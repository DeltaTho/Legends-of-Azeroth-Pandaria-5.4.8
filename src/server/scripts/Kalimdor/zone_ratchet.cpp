/*
 * Northern Barrens: Ratchet's scripted events (research\northern-barrens\dossiers\F.md, plan.md section S4).
 *
 * Gazlowe's Fortune (14050): the Baron's ambush at the Curious Pirate Landmark.
 * Raging River Ride (26769): Horton Hornblower's riverboat up the Southfury River to the pier east of Nozzlepot's Outpost.
 *
 * What is sourced and what is ours is said at each script; nothing here is in either TDB.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "GameObjectAI.h"
#include "GameObject.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "TemporarySummon.h"
#include "MotionMaster.h"
#include "Vehicle.h"

/*######
## Gazlowe's Fortune (14050): the Baron's ambush
######*/

enum GazlowesFortune
{
    QUEST_GAZLOWES_FORTUNE          = 14050,

    NPC_BARON_LONGSHORE             = 3467,
    NPC_SOUTHSEA_CUTTHROAT          = 3383,

    FACTION_SOUTHSEA_FREEBOOTERS    = 230,      // the Privateers' faction: hostile to both player teams

    SAY_BARON_HOLD_IT               = 1,        // creature_text 3467/1, BT 35060 "Hold it, $r! ..."
};

// Ours: the Baron comes from the side of both TDBs' second Baron spawn (guid 302182, (-1107.2,-3648.1), 70 yd from the
// landmark: the sniffed ambusher), but 20 yd out, so he reaches the digger while the "Digging" cast is still on or just over;
// the two cutthroats 3 yd to either side of him. Open ground, terrain z from the 5.4.8 maps.
static Position const AmbushBaronPos         = { -1146.01f, -3617.41f, 95.93f, 2.47f };
static Position const AmbushCutthroatPos[2]  =
{
    { -1144.94f, -3614.43f, 95.29f, 2.47f },
    { -1148.66f, -3619.14f, 96.32f, 2.47f },
};

// Sourced: they "don't follow long, despawn after a few moments" (comment 2014-07-31 [+1]). Ours: 15 s out of combat.
static constexpr Milliseconds AmbushOutOfCombatDespawn = 15s;

// 195206 Curious Pirate Landmark (the treasure chest under the mast; lock 43 "Digging", Gazlowe's Fortune 46833)
// What the player sees (sourced: beta comment [+12], comments 2010-11-30 [+6], 2011-03-08 [+3], 2011-08-06, the wiki, BT 35060
// with emote 5, the offer-reward text "Oh, the Baron tried to stop you, did he?"): digging up the treasure brings Baron
// Longshore and one or two Southsea Cutthroats, who attack; the Baron yells "Hold it, <race>! I promised told ye where the
// treasure is, but never promised ye could keep it!". Running away, they give up after a while and vanish.
// Ours: two cutthroats; the summon spots; one ambush per digger at a time (a second digger gets his own; opening a chest calls
// OnGossipHello several times, core C97, so a digger whose ambush still lives gets no other); sprung when the chest is opened
// (GameObject::Use / the Opening spell's loot, isUse true), not on the click's CMSG_GAMEOBJ_REPORT_USE (isUse false,
// SpellHandler.cpp:669), so the "Digging" cast comes first; the Baron's copy is not a quest giver, stands (no sitting), is hostile to both
// teams like the Privateers, and keeps his loot (Garvey's Head is a quest drop of WANTED: Cap'n Garvey only). The ambush is
// summoned by the chest, not by the player (a gameobject summoner fires no JustSummoned / IsSummonedBy, TemporarySummon.cpp:
// 305-312, so the copy's SmartAI could not set this up itself; plan ruling R3's JUST_SUMMONED rows are replaced by this).
struct go_ratchet_curious_pirate_landmark : public GameObjectAI
{
    go_ratchet_curious_pirate_landmark(GameObject* go) : GameObjectAI(go) { }

    bool OnGossipHello(Player* player, bool isUse) override
    {
        if (isUse && player->GetQuestStatus(QUEST_GAZLOWES_FORTUNE) == QUEST_STATUS_INCOMPLETE && !AmbushAlive(player->GetGUID()))
            Ambush(player);
        return false;   // the chest opens as before
    }

private:
    bool AmbushAlive(ObjectGuid const& digger)
    {
        GuidVector& ambushers = _ambushers[digger];
        for (ObjectGuid const& guid : ambushers)
            if (Creature* ambusher = ObjectAccessor::GetCreature(*me, guid))
                if (ambusher->IsAlive())
                    return true;
        _ambushers.erase(digger);
        return false;
    }

