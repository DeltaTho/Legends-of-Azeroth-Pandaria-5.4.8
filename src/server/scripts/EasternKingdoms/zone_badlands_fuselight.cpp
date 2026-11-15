/*
 * Badlands: Fuselight events
 *  - Troggish Troubles 27789: the Blam Turrets 46707 and their four trogg waves
 *
 * Research: research\badlands\dossiers\fuselight.md (27789 and its "Second pass" 1; 27762 F-27762-1 and "Second pass" 2),
 * plan section D. What is sourced and what is ours is said at each script.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "Vehicle.h"
#include "CombatAI.h"
#include "Group.h"
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

            // R4: a bot never runs the waves (they credit their master's group instead)
            if (player->GetSession()->IsBot())
            {
                player->ExitVehicle();
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
    GuidVector _troggs;
    uint8 _wave = 0;
    uint8 _burst = 0;
};

void AddSC_badlands_fuselight()
{
    new creature_script<npc_badlands_blam_turret>("npc_badlands_blam_turret");
}
