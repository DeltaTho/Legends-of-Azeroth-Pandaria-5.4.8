/*
 * Northern Barrens / Ashenvale border: the three Brutusk rides of the Mor'shan Rampart chain and Kadrak's gossip.
 *
 *   13628 Got Wood?             Kadrak's reins, Brutusk 33386 carries the player from Mor'shan to the Warsong Labor Camp.
 *   13653 Crisis at Splintertree Gorka rides Brutusk II 33509 back to Mor'shan with the player behind her and dies there.
 *   13712 To the Rescue!        Kadrak rides Brutusk III 34007 to Splintertree Post; Brutusk dies at the gate. Since 5.3 a
 *                               wind rider shortcut (here: the existing taxi path 1253, Mor'shan -> Splintertree).
 *
 * Research: research\northern-barrens\dossiers\A.md (event briefs E1-E3, the 13628 / 13653 / 13712 walks), plan.md "S3",
 * second-pass.md (video timings), coders\s3.md (this coder's report: the state walks and what is ours). Neither TDB nor
 * TCPP scripts any of these rides; the spells, summon spots and every line are 5.4.8 data (Spell / SpellEffect DBC,
 * spell_target_position, broadcast_text). Routes, timings, actor positions and counts are ours (questions.md Q4) and are
 * kept in the tables below so they are easy to change.
 *
 * Vehicles (DBC, settled 2026-11-20):
 *   33386 VehicleId 360: one seat 3406 (flags 0x4010800f, flagsB 0): no CAN_ENTER_OR_EXIT, not "usable by override", so the
 *         ride spell 62896 with seat -1 never seats the clicker (core issue C109). spell_nb_ride_brutusk names seat 0.
 *   33509 / 34007 VehicleId 366 (set by this section's SQL; VehicleId 0 in mop and both TDBs): seat 0 = 3546 attach 21 (the
 *         saddle, not enterable, passenger not selectable) for Gorka / Kadrak, seat 1 = 3549 attach 5 (-1, 0, 1.5) behind
 *         it, CAN_ENTER_OR_EXIT, for the player. Dossier A guessed 386 for 34007 (two seats, neither enterable): in this
 *         core two CONTROL_VEHICLE auras stack on one vehicle only while an enterable seat is free (Aura::CanStackWith),
 *         so with 386 the second rider would push the first off. 386 needs the C109 core fix (CanEnterOrExit accepting
 *         the lower-anim bits, as TrinityCore master does) before it can carry Kadrak and a player.
 *   The NPC rider is seated first (seat 0 by name), the player second (seat 1 by name): while the player boards, seat 1 is
 *   still free and enterable, so both ride auras stay.
 *
 * Private rides (questions.md Q5, default): every vehicle, rider and scene actor of 13653 / 13712 is summoned by the player
 * as a private object, so each player gets his own ride, players outside his group see none of it (his group does:
 * WorldObject::CheckPrivateObjectOwnerVisibility shows private objects to the owner's group, but they hear no line) and the
 * live mobs of the road cannot see (or attack) it. Lines go out with TextRange 5. 13628's Brutusk comes from the clicker's
 * own Ride Brutusk spell (62885, SummonProperties 1601, not personal): one per click, visible to all, unattackable.
 *
 * No leaving mid-ride (ours; the 13712 comment 2011-12-12 says you could not hearth or "stuck" off the kodo, nothing says you
 * could step off): seat 3549 shows a leave button, so a passenger who leaves on his own (alive, same map, not being
 * teleported or logging out, still beside Brutusk) is seated again at once. Death, logout and teleports still end the ride.
 *
 * The ambush and road-block speakers of 13628 / 13653 are mop's static Ashenvale Ambushers 33394 and Assailants 33569 where
 * they stand by the road: those spawns are in neither TDB (mop's own), so the script falls back to private copies (34101 /
 * 34013) whenever none is free, and works unchanged should an Ashenvale pass remove them.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "ObjectAccessor.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "MotionMaster.h"
#include "Map.h"
#include "World.h"
#include "WorldSession.h"
#include "DBCStores.h"
#include <cmath>
#include <type_traits>

enum MorshanRides
{
    // Quests
    QUEST_GOT_WOOD                  = 13628,
    QUEST_CRISIS_AT_SPLINTERTREE    = 13653,
    QUEST_TO_THE_RESCUE             = 13712,

    // Creatures
    NPC_KADRAK                      = 8582,    // Mor'shan, giver of 13712, ender of 13653, the reins
    NPC_BRUTUSK_PARKED              = 33374,   // the parked kodo at Mor'shan (spellclick, objective of 13628)
    NPC_BRUTUSK_GOT_WOOD            = 33386,   // 62885's vehicle (VehicleId 360)
    NPC_GORKA                       = 33421,   // Warsong Labor Camp, giver of 13653
    NPC_GORKA_RIDER                 = 33507,   // objective of 13653
    NPC_BRUTUSK_CRISIS              = 33509,   // Brutusk II (63162)
    NPC_KADRAK_RIDER                = 34006,   // 64240
    NPC_BRUTUSK_RESCUE              = 34007,   // Brutusk III (64239), objective of 13712
    NPC_ASHENVALE_AMBUSHER          = 33394,   // 4 static spawns where 13628's ambush is (1384-1397, -2233..-2284)
    NPC_ASHENVALE_ASSAILANT         = 33569,   // 12 static spawns; the squad at (1457-1471, -2316..-2327) blocks 13653's road
    NPC_SCENE_BOWMAN                = 34012,   // faction 1802 scene actors (no spawns in mop): summoned for the rides
    NPC_SCENE_ASSAILANT             = 34013,
    NPC_SCENE_SPLINTERTREE_GUARD    = 34052,
    NPC_SCENE_SKIRMISHER            = 34101,
    NPC_SCENE_SKIRMISHER_LEAPER     = 34117,
    NPC_SCENE_RAGING_ANCIENT        = 34124,   // "Raging Ancient [Phase 2 Kodo Ride Scenery]"
    NPC_SCENE_SKIRMISHER_GATE       = 34126,
    NPC_SCENE_SPLINTERTREE_GUARD_2  = 34136,

    // Items
    ITEM_KADRAKS_REINS              = 45051,

    // Spells
    SPELL_RIDE_BRUTUSK_SUMMON       = 62885,   // 13628: the click on 33374 (summons 33386, the clicker casts 62896)
    SPELL_RIDE_BRUTUSK              = 62896,   // 13628: the clicker's ride aura on 33386 (from 62885)
    SPELL_RIDE_BRUTUSK_KILL_CREDIT  = 62890,   // KILL_CREDIT2 33374
    SPELL_RIDE_BRUTUSK_II           = 63202,   // 13653: the player's ride aura
    SPELL_GORKA_RIDE_BRUTUSK        = 63209,   // 13653: Gorka's ride aura
    SPELL_GORKA_BOWSHOT             = 63262,
    SPELL_RIDE_BRUTUSK_III          = 64265,   // 13712: the player's ride aura
    SPELL_KADRAK_RIDE_BRUTUSK       = 64293,   // 13712: Kadrak's ride aura
    SPELL_KADRAK_GOSSIP_TIMER       = 64243,   // Kadrak "busy" (npc_text 14448 is conditioned on it; never set while private)
    SPELL_BRUTUSK_CHAIN_LIGHTNING   = 64327,
    SPELL_KODO_STOMP                = 64400,
    SPELL_THROW_BRUTUSK_BOULDER     = 64477,
    SPELL_TO_THE_RESCUE_KILL_CREDIT = 64506,   // KILL_CREDIT 34007

    // Gossip
    MENU_KADRAK                     = 10411,
    OPTION_KADRAK_REINS             = 0,       // BT 33514
    OPTION_KADRAK_READY             = 1,       // BT 34040
    OPTION_KADRAK_CHECK_BACK        = 2,       // BT 34045 (shown only while 64243 is on Kadrak)
    OPTION_KADRAK_URGENT            = 3,       // BT 74240 (5.3+)
    MENU_GORKA                      = 10342,
    OPTION_GORKA_READY              = 0,       // BT 33592

    TAXI_NODE_MORSHAN               = 354,
    TAXI_NODE_SPLINTERTREE          = 61,
    TAXI_PATH_MORSHAN_SPLINTERTREE  = 1253,

    // Texts (creature_text, all TextRange 5)
    SAY_KADRAK_REINS                = 0,       // 33515
    SAY_KADRAK_READY                = 1,       // 34047
    SAY_KADRAK_URGENT               = 2,       // 74241
    SAY_GORKA_FOLLOW                = 0,       // 33593
    EMOTE_BRUTUSK_LEAPS             = 0,       // 33386: 33537
    SAY_AMBUSHER_CAPTURE            = 0,       // 33394 / 34101: 33521
    SAY_AMBUSHER_PASS               = 1,       // 33394 / 34101: 33522
    EMOTE_GORKA_CALLS               = 0,       // 33507: 33596
    SAY_GORKA_TO_MORSHAN            = 1,       // 33619
    SAY_GORKA_OUT_OF_OUR_WAY        = 2,       // 33631
    SAY_GORKA_UNGHH                 = 3,       // 33644
    SAY_GORKA_WOUNDED               = 4,       // 33645
    SAY_GORKA_FINISHED              = 5,       // 33653
    SAY_GORKA_SERVED                = 6,       // 33654
    SAY_ASSAILANT_FAR_ENOUGH        = 0,       // 33569 / 34013: 33630
    SAY_ASSAILANT_KILL_HER          = 1,       // 33640
    SAY_ASSAILANT_SHOOT             = 2,       // 33642
    SAY_ASSAILANT_FIRE              = 3,       // 33643
    SAY_ASSAILANT_AHHH              = 4,       // 33641
    SAY_KADRAK_RIDER_GO             = 0,       // 34006: 34049
    SAY_KADRAK_RIDER_MAKE_EM_PAY    = 1,       // 34160
    SAY_KADRAK_RIDER_BLOOD_THUNDER  = 2,       // 34087
    SAY_KADRAK_RIDER_LOKTAR         = 3,       // 34094
    SAY_KADRAK_RIDER_NOT_FAR        = 4,       // 34111
    SAY_KADRAK_RIDER_SPLINTERTREE   = 5,       // 34112
    SAY_KADRAK_RIDER_SIEGE          = 6,       // 34113
    SAY_KADRAK_RIDER_FOR_THE_HORDE  = 7,       // 34114
    SAY_KADRAK_RIDER_OPEN_GATES     = 8,       // 34117
    SAY_KADRAK_RIDER_DRIVE_BACK     = 9,       // 34165
    SAY_KADRAK_RIDER_NOOO           = 10,      // 34171
    SAY_KADRAK_RIDER_SIEGE_BROKEN   = 11,      // 34182
    SAY_GUARD_BLOOD_AND_THUNDER     = 0,       // 34052 / 34136: 34164
    SAY_GUARD_FOR_THE_HORDE         = 1,       // 34052 / 34136: 34114

    // Ride machinery
    SEAT_DRIVER                     = 0,
    SEAT_PASSENGER                  = 1,

    POINT_RIDE_STEP                 = 1,
    POINT_RIDE_JUMP                 = 2,
    POINT_RIDE_TO_RIDER             = 3,
    POINT_ACTOR_DESPAWN             = 99,      // an actor reaching this point despawns (npc_nb_morshan_actor)
    POINT_ACTOR_MOVE                = 98,

    EVENT_RIDE_BOARD_CHECK          = 1,
    EVENT_RIDE_CHECK                = 2,
    EVENT_RIDE_TIMEOUT              = 3,
    EVENT_RIDE_RESEAT               = 4,
    EVENT_RIDE_START                = 5,
    EVENT_SCENE_FIRST               = 100,     // derived rides number their scene events from here

    ACTION_ACTOR_FIGHT_EMOTES       = 1,
    DATA_RIDER_GUID                 = 1,
};

// Choice points (questions.md); each is one constant.
static bool const KadrakSharedBrutusk  = false;  // Q5: true = one Brutusk at a time (64243 on Kadrak while out, busy page)
static bool const CrisisCreditOnCollapse = true; // Q7: true = 13653 credited when Gorka collapses (default)

// ---------------------------------------------------------------------------------------------------------------------------
// Routes (all ours, questions.md Q4: no sniff, TDB, video or emulator has them). Drawn along the Mor'shan - Warsong Labor Camp
// road (E1, E2) and the Mor'shan - Nightsong Woods - Dor'Danil Barrow Den - Splintertree road (E3, the wiki's order), on the
// valley floor of the 5.4.8 maps (research\northern-barrens\tmp\s3\pts.py, heights from the .map files), legs of about 50 yd,
// each driven as its own MovePoint with path finding (core issue C20: a long road is not one spline). A JUMP point is reached
// by a leap from the point before it. Speeds come from second-pass.md: Got Wood? rode ~45 s, Crisis ~55-60 s, To the Rescue!
// ~1:35-1:50 to the gate scene.
// ---------------------------------------------------------------------------------------------------------------------------
enum RidePointFlags : uint8
{
    RIDE_POINT_NONE = 0,
    RIDE_POINT_JUMP = 1,
};

struct RidePoint
{
    float X, Y, Z;
    uint8 Flags;
};

// 13628: from the summon spot (1193.56, -2259.08, spell_target_position of 62885) out of the Mor'shan gate, past mop's static
// ambushers (the leap lands between them), to the Warsong Labor Camp 13 yd from Gorka. 504 yd at 1.6 x 7 yd/s = ~45 s.
static RidePoint const GotWoodRoute[] =
{
    { 1215.00f, -2245.00f, 92.48f, RIDE_POINT_NONE },   //  0 inside the rampart
    { 1240.00f, -2238.00f, 91.87f, RIDE_POINT_NONE },   //  1
    { 1290.00f, -2236.00f, 91.87f, RIDE_POINT_NONE },   //  2 through the gate
    { 1340.00f, -2250.00f, 91.13f, RIDE_POINT_NONE },   //  3 Nightsong Woods
    { 1368.00f, -2258.00f, 89.96f, RIDE_POINT_NONE },   //  4 the ambush: emote and yells, then the leap
    { 1396.00f, -2269.00f, 92.29f, RIDE_POINT_JUMP },   //  5 lands among the ambushers
    { 1430.00f, -2295.00f, 90.39f, RIDE_POINT_NONE },   //  6
    { 1470.00f, -2330.00f, 90.89f, RIDE_POINT_NONE },   //  7
    { 1510.00f, -2370.00f, 96.37f, RIDE_POINT_NONE },   //  8 Warsong Labor Camp
    { 1540.00f, -2420.00f, 98.13f, RIDE_POINT_NONE },   //  9
    { 1565.00f, -2465.00f, 97.99f, RIDE_POINT_NONE },   // 10
    { 1576.00f, -2493.00f, 98.17f, RIDE_POINT_NONE },   // 11 arrival, 13 yd from Gorka (1580.9, -2505.7)
};
static float const GotWoodRate = 1.6f;
static size_t const GotWoodAmbushPoint = 4;

// 13653: from the call spot at the camp back to Mor'shan, through the assailants' road block (mop's static squad at 1462, -2321),
// stopping 12 yd from Kadrak. ~535 yd at 1.3 x 7 yd/s = ~59 s.
static RidePoint const CrisisRoute[] =
{
    { 1605.00f, -2512.00f, 98.40f, RIDE_POINT_NONE },   //  0 leaving the camp
    { 1578.00f, -2490.00f, 98.06f, RIDE_POINT_NONE },   //  1
    { 1565.00f, -2465.00f, 97.99f, RIDE_POINT_NONE },   //  2 (bowmen and a skirmisher appear in the woods)
    { 1540.00f, -2420.00f, 98.13f, RIDE_POINT_NONE },   //  3 the bowmen shoot, to no avail
    { 1510.00f, -2370.00f, 96.37f, RIDE_POINT_NONE },   //  4 the skirmisher leaps at Brutusk, Gorka shoots him
    { 1485.00f, -2345.00f, 91.55f, RIDE_POINT_NONE },   //  5 the road block: "That's far enough, orc!"
    { 1460.00f, -2322.00f, 90.32f, RIDE_POINT_NONE },   //  6 through the squad, the speaker knocked aside
    { 1430.00f, -2295.00f, 90.39f, RIDE_POINT_NONE },   //  7
    { 1390.00f, -2265.00f, 90.52f, RIDE_POINT_NONE },   //  8
    { 1340.00f, -2250.00f, 91.13f, RIDE_POINT_NONE },   //  9
    { 1290.00f, -2236.00f, 91.87f, RIDE_POINT_NONE },   // 10 through the Mor'shan gate
    { 1252.00f, -2238.00f, 92.21f, RIDE_POINT_NONE },   // 11
    { 1238.00f, -2242.00f, 91.80f, RIDE_POINT_NONE },   // 12 stop, 12 yd from Kadrak
};
static float const CrisisRate = 1.3f;
static Position const CrisisCallSpot     = { 1628.00f, -2530.00f, 96.54f, 0.0f };  // ours: Gorka runs here (~14 s with the call)
static Position const CrisisMountSpot    = { 1631.00f, -2527.00f, 95.90f, 0.0f };  // ours: Brutusk stops beside her
static Position const CrisisBrutuskSpawn = { 1642.46f, -2541.73f, 93.92f, 2.4f };  // 63162 spell_target_position (z: map)
static Position const CrisisBlockCenter  = { 1464.00f, -2322.00f, 90.50f, 0.0f };  // mop's static assailant squad (in neither TDB)
static size_t const CrisisWoodsSummonPoint = 2, CrisisBowmenPoint = 3, CrisisLeapPoint = 4, CrisisBlockPoint = 5, CrisisBreakPoint = 6;

// 13712: Mor'shan - Nightsong Woods - the Warsong Labor Camp road - Dor'Danil Barrow Den - Splintertree Post, stopping on the
// battlefield in front of the closed gate (the Splintertree Gate objects at 2229-2235, -2539), where the gate scene plays and
// Brutusk falls (wiki: "just in front of the closed gate to Splintertree, Brutusk and Kadrak observe the battlefield"; the
// Brutusk page: killed "on the battlefield in front of Splintertree Post"). ~1050 yd at 1.6 x 7 yd/s = ~95 s plus the leaps.
static RidePoint const RescueRoute[] =
{
    { 1250.00f, -2237.00f,  92.06f, RIDE_POINT_NONE },  //  0
    { 1290.00f, -2236.00f,  91.87f, RIDE_POINT_NONE },  //  1 the Mor'shan gate
    { 1340.00f, -2250.00f,  91.13f, RIDE_POINT_NONE },  //  2
    { 1390.00f, -2265.00f,  90.52f, RIDE_POINT_NONE },  //  3 (group 1 appears)
    { 1430.00f, -2295.00f,  90.39f, RIDE_POINT_NONE },  //  4
    { 1470.00f, -2330.00f,  90.89f, RIDE_POINT_NONE },  //  5 group 1: "Make 'em pay, Brutusk!", chain lightning
    { 1510.00f, -2370.00f,  96.37f, RIDE_POINT_NONE },  //  6
    { 1550.00f, -2410.00f,  98.11f, RIDE_POINT_NONE },  //  7
    { 1600.00f, -2440.00f, 102.05f, RIDE_POINT_NONE },  //  8
    { 1650.00f, -2455.00f, 104.40f, RIDE_POINT_NONE },  //  9 (group 2 appears)
    { 1678.00f, -2458.00f, 102.84f, RIDE_POINT_NONE },  // 10
    { 1700.00f, -2460.00f, 102.54f, RIDE_POINT_JUMP },  // 11 group 2: leap, Kodo Stomp, "Lok'tar Ogar!!"
    { 1750.00f, -2465.00f,  95.15f, RIDE_POINT_NONE },  // 12 The Dor'Danil Barrow Den
    { 1800.00f, -2470.00f,  85.88f, RIDE_POINT_NONE },  // 13 (group 3 appears)
    { 1828.00f, -2472.00f,  73.09f, RIDE_POINT_NONE },  // 14 "Not far now...." (after the Barrow Den, before the second stomp)
    { 1850.00f, -2475.00f,  71.66f, RIDE_POINT_JUMP },  // 15 group 3: leap, Kodo Stomp
    { 1900.00f, -2480.00f,  73.43f, RIDE_POINT_NONE },  // 16
    { 1950.00f, -2490.00f,  81.61f, RIDE_POINT_NONE },  // 17
    { 2000.00f, -2495.00f,  92.87f, RIDE_POINT_NONE },  // 18
    { 2050.00f, -2500.00f,  93.91f, RIDE_POINT_NONE },  // 19 (group 4 appears)
    { 2100.00f, -2505.00f,  91.75f, RIDE_POINT_NONE },  // 20 "Splintertree..."
    { 2150.00f, -2515.00f,  81.93f, RIDE_POINT_NONE },  // 21 group 4: chain lightning, "We must break the siege!"; the gate scene appears
    { 2195.00f, -2530.00f,  82.44f, RIDE_POINT_NONE },  // 22 stop in front of the gate: "For the Horde!!", "Open the gates brothers!" ...
};
static Position const RescueGatePos      = { 2229.30f, -2538.90f, 86.20f, 0.0f };  // Splintertree Gate 182991 (194647)
static float const RescueRate = 1.6f;
static Position const RescueBrutuskSpawn = { 1193.58f, -2258.65f, 91.67f, 0.6f };  // 64239 spell_target_position
static Position const RescueMountSpot    = { 1232.00f, -2236.00f, 91.78f, 0.0f };  // ours: beside Kadrak (1229.1, -2231.3)
static Position const RescueKadrakHome   = { 2284.80f, -2544.70f, 98.33f, 0.0f };  // where Kadrak 33837 stands in Splintertree

// The scene actors of 13712 (ours: no source has their positions or counts; the wiki has the groups and the gate scene).
struct ActorSpot
{
    uint32 Entry;
    float X, Y, Z;
};

static ActorSpot const RescueGroup1[] = // bowmen on the slope east of the road, beside point 5
{
    { NPC_SCENE_BOWMAN, 1478.0f, -2345.0f, 91.5f }, { NPC_SCENE_BOWMAN, 1488.0f, -2340.0f, 92.0f }, { NPC_SCENE_BOWMAN, 1470.0f, -2350.0f, 91.5f },
};
static ActorSpot const RescueGroup2[] = // assailants on the road at point 11
{
    { NPC_SCENE_ASSAILANT, 1705.0f, -2462.0f, 102.0f }, { NPC_SCENE_ASSAILANT, 1708.0f, -2468.0f, 101.0f }, { NPC_SCENE_ASSAILANT, 1712.0f, -2458.0f, 101.0f },
};
static ActorSpot const RescueGroup3[] = // skirmishers on the road at point 15
{
    { NPC_SCENE_SKIRMISHER, 1855.0f, -2476.0f, 71.5f }, { NPC_SCENE_SKIRMISHER, 1858.0f, -2482.0f, 71.0f }, { NPC_SCENE_SKIRMISHER, 1860.0f, -2471.0f, 71.5f },
};
static ActorSpot const RescueGroup4[] = // bowmen and an assailant east of the road at point 21
{
    { NPC_SCENE_BOWMAN, 2152.0f, -2530.0f, 84.0f }, { NPC_SCENE_BOWMAN, 2160.0f, -2528.0f, 83.0f }, { NPC_SCENE_ASSAILANT, 2145.0f, -2527.0f, 85.0f },
};
// The gate stays closed (ours): three Splintertree Gate models stand stacked in phase 1 there (194648, 194649, 194647, all
// public), so opening one would show nothing and would change it for every player; the guards appear at its outer foot.
static ActorSpot const RescueGateGuards[] = // they pour out of the gate
{
    { NPC_SCENE_SPLINTERTREE_GUARD, 2226.0f, -2535.0f, 86.0f }, { NPC_SCENE_SPLINTERTREE_GUARD, 2226.0f, -2543.0f, 86.0f },
    { NPC_SCENE_SPLINTERTREE_GUARD_2, 2223.0f, -2531.0f, 86.0f }, { NPC_SCENE_SPLINTERTREE_GUARD_2, 2223.0f, -2547.0f, 86.0f },
};
static ActorSpot const RescueGateSkirmishers[] = // on the battlefield south of the gate; the guards fight them
{
    { NPC_SCENE_SKIRMISHER_GATE, 2208.0f, -2552.0f, 86.0f }, { NPC_SCENE_SKIRMISHER_GATE, 2214.0f, -2558.0f, 88.0f }, { NPC_SCENE_SKIRMISHER_GATE, 2203.0f, -2547.0f, 85.0f },
};
static ActorSpot const RescueGateAncient = { NPC_SCENE_RAGING_ANCIENT, 2185.0f, -2565.0f, 85.0f }; // in the trees south-west of the stop

// 13653's woods beat (ours): two bowmen on the slope, one skirmisher who leaps at Brutusk
static ActorSpot const CrisisWoodsBowmen[] =
{
    { NPC_SCENE_BOWMAN, 1530.0f, -2440.0f, 106.0f }, { NPC_SCENE_BOWMAN, 1525.0f, -2425.0f, 103.0f },
};
static ActorSpot const CrisisWoodsLeaper = { NPC_SCENE_SKIRMISHER_LEAPER, 1505.0f, -2385.0f, 94.2f };

static Position MakeRidePos(RidePoint const& point)
{
    return Position(point.X, point.Y, point.Z);
}

// ---------------------------------------------------------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------------------------------------------------------

// A player may start a ride when alive, in the world, not a bot (bots never choose gossip; _playerbots-issues.md), not on a
// vehicle or taxi. A refusal is told.
static bool CanStartRide(Player* player)
{
    if (!player || !player->IsInWorld() || !player->IsAlive() || player->GetSession()->IsBot())
        return false;
    if (player->GetVehicle() || player->IsInFlight())
    {
        player->GetSession()->SendNotification("You can't do that while riding.");
        return false;
    }
    return true;
}

// Ours: a mounted or shapeshifted player is dismounted / returned to his own form before he is seated (the 13653 comments say
// boarding failed for such players on retail; nobody should lose the ride to it). Only forms that cannot ride go, as
// Player::ActivateTaxiPathTo does it (stances, stealth and Shadowform stay).
static void PrepareForRide(Player* player)
{
    player->Dismount();
    player->RemoveAurasByType(SPELL_AURA_MOUNTED);
    if (player->IsInDisallowedMountForm())
        player->RemoveAurasByType(SPELL_AURA_MOD_SHAPESHIFT);
}

// Credit through the sourced spell where it works in this core, then directly (KilledMonsterCredit stops at the objective's
// count, so a spell that did land makes the second call a no-op). Only while the quest is in the log, incomplete.
static void GiveRideCredit(Player* player, uint32 questId, uint32 spellId, uint32 creditEntry)
{
    if (!player || !player->IsInWorld() || player->GetQuestStatus(questId) != QUEST_STATUS_INCOMPLETE)
        return;
    if (spellId)
        player->CastSpell(player, spellId, true);
    if (player->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
        player->KilledMonsterCredit(creditEntry);
}

// The player's own private copy of an entry, alive, within range (a second gossip click while a ride is being set up)
static bool HasOwnPrivateCreature(Player* player, uint32 entry, float range)
{
    std::list<Creature*> list;
    player->GetCreatureListWithEntryInGrid(list, entry, range);
    for (Creature* creature : list)
        if (creature->IsAlive() && creature->GetPrivateObjectOwner() == player->GetGUID())
            return true;
    return false;
}

static float GroundZ(WorldObject const* ref, float x, float y, float z)
{
    float const ground = ref->GetMap()->GetHeight(ref->GetPhaseMask(), x, y, z + 6.0f, true, 30.0f);
    return ground > INVALID_HEIGHT ? ground : z;
}

static Creature* SummonPrivateActor(Player* player, uint32 entry, float x, float y, float z, float facing)
{
    Position const pos(x, y, GroundZ(player, x, y, z), facing);
    return player->SummonCreature(entry, pos, TEMPSUMMON_MANUAL_DESPAWN, 0ms, 0, player->GetGUID());
}

// ---------------------------------------------------------------------------------------------------------------------------
// npc_nb_morshan_actor - the NPC riders (33507 Gorka, 34006 Kadrak) and the faction 1802 / 1801 scene actors (34012 34013
// 34052 34101 34117 34124 34126 34136). Archetype "scene actors": summoned private to the player, never in a fight of their
// own (passive, no melee, no evade, no chase), fights are emotes and the ride's scripted casts; they go when their player
// leaves the world or the map and after a hard cap. Point POINT_ACTOR_DESPAWN despawns them on arrival.
// ---------------------------------------------------------------------------------------------------------------------------
struct npc_nb_morshan_actor : public ScriptedAI
{
    npc_nb_morshan_actor(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner->ToPlayer();
        if (!player)
        {
            me->DespawnOrUnsummon();
            return;
        }
        _playerGUID = player->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetUInt32Value(UNIT_FIELD_NPC_FLAGS, 0);
        _checkTimer = 2000;
        _lifeTimer = (me->GetEntry() == NPC_GORKA_RIDER || me->GetEntry() == NPC_KADRAK_RIDER) ? 300000 : 180000;
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void DoAction(int32 action) override
    {
        if (action == ACTION_ACTOR_FIGHT_EMOTES)
            _fightEmotes = true;
    }

    void SetGUID(ObjectGuid guid, int32 /*id*/) override
    {
        _faceGUID = guid;
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == POINT_MOTION_TYPE && id == POINT_ACTOR_DESPAWN)
            me->DespawnOrUnsummon(500);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_lifeTimer <= diff)
        {
            me->DespawnOrUnsummon();
            return;
        }
        _lifeTimer -= diff;

        if (_checkTimer <= diff)
        {
            _checkTimer = 2000;
            Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
            if (!player || !player->IsInWorld() || player->GetMapId() != me->GetMapId())
            {
                me->DespawnOrUnsummon();
                return;
            }

            if (_fightEmotes && me->IsAlive() && !me->GetVehicle())
            {
                if (Unit* target = ObjectAccessor::GetUnit(*me, _faceGUID))
                    if (target->IsAlive())
                        me->SetFacingToObject(target);
                me->HandleEmoteCommand(me->GetEntry() == NPC_SCENE_BOWMAN ? EMOTE_ONESHOT_ATTACK_BOW : EMOTE_ONESHOT_ATTACK1H);
            }
        }
        else
            _checkTimer -= diff;
    }

