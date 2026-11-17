/*
* This file is part of the Pandaria 5.4.8 Project. See THANKS file for Copyright information
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

/* ScriptData
SDName: Swamp of Sorrows, Bogpaddle
SDComment: The Baron's Cannons (27600 In With a Bang, 27740 Baba Bogbrew, the frigate's Landward Cannon), the Silversnap Swim
           Tonic (27587 Maliciously Delicious), the Stray Land Mines (27536 Mostly Harmless)
SDCategory: Swamp of Sorrows
EndScriptData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "GameObjectAI.h"
#include "GameObject.h"
#include "Player.h"
#include "WorldSession.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "MotionMaster.h"
#include "MovementTypedefs.h"
#include "Map.h"
#include "MapManager.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include <cmath>
#include <mutex>
#include <unordered_map>

/*######
## The Baron's Cannons
## What the player sees (sources: 27600 comments 2010-11-24 [+88], 2010-11-26 [+58], 2010-11-29 [+5], 2011-01-03 [+2],
## 2011-01-10 [+4], 2011-08-08 [+9], 2011-11-21 [+7], 2014-02-16 [+2]; 27740 comments 2010-11-24 [+20], 2013-02-19 [+1]; the wiki
## notes of 27600 / 27740 and the Landward Cannon; menus 12099 / 12132 / 12292 and their options in both TDBs; the spells 85565,
## 86685, 88633 (Summon Baron's Cannon Bunny), 86687 -> 86686 -> 85582 (the parachute "South To Baba's"), 88632 (Safe Fall)):
## Lil' Crazy Jerry, by the cannon north of Crazy Larry's camp: "Load me into that cannon, boy!" - you are loaded into The Baron's
## Cannon (hidden in it) and a few seconds later blasted across the water onto the deck of the Fortune's Fist frigate, next to its
## gilblins. You may take some damage when you land; the landing gives "Going Down?" (964). No parachute (the wiki: Slow Fall makes
## you drift; the "maybe a parachute" comment answers a warning about Daisy's ride).
## Lil' Crazy Daisy, south side of the camp: "Your dad says to fire me across the bay." - the cannon shoots you across the zone to
## Baba Bogbrew in the Stagalbog; a parachute comes out as you start falling, no damage.
## The frigate's Landward Cannon: "I'll get in and fire it! What could go wrong?" - back to shore, right by Lil' Crazy Jerry; no
## damage (Safe Fall).
##
## Ours (no source says how): the 2.6 s in the cannon; each flight is a server jump (a parabolic spline the client cannot steer, so
## Slow Fall and Levitate do not drift it: retail's drift and misses into the water or Stonard are not reproduced) to a point above
## the landing spot, then a free fall straight down onto it: 28 yd onto the deck (fall damage of this core's formula, about
## 15-25 % of health), 25 yd under the parachute at Baba, 18 yd under Safe Fall by Jerry. The flight times (5 s, 9.6 s for Daisy's
## ride, matching the 10 s of her parachute's periodic aura, 5 s back) and arc heights (apex 75 yd over the deck, so the fall is
## the 65 yd of "Going Down?"; the arcs clear the trees on the way). The landing spots: on the open waist of the top deck 4 yd
## from the Landward Cannon (vmap surface 11.80, nothing above it), 7 yd from Jerry on open ground (his cannon stands under a
## canopy tree whose crown is 25 yd up, the "landed in a tree" fault of 2010), 3.6 yd from Baba.
## "Going Down?" is credited by this script on landing alive on the deck: in this core a free fall of 65 yd costs 93 % of the
## player's health (Player::HandleFall, 0.018 * z - 0.2426) while the sources say the ride gave the achievement and left 70 % or
## took about 700 of 3500 health; the fall here is short (that damage), the credit is the arc's height. Ours, in one block:
## CreditGoingDown (remove its call to drop it).
## The player's pet is dismissed for the ride (the core does it for any vehicle) and comes back where he lands (a 2014 comment
## says it was simply gone on retail); if he dies on landing it comes back when he is alive again (resurrected at his corpse or
## at the spirit healer, within 30 minutes): no core hook tells a script of a resurrection, so his event queue looks every 2 s.
## A rider who logs out in flight is put down on his landing spot at the next login (player_bogpaddle_cannon_flight).
######*/

enum BogpaddleCannons
{
    MENU_LIL_CRAZY_JERRY                = 12099,
    MENU_LIL_CRAZY_DAISY                = 12132,
    MENU_LANDWARD_CANNON                = 12292,

