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
SDName: Burning Steppes, Assault on Dreadmaul Rock
SDComment: Quest support: 28320 (Alliance) / 28454 (Horde) Assault on Dreadmaul Rock - the war council cinematic, the
           Obsidian-Cloaked Dragon, its leash and the teleport back to Morgan's Vigil / Flame Crest
SDCategory: Burning Steppes
EndScriptData */

/*######
## What the player sees (sources: wiki notes on 28320 / 28454; comments 2011-02-09 [+22], 2011-01-08 [+37], 2012-09-13 [+32],
## 2010-11-28 [+17], 2010-12-03 [+23], 2013-04-06 [+10], 2010-11-30 [+7], 2013-11-30 [+4]; the AODR spells 89947, 89916, 89919,
## 89921, 89966, 89977, 90069, 90081, 93898-93902; broadcast texts 48535-48550, 48653, 48656, 48658; Phase.dbc 341 / 342):
## Taking the quest starts a cutscene (89947: the AODR Event Camera and phase 341, "Assault on Dreadmaul Rock - Cinematic").
## "Meanwhile, atop Dreadmaul Rock..." - the camera flies away to the top of Dreadmaul Rock, where the Big Three walk onto a ledge
## for a war council: Thorg'izog covers his backside, Neeralak is black and smoking (89966). The sixteen-line exchange; "Behold!",
## Xi'lun steps forward on the overseeing ledge and begins a summoning ritual (the thumb-war line in Demonic), the pit lord
## Hellmondath appears on the field below, Xi'lun tries the Orb of Domination, the pit lord rampages through the Blackrock ranks
## and the troops flee. The camera pulls back up to Thorg'izog and Neeralak: "The pit lord's loose! We're doomed! Retreat!". The
## player is then shown on the disguised red dragon above the rock (90081, 90069), laughing; "Quickly, everyone run toward those
## dragons!" / "I never called any dragons..."; "The Blackrock forces are panicking!  Strike at them now!".
## The battle: the player flies the Obsidian-Cloaked Dragon (Fiery Breath on its bar, 15000 damage to Blackrock Invaders in 15 yd),
## kills 200 invaders, and flies back to the camp; "Return to Dreadmaul Rock, or you will be dropped!" outside the battle area.
## Skipping the cutscene does not bug the quest here (retail's bug, comments [+17] [+24]): leaving the camera skips to the dragon.
##
## Ours (no source says how): the camera's flight and every shot position; the line timings (about 5 s a line); the Big Three's
## walk-on from 10 yd behind the ledge; Xi'lun's ledge spot and his channelling and cast emotes; the talk / question emotes of
## the lines; Hellmondath's rampage path and the ranks he kills (up to 8) or scatters (8 s flight) - the scene's 48414 ranks are
## shared spawns in phase 341, seen only by players in the cutscene; the order of the last two lines after the dragon reveal
## (the [+37] comment's order); the end of the actors 25 s after the reveal (Hellmondath 12 s); the laugh. Not used: 48547
## "It... it's not doing anything!  The pit lord is loose!" (no transcript has it).
##
## Core notes. 89947's summon is a vehicle summon (category 4): the core seats the player at once (VEHICLE_SPELL_RIDE_HARDCODED)
## and the camera is his Minion, which goes 1 ms after he leaves it (Unit::_ExitVehicle) and when he leaves the world. The summon
## copies the player's phases before the spell's PHASE aura lands (C37), so the camera puts itself in 341 (and only there once he
## is seated: no open-world mob sees it). The camera's seats (VehicleSeat 9099 / 9103: HIDE_PASSENGER, PASSENGER_NOT_SELECTABLE,
## CAN_ENTER_OR_EXIT) use CameraModes 120 / 119 (flags 0x174, client CCameraModeLocked): 120 looks 5 yd ahead along the camera's
## own facing (a flight shot), 119 looks at the camera's UNIT_FIELD_CHANNEL_OBJECT + 2 yd (with none it looks straight up, the
## "staring at the sky" of comment 2011-09-24: the camera always has an aim in seat 1). The continent's visibility is 90 yd, so
## the field shots are taken within it; the actors are shown from 200 yd.
######*/

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "Group.h"
#include "WorldSession.h"
#include "Map.h"
#include "SpellMgr.h"
#include "SpellInfo.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "CombatAI.h"
#include "CreatureTextMgr.h"
#include "MotionMaster.h"

enum AssaultData
{
    QUEST_ASSAULT_ON_DREADMAUL_ROCK_A           = 28320,
    QUEST_ASSAULT_ON_DREADMAUL_ROCK_H           = 28454,

    ZONE_BURNING_STEPPES                        = 46,
    MAP_EASTERN_KINGDOMS                        = 0,

    NPC_XILUN                                   = 48370,    // High Warlock Xi'lun (actor)
    NPC_NEERALAK                                = 48371,    // Dragon-Lord Neeralak (actor)
    NPC_THORGIZOG                               = 48372,    // General Thorg'izog (actor)
    NPC_AODR_CAMERA                             = 48373,    // AODR Event Camera, vehicle 1324
    NPC_HELLMONDATH                             = 48409,    // Hellmondath (actor)
    NPC_BLACKROCK_RANKS                         = 48414,    // Blackrock Invader, phase 341 (cinematic only)
    NPC_OBSIDIAN_CLOAKED_DRAGON                 = 48434,    // vehicle 1327

    SPELL_AODR_SUMMON_CAMERA_PHASE              = 89947,    // summons 48373 (vehicle summon) + PHASE 341; the quests' start spell
    SPELL_AODR_SUMMON_XILUN                     = 89916,
    SPELL_AODR_SUMMON_NEERALAK                  = 89919,
    SPELL_AODR_SUMMON_THORGIZOG                 = 89921,
    SPELL_SMOKING_NEERALAK                      = 89966,
    SPELL_AODR_SUMMON_HELLMONDATH               = 89977,
    SPELL_AODR_PLAYER_TELEPORT                  = 90081,    // to (-8030.47,-2471.34,240.56) + FLY 500 ms
    SPELL_AODR_SUMMON_DRAGON                    = 90069,    // summons 48434 at the caster (vehicle summon) + removes 89947
    SPELL_OBSIDIAN_CLOAKED_DRAGON_FLIGHT        = 90071,    // FLY, knockback immunity, vehicle flight speed +240 %
    SPELL_CALL_OF_THE_RED_DRAGONFLIGHT          = 90079,    // the Horn of the Callers' dragon
    SPELL_AODR_TELEPORT_BACK_MASTER             = 93901,    // dummy: 93900 Flame Crest (effect 0) / 93898 Morgan's Vigil (effect 1)
    SPELL_AODR_TELEPORT_TO_MORGANS_VIGIL        = 93898,
    SPELL_AODR_TELEPORT_TO_FLAME_CREST          = 93900,

    // VehicleSeat ids of 1324 by seat index: 0 = 9099 (CameraMode 120, flight), 1 = 9103 (CameraMode 119, aimed)
    SEAT_CAMERA_FLIGHT                          = 0,
    SEAT_CAMERA_AIMED                           = 1,
    // Vehicle 1327: 0 = 9106 (CAN_CONTROL, CAN_CAST: the rider flies and breathes), 1 = 9107 (empty, user question Q3)
    SEAT_DRAGON_CONTROL                         = 0,

