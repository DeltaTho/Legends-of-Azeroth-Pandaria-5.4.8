/*
* This file is part of the Legends of Azeroth Pandaria Project. See THANKS file for Copyright information
*
* This program is free software; you can redistribute it and/or modify it
* under the terms of the GNU General Public License as published by the
* Free Software Foundation; either version 2 of the License, or (at your
* option) any later version.
*
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
* FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
* more details.
*
* You should have received a copy of the GNU General Public License along
* with this program. If not, see <http://www.gnu.org/licenses/>.
*/

/*
 * Northern Barrens: the Whipshank caravans. Four kodo rides driven by Balgor Whipshank and the Burning Blade ambush at
 * Dreadmist Camp:
 *   ride 1  Crossroads Caravan Pickup 13949    Halga Bloodeye (Far Watch Post) -> Grol'dom Farm, Razormane Raiders
 *   ride 2  Crossroads Caravan Delivery 13975  Rocco Whipshank (Grol'dom Farm) -> the Crossroads, Burning Blade on wolves
 *   ride 3  Mor'shan Caravan Pick-Up 29109     Rocco Whipshank (the Crossroads) -> Dreadmist Camp, then the ambush
 *   ride 4  Mor'shan Caravan Delivery 29111    Nagala Whipshank (Dreadmist Camp) -> Mor'shan Rampart, wolf and wind riders
 *
 * Research: research\northern-barrens\dossiers\B.md ("Caravan event brief" and the quest walks), plan.md section S2, the
 * second research pass (29111 video: ~140 s ride, 1-4 attackers on screen at once, fliers from ~20 s in). The pattern is the
 * EPL caravan (zone_eastern_plaguelands_caravan.cpp, npc_epl_caravan_harness): seat the rider, drive the road point by point
 * with path finding, check the rider every half second, credit only a seated rider, take everything away on every exit.
 *
 * Seats (the DBC, read 2026-11-20). The kodos of rides 1 and 2 (vehicles 415 / 422) have a driver seat 0 and a seat 1 that can
 * be entered and cast from, but a passenger who does not control his vehicle cannot cast its spells here
 * (WorldSession::HandleCastSpellOpcode casts from the mover only; HandlePetCastSpellOpcode only from the charm). The data has
 * the answer: "Riding Shotgun" 34438 (vehicle 418) and "The Hotseat" 34582 (vehicle 424) each have one seat that controls and
 * casts, offset 2.2 yd down onto a kodo saddle, and their sniffed copies stand exactly where the ride 1 kodo is summoned
 * (three at 65486's spot) and beside the ride 2 kodo's copy. They are turrets: seat 1 of the kodo carries the turret and the
 * player sits in the turret, which he controls (Unit::SetCharmedBy, CHARM_TYPE_VEHICLE), so its spell1-2 are his bar (Shoot;
 * Shoot + Face Smash). Ride 3's kodo (vehicle 1580, inferred: dossier U-2) has a plain seat 1 (no bar). Ride 4's kodo
 * (vehicle 1587) has seat 1 with CAN_CONTROL + CAN_CAST: the player charms the kodo itself and his bar is its spell1-3; the
 * script keeps the AI (OnCharmed overridden) and takes the client's movement control away (SetClientControl 0), as
 * zone_gilneas.cpp's hippogryph and Krennan's horse.
 *
 * Balgor is put into seat 0 by the script (46598 with the seat in its base points), not by vehicle_template_accessory and a
 * spellclick row: a player's spellclick with 65466 (base points 1 = seat 0) would throw him out (Vehicle::AddPassenger ejects
 * whoever sits in a named seat; dossier B, E-7), so the kodos have no spellclick row at all and a right-click does nothing.
 *
 * Sourced vs ours is said at each part. Constants marked "ours" are the choice points for the test rounds.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "SpellScript.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "MotionMaster.h"
#include "CreatureTextMgr.h"
#include "WorldSession.h"
#include "SpellMgr.h"

enum NorthernBarrensCaravans
{
    // The kodos (summoned public, owned by the player who asked for the ride)
    NPC_LEAD_CARAVAN_KODO           = 34430,   // ride 1, vehicle 415
    NPC_HEAD_CARAVAN_KODO           = 34577,   // ride 2, vehicle 422
    NPC_CHIEF_CARAVAN_KODO          = 52209,   // ride 3, vehicle 1580 (set by 2026_11_29_22)
    NPC_MASTER_CARAVAN_KODO         = 52314,   // ride 4, vehicle 1587

    NPC_BALGOR_RIDES_1_2            = 34431,
    NPC_BALGOR_RIDE_3               = 52227,
    NPC_BALGOR_RIDE_4               = 52333,

    NPC_RIDING_SHOTGUN              = 34438,   // ride 1 turret, vehicle 418
    NPC_THE_HOTSEAT                 = 34582,   // ride 2 turret, vehicle 424

    NPC_FAR_WATCH_CARAVAN_KODO      = 34432,   // 65494 Call a Pack Kodo
    NPC_CROSSROADS_CARAVAN_KODO     = 34576,   // 65663 Call a Pack Kodo 2
    NPC_CROSSROADS_CARAVAN_CART     = 52211,   // 96548 Call a Pack Kodo 3
    NPC_MORSHAN_CARAVAN_CART        = 52316,   // 96750 Call a Pack Kodo 4

    NPC_HALGA_BLOODEYE              = 34258,
    NPC_ROCCO_GROLDOM               = 34578,
    NPC_ROCCO_CROSSROADS            = 52220,
    NPC_NAGALA_WHIPSHANK            = 52207,

    // Attackers (summon spells 65496, 65692, 96786, 96925; summoned here by the kodo)
    NPC_RAZORMANE_RAIDER            = 34487,
    NPC_BURNING_BLADE_MOUNT_2       = 34593,   // vehicle 423
    NPC_BURNING_BLADE_RAIDER        = 34594,
    NPC_BURNING_BLADE_MOUNT_4       = 52337,   // vehicle 1591
    NPC_BURNING_BLADE_ATTACKER      = 52338,
    NPC_BURNING_BLADE_FLYER         = 52385,   // vehicle 1599
    NPC_BURNING_BLADE_WINDRIDER     = 52386,

    // The ambush (96655 / 96656 / 96692); genders from creature_model_info: 52274 female, 52275 / 52276 male
    NPC_AMBUSHER_CART_THIEF         = 52274,   // female: "Quickly now! Grab one of them while I take the supply cart!"
    NPC_AMBUSHER_KIDNAPPER          = 52275,   // vehicle 1585 (seat 9777 carries Balgor): "Which one should I take?"
    NPC_AMBUSHER_GREETER            = 52276,   // "The Burning Blade sends its greetings."

    QUEST_CROSSROADS_CARAVAN_PICKUP   = 13949,
    QUEST_CROSSROADS_CARAVAN_DELIVERY = 13975,
    QUEST_MORSHAN_CARAVAN_PICKUP      = 29109,
    QUEST_MORSHAN_CARAVAN_DELIVERY    = 29111,

    NPC_CREDIT_CARAVAN_1            = 53613,   // "Caravan Escorted" (65561)
    NPC_CREDIT_CARAVAN_2            = 65892,   // "Crossroads Caravan Escorted" (no spell gives it)
    NPC_CREDIT_SPEAK_ROCCO          = 52445,   // 96566 effect 1, on the caster
    NPC_CREDIT_RIDE_TO_DREADMIST    = 52303,   // 96795, the rider
    NPC_CREDIT_SPEAK_NAGALA         = 52505,   // 96749 effect 1, on the caster
    NPC_CREDIT_RIDE_DEFENDED        = 52326,   // 96788, the rider

    MENU_HALGA                      = 10514,
    MENU_ROCCO_GROLDOM              = 10528,
    MENU_ROCCO_CROSSROADS           = 12744,
    MENU_NAGALA                     = 12754,

    SPELL_RIDE_VEHICLE_HARDCODED    = 46598,   // base points 0 = seat + 1
    SPELL_PERMANENT_FEIGN_DEATH     = 29266,   // 34576's template aura (the dead kodo by the Crossroads uses the entry too)
    SPELL_BURNING_BLADE_NET         = 96661,   // root + stun, no duration, death persistent; DONT_SAVE by 2026_11_29_22
    SPELL_FACE_SMASH_RIDE_2         = 65704,
    SPELL_FACE_SMASH_RIDE_4         = 96792,
    SPELL_HIT_RAIDER_IN_THE_FACE_2  = 65713,   // 853 damage to the raider (its effect 1)
    SPELL_HIT_RAIDER_IN_THE_FACE_4  = 96806,   // 2441 damage

    // creature_text groups (plan.md 0.3)
    SAY_HALGA_MOUNT_UP              = 0,       // BT 34630 "Mount up, $n! Do not fail me."
    SAY_HALGA_HEAD_EM_UP            = 1,       // BT 34626 "Head 'em up! Move 'em out!"
    SAY_ROCCO_MOUNT_UP              = 0,       // BT 34818 "There she is. Mount up!"
    SAY_ROCCO_RIDE_HARD             = 1,       // BT 35138 "Ride hard and show no mercy!"
    SAY_BALGOR_2_ARRIVAL            = 0,       // 34431, BT 34821 "Incredible shooting! ..."
    EMOTE_BALGOR_DEFEND_THE_KODO    = 1,       // 34431, BT 34625 "Defend the Caravan Kodo!" (wiki: an emote on 13949, a boss
                                               // emote on 13975; a boss whisper to the rider here, ours)
    SAY_BALGOR_1_ARRIVAL            = 2,       // 34431, BT 34667 "Excellent work! I'll unload the goods. ..." (wiki 13949)
    SAY_BALGOR_2_BURNING_BLADE      = 3,       // 34431, BT 35139 "The Burning Blade? What are they doing here? Shoot to kill!"
    SAY_BALGOR_3_ALL_ABOARD         = 0,       // 52227 groups 0-6: BT 50942 50943 50944 51151 51214 50945 51300
    SAY_BALGOR_3_HO_NAGALA          = 7,       // BT 50968
    SAY_BALGOR_3_HEY                = 8,       // BT 50954
    SAY_BALGOR_3_HELP               = 9,       // BT 51303
    SAY_NAGALA_HUG                  = 0,       // BT 50969
    SAY_NAGALA_NO                   = 1,       // BT 50971
    SAY_GREETER_GREETINGS           = 0,       // 52276, BT 50976
    SAY_THIEF_QUICKLY               = 0,       // 52274, BT 50955
    SAY_THIEF_THE_FAT_ONE           = 1,       // 52274, BT 50975
    SAY_KIDNAPPER_WHICH_ONE         = 0,       // 52275, BT 50970
    SAY_BALGOR_4_HOP_ON             = 0,       // 52333, BT 51228
    SAY_BALGOR_4_SPOTTED            = 1,       // BT 51004 (same id block; inferred place: the first wave)
    SAY_BALGOR_4_ROCKET             = 2,       // BT 51230 "Watch out above us! Use your rocket!"
    SAY_BALGOR_4_GOOD_SHOOTING      = 3,       // BT 51233
    SAY_BALGOR_4_CLOSING_IN         = 4,       // BT 51229
    SAY_BALGOR_4_ALL_SIDES          = 5,       // BT 51231
    SAY_BALGOR_4_MADE_IT            = 6,       // BT 51226

    DATA_CARAVAN_LEAVE              = 1,       // ambusher: leave for the peak
    DATA_CARAVAN_FLEE               = 2,       // attacker: the caravan has arrived, run off

    POINT_CARAVAN_ROAD              = 1,
    POINT_AMBUSHER_IN               = 2,
    POINT_AMBUSHER_OUT              = 3,
    POINT_ATTACKER_FLEE             = 4,
};

enum NorthernBarrensCaravanEvents
{
    EVENT_CARAVAN_BOARD = 1,
    EVENT_CARAVAN_START,
    EVENT_CARAVAN_CHECK,
    EVENT_CARAVAN_TIMEOUT,
    EVENT_CARAVAN_LINE,            // ride 3 chatter
    EVENT_CARAVAN_GIVER_LINE,      // Halga / Rocco after the start
    EVENT_CARAVAN_ATTACKER,
    EVENT_CARAVAN_FLYER,
    EVENT_CARAVAN_FINISH,
    EVENT_CARAVAN_AMBUSH,
    EVENT_CARAVAN_ANNOUNCE,
};

enum CaravanRideIndex
{
    RIDE_FAR_WATCH = 0,
    RIDE_GROLDOM,
    RIDE_CROSSROADS,
    RIDE_DREADMIST,
    MAX_CARAVAN_RIDES
};

// ---------------------------------------------------------------------------------------------------------------------------
// The roads. The ends are sourced (spell_target_position of 65486 / 65662 / 96566; ride 4: the sniffed 52314 copy, as 96749 has
// no destination anywhere); the points between are sourced where the dossier gives them (Wowhead pins of 34431 / 52227 /
// 52333, the sniffed Razormane Raider paths along the Far Watch road, the paths of the sniffed chase targets 52388 / 52391 that
// ran 13 yd either side of the Mor'shan road: the kodo drives between them) and ours elsewhere (Grol'dom north to the east
// road, the last yards into the Crossroads and up to Kadrak). z from the 5.4.8 terrain (research tmp\S2\route.py). Every leg is
// driven as its own MovePoint with path finding (a long linear spline is drawn under the ground by the client: C20).
// Lengths: 784 / 883 / 776 / 1156 yd, at the kodos' run speeds about 115 / 110 / 97 / 145 s (the 29111 video: ~140 s).
// ---------------------------------------------------------------------------------------------------------------------------
static Position const Ride1Road[] =
{
    { 318.0f, -3640.0f, 27.2f }, { 305.0f, -3582.0f, 26.8f }, { 288.0f, -3558.0f, 26.9f }, { 258.0f, -3496.0f, 27.2f },
    { 232.0f, -3452.0f, 28.7f }, { 212.0f, -3424.0f, 30.4f }, { 186.0f, -3385.0f, 37.4f }, { 164.0f, -3346.0f, 46.9f },
    { 152.0f, -3306.0f, 57.9f }, { 152.0f, -3276.0f, 63.5f }, { 155.0f, -3222.0f, 76.0f }, { 166.0f, -3172.0f, 88.2f },
    { 179.0f, -3133.0f, 91.7f }, { 192.0f, -3076.0f, 91.7f }, { 202.0f, -3041.0f, 91.7f }, { 211.0f, -3000.0f, 94.5f },
    { 219.0f, -2966.0f, 91.8f },
};

static Position const Ride2Road[] =
{
    { 212.0f, -2905.0f, 96.4f }, { 196.0f, -2840.0f, 91.7f }, { 178.0f, -2770.0f, 91.7f }, { 160.0f, -2712.0f, 91.7f },
    { 110.0f, -2704.0f, 91.7f }, { 50.0f, -2712.0f, 91.7f }, { -0.8f, -2718.5f, 91.7f }, { -40.0f, -2700.0f, 95.0f },
    { -78.8f, -2684.5f, 95.8f }, { -164.6f, -2684.5f, 92.9f }, { -240.0f, -2684.5f, 95.9f }, { -312.8f, -2684.5f, 93.5f },
    { -354.8f, -2680.9f, 95.8f }, { -410.0f, -2668.0f, 95.7f }, { -452.0f, -2650.0f, 95.5f },
};

static Position const Ride3Road[] =
{
    { -354.8f, -2681.0f, 95.8f }, { -312.8f, -2684.5f, 93.5f }, { -240.0f, -2684.5f, 95.9f }, { -164.6f, -2684.5f, 92.9f },
    { -78.8f, -2684.5f, 95.8f }, { -40.0f, -2700.0f, 95.0f }, { -0.8f, -2718.5f, 91.7f }, { 50.0f, -2712.0f, 91.7f },
    { 110.0f, -2704.0f, 91.7f }, { 155.2f, -2696.0f, 91.7f }, { 210.0f, -2660.0f, 91.8f }, { 265.0f, -2612.0f, 93.5f },
    { 305.0f, -2580.0f, 93.9f }, { 318.0f, -2568.0f, 92.5f },
};

static Position const Ride4Road[] =
{
    { 330.0f, -2560.0f, 91.7f }, { 380.0f, -2600.0f, 93.7f }, { 422.0f, -2624.0f, 91.7f }, { 460.0f, -2618.0f, 91.7f },
    { 500.0f, -2600.0f, 92.0f }, { 551.0f, -2568.0f, 95.9f }, { 590.0f, -2530.0f, 95.8f }, { 612.0f, -2490.0f, 95.0f },
    { 640.0f, -2450.0f, 91.7f }, { 668.0f, -2390.0f, 91.9f }, { 694.0f, -2342.0f, 91.8f }, { 731.0f, -2305.0f, 91.7f },
    { 770.0f, -2288.0f, 91.7f }, { 817.0f, -2288.0f, 91.7f }, { 868.0f, -2286.0f, 91.7f }, { 920.0f, -2285.0f, 91.7f },
    { 972.0f, -2284.0f, 91.7f }, { 1034.0f, -2286.0f, 92.8f }, { 1080.0f, -2300.0f, 91.9f }, { 1128.0f, -2316.0f, 91.7f },
    { 1170.0f, -2312.0f, 91.7f }, { 1207.0f, -2303.0f, 91.7f }, { 1226.0f, -2280.0f, 92.5f }, { 1228.0f, -2262.0f, 92.2f },
};

// Ours: where the Dreadmist ambushers come from (the slope north of the camp) and where they take Balgor and the cart (up
// the torchlit path toward the peak, out of sight from the camp; 52309 waits at the top for 29110).
static Position const AmbushApproach[] =
{
    { 330.0f, -2545.0f, 92.0f },   // 52276, the greeter
    { 305.0f, -2548.0f, 92.0f },   // 52274, the cart thief
    { 326.0f, -2556.0f, 92.0f },   // 52275, the kidnapper
};
static Position const AmbushExit = { 320.0f, -2425.0f, 135.0f };

struct CaravanRide
{
    uint32 Kodo;
    uint32 Quest;
    uint32 Driver;          // Balgor, seat 0 of the kodo
    uint32 Turret;          // seat 1 of the kodo, the player's seat 0 (0: the player sits in the kodo's own seat 1)
    uint32 Pack;            // follows behind
    uint32 Giver;
    uint32 Menu;            // the giver's menu; option 0 starts the ride (E-2)
    int8 GiverLine;         // said on select (-1 none)
    uint32 StartCredit;     // on select (the summon spells' KILL_CREDIT2 on the caster)
    uint32 EndCredit;       // on arrival (ride 3: after the ambush)
    bool Explore;           // SpecialFlags 2 (13949 in the DB, 13975 forced by ObjectMgr for 65670): explored as well
    Position Spawn;
    Position const* Road;
    size_t RoadSize;
};

static CaravanRide const CaravanRides[MAX_CARAVAN_RIDES] =
{
    { NPC_LEAD_CARAVAN_KODO, QUEST_CROSSROADS_CARAVAN_PICKUP, NPC_BALGOR_RIDES_1_2, NPC_RIDING_SHOTGUN, NPC_FAR_WATCH_CARAVAN_KODO,
      NPC_HALGA_BLOODEYE, MENU_HALGA, SAY_HALGA_MOUNT_UP, 0, NPC_CREDIT_CARAVAN_1, true,
      { 321.78f, -3699.07f, 27.03f, 1.48f }, Ride1Road, std::size(Ride1Road) },
    { NPC_HEAD_CARAVAN_KODO, QUEST_CROSSROADS_CARAVAN_DELIVERY, NPC_BALGOR_RIDES_1_2, NPC_THE_HOTSEAT, NPC_CROSSROADS_CARAVAN_KODO,
      NPC_ROCCO_GROLDOM, MENU_ROCCO_GROLDOM, SAY_ROCCO_MOUNT_UP, 0, NPC_CREDIT_CARAVAN_2, true,
      { 217.65f, -2961.46f, 92.22f, 1.67f }, Ride2Road, std::size(Ride2Road) },
    { NPC_CHIEF_CARAVAN_KODO, QUEST_MORSHAN_CARAVAN_PICKUP, NPC_BALGOR_RIDE_3, 0, NPC_CROSSROADS_CARAVAN_CART,
      NPC_ROCCO_CROSSROADS, MENU_ROCCO_CROSSROADS, -1, NPC_CREDIT_SPEAK_ROCCO, NPC_CREDIT_RIDE_TO_DREADMIST, false,
      { -404.69f, -2678.07f, 95.59f, 6.16f }, Ride3Road, std::size(Ride3Road) },
    { NPC_MASTER_CARAVAN_KODO, QUEST_MORSHAN_CARAVAN_DELIVERY, NPC_BALGOR_RIDE_4, 0, NPC_MORSHAN_CARAVAN_CART,
      NPC_NAGALA_WHIPSHANK, MENU_NAGALA, -1, NPC_CREDIT_SPEAK_NAGALA, NPC_CREDIT_RIDE_DEFENDED, false,
      { 286.50f, -2545.60f, 91.80f, 0.09f }, Ride4Road, std::size(Ride4Road) },
};

// Ours (no source gives counts or timers; dossier U-3; the 29111 video gives "1-4 on screen, fliers from ~20 s"):
static uint32 const RIDE_SUMMON_DURATION      = 600;  // s, the summon spells' duration (65486 / 65662 / 96566 / 96749)
static uint32 const RIDE_1_RAIDER_FIRST_MS    = 6000;
static uint32 const RIDE_1_RAIDER_EVERY_MS    = 4000;
static uint32 const RIDE_1_RAIDER_CAP         = 10;   // "about 25 by Grol'dom" (2011) with a 60 s life each (65496)
static uint32 const RIDE_2_RAIDER_FIRST_MS    = 6000;
static uint32 const RIDE_2_RAIDER_EVERY_MS    = 8000;
static uint32 const RIDE_2_RAIDER_CAP         = 4;
static uint32 const RIDE_4_WOLF_FIRST_MS      = 8000;
static uint32 const RIDE_4_WOLF_EVERY_MS      = 9000;
static uint32 const RIDE_4_FLYER_FIRST_MS     = 20000;
static uint32 const RIDE_4_FLYER_EVERY_MS     = 14000;
static uint32 const RIDE_4_ATTACKER_CAP       = 4;    // wolves and fliers together
static uint32 const RIDE_4_FLYER_CAP          = 2;
static float const  FACE_SMASH_REACH          = 10.0f;
static uint32 const RIDE_3_LINE_FIRST_MS      = 10000;
static uint32 const RIDE_3_LINE_EVERY_MS      = 13000;

static int GetRideIndexByKodo(uint32 entry)
{
    for (int i = 0; i < MAX_CARAVAN_RIDES; ++i)
        if (CaravanRides[i].Kodo == entry)
            return i;
    return -1;
}

static bool IsCaravanKodo(Unit const* unit)
{
    return unit && unit->GetTypeId() == TYPEID_UNIT && GetRideIndexByKodo(unit->GetEntry()) >= 0;
}

// The rider of a kodo (its AI keeps him: GetGUID(0))
static Player* GetKodoRider(Creature* kodo)
{
    if (!kodo || !kodo->IsAIEnabled)
        return nullptr;
    return ObjectAccessor::GetPlayer(*kodo, kodo->AI()->GetGUID(0));
}

// A caravan of this player that is still under way (one ride per player at a time; ours, from the EPL "two caravans on top
// of each other" complaint). Searched within 300 yd: a kodo farther from its rider has already ended its ride or will in
// half a second (its rider check).
static bool HasCaravanRide(Player* player)
{
    for (CaravanRide const& ride : CaravanRides)
    {
        std::list<Creature*> kodos;
        player->GetCreatureListWithEntryInGrid(kodos, ride.Kodo, 300.0f);
        for (Creature* kodo : kodos)
            if (kodo->IsAlive() && !kodo->IsDestroyedObject() && kodo->IsSummon() && kodo->IsAIEnabled
                && kodo->AI()->GetGUID(0) == player->GetGUID())
                return true;
    }
    return false;
}

// The ride's kodo, summoned public at its spot with the player as summoner; the kodo's AI does the rest. Refused (silently,
// as the gossip closes) to a bot, a dead player, one without the quest incomplete or with a ride out; told to one in combat
// or riding.
static void StartCaravanRide(Player* player, Creature* giver, int rideIndex)
{
    CaravanRide const& ride = CaravanRides[rideIndex];
    if (!player || !player->IsInWorld() || player->GetSession()->IsBot() || !player->IsAlive()
        || player->GetQuestStatus(ride.Quest) != QUEST_STATUS_INCOMPLETE || HasCaravanRide(player))
        return;

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

    TempSummon* kodo = player->SummonCreature(ride.Kodo, ride.Spawn, TEMPSUMMON_TIMED_DESPAWN, Seconds(RIDE_SUMMON_DURATION));
    if (!kodo || !kodo->GetVehicleKit())
    {
        TC_LOG_ERROR("scripts", "zone_northern_barrens_caravans: could not summon kodo %u for %s", ride.Kodo, player->GetName().c_str());
        if (kodo)
            kodo->DespawnOrUnsummon();
        return;
    }

    if (ride.GiverLine >= 0 && giver)
        sCreatureTextMgr->SendChat(giver, uint8(ride.GiverLine), player);

    // "Speak to Rocco Whipshank" / "Speak to Nagala Whipshank": 96566 / 96749 credit their caster
    if (ride.StartCredit)
        player->KilledMonsterCredit(ride.StartCredit);
}

// 34258 Halga Bloodeye, 34578 Rocco Whipshank (Grol'dom), 52220 Rocco Whipshank (the Crossroads), 52207 Nagala Whipshank
// Option 0 of their menu (E-2; shown only with the ride's quest incomplete in the log, conditions 15) starts the ride. Before,
// Halga's SmartAI gave 13949's credit on the spot (E-3) and the other three had no option at all, so 13975, 29109 and 29111
// could not be completed. What the player sees: the menu closes, the giver says her or his line (Halga BT 34630, Rocco BT
// 34818; sourced), the caravan appears with Balgor on the lead kodo and he is seated on it.
struct npc_nb_caravan_giver : public ScriptedAI
{
    npc_nb_caravan_giver(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
    {
        for (int i = 0; i < MAX_CARAVAN_RIDES; ++i)
        {
            CaravanRide const& ride = CaravanRides[i];
            if (ride.Giver != me->GetEntry() || ride.Menu != menuId || gossipListId != 0)
                continue;

            CloseGossipMenuFor(player);
            StartCaravanRide(player, me, i);
            return true;
        }
        return false;
    }
};

// ---------------------------------------------------------------------------------------------------------------------------
// 34430, 34577, 52209, 52314 - the caravan kodos
// What the player sees (sourced: the wiki's notes of 13949 / 13975 / 29109 / 29111, the Wowhead comments quoted in dossier B):
// Balgor drives the lead kodo with a pack kodo or a cart behind; the player rides "shotgun" behind him.
//   Ride 1: Shoot on the bar; Halga calls "Head 'em up! Move 'em out!"; Razormane Raiders run at the caravan and attack the
//     kodo, which takes no harm; at Grol'dom the player is set down, the raiders run away, "Caravan Escorted".
//   Ride 2: Shoot and Face Smash; Rocco "Ride hard and show no mercy!"; Burning Blade raiders on wolves ride alongside and
//     strike at the kodo; Face Smash knocks a close one off his wolf; set down inside the Crossroads, Balgor's thanks.
//   Ride 3: no bar, nobody attacks; Balgor chats the whole way (seven lines in the wiki's order); at Dreadmist Camp the
//     ambush (below), then "Ride Caravan to Dreadmist Peak".
//   Ride 4: Shoot, Face Smash, Spiral Barrage (the rocket: "to take down aerial units"); wolf riders and, from ~20 s in, wind
//     riders; they strike at the player, who can die (2012 comments: a level 20 priest died several times); death ends the
//     ride and Nagala offers it again; Balgor's lines on the cues; set down beside Kadrak.
// Jumping off before the end gives no credit and the giver offers the ride again (2010-2012 comments). The kodo takes no
// damage on any ride (2014: "you will not die; the caravan always arrives", rides 1-2).
// Ours: the attacker counts and timers (constants above), where the attackers come from, how they move (ground mounts follow
// the kodo at its flank, fliers a few yards above it), the half-second check, the 2.5 s before
// the set-down, the ambush choreography and timings.
// ---------------------------------------------------------------------------------------------------------------------------
struct npc_nb_caravan_kodo : public ScriptedAI
{
    npc_nb_caravan_kodo(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        _rideIndex = GetRideIndexByKodo(me->GetEntry());
        if (_rideIndex < 0 || summoner->GetTypeId() != TYPEID_PLAYER)
        {
            me->DespawnOrUnsummon();
            return;
        }
        _ride = &CaravanRides[_rideIndex];
        _playerGUID = summoner->GetGUID();

        me->SetReactState(REACT_PASSIVE);
        // The attackers of rides 1 and 2 hit the kodo: it must stay selectable to them (34430's template is NOT_SELECTABLE)
        me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC);
        me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);   // no spellclick row: no click cursor (review M3)
        me->setActive(true, ActiveFlags::Script);   // up to 1 150 yd across several grids

        // Balgor in seat 0, then the turret in seat 1 (rides 1-2). Each ride aura stacks while an enterable seat is free
        // (Aura::CanStackWith, CONTROL_VEHICLE): seat 1 of 415 / 422 / 1580 and seat 2 of 1587 are.
        if (Creature* balgor = SummonPassenger(_ride->Driver, 0))
            _driverGUID = balgor->GetGUID();
        if (_ride->Turret)
            if (Creature* turret = SummonPassenger(_ride->Turret, 1))
                _turretGUID = turret->GetGUID();

        // The pack kodo or cart behind (the kodos' own "Call a Pack Kodo" spells, summoned here; the follow is ours)
        Position behind = me->GetNearPosition(8.0f, float(M_PI));
        if (TempSummon* pack = me->SummonCreature(_ride->Pack, behind, TEMPSUMMON_TIMED_DESPAWN, Seconds(RIDE_SUMMON_DURATION)))
        {
            _packGUID = pack->GetGUID();
            pack->RemoveAurasDueToSpell(SPELL_PERMANENT_FEIGN_DEATH);
            pack->SetReactState(REACT_PASSIVE);
            pack->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
            pack->SetSpeed(MOVE_RUN, me->GetSpeedRate(MOVE_RUN) * 1.15f);
            pack->SetSpeed(MOVE_WALK, me->GetSpeedRate(MOVE_WALK) * 1.15f);
            pack->GetMotionMaster()->MoveFollow(me, 6.0f, float(M_PI));
        }

        _events.Reset();
        _events.ScheduleEvent(EVENT_CARAVAN_BOARD, 500ms);
        _events.ScheduleEvent(EVENT_CARAVAN_START, 2500ms);
        _events.ScheduleEvent(EVENT_CARAVAN_CHECK, 1s);
    }

    Creature* SummonPassenger(uint32 entry, int8 seat)
    {
        TempSummon* passenger = me->SummonCreature(entry, me->GetPosition(), TEMPSUMMON_TIMED_DESPAWN, Seconds(RIDE_SUMMON_DURATION));
        if (!passenger)
            return nullptr;
        passenger->SetReactState(REACT_PASSIVE);
        passenger->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_STUNNED);   // 52227's template carried the sniffed netted pose
        passenger->CastCustomSpell(SPELL_RIDE_VEHICLE_HARDCODED, SPELLVALUE_BASE_POINT0, seat + 1, me, true);
        if (passenger->GetVehicleBase() != me)
        {
            TC_LOG_ERROR("scripts", "npc_nb_caravan_kodo: %u could not take seat %d of kodo %u", entry, int32(seat), me->GetEntry());
            passenger->DespawnOrUnsummon();
            return nullptr;
        }
        return passenger;
    }

    ObjectGuid GetGUID(int32 id) const override
    {
        return id == 0 ? _playerGUID : ObjectGuid::Empty;
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    // Ride 4's seat 1 charms the kodo: keep this AI (CreatureAI::OnCharmed would swap it for PossessedAI, C86)
    void OnCharmed(bool apply) override
    {
        if (!apply)
            me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PLAYER_CONTROLLED);
    }

    void DamageTaken(Unit* /*attacker*/, uint32& damage) override
    {
        damage = 0;
    }

    Player* GetRider() const
    {
        return ObjectAccessor::GetPlayer(*me, _playerGUID);
    }

    Unit* GetRiderSeatBase() const
    {
        if (_ride->Turret)
            return ObjectAccessor::GetCreature(*me, _turretGUID);
        return me;
    }

    bool IsRiding(Player* player) const
    {
        Unit* base = GetRiderSeatBase();
        return player && base && player->GetVehicleBase() == base;
    }

    Creature* GetDriver() const
    {
        return ObjectAccessor::GetCreature(*me, _driverGUID);
    }

    void DriverSay(uint8 group)
    {
        if (Creature* balgor = GetDriver())
            sCreatureTextMgr->SendChat(balgor, group, GetRider());
    }

    void Board()
    {
        Player* player = GetRider();
        Unit* base = GetRiderSeatBase();
        if (!player || !base || !GetDriver())
        {
            End(false);
            return;
        }

        // Turret: its only seat (0); ride 3 and 4: seat 1 of the kodo (ride 4's 9784 cannot be entered, it is named)
        int8 const seat = _ride->Turret ? 0 : 1;
        player->CastCustomSpell(SPELL_RIDE_VEHICLE_HARDCODED, SPELLVALUE_BASE_POINT0, seat + 1, base, true);
        if (!IsRiding(player))
        {
            TC_LOG_ERROR("scripts", "npc_nb_caravan_kodo: %s could not board kodo %u", player->GetName().c_str(), me->GetEntry());
            End(false);
            return;
        }
        _boarded = true;

        // Ride 4: the kodo is driven by the script; the player keeps the bar but not the reins
        if (_rideIndex == RIDE_DREADMIST)
            player->SetClientControl(me, false);

        // The rider shield, ride 3 only (re-walk RW-W1): its road passes two aggressive Savannah Huntresses (263855 ~7 yd,
        // 264348 ~16 yd) and the seated player has no bar and no control, so nothing on the way may pick a fight with him
        // (ours, as the EPL caravan: a creature cannot attack a unit immune to NPCs). Not on rides 1, 2 and 4: their bar
        // spells carry SPELL_ATTR6_CAST_BY_CHARMER, so the player is the caster (Spell::Spell) and an NPC immunity on him
        // would make IsValidAttackTarget refuse every target (review round 1, walk W1); there the attackers strike only the
        // kodo (rides 1-2) or the rider (ride 4, sourced). Taken off in End() on every exit.
        if (_rideIndex == RIDE_CROSSROADS && !player->HasFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC))
        {
            player->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);
            _shielded = true;
        }
        if (_rideIndex != RIDE_DREADMIST)
            player->CombatStop(true);

        // The passengers' seats again for a client that learned of the kodo only now (as Vehicle::InstallAllAccessories)
        _events.ScheduleEvent(EVENT_CARAVAN_ANNOUNCE, 250ms);
        _events.ScheduleEvent(EVENT_CARAVAN_ANNOUNCE, 1500ms);

        switch (_rideIndex)
        {
            case RIDE_FAR_WATCH:
            case RIDE_GROLDOM:
                // Between the giver's two lines (wiki 13949 / 13975)
                DriverSay(EMOTE_BALGOR_DEFEND_THE_KODO);
                break;
            case RIDE_CROSSROADS:
                DriverSay(SAY_BALGOR_3_ALL_ABOARD);
                break;
            case RIDE_DREADMIST:
                DriverSay(SAY_BALGOR_4_HOP_ON);
                break;
            default:
                break;
        }
    }

    void Start()
    {
        // Ride 4's cues at half and most of the road (ours: the wiki gives the lines, not when); set before the first leg
        // (review round 1, W1: with both still 0 the "half way" line came at the start)
        _halfLeg = _ride->RoadSize / 2;
        _lateLeg = (_ride->RoadSize * 17) / 20;
        _next = 0;
        MoveNext();

        float length = 0.0f;
        Position prev = me->GetPosition();
        for (size_t i = 0; i < _ride->RoadSize; ++i)
        {
            length += prev.GetExactDist2d(&_ride->Road[i]);
            prev = _ride->Road[i];
        }
        float const speed = std::max(me->GetSpeed(MOVE_RUN), 1.0f);
        _events.ScheduleEvent(EVENT_CARAVAN_TIMEOUT, Milliseconds(uint32(length / speed * IN_MILLISECONDS) + 60 * IN_MILLISECONDS));

        switch (_rideIndex)
        {
            case RIDE_FAR_WATCH:
                _events.ScheduleEvent(EVENT_CARAVAN_GIVER_LINE, 4s);   // "once the caravan has moved a few paces" (2011)
                _events.ScheduleEvent(EVENT_CARAVAN_ATTACKER, Milliseconds(RIDE_1_RAIDER_FIRST_MS));
                break;
            case RIDE_GROLDOM:
                _events.ScheduleEvent(EVENT_CARAVAN_GIVER_LINE, 2s);
                _events.ScheduleEvent(EVENT_CARAVAN_ATTACKER, Milliseconds(RIDE_2_RAIDER_FIRST_MS));
                break;
            case RIDE_CROSSROADS:
                _events.ScheduleEvent(EVENT_CARAVAN_LINE, Milliseconds(RIDE_3_LINE_FIRST_MS));
                break;
            case RIDE_DREADMIST:
                _events.ScheduleEvent(EVENT_CARAVAN_ATTACKER, Milliseconds(RIDE_4_WOLF_FIRST_MS));
                _events.ScheduleEvent(EVENT_CARAVAN_FLYER, Milliseconds(RIDE_4_FLYER_FIRST_MS));
                break;
            default:
                break;
        }
    }

    void MoveNext()
    {
        if (_next >= _ride->RoadSize)
        {
            Arrive();
            return;
        }

        if (_rideIndex == RIDE_DREADMIST)
        {
            if (_next > 0 && _next == _halfLeg)
                DriverSay(SAY_BALGOR_4_CLOSING_IN);
            else if (_next > 0 && _next == _lateLeg)
                DriverSay(SAY_BALGOR_4_ALL_SIDES);
        }

        me->GetMotionMaster()->MovePoint(POINT_CARAVAN_ROAD, _ride->Road[_next], true);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == POINT_MOTION_TYPE && id == POINT_CARAVAN_ROAD && !_ended && !_arrived)
        {
            ++_next;
            MoveNext();
        }
    }

    // --- attackers -------------------------------------------------------------------------------------------------------

    uint32 CountAttackers(bool fliersOnly = false)
    {
        uint32 count = 0;
        for (auto itr = _attackers.begin(); itr != _attackers.end();)
        {
            Creature* attacker = ObjectAccessor::GetCreature(*me, *itr);
            if (!attacker || !attacker->IsAlive() || attacker->IsDestroyedObject())
            {
                itr = _attackers.erase(itr);
                continue;
            }
            if (!fliersOnly || attacker->GetEntry() == NPC_BURNING_BLADE_FLYER)
                ++count;
            ++itr;
        }
        return count;
    }

    // Somewhere off the kodo's flank, ahead or level with it (ours)
    Position AttackerStart(float minDist, float maxDist)
    {
        float const side = urand(0, 1) ? 1.0f : -1.0f;
        float const angle = side * frand(float(M_PI) / 6.0f, float(M_PI) * 0.55f);
        return me->GetNearPosition(frand(minDist, maxDist), angle);
    }

    void SummonRaiderOnFoot()
    {
        Position pos = AttackerStart(25.0f, 35.0f);
        // 65496: 60 s, fighting or not (review round 1, M1: TIMED_OR_DEAD only counts down out of combat)
        if (TempSummon* raider = me->SummonCreature(NPC_RAZORMANE_RAIDER, pos, TEMPSUMMON_TIMED_DESPAWN, 60s))
            _attackers.insert(raider->GetGUID());
    }

    void SummonMountedAttacker(uint32 mountEntry, uint32 riderEntry, bool flyer)
    {
        Position pos = AttackerStart(30.0f, 40.0f);
        if (flyer)
            pos.m_positionZ += 15.0f;
        TempSummon* mount = me->SummonCreature(mountEntry, pos, TEMPSUMMON_TIMED_OR_DEAD_DESPAWN, 180s);
        if (!mount)
            return;
        TempSummon* rider = me->SummonCreature(riderEntry, pos, TEMPSUMMON_TIMED_OR_DEAD_DESPAWN, 180s);
        if (!rider)
        {
            mount->DespawnOrUnsummon();
            return;
        }
        rider->CastCustomSpell(SPELL_RIDE_VEHICLE_HARDCODED, SPELLVALUE_BASE_POINT0, 1, mount, true);
        if (rider->GetVehicleBase() != mount)
        {
            TC_LOG_ERROR("scripts", "npc_nb_caravan_kodo: attacker %u could not mount %u", riderEntry, mountEntry);
            rider->DespawnOrUnsummon();
            mount->DespawnOrUnsummon();
            return;
        }
        _attackers.insert(mount->GetGUID());
        _riders.insert(rider->GetGUID());
    }

    void SpawnAttacker()
    {
        if (_arrived || _ended)
            return;

        switch (_rideIndex)
        {
            case RIDE_FAR_WATCH:
                if (CountAttackers() < RIDE_1_RAIDER_CAP)
                    SummonRaiderOnFoot();
                _events.ScheduleEvent(EVENT_CARAVAN_ATTACKER, Milliseconds(RIDE_1_RAIDER_EVERY_MS));
                break;
            case RIDE_GROLDOM:
                if (CountAttackers() < RIDE_2_RAIDER_CAP)
                {
                    SummonMountedAttacker(NPC_BURNING_BLADE_MOUNT_2, NPC_BURNING_BLADE_RAIDER, false);
                    if (!_saidSpotted)
                    {
                        _saidSpotted = true;
                        DriverSay(SAY_BALGOR_2_BURNING_BLADE);
                    }
                }
                _events.ScheduleEvent(EVENT_CARAVAN_ATTACKER, Milliseconds(RIDE_2_RAIDER_EVERY_MS));
                break;
            case RIDE_DREADMIST:
                if (CountAttackers() < RIDE_4_ATTACKER_CAP)
                {
                    SummonMountedAttacker(NPC_BURNING_BLADE_MOUNT_4, NPC_BURNING_BLADE_ATTACKER, false);
                    if (!_saidSpotted)
                    {
                        _saidSpotted = true;
                        DriverSay(SAY_BALGOR_4_SPOTTED);
                    }
                }
                _events.ScheduleEvent(EVENT_CARAVAN_ATTACKER, Milliseconds(RIDE_4_WOLF_EVERY_MS));
                break;
            default:
                break;
        }
    }

    void SpawnFlyer()
    {
        if (_arrived || _ended)
            return;
        if (CountAttackers() < RIDE_4_ATTACKER_CAP && CountAttackers(true) < RIDE_4_FLYER_CAP)
        {
            SummonMountedAttacker(NPC_BURNING_BLADE_FLYER, NPC_BURNING_BLADE_WINDRIDER, true);
            if (!_saidRocket)
            {
                _saidRocket = true;
                DriverSay(SAY_BALGOR_4_ROCKET);
            }
        }
        _events.ScheduleEvent(EVENT_CARAVAN_FLYER, Milliseconds(RIDE_4_FLYER_EVERY_MS));
    }

    // "Good shooting! That one won't be getting up anytime soon." on a kill (at most every 20 s; ours)
    void SummonedCreatureDies(Creature* summon, Unit* /*killer*/) override
    {
        if (_rideIndex != RIDE_DREADMIST || _arrived || _ended)
            return;
        if (summon->GetEntry() != NPC_BURNING_BLADE_ATTACKER && summon->GetEntry() != NPC_BURNING_BLADE_WINDRIDER)
            return;
        if (_goodShootingCooldown)
            return;
        _goodShootingCooldown = 20000;
        DriverSay(SAY_BALGOR_4_GOOD_SHOOTING);
    }

    void AttackersFlee()
    {
        for (GuidSet const* set : { &_attackers, &_riders })
            for (ObjectGuid const& guid : *set)
                if (Creature* attacker = ObjectAccessor::GetCreature(*me, guid))
                    if (attacker->IsAlive() && attacker->IsAIEnabled)
                        attacker->AI()->SetData(DATA_CARAVAN_FLEE, 1);
    }

    void DespawnAttackers()
    {
        for (GuidSet const* set : { &_riders, &_attackers })
            for (ObjectGuid const& guid : *set)
                if (Creature* attacker = ObjectAccessor::GetCreature(*me, guid))
                    attacker->DespawnOrUnsummon();
        _riders.clear();
        _attackers.clear();
    }

    // --- arrival ---------------------------------------------------------------------------------------------------------

    void Arrive()
    {
        _arrived = true;
        _events.CancelEvent(EVENT_CARAVAN_ATTACKER);
        _events.CancelEvent(EVENT_CARAVAN_FLYER);
        _events.CancelEvent(EVENT_CARAVAN_TIMEOUT);

        if (_rideIndex == RIDE_CROSSROADS)
        {
            _ambushStep = 0;
            _events.ScheduleEvent(EVENT_CARAVAN_AMBUSH, 500ms);
            _events.ScheduleEvent(EVENT_CARAVAN_TIMEOUT, 90s);
            return;
        }

        // The raiders run away (13949 comment: "dismount, they run away"); the credit comes now, the set-down 2.5 s later
        AttackersFlee();
        if (_rideIndex == RIDE_FAR_WATCH)
            DriverSay(SAY_BALGOR_1_ARRIVAL);
        else if (_rideIndex == RIDE_GROLDOM)
            DriverSay(SAY_BALGOR_2_ARRIVAL);
        else if (_rideIndex == RIDE_DREADMIST)
            DriverSay(SAY_BALGOR_4_MADE_IT);
        Credit();
        _events.ScheduleEvent(EVENT_CARAVAN_FINISH, 2500ms);
    }

    void Credit()
    {
        Player* player = GetRider();
        if (_credited || !player || !IsRiding(player) || player->GetQuestStatus(_ride->Quest) != QUEST_STATUS_INCOMPLETE)
            return;
        _credited = true;
        player->KilledMonsterCredit(_ride->EndCredit);
        if (_ride->Explore)
            player->AreaExploredOrEventHappens(_ride->Quest);
    }

    // --- the Dreadmist Camp ambush (end of ride 3) --------------------------------------------------------------------------
    // Sourced (the wiki's 29109 notes and the broadcast texts): Balgor greets his sister, she answers, Balgor "HEY! What's
    // happening!?"; Burning Blade ambushers appear and net Balgor and the player (96661); their four lines; Balgor "Help! Let
    // me go!" as he is carried off (96677 / 96701 Kidnap: into 52275's seat), the cart is taken (96664); Nagala "Balgor! No!";
    // the credit; the player is freed (96719 Undo Net). Ours: every timing, where the ambushers come from and go (up the torchlit
    // path north), that the cart follows the thief rather than being driven (52211 has no vehicle), that the net is cast by each
    // victim on himself (the same aura with no caster in combat: a hostile caster would start a fight with the player, and an
    // ambusher in combat loses its immunity, scripted-quest-scenes "never let them enter combat"), and that nobody can fight
    // the ambushers (passive, immune to players and NPCs).

    Creature* SummonAmbusher(uint32 entry, Position const& from)
    {
        TempSummon* ambusher = me->SummonCreature(entry, from, TEMPSUMMON_TIMED_DESPAWN, 120s);   // 96655: 120 s
        if (!ambusher)
            return nullptr;
        _ambushers.insert(ambusher->GetGUID());
        Position to = me->GetNearPosition(4.0f, me->GetAngle(&from) - me->GetOrientation());
        ambusher->GetMotionMaster()->MovePoint(POINT_AMBUSHER_IN, to, true);
        return ambusher;
    }

    Creature* GetAmbusher(uint32 entry)
    {
        for (ObjectGuid const& guid : _ambushers)
            if (Creature* ambusher = ObjectAccessor::GetCreature(*me, guid))
                if (ambusher->GetEntry() == entry)
                    return ambusher;
        return nullptr;
    }

    void AmbusherSay(uint32 entry, uint8 group)
    {
        if (Creature* ambusher = GetAmbusher(entry))
            sCreatureTextMgr->SendChat(ambusher, group, GetRider());
    }

    void NagalaSay(uint8 group)
    {
        if (Creature* nagala = me->FindNearestCreature(NPC_NAGALA_WHIPSHANK, 80.0f))
            sCreatureTextMgr->SendChat(nagala, group, GetRider());
    }

    void AmbushStep()
    {
        Player* player = GetRider();
        uint32 delay = 0;
        switch (_ambushStep++)
        {
            case 0:
                DriverSay(SAY_BALGOR_3_HO_NAGALA);
                delay = 5000;
                break;
            case 1:
                NagalaSay(SAY_NAGALA_HUG);
                delay = 6000;
                break;
            case 2:
                DriverSay(SAY_BALGOR_3_HEY);
                SummonAmbusher(NPC_AMBUSHER_GREETER, AmbushApproach[0]);
                SummonAmbusher(NPC_AMBUSHER_CART_THIEF, AmbushApproach[1]);
                SummonAmbusher(NPC_AMBUSHER_KIDNAPPER, AmbushApproach[2]);
                delay = 1500;
                break;
            case 3:
                if (player && IsRiding(player))
                    player->CastSpell(player, SPELL_BURNING_BLADE_NET, true);
                if (Creature* balgor = GetDriver())
                    balgor->CastSpell(balgor, SPELL_BURNING_BLADE_NET, true);
                delay = 2000;
                break;
            case 4:
                AmbusherSay(NPC_AMBUSHER_GREETER, SAY_GREETER_GREETINGS);
                delay = 4500;
                break;
            case 5:
                AmbusherSay(NPC_AMBUSHER_CART_THIEF, SAY_THIEF_QUICKLY);
                delay = 4500;
                break;
            case 6:
                AmbusherSay(NPC_AMBUSHER_KIDNAPPER, SAY_KIDNAPPER_WHICH_ONE);
                delay = 4000;
                break;
            case 7:
                AmbusherSay(NPC_AMBUSHER_CART_THIEF, SAY_THIEF_THE_FAT_ONE);
                delay = 3000;
                break;
            case 8:
                Kidnap();
                delay = 2500;
                break;
            case 9:
                NagalaSay(SAY_NAGALA_NO);
                delay = 2000;
                break;
            case 10:
                // Credit before the set-down (a logout after it keeps it), then the net comes off and the player is let down
                Credit();
                HandOffAmbush();
                End(true);
                return;
            default:
                return;
        }
        _events.ScheduleEvent(EVENT_CARAVAN_AMBUSH, Milliseconds(delay));
    }

    void Kidnap()
    {
        Creature* balgor = GetDriver();
        Creature* kidnapper = GetAmbusher(NPC_AMBUSHER_KIDNAPPER);
        if (balgor && kidnapper)
        {
            // Off the kodo and into the kidnapper's seat (a stunned caster: the net comes off Balgor for the move)
            balgor->RemoveAurasDueToSpell(SPELL_BURNING_BLADE_NET);
            balgor->ExitVehicle();
            balgor->CastCustomSpell(SPELL_RIDE_VEHICLE_HARDCODED, SPELLVALUE_BASE_POINT0, 1, kidnapper, true);
            if (balgor->GetVehicleBase() == kidnapper)
            {
                kidnapper->AI()->SetGUID(balgor->GetGUID(), 0);
                _driverGUID.Clear();
                sCreatureTextMgr->SendChat(balgor, SAY_BALGOR_3_HELP, GetRider());
            }
            else
                TC_LOG_ERROR("scripts", "npc_nb_caravan_kodo: Balgor could not be seated on the kidnapper");
        }

        if (Creature* thief = GetAmbusher(NPC_AMBUSHER_CART_THIEF))
            if (Creature* cart = ObjectAccessor::GetCreature(*me, _packGUID))
            {
                cart->GetMotionMaster()->Clear();
                cart->GetMotionMaster()->MoveFollow(thief, 4.0f, float(M_PI));
                thief->AI()->SetGUID(cart->GetGUID(), 0);
                _packGUID.Clear();
            }
    }

    // The ambushers leave with Balgor and the cart and take them away themselves (npc_nb_dreadmist_ambusher)
    void HandOffAmbush()
    {
        for (ObjectGuid const& guid : _ambushers)
            if (Creature* ambusher = ObjectAccessor::GetCreature(*me, guid))
                if (ambusher->IsAIEnabled)
                    ambusher->AI()->SetData(DATA_CARAVAN_LEAVE, 1);
        _ambushers.clear();
    }

    // --- the end of a ride -----------------------------------------------------------------------------------------------

    // Arrived (credit already given) or given up (none). The rider is let go (net off, client control back, set
    // down) and the whole caravan goes at once; on a hand-off the ambushers keep Balgor and the cart.
    void End(bool arrived, bool despawnSelf = true)
    {
        if (_ended)
            return;
        _ended = true;
        _events.Reset();

        if (Player* player = GetRider())
        {
            player->RemoveAurasDueToSpell(SPELL_BURNING_BLADE_NET);
            if (_shielded)
                player->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);
            _shielded = false;
            if (IsRiding(player))
                player->ExitVehicle();
        }

        // On arrival the attackers were sent running and go 6 s later by themselves; on a ride given up they go at once
        if (!arrived)
            DespawnAttackers();
        for (ObjectGuid const& guid : _ambushers)
            if (Creature* ambusher = ObjectAccessor::GetCreature(*me, guid))
                ambusher->DespawnOrUnsummon();
        _ambushers.clear();

        for (ObjectGuid const& guid : { _turretGUID, _driverGUID, _packGUID })
            if (Creature* summon = ObjectAccessor::GetCreature(*me, guid))
                summon->DespawnOrUnsummon();

        if (Vehicle* kit = me->GetVehicleKit())
            for (int8 seat = 0; seat < 3; ++seat)
                if (Unit* passenger = kit->GetPassenger(seat))
                    if (passenger->GetTypeId() == TYPEID_UNIT && passenger->IsSummon())
                        passenger->ToTempSummon()->UnSummon();

        if (despawnSelf)
            me->DespawnOrUnsummon();
    }

    // Cannot be worn down (DamageTaken), but an instant kill (GM) must still end the ride (review round 1, M5)
    void JustDied(Unit* /*killer*/) override
    {
        if (!_ended)
            End(false);
    }

    // The 600 s summon running out, or any other unsummon, while the ride is still on
    void Unsummoned() override
    {
        if (!_ended)
            End(false, false);
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_ride || _ended)
            return;

        if (_goodShootingCooldown)
            _goodShootingCooldown = _goodShootingCooldown > diff ? _goodShootingCooldown - diff : 0;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_CARAVAN_BOARD:
                    Board();
                    break;
                case EVENT_CARAVAN_START:
                    Start();
                    break;
                case EVENT_CARAVAN_ANNOUNCE:
                    if (Vehicle* kit = me->GetVehicleKit())
                        kit->AnnouncePassengers();
                    break;
                case EVENT_CARAVAN_GIVER_LINE:
                    if (Creature* giver = me->FindNearestCreature(_ride->Giver, 80.0f))
                        sCreatureTextMgr->SendChat(giver, _rideIndex == RIDE_FAR_WATCH ? SAY_HALGA_HEAD_EM_UP : SAY_ROCCO_RIDE_HARD, GetRider());
                    break;
                case EVENT_CARAVAN_LINE:
                    if (_line < 6 && !_arrived)
                    {
                        DriverSay(uint8(SAY_BALGOR_3_ALL_ABOARD + 1 + _line));
                        if (++_line < 6)
                            _events.ScheduleEvent(EVENT_CARAVAN_LINE, Milliseconds(RIDE_3_LINE_EVERY_MS));
                    }
                    break;
                case EVENT_CARAVAN_ATTACKER:
                    SpawnAttacker();
                    break;
                case EVENT_CARAVAN_FLYER:
                    SpawnFlyer();
                    break;
                case EVENT_CARAVAN_AMBUSH:
                    AmbushStep();
                    break;
                case EVENT_CARAVAN_FINISH:
                    End(true);
                    return;
                case EVENT_CARAVAN_TIMEOUT:
                    TC_LOG_ERROR("scripts", "npc_nb_caravan_kodo: ride %d did not reach its end in time", _rideIndex + 1);
                    End(false);
                    return;
                case EVENT_CARAVAN_CHECK:
                {
                    // Given up: the rider left the seat (rides 1-3 can get off; on ride 4 only death or a forced exit takes
                    // him off), died, logged out, or the quest left his log
                    Player* player = GetRider();
                    if (!player || !player->IsInWorld() || !player->IsAlive() || (_boarded && !IsRiding(player))
                        || (!_credited && player->GetQuestStatus(_ride->Quest) != QUEST_STATUS_INCOMPLETE))
                    {
                        End(false);
                        return;
                    }
                    _events.ScheduleEvent(EVENT_CARAVAN_CHECK, 500ms);
                    break;
                }
                default:
                    break;
            }
            if (_ended)
                return;
        }
    }