    NPC_BARONS_CANNON_JERRY             = 45873,    // vehicle 1151 (seat 8638: hides the passenger, no control)
    NPC_BARONS_CANNON_DAISY             = 46504,
    NPC_BARONS_CANNON_SHIP              = 47538,

    SPELL_SUMMON_CANNON_JERRY           = 85565,    // summons 45873 at spell_target_position, the core seats the caster
    SPELL_SUMMON_CANNON_DAISY           = 86685,    // summons 46504
    SPELL_SUMMON_CANNON_SHIP            = 88633,    // summons 47538 at the Landward Cannon (condition 13 names it)
    SPELL_FALL_AURA_DAISY               = 86687,    // force cast 86686 on the summoner: periodic 10 s -> 85582
    SPELL_STEAMWHEEDLE_BLAST_CHUTE      = 85582,    // the parachute: small knockback + feather fall
    SPELL_SAFE_FALL_SHIP                = 88632,    // Safe Fall 100 on the summoner, 10 s

    CANNON_LAUNCH_DELAY                 = 2600,     // in the cannon before the shot
    CANNON_JUMP_DELAY                   = 400,      // after the exit, before the jump (a move in the exit's tick is lost)
};

enum BogpaddleCannonFlightId : uint8
{
    FLIGHT_JERRY_TO_DECK    = 0,
    FLIGHT_DAISY_TO_BABA    = 1,
    FLIGHT_SHIP_TO_SHORE    = 2,
    MAX_CANNON_FLIGHTS
};

struct BogpaddleCannonFlight
{
    uint32 CannonEntry;
    Position Launch;        // where the cannon stands (the summon spell's destination)
    Position Landing;       // the ground under the end of the flight
    float Drop;             // free fall from the end of the jump to the landing
    float Amplitude;        // height of the arc over the straight line from the launch to the end of the jump
    uint32 DurationMs;      // the jump
    bool GoingDown;         // credit "Going Down?" on landing alive
};

static BogpaddleCannonFlight const CannonFlights[MAX_CANNON_FLIGHTS] =
{
    { NPC_BARONS_CANNON_JERRY, { -10167.2f, -4182.98f, 22.7538f }, {  -9967.0f, -4543.0f, 11.80f }, 28.0f, 56.0f, 5000, true  },
    { NPC_BARONS_CANNON_DAISY, { -10226.8f, -4154.04f, 23.043f  }, { -10812.0f, -3815.0f, 21.89f }, 25.0f, 60.0f, 9600, false },
    { NPC_BARONS_CANNON_SHIP,  {  -9969.2f, -4539.75f, 11.6994f }, { -10176.0f, -4179.0f, 22.31f }, 18.0f, 50.0f, 5000, false },
};

static BogpaddleCannonFlight const* GetCannonFlightByEntry(uint32 entry, uint8* id = nullptr)
{
    for (uint8 i = 0; i < MAX_CANNON_FLIGHTS; ++i)
    {
        if (CannonFlights[i].CannonEntry == entry)
        {
            if (id)
                *id = i;
            return &CannonFlights[i];
        }
    }
    return nullptr;
}

// Players in a cannon flight, by guid counter: the flight and when it began. Read at login (a rider who logged out in the air)
// and by the cannon options (no second cannon while one flight runs). Map threads and the login thread both use it.
static std::mutex CannonFlightsLock;
static std::unordered_map<uint32, std::pair<uint8, uint32>> CannonFlightsInProgress;

static void SetCannonFlight(Player* player, uint8 flightId)
{
    std::lock_guard<std::mutex> guard(CannonFlightsLock);
    CannonFlightsInProgress[player->GetGUID().GetCounter()] = { flightId, getMSTime() };
}

static void ClearCannonFlight(uint32 guidLow)
{
    std::lock_guard<std::mutex> guard(CannonFlightsLock);
    CannonFlightsInProgress.erase(guidLow);
}

// The flight a player is in, or MAX_CANNON_FLIGHTS. maxAgeMs 0: any age (login)
static uint8 GetCannonFlight(uint32 guidLow, uint32 maxAgeMs)
{
    std::lock_guard<std::mutex> guard(CannonFlightsLock);
    auto itr = CannonFlightsInProgress.find(guidLow);
    if (itr == CannonFlightsInProgress.end())
        return MAX_CANNON_FLIGHTS;
    if (maxAgeMs && getMSTimeDiff(itr->second.second, getMSTime()) > maxAgeMs)
        return MAX_CANNON_FLIGHTS;
    return itr->second.first;
}

