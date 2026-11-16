/*
 * Searing Gorge: Cauldron events
 *  - Operation: Stir the Cauldron 28052: the Brotherhood Flying Machine 47467, its flight into the Cauldron, the gun at the
 *    landing terrace and the Cauldron Defenders 47470
 *  - Kill 'em With Sleep Deprivation 28057 / Look at the Size of It! 28058: the pillow event (the Sleepy Dark Iron Workers
 *    14635 and Chambermaid Pillaclencher 14636, after the first Dark Iron Pillow 179828 is taken)
 *
 * Research: research\searing-gorge\dossiers\cauldron-finale.md (28052 rows 1-14, F3, SP-4), plan section E (E-4). What is
 * sourced and what is ours is said at each script.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "MotionMaster.h"
#include "CombatAI.h"
#include "CreatureTextMgr.h"
#include "WorldSession.h"
#include "GameObject.h"
#include "GameObjectAI.h"
#include "Map.h"
#include "MapManager.h"

// ---------------------------------------------------------------------------------------------------------------------------
// Operation: Stir the Cauldron 28052
// ---------------------------------------------------------------------------------------------------------------------------

enum StirTheCauldron
{
    QUEST_OPERATION_STIR_THE_CAULDRON   = 28052,
    QUEST_WELCOME_TO_THE_BROTHERHOOD    = 28064,

    NPC_BROTHERHOOD_FLYING_MACHINE      = 47467,   // also the objective's credit entry ("Secure entrance into the Slag Pit")
    NPC_CAULDRON_DEFENDER               = 47470,

    TALK_MACHINE_CLEAR_THE_TERRACE      = 0,       // BroadcastText 47787, RAID_BOSS_WHISPER (the DBC's 88645 "Plane Boss Whisper")

    SEAT_PASSENGER                      = 0,       // VehicleSeat 8969: no control, no cast (the flight)
    SEAT_GUNNER                         = 1,       // VehicleSeat 8970: CAN_CONTROL + CAN_CAST (the action bar with 88496 Shoot)

    POINT_MACHINE_HOVER                 = 1,
    POINT_MACHINE_LANDING               = 2,

    EVENT_MACHINE_NO_RIDER              = 1,
    EVENT_MACHINE_TAKE_OFF              = 2,
    EVENT_MACHINE_CHECK                 = 3,
    EVENT_MACHINE_DEFENDER              = 4,
    EVENT_MACHINE_DEFENDERS_SHOOT       = 5,
    EVENT_MACHINE_GUN_TIMEOUT           = 6,
    EVENT_MACHINE_LAND                  = 7,
    EVENT_MACHINE_TERRACE_CLEAR         = 8,
};

// The flight: mop's 33 `waypoints` rows of 47467 (the SmartAI path this script replaces), points 1-31 as they were. Point 32
// (-6924.16,-1259.72,183.36) sat 4 yd above the terrace floor (vmap 179.0); the hover point is raised to 195 (ours) so that the
// gun's 5 yd circle is aimed down at the terrace. Point 33 is the landing at the Slag Pit entrance.
static Position const MachineFlight[] =
{
    { -6568.65f, -1164.91f, 315.744f }, { -6579.04f, -1163.29f, 315.494f }, { -6589.52f, -1172.35f, 313.889f },
    { -6599.08f, -1186.61f, 311.651f }, { -6610.93f, -1203.42f, 310.201f }, { -6617.02f, -1212.21f, 308.402f },
    { -6625.55f, -1224.29f, 305.097f }, { -6637.58f, -1241.95f, 302.045f }, { -6646.11f, -1254.19f, 302.561f },
    { -6655.05f, -1267.77f, 298.156f }, { -6663.65f, -1280.64f, 297.009f }, { -6673.08f, -1294.17f, 293.162f },
    { -6685.47f, -1310.63f, 289.104f }, { -6699.52f, -1325.65f, 285.111f }, { -6713.69f, -1337.52f, 282.325f },
    { -6730.53f, -1350.28f, 278.068f }, { -6746.39f, -1361.68f, 272.226f }, { -6762.47f, -1371.77f, 263.259f },
    { -6779.96f, -1378.52f, 250.393f }, { -6798.62f, -1384.74f, 236.811f }, { -6819.92f, -1391.83f, 222.098f },
    { -6840.49f, -1395.98f, 210.642f }, { -6857.32f, -1397.04f, 201.431f }, { -6875.67f, -1392.32f, 192.422f },
    { -6889.87f, -1380.98f, 188.206f }, { -6907.67f, -1367.36f, 184.374f }, { -6921.59f, -1351.01f, 182.994f },
    { -6929.33f, -1337.27f, 182.371f }, { -6936.93f, -1317.71f, 182.413f }, { -6943.07f, -1295.88f, 183.618f },
    { -6939.26f, -1272.98f, 185.507f },
};

static Position const MachineHoverPoint   = { -6924.16f, -1259.72f, 195.0f };
static Position const MachineLandingPoint = { -6911.87f, -1247.96f, 180.131f };

// Where the Cauldron Defenders appear: the 17 static 47470 spawns mop had on the terrace (sniff copies of the 88502 summon,
// deleted by 2026_11_21_50), all on the terrace floor and within 35 yd of the hover point, as 88502's random 35 yd destination
static Position const DefenderPoints[] =
{
    { -6902.98f, -1232.79f, 178.506f, 3.14151f }, { -6900.95f, -1247.26f, 177.158f, 3.14159f }, { -6908.04f, -1265.40f, 178.445f, 3.14143f },
    { -6904.42f, -1228.39f, 178.381f, 3.14131f }, { -6903.48f, -1227.04f, 178.381f, 3.14159f }, { -6906.35f, -1247.64f, 177.990f, 3.14184f },
    { -6899.13f, -1233.24f, 179.033f, 3.14159f }, { -6906.52f, -1246.53f, 178.144f, 3.14184f }, { -6906.80f, -1258.89f, 178.320f, 3.14139f },
    { -6901.76f, -1249.18f, 177.427f, 3.14159f }, { -6909.06f, -1252.66f, 178.428f, 3.14159f }, { -6902.25f, -1232.58f, 178.589f, 3.14159f },
    { -6907.29f, -1255.06f, 178.404f, 3.14159f }, { -6902.62f, -1263.49f, 178.578f, 3.14159f }, { -6903.53f, -1243.35f, 178.000f, 3.14159f },
    { -6903.99f, -1267.82f, 178.471f, 3.14159f }, { -6907.20f, -1267.84f, 178.469f, 3.14159f },
};

// Ours (user question 7: the sources give no count, no hover time and no control): three defenders on the terrace at a time,
// the terrace is "clear" after ten of them are shot, or after 90 s so that a player who cannot aim still gets through
static uint8  const DefendersAtOnce       = 3;
static uint8  const DefenderKillsNeeded   = 10;
static uint8  const DefenderSummonCap     = 40;       // a hard cap on summons for one flight (timeouts are replaced too)
static uint32 const DefenderLifetime      = 60000;    // 88502's duration
static uint32 const GunPhaseTimeout       = 90000;
static float  const MachineFlightSpeed    = 3.0f;     // x7 yd/s: the flight takes about half a minute (ours)

/*######
## 47467 Brotherhood Flying Machine (VehicleId 1266; summoned by 88498 at Lanie Reed 2941 / Grisha 3305, option 47631)
## What the player sees (sources: quest text, wiki notes, comment 2011-12-11 [+1], DBC 88496 / 88502 / 88645, broadcast 47787,
## screenshot npc47467_202169: the player in the machine's one cockpit seat): the machine appears beside him with him in its
## seat (88498: the summon and the hardcoded ride into the first free seat, seat 0) and flies down into the Cauldron towards the
## Slag Pit entrance. Over the landing terrace it stops and hovers; he gets the whisper "Clear the terrace for landing!  Shoot at
## Cauldron Defenders!" and an action bar with Shoot (88496: 4499 fire damage in a 5 yd circle he places on the ground, the
## "green circular cursor"; 4.4.2 creature_template_spell slot 0); Cauldron Defenders appear on the terrace "from nowhere" and
## die in one shot. Once the terrace is clear: credit ("Secure entrance into the Slag Pit"), the bar goes, the machine sets down
## at the entrance, he is put off on an empty terrace and the machine is gone. Rendan waits at the entrance (staging, B).
## Ours: the hover height, the seat change for the gun (seat 1 is the one with CAN_CONTROL + CAN_CAST; both seats have the same
## attachment, so the view does not move), the counts and the 90 s rule (above), the take-off lift, that the defenders stand
## passive and only play a rifle animation at the machine.
##
## Core notes. The machine is the player's Minion (SummonProperties 161, category vehicle; summoner = the player through the
## SmartAI cross-cast): his leaving it despawns it (Unit::_ExitVehicle) and his logout or far teleport unsummons it
## (Unsummoned). Seat 1 charms it (Vehicle::AddPassenger -> SetCharmedBy); VehicleAI keeps its AI while charmed, but
## VehicleAIBase::OnCharmed(false) would hide and despawn it 5 s after the seat change back to 0, so OnCharmed is replaced. The
## summon effect gives the machine the player's faction (SpellEffects.cpp SUMMON_CATEGORY_VEHICLE), which is hostile to the
## defenders' 54, so 88496 (TARGET_UNIT_DEST_AREA_ENEMY, cast by the vehicle) hits them. The defenders are not private: 88502 is
## a wild summon (SummonProperties 64), and SpellInfo::CheckTarget refuses a target private to someone other than the caster
## (the caster is the machine, not the player).
######*/