private:
    CaravanRide const* _ride = nullptr;
    int _rideIndex = -1;
    ObjectGuid _playerGUID;
    ObjectGuid _driverGUID;
    ObjectGuid _turretGUID;
    ObjectGuid _packGUID;
    GuidSet _attackers;       // raiders on foot, mounts
    GuidSet _riders;          // the riders on the mounts
    GuidSet _ambushers;
    EventMap _events;
    size_t _next = 0;
    size_t _halfLeg = 0;
    size_t _lateLeg = 0;
    uint8 _line = 0;
    uint8 _ambushStep = 0;
    uint32 _goodShootingCooldown = 0;
    bool _boarded = false;
    bool _shielded = false;
    bool _arrived = false;
    bool _credited = false;
    bool _saidSpotted = false;
    bool _saidRocket = false;
    bool _ended = false;
};

// ---------------------------------------------------------------------------------------------------------------------------
// 34487 Razormane Raider, 34594 Burning Blade Raider, 52338 Burning Blade Attacker, 52386 Burning Blade Windrider
// Summoned by a caravan kodo: they go for the kodo (rides 1-2) or for its rider (ride 4) and nothing else, striking whenever
// they are within reach (ours: 5 yd beyond the target's combat reach on foot, 7 yd from a mount, 9 yd from a flier; a
// passenger's melee reach is not measured from the mount's flank). The kodo takes no damage; the ride 4 rider does. They never
// turn on a player who shoots them. On DATA_CARAVAN_FLEE (arrival) they run off and are gone 6 s later. A copy that is not a
// ride's (52338 310992 and 52386 302661 stay as the TDB statics) fights as an ordinary mob.
// ---------------------------------------------------------------------------------------------------------------------------
struct npc_nb_caravan_attacker : public ScriptedAI
{
    npc_nb_caravan_attacker(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (!IsCaravanKodo(summoner))
            return;
        _kodoGUID = summoner->GetGUID();
        _side = Position::NormalizeOrientation(summoner->GetRelativeAngle(me)) <= float(M_PI) ? 1.0f : -1.0f;
        me->SetReactState(REACT_PASSIVE);
        if (me->GetEntry() == NPC_RAZORMANE_RAIDER)
            me->SetSpeed(MOVE_RUN, 1.4f);   // ours: able to catch the kodo
    }

