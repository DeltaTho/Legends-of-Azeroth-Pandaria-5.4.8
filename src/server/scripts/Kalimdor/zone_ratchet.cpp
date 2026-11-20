/*
 * Northern Barrens: Ratchet's scripted events (research\northern-barrens\dossiers\F.md, plan.md section S4).
 *
 * Gazlowe's Fortune (14050): the Baron's ambush at the Curious Pirate Landmark.
 * Raging River Ride (26769): Horton Hornblower's riverboat up the Southfury River to the pier east of Nozzlepot's Outpost.
 * Repel Boarders! (24934, Alliance): the Northwatch gryphon from Admiral Aubrey's tower to the Blackpool and back.
 * Mutiny, Mon! (14063): Tony Two-Tusk and his crew take the Maiden's Dagger from Alicia Cuthbert.
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
#include "SpellScript.h"
#include "WorldSession.h"
#include "MapManager.h"
#include "Map.h"
#include "DBCStores.h"
#include "ObjectMgr.h"
#include "ScriptedGossip.h"
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

/*######
## Repel Boarders! (24934, Alliance): the Northwatch gryphon from Northwatch Hold to the Blackpool and back
######*/

enum RepelBoarders
{
    QUEST_REPEL_BOARDERS            = 24934,

    NPC_ADMIRAL_AUBREY              = 38619,
    NPC_NATHAN_BLAINE               = 38697,
    NPC_CAPTAIN_FISHER              = 38622,
    NPC_NORTHWATCH_GRYPHON_OUT      = 38707,    // 72596 Summon Northwatch Gryphon
    NPC_NORTHWATCH_GRYPHON_BACK     = 38709,    // 72609 Summon Northwatch Gryphon

    BT_RIDE_TO_THE_BLACKPOOL        = 38574,    // "Admiral, can I get a ride to the Blackpool?"
    BT_RIDE_BACK_TO_NORTHWATCH      = 38581,    // "Captain, I need a ride back to Northwatch Hold."
    GOSSIP_ACTION_GRYPHON_RIDE      = 1001,
    NPC_TEXT_AUBREY_HOLD_FAST       = 15393,    // BT 38573 "We must hold fast. If Northwatch falls, there is nothing to our backs but the sea!"
    NPC_TEXT_FISHER_ALL_HANDS       = 15397,    // BT 38580 "All hands topside! Run 'em through!"

    SAY_AUBREY_FLAG_DOWN_A_GRYPHON  = 0,        // BT 38583
    SAY_BLAINE_AYE_AYE              = 0,        // BT 38584
    SAY_FISHER_GODSPEED             = 0,        // BT 38582

    SPELL_GRYPHON_RIDE_HARDCODED    = 46598,    // Ride Vehicle Hardcoded, BP0 = seat + 1
    SUMMON_PROPERTIES_GRYPHON       = 161,      // vehicle category, as 72596 / 72609 (the gryphon is the rider's Minion)
    GRYPHON_RIDER_SEAT              = 0,        // vehicle 1255 seat 8950: usable (flagsB 0x02000000), no exit at will, no control

    POINT_GRYPHON_END               = 1,
};

// ---------------------------------------------------------------------------------------------------------------------------
// The flights (ours: no source has a route; question 17). Sourced shape (video kEpy1ea727k, 6.1, GitGudGuides): gossip with the
// Admiral on the Northwatch tower top, the gryphon lifts off at once, flies out over the bay and sets the player down on the
// Blackpool's deck about 35 s later. The way back is the same in reverse (comment 2012-05-13 [+10] "Captain Fisher gives you a
// ride back"). Checked against the 5.4.8 maps and vmaps (research\northern-barrens\tmp\S4\hmap.py, surf.py): 45 yd or more
// over Northwatch Hold's roofs (96-111), then over the cliff and the bay; the deck landing 6 yd from Captain Fisher on the
// poop deck (21.1), the tower landing on the open platform (131) 8 yd from the Admiral. About 340 yd at 9.8 yd/s each way.
// To change: GryphonSpeedRate; a landing = the last point of its route and its drop position together.
// ---------------------------------------------------------------------------------------------------------------------------
static float const GryphonSpeedRate = 1.4f;

static Position const GryphonTowerLaunchPos = { -2216.0f, -3781.0f, 131.2f, 4.71f };
static Position const GryphonDeckLaunchPos  = { -2161.0f, -4089.0f, 21.2f, 1.75f };

static Position const GryphonRouteOut[] =
{
    { -2215.0f, -3792.0f, 140.0f },
    { -2210.0f, -3830.0f, 150.0f },
    { -2205.0f, -3880.0f, 125.0f },
    { -2212.0f, -3950.0f,  85.0f },
    { -2205.0f, -4020.0f,  55.0f },
    { -2185.0f, -4070.0f,  35.0f },
    { -2168.0f, -4088.0f,  26.0f },
    { -2163.0f, -4092.0f,  22.5f },
};
static Position const GryphonDropOnDeck = { -2161.0f, -4089.0f, 21.2f, 1.0f };      // poop deck, facing Captain Fisher

static Position const GryphonRouteBack[] =
{
    { -2168.0f, -4084.0f,  32.0f },
    { -2185.0f, -4063.0f,  45.0f },
    { -2205.0f, -4010.0f,  70.0f },
    { -2212.0f, -3940.0f, 100.0f },
    { -2208.0f, -3870.0f, 135.0f },
    { -2212.0f, -3820.0f, 150.0f },
    { -2214.0f, -3795.0f, 140.0f },
    { -2214.0f, -3783.0f, 132.5f },
};
static Position const GryphonDropOnTower = { -2214.5f, -3779.0f, 131.2f, 2.6f };    // tower top, facing the Admiral

static std::string GossipText(Player* player, uint32 broadcastTextId)
{
    if (BroadcastText const* text = sObjectMgr->GetBroadcastText(broadcastTextId))
        return text->GetText(player->GetSession()->GetSessionDbcLocale(), player->GetGender());
    return "";
}