struct npc_searing_gorge_flying_machine : public VehicleAI
{
    npc_searing_gorge_flying_machine(Creature* creature) : VehicleAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner ? summoner->ToPlayer() : nullptr;
        if (!player)
        {
            me->DespawnOrUnsummon();
            return;
        }

        _playerGUID = player->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        me->SetSpeed(MOVE_FLIGHT, MachineFlightSpeed);
        me->SetSpeed(MOVE_RUN, MachineFlightSpeed);

        // 88498 seats the player right after the summon (SpellEffects.cpp: the original caster casts the ride on it); should that
        // not have happened, the machine goes
        _events.ScheduleEvent(EVENT_MACHINE_NO_RIDER, 2s);
    }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        if (_changingSeat || passenger->GetGUID() != _playerGUID)
            return;

        if (apply)
        {
            if (!_started)
            {
                _started = true;
                _events.CancelEvent(EVENT_MACHINE_NO_RIDER);
                _events.ScheduleEvent(EVENT_MACHINE_TAKE_OFF, 2s);
                _events.ScheduleEvent(EVENT_MACHINE_CHECK, 1s);
            }
            return;
        }

        // Put off at the landing (Land), or out early: logout, teleport, a death by some other means
        End();
    }

    // VehicleAIBase::OnCharmed(false) hides the vehicle and despawns it 5 s after its controller leaves the control seat: the
    // seat change back to 0 after the gun would end the flight before the landing. This script ends the machine itself.
    void OnCharmed(bool /*apply*/) override { }

    void JustDied(Unit* /*killer*/) override
    {
        End();
    }

    // Unsummoned by something other than End: the player logged out or was teleported far (the machine is his summon)
    void Unsummoned() override
    {
        _done = true;
        _events.Reset();
        DespawnDefenders();
    }

    void JustSummoned(Creature* summon) override
    {
        if (summon->GetEntry() != NPC_CAULDRON_DEFENDER)
            return;

        _defenders.push_back(summon->GetGUID());
        summon->SetReactState(REACT_PASSIVE);
        summon->SetFacingToObject(me);
    }

    void SummonedCreatureDies(Creature* summon, Unit* /*killer*/) override
    {
        if (summon->GetEntry() != NPC_CAULDRON_DEFENDER || _done || !_gunPhase)
            return;

        ++_defenderKills;
        if (_defenderKills >= DefenderKillsNeeded)
        {
            // Not from inside the gun's own hit: the seat change takes the charm off, and Unit::RemoveCharmedBy stops the
            // vehicle's current spell (88496, still executing)
            _events.CancelEvent(EVENT_MACHINE_DEFENDER);
            _events.ScheduleEvent(EVENT_MACHINE_TERRACE_CLEAR, 500ms);
            return;
        }

        _events.ScheduleEvent(EVENT_MACHINE_DEFENDER, 1500ms);
    }

    // A defender whose 60 s ran out is replaced
    void SummonedCreatureDespawn(Creature* summon) override
    {
        if (summon->GetEntry() != NPC_CAULDRON_DEFENDER || _done || !_gunPhase || !summon->IsAlive())
            return;

        _events.ScheduleEvent(EVENT_MACHINE_DEFENDER, 1500ms);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type != EFFECT_MOTION_TYPE || _done)
            return;

        if (id == POINT_MACHINE_HOVER)
            StartGunPhase();
        else if (id == POINT_MACHINE_LANDING)
            _events.ScheduleEvent(EVENT_MACHINE_LAND, 500ms);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void UpdateAI(uint32 diff) override
    {
        VehicleAI::UpdateAI(diff);

        if (_done)
            return;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_MACHINE_NO_RIDER:
                    if (!_started)
                    {
                        TC_LOG_ERROR("scripts", "npc_searing_gorge_flying_machine: nobody boarded the machine (summoner %s); it goes",
                            _playerGUID.ToString().c_str());
                        End();
                        return;
                    }
                    break;
                case EVENT_MACHINE_TAKE_OFF:
                    TakeOff();
                    break;
                case EVENT_MACHINE_CHECK:
                {
                    Player* player = GetRider();
                    if (!player || !player->IsInWorld() || player->GetVehicleBase() != me)
                    {
                        End();
                        return;
                    }
                    _events.ScheduleEvent(EVENT_MACHINE_CHECK, 1s);
                    break;
                }
                case EVENT_MACHINE_DEFENDER:
                    FillTerrace();
                    break;
                case EVENT_MACHINE_DEFENDERS_SHOOT:
                    DefendersShoot();
                    _events.ScheduleEvent(EVENT_MACHINE_DEFENDERS_SHOOT, 2500ms);
                    break;
                case EVENT_MACHINE_GUN_TIMEOUT:
                case EVENT_MACHINE_TERRACE_CLEAR:
                    TerraceClear();
                    break;
                case EVENT_MACHINE_LAND:
                    Land();
                    return;
                default:
                    break;
            }

            if (_done)
                return;
        }
    }