static bool CanBoardCannon(Player* player)
{
    return player->IsAlive() && !player->GetVehicle() && !player->IsInFlight()
        && GetCannonFlight(player->GetGUID().GetCounter(), 30 * IN_MILLISECONDS) == MAX_CANNON_FLIGHTS;
}

static Position GetCannonJumpEnd(BogpaddleCannonFlight const& flight)
{
    return Position(flight.Landing.GetPositionX(), flight.Landing.GetPositionY(), flight.Landing.GetPositionZ() + flight.Drop);
}

// OURS, removable as one block: "Going Down?" (964, criterion 2072, 65 yd) for landing alive on the deck, credited with the arc's
// height (75.5 yd). This core's fall formula would kill a player falling 65 yd for real; the sources say the ride gave it safely.
static void CreditGoingDown(Player* player, BogpaddleCannonFlight const& flight)
{
    if (player->GetExactDist2d(flight.Landing.GetPositionX(), flight.Landing.GetPositionY()) > 12.0f
        || std::fabs(player->GetPositionZ() - flight.Landing.GetPositionZ()) > 3.0f)
        return;

    float const apex = (flight.Launch.GetPositionZ() + flight.Landing.GetPositionZ() + flight.Drop) * 0.5f + flight.Amplitude;
    player->UpdateAchievementCriteria(ACHIEVEMENT_CRITERIA_TYPE_FALL_WITHOUT_DYING, uint32((apex - flight.Landing.GetPositionZ()) * 100.0f));
}

// Died on landing: the pet put away for the ride comes back once he is alive again (corpse or spirit healer; no core hook for a
// resurrection reaches scripts, so this looks every 2 s, for up to 30 minutes). ResummonPetTemporaryUnSummonedIfAny does nothing
// if he already has a pet or none was put away.
static void ResummonPetWhenAlive(Player* player, uint32 tries)
{
    if (!player->IsInWorld() || player->GetSession()->PlayerLogout())
        return;

    if (!player->IsAlive() || player->IsBeingTeleported())
    {
        if (tries < 900)
            player->m_Events.AddLambdaEventAtOffset([player, tries]() { ResummonPetWhenAlive(player, tries + 1); }, 2000);
        return;
    }

    player->ResummonPetTemporaryUnSummonedIfAny();
}

// Landed (or not falling any more): the pet back, "Going Down?" for the deck, the flight closed. Polled while he still falls.
static void FinishCannonFlight(Player* player, uint8 flightId, uint32 tries)
{
    if (!player->IsInWorld() || player->GetSession()->PlayerLogout())
        return;

    if (player->IsFalling() && tries < 12)
    {
        player->m_Events.AddLambdaEventAtOffset([player, flightId, tries]() { FinishCannonFlight(player, flightId, tries + 1); }, 500);
        return;
    }

    ClearCannonFlight(player->GetGUID().GetCounter());

    if (!player->IsAlive())
    {
        ResummonPetWhenAlive(player, 0);
        return;
    }

    player->ResummonPetTemporaryUnSummonedIfAny();

    if (CannonFlights[flightId].GoingDown)
        CreditGoingDown(player, CannonFlights[flightId]);
}

// Daisy's parachute opens at the 10 s tick of 86686, as the jump ends; should the tick come late or the aura be gone, it opens here
static void OpenCannonParachuteIfNeeded(Player* player)
{
    if (!player->IsInWorld() || player->GetSession()->PlayerLogout() || !player->IsAlive())
        return;

    if (player->IsFalling() && !player->HasAuraType(SPELL_AURA_FEATHER_FALL))
        player->CastSpell(player, SPELL_STEAMWHEEDLE_BLAST_CHUTE, true);
}