    static void Prepare(Creature* ambusher, Player* player)
    {
        ambusher->ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
        ambusher->SetStandState(UNIT_STAND_STATE_STAND);
        ambusher->SetFaction(FACTION_SOUTHSEA_FREEBOOTERS);
        ambusher->SetHomePosition(ambusher->GetPosition());
        ambusher->AI()->AttackStart(player);
    }

    void Ambush(Player* player)
    {
        GuidVector& ambushers = _ambushers[player->GetGUID()];

        if (TempSummon* baron = me->SummonCreature(NPC_BARON_LONGSHORE, AmbushBaronPos, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, AmbushOutOfCombatDespawn))
        {
            ambushers.push_back(baron->GetGUID());
            Prepare(baron, player);
            baron->AI()->Talk(SAY_BARON_HOLD_IT, player);
        }

        for (Position const& pos : AmbushCutthroatPos)
            if (TempSummon* cutthroat = me->SummonCreature(NPC_SOUTHSEA_CUTTHROAT, pos, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, AmbushOutOfCombatDespawn))
            {
                ambushers.push_back(cutthroat->GetGUID());
                Prepare(cutthroat, player);
            }
    }

    std::unordered_map<ObjectGuid, GuidVector> _ambushers;   // per digger
};

/*######
## Raging River Ride (26769): Horton Hornblower's riverboat up the Southfury River
######*/

enum RagingRiverRide
{
    NPC_RIVERBOAT_RIDE              = 44055,    // vehicle 1011, summoned by 82457 Summon Riverboat (spellclick of the parked 44057)
    NPC_HORTON_HORNBLOWER           = 44058,

    RIVERBOAT_PLAYER_SEAT           = 0,        // seat 8330 (the summon effect seats the clicker in the first free seat)
    RIVERBOAT_HORTON_SEAT           = 1,        // seat 8331

    // creature_text 44058 (Horton): 0 greeting (BT 44368), 1 the motion emote (BT 45711), 2-6 the ride lines BT 44386-44390
    SAY_HORTON_TIGHT_SQUEEZE        = 2,
    SAY_HORTON_SMELL_OF_DUROTAR     = 3,
    SAY_HORTON_SOMETHING_WRONG      = 4,
    SAY_HORTON_WHY_A_BOAT           = 5,
    SAY_HORTON_YOUR_STOP            = 6,

    EVENT_RIVERBOAT_SEAT_HORTON     = 1,
    EVENT_RIVERBOAT_BOARD_CHECK     = 2,
    EVENT_RIVERBOAT_START           = 3,
    EVENT_RIVERBOAT_CHECK           = 4,
    EVENT_RIVERBOAT_TIMEOUT         = 5,
    EVENT_RIVERBOAT_LANDED          = 6,
    EVENT_RIVERBOAT_SAIL_OFF        = 7,

    POINT_RIVERBOAT_STEP            = 1,
};

// ---------------------------------------------------------------------------------------------------------------------------
// The route (ours: no TDB, sniff or emulator has it; question 4). Sourced shape (video DQKchWmk8v4, 5.4.8, 2014-07-22): the boat
// waits at a wooden dock, the ride takes about 2 minutes with about eight speech bubbles, the player is put off at a wooden dock
// on the west bank, from where Nozzlepot's Outpost is about 1.5 min's run west, and the boat sails off again. Horton's last line
// (BT 44390): "We're pulling up near your stop. Head due west along the road to reach Nozzlepot's Outpost."
// Built along the middle of the Southfury River from the 5.4.8 liquid map (research\northern-barrens\tmp\S4\route.py,
// check.py, vchk.py): every leg over water at least 0.8 yd deep, 20-48 yd long (one MovePoint each, archetypes "a long road
// is not one spline"), at the water surface (17.9) + 1.8, the parked boat's height; under the middle of the bridge of the
// Crossroads - Razor Hill road (x 308-324, arch underside about 29.5); through the narrows at x -560 .. -490 ("Whew, that was
// a bit of a tight squeeze" is said just after them). The drop is the wooden pier on the west bank at (1000..1021, -3814..
// -3790), found in the vmaps (deck 18.6, the only pier on that bank); Nozzlepot (1168.6,-3389.1) is 440 yd north-west of it.
// About 1800 yd at 15 yd/s: 118 s, as the video. Say = Horton's line said when the boat reaches that point (-1 none).
// To change the ride's length: RiverboatSpeedRate (2.16 x 7 yd/s); the drop: the last point and RiverboatDropPos together.
// ---------------------------------------------------------------------------------------------------------------------------
struct RiverboatRoutePoint
{
    float X, Y;
    int8 Say;
};

