/*
 * Badlands: Fuselight events
 *  - Troggish Troubles 27789: the Blam Turrets 46707 and their four trogg waves
 *  - Fuselight, Ho! 27762: The Uncrashable, the rocket ride from Light's Hope Chapel to Fuselight-by-the-Sea
 *
 * Research: research\badlands\dossiers\fuselight.md (27789 and its "Second pass" 1; 27762 F-27762-1 and "Second pass" 2),
 * plan section D. What is sourced and what is ours is said at each script.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "SpellScript.h"
#include "SmartScriptMgr.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "MotionMaster.h"
#include "CombatAI.h"
#include "Group.h"
#include "Map.h"
#include "MapManager.h"
#include "DBCStores.h"
#include "WorldSession.h"

// ---------------------------------------------------------------------------------------------------------------------------
// Troggish Troubles 27789
// ---------------------------------------------------------------------------------------------------------------------------

enum TroggishTroubles
{
    QUEST_TROGGISH_TROUBLES         = 27789,

    NPC_STONEVAULT_RUFFIAN          = 46711,
    NPC_STONEVAULT_GOON             = 46712,
    NPC_TROGG_WAVE_1_CREDIT         = 46737,   // 46738 / 46739 / 46740 for waves 2-4

    SPELL_SUMMON_RUFFIAN            = 87029,   // Troggish Troubles: Summon Ruffian (Random), within 50 yd of the turret
    SPELL_SUMMON_GOON               = 87031,   // Troggish Troubles: Summon Goon (Random)

    EVENT_TURRET_WAVE_START         = 1,
    EVENT_TURRET_BURST              = 2,
    EVENT_TURRET_WAVE_END           = 3,
};

struct TroggWave
{
    uint8 Bursts;
    uint32 BurstInterval;   // ms, first burst at the wave's start
    uint8 Ruffians;         // per burst
    uint8 Goons;            // per burst
    uint32 Length;          // ms from the wave's start to its end (credit, leftovers vanish)
};

// Sourced bounds (dossier fuselight, Second pass 1.1/1.2): four waves, each bigger, about 2 minutes in all, the fourth shorter
// than one 30 s Power Burst cooldown, up to ~20 troggs at once, leftovers despawn when a wave ends. The counts and timings are
// ours (plan D-2 table); wave 4's bursts come every 5 s instead of 8 so its last burst is not removed a second after it spawns.
static TroggWave const TroggWaves[4] =
{
    { 3, 8000, 1, 1, 30000 },   //  6 troggs
    { 3, 8000, 2, 1, 30000 },   //  9
    { 4, 8000, 2, 1, 32000 },   // 12
    { 4, 5000, 3, 2, 25000 },   // 20
};

static uint32 const TurretFirstWaveDelay = 5000;   // as the old SmartAI's first burst
static uint32 const TurretWaveGap        = 5000;   // ours: a breath between waves
static float  const TurretBotCreditRange = 40.0f;  // plan header rule 2 / R4 (amended): bot group members beside the rider

// 46707 - Blam Turret (vehicle 1214, one seat 8832: CAN_CONTROL | CAN_ENTER_OR_EXIT; boarded by spellclick 46598)
// What the player sees (sourced, quest text, wiki and comments of 27789): he mans a free turret and turns it with the mouse;
// button 1 shoots ahead (87030), button 2 is the electrical overload (87034 Power Burst, 30 s); troggs come from all sides in
// four growing waves, the small ones die in one shot, the big ones in two; each wave survived is an objective; when a wave
// ends its leftovers vanish; after the fourth he is thrown off the turret. If the troggs destroy the turret he is put down and
// tries again on another one.
// Ours: the wave table above; a run that is interrupted (rider leaves, logs out, turret destroyed) removes this turret's troggs
// at once and restarts at wave 1 on the next boarding (earned objectives stay); bots never man a turret (R4 guard), and bot
// group members within 40 yd of the rider holding the quest get each wave's credit with him. Only this turret's own troggs are
// removed (tracked by GUID), so a neighbour's fight is never touched.
// The turret stays where it is when the rider leaves (won, stepped off, logged out), clickable and repaired, so he can retry at
// once ("you do all the waves sitting in the same turret"; comments of players retrying many times). The core's vehicle
// dismissal (VehicleAIBase::OnCharmed: spellclick flag removed, hidden and despawned after 5 s) is not used: its respawn wrote
// back the template npcflag 0 and every use cost one of the five turrets until a restart. A destroyed turret respawns after
// 300 s with the spellclick flag of its template (2026_11_20_41). Ours: the repair to full health on leaving.
struct npc_badlands_blam_turret : public VehicleAI
{
    npc_badlands_blam_turret(Creature* creature) : VehicleAI(creature) { }

    void PassengerBoarded(Unit* who, int8 /*seatId*/, bool apply) override
    {
        if (apply)
        {
            Player* player = who->ToPlayer();
            if (!player)
                return;

            // R4: a bot never runs the waves (bots get the waves of a real rider beside them). Put off on the next update, not
            // from inside Vehicle::AddPassenger.
            if (player->GetSession()->IsBot())
            {
                _botGUID = player->GetGUID();
                return;
            }

            Stop();
            _riderGUID = player->GetGUID();
            me->SetControlled(true, UNIT_STATE_ROOT);
            _wave = 0;
            _events.ScheduleEvent(EVENT_TURRET_WAVE_START, Milliseconds(TurretFirstWaveDelay));
            return;
        }

        if (who->GetGUID() == _riderGUID)
        {
            Stop();
            me->SetControlled(false, UNIT_STATE_ROOT);
        }
    }

    void JustSummoned(Creature* summon) override
    {
        if (summon->GetEntry() == NPC_STONEVAULT_RUFFIAN || summon->GetEntry() == NPC_STONEVAULT_GOON)
            _troggs.push_back(summon->GetGUID());
    }

    void JustDied(Unit* /*killer*/) override
    {
        Stop();
    }

    // Replaces VehicleAIBase's dismissal (see above). Runs after the passenger is removed (Vehicle::RemovePassenger ->
    // Unit::RemoveCharmedBy), which also gives the turret its own faction back.
    void OnCharmed(bool apply) override
    {
        if (apply || !me->IsAlive())
            return;

        me->CombatStop(true);
        me->SetFullHealth();
        me->SetFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);
    }

    Player* GetRider() const
    {
        Player* player = ObjectAccessor::GetPlayer(*me, _riderGUID);
        if (player && player->GetVehicleBase() == me)
            return player;
        return nullptr;
    }

    void DespawnTroggs()
    {
        for (ObjectGuid const& guid : _troggs)
            if (Creature* trogg = ObjectAccessor::GetCreature(*me, guid))
                trogg->DespawnOrUnsummon();
        _troggs.clear();
    }

    void Stop()
    {
        _events.Reset();
        DespawnTroggs();
        _riderGUID.Clear();
        _wave = 0;
    }

    void Burst()
    {
        TroggWave const& wave = TroggWaves[_wave];
        for (uint8 i = 0; i < wave.Ruffians; ++i)
            me->CastSpell(me, SPELL_SUMMON_RUFFIAN, true);
        for (uint8 i = 0; i < wave.Goons; ++i)
            me->CastSpell(me, SPELL_SUMMON_GOON, true);

        if (++_burst < wave.Bursts)
            _events.ScheduleEvent(EVENT_TURRET_BURST, Milliseconds(wave.BurstInterval));
    }

    void Credit(Player* rider)
    {
        uint32 const credit = NPC_TROGG_WAVE_1_CREDIT + _wave;
        rider->KilledMonsterCredit(credit);

        // R4 (amended by the user): bot group members beside the rider get the wave too; other real players play it themselves
        if (Group* group = rider->GetGroup())
            for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
            {
                Player* member = ref->GetSource();
                if (!member || member == rider || !member->GetSession()->IsBot() || !member->IsInMap(rider) || !member->IsAlive()
                    || member->GetDistance(rider) > TurretBotCreditRange)
                    continue;
                if (member->GetQuestStatus(QUEST_TROGGISH_TROUBLES) == QUEST_STATUS_INCOMPLETE)
                    member->KilledMonsterCredit(credit);
            }
    }

    void UpdateAI(uint32 diff) override
    {
        VehicleAI::UpdateAI(diff);

        if (!_botGUID.IsEmpty())
        {
            if (Player* bot = ObjectAccessor::GetPlayer(*me, _botGUID))
                if (bot->GetVehicleBase() == me)
                    bot->ExitVehicle();
            _botGUID.Clear();
        }

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_TURRET_WAVE_START:
                    if (!GetRider())
                    {
                        Stop();
                        return;
                    }
                    _burst = 0;
                    Burst();
                    _events.ScheduleEvent(EVENT_TURRET_WAVE_END, Milliseconds(TroggWaves[_wave].Length));
                    break;
                case EVENT_TURRET_BURST:
                    Burst();
                    break;
                case EVENT_TURRET_WAVE_END:
                {
                    Player* rider = GetRider();
                    DespawnTroggs();
                    if (!rider)
                    {
                        Stop();
                        return;
                    }
                    Credit(rider);
                    if (++_wave < 4)
                    {
                        _events.ScheduleEvent(EVENT_TURRET_WAVE_START, Milliseconds(TurretWaveGap));
                        break;
                    }
                    // "thrown off the gun with a complete": PassengerBoarded(false) stops the run and unroots
                    TC_LOG_DEBUG("scripts", "npc_badlands_blam_turret: %s survived the four waves", rider->GetName().c_str());
                    rider->ExitVehicle();
                    return;
                }
                default:
                    break;
            }
        }
    }