private:
    Player* GetRider() const
    {
        return ObjectAccessor::GetPlayer(*me, _playerGUID);
    }

    // Lifts straight up first (ours), so that the line to the first path point does not cut through Thorium Point's tents
    // (Grisha stands 65 yd from it), then flies the path to the hover point
    void TakeOff()
    {
        std::vector<Position> path;
        path.push_back(me->GetPosition());
        Position lift = me->GetPosition();
        lift.m_positionZ = std::max(lift.GetPositionZ() + 12.0f, MachineFlight[0].GetPositionZ());
        path.push_back(lift);
        for (Position const& point : MachineFlight)
            path.push_back(point);
        path.push_back(MachineHoverPoint);

        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveSmoothPath(POINT_MACHINE_HOVER, path.data(), path.size(), false, true);
    }

    void StartGunPhase()
    {
        Player* player = GetRider();
        if (!player || player->GetVehicleBase() != me)
        {
            End();
            return;
        }

        _gunPhase = true;
        me->StopMoving();
        me->SetFacingTo(me->GetAngle(&MachineLandingPoint));

        // The whisper goes to the rider in seat 0, as 88645's TARGET_UNIT_PASSENGER_0 would
        Talk(TALK_MACHINE_CLEAR_THE_TERRACE, player);

        // Seat 1 brings the action bar (Shoot). The machine is held where it is: the control seat would let him fly it away
        ChangeRiderSeat(player, SEAT_GUNNER);
        me->SetControlled(true, UNIT_STATE_ROOT);
        me->SetDisableGravity(true, true);   // to the new controller's client

        for (uint8 i = 0; i < DefendersAtOnce; ++i)
            SummonDefender();

        _events.ScheduleEvent(EVENT_MACHINE_DEFENDERS_SHOOT, 2s);
        _events.ScheduleEvent(EVENT_MACHINE_GUN_TIMEOUT, Milliseconds(GunPhaseTimeout));
    }

    void SummonDefender()
    {
        if (_defendersSummoned >= DefenderSummonCap)
            return;

        // A point no living defender stands on
        std::vector<Position const*> free;
        for (Position const& point : DefenderPoints)
        {
            bool taken = false;
            for (ObjectGuid const& guid : _defenders)
                if (Creature* defender = ObjectAccessor::GetCreature(*me, guid))
                    if (defender->IsAlive() && defender->GetExactDist2d(&point) < 2.0f)
                        taken = true;
            if (!taken)
                free.push_back(&point);
        }
        if (free.empty())
            return;

        Position const* point = free[urand(0, free.size() - 1)];
        if (me->SummonCreature(NPC_CAULDRON_DEFENDER, *point, TEMPSUMMON_TIMED_DESPAWN, Milliseconds(DefenderLifetime)))
            ++_defendersSummoned;
    }

    uint8 LivingDefenders()
    {
        uint8 count = 0;
        for (ObjectGuid const& guid : _defenders)
            if (Creature* defender = ObjectAccessor::GetCreature(*me, guid))
                if (defender->IsAlive() && defender->IsInWorld())
                    ++count;
        return count;
    }

    void FillTerrace()
    {
        if (!_gunPhase)
            return;

        for (uint8 alive = LivingDefenders(); alive < DefendersAtOnce; ++alive)
            SummonDefender();
    }

    // The defenders aim their rifles at the machine (an animation only: they are passive and never put anyone in combat)
    void DefendersShoot()
    {
        for (ObjectGuid const& guid : _defenders)
            if (Creature* defender = ObjectAccessor::GetCreature(*me, guid))
                if (defender->IsAlive() && roll_chance_i(60))
                {
                    defender->SetFacingToObject(me);
                    defender->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK_RIFLE);
                }
    }

    // Ten defenders shot, or 90 s: credit, the bar goes, the machine sets down at the entrance
    void TerraceClear()
    {
        if (!_gunPhase || _done)
            return;

        _gunPhase = false;
        _events.CancelEvent(EVENT_MACHINE_DEFENDER);
        _events.CancelEvent(EVENT_MACHINE_DEFENDERS_SHOOT);
        _events.CancelEvent(EVENT_MACHINE_GUN_TIMEOUT);
        _events.CancelEvent(EVENT_MACHINE_TERRACE_CLEAR);
        DespawnDefenders();

        Player* player = GetRider();
        if (!player || player->GetVehicleBase() != me)
        {
            End();
            return;
        }

        if (player->GetQuestStatus(QUEST_OPERATION_STIR_THE_CAULDRON) == QUEST_STATUS_INCOMPLETE)
            player->KilledMonsterCredit(NPC_BROTHERHOOD_FLYING_MACHINE);

        ChangeRiderSeat(player, SEAT_PASSENGER);
        me->SetControlled(false, UNIT_STATE_ROOT);
        me->SetCanFly(true);
        me->SetDisableGravity(true);

        Position const path[] = { me->GetPosition(), MachineLandingPoint };
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveSmoothPath(POINT_MACHINE_LANDING, path, std::size(path), false, true);
    }

    // At the entrance: the player gets off, which despawns the machine (his minion, Unit::_ExitVehicle)
    void Land()
    {
        if (Player* player = GetRider())
            if (player->GetVehicleBase() == me)
                player->ExitVehicle();

        End();
    }

    // Moves the player to another seat. Unit::ChangeSeat takes the passenger off (PassengerBoarded with apply false) and seats
    // him again within the call: that is no exit (as npc_badlands_story_vehicle::ChangeRiderSeat)
    void ChangeRiderSeat(Player* player, int8 seatId)
    {
        if (player->GetVehicleBase() != me)
            return;

        _changingSeat = true;
        player->ChangeSeat(seatId);
        _changingSeat = false;

        // RemovePassenger's Parachute for a rider with MOVEMENTFLAG_FLYING; nobody got out
        player->RemoveAurasDueToSpell(VEHICLE_SPELL_PARACHUTE);
    }

    void DespawnDefenders()
    {
        for (ObjectGuid const& guid : _defenders)
            if (Creature* defender = ObjectAccessor::GetCreature(*me, guid))
                defender->DespawnOrUnsummon();
        _defenders.clear();
    }

    // Every end: the defenders go, the machine goes; no credit unless the terrace was cleared (TerraceClear)
    void End()
    {
        if (_done)
            return;

        _done = true;
        _gunPhase = false;
        _events.Reset();
        DespawnDefenders();

        if (Player* player = GetRider())
            if (player->GetVehicleBase() == me)
                player->ExitVehicle();

        me->DespawnOrUnsummon(500);
    }

    EventMap _events;
    ObjectGuid _playerGUID;
    std::vector<ObjectGuid> _defenders;
    uint8 _defenderKills = 0;
    uint8 _defendersSummoned = 0;
    bool _started = false;
    bool _gunPhase = false;
    bool _changingSeat = false;
    bool _done = false;
};