private:
    ObjectGuid _playerGUID;
    ObjectGuid _faceGUID;
    uint32 _checkTimer = 2000;
    uint32 _lifeTimer = 180000;
    bool _fightEmotes = false;
};

// ---------------------------------------------------------------------------------------------------------------------------
// The common Brutusk: drives a route point by point with its player on board, checks every 500 ms that he still is, and ends
// once on every path. Derived rides add the boarding, the scenes (events from EVENT_SCENE_FIRST, ReachedPoint) and the end.
// ---------------------------------------------------------------------------------------------------------------------------
struct npc_nb_brutusk_ride_base : public ScriptedAI
{
    npc_nb_brutusk_ride_base(Creature* creature, RidePoint const* route, size_t count, float rate)
        : ScriptedAI(creature), _route(route), _count(count), _rate(rate) { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner->ToPlayer();
        if (!player)
        {
            me->DespawnOrUnsummon();
            return;
        }
        _playerGUID = player->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC);
        me->SetUInt32Value(UNIT_FIELD_NPC_FLAGS, 0);
        me->setActive(true, ActiveFlags::Script);   // up to 1 100 yd across several grids
        _events.Reset();
        OnSummoned(player);
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    Player* GetRider() const { return ObjectAccessor::GetPlayer(*me, _playerGUID); }
    bool IsRiding(Player* player) const { return player && player->GetVehicleBase() == me; }
    Creature* GetNpcRider() const { return _npcRiderGUID.IsEmpty() ? nullptr : ObjectAccessor::GetCreature(*me, _npcRiderGUID); }