static RiverboatRoutePoint const RiverboatRoute[] =
{
    { -670.0f, -3978.5f, -1 }, { -640.0f, -3962.0f, -1 }, { -610.0f, -3963.0f, -1 }, { -580.0f, -3952.0f, -1 },
    { -550.0f, -3931.0f, -1 }, { -520.0f, -3928.5f, -1 }, { -490.0f, -3924.5f, -1 },                              // the narrows
    { -460.0f, -3914.0f, SAY_HORTON_TIGHT_SQUEEZE }, { -420.0f, -3920.0f, -1 }, { -380.0f, -3915.0f, -1 },
    { -345.0f, -3882.0f, -1 }, { -310.0f, -3866.5f, -1 }, { -280.0f, -3859.5f, -1 }, { -250.0f, -3848.0f, -1 },
    { -220.0f, -3828.0f, -1 }, { -190.0f, -3818.0f, -1 }, { -160.0f, -3804.0f, SAY_HORTON_SMELL_OF_DUROTAR },
    { -120.0f, -3790.0f, -1 }, { -80.0f, -3774.0f, -1 }, { -40.0f, -3763.0f, -1 }, { 0.0f, -3764.0f, -1 },
    { 40.0f, -3767.0f, -1 }, { 80.0f, -3758.0f, -1 }, { 120.0f, -3756.0f, -1 }, { 160.0f, -3755.0f, -1 },
    { 200.0f, -3759.5f, -1 }, { 230.0f, -3756.0f, -1 }, { 260.0f, -3756.5f, SAY_HORTON_SOMETHING_WRONG },
    { 290.0f, -3767.0f, -1 }, { 320.0f, -3761.0f, -1 },                                                          // the bridge
    { 350.0f, -3776.0f, -1 }, { 380.0f, -3790.0f, -1 }, { 410.0f, -3781.0f, -1 }, { 440.0f, -3785.5f, -1 },
    { 470.0f, -3790.0f, -1 }, { 500.0f, -3790.0f, SAY_HORTON_WHY_A_BOAT }, { 530.0f, -3778.5f, -1 },
    { 560.0f, -3774.0f, -1 }, { 590.0f, -3770.0f, -1 }, { 620.0f, -3780.0f, -1 }, { 650.0f, -3775.5f, -1 },
    { 680.0f, -3784.5f, -1 }, { 710.0f, -3780.5f, -1 }, { 740.0f, -3783.0f, -1 }, { 770.0f, -3776.5f, -1 },
    { 800.0f, -3785.0f, -1 }, { 830.0f, -3800.0f, -1 }, { 860.0f, -3796.0f, SAY_HORTON_YOUR_STOP },
    { 890.0f, -3792.5f, -1 }, { 920.0f, -3799.0f, -1 }, { 950.0f, -3808.5f, -1 }, { 975.0f, -3822.0f, -1 },
    { 985.0f, -3824.0f, -1 }, { 1003.0f, -3818.0f, -1 },                                                         // alongside the pier
};

static float const RiverboatZ                   = 19.7231f;     // the parked boat's and 82457's spell_target_position z
static float const RiverboatSpeedRate           = 2.16f;
static Position const RiverboatDropPos          = { 1006.0f, -3803.5f, 18.7f, 2.0f };   // on the pier, 14.7 yd from the boat
// After the drop the boat sails on upstream and is gone (ours: three legs, then despawn)
static Position const RiverboatSailOffRoute[]   =
{
    { 1040.0f, -3862.0f, 19.7231f },
    { 1080.0f, -3884.0f, 19.7231f },
    { 1120.0f, -3895.0f, 19.7231f },
};

static void UnsummonPassengers(Creature* boat)
{
    if (Vehicle* kit = boat->GetVehicleKit())
        for (int8 seat = 0; seat < 2; ++seat)
            if (Unit* passenger = kit->GetPassenger(seat))
                if (passenger->GetTypeId() == TYPEID_UNIT && passenger->IsSummon())
                    passenger->ToTempSummon()->UnSummon();
}