// A rider who logged out in flight is saved where the machine was, high over the Cauldron (his summons go with him), and would
// fall at the next login (walk M2). Before he enters the world he is moved to the landing point only when all of these hold:
// he can have been a passenger (28052 in the log, or rewarded while Welcome to the Brotherhood is not: the flight option's own
// window); map 0; no mount or flight aura; within 40 yd of the machine's route (each flight master's lift, the path, the hover
// point, the landing); at least 25 yd above the ground or water below him. Anyone standing, riding or flying elsewhere cannot
// match. As player_badlands_uncrashable (Fuselight rocket). Ours.
class player_searing_gorge_cauldron_flight : public PlayerScript
{
public:
    player_searing_gorge_cauldron_flight() : PlayerScript("player_searing_gorge_cauldron_flight") { }

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
        QuestStatus const status = player->GetQuestStatus(QUEST_OPERATION_STIR_THE_CAULDRON);
        bool const inWindow = status == QUEST_STATUS_INCOMPLETE || status == QUEST_STATUS_COMPLETE
            || (player->GetQuestRewardStatus(QUEST_OPERATION_STIR_THE_CAULDRON) && !player->GetQuestRewardStatus(QUEST_WELCOME_TO_THE_BROTHERHOOD));
        if (!inWindow)
            return;