private:
    EventMap _events;
    ObjectGuid _riderGUID;
    ObjectGuid _botGUID;
    GuidVector _troggs;
    uint8 _wave = 0;
    uint8 _burst = 0;
};

// ---------------------------------------------------------------------------------------------------------------------------
// Fuselight, Ho! 27762: The Uncrashable
// ---------------------------------------------------------------------------------------------------------------------------

enum Uncrashable
{
    QUEST_FUSELIGHT_HO              = 27762,
    NPC_UNCRASHABLE_ROCKET          = 48766,   // the flying rocket (vehicle 1364, ours)
    NPC_GOBBY_NOZZLEROCKET          = 48837,   // the pilot, accessory in seat 0

    SPELL_ROCKET_RIDE_TO_BADLANDS   = 87956,   // SUMMON 48766, SummonProperties 161 (vehicle), 900 s
    SPELL_RIDE_VEHICLE_HARDCODED    = 46598,
    SPELL_ROCKET_TRAIL              = 96840,   // cosmetic, as the Silver Bullet X-831 (ours here)

    ROCKET_PASSENGER_SEAT           = 1,       // seat 9199: no exit, not selectable (sourced: "you cannot exit")

    ZONE_BADLANDS                   = 3,

    EVENT_ROCKET_BOARD_CHECK        = 1,
    EVENT_ROCKET_START              = 2,
    EVENT_ROCKET_CHECK              = 3,
    EVENT_ROCKET_TIMEOUT            = 4,
    EVENT_ROCKET_LANDED             = 5,