// Not for a bot (bots choose no gossip), the dead, a player in combat or one already riding (the Bogpaddle Bullet's rules,
// zone_swamp_of_sorrows_bullet.cpp). Checked before anyone speaks, so a refused ride plays no lines.
static bool CanStartGryphonRide(Player* player)
{
    if (!player->IsInWorld() || player->GetSession()->IsBot() || !player->IsAlive())
        return false;
    if (player->IsInCombat())
    {
        player->SendGameError(GameError::ERR_NOT_IN_COMBAT);
        return false;
    }
    if (player->GetVehicle() || player->IsInFlight())
    {
        player->GetSession()->SendNotification("You can't do that while riding.");
        return false;
    }
    return true;
}

// Summons the gryphon at the launch spot and seats the player (CanStartGryphonRide has passed)
static void StartGryphonRide(Player* player, uint32 gryphonEntry, Position const& launchPos)
{

    SummonPropertiesEntry const* properties = sSummonPropertiesStore.LookupEntry(SUMMON_PROPERTIES_GRYPHON);
    TempSummon* gryphon = player->GetMap()->SummonCreature(gryphonEntry, launchPos, properties, 300s, player);
    if (!gryphon || !gryphon->GetVehicleKit())
    {
        TC_LOG_ERROR("scripts", "zone_ratchet: could not summon the Northwatch Gryphon %u for %s", gryphonEntry, player->GetName().c_str());
        if (gryphon)
            gryphon->DespawnOrUnsummon();
        return;
    }

    player->CastCustomSpell(SPELL_GRYPHON_RIDE_HARDCODED, SPELLVALUE_BASE_POINT0, GRYPHON_RIDER_SEAT + 1, gryphon, true);
    if (player->GetVehicleBase() != gryphon)
    {
        TC_LOG_ERROR("scripts", "zone_ratchet: %s could not be seated on the Northwatch Gryphon", player->GetName().c_str());
        gryphon->DespawnOrUnsummon();
    }
}