    // creature_text, all personal (TextRange 5): the scene is the player's alone
    TALK_XILUN_BUTT                             = 0,        // 48535
    TALK_XILUN_SERGEANTS                        = 1,        // 48537
    TALK_XILUN_BLACK_AND_SMOKY                  = 2,        // 48539
    TALK_XILUN_FLAMEKIN                         = 3,        // 48541
    TALK_XILUN_BEHOLD                           = 4,        // 48544
    TALK_XILUN_THUMB_WAR                        = 5,        // 48545 (Demonic)
    TALK_XILUN_ORB                              = 6,        // 48546
    TALK_THORGIZOG_STOMACH                      = 0,        // 48536
    TALK_THORGIZOG_SERGEANTS                    = 1,        // 48538
    TALK_THORGIZOG_RETREAT                      = 2,        // 48548
    TALK_THORGIZOG_DRAGONS                      = 3,        // 48549
    TALK_NEERALAK_IMPS                          = 0,        // 48540
    TALK_NEERALAK_WARLOCK_CRAP                  = 1,        // 48542
    TALK_NEERALAK_FRONT_LINES                   = 2,        // 48543
    TALK_NEERALAK_NO_DRAGONS                    = 3,        // 48550
    TALK_CAMERA_MEANWHILE                       = 0,        // 48658 boss emote
    TALK_DRAGON_PANICKING                       = 0,        // 48656 boss emote
    TALK_DRAGON_RETURN                          = 1,        // 48653 boss whisper

    POINT_CAMERA_PATH                           = 1,
    POINT_ACTOR_WALK                            = 2,
};

enum AssaultCameraEvents
{
    EVENT_CAMERA_WAIT_FOR_RIDER                 = 1,
    EVENT_CAMERA_BEGIN,
    EVENT_CAMERA_APPROACH_CHECK,
    EVENT_COUNCIL_BUTT,
    EVENT_COUNCIL_STOMACH,
    EVENT_COUNCIL_SERGEANTS_Q,
    EVENT_COUNCIL_SERGEANTS_A,
    EVENT_COUNCIL_BLACK_AND_SMOKY,
    EVENT_COUNCIL_IMPS,
    EVENT_COUNCIL_FLAMEKIN,
    EVENT_COUNCIL_WARLOCK_CRAP,
    EVENT_COUNCIL_FRONT_LINES,
    EVENT_COUNCIL_BEHOLD,
    EVENT_RITUAL_TO_THE_LEDGE,
    EVENT_RITUAL_THUMB_WAR,
    EVENT_RITUAL_PIT_LORD,
    EVENT_RITUAL_ROAR,
    EVENT_RITUAL_ORB,
    EVENT_RAMPAGE,
    EVENT_RAMPAGE_TICK,
    EVENT_BACK_TO_THE_LEDGE,
    EVENT_RETREAT,
    EVENT_CAMERA_END,
};

enum AssaultDragonEvents
{
    EVENT_DRAGON_NO_RIDER                       = 1,
    EVENT_DRAGON_CHECK,
    EVENT_REVEAL_LAUGH,
    EVENT_REVEAL_TO_THE_DRAGONS,
    EVENT_REVEAL_NO_DRAGONS,
    EVENT_REVEAL_PANICKING,
    EVENT_REVEAL_PIT_LORD_GONE,
    EVENT_REVEAL_END,
};

// Where the camera holds for the war council: 26 yd west of the Big Three, 8 yd above them, over the cliff. The three stand
// within 31 deg of one another seen from here (CameraMode 119: FOV 90, +-35 deg across at 16:9), line of sight over the ledge
// rim clear by 2.4 yd or more (maps + vmaps)
Position const AodrCouncilShot      = { -7934.0f, -2533.5f, 230.0f };
// The flight's last two corners: over the valley north-west of the rock, then heading east at the council
Position const AodrApproach[]       =
{
    { -7955.0f, -2470.0f, 240.0f },
    { -7936.0f, -2508.0f, 233.0f },
    { -7934.0f, -2533.5f, 230.0f },
};
// Over Xi'lun's shoulder, 13 yd behind him on the ledge and 14 yd up: he and the field below in one frame
Position const AodrRitualPath[]     =
{
    { -7931.0f, -2552.0f, 236.0f },
    { -7928.4f, -2567.4f, 236.0f },
};
// Down to the field, 36 yd east of the summoning spot and 16 yd up: Hellmondath and the ranks he runs into are within the 90 yd
// visibility; the posed corpse of Hellmondath 48655 (phase 342, 44 yd from here) stays 76 deg or more out of the frame
Position const AodrFieldPath[]      =
{
    { -7932.0f, -2540.0f, 228.0f },
    { -7934.0f, -2500.0f, 190.0f },
    { -7935.0f, -2462.0f, 152.0f },
};
Position const AodrBackUpPath[]     =
{
    { -7935.0f, -2500.0f, 205.0f },
    { -7934.0f, -2533.5f, 230.0f },
};
// The Big Three's spots (89916 / 89919 / 89921's spell_target_position) and where they walk on from (10 yd east)
Position const AodrXilunSpot        = { -7939.70f, -2561.91f, 221.497f, 2.01233f };
Position const AodrNeeralakSpot     = { -7928.45f, -2554.93f, 222.717f, 3.44961f };
Position const AodrThorgizogSpot    = { -7942.40f, -2561.74f, 221.099f, 1.55287f };
Position const AodrXilunFrom        = { -7939.70f, -2571.91f, 219.0f };
Position const AodrNeeralakFrom     = { -7928.45f, -2564.93f, 214.0f };
Position const AodrThorgizogFrom    = { -7942.40f, -2571.74f, 219.5f };
// The overseeing ledge, 7 yd north-west of his spot, facing the summoning spot (89977's spot, -7956.91,-2442.87,129.61)
Position const AodrXilunLedge       = { -7935.5f, -2556.5f, 221.5f, 1.757f };
// Hellmondath's rampage: from the summoning spot north-west into the thickest ranks of 48414
Position const AodrRampage[]        =
{
    { -7953.0f, -2428.0f, 127.0f },
    { -7950.0f, -2414.0f, 127.0f },
};
// Where 93898 / 93900 set the player down (their spell_target_position rows): 3-4 yd in front of Troteman / Eitrigg
Position const AodrMorgansVigil     = { -8393.3f, -2784.0f, 194.9f, 3.73f };
Position const AodrFlameCrest       = { -7503.4f, -2187.0f, 165.6f, 5.87f };

float const AodrCameraSpeedYd       = 45.0f;    // the flight from the camp (500-550 yd): about 14 s
float const AodrFieldSpeedYd        = 35.0f;
float const AodrSummonCouncilAtYd   = 130.0f;   // the camera's distance from the council shot when the Big Three walk on
float const AodrSearchRange         = 300.0f;   // the dragon's reveal point is 127 yd from the ledge, 100 from the field
float const AodrActorLeashYd        = 400.0f;
float const AodrRampageKillYd       = 7.0f;
float const AodrRampageScatterYd    = 30.0f;
uint32 const AodrRampageKillCap     = 8;

uint32 const AodrActorEntries[]     = { NPC_XILUN, NPC_NEERALAK, NPC_THORGIZOG, NPC_HELLMONDATH };

// The battle area: the Horn of the Callers' AreaGroup 2846 (Blackrock Pass 2417, Dreadmaul Rock 249, Firegut Furnace 5655, Ruins
// of Thaurissan 250, Slither Rock 2419, Terror Wing Path 2420; its 2851 is not in the 5.4.8 AreaTable) plus Valley of Ashes 5677,
// where 164 of the 513 invaders stand (U3; comment 2010-11-30 [+7] fought there). Ours: 5677 in the leash's area
uint32 const AodrBattleAreas[]      = { 2417, 249, 5655, 250, 2419, 2420, 5677 };
uint32 const AodrLeashWarnMs        = 10 * IN_MILLISECONDS;     // "Return to Dreadmaul Rock, or you will be dropped!", then dropped
float const AodrMidAirYd            = 10.0f;    // an exit higher than this above the ground is sent back to the camp