// The shot: out of the cannon (the cannon, his Minion, goes with the exit: Unit::_ExitVehicle), the pet kept away until he lands
// (the exit brings it back at the cannon, where it would be left behind and dismissed out of range), then the jump.
static void FireCannon(Player* player, uint8 flightId)
{
    SetCannonFlight(player, flightId);
    player->ExitVehicle();
    player->UnsummonPetTemporaryIfAny();

    player->m_Events.AddLambdaEventAtOffset([player, flightId]()
    {
        if (!player->IsInWorld() || player->GetSession()->PlayerLogout())
            return;

        if (!player->IsAlive() || player->GetVehicle() || player->IsInFlight() || player->IsBeingTeleported())
        {
            ClearCannonFlight(player->GetGUID().GetCounter());
            ResummonPetWhenAlive(player, 0);
            return;
        }

        BogpaddleCannonFlight const& flight = CannonFlights[flightId];
        Position const end = GetCannonJumpEnd(flight);
        float const speedXY = std::max(1.0f, player->GetExactDist(&end) * IN_MILLISECONDS / float(flight.DurationMs));
        float const speedZ = std::sqrt(2.0f * float(Movement::gravity) * flight.Amplitude);
        player->GetMotionMaster()->MoveJump(end.GetPositionX(), end.GetPositionY(), end.GetPositionZ(), speedXY, speedZ);

        float const dropMs = std::sqrt(2.0f * flight.Drop / float(Movement::gravity)) * IN_MILLISECONDS;
        if (flightId == FLIGHT_DAISY_TO_BABA)
            player->m_Events.AddLambdaEventAtOffset([player]() { OpenCannonParachuteIfNeeded(player); }, flight.DurationMs + 600);

        player->m_Events.AddLambdaEventAtOffset([player, flightId]() { FinishCannonFlight(player, flightId, 0); },
            flight.DurationMs + uint32(dropMs) + 1000);
    }, CANNON_JUMP_DELAY);
}

// 45873, 46504, 47538 The Baron's Cannon: the vehicle summoned by the cannon options. Holds the player for a few seconds, gives him
// the cannon's fall spell (Daisy's parachute, the Landward Cannon's Safe Fall; Jerry's none) and fires him.
struct npc_bogpaddle_barons_cannon : public ScriptedAI
{
    npc_bogpaddle_barons_cannon(Creature* creature) : ScriptedAI(creature) { }

    void InitializeAI() override
    {
        me->SetReactState(REACT_PASSIVE);
    }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        if (!passenger->ToPlayer())
            return;

        if (apply)
        {
            // Nothing hits the cannon (and so throws out its rider) on the gilblins' deck; set once he is in
            me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE | UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
            _riderGUID = passenger->GetGUID();
            _launchTimer = CANNON_LAUNCH_DELAY;
        }
        else if (passenger->GetGUID() == _riderGUID)
        {
            // Left before the shot (logout, death, a leave-vehicle click): no flight; the cannon goes with him (Minion)
            _riderGUID.Clear();
            _launchTimer = 0;
        }
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_launchTimer)
            return;

        if (_launchTimer > diff)
        {
            _launchTimer -= diff;
            return;
        }
        _launchTimer = 0;

        uint8 flightId = MAX_CANNON_FLIGHTS;
        Vehicle* kit = me->GetVehicleKit();
        Unit* passenger = kit ? kit->GetPassenger(0) : nullptr;
        Player* player = passenger ? passenger->ToPlayer() : nullptr;
        if (!player || player->GetGUID() != _riderGUID || !GetCannonFlightByEntry(me->GetEntry(), &flightId))
        {
            me->DespawnOrUnsummon();
            return;
        }

        // The fall spells target the cannon's summoner (TARGET_UNIT_SUMMONER)
        if (flightId == FLIGHT_DAISY_TO_BABA)
            DoCast(me, SPELL_FALL_AURA_DAISY, true);
        else if (flightId == FLIGHT_SHIP_TO_SHORE)
            DoCast(me, SPELL_SAFE_FALL_SHIP, true);

        FireCannon(player, flightId);
        // The exit unsummons the cannon (his Minion); this only covers a cannon that would not be one
        me->DespawnOrUnsummon(1000);
    }

private:
    ObjectGuid _riderGUID;
    uint32 _launchTimer = 0;
};

// 46245 Lil' Crazy Jerry (menu 12099, while In With a Bang is in the log) and 46503 Lil' Crazy Daisy (menu 12132, while Baba
// Bogbrew is in the log): the option summons the cannon, which seats the player
struct npc_bogpaddle_cannon_kid : public ScriptedAI
{
    npc_bogpaddle_cannon_kid(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 /*gossipListId*/) override
    {
        uint32 spellId = 0;
        if (menuId == MENU_LIL_CRAZY_JERRY)
            spellId = SPELL_SUMMON_CANNON_JERRY;
        else if (menuId == MENU_LIL_CRAZY_DAISY)
            spellId = SPELL_SUMMON_CANNON_DAISY;
        else
            return false;

        CloseGossipMenuFor(player);
        if (CanBoardCannon(player))
            player->CastSpell(player, spellId, true);
        return true;
    }
};