    void TrackActor(Creature* actor)
    {
        if (actor)
            _actors.push_back(actor->GetGUID());
    }

    // The player is on board: start the route and the watch
    void BeginRide()
    {
        _boarded = true;
        _next = 0;
        me->SetWalk(false);
        me->SetSpeed(MOVE_RUN, _rate);
        _events.ScheduleEvent(EVENT_RIDE_CHECK, 500ms);

        float seconds = 0.0f;
        Position prev = me->GetPosition();
        for (size_t i = 0; i < _count; ++i)
        {
            Position const next = MakeRidePos(_route[i]);
            seconds += prev.GetExactDist(&next) / (_rate * 7.0f);
            prev = next;
        }
        _events.ScheduleEvent(EVENT_RIDE_TIMEOUT, Milliseconds(uint32(seconds * IN_MILLISECONDS) + 60 * IN_MILLISECONDS));
        MoveNext();
    }

    void MoveNext()
    {
        if (_next >= _count)
        {
            _arrived = true;
            Arrived();
            return;
        }

        RidePoint const& point = _route[_next];
        if (point.Flags & RIDE_POINT_JUMP)
            me->GetMotionMaster()->MoveJump(point.X, point.Y, point.Z, 20.0f, 9.0f, POINT_RIDE_JUMP);
        else
            me->GetMotionMaster()->MovePoint(POINT_RIDE_STEP, point.X, point.Y, point.Z, true);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (_ended)
            return;

        if (type == POINT_MOTION_TYPE && id == POINT_RIDE_TO_RIDER)
        {
            ReachedRider();
            return;
        }

        if (!_boarded || _arrived)
            return;

        if ((type == POINT_MOTION_TYPE && id == POINT_RIDE_STEP) || (type == EFFECT_MOTION_TYPE && id == POINT_RIDE_JUMP))
        {
            size_t const reached = _next++;
            ReachedPoint(reached);
            if (!_ended && !_arrived)
                MoveNext();
        }
    }

