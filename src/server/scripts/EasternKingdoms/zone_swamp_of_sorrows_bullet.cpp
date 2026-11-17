/*
 * Swamp of Sorrows: The Bogpaddle Bullet, the rocket from Sharon Boomgetter's launch rig in the south-east corner of the Burning
 * Steppes down to Bogpaddle (The Bogpaddle Bullet 28569 / 28570 send the player to her; anyone may ride).
 *
 * Research: research\swamp-of-sorrows\dossiers\S1-bogpaddle.md section 2 (F-ROCKET) and its "Gate pass 1 changes" G1, plan
 * section F (F-01 .. F-05). The pattern is the Badlands rocket of zone_badlands_fuselight.cpp (The Uncrashable, as built and as
 * fixed after its smoke test: the player is seated first, the pilot after him), copied here rather than shared, because the
 * Badlands file is in its own test loop. What is sourced and what is ours is said at each script.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "MotionMaster.h"
#include "Map.h"
#include "MapManager.h"
#include "DBCStores.h"
#include "WorldSession.h"

enum BogpaddleBullet
{
    NPC_BOGPADDLE_BULLET            = 48324,   // the flying rocket (vehicle 1364)
    NPC_HIGS_BLASTSCORCH            = 48990,   // the pilot (wiki), seat 0
    NPC_TRADE_BARON_SILVERSNAP      = 45786,   // ender of 28569 / 28570, beside the landing spot

    MENU_SHARON_BOOMGETTER          = 12464,
    OPTION_SHARON_RIDE              = 0,       // "Alright!  Let's head down to the Swamp of Sorrows!" (BT 49049, both TDBs)

    SUMMON_PROPERTIES_BULLET        = 161,     // vehicle category, as The Uncrashable's 87956 (the rocket is the rider's Minion)
    BULLET_SUMMON_DURATION          = 600,     // s; the ride takes about 70 s

    SPELL_BULLET_RIDE_HARDCODED     = 46598,   // Ride Vehicle Hardcoded, BP0 = seat + 1
    SPELL_BULLET_ROCKET_TRAIL       = 96840,   // Rocket Trail (cosmetic, as the Silver Bullet X-831 and The Uncrashable; ours here)
    SPELL_BULLET_LOOP_SOUND         = 97203,   // Silver Bullet X-831 Rocket Loop Sound (mop's old spellclick row of 48324)

    BULLET_PILOT_SEAT               = 0,       // seat 9198: enterable, not selectable
    BULLET_PASSENGER_SEAT           = 1,       // seat 9199: no exit, no control, no cast, passenger not selectable

    EVENT_BULLET_BOARD_CHECK        = 1,
    EVENT_BULLET_START              = 2,
    EVENT_BULLET_CHECK              = 3,
    EVENT_BULLET_TIMEOUT            = 4,
    EVENT_BULLET_LANDED             = 5,

    POINT_BULLET_STEP               = 1,
};

// ---------------------------------------------------------------------------------------------------------------------------
// The flight (all of it ours: no source gives the route, the duration or the landing; plan question 5).
//
// Built to the dossier's constraint (S1 G1): every point on or east of the ridge crest east of the Redridge valleys, at least
// 100 yd from every Galardell Valley / Stonewatch / Shalewind Canyon spawn (the nearest Redridge spawn is 322 yd from the path),
// at least 75 yd above the terrain (liquid counted) on every cruise leg, down over the sea off the Shalewind headland and Misty
// Reed Strand, never over Shalewind Canyon, landing 3.5 yd from Trade Baron Silversnap on open ground. Every leg is 200 yd or
// shorter and driven as its own MovePoint (archetypes "A long road is not one spline"). Checked against the 5.4.8 maps and
// vmaps (research\swamp-of-sorrows\tmp\coder-f\final.py and vcheck.py; the table with every point is in coders\f.md).
//
// Rate = the speed of the leg that ends at the point, as a multiple of 7 yd/s. The default (question 5: "about 60-70 s along the
// ridge east of Redridge, landing beside Silversnap"): about 2240 yd flown, 67 s in the air, plus 2 s boarding and 1.5 s at the
// landing. To change it: a longer or shorter ride = scale the 5.55 / 5.0 rates (4.17 everywhere gives about 83 s); a route over
// the Redridge valley = replace points 6-12 (the dossier's constraint would then no longer hold); another landing = the last
// point and BulletLandingPos together (and the descent points 16-18 if it is not on the north side of the town).
// ---------------------------------------------------------------------------------------------------------------------------
struct BulletRoutePoint
{
    float X, Y, Z;
    float Rate;
};

static BulletRoutePoint const BulletRoute[] =
{
    //      x          y         z      rate        ground below, height above it (yd)
    { -8223.00f, -2935.00f, 215.00f, 2.00f },   //  1 straight up from the launch spot                 152 / 63
    { -8255.00f, -2970.00f, 300.00f, 3.00f },   //  2 climbing out of Sharon's corner                  169 / 131
    { -8320.00f, -3040.00f, 401.00f, 5.55f },   //  3 over the Terror Wing Path                        234 / 167
    { -8420.00f, -3150.00f, 402.50f, 5.55f },   //  4 the border peaks                                 297 / 105
    { -8560.00f, -3290.00f, 402.50f, 5.55f },   //  5 last of the Burning Steppes                      217 / 186
    { -8700.00f, -3420.00f, 395.00f, 5.55f },   //  6 Redridge Mountains, the eastern ridge            98 / 297
    { -8775.00f, -3490.00f, 388.00f, 5.55f },   //  7                                                  157 / 231
    { -8850.00f, -3560.00f, 385.00f, 5.55f },   //  8                                                  239 / 146
    { -8925.00f, -3630.00f, 378.00f, 5.55f },   //  9 east of the crest                                252 / 126
    { -9000.00f, -3700.00f, 372.00f, 5.55f },   // 10                                                  206 / 166
    { -9130.00f, -3810.00f, 372.00f, 5.55f },   // 11 east flank, above the coast                      177 / 195
    { -9250.00f, -3930.00f, 301.50f, 5.55f },   // 12 the shore (Galardell Valley 493 yd west)          12 / 289
    { -9340.00f, -3995.00f, 240.00f, 5.00f },   // 13 over the sea, round the Shalewind headland          0 / 240
    { -9450.00f, -3970.00f, 180.00f, 5.00f },   // 14 The Forbidding Sea                                  0 / 180
    { -9550.00f, -3928.00f, 120.00f, 5.00f },   // 15 Misty Reed Strand                                   2 / 118
    { -9640.00f, -3907.00f,  75.00f, 5.00f },   // 16 Misty Reed Strand                                   0 / 75
    { -9700.00f, -3905.00f,  48.00f, 5.00f },   // 17 the north edge of Bogpaddle                         6 / 42
    { -9750.00f, -3905.00f,  38.00f, 2.50f },   // 18 over the street, 9 yd above the nearest roof        22 / 16
    { -9783.74f, -3912.94f,  22.15f, 2.50f },   // 19 = BulletLandingPos                                 21.65 / 0.5
};

// Ours: the launch spot 3.7 yd from Sharon (sniffed 165434) and from the static rocket (sniffed 165442), open ground, nothing
// overhead (the pipe rig tops out 3 yd above the ground, 4-7 yd to the west); the landing spot 3.5 yd in front of Trade Baron
// Silversnap (sniffed 165161, facing 1.29), on the ground of the street (21.65, no liquid, no model overhead), between his two
// Bogpaddle Bruisers (4.9 / 5.0 yd). The player is turned to face him before he is set down.
static Position const BulletLaunchPos     = { -8223.00f, -2935.00f, 152.40f, 3.97f };
static Position const BulletLandingPos    = { -9783.74f, -3912.94f, 22.15f, 4.43f };
static Position const BulletSilversnapPos = { -9784.71f, -3916.30f, 21.76f, 1.29f };

static std::vector<Position> GetBulletRoute()
{
    std::vector<Position> points;
    for (BulletRoutePoint const& point : BulletRoute)
        points.emplace_back(point.X, point.Y, point.Z);
    return points;
}

static float DistToBulletSegment(Position const& p, Position const& a, Position const& b)
{
    float const dx = b.GetPositionX() - a.GetPositionX(), dy = b.GetPositionY() - a.GetPositionY(), dz = b.GetPositionZ() - a.GetPositionZ();
    float const len2 = dx * dx + dy * dy + dz * dz;
    float t = 0.0f;
    if (len2 > 0.0f)
        t = std::max(0.0f, std::min(1.0f, ((p.GetPositionX() - a.GetPositionX()) * dx + (p.GetPositionY() - a.GetPositionY()) * dy + (p.GetPositionZ() - a.GetPositionZ()) * dz) / len2));
    Position const q(a.GetPositionX() + dx * t, a.GetPositionY() + dy * t, a.GetPositionZ() + dz * t);
    return p.GetExactDist(&q);
}

// Within this distance (3D) of the flight path, launch spot to landing spot
static bool IsNearBulletPath(Position const& pos, float range)
{
    Position prev = BulletLaunchPos;
    for (BulletRoutePoint const& point : BulletRoute)
    {
        Position const next(point.X, point.Y, point.Z);
        if (DistToBulletSegment(pos, prev, next) <= range)
            return true;
        prev = next;
    }
    return false;
}

static void GiveBackGravity(Player* player)
{
    if (!player->IsInWorld() || player->GetVehicle() || player->IsInFlight() || player->HasAuraType(SPELL_AURA_FLY)
        || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
        return;
    if (!player->SetDisableGravity(false))
        player->SetDisableGravity(false, true);
}

// A rider who left the rocket early is set down only while he is still where the rocket took him: on map 0, not being
// teleported (a GM .tele, an accepted summon or a meeting stone exits the vehicle first and relocates him only on the client's
// ack, so for a moment he still stands in the air on the path) and within 60 yd of the flight path. Review round 1, F-m2.
static bool ShouldSetDownAtBogpaddle(Player* player)
{
    return player->IsInWorld() && player->GetMapId() == 0 && !player->IsBeingTeleported()
        && IsNearBulletPath(player->GetPosition(), 60.0f);
}

// Puts a player who is no longer on the rocket but still in the air down at the landing spot: gravity held while the exit
// spline plays, the teleport 300 ms later, gravity given back twice (as zone_badlands_fuselight's SetDownAtLanding, from the
// Hillsbrad camera pattern: a teleport in the tick of the exit leaves the client stuck). The ride is one way, so the set-down
// is where it would have ended. Should he be teleported elsewhere in those 300 ms, he is left there with his gravity back.
static void SetDownAtBogpaddle(Player* player)
{
    player->SetDisableGravity(true);
    player->m_Events.AddLambdaEventAtOffset([player]()
    {
        if (!player->IsInWorld() || player->GetVehicle())
            return;

        if (!ShouldSetDownAtBogpaddle(player))
        {
            GiveBackGravity(player);
            return;
        }

        player->NearTeleportTo(BulletLandingPos.GetPositionX(), BulletLandingPos.GetPositionY(), BulletLandingPos.GetPositionZ(), BulletLandingPos.GetOrientation());
        for (uint32 delay : { 100, 1500 })
            player->m_Events.AddLambdaEventAtOffset([player]() { GiveBackGravity(player); }, delay);
    }, 300);
}

// Summons the rocket for this player at the launch spot and seats him behind the pilot. No rocket for a bot (bots never choose
// gossip on their own; they follow their master or are summoned by him), nor for a player who is dead, in combat, on a taxi or
// already on a vehicle (in combat he gets the client's "You can't do that while in combat", riding a notice).
// Seating order (Badlands fix round 3): the player goes into seat 1 by name first, then the pilot into seat 0. Two ride auras on
// one vehicle stack only while an enterable seat is still free (Aura::CanStackWith, CONTROL_VEHICLE case); seat 1 cannot be
// entered, so a pilot seated first lost his seat the moment the player boarded and was unsummoned 2 s later. The rocket is a
// public Minion of the player (SummonProperties 161), so its pilot is public too and other players see both.
static void StartBulletRide(Player* player)
{
    if (!player || !player->IsInWorld() || player->GetSession()->IsBot() || !player->IsAlive() || player->GetMapId() != 0)
        return;

    // A refusal is told (ours, review round 1: the walk's M8): the client's own red error text for combat, a notice otherwise
    if (player->IsInCombat())
    {
        player->SendGameError(GameError::ERR_NOT_IN_COMBAT);
        return;
    }
    if (player->GetVehicle() || player->IsInFlight())
    {
        player->GetSession()->SendNotification("You can't do that while riding.");
        return;
    }

    Position pos = player->GetPosition();
    if (player->GetExactDist(&BulletLaunchPos) < 30.0f)
        pos = BulletLaunchPos;

    SummonPropertiesEntry const* properties = sSummonPropertiesStore.LookupEntry(SUMMON_PROPERTIES_BULLET);
    TempSummon* rocket = player->GetMap()->SummonCreature(NPC_BOGPADDLE_BULLET, pos, properties, Seconds(BULLET_SUMMON_DURATION), player);
    if (!rocket || !rocket->GetVehicleKit())
    {
        TC_LOG_ERROR("scripts", "zone_swamp_of_sorrows_bullet: could not summon the Bogpaddle Bullet for %s", player->GetName().c_str());
        if (rocket)
            rocket->DespawnOrUnsummon();
        return;
    }

    // The aura's amount is the seat + 1 (AuraEffect::HandleAuraControlVehicle); boarding dismounts him and puts his pet away
    // until he gets off (Unit::_EnterVehicle / _ExitVehicle)
    player->CastCustomSpell(SPELL_BULLET_RIDE_HARDCODED, SPELLVALUE_BASE_POINT0, BULLET_PASSENGER_SEAT + 1, rocket, true);
    if (player->GetVehicleBase() != rocket)
    {
        TC_LOG_ERROR("scripts", "zone_swamp_of_sorrows_bullet: %s could not be seated on the Bogpaddle Bullet", player->GetName().c_str());
        rocket->DespawnOrUnsummon();
        return;
    }

    // Then the pilot (a minion accessory: he goes with the rocket; Vehicle::InstallAccessory boards him through the rocket's
    // spellclick row 48324 / 46598)
    if (Vehicle* kit = rocket->GetVehicleKit())
    {
        if (!kit->GetPassenger(BULLET_PILOT_SEAT))
            kit->InstallAccessory(NPC_HIGS_BLASTSCORCH, BULLET_PILOT_SEAT, true, TEMPSUMMON_MANUAL_DESPAWN, 0);
        if (!kit->GetPassenger(BULLET_PILOT_SEAT))
            TC_LOG_ERROR("scripts", "zone_swamp_of_sorrows_bullet: Higs Blastscorch could not be seated on the Bogpaddle Bullet of %s", player->GetName().c_str());

        // As Vehicle::InstallAllAccessories does: a client that learns of the rocket only now dropped the pilot's boarding move,
        // so his seat is announced again once the rocket has been sent, and once more for a late client
        Unit* base = rocket;
        for (uint32 delay : { 250u, 1500u })
            base->m_Events.AddLambdaEventAtOffset([base]()
            {
                if (Vehicle* vehicle = base->GetVehicleKit())
                    vehicle->AnnouncePassengers();
            }, delay);
    }
}

// 48948 - Sharon Boomgetter (Burning Steppes, the south-east corner; menu 12464)
// What the player sees (sourced: npc_text 17532 "Need a ride, sugar? Hop on. We're headed down to Bogpaddle, and it's a one way
// trip."; option BT 49049 in both TDBs; the quest texts of 28569 / 28570 "Speak with Sharon Boomgetter ... to ride the Bogpaddle
// Bullet"): he picks "Alright! Let's head down to the Swamp of Sorrows!", the menu closes and he is seated on a rocket behind a
// goblin pilot. No quest gate (no condition in either TDB; holders of the capital boards' Hero's Call / Warchief's Command were
// sent to her too, and a 2010 comment warns Bloodsail Admirals off "that rocket").
struct npc_sos_sharon_boomgetter : public ScriptedAI
{
    npc_sos_sharon_boomgetter(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
    {
        if (menuId != MENU_SHARON_BOOMGETTER || gossipListId != OPTION_SHARON_RIDE)
            return false;

        CloseGossipMenuFor(player);
        StartBulletRide(player);
        return true;
    }
};

// 48324 - The Bogpaddle Bullet (the flying rocket)
// What the player sees (sourced: Wowhead screenshots 194456, 194743, 239937 of 48324 / 28569; Sharon's text; the wiki pilot name
// Higs Blastscorch): the rocket appears beside the one parked at Sharon's rig, a blue-suited goblin pilot in front and the player
// behind him; he cannot get off; it lifts off and flies over the mountains with Redridge's autumn forest and a keep with towers
// on one side, and sets him down in Bogpaddle. One way. Nothing credits: 28569 / 28570 are complete on accept.
// Ours: the route and speeds (table above), the landing spot and the turn to face Silversnap, the trail and loop-sound auras,
// and the early ends: should the ride end before Bogpaddle (the rocket expires or fails, a GM moves the rider, he leaves the
// seat in any way) a rider still in the air is set down at the landing spot; a rider who logs out in flight comes back at the
// landing spot (player_sos_bogpaddle_bullet below).
struct npc_sos_bogpaddle_bullet : public ScriptedAI
{
    npc_sos_bogpaddle_bullet(Creature* creature) : ScriptedAI(creature) { }

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
        me->setActive(true, ActiveFlags::Script);   // 2 000 yd across several grids: keep them loaded around the rocket

        _events.Reset();
        _events.ScheduleEvent(EVENT_BULLET_BOARD_CHECK, 1s);
        _events.ScheduleEvent(EVENT_BULLET_START, 2s);
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
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        DoCast(me, SPELL_BULLET_ROCKET_TRAIL, true);
        DoCast(me, SPELL_BULLET_LOOP_SOUND, true);

        _route = GetBulletRoute();
        _next = 0;
        MoveNext();

        // Failsafe: should a leg never report its end, the ride ends 30 s after it should have arrived
        float seconds = 0.0f;
        Position prev = me->GetPosition();
        for (size_t i = 0; i < _route.size(); ++i)
        {
            seconds += prev.GetExactDist(&_route[i]) / (BulletRoute[i].Rate * 7.0f);
            prev = _route[i];
        }
        _events.ScheduleEvent(EVENT_BULLET_TIMEOUT, Milliseconds(uint32(seconds * IN_MILLISECONDS) + 30 * IN_MILLISECONDS));
    }

    void MoveNext()
    {
        if (_next >= _route.size())
        {
            // Landed: turn to Trade Baron Silversnap (the passenger turns with the rocket: Unit::UpdateOrientation relocates the
            // passengers), then the rider is put off facing him
            _arrived = true;
            Position target = BulletSilversnapPos;
            if (Creature* silversnap = me->FindNearestCreature(NPC_TRADE_BARON_SILVERSNAP, 15.0f))
                target = silversnap->GetPosition();
            me->SetFacingTo(me->GetAngle(&target));
            _events.ScheduleEvent(EVENT_BULLET_LANDED, 1500ms);
            return;
        }

        float const rate = BulletRoute[_next].Rate;
        me->SetSpeed(MOVE_RUN, rate);
        me->SetSpeed(MOVE_FLIGHT, rate);
        me->GetMotionMaster()->MovePoint(POINT_BULLET_STEP, _route[_next].GetPositionX(), _route[_next].GetPositionY(), _route[_next].GetPositionZ(), false);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == POINT_MOTION_TYPE && id == POINT_BULLET_STEP && !_ended && !_arrived)
        {
            ++_next;
            MoveNext();
        }
    }

    // Landed (the rider steps off in front of Silversnap) or ended early (a rider still in the air is set down at the landing
    // spot). The rocket and its pilot go at once either way.
    void End(bool landed, bool despawnSelf = true)
    {
        if (_ended)
            return;
        _ended = true;
        _events.Reset();

        // A rider logging out is not set down here: he is saved where he is and moved at his next login (player_sos_bogpaddle_bullet)
        if (Player* player = GetRider())
        {
            // Unit::ExitVehicle ignores a position: the exit spline ends at the rocket, which stands on the last point of the
            // route, the landing spot 0.5 yd above the street
            if (landed && IsRiding(player))
                player->ExitVehicle();
            else if (player->IsInWorld() && player->IsAlive() && player->GetMapId() == me->GetMapId() && !player->GetSession()->PlayerLogout())
            {
                bool const riding = IsRiding(player);
                if (riding)
                    player->ExitVehicle();
                float const ground = me->GetMap()->GetHeight(player->GetPhaseMask(), player->GetPositionX(), player->GetPositionY(), player->GetPositionZ(), true, 1000.0f);
                if (ShouldSetDownAtBogpaddle(player)
                    && (riding || player->GetPositionZ() > ground + 10.0f) && player->GetPositionZ() > ground + 5.0f && !player->IsInFlight()
                    && !player->HasAuraType(SPELL_AURA_FLY) && !player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
                {
                    TC_LOG_DEBUG("scripts", "npc_sos_bogpaddle_bullet: ride of %s ended early at %.1f %.1f %.1f, setting down at Bogpaddle",
                        player->GetName().c_str(), player->GetPositionX(), player->GetPositionY(), player->GetPositionZ());
                    SetDownAtBogpaddle(player);
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

    // The 600 s summon running out (or any other unsummon, e.g. the rider leaving the world) with the rider aboard: set him down
    // first
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
                case EVENT_BULLET_BOARD_CHECK:
                    if (!IsRiding(GetRider()))
                    {
                        TC_LOG_ERROR("scripts", "npc_sos_bogpaddle_bullet: the rider did not board");
                        End(false);
                        return;
                    }
                    _boarded = true;
                    _events.ScheduleEvent(EVENT_BULLET_CHECK, 500ms);
                    break;
                case EVENT_BULLET_START:
                    Start();
                    break;
                case EVENT_BULLET_CHECK:
                {
                    Player* player = GetRider();
                    if (!player || !player->IsInWorld() || !player->IsAlive() || (_boarded && !IsRiding(player)))
                    {
                        End(false);
                        return;
                    }
                    _events.ScheduleEvent(EVENT_BULLET_CHECK, 500ms);
                    break;
                }
                case EVENT_BULLET_TIMEOUT:
                    TC_LOG_ERROR("scripts", "npc_sos_bogpaddle_bullet: the ride did not reach Bogpaddle in time");
                    End(false);
                    return;
                case EVENT_BULLET_LANDED:
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
    size_t _next = 0;
    bool _boarded = false;
    bool _arrived = false;
    bool _ended = false;
};

// A rider who logged out in flight is saved where the rocket was, high in the air (his summons go with him), and would fall at
// the next login. Before he enters the world, a player is moved to the landing spot only when all of these hold: map 0; no
// mount, flight or mounted-flight aura (auras are loaded by then); within 40 yd of the rocket's flight path (launch spot to the
// last point); at least 25 yd above the ground or water below him (vmaps counted, so a roof or a bridge is ground). A player
// standing, swimming, riding or on a taxi (LoadFromDB has put a taxi rider back at his start node) cannot match: only someone
// saved in mid-air on the rocket's path does. Unlike the Badlands rocket no quest is required, as anyone may ride. A rider who
// logged out on the last 25 yd of the descent falls at most that far. Ours (no source says what retail did).
class player_sos_bogpaddle_bullet : public PlayerScript
{
public:
    player_sos_bogpaddle_bullet() : PlayerScript("player_sos_bogpaddle_bullet") { }

    void OnLoadFromDB(Player* player) override
    {
        if (player->GetMapId() != 0 || player->HasAuraType(SPELL_AURA_MOUNTED) || player->HasAuraType(SPELL_AURA_FLY)
            || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
            return;

        // Cheap box test first: the route lies inside x -9790 .. -8215, y -4000 .. -2930
        Position const pos = player->GetPosition();
        if (pos.GetPositionX() < -9830.0f || pos.GetPositionX() > -8175.0f || pos.GetPositionY() < -4040.0f || pos.GetPositionY() > -2890.0f)
            return;

        if (!IsNearBulletPath(pos, 40.0f))
            return;

        Map* map = sMapMgr->FindBaseNonInstanceMap(0);
        if (!map)
            return;
        float const below = map->GetWaterOrGroundLevel(PHASEMASK_NORMAL, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ());
        if (pos.GetPositionZ() < below + 25.0f)
            return;

        TC_LOG_DEBUG("scripts", "player_sos_bogpaddle_bullet: %s logged in on the Bogpaddle Bullet's path at %.1f %.1f %.1f (%.1f yd up), moved to Bogpaddle",
            player->GetName().c_str(), pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), pos.GetPositionZ() - below);
        player->Relocate(BulletLandingPos);
        player->SetFallInformation(0, BulletLandingPos.GetPositionZ());
    }
};

void AddSC_swamp_of_sorrows_bullet()
{
    new creature_script<npc_sos_sharon_boomgetter>("npc_sos_sharon_boomgetter");
    new creature_script<npc_sos_bogpaddle_bullet>("npc_sos_bogpaddle_bullet");
    new player_sos_bogpaddle_bullet();
}