// 206679 Landward Cannon (menu 12292, no quest gate: anyone on the frigate can leave)
struct go_bogpaddle_landward_cannon : public GameObjectAI
{
    go_bogpaddle_landward_cannon(GameObject* go) : GameObjectAI(go) { }

    // The handler passes the menu id and the option's list index here
    bool OnGossipSelect(Player* player, uint32 menuId, uint32 /*gossipListId*/) override
    {
        if (menuId != MENU_LANDWARD_CANNON)
            return false;

        CloseGossipMenuFor(player);
        if (CanBoardCannon(player))
            player->CastSpell(player, SPELL_SUMMON_CANNON_SHIP, true);
        return true;
    }
};

// A rider who logged out or lost his connection in the air is saved where the jump had taken him, up to 75 yd over the water or
// the deck, and would fall from there at the next login. Before he enters the world, a player is put on his landing spot when he
// was saved at least 12 yd above the ground or water below him (vmaps counted: the deck is ground), within 40 yd (2D) of a cannon
// flight's line, and not on a mount or flying. The flight is the one recorded at the shot (kept in memory across the logout);
// after a server restart it is unknown, and he is put on the nearer end of the line he is on (Jerry and the Landward Cannon share
// one line). Ours (no source says what retail did).
class player_bogpaddle_cannon_flight : public PlayerScript
{
public:
    player_bogpaddle_cannon_flight() : PlayerScript("player_bogpaddle_cannon_flight") { }

    static float DistToSegment2d(Position const& p, Position const& a, Position const& b, float* along = nullptr)
    {
        float const dx = b.GetPositionX() - a.GetPositionX(), dy = b.GetPositionY() - a.GetPositionY();
        float const len2 = dx * dx + dy * dy;
        float t = 0.0f;
        if (len2 > 0.0f)
            t = std::max(0.0f, std::min(1.0f, ((p.GetPositionX() - a.GetPositionX()) * dx + (p.GetPositionY() - a.GetPositionY()) * dy) / len2));
        if (along)
            *along = t;
        return std::hypot(p.GetPositionX() - (a.GetPositionX() + dx * t), p.GetPositionY() - (a.GetPositionY() + dy * t));
    }

    void OnLoadFromDB(Player* player) override
    {
        uint32 const guidLow = player->GetGUID().GetCounter();
        uint8 const recorded = GetCannonFlight(guidLow, 0);
        ClearCannonFlight(guidLow);

        if (player->GetMapId() != 0 || player->HasAuraType(SPELL_AURA_MOUNTED) || player->HasAuraType(SPELL_AURA_FLY)
            || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
            return;

        Position const pos = player->GetPosition();
        int8 landingId = -1;
        for (uint8 i = 0; i < MAX_CANNON_FLIGHTS && landingId < 0; ++i)
        {
            BogpaddleCannonFlight const& flight = CannonFlights[i];
            float along = 0.0f;
            if (DistToSegment2d(pos, flight.Launch, flight.Landing, &along) > 40.0f)
                continue;

            if (recorded < MAX_CANNON_FLIGHTS)
            {
                // The recorded flight, if this is its line (the deck and shore flights share theirs)
                if (recorded == i || (recorded != FLIGHT_DAISY_TO_BABA && i != FLIGHT_DAISY_TO_BABA))
                    landingId = recorded;
            }
            else if (i == FLIGHT_DAISY_TO_BABA)
                landingId = FLIGHT_DAISY_TO_BABA;
            else
                landingId = along >= 0.5f ? i : (i == FLIGHT_JERRY_TO_DECK ? FLIGHT_SHIP_TO_SHORE : FLIGHT_JERRY_TO_DECK);
        }

        if (landingId < 0)
            return;

        Map* map = sMapMgr->FindBaseNonInstanceMap(0);
        if (!map)
            return;

        float const below = map->GetWaterOrGroundLevel(PHASEMASK_NORMAL, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ());
        if (pos.GetPositionZ() < below + 12.0f)
            return;

        Position const& landing = CannonFlights[landingId].Landing;
        TC_LOG_DEBUG("scripts", "player_bogpaddle_cannon_flight: %s logged in on a cannon flight at %.1f %.1f %.1f (%.1f yd up), put down at %.1f %.1f %.1f",
            player->GetName().c_str(), pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), pos.GetPositionZ() - below,
            landing.GetPositionX(), landing.GetPositionY(), landing.GetPositionZ());
        player->Relocate(landing.GetPositionX(), landing.GetPositionY(), landing.GetPositionZ() + 0.5f, player->GetOrientation());
        player->SetFallInformation(0, landing.GetPositionZ() + 0.5f);
    }
};