    bool OnRide() const { return !_kodoGUID.IsEmpty(); }

    void MoveInLineOfSight(Unit* who) override
    {
        if (!OnRide())
            ScriptedAI::MoveInLineOfSight(who);
    }

    void AttackStart(Unit* who) override
    {
        if (!OnRide())
            ScriptedAI::AttackStart(who);
    }

    void EnterEvadeMode(EvadeReason why) override
    {
        if (!OnRide())
            ScriptedAI::EnterEvadeMode(why);
    }

    void SetData(uint32 id, uint32 /*value*/) override
    {
        if (id != DATA_CARAVAN_FLEE || !OnRide() || _fleeing)
            return;
        _fleeing = true;
        if (!me->GetVehicle())
        {
            me->GetMotionMaster()->Clear();
            Creature* kodo = ObjectAccessor::GetCreature(*me, _kodoGUID);
            float const away = kodo ? kodo->GetAngle(me) : me->GetOrientation();
            Position pos = me->GetPosition();
            pos.m_positionX += 30.0f * std::cos(away);
            pos.m_positionY += 30.0f * std::sin(away);
            me->UpdateGroundPositionZ(pos.m_positionX, pos.m_positionY, pos.m_positionZ);
            me->GetMotionMaster()->MovePoint(POINT_ATTACKER_FLEE, pos, true);
        }
        me->DespawnOrUnsummon(6000);
    }