    POINT_ROCKET_STEP               = 1,
};

// Ours: the launch spot, 4.4 yd from the sniffed The Uncrashable 173981, open sky above (the west gate's walls rise to z 104
// north of it), and the landing spot, 3.5 yd from Eddie Flofizzle (sniffed 316466) on open ground by the dock.
static Position const RocketLaunchPos  = { 2274.5f, -5262.5f, 81.55f, 2.4f };
static Position const RocketLandingPos = { -6648.4f, -4745.0f, 8.1f, 2.0f };

static float const RocketRateLift      = 2.0f;    // x 7 yd/s: the climb from the gate and the touch-down
static float const RocketRateLand      = 2.5f;
static float const RocketRateCruise1   = 4.17f;   // "about 417 %" until the first zone border (LATE 2025 [+1] measured)
static float const RocketRateCruise2   = 5.55f;   // "then about 555 %"
static float const RocketRateBurst     = 7.0f;    // "peaks of ~700 %": a burst after each zone border and downhill in the Badlands

// The route as `waypoints` entry 48766 (ours, every point checked against the terrain and models). Used by the rocket and by
// the login check below.
static WPPath const* GetRocketPath()
{
    WPPath const* path = sSmartWaypointMgr->GetPath(NPC_UNCRASHABLE_ROCKET);
    return path && !path->empty() ? path : nullptr;
}