/*######
## Silversnap Swim Tonic (item 62795, Maliciously Delicious 27587)
## What the player sees (sources: 27587 comments 2010-12-01 [+8], 2010-11-27 [+5], 2011-03-23 [+7], 2010-12-06 [+3],
## 2011-02-06 [+2]; the wiki 27600 note "for an easier swim back"; spells 88026, 88416, 88008): for 15 minutes in the Swamp of
## Sorrows he breathes under water and walks on the sea floor 60 % faster (also mounted); crossing into Redridge or entering the
## Sunken Temple ends it (the spells' AreaGroup 2801 = zone 8).
## The item's spell 88026 is a bare marker aura; the effects are 88416 (run speed +60 %, water breathing, linked 88008: swim speed,
## underwater walking 315, the walking animation set), which nothing applies. The core removes 88416 on every move out of the
## water (its AuraInterruptFlags NOT_UNDERWATER: Unit::ProcessTerrainStatusUpdate on each relocation whose liquid status is
## neither in nor under water) and nothing puts it back, so it is meant to be on him only in the water and has to come back each
## time he goes in again: a spell_area row on aura 88026 would give it once, on the drink (Aura::HandleAuraSpecificMods), and a
## second drink only refreshes 88026. Here the marker checks every second: swimming or under water he gets 88416; wading in
## shallow water (less than 0.6 of his height, where the client would not start swimming without it) he loses it, so the +60 %
## is not given in the swamp's shallows; between the two it stays as it is (no flicker at the edge of the deep water); out of the
## water the core takes it. 88416's linked 88008 (the sea-floor walk) lasts 15 min while 88416 has no end: after an early
## second drink 88008 runs out first, so 88416 is cast again whenever 88008 is missing. The client walks him on the bottom from
## aura 315 by itself (CGUnit_C aura-added handler sets the client flag 0x80000000, and UpdateSwimmingStatus then uses the
## "flight style": 5.0.4 decomp Unit_C.cpp 3386, 20929), so the server needs no handler.
## Ours: the one-second check and its depth rule (the map's liquid level against his position, one liquid query a second; the
## swim flag from his own movement); no speed bonus on land or in shallows (user question 14).
######*/

enum SilversnapSwimTonic
{
    SPELL_SILVERSNAP_SWIM_TONIC_MARKER  = 88026,    // the item's spell: dummy, 15 min, zone 8
    SPELL_SILVERSNAP_SWIM_TONIC         = 88416,    // speed, breathing, linked 88008 (underwater walking); zone 8
    SPELL_SILVERSNAP_SWIM_TONIC_WALK    = 88008,    // swim speed, underwater walking 315, walking anims; 15 min
};

class spell_bogpaddle_silversnap_swim_tonic : public AuraScript
{
    PrepareAuraScript(spell_bogpaddle_silversnap_swim_tonic);

    void CalcPeriodic(AuraEffect const* /*aurEff*/, bool& isPeriodic, int32& amplitude)
    {
        isPeriodic = true;
        amplitude = 1 * IN_MILLISECONDS;
    }

    void OnPeriodic(AuraEffect const* /*aurEff*/)
    {
        PreventDefaultAction();

        Unit* target = GetTarget();
        if (!target->IsInWorld())
            return;

        bool hasTonic = target->HasAura(SPELL_SILVERSNAP_SWIM_TONIC);
        // 88008 (15 min) ran out under a 88416 that has no end (an early second tonic): start both again
        if (hasTonic && !target->HasAura(SPELL_SILVERSNAP_SWIM_TONIC_WALK))
        {
            target->RemoveAurasDueToSpell(SPELL_SILVERSNAP_SWIM_TONIC);
            hasTonic = false;
        }

        LiquidData liquid;
        ZLiquidStatus const status = target->GetMap()->GetLiquidStatus(target->GetPhaseMask(), target->GetPositionX(),
            target->GetPositionY(), target->GetPositionZ(), MAP_ALL_LIQUIDS, &liquid, target->GetCollisionHeight());
        bool const inLiquid = (status & (LIQUID_MAP_IN_WATER | LIQUID_MAP_UNDER_WATER)) != 0;
        bool const swimming = target->HasUnitMovementFlag(MOVEMENTFLAG_SWIMMING);
        bool const deep = inLiquid && (swimming || (status & LIQUID_MAP_UNDER_WATER));
        bool const shallow = !inLiquid || (!swimming && liquid.level - target->GetPositionZ() < 0.6f * target->GetCollisionHeight());

        if (!hasTonic && deep && target->IsAlive() && !target->IsInFlight())
            target->CastSpell(target, SPELL_SILVERSNAP_SWIM_TONIC, true);
        else if (hasTonic && shallow)
            target->RemoveAurasDueToSpell(SPELL_SILVERSNAP_SWIM_TONIC);
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        GetTarget()->RemoveAurasDueToSpell(SPELL_SILVERSNAP_SWIM_TONIC);
    }