    Unit* GetRideTarget(Creature* kodo) const
    {
        if (kodo->GetEntry() == NPC_MASTER_CARAVAN_KODO)
            return GetKodoRider(kodo);
        return kodo;
    }

    void UpdateAI(uint32 /*diff*/) override
    {
        if (!OnRide())
        {
            if (!UpdateVictim())
                return;
            DoMeleeAttackIfReady();
            return;
        }

        if (_fleeing)
            return;

        Creature* kodo = ObjectAccessor::GetCreature(*me, _kodoGUID);
        if (!kodo || !kodo->IsAlive())
        {
            me->DespawnOrUnsummon();
            return;
        }

        Unit* target = GetRideTarget(kodo);
        if (!target || !target->IsAlive() || !target->IsInWorld() || target->GetMapId() != me->GetMapId())
            return;

        float reach = 5.0f;
        if (Unit* mount = me->GetVehicleBase())
            reach = mount->GetEntry() == NPC_BURNING_BLADE_FLYER ? 9.0f : 7.0f;
        else
        {
            // On foot (ride 1's raiders, a rider knocked off his wolf): run at the kodo's flank. Not MoveChase: without a victim
            // ChaseMovementGenerator stops every tick (HasLostTarget; review round 1, B1). Not during a knockback.
            MovementGeneratorType const current = me->GetMotionMaster()->GetCurrentMovementGeneratorType();
            if (current != FOLLOW_MOTION_TYPE && current != EFFECT_MOTION_TYPE)
                me->GetMotionMaster()->MoveFollow(kodo, 1.5f, _side * float(M_PI) / 2.0f);
        }

        if (me->isAttackReady() && me->GetExactDist(target) <= reach + target->GetCombatReach())
        {
            if (!me->GetVehicle())
                me->SetFacingToObject(target);
            me->AttackerStateUpdate(target, true);
            me->resetAttackTimer();
        }
    }

private:
    ObjectGuid _kodoGUID;
    float _side = 1.0f;
    bool _fleeing = false;
};