// 38619 Admiral Aubrey (Northwatch Hold, the tower top)
// What the player sees (sourced: the quest's log text "Speak to Admiral Aubrey to fly to the Blackpool", BT 38574 / 38583 /
// 38584, comment 2012-05-13 [+10]): on Repel Boarders! he asks "Admiral, can I get a ride to the Blackpool?"; the Admiral calls
// "Mister Blaine? Flag down a gryphon for <name> if you please.", Nathan Blaine answers "Aye aye sir! Immediately, sir!", and a
// Northwatch Gryphon takes him to the ship. His greeting is "We must hold fast..." (wiki; npc_text 15393 exists, no menu row in
// mop or either TDB). Ours: the option only while the quest is in progress; Blaine's line 1.5 s later.
struct npc_ratchet_admiral_aubrey : public ScriptedAI
{
    npc_ratchet_admiral_aubrey(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipHello(Player* player) override
    {
        if (me->IsQuestGiver())
            player->PrepareQuestMenu(me->GetGUID());
        if (player->GetQuestStatus(QUEST_REPEL_BOARDERS) == QUEST_STATUS_INCOMPLETE)
            AddGossipItemFor(player, GOSSIP_ICON_CHAT, GossipText(player, BT_RIDE_TO_THE_BLACKPOOL), GOSSIP_SENDER_MAIN, GOSSIP_ACTION_GRYPHON_RIDE);
        SendGossipMenuFor(player, NPC_TEXT_AUBREY_HOLD_FAST, me->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, uint32 /*menuId*/, uint32 gossipListId) override
    {
        uint32 const action = player->PlayerTalkClass->GetGossipOptionAction(gossipListId);
        CloseGossipMenuFor(player);
        if (action != GOSSIP_ACTION_GRYPHON_RIDE || player->GetQuestStatus(QUEST_REPEL_BOARDERS) != QUEST_STATUS_INCOMPLETE
            || !CanStartGryphonRide(player))
            return true;

        Talk(SAY_AUBREY_FLAG_DOWN_A_GRYPHON, player);
        ObjectGuid const playerGUID = player->GetGUID();
        Creature* aubrey = me;
        me->m_Events.AddLambdaEventAtOffset([aubrey, playerGUID]()
        {
            if (Creature* blaine = aubrey->FindNearestCreature(NPC_NATHAN_BLAINE, 20.0f))
                blaine->AI()->Talk(SAY_BLAINE_AYE_AYE, ObjectAccessor::GetPlayer(*aubrey, playerGUID));
        }, 1500);
        StartGryphonRide(player, NPC_NORTHWATCH_GRYPHON_OUT, GryphonTowerLaunchPos);
        return true;
    }
};

// 38622 Captain Fisher (the Blackpool; ender of Repel Boarders!)
// What the player sees (sourced: comments 2012-05-13 [+10], 2012-02-08 [+1], BT 38581 / 38582): "Captain, I need a ride back to
// Northwatch Hold." - "Godspeed, <class>!" and a gryphon takes him back to the tower; greeting "All hands topside! Run 'em
// through!" (wiki; npc_text 15397). Ours: the option for anyone who can
// talk to him (a player stranded on the ship needs it whatever his quests).
struct npc_ratchet_captain_fisher : public ScriptedAI
{
    npc_ratchet_captain_fisher(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipHello(Player* player) override
    {
        if (me->IsQuestGiver())
            player->PrepareQuestMenu(me->GetGUID());
        AddGossipItemFor(player, GOSSIP_ICON_CHAT, GossipText(player, BT_RIDE_BACK_TO_NORTHWATCH), GOSSIP_SENDER_MAIN, GOSSIP_ACTION_GRYPHON_RIDE);
        SendGossipMenuFor(player, NPC_TEXT_FISHER_ALL_HANDS, me->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, uint32 /*menuId*/, uint32 gossipListId) override
    {
        uint32 const action = player->PlayerTalkClass->GetGossipOptionAction(gossipListId);
        CloseGossipMenuFor(player);
        if (action != GOSSIP_ACTION_GRYPHON_RIDE || !CanStartGryphonRide(player))
            return true;

        Talk(SAY_FISHER_GODSPEED, player);
        StartGryphonRide(player, NPC_NORTHWATCH_GRYPHON_BACK, GryphonDeckLaunchPos);
        return true;
    }
};

// 38707 / 38709 Northwatch Gryphon (vehicle 1255 from the SQL: no gryphon vehicle id exists for them in any source; 1255 is
// the Mullan Gryphon Mount's, the same model 17697, one usable seat with no exit at will - question 17's "nearest fitting
// vehicle"). It lifts off half a second after the player is seated, flies its route and sets him down at its end; if he is
// gone before (logout, death) it despawns.
struct npc_ratchet_northwatch_gryphon : public ScriptedAI
{
    npc_ratchet_northwatch_gryphon(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        me->SetSpeed(MOVE_RUN, GryphonSpeedRate);
        me->SetSpeed(MOVE_FLIGHT, GryphonSpeedRate);
        me->setActive(true, ActiveFlags::Script);
        _timer = 5 * IN_MILLISECONDS;   // never boarded: gone after 5 s
    }

    void JustAppeared() override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        if (passenger->GetTypeId() != TYPEID_PLAYER)
            return;

        if (apply)
        {
            if (_state == STATE_WAITING)
            {
                _state = STATE_TAKE_OFF;
                _timer = 500;
            }
            return;
        }

        if (_state != STATE_DONE)
        {
            _state = STATE_DONE;
            me->DespawnOrUnsummon(1000);
        }
    }

    // Vehicle::RemovePassenger overwrites any exit position with the vehicle's own unless the AI moves it (Vehicle.cpp:776-785)
    void GetPassengerExitPosition(Unit* passenger, int8 /*seatId*/, Position& pos) override
    {
        if (passenger->GetTypeId() == TYPEID_PLAYER && (_state == STATE_LANDED || _state == STATE_DONE))
            pos.Relocate(me->GetEntry() == NPC_NORTHWATCH_GRYPHON_OUT ? GryphonDropOnDeck : GryphonDropOnTower);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == EFFECT_MOTION_TYPE && id == POINT_GRYPHON_END && _state == STATE_FLYING)
        {
            _state = STATE_LANDED;
            _timer = 500;
        }
    }

    void UpdateAI(uint32 diff) override
    {
        if (_state == STATE_FLYING || _state == STATE_DONE)
            return;

        if (_timer > diff)
        {
            _timer -= diff;
            return;
        }

        bool const out = me->GetEntry() == NPC_NORTHWATCH_GRYPHON_OUT;
        switch (_state)
        {
            case STATE_WAITING:
                _state = STATE_DONE;
                me->DespawnOrUnsummon();
                break;
            case STATE_TAKE_OFF:
                _state = STATE_FLYING;
                if (out)
                    me->GetMotionMaster()->MoveSmoothPath(POINT_GRYPHON_END, GryphonRouteOut, std::extent<decltype(GryphonRouteOut)>::value, false, true);
                else
                    me->GetMotionMaster()->MoveSmoothPath(POINT_GRYPHON_END, GryphonRouteBack, std::extent<decltype(GryphonRouteBack)>::value, false, true);
                break;
            case STATE_LANDED:
                SetRiderDown();
                _state = STATE_DONE;
                me->DespawnOrUnsummon(1000);
                break;
            default:
                break;
        }
    }

private:
    enum GryphonState
    {
        STATE_WAITING,
        STATE_TAKE_OFF,
        STATE_FLYING,
        STATE_LANDED,
        STATE_DONE
    };

    // The rider lands on the drop spot (GetPassengerExitPosition, state LANDED)
    void SetRiderDown()
    {
        Vehicle* kit = me->GetVehicleKit();
        if (!kit)
            return;

        Unit* rider = kit->GetPassenger(GRYPHON_RIDER_SEAT);
        if (!rider)
        {
            kit->RemoveAllPassengers();
            return;
        }

        rider->ExitVehicle();
    }

    GryphonState _state = STATE_WAITING;
    uint32 _timer = 0;
};

// A rider who logged out in flight is saved where the gryphon was, up to 150 yd over the bay or Northwatch Hold, and would
// fall at the next login (his summons go with him). Before he enters the world he is moved to the tower top when all of these
// hold: map 1, within 30 yd of either flight's path (launch spot to the last point), not on the Blackpool (below z 40 inside
// the ship's box: at login the ship's collision may not be loaded and its deck would read as the bay's surface), no mount or
// flight aura, 15 yd or more above the ground or water below him. Ours (no source says what retail did).
class player_ratchet_northwatch_gryphon : public PlayerScript
{
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

    static bool IsNearGryphonPath(Position const& pos, Position const& launch, Position const* route, size_t count)
    {
        Position prev = launch;
        for (size_t i = 0; i < count; ++i)
        {
            if (DistToSegment(pos, prev, route[i]) <= 30.0f)
                return true;
            prev = route[i];
        }
        return false;
    }

public:
    player_ratchet_northwatch_gryphon() : PlayerScript("player_ratchet_northwatch_gryphon") { }

    void OnLoadFromDB(Player* player) override
    {
        if (player->GetMapId() != 1 || player->HasAuraType(SPELL_AURA_MOUNTED) || player->HasAuraType(SPELL_AURA_FLY)
            || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
            return;

        Position const pos = player->GetPosition();
        if (pos.GetPositionX() < -2240.0f || pos.GetPositionX() > -2140.0f || pos.GetPositionY() < -4110.0f || pos.GetPositionY() > -3770.0f)
            return;
        if (pos.GetPositionZ() < 40.0f && pos.GetPositionX() > -2185.0f && pos.GetPositionX() < -2135.0f
            && pos.GetPositionY() > -4110.0f && pos.GetPositionY() < -4060.0f)
            return;
        if (!IsNearGryphonPath(pos, GryphonTowerLaunchPos, GryphonRouteOut, std::extent<decltype(GryphonRouteOut)>::value)
            && !IsNearGryphonPath(pos, GryphonDeckLaunchPos, GryphonRouteBack, std::extent<decltype(GryphonRouteBack)>::value))
            return;

        Map* map = sMapMgr->FindBaseNonInstanceMap(1);
        if (!map)
            return;
        float const below = map->GetWaterOrGroundLevel(PHASEMASK_NORMAL, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ());
        if (pos.GetPositionZ() < below + 15.0f)
            return;

        TC_LOG_DEBUG("scripts", "player_ratchet_northwatch_gryphon: %s logged in on the Northwatch Gryphon's path at %.1f %.1f %.1f, moved to the tower top",
            player->GetName().c_str(), pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ());
        player->Relocate(GryphonDropOnTower);
        player->SetFallInformation(0, GryphonDropOnTower.GetPositionZ());
    }
};

/*######
## Mutiny, Mon! (14063): Tony Two-Tusk takes the Maiden's Dagger
######*/

enum MutinyMon
{
    QUEST_MUTINY_MON                = 14063,

    NPC_TONY_TWO_TUSK               = 34749,    // the quest giver on Fray Island; the event copy is a summon of the same entry
    NPC_ALICIA_CUTHBERT             = 34782,
    NPC_SOUTHSEA_MUTINEER           = 34790,
    NPC_SOUTHSEA_CANNONEER          = 3382,
    NPC_SOUTHSEA_CUTTHROAT_DECK     = 3383,

    SPELL_MUTINY_COMPLETE           = 66226,    // KILL_CREDIT2 34782 to the units within 25 yd of the caster (source-13 condition: quest)
    SPELL_SWASHBUCKLING_SLICE       = 75361,    // Tony's template spell1

    FACTION_MUTINEERS               = 106,      // the mutineers' faction: Horde friendly, Alliance hostile, hostile to 230 and 14
    FACTION_FREEBOOTERS_HOSTILE     = 230,      // the Privateers': the deck pirates the crew can fight
    FACTION_ALICIA_HOSTILE          = 14,       // mop's old SmartAI turned her to 14 on the horn; 106 fights 14

    // creature_text 34749 (Tony, event copy)
    SAY_TONY_TAKE_THE_SHIP          = 0,        // BT 35072 (yell)
    SAY_TONY_BELOW_DECKS            = 1,        // BT 35073
    SAY_TONY_THERE_SHE_IS           = 2,        // BT 35076
    SAY_TONY_HELP_ME                = 3,        // BT 35082
    SAY_TONY_COUNTING_ON_IT         = 4,        // BT 35083
    SAY_TONY_WE_DID_IT              = 5,        // BT 35084
    SAY_TONY_TELL_DIZZYWIG          = 6,        // BT 35085
    EMOTE_TONY_MUTINY               = 7,        // BT 35074 "Mutiny!" (boss emote)
    // creature_text 34782 (Alicia): 0 BT 35077 (her gossip text, exists), 1-3 below
    SAY_ALICIA_TRAITOR              = 1,        // BT 35078
    SAY_ALICIA_ANOTHER_MUTINY       = 2,        // BT 35079 (Tony died)
    SAY_ALICIA_GARVEY_WILL_HEAR     = 3,        // BT 35080 (her death)

    DATA_MUTINY_STARTER             = 1,
    ACTION_ALICIA_FIGHT             = 1,
    ACTION_ALICIA_GLOAT             = 2,

    POINT_TONY_DECK                 = 1,
    POINT_TONY_WALK                 = 2,        // + index
};

// ---------------------------------------------------------------------------------------------------------------------------
// Positions. The Maiden's Dagger lies along the pier north of it (video 5v0vT0w6LUI: the player walks out along the pier and
// climbs aboard; the crew is fighting on the upper deck within seconds of the horn). Sniff-derived: the four looping
// mutineers' paths (mop 265911 / 265912 / 265914 / 265915, deleted with this event) each ended on a deck spot, and 265911
// started on the pier; those deck spots are where the crew lands. Alicia's cabin spot is her old static spawn 265913.
// Ours: the crew's and Tony's start spots on the pier, Tony's deck spot, and his way below decks (main deck 10.4 -> the stair
// at x -1659 down to the lower deck 5.3 -> aft to the cabin), read from the 5.4.8 vmaps (research\northern-barrens\tmp\S4).
// ---------------------------------------------------------------------------------------------------------------------------
static Position const TonyPierPos           = { -1662.0f, -4356.0f, 4.45f, 4.71f };
static Position const TonyDeckPos           = { -1664.0f, -4377.5f, 10.6f, 4.71f };
static Position const MutineerPierPos[4]    =
{
    { -1673.1f, -4358.3f, 4.45f, 4.71f },   // sniffed start of 265911
    { -1668.0f, -4355.0f, 4.45f, 4.71f },
    { -1680.0f, -4356.0f, 4.45f, 4.71f },
    { -1686.0f, -4357.0f, 4.45f, 4.71f },
};
static Position const MutineerDeckPos[4]    =
{
    { -1670.9f, -4375.8f, 10.59f, 4.71f },  // 265911's end
    { -1650.4f, -4385.7f, 16.43f, 3.14f },  // 265912's end (poop deck)
    { -1672.4f, -4387.4f, 10.61f, 1.57f },  // 265914's end
    { -1690.5f, -4385.7f, 10.79f, 0.00f },  // 265915's end
};
static Position const TonyBelowDecksPath[]  =
{
    { -1659.0f, -4378.5f, 10.4f },          // top of the stair
    { -1659.0f, -4387.5f, 5.35f },          // foot of the stair
    { -1652.0f, -4386.0f, 5.35f },
    { -1646.5f, -4384.5f, 5.35f },          // 4.5 yd from Alicia
};
static Position const AliciaCabinPos        = { -1642.1f, -4383.7f, 5.4f, 2.34f };
static Position const MaidensDaggerCenter   = { -1668.0f, -4380.0f, 10.6f, 0.0f };

// Ours: the deck fight lasts 8-20 s (the video: about 20 s), Tony takes a third of any creature's damage and deals Alicia double
// (her 712 hp against his 356 at level 16: alone he wins in about a minute at about two thirds of his health, with a player
// in about half that; the video's fight below decks took about 40 s); "Help me out here, mon!" below 70 % of his health in
// her fight; 60 s with no player within 60 yd ends the event; the crew and Tony leave 30 s after the credit.
static constexpr Milliseconds MutinyDeckFightMin      = 8s;
static constexpr Milliseconds MutinyDeckFightMax      = 20s;
static constexpr uint32       MutinyNoPlayerAbortTicks = 12;        // x 5 s
static constexpr float        MutinyPlayerRange        = 60.0f;

static ObjectGuid sMutinyTonyGUID;      // the lock: one mutiny at a time (question 13)

// 34782 Alicia Cuthbert (only the event's summon exists; mop's static copy 265913 is deleted)
// What the player sees (sourced: comments 2012-01-14 [+4], 2011-03-29 [+4] and reply [+2]; BT 35077-35080; the wiki): she is
// not on the ship until the horn sounds; then she waits in her cabin and greets with "Do not trifle with me, <race>."; when Tony
// comes in she says "I should've known you were behind this, Two-Tusk. Have at it, traitor!" and they fight; dying, "Cap'n
// Garvey will hear of this!"; if Tony falls, "Another mutiny put to rest. Now get this blood off my decks!".
// Ours: faction 14 for the fight (106 fights 14), double damage from Tony.
struct npc_ratchet_alicia_cuthbert : public ScriptedAI
{
    npc_ratchet_alicia_cuthbert(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->SetReactState(REACT_PASSIVE);
    }

    void SetGUID(ObjectGuid guid, int32 /*id*/) override
    {
        _tonyGUID = guid;
    }

    void DoAction(int32 action) override
    {
        switch (action)
        {
            case ACTION_ALICIA_FIGHT:
                if (_fighting)
                    return;
                _fighting = true;
                Talk(SAY_ALICIA_TRAITOR);
                me->ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
                me->SetFaction(FACTION_ALICIA_HOSTILE);
                me->SetReactState(REACT_AGGRESSIVE);
                if (Creature* tony = ObjectAccessor::GetCreature(*me, _tonyGUID))
                    AttackStart(tony);
                break;
            case ACTION_ALICIA_GLOAT:
                if (me->IsAlive())
                    Talk(SAY_ALICIA_ANOTHER_MUTINY);
                break;
            default:
                break;
        }
    }

    void DamageTaken(Unit* attacker, uint32& damage) override
    {
        if (attacker && attacker->GetGUID() == _tonyGUID)
            damage *= 2;
    }

    void JustDied(Unit* /*killer*/) override
    {
        Talk(SAY_ALICIA_GARVEY_WILL_HEAR);
    }

    // She stays in her cabin whatever happens; the event despawns her
    void EnterEvadeMode(EvadeReason why) override
    {
        if (!_fighting)
            return;
        ScriptedAI::EnterEvadeMode(why);
        me->SetFaction(FACTION_ALICIA_HOSTILE);   // an evade keeps the faction already; set again for clarity after LoadCreaturesAddon
    }

    void UpdateAI(uint32 /*diff*/) override
    {
        if (!UpdateVictim())
            return;
        DoMeleeAttackIfReady();
    }

private:
    ObjectGuid _tonyGUID;
    bool _fighting = false;
};

// 34749 Tony Two-Tusk. The static giver on Fray Island is never summoned and keeps the plain behaviour; the event copy runs the
// mutiny (summoned by the horn's spell script, no summoner, so it outlives the horn blower's logout).
// What the player sees (sourced: beta comment [+24], comments 2011-03-29 [+4], 2012-01-14 [+4], the quest and wiki texts, BT
// 35072-35085, video 5v0vT0w6LUI): on the horn a boss emote "Mutiny!"; Tony and his men come aboard from the pier and fall on
// the pirates on deck, Tony yelling "C'mon mates! Take the ship and give no quarter!"; then "Right, Cuthbert should be below
// decks. Come with me, mon!" and he goes below; at her cabin "There she is, mon! Let's finish this business." and the fight with
// Alicia; he may call "Help me out here, mon!"; when she falls "I'm countin' on it!", "We did it! The Maiden's Dagger is mine,
// all mine!" with the Mutiny Complete credit to everyone within 25 yd (players on the quest), and "You tell Dizzywig that I'm
// open to negotiations....". If Tony dies (an Alliance player can kill him) the quest fails for the players taking part, who
// abandon and retake it.
// Ours: one mutiny at a time on the ship instead of a ship phased per player (question 13; a second horn blower gets a notice
// and the credit too if he is within 25 yd at the end; the lock is held until the crew and Tony are gone, 30 s after the credit,
// or the event fails or is abandoned); a 20 s failsafe puts Tony at the cabin should his walk below decks be interrupted; four mutineers; the deck's neutral Cutthroats (and Cannoneers, should
// they still be 190) turned to the Privateers' 230 for the event and back after it, so the crew can fight them; Tony's walk
// and timings; no quest marks on the copy; the despawns and the 60 s no-player abort.
struct npc_ratchet_tony_two_tusk : public ScriptedAI
{
    npc_ratchet_tony_two_tusk(Creature* creature) : ScriptedAI(creature), _summons(creature) { }

    bool IsEventCopy() const { return me->IsSummon(); }

    void SetGUID(ObjectGuid guid, int32 id) override
    {
        if (id != DATA_MUTINY_STARTER || !IsEventCopy() || _state != STATE_NONE)
            return;
        _starterGUID = guid;
        Begin();
    }

    void Begin()
    {
        sMutinyTonyGUID = me->GetGUID();
        _state = STATE_BOARDING;
        me->ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
        me->SetFaction(FACTION_MUTINEERS);
        me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);
        me->SetEmoteState(EMOTE_ONESHOT_NONE);
        me->SetReactState(REACT_PASSIVE);
        me->setActive(true, ActiveFlags::Script);

        Player* starter = ObjectAccessor::GetPlayer(*me, _starterGUID);
        Talk(EMOTE_TONY_MUTINY, starter);

        // Alicia appears in her cabin with the horn
        if (TempSummon* alicia = me->SummonCreature(NPC_ALICIA_CUTHBERT, AliciaCabinPos, TEMPSUMMON_MANUAL_DESPAWN))
        {
            _aliciaGUID = alicia->GetGUID();
            alicia->AI()->SetGUID(me->GetGUID(), 0);
        }

        // The deck's neutral pirates join the Privateers' side for the event
        std::list<Creature*> pirates;
        for (uint32 entry : { uint32(NPC_SOUTHSEA_CANNONEER), uint32(NPC_SOUTHSEA_CUTTHROAT_DECK) })
            me->GetCreatureListWithEntryInGridAppend(pirates, entry, 60.0f);
        for (Creature* pirate : pirates)
            if (pirate->IsAlive() && !pirate->IsSummon() && pirate->GetExactDist(&MaidensDaggerCenter) < 35.0f
                && pirate->GetFaction() != FACTION_FREEBOOTERS_HOSTILE)
            {
                pirate->SetFaction(FACTION_FREEBOOTERS_HOSTILE);
                _switchedPirates.push_back(pirate->GetGUID());
            }

        // The crew comes off the pier, one after the other
        for (uint8 i = 0; i < 4; ++i)
            if (TempSummon* mutineer = me->SummonCreature(NPC_SOUTHSEA_MUTINEER, MutineerPierPos[i], TEMPSUMMON_MANUAL_DESPAWN))
            {
                ObjectGuid const guid = mutineer->GetGUID();
                Position const deck = MutineerDeckPos[i];
                mutineer->SetReactState(REACT_PASSIVE);
                mutineer->SetHomePosition(deck);
                Creature* tony = me;
                me->m_Events.AddLambdaEventAtOffset([tony, guid, deck]()
                {
                    if (Creature* crew = ObjectAccessor::GetCreature(*tony, guid))
                        crew->GetMotionMaster()->MoveJump(deck, 18.0f, 10.0f);
                }, 300 + i * 400);
                me->m_Events.AddLambdaEventAtOffset([tony, guid]()
                {
                    if (Creature* crew = ObjectAccessor::GetCreature(*tony, guid))
                        if (crew->IsAlive())
                        {
                            crew->SetReactState(REACT_AGGRESSIVE);
                            if (Unit* target = crew->SelectNearestTarget(30.0f))
                                crew->AI()->AttackStart(target);
                        }
                }, 2500 + i * 400);
            }

        me->GetMotionMaster()->MoveJump(TonyDeckPos, 18.0f, 10.0f, POINT_TONY_DECK);
        _events.ScheduleEvent(EVENT_TONY_PLAYER_CHECK, 5s);
    }

    void JustSummoned(Creature* summon) override
    {
        _summons.Summon(summon);
    }

    void SummonedCreatureDies(Creature* summon, Unit* /*killer*/) override
    {
        if (summon->GetEntry() == NPC_ALICIA_CUTHBERT && _state == STATE_DUEL)
            Victory();
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (!IsEventCopy())
            return;

        if (type == EFFECT_MOTION_TYPE && id == POINT_TONY_DECK && _state == STATE_BOARDING)
        {
            _state = STATE_DECK;
            me->SetHomePosition(TonyDeckPos);
            Talk(SAY_TONY_TAKE_THE_SHIP);
            me->SetReactState(REACT_AGGRESSIVE);
            if (Unit* target = me->SelectNearestTarget(30.0f))
                AttackStart(target);
            _events.ScheduleEvent(EVENT_TONY_DECK_CHECK, MutinyDeckFightMin);
            _events.ScheduleEvent(EVENT_TONY_GO_BELOW, MutinyDeckFightMax);
            _events.ScheduleEvent(EVENT_TONY_SLICE, 5s);
            return;
        }

        if (type == POINT_MOTION_TYPE && id >= POINT_TONY_WALK && _state == STATE_WALK)
        {
            uint32 const next = id - POINT_TONY_WALK + 1;
            if (next < std::extent<decltype(TonyBelowDecksPath)>::value)
            {
                Position const& pos = TonyBelowDecksPath[next];
                me->GetMotionMaster()->MovePoint(POINT_TONY_WALK + next, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), false);
                return;
            }

            ArriveAtCabin();
        }
    }

    void ArriveAtCabin()
    {
        if (_state != STATE_WALK)
            return;
        _state = STATE_CABIN;
        _events.CancelEvent(EVENT_TONY_WALK_TIMEOUT);
        me->SetHomePosition(me->GetPosition());
        Creature* alicia = ObjectAccessor::GetCreature(*me, _aliciaGUID);
        if (!alicia || !alicia->IsAlive())
        {
            Victory();
            return;
        }
        me->SetFacingToObject(alicia);
        Talk(SAY_TONY_THERE_SHE_IS);
        _events.ScheduleEvent(EVENT_TONY_DUEL, 3s);
    }

    void GoBelowDecks()
    {
        if (_state != STATE_DECK)
            return;
        _state = STATE_WALK;
        _events.CancelEvent(EVENT_TONY_DECK_CHECK);
        _events.CancelEvent(EVENT_TONY_GO_BELOW);
        _events.CancelEvent(EVENT_TONY_SLICE);
        me->SetReactState(REACT_PASSIVE);
        me->CombatStop(true);
        me->GetThreatManager().ClearAllThreat();
        me->SetFullHealth();
        Talk(SAY_TONY_BELOW_DECKS);
        Position const& pos = TonyBelowDecksPath[0];
        me->GetMotionMaster()->MovePoint(POINT_TONY_WALK, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), false);
        // The walk takes about 5 s; should a stun, knockback or anything else replace the point movement, he is put at the cabin
        _events.ScheduleEvent(EVENT_TONY_WALK_TIMEOUT, 20s);
    }