static bool InAodrBattleArea(uint32 areaId)
{
    for (uint32 area : AodrBattleAreas)
        if (area == areaId)
            return true;
    return false;
}

static bool HoldsAssault(Player* player)
{
    for (uint32 questId : { QUEST_ASSAULT_ON_DREADMAUL_ROCK_A, QUEST_ASSAULT_ON_DREADMAUL_ROCK_H })
    {
        QuestStatus status = player->GetQuestStatus(questId);
        if (status == QUEST_STATUS_INCOMPLETE || status == QUEST_STATUS_COMPLETE)
            return true;
    }
    return false;
}

static Creature* FindAodrSummonOf(Player* player, uint32 entry, float range = AodrSearchRange)
{
    std::list<Creature*> creatures;
    player->GetCreatureListWithEntryInGrid(creatures, entry, range);
    for (Creature* creature : creatures)
        if (creature->IsAlive() && creature->IsSummon() && !creature->IsDestroyedObject()
            && creature->ToTempSummon()->GetSummonerGUID() == player->GetGUID())
            return creature;
    return nullptr;
}

static void DespawnAodrActorsOf(Player* player)
{
    std::list<Creature*> creatures;
    for (uint32 entry : AodrActorEntries)
        player->GetCreatureListWithEntryInGridAppend(creatures, entry, AodrSearchRange);

    for (Creature* creature : creatures)
        if (creature->IsSummon() && creature->ToTempSummon()->GetSummonerGUID() == player->GetGUID())
            creature->DespawnOrUnsummon();
}

// Restores gravity once the player is set down: sent twice, as the player's own movement packets replace the server's flags
// (scripted-quest-scenes, Finish). Not while he rides or flies on his own
static void RestoreGravityLater(Player* player)
{
    for (uint32 delay : { 100, 1500 })
        player->m_Events.AddLambdaEventAtOffset([player]()
        {
            if (!player->IsInWorld() || player->GetVehicle() || player->IsInFlight() || player->HasAuraType(SPELL_AURA_FLY)
                || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
                return;

            if (!player->SetDisableGravity(false))
                player->SetDisableGravity(false, true);
        }, delay);
}

// "AODR: Force Teleport Back" (93902) as this core can cast it: 93902's own effect 1 triggers 89948, which is not in the 5.4.8
// DBC, so its master dummy 93901 is cast directly; it picks Morgan's Vigil or Flame Crest by the player's team
// (spell_bs_aodr_teleport_back_master). The player is held hovering first (no root: a root or a teleport in the tick of a vehicle
// exit leaves the client's view in the vehicle), teleported 300 ms later, gravity back after it
static void SendBackToCamp(Player* player)
{
    if (!player->IsAlive())
        return;

    player->SetDisableGravity(true);
    player->m_Events.AddLambdaEventAtOffset([player]()
    {
        if (!player->IsInWorld() || player->GetSession()->PlayerLogout())
            return;

        player->RemoveAurasDueToSpell(SPELL_AODR_SUMMON_CAMERA_PHASE);
        if (player->IsAlive() && !player->GetVehicle() && !player->IsBeingTeleported() && player->GetMapId() == MAP_EASTERN_KINGDOMS)
            player->CastSpell(player, SPELL_AODR_TELEPORT_BACK_MASTER, true);
        player->RemoveAurasDueToSpell(VEHICLE_SPELL_PARACHUTE);
        RestoreGravityLater(player);
    }, 300);
}

// Once the near teleport of 90081 has been acknowledged (polled every 200 ms, up to 5 s): 90069 summons the dragon where he
// then is; the core seats him (vehicle summon) and the spell ends 89947 (phase 341)
static void SummonDragonWhenLanded(Player* player, uint32 tries)
{
    if (!player->IsInWorld() || player->GetSession()->PlayerLogout())
        return;

    if (player->IsBeingTeleportedNear() && tries < 25)
    {
        player->m_Events.AddLambdaEventAtOffset([player, tries]() { SummonDragonWhenLanded(player, tries + 1); }, 200);
        return;
    }

    if (!player->IsAlive() || player->GetVehicle() || player->IsBeingTeleported() || !HoldsAssault(player))
    {
        player->RemoveAurasDueToSpell(SPELL_AODR_SUMMON_CAMERA_PHASE);
        RestoreGravityLater(player);
        return;
    }

    // The teleport's FLY goes now rather than under the rider (its removal would put a flying passenger into a fall)
    player->RemoveAurasDueToSpell(SPELL_AODR_PLAYER_TELEPORT);
    if (!player->SetDisableGravity(false))
        player->SetDisableGravity(false, true);
    player->CastSpell(player, SPELL_AODR_SUMMON_DRAGON, true);

    if (!player->GetVehicle())
    {
        // Not expected: no dragon took him. The horn calls one in the battle area; he is not left 100 yd up in the air
        TC_LOG_ERROR("scripts", "zone_burning_steppes_assault: %s was not seated on the Obsidian-Cloaked Dragon after the cutscene; "
            "sent back to the camp (the Horn of the Callers calls the dragon)", player->GetName().c_str());
        SendBackToCamp(player);
    }
}

// The end of the cutscene, also when it is skipped (the player leaves the camera): 90081 takes him to the reveal point above the
// rock (-8030.5,-2471.3,240.6) with a short FLY, then the dragon (SummonDragonWhenLanded). Held hovering from the camera's exit
// on (300 ms, as the Hillsbrad cameras' Finish). Run on the player's own event queue: the camera is gone by then
static void GoToBattle(Player* player)
{
    if (!player->IsAlive() || player->GetSession()->PlayerLogout())
        return;

    player->SetDisableGravity(true);
    player->m_Events.AddLambdaEventAtOffset([player]()
    {
        if (!player->IsInWorld() || player->GetSession()->PlayerLogout())
            return;

        if (!player->IsAlive() || player->GetVehicle() || player->GetMapId() != MAP_EASTERN_KINGDOMS || player->IsBeingTeleported())
        {
            player->RemoveAurasDueToSpell(SPELL_AODR_SUMMON_CAMERA_PHASE);
            RestoreGravityLater(player);
            return;
        }

        // Abandoned meanwhile: back to the camp instead
        if (!HoldsAssault(player))
        {
            SendBackToCamp(player);
            return;
        }

        player->RemoveAurasDueToSpell(VEHICLE_SPELL_PARACHUTE);
        player->CastSpell(player, SPELL_AODR_PLAYER_TELEPORT, true);
        SummonDragonWhenLanded(player, 0);
    }, 300);
}

// 48370 Xi'lun, 48371 Neeralak, 48372 Thorg'izog, 48409 Hellmondath (personal summons of the player: SummonProperties 3042,
// PERSONAL_SPAWN). Passive, out of reach and never in combat (scripted-quest-scenes: fights are emotes); the camera and the
// dragon move and voice them. Shown from 200 yd and updated far from players. They go with their player (gone, dead, quest
// dropped, far away); the scene itself despawns them at its end
struct npc_bs_aodr_actor : public ScriptedAI
{
    npc_bs_aodr_actor(Creature* creature) : ScriptedAI(creature), _checkTimer(1 * IN_MILLISECONDS) { }

    void IsSummonedBy(Unit* summoner) override
    {
        _playerGUID = summoner->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
        me->setActive(true, ActiveFlags::Script);
        me->SetCustomVisibilityDistance(VISIBILITY_DISTANCE_LARGE, false);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void DamageTaken(Unit* /*attacker*/, uint32& damage) override
    {
        damage = 0;
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type != POINT_MOTION_TYPE || id != POINT_ACTOR_WALK)
            return;

        // At his spot: the spell's facing (Xi'lun on the ledge faces the field)
        if (me->GetEntry() == NPC_XILUN && me->GetExactDist2d(&AodrXilunLedge) < 2.0f)
            me->SetFacingTo(AodrXilunLedge.GetOrientation());
        else if (me->GetEntry() == NPC_XILUN)
            me->SetFacingTo(AodrXilunSpot.GetOrientation());
        else if (me->GetEntry() == NPC_NEERALAK)
            me->SetFacingTo(AodrNeeralakSpot.GetOrientation());
        else if (me->GetEntry() == NPC_THORGIZOG)
            me->SetFacingTo(AodrThorgizogSpot.GetOrientation());
    }

    void UpdateAI(uint32 diff) override
    {
        if (_checkTimer > diff)
        {
            _checkTimer -= diff;
            return;
        }

        _checkTimer = 1 * IN_MILLISECONDS;
        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player || !player->IsInWorld() || !player->IsAlive() || !HoldsAssault(player)
            || !me->IsWithinDistInMap(player, AodrActorLeashYd))
            me->DespawnOrUnsummon();
    }

private:
    ObjectGuid _playerGUID;
    uint32 _checkTimer;
};