// 44055 Riverboat (the moving boat; vehicle 1011, seats 8330 / 8331 both CAN_ENTER_OR_EXIT, neither controls)
// What the player sees (sourced: comments 2010-11-24 [+17], 2010-11-26 [+5] "Call Riverboat" on the bar, 2011-02-23 [+14], the
// wiki's line order, BT 44386-44390, video DQKchWmk8v4): clicking the boat at the dock puts him on a riverboat with Horton
// Hornblower aboard (the board objective is credited by 82457 itself); it goes up the Southfury River, Horton says his five
// lines on the way, the last one near the stop, and the player is put off on a wooden pier on the west bank; the boat sails on.
// Ours: Horton's copy in the second seat (no accessory row in mop or either TDB), the route and timings above, the drop point.
// The player may leave at any time (the seat allows it): the boat (his Minion, Unit::_ExitVehicle) and Horton's copy go, the
// credit stays; logging out ends it the same way (he logs back in where he was, on the river). Failsafe: 30 s after the ride
// should have ended, the player is let off where the boat is. After any early end he may click the parked boat again (the
// click is allowed until the quest is handed in).
// Summoned by another boat (its sail-off copy, see End) it takes no rider and only sails off with its own Horton.
struct npc_ratchet_riverboat : public ScriptedAI
{
    npc_ratchet_riverboat(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        me->SetSpeed(MOVE_RUN, RiverboatSpeedRate);
        me->SetSpeed(MOVE_FLIGHT, RiverboatSpeedRate);
        me->SetSpeed(MOVE_SWIM, RiverboatSpeedRate);

        _events.Reset();
        if (summoner->GetTypeId() == TYPEID_PLAYER)
        {
            _playerGUID = summoner->GetGUID();
            me->setActive(true, ActiveFlags::Script);   // 1 800 yd of river across several grids
            // The summon effect seats the clicker right after this call; Horton goes into the other seat after him
            _events.ScheduleEvent(EVENT_RIVERBOAT_SEAT_HORTON, 300ms);
            _events.ScheduleEvent(EVENT_RIVERBOAT_BOARD_CHECK, 1s);
            _events.ScheduleEvent(EVENT_RIVERBOAT_START, 2500ms);
        }
        else
        {
            _sailOff = true;
            _events.ScheduleEvent(EVENT_RIVERBOAT_SEAT_HORTON, 0ms);
            _events.ScheduleEvent(EVENT_RIVERBOAT_SAIL_OFF, 1s);
        }
    }

    // Not the follow-on-spawn of CreatureAI::JustAppeared (the ride boat is the player's Minion)
    void JustAppeared() override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    Player* GetRider() const { return ObjectAccessor::GetPlayer(*me, _playerGUID); }
    bool IsRiding(Player* player) const { return player && player->GetVehicleBase() == me; }

    Creature* GetHorton() const
    {
        if (Vehicle* kit = me->GetVehicleKit())
            if (Unit* passenger = kit->GetPassenger(RIVERBOAT_HORTON_SEAT))
                if (passenger->GetEntry() == NPC_HORTON_HORNBLOWER)
                    return passenger->ToCreature();
        return nullptr;
    }

    void SeatHorton()
    {
        Vehicle* kit = me->GetVehicleKit();
        if (!kit || kit->GetPassenger(RIVERBOAT_HORTON_SEAT))
            return;

        if (TempSummon* horton = me->SummonCreature(NPC_HORTON_HORNBLOWER, me->GetPosition(), TEMPSUMMON_MANUAL_DESPAWN))
        {
            horton->ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
            horton->SetReactState(REACT_PASSIVE);
            horton->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
            horton->EnterVehicle(me, RIVERBOAT_HORTON_SEAT);
            if (horton->GetVehicleBase() != me)
            {
                TC_LOG_ERROR("scripts", "npc_ratchet_riverboat: Horton could not be seated on the riverboat");
                horton->DespawnOrUnsummon();
            }
        }
    }

    void HortonSays(uint8 group)
    {
        if (Creature* horton = GetHorton())
            horton->AI()->Talk(group, GetRider());
    }