        if (player->GetMapId() != 0 || player->HasAuraType(SPELL_AURA_MOUNTED) || player->HasAuraType(SPELL_AURA_FLY)
            || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
            return;

        // Lanie Reed's and Grisha's spots, 12 yd up (the lift), then the path
        std::vector<Position> route;
        route.push_back({ -6559.06f, -1169.38f, 321.9f });
        route.push_back({ -6559.31f, -1100.25f, 322.4f });
        route.push_back(MachineFlight[0]);
        Position const pos = player->GetPosition();
        bool onPath = DistToSegment(pos, route[0], route[2]) <= 40.0f || DistToSegment(pos, route[1], route[2]) <= 40.0f;
        std::vector<Position> path(std::begin(MachineFlight), std::end(MachineFlight));
        path.push_back(MachineHoverPoint);
        path.push_back(MachineLandingPoint);
        for (size_t i = 0; i + 1 < path.size() && !onPath; ++i)
            onPath = DistToSegment(pos, path[i], path[i + 1]) <= 40.0f;
        if (!onPath)
            return;

        Map* map = sMapMgr->FindBaseNonInstanceMap(0);
        if (!map)
            return;
        float const below = map->GetWaterOrGroundLevel(PHASEMASK_NORMAL, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ());
        if (pos.GetPositionZ() < below + 25.0f)
            return;

        TC_LOG_DEBUG("scripts", "player_searing_gorge_cauldron_flight: %s logged in on the flying machine's route at %.1f %.1f %.1f (%.1f yd up), moved to the landing point",
            player->GetName().c_str(), pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), pos.GetPositionZ() - below);
        player->Relocate(MachineLandingPoint);
        player->SetFallInformation(0, MachineLandingPoint.GetPositionZ());
    }
};