    void Register() override
    {
        DoEffectCalcPeriodic += AuraEffectCalcPeriodicFn(spell_bogpaddle_silversnap_swim_tonic::CalcPeriodic, EFFECT_0, SPELL_AURA_DUMMY);
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_bogpaddle_silversnap_swim_tonic::OnPeriodic, EFFECT_0, SPELL_AURA_DUMMY);
        AfterEffectRemove += AuraEffectRemoveFn(spell_bogpaddle_silversnap_swim_tonic::AfterRemove, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

/*######
## Stray Land Mines (205545, Mostly Harmless 27536)
## What the player sees (sources: the wiki note of 27536 "Do not carelessly run over the landmines! They will explode. Carefully
## walk up to them and right-click as soon as the cog lights up."; comments 2012-08-16 [+4], 2010-12-24 reply [+2], 2012-03-19
## [+4], 2011-01-23 [+2], 2011-07-07 [+2], 2011-09-23 [+2]; the trap 205547 "Stray Land Mine (Armed)" -> 85452 Summon Explosion
## Bunny 45842 -> 85445 Detonation): a player who runs onto a mine sets it off: knockback and about 170 fire damage to him and the
## players beside him, and the mine is gone until it respawns. One who stops as the cursor turns into the cog and loots it from
## there is safe.
## No 205547 was ever spawned (mop and both TDBs) and this core fires an environmental trap only from a spawned one, so one is
## spawned at each mine. The chest's linked trap (data7) is cleared: the core fires a linked trap on every opening, which would
## blow up the careful looter too.
## The margin, from the code: the mine is looted with "Opening" (6478, 5 yd); its model has an empty bounding box, so the client
## (CGGameObject_C_TypeBase::CheckRange) and the server (GameObject::IsAtInteractDistance) both allow it from inside a 10 x 10 yd
## box around it, turned with the mine; the cog lights up at its edge, 5 yd in front of the mine (up to 7 yd at its corners). The
## trap measures the exact distance to the player. With the template's 5 yd a player coming straight at a mine would stand on the
## trap's edge the moment the cog lights up; TrinityCore reads that field as a diameter (radius 2.5, the Cataclysm core in
## E:\WoW Cores\CataclysmPreservationProject halves it), this core as a radius. The trap is 3 yd here (ours: the integer nearest
## the 2.5 yd radius), so the band from 3 to 5 yd is safe all round and running over a mine is not.
## Ours: the trap spawns (gameobject 3136000-3136018, on the mines, server-side only, 120 s like the mines), the one-shot trap type,
## the 3 yd, the explosion bunny's script: it explodes only beside a mine that is there, takes the mine away for its respawn time,
## and the explosion hits players and what they control (pets: a 2014 comment says pets set them off; here they are only hit),
## nothing else, and uses no object (85445's ACTIVATE_OBJECT would "use" the mines and traps around it). A mine looted carefully
## takes its trap with it (both come back together when the mines respawn in 120 s: sos-ac's 2026_11_23_01; at the old 300 s a
## trap is back before its mine and does nothing).
## Not as the sources: auto-loot from the edge set a mine off every time (2012-03-19 [+4], 2025-05-22 [+1]): here only distance
## counts; pets set mines off (2014-03-19 [+3]): here only players. The 3-5 yd band is read from the code, not tried in game.
######*/

enum BogpaddleLandMines
{
    GO_STRAY_LAND_MINE                  = 205545,
    GO_STRAY_LAND_MINE_ARMED            = 205547,   // the trap: 85452 summons 45842 at it
    SPELL_LAND_MINE_DETONATION          = 85445,    // knockback, 174 fire, activate object; 7 yd
};

// 205545 Stray Land Mine: looted (or blown up), it takes its trap away for the same respawn time
struct go_bogpaddle_stray_land_mine : public GameObjectAI
{
    go_bogpaddle_stray_land_mine(GameObject* go) : GameObjectAI(go) { }

    void OnStateChanged(uint32 state, Unit* /*unit*/) override
    {
        if (state != GO_JUST_DEACTIVATED)
            return;

        std::list<GameObject*> traps;
        me->GetGameObjectListWithEntryInGrid(traps, GO_STRAY_LAND_MINE_ARMED, 1.5f);
        for (GameObject* trap : traps)
            if (trap->isSpawned() && trap->getLootState() != GO_JUST_DEACTIVATED)
                trap->SetLootState(GO_JUST_DEACTIVATED);
    }
};

// 45842 Stray Land Mine Explosion Bunny, summoned by the trap (as a guardian of the trap's spell trigger, which lasts 100 ms):
// explodes at once beside a mine that is there, and takes the mine away for its respawn time
struct npc_bogpaddle_land_mine_explosion_bunny : public ScriptedAI
{
    npc_bogpaddle_land_mine_explosion_bunny(Creature* creature) : ScriptedAI(creature) { }

    void InitializeAI() override
    {
        me->SetReactState(REACT_PASSIVE);
    }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        Detonate();
    }

    // A static spawn (two stood on mines; the spawn section deletes them, plan K14) never explodes
    void UpdateAI(uint32 /*diff*/) override
    {
        if (me->IsSummon())
            Detonate();
    }

    void Detonate()
    {
        if (_done)
            return;
        _done = true;

        GameObject* mine = nullptr;
        std::list<GameObject*> mines;
        me->GetGameObjectListWithEntryInGrid(mines, GO_STRAY_LAND_MINE, 3.0f);
        for (GameObject* go : mines)
            if (go->isSpawned() && go->getLootState() != GO_JUST_DEACTIVATED && (!mine || me->GetExactDist(go) < me->GetExactDist(mine)))
                mine = go;

        if (!mine)
        {
            me->DespawnOrUnsummon();
            return;
        }

        DoCast(me, SPELL_LAND_MINE_DETONATION, true);
        mine->SetLootState(GO_JUST_DEACTIVATED);
        me->DespawnOrUnsummon(1000);
    }

private:
    bool _done = false;
};

// 85445 Detonation: players and what they control only; no object is used
class spell_bogpaddle_land_mine_detonation : public SpellScript
{
    PrepareSpellScript(spell_bogpaddle_land_mine_detonation);