    // Seats the NPC rider in the saddle (seat 0) and then the player behind (seat 1), each by name (see the file header)
    // The ride spells reach 50 000 yd (range index 13), and the player chose the option, so he is seated wherever he waits
    // (dossier A E2.1: "seat him anyway"), up to 150 yd; past that, or dead, or on a vehicle or taxi, he is told why.
    bool SeatRiders(Creature* npcRider, uint32 npcRideSpell, uint32 playerRideSpell)
    {
        Player* player = GetRider();
        if (!npcRider || !player || !player->IsInWorld())
            return false;
        if (!player->IsAlive() || player->GetVehicle() || player->IsInFlight() || player->GetMapId() != me->GetMapId()
            || player->GetExactDist(me) > 150.0f)
        {
            player->GetSession()->SendNotification("Brutusk could not take you along. Speak with %s again.", npcRider->GetName().c_str());
            return false;
        }

        npcRider->CastCustomSpell(npcRideSpell, SPELLVALUE_BASE_POINT0, SEAT_DRIVER + 1, me, true);
        if (npcRider->GetVehicleBase() != me)
        {
            TC_LOG_ERROR("scripts", "zone_northern_barrens_morshan: %u could not be seated on %u", npcRider->GetEntry(), me->GetEntry());
            return false;
        }

        _playerRideSpell = playerRideSpell;
        PrepareForRide(player);
        player->CastCustomSpell(playerRideSpell, SPELLVALUE_BASE_POINT0, SEAT_PASSENGER + 1, me, true);
        if (!IsRiding(player))
        {
            TC_LOG_ERROR("scripts", "zone_northern_barrens_morshan: %s could not be seated on %u", player->GetName().c_str(), me->GetEntry());
            player->GetSession()->SendNotification("Brutusk could not take you along. Speak with %s again.", npcRider->GetName().c_str());
            return false;
        }
        return true;
    }

    // A passenger who stepped off on his own (seat 3549's leave button) is seated again (file header); one who died, logs out
    // or is being teleported is not.
    bool MayReseat(Player* player) const
    {
        return _playerRideSpell && player && player->IsInWorld() && player->IsAlive() && !player->GetSession()->PlayerLogout()
            && !player->IsBeingTeleported() && player->GetMapId() == me->GetMapId() && !player->GetVehicle() && !player->IsInFlight()
            && player->GetExactDist(me) < 20.0f;
    }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        Player* player = passenger->ToPlayer();
        if (!player || player->GetGUID() != _playerGUID)
            return;

        if (apply)
        {
            // Ours: seat 3549 lets the passenger be selected, so the live mobs of the road would pull him off his ride; he is
            // unselectable while seated, as seat 3406 makes him on 13628. Cleared when he leaves the seat in any way.
            if (!player->HasFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE))
            {
                player->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                _setUnselectable = true;
            }
            OnPlayerBoarded(player);
            return;
        }

        if (_setUnselectable)
        {
            player->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
            _setUnselectable = false;
        }

        // Leaving the seat before the ride's own end: the leave button seats him again (decided 300 ms later, when a teleport
        // that exited him first shows as IsBeingTeleported); death, logout and teleports end the ride
        if (!_ended && !_releasing)
        {
            if (MayReseat(player))
            {
                _reseatPending = true;
                _events.ScheduleEvent(EVENT_RIDE_RESEAT, 300ms);
            }
            else
                End(true);
        }
    }

    // Ends the ride once. abort: the player is let off where Brutusk is, the riders and actors go at once and the quest stays
    // incomplete (a new start is possible at once). Otherwise the derived ride has played its end.
    void End(bool abort)
    {
        if (_ended)
            return;
        _ended = true;
        _events.Reset();

        if (abort)
        {
            TC_LOG_DEBUG("scripts", "zone_northern_barrens_morshan: ride of %u ended early", me->GetEntry());
            _releasing = true;
            if (Player* player = GetRider())
                if (IsRiding(player))
                    player->ExitVehicle();
            if (Creature* rider = GetNpcRider())
                rider->DespawnOrUnsummon();
            for (ObjectGuid const& guid : _actors)
                if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                    actor->DespawnOrUnsummon();
            me->DespawnOrUnsummon();
            return;
        }
    }

    // Lets the riders off at the end of a ride without it counting as an early end
    void ReleasePassengers()
    {
        _releasing = true;
        if (Player* player = GetRider())
            if (IsRiding(player))
                player->ExitVehicle();
        if (Creature* rider = GetNpcRider())
            if (rider->GetVehicleBase() == me)
                rider->ExitVehicle();
        // Vehicle::RemovePassenger gives an enterable seat's vehicle the spellclick flag back: no mount cursor on the kodo now
        me->SetUInt32Value(UNIT_FIELD_NPC_FLAGS, 0);
    }

    void DespawnActors(uint32 delay)
    {
        for (ObjectGuid const& guid : _actors)
            if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                actor->DespawnOrUnsummon(delay);
        _actors.clear();
    }

    // Kills every listed actor by this vehicle (no player gets loot, XP or credit: the vehicle has no owner)
    void KillActors(std::vector<ObjectGuid>& group)
    {
        for (ObjectGuid const& guid : group)
            if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                if (actor->IsAlive())
                    me->Kill(actor);
    }

    // Summons a group of actors private to the player, facing the road point they wait at
    void SummonGroup(ActorSpot const* spots, size_t count, Position const& face, std::vector<ObjectGuid>& out)
    {
        Player* player = GetRider();
        if (!player)
            return;
        for (size_t i = 0; i < count; ++i)
        {
            float const facing = std::atan2(face.GetPositionY() - spots[i].Y, face.GetPositionX() - spots[i].X);
            if (Creature* actor = SummonPrivateActor(player, spots[i].Entry, spots[i].X, spots[i].Y, spots[i].Z, facing))
            {
                out.push_back(actor->GetGUID());
                TrackActor(actor);
            }
        }
    }

    Creature* FirstAlive(std::vector<ObjectGuid> const& group) const
    {
        for (ObjectGuid const& guid : group)
            if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                if (actor->IsAlive())
                    return actor;
        return nullptr;
    }

    // Any unsummon, ours included (TempSummon::UnSummon); one not started by End (a GM, a map unload) still takes the rider
    // and the actors along. A logout is caught earlier by PassengerBoarded(false) and the actors' own owner check.
    void Unsummoned() override
    {
        if (!_ended)
        {
            _ended = true;
            if (Creature* rider = GetNpcRider())
                rider->DespawnOrUnsummon();
            for (ObjectGuid const& guid : _actors)
                if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                    actor->DespawnOrUnsummon();
        }
    }

    void UpdateAI(uint32 diff) override
    {
        if (_ended && !_keepUpdating)
            return;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_RIDE_BOARD_CHECK:
                    if (!_boarded)
                    {
                        TC_LOG_ERROR("scripts", "zone_northern_barrens_morshan: the rider of %u did not board", me->GetEntry());
                        End(true);
                        return;
                    }
                    break;
                case EVENT_RIDE_CHECK:
                {
                    Player* player = GetRider();
                    if (!_reseatPending && (!player || !player->IsInWorld() || !player->IsAlive() || !IsRiding(player)))
                    {
                        End(true);
                        return;
                    }
                    _events.ScheduleEvent(EVENT_RIDE_CHECK, 500ms);
                    break;
                }
                case EVENT_RIDE_RESEAT:
                {
                    _reseatPending = false;
                    Player* player = GetRider();
                    if (!MayReseat(player))
                    {
                        End(true);
                        return;
                    }
                    player->CastCustomSpell(_playerRideSpell, SPELLVALUE_BASE_POINT0, SEAT_PASSENGER + 1, me, true);
                    if (!IsRiding(player))
                    {
                        End(true);
                        return;
                    }
                    break;
                }
                case EVENT_RIDE_TIMEOUT:
                    TC_LOG_ERROR("scripts", "zone_northern_barrens_morshan: the ride of %u did not arrive in time", me->GetEntry());
                    End(true);
                    return;
                default:
                    SceneEvent(eventId);
                    break;
            }
            if (_ended && !_keepUpdating)
                return;
        }
    }

    virtual void OnSummoned(Player* /*player*/) { }
    virtual void OnPlayerBoarded(Player* /*player*/) { }
    virtual void ReachedRider() { }
    virtual void ReachedPoint(size_t /*index*/) { }
    virtual void Arrived() = 0;
    virtual void SceneEvent(uint32 /*eventId*/) { }

protected:
    RidePoint const* _route;
    size_t _count;
    float _rate;
    ObjectGuid _playerGUID;
    ObjectGuid _npcRiderGUID;
    EventMap _events;
    std::vector<ObjectGuid> _actors;
    size_t _next = 0;
    bool _boarded = false;
    bool _arrived = false;
    bool _ended = false;
    bool _releasing = false;
    bool _keepUpdating = false;   // the scene goes on after the ride's end (13653's collapse, 13712's gate)
    bool _setUnselectable = false;
    bool _reseatPending = false;
    uint32 _playerRideSpell = 0;  // set by SeatRiders (13653 / 13712); 0 on 13628, whose seat has no leave button
};

// ---------------------------------------------------------------------------------------------------------------------------
// 13628 Got Wood? - 33386 Brutusk (VehicleId 360)
// What the player sees (sourced: wiki "Speaking with Kadrak", comments 2010-07-09 / 2010-11-26 / 2013-07-13, BT 33537 33521
// 33522, the quest's request text "Quite an entrance"; second-pass.md: a ~45 s ride on the forest road): with the reins in his
// bags he clicks the parked Brutusk, is seated on a Brutusk of his own and carried out of the Mor'shan gate along the road;
// on the way "Brutusk roars as he leaps into the ambush!", two elves yell "Kill the Kodo and capture the rider!" / "Do not let
// it pass!" and Brutusk leaps past them without stopping; at the Warsong Labor Camp he is credited ("Brutusk mounted"), let
// off 13 yd from Gorka, and the kodo goes. Ours: the route, the leap's spot (between mop's 4 static ambushers, in neither
// TDB), private-copy fallback ambushers (34101) when no static one is free, the credit on arrival (Ride Brutusk Kill
// Credit 62890 cast by the player on himself, plus a direct credit if the spell did not count).
// ---------------------------------------------------------------------------------------------------------------------------
struct npc_nb_brutusk_got_wood : public npc_nb_brutusk_ride_base
{
    npc_nb_brutusk_got_wood(Creature* creature)
        : npc_nb_brutusk_ride_base(creature, GotWoodRoute, std::extent<decltype(GotWoodRoute)>::value, GotWoodRate) { }

    void OnSummoned(Player* /*player*/) override
    {
        // 62885's SUMMON_CATEGORY_VEHICLE branch makes the clicker cast 62896 at once (seat 0 by spell_nb_ride_brutusk)
        _events.ScheduleEvent(EVENT_RIDE_BOARD_CHECK, 1500ms);
    }

    void OnPlayerBoarded(Player* player) override
    {
        // A druid in a form that cannot ride is seated by the click as he is: back to his own form (dossier A E1-E3 common:
        // "dismount and cancel shapeshift before seating"; ours)
        PrepareForRide(player);
        if (!_boarded)
            _events.ScheduleEvent(EVENT_RIDE_START, 1s);
    }