// 48373 - AODR Event Camera
// Plays the war council for the player who took Assault on Dreadmaul Rock (89947 is the quests' start spell). Timeline from
// arrival over the rock (A; the flight from the camp takes about 14 s):
//  0 seated: "Meanwhile, atop Dreadmaul Rock...", seat 0, the flight. The Big Three are summoned when the camera is 130 yd from
//  the council shot and walk onto the ledge. A seat 1 on Xi'lun; A+1.5 Xi'lun, A+7 Thorg'izog, A+12.5 Xi'lun, A+17 Thorg'izog,
//  A+24 Xi'lun, A+29 Neeralak, A+35 Xi'lun, A+40.5 / A+45.5 Neeralak, A+51.5 "Behold!"; A+56 Xi'lun to the ledge, the camera
//  over his shoulder; A+59 the ritual (Demonic); A+62.5 Hellmondath, the camera down to the field; A+64 his roar; A+66 the orb;
//  A+68 the rampage (to A+76); A+76 back up to the ledge; A+80 "Retreat!"; A+83.5 the end (GoToBattle: the dragon reveal and the
//  last lines, npc_bs_obsidian_cloaked_dragon).
// Every way out ends it once. Leaving the camera (the Leave button) or the camera going away while the player is still here and
// holds the quest skips to the dragon, as the end does. Abandoning the quest sends him back to the camp; death or a logout ends it
// without either (player_bs_aodr_login sets a player saved in the air down at the camp). A playerbot is never seated: it cannot
// fly the dragon (research\_playerbots-issues.md B34)
struct npc_bs_aodr_camera : public ScriptedAI
{
    npc_bs_aodr_camera(Creature* creature) : ScriptedAI(creature), _boardTries(0), _killed(0), _started(false), _done(false),
        _changingSeat(false), _noScene(false), _councilCalled(false) { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner ? summoner->ToPlayer() : nullptr;
        if (!player)
        {
            me->DespawnOrUnsummon();
            return;
        }

        _playerGUID = player->GetGUID();
        // No scene for a playerbot (it cannot fly the dragon), nor for a quest taken outside Burning Steppes (a share): the camera
        // would fly there from anywhere. The horn calls the dragon in the battle area
        _noScene = player->GetSession()->IsBot() || player->GetMapId() != MAP_EASTERN_KINGDOMS || player->GetZoneId() != ZONE_BURNING_STEPPES;
        _summonerSpot = player->GetPosition();

        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC | UNIT_FLAG_NOT_SELECTABLE);
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        me->setActive(true, ActiveFlags::Script);
        // C37: the summon copied the player's phases before 89947's PHASE aura landed
        me->SetPhased(341, true, true);

        _events.ScheduleEvent(EVENT_CAMERA_WAIT_FOR_RIDER, 500ms);
    }

    // Without a scene he is put off where he stood (the camera's random spot is up to 40 yd away)
    void GetPassengerExitPosition(Unit* passenger, int8 /*seatId*/, Position& pos) override
    {
        if (_noScene && passenger->GetGUID() == _playerGUID)
            pos.Relocate(_summonerSpot);
    }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        if (apply || _changingSeat || _done || passenger->GetGUID() != _playerGUID)
            return;

        // The Leave button, or the core taking him off (death, a teleport)
        Player* player = passenger->ToPlayer();
        End(player, player && player->IsAlive() && player->IsInWorld() && !player->IsBeingTeleportedFar()
            && !player->GetSession()->PlayerLogout());
    }

    // Unsummoned by something other than End: the player left the world (logout, map change) or the camera's 180 s ran out
    void Unsummoned() override
    {
        if (_done)
            return;

        Player* player = ObjectAccessor::FindPlayer(_playerGUID);
        bool const here = player && player->IsInWorld() && !player->GetSession()->PlayerLogout() && player->GetMap() == me->GetMap()
            && player->IsAlive() && !player->IsBeingTeleportedFar();
        End(here ? player : nullptr, here);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == EFFECT_MOTION_TYPE && id == POINT_CAMERA_PATH && _started && !_done && !_councilStarted)
        {
            _councilStarted = true;
            _events.CancelEvent(EVENT_CAMERA_APPROACH_CHECK);
            StartCouncil();
        }
    }

    void UpdateAI(uint32 diff) override
    {
        if (_done)
            return;

        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player || !player->IsInWorld())
        {
            End(nullptr, false);
            return;
        }

        if (_started && !HoldsAssault(player))
        {
            End(player, false);
            return;
        }

        if (_started && !_changingSeat && (!player->IsAlive() || player->GetVehicleBase() != me))
        {
            End(player, player->IsAlive());
            return;
        }

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            SceneEvent(eventId, player);
            if (_done)
                return;
        }
    }