static std::vector<Position> GetRocketRoute()
{
    std::vector<Position> points;
    if (WPPath const* path = GetRocketPath())
        for (uint32 id = 1; id <= path->size(); ++id)
        {
            auto itr = path->find(id);
            if (itr == path->end())
                break;
            points.emplace_back(itr->second->x, itr->second->y, itr->second->z);
        }
    return points;
}

// Puts a player who is no longer on the rocket but still in the air down at the landing spot: gravity held while the exit
// spline plays, the teleport 300 ms later, gravity given back twice (the camera-scene pattern of zone_hillsbrad_sludge_stormpike:
// a teleport in the same tick as the exit leaves the client stuck, and the client's own movement packets can clear the first
// gravity enable). The ride is one way, so the set-down is where it would have ended.
static void SetDownAtLanding(Player* player)
{
    player->SetDisableGravity(true);
    player->m_Events.AddLambdaEventAtOffset([player]()
    {
        if (!player->IsInWorld() || player->GetVehicle() || player->GetMapId() != 0)
            return;

        player->NearTeleportTo(RocketLandingPos.GetPositionX(), RocketLandingPos.GetPositionY(), RocketLandingPos.GetPositionZ(), RocketLandingPos.GetOrientation());
        for (uint32 delay : { 100, 1500 })
            player->m_Events.AddLambdaEventAtOffset([player]()
            {
                if (!player->IsInWorld() || player->GetVehicle() || player->IsInFlight() || player->HasAuraType(SPELL_AURA_FLY)
                    || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
                    return;
                if (!player->SetDisableGravity(false))
                    player->SetDisableGravity(false, true);
            }, delay);
    }, 300);
}

// 87956 - Rocket Ride to Badlands (cast by the clicker of The Uncrashable 48708 at Light's Hope Chapel, D-5)
// The default vehicle summon boards the caster on "any free seat", and the rocket's only free seat that allows entering is the
// pilot's: with Gobby installed the board fails and leaves a stray ride aura; without him the player would take the controls.
// So the rocket is summoned here and the player put in the passenger seat by name (seat 1, which cannot be left). R4: no rocket
// for a bot (bots reach Eddie by following their master; the quest is complete on accept).
class spell_badlands_rocket_ride_to_badlands : public SpellScript
{
    PrepareSpellScript(spell_badlands_rocket_ride_to_badlands);

    void HandleSummon(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);

        Player* player = GetCaster() ? GetCaster()->ToPlayer() : nullptr;
        if (!player || !player->IsAlive() || player->GetVehicle() || player->GetSession()->IsBot())
            return;

        Position pos = player->GetPosition();
        if (player->GetMapId() == 0 && player->GetExactDist(&RocketLaunchPos) < 30.0f)
            pos = RocketLaunchPos;

        SummonPropertiesEntry const* properties = sSummonPropertiesStore.LookupEntry(GetSpellInfo()->Effects[effIndex].MiscValueB);
        int32 duration = GetSpellInfo()->GetDuration();
        TempSummon* rocket = player->GetMap()->SummonCreature(NPC_UNCRASHABLE_ROCKET, pos, properties,
            Milliseconds(duration > 0 ? duration : 900000), player, GetSpellInfo()->Id);
        if (!rocket || !rocket->GetVehicleKit())
        {
            TC_LOG_ERROR("scripts", "spell_badlands_rocket_ride_to_badlands: could not summon the rocket for %s", player->GetName().c_str());
            if (rocket)
                rocket->DespawnOrUnsummon();
            return;
        }

        // The aura's amount is the seat + 1 (AuraEffect::HandleAuraControlVehicle)
        player->CastCustomSpell(SPELL_RIDE_VEHICLE_HARDCODED, SPELLVALUE_BASE_POINT0, ROCKET_PASSENGER_SEAT + 1, rocket, true);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_badlands_rocket_ride_to_badlands::HandleSummon, EFFECT_0, SPELL_EFFECT_SUMMON);
    }
};