    void FilterUnits(std::list<WorldObject*>& targets)
    {
        targets.remove_if([](WorldObject* object)
        {
            Unit* unit = object->ToUnit();
            return !unit || !unit->IsControlledByPlayer();
        });
    }

    void FilterObjects(std::list<WorldObject*>& targets)
    {
        targets.clear();
    }

    void PreventActivate(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_bogpaddle_land_mine_detonation::FilterUnits, EFFECT_0, TARGET_UNIT_DEST_AREA_ENTRY);
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_bogpaddle_land_mine_detonation::FilterUnits, EFFECT_1, TARGET_UNIT_DEST_AREA_ENTRY);
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_bogpaddle_land_mine_detonation::FilterObjects, EFFECT_2, TARGET_GAMEOBJECT_DEST_AREA);
        OnEffectHitTarget += SpellEffectFn(spell_bogpaddle_land_mine_detonation::PreventActivate, EFFECT_2, SPELL_EFFECT_ACTIVATE_OBJECT);
    }
};

void AddSC_swamp_of_sorrows_bogpaddle()
{
    RegisterGameObjectAI(go_bogpaddle_stray_land_mine);
    RegisterCreatureAI(npc_bogpaddle_land_mine_explosion_bunny);
    new spell_script<spell_bogpaddle_land_mine_detonation>("spell_bogpaddle_land_mine_detonation");
    new aura_script<spell_bogpaddle_silversnap_swim_tonic>("spell_bogpaddle_silversnap_swim_tonic");
    RegisterCreatureAI(npc_bogpaddle_barons_cannon);
    RegisterCreatureAI(npc_bogpaddle_cannon_kid);
    RegisterGameObjectAI(go_bogpaddle_landward_cannon);
    new player_bogpaddle_cannon_flight();
}