    void StartDuel()
    {
        Creature* alicia = ObjectAccessor::GetCreature(*me, _aliciaGUID);
        if (!alicia || !alicia->IsAlive())
        {
            Victory();
            return;
        }
        _state = STATE_DUEL;
        alicia->AI()->DoAction(ACTION_ALICIA_FIGHT);
        me->SetReactState(REACT_AGGRESSIVE);
        AttackStart(alicia);
        _events.ScheduleEvent(EVENT_TONY_SLICE, 4s);
    }

    void Victory()
    {
        if (_state == STATE_OUTRO || _state == STATE_DONE)
            return;
        _state = STATE_OUTRO;
        // The lock is kept until the crew and Tony are gone (Abort), so a second horn cannot start a second crew beside them
        _events.CancelEvent(EVENT_TONY_SLICE);
        me->SetReactState(REACT_PASSIVE);
        me->CombatStop(true);
        me->GetThreatManager().ClearAllThreat();
        _events.ScheduleEvent(EVENT_TONY_COUNTING_ON_IT, 2s);
        _events.ScheduleEvent(EVENT_TONY_WE_DID_IT, 5s);
        _events.ScheduleEvent(EVENT_TONY_TELL_DIZZYWIG, 9s);
        _events.ScheduleEvent(EVENT_TONY_LEAVE, 39s);
    }