// 48766 - The Uncrashable (the flying rocket)
// What the player sees (sourced, comments of 27762 / 48708 / 48766 / 48837 and the wiki): the rocket appears beside The
// Uncrashable with Gobby Nozzlerocket at the controls; he sits behind and cannot get off; it lifts off over the walls of Light's
// Hope and flies south for about five minutes over the Hinterlands, the Arathi Highlands, the Wetlands (not over the Twilight
// Highlands), Loch Modan and the gorge into the Badlands, speeding up in bursts between zones, every area flown over is
// discovered, and it sets him down by Eddie Flofizzle at Fuselight-by-the-Sea. Nobody can shoot it down. Abandoning the quest
// on the way changes nothing. One way.
// Ours: the route (69 points, legs <= 200 yd, 75+ yd above the terrain and clear of every model along the way), the speeds per
// leg (rates above), the landing spot, and the early ends: should the ride end before Fuselight (the rocket expires or fails,
// a GM moves the rider) a rider still in the air is set down at the landing spot; a rider who logs out in flight comes back at
// the landing spot (player_badlands_uncrashable below). Driven point by point (MovePoint per leg), never one long spline
// (archetypes "Vehicles": a linear path past ~256 yd from its middle is drawn elsewhere by the client).
struct npc_badlands_uncrashable_rocket : public ScriptedAI
{
    npc_badlands_uncrashable_rocket(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (summoner->GetTypeId() != TYPEID_PLAYER)
        {
            me->DespawnOrUnsummon();
            return;
        }

        _playerGUID = summoner->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->setActive(true, ActiveFlags::Script);   // 11 000 yd across many grids: keep them loaded around the rocket

        _events.Reset();
        _events.ScheduleEvent(EVENT_ROCKET_BOARD_CHECK, 1s);
        _events.ScheduleEvent(EVENT_ROCKET_START, 2s);
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    Player* GetRider() const
    {
        return ObjectAccessor::GetPlayer(*me, _playerGUID);
    }

    bool IsRiding(Player* player) const
    {
        return player && player->GetVehicleBase() == me;
    }

    void Start()
    {
        _route = GetRocketRoute();
        if (_route.empty())
        {
            TC_LOG_ERROR("scripts", "npc_badlands_uncrashable_rocket: no `waypoints` path %u", NPC_UNCRASHABLE_ROCKET);
            End(false);
            return;
        }

        me->SetCanFly(true);
        me->SetDisableGravity(true);
        DoCast(me, SPELL_ROCKET_TRAIL, true);

        _next = 0;
        _lastZone = ZoneOf(0);
        _bordersSeen = 0;
        _burstLegs = 0;
        MoveNext();

        // Failsafe: should a leg never report its end, the ride ends 30 s after it should have arrived (slowest rate)
        float length = 0.0f;
        Position prev = me->GetPosition();
        for (Position const& pos : _route)
        {
            length += prev.GetExactDist(&pos);
            prev = pos;
        }
        _events.ScheduleEvent(EVENT_ROCKET_TIMEOUT, Milliseconds(uint32(length / (RocketRateCruise1 * 7.0f) * IN_MILLISECONDS) + 30 * IN_MILLISECONDS));
    }

    // The zone of a point is read when the rocket sets out for it (its grid is loaded around the rocket by then)
    uint32 ZoneOf(size_t index) const
    {
        Position const& pos = _route[index];
        return me->GetMap()->GetZoneId(me->GetPhaseMask(), pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ());
    }

    float RateFor(size_t index)
    {
        uint32 const zone = ZoneOf(index);
        if (index > 0 && zone != _lastZone)
        {
            ++_bordersSeen;
            _burstLegs = 2;
        }
        _lastZone = zone;

        if (index < 2)
            return RocketRateLift;
        if (index + 2 >= _route.size())
            return RocketRateLand;
        if (_burstLegs)
        {
            --_burstLegs;
            return RocketRateBurst;
        }
        if (zone == ZONE_BADLANDS && index + 6 < _route.size() && _route[index].GetPositionZ() < _route[index - 1].GetPositionZ())
            return RocketRateBurst;
        return _bordersSeen ? RocketRateCruise2 : RocketRateCruise1;
    }

    void MoveNext()
    {
        if (_next >= _route.size())
        {
            _arrived = true;
            _events.ScheduleEvent(EVENT_ROCKET_LANDED, 1s);
            return;
        }

        float const rate = RateFor(_next);
        me->SetSpeed(MOVE_RUN, rate);
        me->SetSpeed(MOVE_FLIGHT, rate);
        me->GetMotionMaster()->MovePoint(POINT_ROCKET_STEP, _route[_next].GetPositionX(), _route[_next].GetPositionY(), _route[_next].GetPositionZ(), false);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == POINT_MOTION_TYPE && id == POINT_ROCKET_STEP && !_ended && !_arrived)
        {
            ++_next;
            MoveNext();
        }
    }