// ---------------------------------------------------------------------------------------------------------------------------
// 34593, 52337 Burning Blade Mount; 52385 Burning Blade Flyer
// Summoned by a caravan kodo with a rider aboard: a wolf keeps to the kodo's flank (ours: follow 3 yd off, on the side it came
// from), a flier a few yards above and beside it (ours: 4 yd up, 5 yd out; a flier at ground height would scrape the road).
// Faster than the kodo so it can catch up (ours). When its rider is gone (shot, knocked off) or the caravan arrives it turns
// away and is gone 6 s later.
// ---------------------------------------------------------------------------------------------------------------------------
struct npc_nb_caravan_attacker_mount : public ScriptedAI
{
    npc_nb_caravan_attacker_mount(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (!IsCaravanKodo(summoner))
        {
            me->DespawnOrUnsummon();
            return;
        }
        _kodoGUID = summoner->GetGUID();
        _side = Position::NormalizeOrientation(summoner->GetRelativeAngle(me)) <= float(M_PI) ? 1.0f : -1.0f;
        me->SetReactState(REACT_PASSIVE);
        me->SetSpeed(MOVE_RUN, 1.6f);
        if (me->GetEntry() == NPC_BURNING_BLADE_FLYER)
        {
            me->SetCanFly(true);
            me->SetDisableGravity(true);
            me->SetSpeed(MOVE_FLIGHT, 1.8f);
        }
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void SetData(uint32 id, uint32 /*value*/) override
    {
        if (id == DATA_CARAVAN_FLEE)
            Flee();
    }

    void Flee()
    {
        if (_fleeing)
            return;
        _fleeing = true;
        Creature* kodo = ObjectAccessor::GetCreature(*me, _kodoGUID);
        float const away = kodo ? kodo->GetAngle(me) : me->GetOrientation();
        Position pos = me->GetPosition();
        pos.m_positionX += 40.0f * std::cos(away);
        pos.m_positionY += 40.0f * std::sin(away);
        bool const flyer = me->GetEntry() == NPC_BURNING_BLADE_FLYER;
        if (flyer)
            pos.m_positionZ += 20.0f;
        else
            me->UpdateGroundPositionZ(pos.m_positionX, pos.m_positionY, pos.m_positionZ);
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MovePoint(POINT_ATTACKER_FLEE, pos, !flyer);
        me->DespawnOrUnsummon(6000);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_fleeing || _kodoGUID.IsEmpty())
            return;

        if (_timer > diff)
        {
            _timer -= diff;
            return;
        }
        _timer = 500;

        Creature* kodo = ObjectAccessor::GetCreature(*me, _kodoGUID);
        Unit* rider = me->GetVehicleKit() ? me->GetVehicleKit()->GetPassenger(0) : nullptr;
        if (!kodo || !kodo->IsAlive() || !rider || !rider->IsAlive())
        {
            Flee();
            return;
        }

        if (me->GetEntry() == NPC_BURNING_BLADE_FLYER)
        {
            Position pos = kodo->GetNearPosition(5.0f, _side * float(M_PI) / 2.0f);
            pos.m_positionZ = kodo->GetPositionZ() + 4.0f;
            me->GetMotionMaster()->MovePoint(0, pos, false);
        }
        else if (me->GetMotionMaster()->GetCurrentMovementGeneratorType() != FOLLOW_MOTION_TYPE)
            me->GetMotionMaster()->MoveFollow(kodo, 3.0f, _side * float(M_PI) / 2.0f);
    }

private:
    ObjectGuid _kodoGUID;
    float _side = 1.0f;
    uint32 _timer = 500;
    bool _fleeing = false;
};