    void AttackStart(Unit* who) override
    {
        if (!IsEventCopy() || _state == STATE_DECK || _state == STATE_DUEL)
            ScriptedAI::AttackStart(who);
    }

    void MoveInLineOfSight(Unit* who) override
    {
        if (!IsEventCopy() || _state == STATE_DECK || _state == STATE_DUEL)
            ScriptedAI::MoveInLineOfSight(who);
    }

    // The copy never goes home to the pier or reloads its addon (the giver's emote state): it only drops the fight
    void EnterEvadeMode(EvadeReason why) override
    {
        if (!IsEventCopy())
        {
            ScriptedAI::EnterEvadeMode(why);
            return;
        }
        me->CombatStop(true);
        me->GetThreatManager().ClearAllThreat();
        me->ResetPlayerDamageReq();
    }

    void DamageTaken(Unit* attacker, uint32& damage) override
    {
        if (!IsEventCopy() || !attacker || attacker->GetTypeId() != TYPEID_UNIT || attacker->IsControlledByPlayer())
            return;

        damage /= 3;
        if (_state == STATE_DUEL && !_askedForHelp && me->HealthBelowPctDamaged(70, damage))
        {
            _askedForHelp = true;
            Talk(SAY_TONY_HELP_ME);
        }
    }

    void JustDied(Unit* /*killer*/) override
    {
        if (!IsEventCopy())
            return;
        // Sourced (comment 2011-03-29 [+4]): "It's possible to fail the quest if an Alliance player ... kills Tony Two-Tusk."
        // Ours: who took part = players with the quest in progress within 60 yd of Tony (the ship and its pier); they abandon
        // and retake it (the horn is provided again). Only Tony's death fails it; the no-player and timeout ends do not.
        if (_state != STATE_OUTRO)
        {
            std::list<Player*> players = me->GetNearestPlayersList(MutinyPlayerRange, false);
            for (Player* player : players)
                if (player->GetQuestStatus(QUEST_MUTINY_MON) == QUEST_STATUS_INCOMPLETE)
                    player->FailQuest(QUEST_MUTINY_MON);
        }
        _state = STATE_DONE;
        if (Creature* alicia = ObjectAccessor::GetCreature(*me, _aliciaGUID))
            alicia->AI()->DoAction(ACTION_ALICIA_GLOAT);
        ReleaseLock();
        RestorePirates();
        _summons.DespawnAll(5000);
        me->DespawnOrUnsummon(10 * IN_MILLISECONDS);
    }