// ---------------------------------------------------------------------------------------------------------------------------
// The pillow event: Kill 'em With Sleep Deprivation 28057, Look at the Size of It! 28058
// ---------------------------------------------------------------------------------------------------------------------------

enum PillowEvent
{
    GO_DARK_IRON_PILLOW                 = 179828,
    GO_PILLOW_EVENT_GENERATOR           = 179829,  // "Dark Iron Pillow Event Generator", one spawn in the bunk hall (3132412)

    NPC_SLEEPY_DARK_IRON_WORKER         = 14635,
    NPC_CHAMBERMAID_PILLACLENCHER       = 14636,

    TALK_WORKER_OUR_PILLAS              = 0,       // BroadcastText 9799 "Our pillas! Someone has stolen our pillas!"
    TALK_WORKER_NOT_UNPUNISHED          = 1,       // BroadcastText 9800 "We'll not let this act of madness go unpunished!"
    TALK_CHAMBERMAID_THIEVES            = 0,       // BroadcastText 9810 "Thieves! Scallywags! Rapscallions! ..."

    ACTION_PILLOW_TAKEN                 = 1,

    EVENT_PILLOW_GANG_1                 = 1,
    EVENT_PILLOW_GANG_2                 = 2,
    EVENT_PILLOW_CHAMBERMAID            = 3,
    EVENT_PILLOW_END                    = 4,

    POINT_SLEEPY_PATROL                 = 1,
};

// Sourced (28057 comments 2011-12-30 [+2] "every 5 minutes after you loot the first pillow" with the times 13:06 / 13:11 /
// 13:16, 2010-12-27 [+62], OLD 2009-12-24 [+14] "About 12 of these spawn and run as a group", 2011-03-18 [+15] "pace back and
// forth through that hall" and never leave; 28058 2010-11-26 [+19] / 2013-09-21 [+1] the Chambermaid in the curved hall at
// 45.82 29.65): 5 min after the first pillow a gang and its yell, 5 min later a second gang and its yell, 5 min later the
// Chambermaid and her yell. Ours: 10 workers per gang, the patrol line, the Chambermaid's 10 minutes out of combat, the end of
// the cycle 25 min after the first pillow (the next pillow then starts a new cycle). The gangs never leave (2011-03-18): they
// pace until killed. The bound is a cap instead: a gang tops the hall up to at most 20 living workers (two gangs), and no second
// Chambermaid comes while one lives; a grid unload (nobody near) takes them all.
static uint32 const PillowGangDelay       = 5 * MINUTE * IN_MILLISECONDS;
static uint32 const PillowChambermaidTime = 10 * MINUTE * IN_MILLISECONDS;
static uint8  const PillowGangSize        = 10;
static uint8  const PillowWorkerCap       = 20;