private:
    void SceneEvent(uint32 eventId, Player* player)
    {
        switch (eventId)
        {
            case EVENT_CAMERA_WAIT_FOR_RIDER:
                if (_noScene)
                {
                    // No scene: off the camera, out of phase 341 (the aura lands after the summon)
                    _done = true;
                    if (player->GetVehicleBase() == me)
                        player->ExitVehicle();
                    player->RemoveAurasDueToSpell(SPELL_AODR_SUMMON_CAMERA_PHASE);
                    me->DespawnOrUnsummon(100);
                    return;
                }

                if (player->GetVehicleBase() == me)
                {
                    _started = true;
                    // Out of the open world: from here on only phase 341 (no world mob sees the camera, no passer-by)
                    me->ClearPhases(false);
                    me->SetPhased(341, true, true);
                    _events.ScheduleEvent(EVENT_CAMERA_BEGIN, 500ms);
                }
                else if (++_boardTries < 6 && player->IsAlive())
                {
                    if (!player->GetVehicle())
                        player->EnterVehicle(me, SEAT_CAMERA_FLIGHT);
                    _events.ScheduleEvent(EVENT_CAMERA_WAIT_FOR_RIDER, 500ms);
                }
                else
                {
                    // Not expected. The quest is not lost: the horn calls the dragon in the battle area
                    TC_LOG_ERROR("scripts", "npc_bs_aodr_camera: %s could not be seated in the AODR Event Camera (on a vehicle: %u, alive: %u); "
                        "no cutscene", player->GetName().c_str(), player->GetVehicle() ? 1 : 0, player->IsAlive() ? 1 : 0);
                    _done = true;
                    player->RemoveAurasDueToSpell(SPELL_AODR_SUMMON_CAMERA_PHASE);
                    me->DespawnOrUnsummon(100);
                }
                break;
            case EVENT_CAMERA_BEGIN:
                Begin(player);
                break;
            case EVENT_CAMERA_APPROACH_CHECK:
                if (!_councilCalled && me->GetExactDist(&AodrCouncilShot) <= AodrSummonCouncilAtYd)
                    CallCouncil(player);
                // Arrived (MovementInform's end of the flight; this in case the spline ended without it)
                if (!_councilStarted && !me->isMoving() && me->GetExactDist(&AodrCouncilShot) <= 2.0f)
                {
                    _councilStarted = true;
                    StartCouncil();
                    break;
                }
                _events.ScheduleEvent(EVENT_CAMERA_APPROACH_CHECK, 250ms);
                break;
            case EVENT_COUNCIL_BUTT:
                Say(NPC_XILUN, TALK_XILUN_BUTT, player, NPC_THORGIZOG);
                break;
            case EVENT_COUNCIL_STOMACH:
                Aim(Actor(NPC_THORGIZOG));
                Say(NPC_THORGIZOG, TALK_THORGIZOG_STOMACH, player, NPC_XILUN);
                break;
            case EVENT_COUNCIL_SERGEANTS_Q:
                Aim(Actor(NPC_XILUN));
                Say(NPC_XILUN, TALK_XILUN_SERGEANTS, player, NPC_THORGIZOG);
                break;
            case EVENT_COUNCIL_SERGEANTS_A:
                Aim(Actor(NPC_THORGIZOG));
                Say(NPC_THORGIZOG, TALK_THORGIZOG_SERGEANTS, player, NPC_XILUN);
                break;
            case EVENT_COUNCIL_BLACK_AND_SMOKY:
                Aim(Actor(NPC_XILUN));
                Say(NPC_XILUN, TALK_XILUN_BLACK_AND_SMOKY, player, NPC_NEERALAK);
                break;
            case EVENT_COUNCIL_IMPS:
                Aim(Actor(NPC_NEERALAK));
                Say(NPC_NEERALAK, TALK_NEERALAK_IMPS, player, NPC_XILUN);
                break;
            case EVENT_COUNCIL_FLAMEKIN:
                Aim(Actor(NPC_XILUN));
                Say(NPC_XILUN, TALK_XILUN_FLAMEKIN, player, NPC_NEERALAK);
                break;
            case EVENT_COUNCIL_WARLOCK_CRAP:
                Aim(Actor(NPC_NEERALAK));
                Say(NPC_NEERALAK, TALK_NEERALAK_WARLOCK_CRAP, player, NPC_XILUN);
                break;
            case EVENT_COUNCIL_FRONT_LINES:
                Say(NPC_NEERALAK, TALK_NEERALAK_FRONT_LINES, player, NPC_XILUN);
                break;
            case EVENT_COUNCIL_BEHOLD:
                Aim(Actor(NPC_XILUN));
                Say(NPC_XILUN, TALK_XILUN_BEHOLD, player, 0);
                break;
            case EVENT_RITUAL_TO_THE_LEDGE:
                // "The High Warlock steps forward on an overseeing ledge" ([+37]); the camera pulls away over his shoulder
                if (Creature* xilun = Actor(NPC_XILUN))
                {
                    xilun->SetWalk(true);
                    xilun->GetMotionMaster()->Clear();
                    xilun->GetMotionMaster()->MovePoint(POINT_ACTOR_WALK, AodrXilunLedge);
                }
                Fly(std::begin(AodrRitualPath), std::end(AodrRitualPath), AodrFieldSpeedYd * 0.4f);
                break;
            case EVENT_RITUAL_THUMB_WAR:
                if (Creature* xilun = Actor(NPC_XILUN))
                {
                    xilun->SetFacingTo(AodrXilunLedge.GetOrientation());
                    xilun->SetEmoteState(EMOTE_STATE_SPELL_CHANNEL_OMNI);
                    xilun->AI()->Talk(TALK_XILUN_THUMB_WAR, player);
                }
                break;
            case EVENT_RITUAL_PIT_LORD:
                player->CastSpell(player, SPELL_AODR_SUMMON_HELLMONDATH, true);
                Track(player, NPC_HELLMONDATH);
                if (Creature* xilun = Actor(NPC_XILUN))
                    xilun->SetEmoteState(EMOTE_ONESHOT_NONE);
                if (Creature* pitLord = Actor(NPC_HELLMONDATH))
                {
                    Aim(pitLord);
                    pitLord->SetFacingTo(pitLord->GetAngle(AodrRampage[0].GetPositionX(), AodrRampage[0].GetPositionY()));
                }
                Fly(std::begin(AodrFieldPath), std::end(AodrFieldPath), AodrFieldSpeedYd);
                break;
            case EVENT_RITUAL_ROAR:
                if (Creature* pitLord = Actor(NPC_HELLMONDATH))
                    pitLord->HandleEmoteCommand(EMOTE_ONESHOT_ROAR);
                break;
            case EVENT_RITUAL_ORB:
                if (Creature* xilun = Actor(NPC_XILUN))
                {
                    xilun->HandleEmoteCommand(EMOTE_ONESHOT_SPELL_CAST_OMNI);
                    xilun->AI()->Talk(TALK_XILUN_ORB, player);
                }
                break;
            case EVENT_RAMPAGE:
                // Running north-west into the thickest ranks (path finding takes him past AodrRampage[0])
                if (Creature* pitLord = Actor(NPC_HELLMONDATH))
                {
                    pitLord->SetWalk(false);
                    pitLord->GetMotionMaster()->Clear();
                    pitLord->GetMotionMaster()->MovePoint(POINT_ACTOR_WALK, AodrRampage[1]);
                }
                _events.ScheduleEvent(EVENT_RAMPAGE_TICK, 500ms);
                break;
            case EVENT_RAMPAGE_TICK:
                Rampage();
                _events.ScheduleEvent(EVENT_RAMPAGE_TICK, 1500ms);
                break;
            case EVENT_BACK_TO_THE_LEDGE:
                _events.CancelEvent(EVENT_RAMPAGE_TICK);
                Aim(Actor(NPC_THORGIZOG));
                Fly(std::begin(AodrBackUpPath), std::end(AodrBackUpPath), AodrFieldSpeedYd);
                break;
            case EVENT_RETREAT:
                Aim(Actor(NPC_THORGIZOG));
                Say(NPC_THORGIZOG, TALK_THORGIZOG_RETREAT, player, 0);
                if (Creature* thorgizog = Actor(NPC_THORGIZOG))
                    thorgizog->HandleEmoteCommand(EMOTE_ONESHOT_EXCLAMATION);
                break;
            case EVENT_CAMERA_END:
                End(player, true);
                break;
            default:
                break;
        }
    }

    void Begin(Player* player)
    {
        // The seated player cannot be reached and is hidden from everyone else (as the Badlands cameras): mobs that followed let go
        player->CombatStop();
        if (player->IsVisible())
        {
            _riderHidden = true;
            player->SetVisible(false);
        }

        Talk(TALK_CAMERA_MEANWHILE, player);

        me->SetSpeed(MOVE_RUN, AodrCameraSpeedYd / 7.0f);
        me->SetSpeed(MOVE_FLIGHT, AodrCameraSpeedYd / 7.0f);

        // Up from the camp, then over the valley and in at the council from the west (the flight shot looks ahead)
        std::vector<Position> corners;
        Position lift = me->GetPosition();
        lift.m_positionZ = std::max(lift.GetPositionZ() + 30.0f, 230.0f);
        corners.push_back(lift);
        corners.insert(corners.end(), std::begin(AodrApproach), std::end(AodrApproach));
        Fly(corners.data(), corners.data() + corners.size(), 0.0f, 10.0f);

        _events.ScheduleEvent(EVENT_CAMERA_APPROACH_CHECK, 250ms);
    }

    // The Big Three appear 10 yd behind the ledge and walk onto it ("The Big Three walk onto the scene", [+37])
    void CallCouncil(Player* player)
    {
        _councilCalled = true;

        struct Member { uint32 spell; uint32 entry; Position const* from; Position const* spot; };
        Member const members[] =
        {
            { SPELL_AODR_SUMMON_XILUN,      NPC_XILUN,      &AodrXilunFrom,      &AodrXilunSpot },
            { SPELL_AODR_SUMMON_NEERALAK,   NPC_NEERALAK,   &AodrNeeralakFrom,   &AodrNeeralakSpot },
            { SPELL_AODR_SUMMON_THORGIZOG,  NPC_THORGIZOG,  &AodrThorgizogFrom,  &AodrThorgizogSpot },
        };

        for (Member const& member : members)
        {
            player->CastSpell(player, member.spell, true);
            Track(player, member.entry);
            if (Creature* actor = Actor(member.entry))
            {
                float z = actor->GetMap()->GetHeight(actor->GetPhaseMask(), member.from->GetPositionX(), member.from->GetPositionY(),
                    member.from->GetPositionZ() + 5.0f, true, 20.0f);
                if (z <= INVALID_HEIGHT)
                    z = member.from->GetPositionZ();
                actor->NearTeleportTo(member.from->GetPositionX(), member.from->GetPositionY(), z,
                    actor->GetAngle(member.spot->GetPositionX(), member.spot->GetPositionY()));
                actor->SetWalk(true);
                actor->GetMotionMaster()->MovePoint(POINT_ACTOR_WALK, *member.spot);
                if (member.entry == NPC_NEERALAK)
                    actor->CastSpell(actor, SPELL_SMOKING_NEERALAK, true);
            }
            else
                TC_LOG_ERROR("scripts", "npc_bs_aodr_camera: spell %u summoned no %u for %s", member.spell, member.entry,
                    player->GetName().c_str());
        }

        // The view is on Xi'lun from the moment the camera stops
        Aim(Actor(NPC_XILUN));
    }

    void StartCouncil()
    {
        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player)
            return;

        if (!_councilCalled)
            CallCouncil(player);

        Aim(Actor(NPC_XILUN));
        ChangeRiderSeat(player, SEAT_CAMERA_AIMED);

        _events.ScheduleEvent(EVENT_COUNCIL_BUTT, 1500ms);
        _events.ScheduleEvent(EVENT_COUNCIL_STOMACH, 7s);
        _events.ScheduleEvent(EVENT_COUNCIL_SERGEANTS_Q, 12500ms);
        _events.ScheduleEvent(EVENT_COUNCIL_SERGEANTS_A, 17s);
        _events.ScheduleEvent(EVENT_COUNCIL_BLACK_AND_SMOKY, 24s);
        _events.ScheduleEvent(EVENT_COUNCIL_IMPS, 29s);
        _events.ScheduleEvent(EVENT_COUNCIL_FLAMEKIN, 35s);
        _events.ScheduleEvent(EVENT_COUNCIL_WARLOCK_CRAP, 40500ms);
        _events.ScheduleEvent(EVENT_COUNCIL_FRONT_LINES, 45500ms);
        _events.ScheduleEvent(EVENT_COUNCIL_BEHOLD, 51500ms);
        _events.ScheduleEvent(EVENT_RITUAL_TO_THE_LEDGE, 56s);
        _events.ScheduleEvent(EVENT_RITUAL_THUMB_WAR, 59s);
        _events.ScheduleEvent(EVENT_RITUAL_PIT_LORD, 62500ms);
        _events.ScheduleEvent(EVENT_RITUAL_ROAR, 64s);
        _events.ScheduleEvent(EVENT_RITUAL_ORB, 66s);
        _events.ScheduleEvent(EVENT_RAMPAGE, 68s);
        _events.ScheduleEvent(EVENT_BACK_TO_THE_LEDGE, 76s);
        _events.ScheduleEvent(EVENT_RETREAT, 80s);
        _events.ScheduleEvent(EVENT_CAMERA_END, 83500ms);
    }

    // The speaker talks to whom he turns to (0: as he stands)
    void Say(uint32 speakerEntry, uint8 group, Player* player, uint32 toEntry)
    {
        Creature* speaker = Actor(speakerEntry);
        if (!speaker)
            return;

        if (toEntry)
            if (Creature* to = Actor(toEntry))
                speaker->SetFacingToObject(to);
        speaker->AI()->Talk(group, player);
    }

    // The pit lord swings into the ranks (shared 48414 spawns in phase 341, seen only in the cutscene): the nearest ones fall,
    // the others run (ours: cosmetic deaths by Unit::Kill - a wild summon of no owner gives nobody credit or experience - and an
    // 8 s flight, after which they wander again)
    void Rampage()
    {
        Creature* pitLord = Actor(NPC_HELLMONDATH);
        if (!pitLord)
            return;

        pitLord->HandleEmoteCommand(urand(0, 1) ? EMOTE_ONESHOT_ATTACK1H : EMOTE_ONESHOT_ATTACK2HTIGHT);

        std::list<Creature*> ranks;
        pitLord->GetCreatureListWithEntryInGrid(ranks, NPC_BLACKROCK_RANKS, AodrRampageScatterYd);
        for (Creature* invader : ranks)
        {
            if (!invader->IsAlive() || invader->IsSummon())
                continue;

            if (_killed < AodrRampageKillCap && pitLord->GetExactDist2d(invader) <= AodrRampageKillYd)
            {
                ++_killed;
                pitLord->Kill(invader, false);
            }
            else if (!invader->HasUnitState(UNIT_STATE_FLEEING))
            {
                invader->SetEmoteState(EMOTE_ONESHOT_NONE);
                invader->GetMotionMaster()->MoveFleeing(pitLord, 8 * IN_MILLISECONDS);
            }
        }
    }

    // CameraMode 119 looks at the camera's channel object; no channel spell, so no beam is drawn (Badlands, Rheastrasza's Gift)
    void Aim(Unit* target)
    {
        if (target)
            me->SetGuidValue(UNIT_FIELD_CHANNEL_OBJECT, target->GetGUID());
    }

    // Unit::ChangeSeat takes the passenger off and seats him again within the call: no exit
    void ChangeRiderSeat(Player* player, int8 seatId)
    {
        if (player->GetVehicleBase() != me)
            return;

        _changingSeat = true;
        player->ChangeSeat(seatId);
        _changingSeat = false;
        player->RemoveAurasDueToSpell(VEHICLE_SPELL_PARACHUTE);
    }

    // Flies the camera from where it is along one smooth curve through the corners at an even pace (scripted-quest-scenes,
    // FlyCurve: a clamped uniform cubic B-spline sampled every `step` yards); a fly spline is sent uncompressed (no +-256 yd
    // packing, C20). MovementInform POINT_CAMERA_PATH at its end
    void Fly(Position const* first, Position const* last, float speedYd, float step = 4.0f)
    {
        if (speedYd > 0.0f)
        {
            me->SetSpeed(MOVE_RUN, speedYd / 7.0f);
            me->SetSpeed(MOVE_FLIGHT, speedYd / 7.0f);
        }

        Position const here = me->GetPosition();
        std::vector<Position> controls(3, here);
        controls.insert(controls.end(), first, last);
        Position const end = controls.back();
        controls.push_back(end);
        controls.push_back(end);

        uint32 const subSteps = 16;
        std::vector<Position> dense(1, here);
        for (size_t i = 0; i + 3 < controls.size(); ++i)
        {
            Position const& c0 = controls[i];
            Position const& c1 = controls[i + 1];
            Position const& c2 = controls[i + 2];
            Position const& c3 = controls[i + 3];
            for (uint32 k = 1; k <= subSteps; ++k)
            {
                float t = float(k) / subSteps;
                float b0 = (1.0f - t) * (1.0f - t) * (1.0f - t) / 6.0f;
                float b1 = (3.0f * t * t * t - 6.0f * t * t + 4.0f) / 6.0f;
                float b2 = (-3.0f * t * t * t + 3.0f * t * t + 3.0f * t + 1.0f) / 6.0f;
                float b3 = t * t * t / 6.0f;
                dense.emplace_back(
                    b0 * c0.GetPositionX() + b1 * c1.GetPositionX() + b2 * c2.GetPositionX() + b3 * c3.GetPositionX(),
                    b0 * c0.GetPositionY() + b1 * c1.GetPositionY() + b2 * c2.GetPositionY() + b3 * c3.GetPositionY(),
                    b0 * c0.GetPositionZ() + b1 * c1.GetPositionZ() + b2 * c2.GetPositionZ() + b3 * c3.GetPositionZ());
            }
        }

        float length = 0.0f;
        for (size_t i = 0; i + 1 < dense.size(); ++i)
            length += dense[i].GetExactDist(dense[i + 1]);

        size_t const count = std::max<size_t>(1, size_t(std::lround(length / step)));
        float const spacing = length / count;

        std::vector<Position> path(1, here);
        float walked = 0.0f;
        float next = spacing;
        for (size_t i = 0; i + 1 < dense.size(); ++i)
        {
            Position const& a = dense[i];
            Position const& b = dense[i + 1];
            float segment = a.GetExactDist(b);
            while (segment > 0.0f && walked + segment >= next && path.size() < count)
            {
                float f = (next - walked) / segment;
                path.emplace_back(a.GetPositionX() + (b.GetPositionX() - a.GetPositionX()) * f,
                    a.GetPositionY() + (b.GetPositionY() - a.GetPositionY()) * f,
                    a.GetPositionZ() + (b.GetPositionZ() - a.GetPositionZ()) * f);
                next += spacing;
            }
            walked += segment;
        }
        path.push_back(end);

        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveSmoothPath(POINT_CAMERA_PATH, path.data(), path.size(), false, true);
    }

    void Track(Player* player, uint32 entry)
    {
        if (Creature* actor = FindAodrSummonOf(player, entry))
            _actors[entry] = actor->GetGUID();
    }

    Creature* Actor(uint32 entry)
    {
        auto itr = _actors.find(entry);
        if (itr == _actors.end())
            return nullptr;

        Creature* actor = ObjectAccessor::GetCreature(*me, itr->second);
        return actor && actor->IsAlive() ? actor : nullptr;
    }

    // Ends the cutscene once. toBattle: the scene's end or a skip - the dragon (GoToBattle); the actors stay for the reveal's last
    // lines (the dragon's script ends them). Otherwise the actors go, and a living player still here who has dropped the quest is
    // sent back to the camp
    void End(Player* player, bool toBattle)
    {
        if (_done)
            return;
        _done = true;
        _events.Reset();
        me->SetGuidValue(UNIT_FIELD_CHANNEL_OBJECT, ObjectGuid::Empty);

        if (player && _riderHidden)
            player->SetVisible(true);
        _riderHidden = false;

        if (!player)
        {
            for (auto const& actor : _actors)
                if (Creature* creature = ObjectAccessor::GetCreature(*me, actor.second))
                    creature->DespawnOrUnsummon();
            me->DespawnOrUnsummon(500);
            return;
        }

        if (toBattle && !HoldsAssault(player))
            toBattle = false;

        if (!toBattle)
            DespawnAodrActorsOf(player);

        if (player->GetVehicleBase() == me)
            player->ExitVehicle();

        if (toBattle)
            GoToBattle(player);
        else if (player->IsAlive() && player->IsInWorld() && !player->GetSession()->PlayerLogout() && !player->IsBeingTeleportedFar())
            SendBackToCamp(player);
        else
            player->RemoveAurasDueToSpell(SPELL_AODR_SUMMON_CAMERA_PHASE);

        me->DespawnOrUnsummon(500);
    }

    EventMap _events;
    ObjectGuid _playerGUID;
    Position _summonerSpot;
    std::map<uint32, ObjectGuid> _actors;
    uint8 _boardTries;
    uint32 _killed;
    bool _started;
    bool _done;
    bool _changingSeat;
    bool _noScene;
    bool _councilCalled;
    bool _councilStarted = false;
    bool _riderHidden = false;
};