    void Unsummoned() override
    {
        ReleaseLock();
        RestorePirates();
        _summons.DespawnAll();
    }

    void ReleaseLock()
    {
        if (sMutinyTonyGUID == me->GetGUID())
            sMutinyTonyGUID.Clear();
    }

    void RestorePirates()
    {
        for (ObjectGuid const& guid : _switchedPirates)
            if (Creature* pirate = ObjectAccessor::GetCreature(*me, guid))
                if (pirate->IsAlive())
                    pirate->RestoreFaction();
        _switchedPirates.clear();
    }

    void Abort()
    {
        _state = STATE_DONE;
        ReleaseLock();
        RestorePirates();
        _summons.DespawnAll();
        me->DespawnOrUnsummon();
    }

    void UpdateAI(uint32 diff) override
    {
        if (!IsEventCopy())
        {
            if (!UpdateVictim())
                return;
            DoMeleeAttackIfReady();
            return;
        }

        if (_state == STATE_NONE || _state == STATE_DONE)
            return;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_TONY_PLAYER_CHECK:
                {
                    Player* player = me->FindNearestPlayer(MutinyPlayerRange);
                    _noPlayerTicks = (player && player->IsAlive()) ? 0 : _noPlayerTicks + 1;
                    if (_noPlayerTicks >= MutinyNoPlayerAbortTicks && _state != STATE_OUTRO)
                    {
                        Abort();
                        return;
                    }
                    _events.ScheduleEvent(EVENT_TONY_PLAYER_CHECK, 5s);
                    break;
                }
                case EVENT_TONY_DECK_CHECK:
                    // Down to the cabin early once nothing on deck fights him any more
                    if (!me->IsInCombat())
                        GoBelowDecks();
                    else
                        _events.ScheduleEvent(EVENT_TONY_DECK_CHECK, 2s);
                    break;
                case EVENT_TONY_GO_BELOW:
                    GoBelowDecks();
                    break;
                case EVENT_TONY_SLICE:
                    if (me->GetVictim())
                        DoCastVictim(SPELL_SWASHBUCKLING_SLICE);
                    _events.ScheduleEvent(EVENT_TONY_SLICE, 12s, 16s);
                    break;
                case EVENT_TONY_DUEL:
                    StartDuel();
                    break;
                case EVENT_TONY_COUNTING_ON_IT:
                    Talk(SAY_TONY_COUNTING_ON_IT);
                    break;
                case EVENT_TONY_WE_DID_IT:
                    Talk(SAY_TONY_WE_DID_IT);
                    DoCastSelf(SPELL_MUTINY_COMPLETE, true);
                    break;
                case EVENT_TONY_TELL_DIZZYWIG:
                    Talk(SAY_TONY_TELL_DIZZYWIG, ObjectAccessor::GetPlayer(*me, _starterGUID));
                    break;
                case EVENT_TONY_WALK_TIMEOUT:
                    if (_state == STATE_WALK)
                    {
                        Position const& last = TonyBelowDecksPath[std::extent<decltype(TonyBelowDecksPath)>::value - 1];
                        me->GetMotionMaster()->Clear();
                        me->NearTeleportTo(last.GetPositionX(), last.GetPositionY(), last.GetPositionZ(), me->GetOrientation());
                        ArriveAtCabin();
                    }
                    break;
                case EVENT_TONY_LEAVE:
                    Abort();
                    return;
                default:
                    break;
            }
            if (_state == STATE_DONE)
                return;
        }

        if (_state != STATE_DECK && _state != STATE_DUEL)
            return;

        // In her cabin: back at her whenever nothing else holds him (an evade of hers, a CC on him)
        if (_state == STATE_DUEL && !me->GetVictim())
            if (Creature* alicia = ObjectAccessor::GetCreature(*me, _aliciaGUID))
                if (alicia->IsAlive())
                    AttackStart(alicia);

        if (!UpdateVictim())
            return;
        DoMeleeAttackIfReady();
    }