// The gang appears where mop's ten static Sleepy workers stood (their post-event state, removed by 2026_11_21_53)
static Position const SleepyGangPoints[PillowGangSize] =
{
    { -6533.57f, -1344.48f, 208.798f }, { -6540.60f, -1346.88f, 208.874f }, { -6543.31f, -1346.92f, 208.906f },
    { -6543.34f, -1345.34f, 208.890f }, { -6541.66f, -1344.94f, 208.878f }, { -6545.29f, -1346.00f, 208.906f },
    { -6540.70f, -1345.85f, 208.866f }, { -6544.54f, -1343.22f, 208.874f }, { -6542.71f, -1347.73f, 208.912f },
    { -6542.17f, -1343.94f, 208.870f },
};

static Position const ChambermaidPoint = { -6540.42f, -1348.01f, 208.904f, 2.5f };   // mop's static spot = the comment's pin

// The bunk hall's walkway, between the two curved rows of bunks (the pillow spots); floor z 208.8-209.0 under a 222 ceiling at
// every point (vmap, ground.py). Ours.
static Position const SleepyPatrol[] =
{
    { -6566.0f, -1318.0f, 208.8f }, { -6560.0f, -1332.0f, 208.8f }, { -6552.0f, -1341.0f, 209.0f },
    { -6541.0f, -1348.0f, 208.9f }, { -6528.0f, -1352.0f, 208.9f }, { -6514.0f, -1354.0f, 209.0f },
};

/*######
## 179829 Dark Iron Pillow Event Generator (one spawn, displayId 0): the event's timeline. One cycle at a time; pillows taken
## while it runs change nothing. Everything it summons is public (the comments speak of other players' gangs and of a
## Chambermaid already waiting). Objects update only in loaded grids: with nobody in the Slag Pit the grid unloads, the
## summons with it, and the generator starts idle again.
######*/

struct go_searing_gorge_pillow_event_generator : public GameObjectAI
{
    go_searing_gorge_pillow_event_generator(GameObject* go) : GameObjectAI(go) { }

    void DoAction(int32 action) override
    {
        if (action != ACTION_PILLOW_TAKEN || _running)
            return;

        _running = true;
        _events.Reset();
        _events.ScheduleEvent(EVENT_PILLOW_GANG_1, Milliseconds(PillowGangDelay));
        _events.ScheduleEvent(EVENT_PILLOW_GANG_2, Milliseconds(2 * PillowGangDelay));
        _events.ScheduleEvent(EVENT_PILLOW_CHAMBERMAID, Milliseconds(3 * PillowGangDelay));
        _events.ScheduleEvent(EVENT_PILLOW_END, Milliseconds(3 * PillowGangDelay + PillowChambermaidTime));
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_running)
            return;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_PILLOW_GANG_1:
                    SummonGang(TALK_WORKER_OUR_PILLAS);
                    break;
                case EVENT_PILLOW_GANG_2:
                    SummonGang(TALK_WORKER_NOT_UNPUNISHED);
                    break;
                case EVENT_PILLOW_CHAMBERMAID:
                {
                    // She stays 10 min out of combat, then goes; on her death her SmartAI summons the Ornate Pillow (2026_11_21_53)
                    Creature* old = _maidGUID.IsEmpty() ? nullptr : ObjectAccessor::GetCreature(*me, _maidGUID);
                    if (old && old->IsAlive())
                        break;
                    if (TempSummon* maid = me->SummonCreature(NPC_CHAMBERMAID_PILLACLENCHER, ChambermaidPoint,
                        TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, Milliseconds(PillowChambermaidTime)))
                    {
                        _maidGUID = maid->GetGUID();
                        sCreatureTextMgr->SendChat(maid, TALK_CHAMBERMAID_THIEVES);
                    }
                    break;
                }
                case EVENT_PILLOW_END:
                    _running = false;
                    break;
                default:
                    break;
            }
        }
    }