// 48434 - Obsidian-Cloaked Dragon (vehicle 1327), from the cutscene's end (90069) or the Horn of the Callers (90079)
// The rider flies it freely (seat 9106: CAN_CONTROL, CAN_CAST; user question Q2, default free flight with a leash) and breathes
// Fiery Breath (spell1 90067: a missile at the aimed point, 90068 on Blackrock Invaders 48432 within 15 yd: condition 13).
// Flight: 90071 (FLY, knockback immunity, vehicle flight speed +240 %) is put on again once the rider controls it, so that the
// controlling client gets CAN_FLY and pitching (Unit::SetCanFly sends ALWAYS_ALLOW_PITCHING only to a client-moved unit); the Fly
// animation tier (C45). Seat 9107 stays empty (Q3).
// Leash: outside the battle area the rider is told "Return to Dreadmaul Rock, or you will be dropped!" once; 10 s later, still
// outside, he is put off and taken back to his camp (93901 -> 93898 / 93900). So is a rider who leaves it higher than 10 yd above
// the ground (Leave button, the quest abandoned), instead of a 100-yd fall; one who lands and steps off stays where he is
// (comments 2010-11-28 [+17], 2013-11-30 [+4]: fly back to the camp and dismount). The dragon is his Minion: it goes 1 ms after
// he leaves it (Unit::_ExitVehicle), and with him at a logout.
// After the cutscene (summoned by 90069) it also plays the reveal's end: he laughs (wiki), Thorg'izog's "run toward those
// dragons" and Neeralak's "I never called any dragons...", then "The Blackrock forces are panicking!  Strike at them now!"; the
// actors go 25 s after the reveal (Hellmondath at 12 s). Ours: the timings, the laugh as the player's emote, Thorg'izog's point
struct npc_bs_obsidian_cloaked_dragon : public VehicleAI
{
    npc_bs_obsidian_cloaked_dragon(Creature* creature) : VehicleAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner ? summoner->ToPlayer() : nullptr;
        if (!player)
        {
            me->DespawnOrUnsummon();
            return;
        }