// ---------------------------------------------------------------------------------------------------------------------------
// 52274, 52275, 52276 Burning Blade Ambusher (the Dreadmist Camp ambush of ride 3, summoned by the kodo)
// Passive and immune to players and NPCs: they are a scene, nobody fights them (a hostile NPC that is only IMMUNE_TO_PC still
// attacks players here, core C2). The kidnapper carries Balgor, the thief leads the cart; on DATA_CARAVAN_LEAVE they go up the
// torchlit path north and are gone at its first bend (or after 30 s), taking Balgor and the cart with them. Ours.
// ---------------------------------------------------------------------------------------------------------------------------
struct npc_nb_dreadmist_ambusher : public ScriptedAI
{
    npc_nb_dreadmist_ambusher(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
    }

    void IsSummonedBy(Unit* summoner) override
    {
        Reset();
        if (!IsCaravanKodo(summoner))
            me->DespawnOrUnsummon();
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    void DamageTaken(Unit* /*attacker*/, uint32& damage) override { damage = 0; }

    void SetGUID(ObjectGuid guid, int32 /*id*/) override
    {
        _carriedGUID = guid;   // Balgor (kidnapper) or the cart (thief)
    }

    void SetData(uint32 id, uint32 /*value*/) override
    {
        if (id != DATA_CARAVAN_LEAVE || _leaving)
            return;
        _leaving = true;
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MovePoint(POINT_AMBUSHER_OUT, AmbushExit, true);
        _leaveTimer = 30000;
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == POINT_MOTION_TYPE && id == POINT_AMBUSHER_IN)
            if (TempSummon* summon = me->ToTempSummon())
                if (Unit* kodo = summon->GetSummoner())
                    me->SetFacingToObject(kodo);
        if (type == POINT_MOTION_TYPE && id == POINT_AMBUSHER_OUT)
            Vanish();
    }