    void ReachedPoint(size_t index) override
    {
        if (index != GotWoodAmbushPoint)
            return;

        // At the point before the leap: the emote and the yells, from the static ambushers (mop's spawns, in neither TDB) or a private copy
        Player* player = GetRider();
        if (!player)
            return;
        Talk(EMOTE_BRUTUSK_LEAPS, player);

        Position const leapTo = MakeRidePos(GotWoodRoute[GotWoodAmbushPoint + 1]);
        std::list<Creature*> statics;
        me->GetCreatureListWithEntryInGrid(statics, NPC_ASHENVALE_AMBUSHER, 90.0f);
        std::vector<Creature*> speakers;
        for (Creature* ambusher : statics)
            if (!ambusher->IsPrivateObject() && ambusher->IsAlive() && !ambusher->IsInCombat() && ambusher->GetExactDist2d(&leapTo) < 35.0f)
                speakers.push_back(ambusher);

        while (speakers.size() < 2)
        {
            float const x = leapTo.GetPositionX() + (speakers.empty() ? 6.0f : -4.0f);
            float const y = leapTo.GetPositionY() + (speakers.empty() ? -5.0f : 7.0f);
            Creature* copy = SummonPrivateActor(player, NPC_SCENE_SKIRMISHER, x, y, leapTo.GetPositionZ(), 0.0f);
            if (!copy)
                break;
            copy->SetFacingToObject(me);
            copy->DespawnOrUnsummon(20000);
            TrackActor(copy);
            speakers.push_back(copy);
        }

        if (!speakers.empty())
            speakers[0]->AI()->Talk(SAY_AMBUSHER_CAPTURE, player);
        if (speakers.size() > 1)
        {
            ObjectGuid const second = speakers[1]->GetGUID();
            ObjectGuid const playerGuid = player->GetGUID();
            me->m_Events.AddLambdaEventAtOffset([this, second, playerGuid]()
            {
                Creature* speaker = ObjectAccessor::GetCreature(*me, second);
                Player* target = ObjectAccessor::GetPlayer(*me, playerGuid);
                if (speaker && target && speaker->IsAlive() && speaker->IsAIEnabled)
                    speaker->AI()->Talk(SAY_AMBUSHER_PASS, target);
            }, 1500);
        }
    }

    void Arrived() override
    {
        Player* player = GetRider();
        ReleasePassengers();
        if (player)
            GiveRideCredit(player, QUEST_GOT_WOOD, SPELL_RIDE_BRUTUSK_KILL_CREDIT, NPC_BRUTUSK_PARKED);
        End(false);
        DespawnActors(0);
        me->DespawnOrUnsummon(1500);
    }

    void SceneEvent(uint32 eventId) override
    {
        if (eventId == EVENT_RIDE_START)
            BeginRide();
    }
};

// 33374 - Brutusk, parked at Mor'shan (spellclick 62885, conditions: 13628 in the log and the reins in the bags)
// The server sees every click (WorldSession::HandleSpellClick -> Unit::HandleSpellClick), but the clicker casts 62885 with
// TRIGGERED_NONE (Unit.cpp HandleSpellClick, no vehicle kit on 33374), and Spell::CheckCast refuses a mounted caster (62885
// lacks CASTABLE_WHILE_MOUNTED: SPELL_FAILED_NOT_MOUNTED) before any SpellScript check hook runs. OnSpellClick comes after that
// attempt with result = "a spellclick row passed its conditions": a clicker who passed them and is still not on a vehicle was
// refused, so he is dismounted and the ride spell is cast again (dossier A: "dismount ... before seating, so no player loses
// the quest to it"; ours). The client shows the first refusal's red text, then he is seated.
struct npc_nb_brutusk_parked : public ScriptedAI
{
    npc_nb_brutusk_parked(Creature* creature) : ScriptedAI(creature) { }

    void OnSpellClick(Unit* clicker, bool& result) override
    {
        Player* player = clicker->ToPlayer();
        if (!result || !player || player->GetVehicle() || player->IsInFlight() || !player->IsMounted())
            return;
        PrepareForRide(player);
        player->CastSpell(me, SPELL_RIDE_BRUTUSK_SUMMON, false);
    }
};

// 62896 Ride Brutusk (the clicker on 33386): the effect's 0/0 base points mean "any seat", and 33386's only seat 3406 is
// neither enterable nor usable by override (core issue C109), so Vehicle::AddPassenger finds no seat and the clicker stays
// on the ground. Naming seat 0 (amount = seat + 1, AuraEffect::HandleAuraControlVehicle) seats him.
class spell_nb_ride_brutusk : public AuraScript
{
    PrepareAuraScript(spell_nb_ride_brutusk);

    void CalcSeat(AuraEffect const* /*aurEff*/, float& amount, bool& /*canBeRecalculated*/)
    {
        amount = SEAT_DRIVER + 1;
    }

    void Register() override
    {
        DoEffectCalcAmount += AuraEffectCalcAmountFn(spell_nb_ride_brutusk::CalcSeat, EFFECT_0, SPELL_AURA_CONTROL_VEHICLE);
    }
};

// ---------------------------------------------------------------------------------------------------------------------------
// 13653 Crisis at Splintertree - 33509 Brutusk II with Gorka 33507 in the saddle
// What the player sees (sourced: the wiki's pre-8.3 paragraph and line list, BT 33593 33596 33619 33630 33631 33640-33645
// 33653 33654, comments 2010-11-25 / 2010-12-09 / 2011-05-22; second-pass.md: a ~14 s walk across the camp, Brutusk
// arrives, ~59 s ride, dismount, a body on the ground, turn-in at Kadrak ~5 s later with no gossip in between):
// "Follow me, <name>! Hurry!" - Gorka runs across the camp, "Gorka calls for Brutusk!", the kodo comes, she jumps into the
// saddle and the player is seated behind her; "To Mor'shan!!"; bowmen shoot from the woods to no avail, a skirmisher leaps
// at Brutusk and Gorka shoots him down; a squad blocks the road: "That's far enough, orc! Dismount and submit or die!" /
// "Out of our way, fools!" / "Kill her!!" "Shoot!" "Fire!!" - Brutusk barrels through and knocks the speaker aside ("Ahhh!"),
// Gorka is hit ("Unghh!", "Hurry, Brutusk. I'm wounded!"); inside Mor'shan both get off, Gorka sinks down, "I am...
// finished....", "<name>... You have served the Horde well. Hurry now... speak with Kadrak.... Save Splintertree!!" and lies
// dead; the player is credited (questions.md Q7 default: as she collapses; 63393 Gorka Kill Credit uses target 105, which
// this core leaves unimplemented, core C29, so the credit is given here).
// Ours: the call spot, the route and its timing, which actors play the woods (34012 / 34117, private copies; the sources name
// none), the road block's speakers (mop's static assailants standing on the road there, in neither TDB, else private 34013
// copies), the knock-aside (a knockback, no damage, only of a private copy), Gorka's body lying 60 s, Brutusk trotting out of
// the gate and going. Gorka's Bowshot is aimed by a source-13 condition on 63262 (the leaper 34117).
// The real Gorka 33421 stays at the camp as the quest giver for everybody else; the rider is a private copy.
// ---------------------------------------------------------------------------------------------------------------------------
enum CrisisScene
{
    EVENT_CRISIS_CALL        = EVENT_SCENE_FIRST,
    EVENT_CRISIS_COME,
    EVENT_CRISIS_MOUNT_TIMEOUT,
    EVENT_CRISIS_GO,
    EVENT_CRISIS_OUT_OF_OUR_WAY,
    EVENT_CRISIS_KILL_HER,
    EVENT_CRISIS_SHOOT,
    EVENT_CRISIS_FIRE,
    EVENT_CRISIS_UNGHH,
    EVENT_CRISIS_WOUNDED,
    EVENT_CRISIS_LEAPER_DIES,
    EVENT_CRISIS_DISMOUNT_GORKA,
    EVENT_CRISIS_COLLAPSE,
    EVENT_CRISIS_SERVED,
    EVENT_CRISIS_DEAD,
    EVENT_CRISIS_LEAVE,
};

struct npc_nb_brutusk_crisis : public npc_nb_brutusk_ride_base
{
    npc_nb_brutusk_crisis(Creature* creature)
        : npc_nb_brutusk_ride_base(creature, CrisisRoute, std::extent<decltype(CrisisRoute)>::value, CrisisRate) { }

    void SetGUID(ObjectGuid guid, int32 id) override
    {
        if (id != DATA_RIDER_GUID)
            return;
        _npcRiderGUID = guid;
        if (Creature* gorka = GetNpcRider())
        {
            gorka->SetWalk(false);
            gorka->GetMotionMaster()->MovePoint(POINT_ACTOR_MOVE, CrisisCallSpot.GetPositionX(), CrisisCallSpot.GetPositionY(), CrisisCallSpot.GetPositionZ(), true);
        }
        _events.ScheduleEvent(EVENT_CRISIS_CALL, 8s);
        _events.ScheduleEvent(EVENT_CRISIS_MOUNT_TIMEOUT, 25s);
    }

    void ReachedRider() override
    {
        if (!_boarded)
            _events.ScheduleEvent(EVENT_CRISIS_GO, 1s);
    }

    void ReachedPoint(size_t index) override
    {
        Player* player = GetRider();
        Creature* gorka = GetNpcRider();
        if (!player)
            return;

        if (index == CrisisWoodsSummonPoint)
        {
            Position const face = MakeRidePos(CrisisRoute[CrisisBowmenPoint]);
            SummonGroup(CrisisWoodsBowmen, std::extent<decltype(CrisisWoodsBowmen)>::value, face, _bowmen);
            ActorSpot const leaper[] = { CrisisWoodsLeaper };
            SummonGroup(leaper, 1, MakeRidePos(CrisisRoute[CrisisLeapPoint]), _leaper);
        }
        else if (index == CrisisBowmenPoint)
        {
            for (ObjectGuid const& guid : _bowmen)
                if (Creature* bowman = ObjectAccessor::GetCreature(*me, guid))
                {
                    bowman->AI()->SetGUID(me->GetGUID(), 0);
                    bowman->AI()->DoAction(ACTION_ACTOR_FIGHT_EMOTES);
                    bowman->DespawnOrUnsummon(15000);
                }
        }
        else if (index == CrisisLeapPoint)
        {
            if (Creature* leaper = FirstAlive(_leaper))
            {
                leaper->GetMotionMaster()->MoveJump(me->GetPositionX() + 3.0f, me->GetPositionY() + 3.0f, me->GetPositionZ(), 18.0f, 8.0f, POINT_ACTOR_MOVE);
                if (gorka)
                    gorka->CastSpell(leaper, SPELL_GORKA_BOWSHOT, true);
                _events.ScheduleEvent(EVENT_CRISIS_LEAPER_DIES, 1200ms);
            }
            FindBlockSpeakers();
        }
        else if (index == CrisisBlockPoint)
        {
            if (Creature* speaker = BlockSpeaker(0))
                speaker->AI()->Talk(SAY_ASSAILANT_FAR_ENOUGH, player);
            _events.ScheduleEvent(EVENT_CRISIS_OUT_OF_OUR_WAY, 1800ms);
        }
        else if (index == CrisisBreakPoint)
        {
            _events.ScheduleEvent(EVENT_CRISIS_KILL_HER, 100ms);
            _events.ScheduleEvent(EVENT_CRISIS_SHOOT, 900ms);
            _events.ScheduleEvent(EVENT_CRISIS_FIRE, 1700ms);
            _events.ScheduleEvent(EVENT_CRISIS_UNGHH, 2600ms);
            _events.ScheduleEvent(EVENT_CRISIS_WOUNDED, 4600ms);
            // Brutusk barrels through: the speaker is knocked aside. Only a private copy is thrown: a live static flying
            // for no visible reason would be seen by every other player there.
            if (Creature* speaker = BlockSpeaker(0))
            {
                speaker->AI()->Talk(SAY_ASSAILANT_AHHH, player);
                if (speaker->IsPrivateObject())
                    speaker->GetMotionMaster()->MoveKnockbackFrom(me->GetPositionX(), me->GetPositionY(), 10.0f, 5.0f);
            }
        }
    }