private:
    void SummonGang(uint8 talkGroup)
    {
        // Forget the dead and the gone; top the hall up to the cap
        uint8 living = 0;
        for (auto itr = _workers.begin(); itr != _workers.end();)
        {
            Creature* worker = ObjectAccessor::GetCreature(*me, *itr);
            if (worker && worker->IsAlive())
            {
                ++living;
                ++itr;
            }
            else
                itr = _workers.erase(itr);
        }

        bool yelled = false;
        for (Position const& point : SleepyGangPoints)
        {
            if (living >= PillowWorkerCap)
                break;

            TempSummon* worker = me->SummonCreature(NPC_SLEEPY_DARK_IRON_WORKER, point, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 60s);
            if (!worker)
                continue;

            _workers.push_back(worker->GetGUID());
            ++living;
            if (!yelled)
            {
                yelled = true;
                sCreatureTextMgr->SendChat(worker, talkGroup);
            }
        }
    }

    EventMap _events;
    std::vector<ObjectGuid> _workers;
    ObjectGuid _maidGUID;
    bool _running = false;
};

/*######
## 179828 Dark Iron Pillow: opening one starts the generator's cycle (the open-lock path asks the object's AI before the loot,
## Spell::SendLoot; GameObject::Use does too). The loot itself is untouched. The chest's lootedEvent 8540, which no
## event_scripts row in mop or either TDB carries, is where retail hooked it (I).
######*/

struct go_searing_gorge_dark_iron_pillow : public GameObjectAI
{
    go_searing_gorge_dark_iron_pillow(GameObject* go) : GameObjectAI(go) { }

    bool OnGossipHello(Player* /*player*/, bool /*isUse*/) override
    {
        if (GameObject* generator = me->FindNearestGameObject(GO_PILLOW_EVENT_GENERATOR, 100.0f))
            if (generator->AI())
                generator->AI()->DoAction(ACTION_PILLOW_TAKEN);
        return false;
    }
};

/*######
## 14635 Sleepy Dark Iron Worker: summoned by the generator only. Paces the walkway of the bunk hall back and forth at a walk
## (ours) and fights whoever it meets (faction 54); after an evade it goes back to pacing from where it was summoned.
######*/

struct npc_searing_gorge_sleepy_worker : public ScriptedAI
{
    npc_searing_gorge_sleepy_worker(Creature* creature) : ScriptedAI(creature)
    {
        // Each walks a little beside the line, so the gang does not move as one body
        _offsetX = frand(-2.0f, 2.0f);
        _offsetY = frand(-2.0f, 2.0f);
        _direction = urand(0, 1) ? 1 : -1;
    }

    void Reset() override
    {
        me->SetWalk(true);
        _index = NearestPatrolPoint();
        _moveTimer = urand(1000, 3000);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type != POINT_MOTION_TYPE || id != POINT_SLEEPY_PATROL)
            return;

        int32 const last = int32(std::size(SleepyPatrol)) - 1;
        if (_index + _direction < 0 || _index + _direction > last)
            _direction = -_direction;
        _index += _direction;
        _moveTimer = urand(500, 2500);
    }

    void UpdateAI(uint32 diff) override
    {
        if (!UpdateVictim())
        {
            if (me->IsInEvadeMode() || me->GetMotionMaster()->GetCurrentMovementGeneratorType() != IDLE_MOTION_TYPE)
                return;

            if (_moveTimer <= diff)
            {
                _moveTimer = 5000;   // a point that cannot be reached is tried again
                Position const& point = SleepyPatrol[_index];
                me->GetMotionMaster()->MovePoint(POINT_SLEEPY_PATROL, point.GetPositionX() + _offsetX, point.GetPositionY() + _offsetY,
                    point.GetPositionZ());
            }
            else
                _moveTimer -= diff;
            return;
        }

        DoMeleeAttackIfReady();
    }

private:
    int32 NearestPatrolPoint() const
    {
        int32 best = 0;
        float bestDist = std::numeric_limits<float>::max();
        for (int32 i = 0; i < int32(std::size(SleepyPatrol)); ++i)
        {
            float const dist = me->GetExactDist2d(&SleepyPatrol[i]);
            if (dist < bestDist)
            {
                bestDist = dist;
                best = i;
            }
        }
        return best;
    }

    float _offsetX = 0.0f;
    float _offsetY = 0.0f;
    int32 _index = 0;
    int32 _direction = 1;
    uint32 _moveTimer = 0;
};

void AddSC_searing_gorge_cauldron()
{
    new creature_script<npc_searing_gorge_flying_machine>("npc_searing_gorge_flying_machine");
    RegisterGameObjectAI(go_searing_gorge_pillow_event_generator);
    RegisterGameObjectAI(go_searing_gorge_dark_iron_pillow);
    new creature_script<npc_searing_gorge_sleepy_worker>("npc_searing_gorge_sleepy_worker");
    new player_searing_gorge_cauldron_flight();
}