private:
    enum TonyState
    {
        STATE_NONE,
        STATE_BOARDING,
        STATE_DECK,
        STATE_WALK,
        STATE_CABIN,
        STATE_DUEL,
        STATE_OUTRO,
        STATE_DONE
    };

    enum TonyEvents
    {
        EVENT_TONY_PLAYER_CHECK = 1,
        EVENT_TONY_DECK_CHECK,
        EVENT_TONY_GO_BELOW,
        EVENT_TONY_SLICE,
        EVENT_TONY_DUEL,
        EVENT_TONY_COUNTING_ON_IT,
        EVENT_TONY_WE_DID_IT,
        EVENT_TONY_TELL_DIZZYWIG,
        EVENT_TONY_LEAVE,
        EVENT_TONY_WALK_TIMEOUT,
    };

    SummonList _summons;
    EventMap _events;
    GuidVector _switchedPirates;
    ObjectGuid _starterGUID;
    ObjectGuid _aliciaGUID;
    TonyState _state = STATE_NONE;
    uint32 _noPlayerTicks = 0;
    bool _askedForHelp = false;
};

// 66204 Blow Pirate Signal Horn (the Pirate Signal Horn 46838; focus 1617 "The Maiden's Dagger" 301018 on the deck). Effect 0
// SEND_EVENT 21888: instead of mop's event script (which summoned Mount Hyjal's level-1 Tony 52235 for 1 s as a trigger), the
// event Tony is summoned on the pier and starts the mutiny, for a player with the quest in progress, unless a mutiny is
// already under way (question 13: a notice, ours).
class spell_ratchet_blow_pirate_signal_horn : public SpellScript
{
    PrepareSpellScript(spell_ratchet_blow_pirate_signal_horn);