    // The speakers of the road block: the static assailants standing there (mop's spawns, in neither TDB), else private 34013 copies
    void FindBlockSpeakers()
    {
        Player* player = GetRider();
        if (!player)
            return;
        std::list<Creature*> statics;
        me->GetCreatureListWithEntryInGrid(statics, NPC_ASHENVALE_ASSAILANT, 100.0f);
        statics.sort([](Creature* a, Creature* b) { return a->GetExactDist2d(&CrisisBlockCenter) < b->GetExactDist2d(&CrisisBlockCenter); });
        for (Creature* assailant : statics)
            if (_blockSpeakers.size() < 3 && !assailant->IsPrivateObject() && assailant->IsAlive() && !assailant->IsInCombat()
                && assailant->GetExactDist2d(&CrisisBlockCenter) < 20.0f && assailant->IsAIEnabled)
                _blockSpeakers.push_back(assailant->GetGUID());

        for (uint8 i = uint8(_blockSpeakers.size()); i < 3; ++i)
        {
            float const x = CrisisBlockCenter.GetPositionX() + 4.0f * i - 2.0f;
            float const y = CrisisBlockCenter.GetPositionY() - 5.0f + 4.0f * i;
            if (Creature* copy = SummonPrivateActor(player, NPC_SCENE_ASSAILANT, x, y, CrisisBlockCenter.GetPositionZ(), 0.6f))
            {
                copy->DespawnOrUnsummon(30000);
                TrackActor(copy);
                _blockSpeakers.push_back(copy->GetGUID());
            }
        }
    }

    Creature* BlockSpeaker(size_t index)
    {
        if (_blockSpeakers.empty())
            return nullptr;
        Creature* speaker = ObjectAccessor::GetCreature(*me, _blockSpeakers[std::min(index, _blockSpeakers.size() - 1)]);
        return speaker && speaker->IsAlive() && speaker->IsAIEnabled ? speaker : nullptr;
    }

    void Arrived() override
    {
        _keepUpdating = true;
        ReleasePassengers();
        End(false);
        _events.ScheduleEvent(EVENT_CRISIS_DISMOUNT_GORKA, 500ms);
    }

    void SceneEvent(uint32 eventId) override
    {
        Player* player = GetRider();
        Creature* gorka = GetNpcRider();
        switch (eventId)
        {
            case EVENT_CRISIS_CALL:
                if (gorka && player)
                    gorka->AI()->Talk(EMOTE_GORKA_CALLS, player);
                _events.ScheduleEvent(EVENT_CRISIS_COME, 1500ms);
                break;
            case EVENT_CRISIS_COME:
                me->SetWalk(false);
                me->GetMotionMaster()->MovePoint(POINT_RIDE_TO_RIDER, CrisisMountSpot.GetPositionX(), CrisisMountSpot.GetPositionY(), CrisisMountSpot.GetPositionZ(), true);
                break;
            case EVENT_CRISIS_MOUNT_TIMEOUT:
                if (!_boarded)
                    End(true);
                break;
            case EVENT_CRISIS_GO:
                if (!SeatRiders(gorka, SPELL_GORKA_RIDE_BRUTUSK, SPELL_RIDE_BRUTUSK_II))
                {
                    End(true);
                    return;
                }
                if (gorka && player)
                    gorka->AI()->Talk(SAY_GORKA_TO_MORSHAN, player);
                BeginRide();
                break;
            case EVENT_CRISIS_LEAPER_DIES:
                KillActors(_leaper);
                break;
            case EVENT_CRISIS_OUT_OF_OUR_WAY:
                if (gorka && player)
                    gorka->AI()->Talk(SAY_GORKA_OUT_OF_OUR_WAY, player);
                break;
            case EVENT_CRISIS_KILL_HER:
                if (Creature* speaker = BlockSpeaker(1))
                    if (player)
                        speaker->AI()->Talk(SAY_ASSAILANT_KILL_HER, player);
                break;
            case EVENT_CRISIS_SHOOT:
                if (Creature* speaker = BlockSpeaker(2))
                    if (player)
                        speaker->AI()->Talk(SAY_ASSAILANT_SHOOT, player);
                break;
            case EVENT_CRISIS_FIRE:
                if (Creature* speaker = BlockSpeaker(1))
                    if (player)
                        speaker->AI()->Talk(SAY_ASSAILANT_FIRE, player);
                break;
            case EVENT_CRISIS_UNGHH:
                if (gorka && player)
                    gorka->AI()->Talk(SAY_GORKA_UNGHH, player);
                break;
            case EVENT_CRISIS_WOUNDED:
                if (gorka && player)
                    gorka->AI()->Talk(SAY_GORKA_WOUNDED, player);
                break;
            case EVENT_CRISIS_DISMOUNT_GORKA:
                if (gorka)
                {
                    gorka->SetWalk(true);
                    gorka->GetMotionMaster()->MovePoint(POINT_ACTOR_MOVE, me->GetPositionX() + 2.5f, me->GetPositionY() + 3.0f, me->GetPositionZ(), true);
                }
                _events.ScheduleEvent(EVENT_CRISIS_COLLAPSE, 1500ms);
                break;
            case EVENT_CRISIS_COLLAPSE:
                if (gorka)
                {
                    gorka->SetStandState(UNIT_STAND_STATE_KNEEL);
                    if (player)
                        gorka->AI()->Talk(SAY_GORKA_FINISHED, player);
                }
                if (CrisisCreditOnCollapse && player)
                    GiveRideCredit(player, QUEST_CRISIS_AT_SPLINTERTREE, 0, NPC_GORKA_RIDER);
                _events.ScheduleEvent(EVENT_CRISIS_SERVED, 3s);
                _events.ScheduleEvent(EVENT_CRISIS_LEAVE, 2s);
                break;
            case EVENT_CRISIS_SERVED:
                if (gorka && player)
                    gorka->AI()->Talk(SAY_GORKA_SERVED, player);
                if (!CrisisCreditOnCollapse && player)
                    GiveRideCredit(player, QUEST_CRISIS_AT_SPLINTERTREE, 0, NPC_GORKA_RIDER);
                _events.ScheduleEvent(EVENT_CRISIS_DEAD, 6s);
                break;
            case EVENT_CRISIS_DEAD:
                if (gorka)
                {
                    gorka->SetStandState(UNIT_STAND_STATE_DEAD);
                    gorka->DespawnOrUnsummon(60000);
                }
                DespawnActors(0);
                _keepUpdating = false;
                me->DespawnOrUnsummon();
                break;
            case EVENT_CRISIS_LEAVE:
                // Brutusk trots back out of the gate (he goes with the scene's end)
                me->SetWalk(true);
                me->GetMotionMaster()->MovePoint(POINT_ACTOR_MOVE, 1290.0f, -2236.0f, 91.87f, true);
                break;
            default:
                break;
        }
    }

    std::vector<ObjectGuid> _bowmen;
    std::vector<ObjectGuid> _leaper;
    std::vector<ObjectGuid> _blockSpeakers;
};

// ---------------------------------------------------------------------------------------------------------------------------
// 13712 To the Rescue! - 34007 Brutusk III with Kadrak 34006 in the saddle
// What the player sees (sourced: the wiki's "removed from game" section, BT 34047 34049 34160 34087 34094 34111-34114 34117
// 34164 34165 34171 34182, comments 2011-09-17 / 2011-12-16 ("Lightning Bolts at group 1, War Stomps on groups 2-3, then
// Lightning Bolts on group 4"), the wiki's Brutusk page; second-pass.md: ~1:35-1:50 to the gate, a Raging Ancient there):
// "Now... witness the power of a war kodo in the hands of a master!" - Brutusk comes, Kadrak takes the saddle and the player
// sits behind him; "To Splintertree!"; group 1 of elves: "Make 'em pay, Brutusk!", Brutusk's chain lightning fells them,
// Kadrak laughs, "Teach them the meaning of blood and thunder!"; groups 2 and 3: Brutusk leaps among them and stomps
// (Kodo Stomp), "Lok'tar Ogar!!"; "Not far now...."; "Splintertree..."; group 4 lightning, "We must break the siege!",
// "For the Horde!!", "Open the gates brothers! Let us welcome our visitors in true Horde fashion!"; guards pour out of the
// gate ("Blood and Thunder!", "For the Horde!!") and fight the skirmishers, "Drive them back! Back to Darnassus!", Brutusk
// lightnings the skirmishers; a Raging Ancient throws a boulder at Brutusk, who falls; both riders are thrown off,
// "Brutusk... NOOOOOO!!"; Kadrak throws his axe and the Ancient falls; "The siege is broken... for now. Follow me to
// Splintertree." - the player is credited ("Splintertree Post Siege Broken", 64506 Kill Credit on himself) and Kadrak walks
// into Splintertree to where his Splintertree self stands, and goes.
// Where: the battlefield in front of the closed gate (wiki); the gate stays shut (three stacked public gate models) and the
// guards appear at its foot. The Ancient's throw is an emote, not 64477 (see EVENT_RESCUE_BOULDER).
// Ours: the route, the actors' entries, counts and spots (the 1802 scene entries with no spawns, private copies), the timing
// of every line, the axe (an emote, the Ancient killed by script), Brutusk lying dead 60 s (a stand state: he keeps his AI so
// the scene can finish), the credit after "The siege is broken" and not at the boulder.
// ---------------------------------------------------------------------------------------------------------------------------
enum RescueScene
{
    EVENT_RESCUE_MOUNT_TIMEOUT    = EVENT_SCENE_FIRST,
    EVENT_RESCUE_GO,
    EVENT_RESCUE_G1_DIE,
    EVENT_RESCUE_G1_LAUGH,
    EVENT_RESCUE_G2_DIE,
    EVENT_RESCUE_G3_DIE,
    EVENT_RESCUE_G4_DIE,
    EVENT_RESCUE_OPEN_GATES,
    EVENT_RESCUE_GUARDS_YELL,
    EVENT_RESCUE_DRIVE_BACK,
    EVENT_RESCUE_GATE_LIGHTNING,
    EVENT_RESCUE_GATE_SKIRMISHERS_DIE,
    EVENT_RESCUE_BOULDER,
    EVENT_RESCUE_BRUTUSK_FALLS,
    EVENT_RESCUE_NOOO,
    EVENT_RESCUE_AXE,
    EVENT_RESCUE_ANCIENT_DIES,
    EVENT_RESCUE_SIEGE_BROKEN,
    EVENT_RESCUE_KADRAK_LEAVES,
    EVENT_RESCUE_CLEANUP,
};

struct npc_nb_brutusk_rescue : public npc_nb_brutusk_ride_base
{
    npc_nb_brutusk_rescue(Creature* creature)
        : npc_nb_brutusk_ride_base(creature, RescueRoute, std::extent<decltype(RescueRoute)>::value, RescueRate) { }

    void SetGUID(ObjectGuid guid, int32 id) override
    {
        if (id != DATA_RIDER_GUID)
            return;
        _npcRiderGUID = guid;
        me->SetWalk(false);
        me->GetMotionMaster()->MovePoint(POINT_RIDE_TO_RIDER, RescueMountSpot.GetPositionX(), RescueMountSpot.GetPositionY(), RescueMountSpot.GetPositionZ(), true);
        _events.ScheduleEvent(EVENT_RESCUE_MOUNT_TIMEOUT, 20s);
    }