    // Landed (the rider steps off by Eddie) or ended early (a rider still in the air is set down at the landing spot). The rocket
    // and its pilot go at once either way.
    void End(bool landed, bool despawnSelf = true)
    {
        if (_ended)
            return;
        _ended = true;
        _events.Reset();

        // A rider logging out is not set down here: he is saved where he is and moved at his next login (player_badlands_uncrashable)
        if (Player* player = GetRider())
        {
            // Unit::ExitVehicle ignores a position: the exit spline ends at the rocket, which stands on the last waypoint, the
            // landing spot (`waypoints` 48766 point 69 = RocketLandingPos, 0.5 yd above the ground)
            if (landed && IsRiding(player))
                player->ExitVehicle();
            else if (player->IsInWorld() && player->IsAlive() && player->GetMapId() == me->GetMapId() && !player->GetSession()->PlayerLogout())
            {
                bool const riding = IsRiding(player);
                if (riding)
                    player->ExitVehicle();
                float const ground = me->GetMap()->GetHeight(player->GetPhaseMask(), player->GetPositionX(), player->GetPositionY(), player->GetPositionZ(), true, 1000.0f);
                if ((riding || player->GetPositionZ() > ground + 10.0f) && player->GetPositionZ() > ground + 5.0f && !player->IsInFlight()
                    && !player->HasAuraType(SPELL_AURA_FLY) && !player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
                {
                    TC_LOG_DEBUG("scripts", "npc_badlands_uncrashable_rocket: ride of %s ended early at %.1f %.1f %.1f, setting down at the landing spot",
                        player->GetName().c_str(), player->GetPositionX(), player->GetPositionY(), player->GetPositionZ());
                    SetDownAtLanding(player);
                }
            }
        }

        if (Vehicle* kit = me->GetVehicleKit())
            for (int8 seat = 0; seat < 2; ++seat)
                if (Unit* passenger = kit->GetPassenger(seat))
                    if (passenger->GetTypeId() == TYPEID_UNIT && passenger->IsSummon())
                        passenger->ToTempSummon()->UnSummon();
        if (despawnSelf)
            me->DespawnOrUnsummon();
    }

    // The 900 s summon running out (or any other unsummon) with the rider aboard: set him down first
    void Unsummoned() override
    {
        if (!_ended)
            End(false, false);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_ended)
            return;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_ROCKET_BOARD_CHECK:
                    if (!IsRiding(GetRider()))
                    {
                        TC_LOG_ERROR("scripts", "npc_badlands_uncrashable_rocket: the rider did not board");
                        End(false);
                        return;
                    }
                    _boarded = true;
                    _events.ScheduleEvent(EVENT_ROCKET_CHECK, 500ms);
                    break;
                case EVENT_ROCKET_START:
                    Start();
                    break;
                case EVENT_ROCKET_CHECK:
                {
                    Player* player = GetRider();
                    if (!player || !player->IsInWorld() || !player->IsAlive() || (_boarded && !IsRiding(player)))
                    {
                        End(false);
                        return;
                    }
                    _events.ScheduleEvent(EVENT_ROCKET_CHECK, 500ms);
                    break;
                }
                case EVENT_ROCKET_TIMEOUT:
                    TC_LOG_ERROR("scripts", "npc_badlands_uncrashable_rocket: the ride did not reach Fuselight in time");
                    End(false);
                    return;
                case EVENT_ROCKET_LANDED:
                    End(true);
                    return;
                default:
                    break;
            }
            if (_ended)
                return;
        }
    }