        _playerGUID = player->GetGUID();
        _fromCutscene = me->GetUInt32Value(UNIT_FIELD_CREATED_BY_SPELL) == SPELL_AODR_SUMMON_DRAGON;
        me->SetReactState(REACT_PASSIVE);
        // 90069's dragon appears 100 yd above the ground: held in the air with the Fly animation (C45) until he is seated
        me->SetFlying(true);
        me->CastSpell(me, SPELL_OBSIDIAN_CLOAKED_DRAGON_FLIGHT, true);

        // The summon seats him at once (vehicle summon); should that not have happened, the dragon goes
        _events.ScheduleEvent(EVENT_DRAGON_NO_RIDER, 2s);
    }

    void PassengerBoarded(Unit* passenger, int8 seatId, bool apply) override
    {
        if (_changingSeat || passenger->GetGUID() != _playerGUID)
            return;

        Player* player = passenger->ToPlayer();
        if (!player)
            return;

        if (apply)
        {
            if (seatId != SEAT_DRAGON_CONTROL)
            {
                _changingSeat = true;
                player->ChangeSeat(SEAT_DRAGON_CONTROL);
                _changingSeat = false;
            }

            _seated = true;
            _events.CancelEvent(EVENT_DRAGON_NO_RIDER);
            _events.ScheduleEvent(EVENT_DRAGON_CHECK, 1s);

            // Not in the cutscene's phase (the summon copied it; 90069 then ends it on the player)
            me->SetPhased(341, true, false);

            // The flight for the controlling client (see above). Gravity off first: taking 90071 off a unit with gravity would
            // start a fall (AuraEffect::HandleAuraAllowFlight -> MoveFall) under the rider
            me->SetFlying(true);
            me->RemoveAurasDueToSpell(SPELL_OBSIDIAN_CLOAKED_DRAGON_FLIGHT);
            me->CastSpell(me, SPELL_OBSIDIAN_CLOAKED_DRAGON_FLIGHT, true);
            me->SetAlwaysAllowPitching(true);

            if (_fromCutscene && !_revealStarted)
            {
                _revealStarted = true;
                _events.ScheduleEvent(EVENT_REVEAL_LAUGH, 1500ms);
                _events.ScheduleEvent(EVENT_REVEAL_TO_THE_DRAGONS, 2s);
                _events.ScheduleEvent(EVENT_REVEAL_NO_DRAGONS, 6500ms);
                _events.ScheduleEvent(EVENT_REVEAL_PANICKING, 9s);
                _events.ScheduleEvent(EVENT_REVEAL_PIT_LORD_GONE, 12s);
                _events.ScheduleEvent(EVENT_REVEAL_END, 25s);
            }
            return;
        }

        if (!_seated)
            return;
        _seated = false;
        _events.Reset();

        // The reveal's actors go with the dragon
        if (_revealStarted && !_revealDone)
        {
            _revealDone = true;
            DespawnAodrActorsOf(player);
        }

        if (!player->IsInWorld() || player->GetSession()->PlayerLogout() || !player->IsAlive() || player->IsBeingTeleported())
            return;

        float const ground = me->GetMap()->GetHeight(me->GetPhaseMask(), me->GetPositionX(), me->GetPositionY(), me->GetPositionZ(), true, 500.0f);
        if (ground <= INVALID_HEIGHT || me->GetPositionZ() - ground > AodrMidAirYd)
            SendBackToCamp(player);
    }

    void UpdateAI(uint32 diff) override
    {
        VehicleAI::UpdateAI(diff);

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
            if (!player || !player->IsInWorld())
                return;

            switch (eventId)
            {
                case EVENT_DRAGON_NO_RIDER:
                    if (!_seated)
                        me->DespawnOrUnsummon();
                    return;
                case EVENT_DRAGON_CHECK:
                    if (!Check(player))
                        return;
                    _events.ScheduleEvent(EVENT_DRAGON_CHECK, 1s);
                    break;
                case EVENT_REVEAL_LAUGH:
                    player->HandleEmoteCommand(EMOTE_ONESHOT_LAUGH);
                    break;
                case EVENT_REVEAL_TO_THE_DRAGONS:
                    if (Creature* thorgizog = FindAodrSummonOf(player, NPC_THORGIZOG))
                    {
                        thorgizog->HandleEmoteCommand(EMOTE_ONESHOT_POINT);
                        thorgizog->AI()->Talk(TALK_THORGIZOG_DRAGONS, player);
                    }
                    break;
                case EVENT_REVEAL_NO_DRAGONS:
                    if (Creature* neeralak = FindAodrSummonOf(player, NPC_NEERALAK))
                        neeralak->AI()->Talk(TALK_NEERALAK_NO_DRAGONS, player);
                    break;
                case EVENT_REVEAL_PANICKING:
                    Talk(TALK_DRAGON_PANICKING, player);
                    break;
                case EVENT_REVEAL_PIT_LORD_GONE:
                    if (Creature* pitLord = FindAodrSummonOf(player, NPC_HELLMONDATH))
                        pitLord->DespawnOrUnsummon();
                    break;
                case EVENT_REVEAL_END:
                    _revealDone = true;
                    DespawnAodrActorsOf(player);
                    break;
                default:
                    break;
            }
        }
    }