    void ReachedRider() override
    {
        if (!_boarded)
            _events.ScheduleEvent(EVENT_RESCUE_GO, 500ms);
    }

    void KadrakSays(uint8 group)
    {
        Creature* kadrak = GetNpcRider();
        Player* player = GetRider();
        if (kadrak && player && kadrak->IsAIEnabled)
            kadrak->AI()->Talk(group, player);
    }

    void ReachedPoint(size_t index) override
    {
        Creature* kadrak = GetNpcRider();
        switch (index)
        {
            case 3:
                SummonGroup(RescueGroup1, std::extent<decltype(RescueGroup1)>::value, MakeRidePos(RescueRoute[5]), _group1);
                break;
            case 5:
                KadrakSays(SAY_KADRAK_RIDER_MAKE_EM_PAY);
                if (Creature* target = FirstAlive(_group1))
                    DoCast(target, SPELL_BRUTUSK_CHAIN_LIGHTNING, true);
                _events.ScheduleEvent(EVENT_RESCUE_G1_DIE, 1s);
                _events.ScheduleEvent(EVENT_RESCUE_G1_LAUGH, 2s);
                break;
            case 9:
                SummonGroup(RescueGroup2, std::extent<decltype(RescueGroup2)>::value, MakeRidePos(RescueRoute[11]), _group2);
                break;
            case 11:
                DoCast(me, SPELL_KODO_STOMP, true);
                KadrakSays(SAY_KADRAK_RIDER_LOKTAR);
                _events.ScheduleEvent(EVENT_RESCUE_G2_DIE, 800ms);
                break;
            case 13:
                SummonGroup(RescueGroup3, std::extent<decltype(RescueGroup3)>::value, MakeRidePos(RescueRoute[15]), _group3);
                break;
            case 14:
                // The wiki's order: Lok'tar at the first stomp, the Barrow Den, "Not far now...", the second stomp
                KadrakSays(SAY_KADRAK_RIDER_NOT_FAR);
                break;
            case 15:
                DoCast(me, SPELL_KODO_STOMP, true);
                if (kadrak)
                    kadrak->HandleEmoteCommand(EMOTE_ONESHOT_LAUGH);
                _events.ScheduleEvent(EVENT_RESCUE_G3_DIE, 800ms);
                break;
            case 19:
                SummonGroup(RescueGroup4, std::extent<decltype(RescueGroup4)>::value, MakeRidePos(RescueRoute[21]), _group4);
                break;
            case 20:
                KadrakSays(SAY_KADRAK_RIDER_SPLINTERTREE);
                break;
            case 21:
                if (Creature* target = FirstAlive(_group4))
                    DoCast(target, SPELL_BRUTUSK_CHAIN_LIGHTNING, true);
                _events.ScheduleEvent(EVENT_RESCUE_G4_DIE, 1s);
                SummonGateScene();
                break;
            default:
                break;
        }
    }

    void SummonGateScene()
    {
        SummonGroup(RescueGateSkirmishers, std::extent<decltype(RescueGateSkirmishers)>::value, RescueGatePos, _gateSkirmishers);
        SummonGroup(RescueGateGuards, std::extent<decltype(RescueGateGuards)>::value, MakeRidePos(RescueRoute[std::extent<decltype(RescueRoute)>::value - 1]), _gateGuards);
        ActorSpot const ancient[] = { RescueGateAncient };
        SummonGroup(ancient, 1, MakeRidePos(RescueRoute[std::extent<decltype(RescueRoute)>::value - 1]), _ancient);
    }

    // Stopped in front of the closed gate: the gate scene plays here and Brutusk stays until it ends
    void Arrived() override
    {
        _keepUpdating = true;
        _events.CancelEvent(EVENT_RIDE_TIMEOUT);
        me->SetFacingTo(me->GetAngle(&RescueGatePos));
        KadrakSays(SAY_KADRAK_RIDER_FOR_THE_HORDE);
        _events.ScheduleEvent(EVENT_RESCUE_OPEN_GATES, 2500ms);
    }

    void SceneEvent(uint32 eventId) override
    {
        Player* player = GetRider();
        Creature* kadrak = GetNpcRider();
        switch (eventId)
        {
            case EVENT_RESCUE_MOUNT_TIMEOUT:
                if (!_boarded)
                    End(true);
                break;
            case EVENT_RESCUE_GO:
                if (!SeatRiders(kadrak, SPELL_KADRAK_RIDE_BRUTUSK, SPELL_RIDE_BRUTUSK_III))
                {
                    End(true);
                    return;
                }
                KadrakSays(SAY_KADRAK_RIDER_GO);
                BeginRide();
                break;
            case EVENT_RESCUE_G1_DIE:
                KillActors(_group1);
                break;
            case EVENT_RESCUE_G1_LAUGH:
                if (kadrak)
                    kadrak->HandleEmoteCommand(EMOTE_ONESHOT_LAUGH);
                KadrakSays(SAY_KADRAK_RIDER_BLOOD_THUNDER);
                break;
            case EVENT_RESCUE_G2_DIE:
                KillActors(_group2);
                break;
            case EVENT_RESCUE_G3_DIE:
                KillActors(_group3);
                break;
            case EVENT_RESCUE_G4_DIE:
                KillActors(_group4);
                KadrakSays(SAY_KADRAK_RIDER_SIEGE);
                break;
            case EVENT_RESCUE_OPEN_GATES:
            {
                KadrakSays(SAY_KADRAK_RIDER_OPEN_GATES);
                // The guards run out towards the skirmishers and fight them (emotes)
                size_t i = 0;
                for (ObjectGuid const& guid : _gateGuards)
                {
                    Creature* guard = ObjectAccessor::GetCreature(*me, guid);
                    Creature* foe = _gateSkirmishers.empty() ? nullptr : ObjectAccessor::GetCreature(*me, _gateSkirmishers[i % _gateSkirmishers.size()]);
                    ++i;
                    if (!guard || !foe)
                        continue;
                    guard->SetWalk(false);
                    guard->GetMotionMaster()->MovePoint(POINT_ACTOR_MOVE, foe->GetPositionX() + 2.0f, foe->GetPositionY() + 1.5f, foe->GetPositionZ(), true);
                    guard->AI()->SetGUID(foe->GetGUID(), 0);
                    guard->AI()->DoAction(ACTION_ACTOR_FIGHT_EMOTES);
                    foe->AI()->SetGUID(guard->GetGUID(), 0);
                    foe->AI()->DoAction(ACTION_ACTOR_FIGHT_EMOTES);
                }
                _events.ScheduleEvent(EVENT_RESCUE_GUARDS_YELL, 1500ms);
                _events.ScheduleEvent(EVENT_RESCUE_DRIVE_BACK, 3s);
                break;
            }
            case EVENT_RESCUE_DRIVE_BACK:
                KadrakSays(SAY_KADRAK_RIDER_DRIVE_BACK);
                _events.ScheduleEvent(EVENT_RESCUE_GATE_LIGHTNING, 2s);
                _events.ScheduleEvent(EVENT_RESCUE_BOULDER, 4500ms);
                break;
            case EVENT_RESCUE_GUARDS_YELL:
                if (player)
                    for (size_t i = 0; i < _gateGuards.size() && i < 2; ++i)
                        if (Creature* guard = ObjectAccessor::GetCreature(*me, _gateGuards[i * 2 < _gateGuards.size() ? i * 2 : i]))
                            guard->AI()->Talk(i == 0 ? SAY_GUARD_BLOOD_AND_THUNDER : SAY_GUARD_FOR_THE_HORDE, player);
                break;
            case EVENT_RESCUE_GATE_LIGHTNING:
                if (Creature* target = FirstAlive(_gateSkirmishers))
                {
                    me->SetFacingToObject(target);
                    DoCast(target, SPELL_BRUTUSK_CHAIN_LIGHTNING, true);
                }
                _events.ScheduleEvent(EVENT_RESCUE_GATE_SKIRMISHERS_DIE, 1s);
                break;
            case EVENT_RESCUE_GATE_SKIRMISHERS_DIE:
                KillActors(_gateSkirmishers);
                break;
            case EVENT_RESCUE_BOULDER:
                // The throw is an emote: 64477 Throw Brutusk Boulder is a dummy whose TARGET_UNIT_NEARBY_ENTRY search runs
                // at its 50 000 yd range (range index 13) over every cell of the map; it would show nothing more
                if (Creature* ancient = FirstAlive(_ancient))
                {
                    ancient->SetFacingToObject(me);
                    ancient->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK_THROWN);
                }
                _events.ScheduleEvent(EVENT_RESCUE_BRUTUSK_FALLS, 1500ms);
                break;
            case EVENT_RESCUE_BRUTUSK_FALLS:
                ReleasePassengers();
                End(false);
                me->SetStandState(UNIT_STAND_STATE_DEAD);
                // Ours: the player lands among the Splintertree siege statics (33914 / 33945, hostile, mop's phase 1;
                // retail phased the siege away with this quest, Ashenvale hand-off). He stays unselectable until the scene
                // has ended, ~12 s, so they cannot pull him while it plays.
                if (player && player->IsInWorld() && !player->HasFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE))
                {
                    player->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                    player->m_Events.AddLambdaEventAtOffset([player]()
                    {
                        if (!player->GetVehicle() && !player->IsInFlight())
                            player->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                    }, 12000);
                }
                _events.ScheduleEvent(EVENT_RESCUE_NOOO, 1s);
                break;
            case EVENT_RESCUE_NOOO:
                KadrakSays(SAY_KADRAK_RIDER_NOOO);
                _events.ScheduleEvent(EVENT_RESCUE_AXE, 2500ms);
                break;
            case EVENT_RESCUE_AXE:
                if (Creature* ancient = FirstAlive(_ancient))
                    if (kadrak)
                    {
                        kadrak->SetFacingToObject(ancient);
                        kadrak->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK_THROWN);
                    }
                _events.ScheduleEvent(EVENT_RESCUE_ANCIENT_DIES, 800ms);
                break;
            case EVENT_RESCUE_ANCIENT_DIES:
                if (Creature* ancient = FirstAlive(_ancient))
                    (kadrak ? static_cast<Unit*>(kadrak) : static_cast<Unit*>(me))->Kill(ancient);
                _events.ScheduleEvent(EVENT_RESCUE_SIEGE_BROKEN, 2s);
                break;
            case EVENT_RESCUE_SIEGE_BROKEN:
                KadrakSays(SAY_KADRAK_RIDER_SIEGE_BROKEN);
                if (player)
                    GiveRideCredit(player, QUEST_TO_THE_RESCUE, SPELL_TO_THE_RESCUE_KILL_CREDIT, NPC_BRUTUSK_RESCUE);
                _events.ScheduleEvent(EVENT_RESCUE_KADRAK_LEAVES, 3s);
                break;
            case EVENT_RESCUE_KADRAK_LEAVES:
                if (kadrak)
                {
                    kadrak->SetWalk(true);
                    kadrak->GetMotionMaster()->MovePoint(POINT_ACTOR_DESPAWN, RescueKadrakHome.GetPositionX(), RescueKadrakHome.GetPositionY(), RescueKadrakHome.GetPositionZ(), true);
                    kadrak->DespawnOrUnsummon(50000);   // 92 yd at walking pace
                }
                _events.ScheduleEvent(EVENT_RESCUE_CLEANUP, 15s);
                break;
            case EVENT_RESCUE_CLEANUP:
                DespawnActors(0);
                _keepUpdating = false;
                me->DespawnOrUnsummon(45000);
                break;
            default:
                break;
        }
    }

    std::vector<ObjectGuid> _group1, _group2, _group3, _group4;
    std::vector<ObjectGuid> _gateGuards, _gateSkirmishers, _ancient;
};