    void HandleSendEvent(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);

        Player* player = GetCaster() ? GetCaster()->ToPlayer() : nullptr;
        if (!player || player->GetQuestStatus(QUEST_MUTINY_MON) != QUEST_STATUS_INCOMPLETE)
            return;

        if (!sMutinyTonyGUID.IsEmpty())
        {
            if (Creature* tony = ObjectAccessor::GetCreature(*player, sMutinyTonyGUID))
                if (tony->IsAlive() && tony->IsInWorld())
                {
                    player->GetSession()->SendNotification("The mutiny is already under way!");
                    return;
                }
            sMutinyTonyGUID.Clear();
        }

        if (TempSummon* tony = player->GetMap()->SummonCreature(NPC_TONY_TWO_TUSK, TonyPierPos, nullptr, 360s))
            tony->AI()->SetGUID(player->GetGUID(), DATA_MUTINY_STARTER);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_ratchet_blow_pirate_signal_horn::HandleSendEvent, EFFECT_0, SPELL_EFFECT_SEND_EVENT);
    }
};

void AddSC_ratchet()
{
    RegisterGameObjectAI(go_ratchet_curious_pirate_landmark);
    new creature_script<npc_ratchet_riverboat>("npc_ratchet_riverboat");
    new creature_script<npc_ratchet_admiral_aubrey>("npc_ratchet_admiral_aubrey");
    new creature_script<npc_ratchet_captain_fisher>("npc_ratchet_captain_fisher");
    new creature_script<npc_ratchet_northwatch_gryphon>("npc_ratchet_northwatch_gryphon");
    new player_ratchet_northwatch_gryphon();
    new creature_script<npc_ratchet_alicia_cuthbert>("npc_ratchet_alicia_cuthbert");
    new creature_script<npc_ratchet_tony_two_tusk>("npc_ratchet_tony_two_tusk");
    new spell_script<spell_ratchet_blow_pirate_signal_horn>("spell_ratchet_blow_pirate_signal_horn");
}