    void Vanish()
    {
        if (_vanished)
            return;
        _vanished = true;
        if (Creature* carried = ObjectAccessor::GetCreature(*me, _carriedGUID))
            carried->DespawnOrUnsummon();
        _carriedGUID.Clear();
        me->DespawnOrUnsummon();
    }

    // The 120 s summon running out (or the ride ending before the hand-off): Balgor or the cart go too
    void Unsummoned() override
    {
        if (_vanished)
            return;
        _vanished = true;
        if (Creature* carried = ObjectAccessor::GetCreature(*me, _carriedGUID))
            carried->DespawnOrUnsummon();
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_leaving || _vanished)
            return;
        if (_leaveTimer <= diff)
            Vanish();
        else
            _leaveTimer -= diff;
    }

private:
    ObjectGuid _carriedGUID;
    uint32 _leaveTimer = 0;
    bool _leaving = false;
    bool _vanished = false;
};

// ---------------------------------------------------------------------------------------------------------------------------
// 65704 Face Smash (ride 2, The Hotseat's spell2), 96792 Face Smash (ride 4, the Master Caravan Kodo's spell2)
// "Butt them with the gun when close" (wiki 13975, comment 2013-02 [+8]); 29111: "wolf riders shot or punched off the kodo".
// The DBC aims it at a nearby creature with no range (TARGET_UNIT_NEARBY_ENTRY, range 0) and the follow-up "Hit Raider in the
// Face" (65713: 853, 96806: 2441 damage) at a vehicle's passenger: the script takes the nearest living raider of the ride
// (34594 / 52338) within 10 yd of the caster (ours), knocks him off his wolf and deals the follow-up's damage from the caster
// (the caster is the player himself: the spell has SPELL_ATTR6_CAST_BY_CHARMER; the kill is his). Nothing in reach: "Out of range".
// ---------------------------------------------------------------------------------------------------------------------------
class spell_nb_caravan_face_smash : public SpellScript
{
    PrepareSpellScript(spell_nb_caravan_face_smash);