// ---------------------------------------------------------------------------------------------------------------------------
// Starting the gossip rides
// ---------------------------------------------------------------------------------------------------------------------------
// Both starts return whether the ride was set up, so the giver speaks only then (a second click while one is being set up
// does nothing and says nothing).
static bool StartCrisisRide(Creature* gorka, Player* player)
{
    if (!CanStartRide(player) || HasOwnPrivateCreature(player, NPC_BRUTUSK_CRISIS, 150.0f))
        return false;

    Creature* rider = player->SummonCreature(NPC_GORKA_RIDER, gorka->GetPosition(), TEMPSUMMON_MANUAL_DESPAWN, 0ms, 0, player->GetGUID());
    Creature* brutusk = player->SummonCreature(NPC_BRUTUSK_CRISIS, CrisisBrutuskSpawn, TEMPSUMMON_MANUAL_DESPAWN, 0ms, 0, player->GetGUID());
    if (!rider || !brutusk || !brutusk->GetVehicleKit() || !brutusk->IsAIEnabled)
    {
        TC_LOG_ERROR("scripts", "zone_northern_barrens_morshan: could not set up Crisis at Splintertree for %s", player->GetName().c_str());
        if (rider)
            rider->DespawnOrUnsummon();
        if (brutusk)
            brutusk->DespawnOrUnsummon();
        return false;
    }
    rider->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);   // she shoots the leaping skirmisher
    brutusk->AI()->SetGUID(rider->GetGUID(), DATA_RIDER_GUID);
    return true;
}

static bool StartRescueRide(Creature* kadrak, Player* player)
{
    if (!CanStartRide(player) || HasOwnPrivateCreature(player, NPC_BRUTUSK_RESCUE, 150.0f))
        return false;

    Position riderPos = kadrak->GetPosition();
    kadrak->MovePosition(riderPos, 2.0f, float(M_PI) / 2.0f);   // 64240 summons him beside Kadrak
    Creature* rider = player->SummonCreature(NPC_KADRAK_RIDER, riderPos, TEMPSUMMON_MANUAL_DESPAWN, 0ms, 0, player->GetGUID());
    Creature* brutusk = player->SummonCreature(NPC_BRUTUSK_RESCUE, RescueBrutuskSpawn, TEMPSUMMON_MANUAL_DESPAWN, 0ms, 0, player->GetGUID());
    if (!rider || !brutusk || !brutusk->GetVehicleKit() || !brutusk->IsAIEnabled)
    {
        TC_LOG_ERROR("scripts", "zone_northern_barrens_morshan: could not set up To the Rescue! for %s", player->GetName().c_str());
        if (rider)
            rider->DespawnOrUnsummon();
        if (brutusk)
            brutusk->DespawnOrUnsummon();
        return false;
    }
    rider->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC);
    brutusk->AI()->SetGUID(rider->GetGUID(), DATA_RIDER_GUID);

    if (KadrakSharedBrutusk)
        if (Aura* busy = kadrak->AddAura(SPELL_KADRAK_GOSSIP_TIMER, kadrak))
        {
            busy->SetMaxDuration(150 * IN_MILLISECONDS);
            busy->SetDuration(150 * IN_MILLISECONDS);
        }
    return true;
}

// The 5.3 shortcut (questions.md Q6 default): the existing taxi path 1253 The Mor'Shan Ramparts -> Splintertree Post stands in
// for the wind rider 71585, which has no vehicle in this core (second-pass.md: in 5.4.0 a single-seat wind rider flew ~56 s
// from the Mor'shan gate into Splintertree). Player::ActivateTaxiPathTo would refuse (Kadrak stands 32 yd from node 354's
// spot, "too far away") and charge the 5s30c fare, so the flight is started as it does it (its refusals, interrupts and
// clean-ups, Player.cpp ActivateTaxiPathTo), free and without the spot check. The credit (on choosing, Q6) is given only once
// the flight is sure to start.
static bool StartShortcutFlight(Player* player)
{
    uint32 path = 0, cost = 0;
    sObjectMgr->GetTaxiPath(TAXI_NODE_MORSHAN, TAXI_NODE_SPLINTERTREE, path, cost);
    uint32 const mountDisplay = sObjectMgr->GetTaxiMountDisplayId(TAXI_NODE_MORSHAN, player->GetTeam(), true);
    TaxiNodesEntry const* endNode = sTaxiNodesStore.LookupEntry(TAXI_NODE_SPLINTERTREE);
    if (!path || !mountDisplay || !endNode)
    {
        TC_LOG_ERROR("scripts", "zone_northern_barrens_morshan: no taxi path %u -> %u", uint32(TAXI_NODE_MORSHAN), uint32(TAXI_NODE_SPLINTERTREE));
        return false;
    }
    if (player->GetSession()->isLogingOut() || player->HasUnitState(UNIT_STATE_STUNNED) || player->HasUnitState(UNIT_STATE_ROOT)
        || player->HasFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_DISABLE_MOVE))
    {
        player->GetSession()->SendActivateTaxiReply(ERR_TAXI_PLAYER_BUSY);
        return false;
    }

    GiveRideCredit(player, QUEST_TO_THE_RESCUE, SPELL_TO_THE_RESCUE_KILL_CREDIT, NPC_BRUTUSK_RESCUE);

    player->InterruptNonMeleeSpells(false);
    PrepareForRide(player);
    player->CombatStop();
    player->StopCastingCharm();
    player->StopCastingBindSight();
    player->ExitVehicle();
    player->TradeCancel(true);
    if (sWorld->getBoolConfig(CONFIG_INSTANT_TAXI))
    {
        player->TeleportTo(endNode->map_id, endNode->x, endNode->y, endNode->z, player->GetOrientation());
        return true;
    }

    player->m_taxi.ClearTaxiDestinations();
    player->m_taxi.AddTaxiDestination(TAXI_NODE_MORSHAN);
    player->m_taxi.AddTaxiDestination(TAXI_NODE_SPLINTERTREE);
    player->GetSession()->SendActivateTaxiReply(ERR_TAXI_OK);
    player->GetSession()->SendDoFlight(mountDisplay, path);
    return true;
}

// 8582 - Kadrak (Mor'shan; menu 10411)
// What the player sees (sourced: wiki, BT 33514 / 33515, 34040 / 34047, 34045, 74240 / 74241, comments on 13628 and 13712):
//  - with Got Wood? and no reins: "Truun is in need of lumber from the Warsong Camp. I need to use Brutusk to haul it." -
//    Kadrak: "Very well, <class>. But be careful, Brutusk can be very... spirited." and the reins are in his bags.
//  - with To the Rescue!: "I am ready to accompany you to Splintertree, Kadrak!" starts the ride; "This seems urgent,
//    Kadrak. There must be another way!" - "Very well, <name>. I'll meet you there." and a flight to Splintertree.
// Ours (questions.md Q5 / Q6 defaults): both 13712 options always side by side (private rides make the busy page needless);
// the shortcut credits on choosing it, so an interrupted flight cannot lose it. "I will check back with you shortly" (BT
// 34045) only shows while Kadrak holds 64243, which only the shared mode (KadrakSharedBrutusk) sets.
// Kadrak 8582 never moves or phases (29111's turn-in in every state, plan S3-6).
struct npc_nb_kadrak : public ScriptedAI
{
    npc_nb_kadrak(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
    {
        if (menuId != MENU_KADRAK)
            return false;

        switch (gossipListId)
        {
            case OPTION_KADRAK_REINS:
                CloseGossipMenuFor(player);
                if (player->GetQuestStatus(QUEST_GOT_WOOD) != QUEST_STATUS_INCOMPLETE || player->HasItemCount(ITEM_KADRAKS_REINS, 1, false))
                    return true;
                // The option shows while the reins are not in the bags; reins left in the bank (maxcount 1) are pointed out
                // instead of a second pair (ours: the click needs them in the bags)
                if (player->HasItemCount(ITEM_KADRAKS_REINS, 1, true))
                {
                    player->GetSession()->SendNotification("Your Kadrak's Reins are in your bank.");
                    return true;
                }
                if (player->AddItem(ITEM_KADRAKS_REINS, 1))
                    Talk(SAY_KADRAK_REINS, player);
                return true;
            case OPTION_KADRAK_READY:
                CloseGossipMenuFor(player);
                if (player->GetQuestStatus(QUEST_TO_THE_RESCUE) == QUEST_STATUS_INCOMPLETE && !me->HasAura(SPELL_KADRAK_GOSSIP_TIMER)
                    && CanStartRide(player))
                {
                    if (StartRescueRide(me, player))
                        Talk(SAY_KADRAK_READY, player);
                }
                return true;
            case OPTION_KADRAK_CHECK_BACK:
                CloseGossipMenuFor(player);
                return true;
            case OPTION_KADRAK_URGENT:
                CloseGossipMenuFor(player);
                if (player->GetQuestStatus(QUEST_TO_THE_RESCUE) != QUEST_STATUS_INCOMPLETE || !CanStartRide(player))
                    return true;
                if (player->IsInCombat())
                {
                    player->SendGameError(GameError::ERR_NOT_IN_COMBAT);
                    return true;
                }
                if (StartShortcutFlight(player))
                    Talk(SAY_KADRAK_URGENT, player);
                return true;
            default:
                return false;
        }
    }
};

// 33421 - Gorka (Warsong Labor Camp; menu 10342, option 0 "I am ready, Gorka. To Kadrak!")
// Replaces her SmartAI (which credited 13653 on the spot and closed the gossip). Sourced: "Follow me, <name>! Hurry!" (BT
// 33593) and the ride (npc_nb_brutusk_crisis). The option is shown only with 13653 in the log, incomplete (SQL).
struct npc_nb_gorka : public ScriptedAI
{
    npc_nb_gorka(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
    {
        if (menuId != MENU_GORKA || gossipListId != OPTION_GORKA_READY)
            return false;

        CloseGossipMenuFor(player);
        if (player->GetQuestStatus(QUEST_CRISIS_AT_SPLINTERTREE) != QUEST_STATUS_INCOMPLETE || !CanStartRide(player))
            return true;
        if (StartCrisisRide(me, player))
            Talk(SAY_GORKA_FOLLOW, player);
        return true;
    }
};

void AddSC_northern_barrens_morshan()
{
    new creature_script<npc_nb_morshan_actor>("npc_nb_morshan_actor");
    new creature_script<npc_nb_brutusk_parked>("npc_nb_brutusk_parked");
    new creature_script<npc_nb_brutusk_got_wood>("npc_nb_brutusk_got_wood");
    new creature_script<npc_nb_brutusk_crisis>("npc_nb_brutusk_crisis");
    new creature_script<npc_nb_brutusk_rescue>("npc_nb_brutusk_rescue");
    new creature_script<npc_nb_kadrak>("npc_nb_kadrak");
    new creature_script<npc_nb_gorka>("npc_nb_gorka");
    new aura_script<spell_nb_ride_brutusk>("spell_nb_ride_brutusk");
}