private:
    ObjectGuid _playerGUID;
    EventMap _events;
    std::vector<Position> _route;
    uint32 _lastZone = 0;
    size_t _next = 0;
    uint32 _bordersSeen = 0;
    uint32 _burstLegs = 0;
    bool _boarded = false;
    bool _arrived = false;
    bool _ended = false;
};

// A rider who logged out in flight is saved where the rocket was, high in the air (his summons go with him), and would fall
// to his death at the next login. Before he enters the world, a player is moved to the landing spot only when all of these
// hold: Fuselight, Ho! in his log (only then can he have been a passenger; a rider who abandoned it on the way is not caught
// and falls, as anyone saved in the air would); map 0; at least 25 yd above the ground or water below him (vmaps counted, so a bridge or roof is ground); within 40 yd
// of the rocket's flight path (launch spot to the last point); no mount or flight aura. A player standing, swimming or riding
// anywhere cannot match: only someone saved in mid-air on the rocket's path does. A saved marker was considered and not used:
// the core never saves a control-vehicle aura (Aura::CanBeSaved), and a marker spell of our own would need new spell data.
// A rider who logged out on the last 25 yd of the descent falls at most that far. Ours (no source says what retail did).
class player_badlands_uncrashable : public PlayerScript
{
public:
    player_badlands_uncrashable() : PlayerScript("player_badlands_uncrashable") { }

    static float DistToSegment(Position const& p, Position const& a, Position const& b)
    {
        float const dx = b.GetPositionX() - a.GetPositionX(), dy = b.GetPositionY() - a.GetPositionY(), dz = b.GetPositionZ() - a.GetPositionZ();
        float const len2 = dx * dx + dy * dy + dz * dz;
        float t = 0.0f;
        if (len2 > 0.0f)
            t = std::max(0.0f, std::min(1.0f, ((p.GetPositionX() - a.GetPositionX()) * dx + (p.GetPositionY() - a.GetPositionY()) * dy + (p.GetPositionZ() - a.GetPositionZ()) * dz) / len2));
        Position const q(a.GetPositionX() + dx * t, a.GetPositionY() + dy * t, a.GetPositionZ() + dz * t);
        return p.GetExactDist(&q);
    }

    void OnLoadFromDB(Player* player) override
    {
        QuestStatus const status = player->GetQuestStatus(QUEST_FUSELIGHT_HO);
        if (status != QUEST_STATUS_INCOMPLETE && status != QUEST_STATUS_COMPLETE)
            return;

        if (player->GetMapId() != 0 || player->HasAuraType(SPELL_AURA_MOUNTED) || player->HasAuraType(SPELL_AURA_FLY)
            || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
            return;

        std::vector<Position> route = GetRocketRoute();
        if (route.empty())
            return;
        route.insert(route.begin(), RocketLaunchPos);

        Position const pos = player->GetPosition();
        bool onPath = false;
        for (size_t i = 0; i + 1 < route.size() && !onPath; ++i)
            onPath = DistToSegment(pos, route[i], route[i + 1]) <= 40.0f;
        if (!onPath)
            return;

        Map* map = sMapMgr->FindBaseNonInstanceMap(0);
        if (!map)
            return;
        float const below = map->GetWaterOrGroundLevel(PHASEMASK_NORMAL, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ());
        if (pos.GetPositionZ() < below + 25.0f)
            return;

        TC_LOG_DEBUG("scripts", "player_badlands_uncrashable: %s logged in on the rocket's path at %.1f %.1f %.1f (%.1f yd up), moved to the landing spot",
            player->GetName().c_str(), pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), pos.GetPositionZ() - below);
        player->Relocate(RocketLandingPos);
        player->SetFallInformation(0, RocketLandingPos.GetPositionZ());
    }
};

void AddSC_badlands_fuselight()
{
    new creature_script<npc_badlands_blam_turret>("npc_badlands_blam_turret");
    new spell_script<spell_badlands_rocket_ride_to_badlands>("spell_badlands_rocket_ride_to_badlands");
    new creature_script<npc_badlands_uncrashable_rocket>("npc_badlands_uncrashable_rocket");
    new player_badlands_uncrashable();
}