    uint32 RaiderEntry()
    {
        return GetSpellInfo()->Id == SPELL_FACE_SMASH_RIDE_2 ? NPC_BURNING_BLADE_RAIDER : NPC_BURNING_BLADE_ATTACKER;
    }

    Creature* FindRaider()
    {
        Unit* caster = GetCaster();
        return caster ? caster->FindNearestCreature(RaiderEntry(), FACE_SMASH_REACH) : nullptr;
    }

    SpellCastResult CheckCast()
    {
        return FindRaider() ? SPELL_CAST_OK : SPELL_FAILED_OUT_OF_RANGE;
    }

    void HandleCast()
    {
        Unit* caster = GetCaster();
        Creature* raider = FindRaider();
        if (!caster || !raider)
            return;

        bool const ride2 = GetSpellInfo()->Id == SPELL_FACE_SMASH_RIDE_2;   // else SPELL_FACE_SMASH_RIDE_4
        uint32 const damage = ride2 ? 853 : 2441;
        uint32 const followUp = ride2 ? SPELL_HIT_RAIDER_IN_THE_FACE_2 : SPELL_HIT_RAIDER_IN_THE_FACE_4;
        raider->ExitVehicle();
        // With a combat log line and the damage number (review round 1, M4)
        SpellNonMeleeDamage hit(caster, raider, followUp, SPELL_SCHOOL_MASK_NORMAL);
        hit.damage = damage;
        caster->DealSpellDamage(&hit, false);
        caster->SendSpellNonMeleeDamageLog(&hit);
        if (raider->IsAlive())
            raider->KnockbackFrom(caster->GetPositionX(), caster->GetPositionY(), 8.0f, 5.0f);
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_nb_caravan_face_smash::CheckCast);
        OnCast += SpellCastFn(spell_nb_caravan_face_smash::HandleCast);
    }
};

void AddSC_northern_barrens_caravans()
{
    new creature_script<npc_nb_caravan_giver>("npc_nb_caravan_giver");
    new creature_script<npc_nb_caravan_kodo>("npc_nb_caravan_kodo");
    new creature_script<npc_nb_caravan_attacker>("npc_nb_caravan_attacker");
    new creature_script<npc_nb_caravan_attacker_mount>("npc_nb_caravan_attacker_mount");
    new creature_script<npc_nb_dreadmist_ambusher>("npc_nb_dreadmist_ambusher");
    new spell_script<spell_nb_caravan_face_smash>("spell_nb_caravan_face_smash");
}