    void MoveTo(Position const& pos)
    {
        me->GetMotionMaster()->MovePoint(POINT_RIVERBOAT_STEP, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), false);
    }

    void MoveNext()
    {
        if (_sailOff)
        {
            if (_next >= std::extent<decltype(RiverboatSailOffRoute)>::value)
            {
                _ended = true;
                UnsummonPassengers(me);
                me->DespawnOrUnsummon();
                return;
            }
            MoveTo(RiverboatSailOffRoute[_next]);
            return;
        }

        if (_next >= std::extent<decltype(RiverboatRoute)>::value)
        {
            _arrived = true;
            me->SetFacingTo(me->GetAngle(&RiverboatDropPos));
            _events.ScheduleEvent(EVENT_RIVERBOAT_LANDED, 1500ms);
            return;
        }

        RiverboatRoutePoint const& point = RiverboatRoute[_next];
        MoveTo(Position(point.X, point.Y, RiverboatZ));
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type != POINT_MOTION_TYPE || id != POINT_RIVERBOAT_STEP || _ended || _arrived)
            return;

        if (!_sailOff && _next < std::extent<decltype(RiverboatRoute)>::value && RiverboatRoute[_next].Say >= 0)
            HortonSays(uint8(RiverboatRoute[_next].Say));

        ++_next;
        MoveNext();
    }

    void Start()
    {
        _next = 0;
        MoveNext();

        float length = 0.0f;
        Position prev = me->GetPosition();
        for (RiverboatRoutePoint const& point : RiverboatRoute)
        {
            Position const pos(point.X, point.Y, RiverboatZ);
            length += prev.GetExactDist2d(&pos);
            prev = pos;
        }
        uint32 const seconds = uint32(length / (RiverboatSpeedRate * 7.0f));
        _events.ScheduleEvent(EVENT_RIVERBOAT_TIMEOUT, Seconds(seconds + 30));
    }

    // At the pier: the player steps onto it, and a copy of the boat with its own Horton sails on (the ride boat is the player's
    // Minion and goes the moment he gets off, Unit::_ExitVehicle). Ended early: he is let off where the boat is.
    void End(bool landed)
    {
        if (_ended)
            return;
        _ended = true;
        _events.Reset();

        if (landed)
            me->SummonCreature(NPC_RIVERBOAT_RIDE, me->GetPosition(), TEMPSUMMON_TIMED_DESPAWN, 30s);

        UnsummonPassengers(me);

        if (Player* player = GetRider())
            if (IsRiding(player))
            {
                player->ExitVehicle();   // lands on the pier when landed (GetPassengerExitPosition)
            }

        me->DespawnOrUnsummon();
    }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        if (!apply && !_sailOff && passenger->GetGUID() == _playerGUID && !_ended)
            End(false);
    }

    // Vehicle::RemovePassenger overwrites any exit position with the vehicle's own unless the AI moves it (Vehicle.cpp:776-785):
    // at the pier the player lands on its deck; ended early he is let off where the boat is
    void GetPassengerExitPosition(Unit* passenger, int8 /*seatId*/, Position& pos) override
    {
        if (_arrived && passenger->GetGUID() == _playerGUID)
            pos.Relocate(RiverboatDropPos);
    }

    void Unsummoned() override
    {
        _ended = true;
        UnsummonPassengers(me);
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
                case EVENT_RIVERBOAT_SEAT_HORTON:
                    SeatHorton();
                    break;
                case EVENT_RIVERBOAT_BOARD_CHECK:
                    if (!IsRiding(GetRider()))
                    {
                        TC_LOG_ERROR("scripts", "npc_ratchet_riverboat: the rider did not board");
                        End(false);
                        return;
                    }
                    _boarded = true;
                    _events.ScheduleEvent(EVENT_RIVERBOAT_CHECK, 1s);
                    break;
                case EVENT_RIVERBOAT_START:
                    Start();
                    break;
                case EVENT_RIVERBOAT_CHECK:
                {
                    Player* player = GetRider();
                    if (!player || !player->IsInWorld() || !player->IsAlive() || (_boarded && !IsRiding(player)))
                    {
                        End(false);
                        return;
                    }
                    _events.ScheduleEvent(EVENT_RIVERBOAT_CHECK, 1s);
                    break;
                }
                case EVENT_RIVERBOAT_TIMEOUT:
                    TC_LOG_ERROR("scripts", "npc_ratchet_riverboat: the ride did not reach the pier in time");
                    End(false);
                    return;
                case EVENT_RIVERBOAT_LANDED:
                    End(true);
                    return;
                case EVENT_RIVERBOAT_SAIL_OFF:
                    _next = 0;
                    MoveNext();
                    break;
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
    size_t _next = 0;
    bool _sailOff = false;
    bool _boarded = false;
    bool _arrived = false;
    bool _ended = false;
};

void AddSC_ratchet()
{
    RegisterGameObjectAI(go_ratchet_curious_pirate_landmark);
    new creature_script<npc_ratchet_riverboat>("npc_ratchet_riverboat");
}