private:
    // Once a second while he rides: the quest dropped (abandoned) puts him off; the leash
    bool Check(Player* player)
    {
        if (player->GetVehicleBase() != me)
            return false;

        if (!HoldsAssault(player))
        {
            player->ExitVehicle();
            return false;
        }

        if (InAodrBattleArea(me->GetAreaId()))
        {
            _warned = false;
            _outsideMs = 0;
            return true;
        }

        if (!_warned)
        {
            _warned = true;
            _outsideMs = 0;
            Talk(TALK_DRAGON_RETURN, player);
            return true;
        }

        _outsideMs += 1 * IN_MILLISECONDS;
        if (_outsideMs >= AodrLeashWarnMs)
        {
            player->ExitVehicle();
            return false;
        }
        return true;
    }

    EventMap _events;
    ObjectGuid _playerGUID;
    uint32 _outsideMs = 0;
    bool _fromCutscene = false;
    bool _seated = false;
    bool _changingSeat = false;
    bool _warned = false;
    bool _revealStarted = false;
    bool _revealDone = false;
};

// 93901 - AODR: Teleport Back Master. Its two dummy effects carry the two teleports (effect 0: 93900 to Flame Crest, effect 1:
// 93898 to Morgan's Vigil); the player gets his own side's
class spell_bs_aodr_teleport_back_master : public SpellScript
{
    PrepareSpellScript(spell_bs_aodr_teleport_back_master);

    void HandleDummy(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
        Player* player = GetHitPlayer();
        if (!player)
            return;

        bool const horde = player->GetTeam() == HORDE;
        if ((effIndex == EFFECT_0) == horde)
            player->CastSpell(player, horde ? SPELL_AODR_TELEPORT_TO_FLAME_CREST : SPELL_AODR_TELEPORT_TO_MORGANS_VIGIL, true);
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_bs_aodr_teleport_back_master::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        OnEffectHitTarget += SpellEffectFn(spell_bs_aodr_teleport_back_master::HandleDummy, EFFECT_1, SPELL_EFFECT_DUMMY);
    }
};

// A player saved in the air during the Assault (in the camera, or on the dragon: both are gone at the logout) logs in above Burning
// Steppes and would fall; with the quest held and more than 10 yd above the ground he is set down at his camp (ours). Not one on
// a flying mount of his own (saved with him)
class player_bs_aodr_login : public PlayerScript
{
public:
    player_bs_aodr_login() : PlayerScript("player_bs_aodr_login") { }

    void OnLogin(Player* player) override
    {
        if (player->GetVehicle())
            return;

        player->RemoveAurasDueToSpell(SPELL_AODR_SUMMON_CAMERA_PHASE);

        if (player->GetMapId() != MAP_EASTERN_KINGDOMS || player->GetZoneId() != ZONE_BURNING_STEPPES || !player->IsAlive()
            || !HoldsAssault(player) || player->IsMounted() || player->HasAuraType(SPELL_AURA_FLY)
            || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
            return;

        float const ground = player->GetMap()->GetHeight(player->GetPhaseMask(), player->GetPositionX(), player->GetPositionY(),
            player->GetPositionZ(), true, 500.0f);
        if (ground > INVALID_HEIGHT && player->GetPositionZ() - ground <= AodrMidAirYd)
            return;

        Position const& camp = player->GetTeam() == HORDE ? AodrFlameCrest : AodrMorgansVigil;
        player->NearTeleportTo(camp.GetPositionX(), camp.GetPositionY(), camp.GetPositionZ(), camp.GetOrientation());
    }
};

void AddSC_burning_steppes_assault()
{
    new creature_script<npc_bs_aodr_actor>("npc_bs_aodr_actor");
    new creature_script<npc_bs_aodr_camera>("npc_bs_aodr_camera");
    new creature_script<npc_bs_obsidian_cloaked_dragon>("npc_bs_obsidian_cloaked_dragon");
    new spell_script<spell_bs_aodr_teleport_back_master>("spell_bs_aodr_teleport_back_master");
    new player_bs_aodr_login();
}
