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
SDName: Badlands, the Scar of the Worldbreaker: The Day that Deathwing Came
SDComment: Quest support: 27713 The Day that Deathwing Came, 27714 ... The Real Story, 27715 ... What Really Happened
SDCategory: Badlands
EndScriptData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "CombatAI.h"
#include "ScriptedGossip.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "SpellScript.h"
#include "SpellAuras.h"
#include "SpellInfo.h"
#include "CreatureTextMgr.h"
#include "TemporarySummon.h"
#include "Vehicle.h"
#include "MotionMaster.h"
#include "GameObject.h"
#include "Group.h"
#include "WorldSession.h"

/*######
## The three stories told at the campfire in the Scar of the Worldbreaker
##
## Each quest is the teller's story, played by the player inside it (the 5.4.8 DBC holds the skeleton of each: a start spell that
## puts the player in the story's phase, summons the teller as a vehicle at the camp and sets the sky; two camera seats and a
## control seat; the story's actors and spells). Nothing of it was built and no TDB has a script; what follows is built from the
## DBC id blocks, the broadcast texts, the wiki's transcripts and the Wowhead comments (research/badlands/dossiers/deathwing-stories.md).
##
## Common to the three (ours where not said otherwise):
##  - accepting the quest from its teller starts the story, for a real player only (a playerbot never drives a vehicle: R4); a
##    shared quest starts nothing, "Tell me that story again, <name>." (sourced texts 46593 / 47169 / 47242) starts it while the
##    quest is in progress;
##  - the start spell seats the player in the teller's first camera seat (Sky), the vehicle moves him to the second (Ground) and
##    then to the control seat, narrating between (boss whispers to the player, the teller's yells personal);
##  - the seats have CAN_ENTER_OR_EXIT (VehicleSeat 8748 ... 8764 flags 0x02000000), so the vehicle bar's Leave button is the
##    story's Eject button: getting off ends the story early with the credits earned so far;
##  - every end (the story's end, Leave, the vehicle's death, the player's death, abandoning the quest, leaving the Badlands)
##    takes the story's auras off the player (phase, sky, weather, quest-invisibility detection) and, if alive, sets him down at
##    the camp in front of the teller; a logout takes the vehicle with the player's summons (the auras are not saved: the start
##    spells are DONT_SAVE, and player_badlands_stories strips them at login anyway);
##  - at the last credit of a real player's story, every playerbot of his group holding the quest within 100 yd of the teller or
##    of that player gets all of the quest's objectives (R4 as amended by the user: bots only; another real player plays it).
######*/

enum BadlandsStories
{
    QUEST_TDDC_THELDURIN                = 27713,
    QUEST_TDDC_LUCIEN                   = 27714,
    QUEST_TDDC_MARTEK                   = 27715,

    NPC_THELDURIN_THE_LOST              = 2785,
    NPC_LUCIEN_TOSSELWRENCH             = 2920,
    NPC_MARTEK_THE_EXILED               = 4618,

    NPC_THELDURIN_VEHICLE               = 46466,    // vehicle 1187
    NPC_LUCIEN_VEHICLE                  = 47080,    // vehicle 1239
    NPC_MARTEKS_HOG                     = 46501,    // vehicle 1191

    MENU_THELDURIN                      = 12131,
    MENU_LUCIEN                         = 12202,
    MENU_MARTEK                         = 12209,

    // Start spells: PHASE (293 / 295 / 310), SUMMON of the vehicle (SummonProperties 161, category vehicle) at the camp, and the
    // sky (SCREEN_EFFECT 774 / 775) or the blood rain (FORCE_WEATHER)
    SPELL_TDDC1_SUMMON_THELDURIN        = 86557,
    SPELL_TDDC2_SUMMON_LUCIEN           = 87737,
    SPELL_TDDC3_SUMMON_MARTEKS_HOG      = 86675,

    PHASE_TDDC1                         = 293,
    PHASE_TDDC2                         = 295,
    PHASE_TDDC3                         = 310,

    // Other auras a story puts on the player
    SPELL_SEE_QUEST_INVIS_1             = 86637,    // detection of the elementals' invisibility type 7 (TDDC 1)
    SPELL_SEE_QUEST_INVIS_1_VEHICLE     = 87785,    // its vehicle form (target 105, not implemented here: 86637 is cast on the vehicle)
    SPELL_TDDC2_WEATHER                 = 86723,
    SPELL_TDDC2_SUMMON_THE_SUN          = 87790,
    SPELL_TDDC2_SUNNY_WEATHER           = 87788,

    // Seats of the three vehicles (Vehicle.dbc 1187 / 1239 / 1191)
    SEAT_CAMERA_SKY                     = 0,        // CameraMode 80 "TDDC Camera 1 (Sky)": a fixed shot from the camp, north-east and up
    SEAT_CAMERA_GROUND                  = 1,        // CameraMode 81 / 100 / 101: from the camp, looking at the teller (the vehicle)
    SEAT_CONTROL                        = 2,        // CAN_CONTROL | CAN_CAST, hides the player

    ZONE_BADLANDS                       = 3,
    MAP_EASTERN_KINGDOMS                = 0,

    // Turn-in lines (sourced: wiki, broadcast texts)
    SAY_LUCIEN_TELLING_IT_WRONG         = 0,        // 2920: No, no, no, Theldurin.  You're telling the story wrong! (46594)
    SAY_THELDURIN_STOP_DRINKING         = 0,        // 2785: Wow, Lucien.  You need to stop drinking RIGHT NOW. (47178)
    SAY_THELDURIN_SORRY_MARTEK          = 1,        // 2785: Sorry about the interruption, Martek. ... Next drink's on me. (47255)

    EVENT_STORY_WAIT_FOR_RIDER          = 1,
    EVENT_STORY_CHECK                   = 2,
    EVENT_STORY_END                     = 3,
    EVENT_STORY_BEGIN                   = 4,
    EVENT_STORY_FIRST_SCENE_EVENT       = 10,

    ACTION_TDDC_FIST                    = 1,        // 86561 cast from Theldurin's bar
    ACTION_TDDC_GROW                    = 2,        // 87743 cast from Lucien's bar
    ACTION_TDDC_CLOUD_SEARCHED          = 3,        // 87777 hit a cloud
    ACTION_TDDC_SUN_CLICKED             = 4,        // the player clicked The Sun 206550

    DATA_TDDC_ADMIRER                   = 1         // SetGUID: the admirer the player picked
};

struct StoryCredit
{
    uint32 Entry;
    uint32 Count;
};

struct StoryInfo
{
    uint32 Quest;
    uint32 Teller;
    uint32 Menu;
    uint32 StartSpell;
    uint32 Vehicle;
    uint32 Phase;
    Position TellerPos;             // the teller's spawn at the camp (161561 / 161562 / 161560)
    Position ReturnPos;             // where the story leaves the player: the vehicle's summon point (spell_target_position)
    StoryCredit Credits[4];
    uint8 CreditCount;
};

StoryInfo const Stories[] =
{
    { QUEST_TDDC_THELDURIN, NPC_THELDURIN_THE_LOST, MENU_THELDURIN, SPELL_TDDC1_SUMMON_THELDURIN, NPC_THELDURIN_VEHICLE, PHASE_TDDC1,
        { -7128.51f, -2706.85f, 250.221f, 4.06662f }, { -7126.47f, -2713.70f, 249.459f },
        { { 46467, 5 }, { 46471, 1 } }, 2 },
    { QUEST_TDDC_LUCIEN, NPC_LUCIEN_TOSSELWRENCH, MENU_LUCIEN, SPELL_TDDC2_SUMMON_LUCIEN, NPC_LUCIEN_VEHICLE, PHASE_TDDC2,
        { -7133.60f, -2709.05f, 250.160f, 5.75959f }, { -7126.47f, -2713.70f, 249.459f },
        { { 47080, 1 }, { 47097, 5 }, { 47103, 1 } }, 3 },
    { QUEST_TDDC_MARTEK, NPC_MARTEK_THE_EXILED, MENU_MARTEK, SPELL_TDDC3_SUMMON_MARTEKS_HOG, NPC_MARTEKS_HOG, PHASE_TDDC3,
        { -7131.81f, -2706.22f, 250.221f, 5.39307f }, { -7130.30f, -2710.17f, 250.099f },
        { { 47123, 1 }, { 47178, 1 }, { 47179, 1 }, { 46471, 1 } }, 4 },
};

// Everything a story may have put on the player
uint32 const StoryPlayerAuras[] =
{
    SPELL_TDDC1_SUMMON_THELDURIN, SPELL_TDDC2_SUMMON_LUCIEN, SPELL_TDDC3_SUMMON_MARTEKS_HOG, SPELL_SEE_QUEST_INVIS_1,
    SPELL_SEE_QUEST_INVIS_1_VEHICLE, SPELL_TDDC2_WEATHER, SPELL_TDDC2_SUMMON_THE_SUN, SPELL_TDDC2_SUNNY_WEATHER
};

// R4 as amended for the stories: group bots within this distance of the teller or of the player get the story's credits
float const StoryGroupCreditRange = 100.0f;
// Moved farther than this from where the vehicle let him go, by the set-down: he was teleported or summoned, and stays there
float const StoryTeleportedAway = 30.0f;
// The login set-down only looks this far from Martek's camp
float const StoryLoginReach = 800.0f;

static StoryInfo const* GetStoryByQuest(uint32 questId)
{
    for (StoryInfo const& story : Stories)
        if (story.Quest == questId)
            return &story;
    return nullptr;
}

static StoryInfo const* GetStoryByMenu(uint32 menuId)
{
    for (StoryInfo const& story : Stories)
        if (story.Menu == menuId)
            return &story;
    return nullptr;
}

static bool IsStoryVehicle(uint32 entry)
{
    for (StoryInfo const& story : Stories)
        if (story.Vehicle == entry)
            return true;
    return false;
}

static void StripStoryAuras(Player* player)
{
    for (uint32 spell : StoryPlayerAuras)
        player->RemoveAurasDueToSpell(spell);
}

// A story vehicle of this player's still in the world (the one he rides, or one that has not seated him yet)
static Creature* FindStoryVehicleOf(Player* player)
{
    if (Unit* base = player->GetVehicleBase())
        if (base->GetTypeId() == TYPEID_UNIT && IsStoryVehicle(base->GetEntry()))
            return base->ToCreature();

    std::list<Creature*> vehicles;
    for (StoryInfo const& story : Stories)
        player->GetCreatureListWithEntryInGridAppend(vehicles, story.Vehicle, 50.0f);
    for (Creature* vehicle : vehicles)
        if (vehicle->IsAlive() && !vehicle->IsDestroyedObject() && vehicle->IsSummon()
            && vehicle->ToTempSummon()->GetSummonerGUID() == player->GetGUID())
            return vehicle;
    return nullptr;
}

// The player's own summon of an entry near him (personal summons are private: closest-creature searches skip them)
static Creature* FindOwnSummon(Player* player, uint32 entry, float range = 60.0f)
{
    std::list<Creature*> creatures;
    player->GetCreatureListWithEntryInGrid(creatures, entry, range);
    for (Creature* creature : creatures)
        if (creature->IsAlive() && !creature->IsDestroyedObject() && creature->IsSummon()
            && creature->ToTempSummon()->GetSummonerGUID() == player->GetGUID())
            return creature;
    return nullptr;
}

// At the last credit of a real player's story: every playerbot of his group holding the quest in progress within 100 yd of the teller at
// the camp or of the player gets all of its objectives. Bots follow their leader down the trench or across the zone, so the
// leader's position counts as well as the camp's (stories S6, R4 as amended)
static void CreditStoryGroup(Player* leader, StoryInfo const& story)
{
    Group* group = leader->GetGroup();
    if (!group)
        return;

    for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
    {
        Player* member = ref->GetSource();
        // Bots only: a second real player plays the story himself (R4 as amended by the user, 2026-11-15)
        if (!member || member == leader || !member->IsInWorld() || !member->IsInMap(leader) || !member->GetSession()->IsBot())
            continue;
        if (member->GetQuestStatus(story.Quest) != QUEST_STATUS_INCOMPLETE)
            continue;
        if (member->GetExactDist(&story.TellerPos) > StoryGroupCreditRange && member->GetExactDist(leader) > StoryGroupCreditRange)
            continue;

        for (uint8 i = 0; i < story.CreditCount; ++i)
            for (uint32 n = 0; n < story.Credits[i].Count; ++n)
                member->KilledMonsterCredit(story.Credits[i].Entry);
    }
}

class npc_badlands_story_vehicle;

// Lets the player out where he is and, 300 ms later, takes the story's auras off and (alive) sets him down at the camp in front
// of the teller. The client plays the exit's jump only if no teleport comes in the same tick (scripted-quest-scenes: Finish), so
// the teleport waits; until then a living player hovers where the vehicle let him go (no root: a root sends a stop spline that
// cuts the exit off) - Martek's hog may be in the air. A player who is being teleported elsewhere (a far teleport takes him off
// the vehicle first) or is no longer on this map is only stripped
static void SetDownAtCamp(Player* player, StoryInfo const* story, Unit* vehicle)
{
    // The elementals' detection goes at once: in the 300 ms before the set-down the player stands where the vehicle let him go,
    // and this core lets type-7 invisible units see only those who detect them
    player->RemoveAurasDueToSpell(SPELL_SEE_QUEST_INVIS_1);
    player->RemoveAurasDueToSpell(SPELL_SEE_QUEST_INVIS_1_VEHICLE);

    bool const seated = vehicle && player->GetVehicleBase() == vehicle;
    bool const hover = seated && player->IsAlive();
    if (seated)
    {
        player->ExitVehicle();
        if (hover)
            player->SetDisableGravity(true);
    }

    // A teleport or a summon that took him off the vehicle (Player::TeleportTo exits first) is left alone: by the set-down he is
    // either still being teleported or already somewhere else than where the vehicle let him go
    Position const leftAt = player->GetPosition();

    player->m_Events.AddLambdaEventAtOffset([player, story, hover, leftAt]()
    {
        if (!player->IsInWorld())
            return;

        StripStoryAuras(player);

        if (player->IsAlive() && !player->GetVehicle() && !player->IsBeingTeleported() && player->GetMapId() == MAP_EASTERN_KINGDOMS
            && player->GetExactDist(&leftAt) <= StoryTeleportedAway)
        {
            Position const& dest = story->ReturnPos;
            float const facing = dest.GetAngle(story->TellerPos.GetPositionX(), story->TellerPos.GetPositionY());
            player->NearTeleportTo(dest.GetPositionX(), dest.GetPositionY(), dest.GetPositionZ(), facing);
        }

        // Gravity back once set down, sent twice: the player's own movement packets replace the server's flags, so an enable
        // sent before the client took the hold would leave it hovering (see npc_hillsbrad_scene_camera::Finish)
        if (hover)
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

static bool StartStory(Player* player, StoryInfo const& story);

/*######
## The story vehicles (common part)
## Theldurin 46466, Lucien 47080, Martek's Hog 46501: summoned by the start spell at the camp with the player in seat 0.
## Seat 2 has CAN_CONTROL: seating the player there charms the vehicle, and a ScriptedAI would be switched off for PossessedAI
## (Unit::UpdateCharmAI); VehicleAI keeps its AI on (VehicleAIBase::OnCharmed does not ask for the switch), so the story runs on.
## The vehicle is the player's Minion (SummonProperties 161, category vehicle): getting off despawns it (Unit::_ExitVehicle), and
## the player's logout or far teleport unsummons it; nothing of the end may wait on the vehicle.
######*/

class npc_badlands_story_vehicle : public VehicleAI
{
public:
    npc_badlands_story_vehicle(Creature* creature, uint32 questId) : VehicleAI(creature), _story(GetStoryByQuest(questId)) { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner->ToPlayer();
        if (!_story || !player)
        {
            me->DespawnOrUnsummon();
            return;
        }

        _playerGUID = player->GetGUID();

        // "Theldurin's health depends on the player's level (1999 hp at 47, 6141 at 85)" (comment 2012-03-02): the player's level
        // with the template's health modifier 1 and no gear term (stories S1). Creature::SelectLevel takes the level from the
        // template whatever was set before, so it is given a copy of the template with the player's level
        CreatureTemplate scaled = *me->GetCreatureTemplate();
        scaled.minlevel = player->GetLevel();
        scaled.maxlevel = player->GetLevel();
        me->SelectLevel(&scaled);

        // The summon copies the player's phases at the moment of the summon, which is before the start spell's phase aura lands
        // (the destination effects run before the unit effects, Spell::handle_immediate): the vehicle gets the story's phase
        // itself. It keeps the player's default phase 169 until he is seated and has the story's phase (StoryPhaseOnly)
        me->SetPhased(_story->Phase, true, true);
        me->SetReactState(REACT_PASSIVE);

        _events.ScheduleEvent(EVENT_STORY_WAIT_FOR_RIDER, 1s);
        OnSummoned(player);
    }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        if (_changingSeat || passenger->GetGUID() != _playerGUID)
            return;

        if (apply)
        {
            if (!_started && !_done)
            {
                // The first seat is taken inside the start spell's summon effect, before the spell's phase aura lands on the
                // player: the scene starts a moment later, so that what the player summons for it is in the story's phase
                _started = true;
                _events.ScheduleEvent(EVENT_STORY_BEGIN, 500ms);
            }
            return;
        }

        // Leave button (the story's Eject), the player's death, a teleport
        End();
    }

    void JustDied(Unit* /*killer*/) override
    {
        End();
    }

    // Unsummoned by something other than End: the player logged out (the vehicle is one of his summons, Unit::RemoveFromWorld),
    // was teleported far, or the vehicle went for another reason. The actors go; a player still in the world is stripped
    void Unsummoned() override
    {
        if (_done)
            return;

        _done = true;
        _events.Reset();
        DespawnActors();

        if (Player* player = ObjectAccessor::FindPlayer(_playerGUID))
            if (player->IsInWorld() && !player->GetSession()->PlayerLogout())
            {
                ShowRider(player);
                OnEnd(player);
            }

        if (Player* player = ObjectAccessor::FindPlayer(_playerGUID))
            if (player->IsInWorld() && !player->GetSession()->PlayerLogout())
                player->m_Events.AddLambdaEventAtOffset([player]()
                {
                    if (player->IsInWorld() && !player->GetVehicle())
                        StripStoryAuras(player);
                }, 500);
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
            Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
            if (!player || !player->IsInWorld())
            {
                End();
                return;
            }

            switch (eventId)
            {
                case EVENT_STORY_WAIT_FOR_RIDER:
                    if (!_started)
                    {
                        // The start spell seats the player at once; should that not have held, the story is called off
                        TC_LOG_ERROR("scripts", "npc_badlands_story_vehicle: %s was not seated in story vehicle %u; the story is called off",
                            player->GetName().c_str(), me->GetEntry());
                        End();
                        return;
                    }
                    break;
                case EVENT_STORY_BEGIN:
                    StoryPhaseOnly();
                    HideRider(player);
                    _events.ScheduleEvent(EVENT_STORY_CHECK, 500ms);
                    StartScene(player);
                    break;
                case EVENT_STORY_CHECK:
                    if (!CheckStory(player))
                        return;
                    _events.ScheduleEvent(EVENT_STORY_CHECK, 500ms);
                    break;
                case EVENT_STORY_END:
                    End();
                    return;
                default:
                    SceneEvent(eventId, player);
                    break;
            }

            if (_done)
                return;
        }
    }

protected:
    virtual void OnSummoned(Player* /*player*/) { }
    virtual void StartScene(Player* player) = 0;
    virtual void SceneEvent(uint32 /*eventId*/, Player* /*player*/) { }
    virtual void OnCheck(Player* /*player*/) { }
    // At every end of the story, for a player still in the world: what the story left that is not a tracked actor
    virtual void OnEnd(Player* /*player*/) { }
    // The creature that narrates (the vehicle itself; Martek the Awesome on the hog)
    virtual Creature* Narrator() { return me; }
    // Its text group of "Hmm... I didn't go this direction.  I think I'm telling the story wrong." (46595)
    virtual uint8 WrongWayGroup() const = 0;

    Player* GetPlayer() const { return ObjectAccessor::GetPlayer(*me, _playerGUID); }

    void Narrate(uint8 group, Player* player)
    {
        if (Creature* narrator = Narrator())
            sCreatureTextMgr->SendChat(narrator, group, player);
    }

    void Say(uint8 group, Player* player)
    {
        sCreatureTextMgr->SendChat(me, group, player);
    }

    // Moves the player to another seat, whose CameraMode the client then uses. Unit::ChangeSeat takes the passenger off
    // (PassengerBoarded with apply false) and seats him again within the call: that is no exit
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

    // Once the player is seated and in the story's phase, the vehicle keeps the story's phase ONLY. With the default phase 169 the
    // open world's mobs (the trench's 21 Rock Elementals 92, Moltanus) saw and fought Theldurin and Martek's hog, and every
    // passer-by saw the stories' vehicles (WorldObject::IsPhased: a unit without 169 and the phase-0 world do not see each other).
    // The player cannot leave 169 (Player::Update puts it back every tick), but he rides as a hidden, unselectable passenger; the
    // story's actors share the story phase. Not earlier: the player, without the story phase yet, has to see the vehicle to be
    // seated. Phases the player gains later are passed on (Unit::SetPhased); 169 is not, he never loses it
    void StoryPhaseOnly()
    {
        me->ClearPhases(false);
        me->SetPhased(_story->Phase, true, true);
        if (Vehicle* kit = me->GetVehicleKit())
            for (int8 seat = 0; seat < MAX_VEHICLE_SEATS; ++seat)
                if (Unit* passenger = kit->GetPassenger(seat))
                    if (passenger->GetTypeId() == TYPEID_UNIT)
                    {
                        passenger->ClearPhases(false);
                        passenger->SetPhased(_story->Phase, true, true);
                    }
    }

    // The rider is hidden from everyone else the server-side way, as a GM is (Unit::SetVisible; as Rheastrasza's Gift and the
    // Hillsbrad cameras do), from the scene's start to its end. The vehicle is out of the default phase (StoryPhaseOnly) but the
    // player is not: without this the open world's mobs, which do not see the vehicle, saw and fought its rider - on the hog's
    // control seat (VehicleSeat 8764 has no PASSENGER_NOT_SELECTABLE, unlike Theldurin's 8746 and Lucien's 8889) he could be
    // targeted and killed - and passers-by saw a player hanging on a vehicle their client does not know. Not NOT_SELECTABLE or
    // IMMUNE_TO_NPC: neither hides him from passers-by, and the vehicle code clears NOT_SELECTABLE at each seat change. The story
    // needs nobody to see the rider: its mobs attack the vehicle, the cave-in rocks fall on the hog, its credits and lines are
    // given to him directly, and talking to an admirer or clicking the sun asks no visibility of him (Player::GetNPCIfCanInteractWith,
    // HandleGameObjectUseOpcode). Shown again at every end; a logout keeps nothing (the server-side visibility is not saved)
    void HideRider(Player* player)
    {
        if (!player->IsVisible())
            return;

        _riderHidden = true;
        player->SetVisible(false);
    }

    void ShowRider(Player* player)
    {
        if (!_riderHidden)
            return;

        _riderHidden = false;
        player->SetVisible(true);
    }

    bool IsControlling(Player* player) const
    {
        return player->GetVehicleBase() == me && player->GetTransSeat() == SEAT_CONTROL;
    }

    uint32 CreditCount(Player* player, uint32 entry) const
    {
        return player->GetReqKillOrCastCurrentCount(_story->Quest, int32(entry));
    }

    void Credit(Player* player, uint32 entry)
    {
        if (player->GetQuestStatus(_story->Quest) == QUEST_STATUS_INCOMPLETE)
            player->KilledMonsterCredit(entry);
        CheckGroupCredit(player);
    }

    // Once, at the player's last credit (also when the last one was a kill the core gave: the elementals)
    void CheckGroupCredit(Player* player)
    {
        if (_groupCredited || player->GetQuestStatus(_story->Quest) != QUEST_STATUS_COMPLETE)
            return;

        _groupCredited = true;
        CreditStoryGroup(player, *_story);
    }

    void Track(Creature* actor)
    {
        if (actor)
            _actorGUIDs.push_back(actor->GetGUID());
    }

    Creature* GetActor(ObjectGuid const& guid) const
    {
        return guid.IsEmpty() ? nullptr : ObjectAccessor::GetCreature(*me, guid);
    }

    void DespawnActors()
    {
        for (ObjectGuid const& guid : _actorGUIDs)
            if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                actor->DespawnOrUnsummon(100);
        _actorGUIDs.clear();
    }

    // Ends the story once, whatever ended it. Credits already earned stay
    void End()
    {
        if (_done)
            return;

        _done = true;
        _events.Reset();
        DespawnActors();

        Player* player = GetPlayer();
        if (player && player->IsInWorld() && !player->GetSession()->PlayerLogout())
        {
            ShowRider(player);
            OnEnd(player);
            SetDownAtCamp(player, _story, me);
        }

        me->DespawnOrUnsummon(500);
    }

    void EndIn(Milliseconds delay)
    {
        _events.ScheduleEvent(EVENT_STORY_END, delay);
    }

    StoryInfo const* _story;
    ObjectGuid _playerGUID;
    EventMap _events;

private:
    // Every half second while the story runs: off the vehicle, dead, quest abandoned, out of the Badlands
    bool CheckStory(Player* player)
    {
        if (!player->IsAlive() || player->GetVehicleBase() != me || player->GetQuestStatus(_story->Quest) == QUEST_STATUS_NONE)
        {
            End();
            return false;
        }

        // "Hmm... I didn't go this direction.  I think I'm telling the story wrong." then out (comments on 27714; retail let the
        // player fall from the sky in Searing Gorge half a minute later: here he is set down at the camp at once)
        if (player->GetMapId() != MAP_EASTERN_KINGDOMS || me->GetZoneId() != ZONE_BADLANDS)
        {
            Narrate(WrongWayGroup(), player);
            End();
            return false;
        }

        CheckGroupCredit(player);
        OnCheck(player);
        return !_done;
    }

    std::vector<ObjectGuid> _actorGUIDs;
    bool _started = false;
    bool _done = false;
    bool _changingSeat = false;
    bool _groupCredited = false;
    bool _riderHidden = false;
};

// Starts a story for a real player holding its quest in progress: the start spell seats him in the teller's vehicle. If no
// story vehicle with this script seated him (the spell failed, or the vehicle has no script), what the spell left is taken off
static bool StartStory(Player* player, StoryInfo const& story)
{
    if (player->GetSession()->IsBot())
        return false;

    if (!player->IsAlive() || player->GetVehicle() || player->IsInFlight() || player->GetQuestStatus(story.Quest) != QUEST_STATUS_INCOMPLETE)
        return false;

    if (FindStoryVehicleOf(player))
        return false;

    StripStoryAuras(player);
    player->CastSpell(player, story.StartSpell, true);

    Unit* base = player->GetVehicleBase();
    Creature* vehicle = base ? base->ToCreature() : nullptr;
    if (!vehicle || vehicle->GetEntry() != story.Vehicle || !dynamic_cast<npc_badlands_story_vehicle*>(vehicle->AI()))
    {
        TC_LOG_ERROR("scripts", "StartStory: %s could not start the story of quest %u (on a vehicle: %u)", player->GetName().c_str(),
            story.Quest, vehicle ? vehicle->GetEntry() : 0);
        if (vehicle)
            player->ExitVehicle();
        StripStoryAuras(player);
        return false;
    }
    return true;
}

/*######
## 2785 Theldurin the Lost, 2920 Lucien Tosselwrench, 4618 Martek the Exiled (the tellers at the campfire)
## Accepting a story from its teller starts it (the wiki: "On accept"; a comment: "the quests take place during the cinematics");
## a playerbot accepting it gets no vehicle (R4). "Tell me that story again, <name>." (gossip 12131 / 12202 / 12209 option 0,
## shown while the quest is in progress) starts it again: after a death, an early exit, or for a quest received by sharing. At each
## turn-in the next teller speaks up (sourced lines and order: the wiki).
######*/

struct npc_badlands_storyteller : public ScriptedAI
{
    npc_badlands_storyteller(Creature* creature) : ScriptedAI(creature) { }

    void OnQuestAccept(Player* player, Quest const* quest) override
    {
        StoryInfo const* story = GetStoryByQuest(quest->GetQuestId());
        if (story && story->Teller == me->GetEntry())
            StartStory(player, *story);
    }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 /*gossipListId*/) override
    {
        StoryInfo const* story = GetStoryByMenu(menuId);
        if (!story || story->Teller != me->GetEntry())
            return false;

        CloseGossipMenuFor(player);
        StartStory(player, *story);
        return true;
    }

    void OnQuestReward(Player* player, Quest const* quest, uint32 /*opt*/) override
    {
        switch (quest->GetQuestId())
        {
            case QUEST_TDDC_THELDURIN:
                if (Creature* lucien = me->FindNearestCreature(NPC_LUCIEN_TOSSELWRENCH, 30.0f))
                    sCreatureTextMgr->SendChat(lucien, SAY_LUCIEN_TELLING_IT_WRONG, player);
                break;
            case QUEST_TDDC_LUCIEN:
                if (Creature* theldurin = me->FindNearestCreature(NPC_THELDURIN_THE_LOST, 30.0f))
                    sCreatureTextMgr->SendChat(theldurin, SAY_THELDURIN_STOP_DRINKING, player);
                break;
            case QUEST_TDDC_MARTEK:
                if (Creature* theldurin = me->FindNearestCreature(NPC_THELDURIN_THE_LOST, 30.0f))
                    sCreatureTextMgr->SendChat(theldurin, SAY_THELDURIN_SORRY_MARTEK, player);
                break;
            default:
                break;
        }
    }
};

/*######
## 46484 / 46502 the flying Deathwings, 46497 Martek the Awesome, 47103 Cowardly Deathwing, 47157 Theldurin and 47163 the giant
## Lucien (Martek's interrupters): actors of a story. The story moves and voices them; they never fight (faction 14 and 103 would
## otherwise make AggressorAI of the dragons). They leave with their story (the vehicle tracks them) or with their summoner.
######*/

struct npc_badlands_tddc_actor : public ScriptedAI
{
    npc_badlands_tddc_actor(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    void UpdateAI(uint32 /*diff*/) override { }
};

/*######
## The Day that Deathwing Came (27713), Theldurin's story (TDDC 1)
######*/

enum TheldurinStory
{
    NPC_DANG_BLASTED_ROCK_ELEMENTAL     = 46467,
    NPC_TDDC_DEATHWING                  = 46471,    // in human form: 161640 at the end of the trench (phase 293), 161582 on the pillar (310)
    NPC_TDDC1_FLYING_DEATHWING          = 46484,
    GO_GOL_DURNED_ROCK_HEAP             = 206108,   // 77 rock walls down the trench (phase 293), doors

    SPELL_TDDC1_THELDURIN_TRANSFORM     = 86621,
    SPELL_TDDC1_SUMMON_DEATHWING        = 86628,    // the flying Deathwing, personal, 71 yd above the camp
    SPELL_TDDC1_KNOCKBACK_ELEMENTAL     = 86563,    // 3600 to the target and a 10 yd cone in front, knock back

    // 46466 text groups (broadcast texts, order from the wiki's transcript)
    TALK_TDDC1_BRIGHT_SHINY_DAY         = 0,        // 46563
    TALK_TDDC1_DEATHWING_APPEARED       = 1,        // 46564
    TALK_TDDC1_I_SAID_TO_MYSELF         = 2,        // 46565
    TALK_TDDC1_YELL_PUNCH_THAT_DRAGON   = 3,        // 46566 (yell)
    TALK_TDDC1_ANGRY_ELEMENTALS         = 4,        // 46567
    TALK_TDDC1_I_SAID                   = 5,        // 46568
    TALK_TDDC1_YELL_ROCK_ELEMENTALS     = 6,        // 46569 (yell)
    TALK_TDDC1_YELL_PUNCH_YOU_TOO       = 7,        // 46570 (yell)
    TALK_TDDC1_PUNCH                    = 8,        // 46575-46582, random, about one punch in three
    TALK_TDDC1_WRONG_WAY                = 9,        // 46595

    EVENT_TDDC1_LINE_SHINY_DAY          = EVENT_STORY_FIRST_SCENE_EVENT,
    EVENT_TDDC1_DEATHWING_FLIES,
    EVENT_TDDC1_LINE_APPEARED,
    EVENT_TDDC1_GROUND_CAMERA,
    EVENT_TDDC1_YELL_PUNCH_DRAGON,
    EVENT_TDDC1_LINE_ELEMENTALS,
    EVENT_TDDC1_LINE_I_SAID,
    EVENT_TDDC1_YELL_ROCK_ELEMENTALS,
    EVENT_TDDC1_YELL_PUNCH_YOU_TOO,
    EVENT_TDDC1_CONTROL,
    EVENT_TDDC1_PUNCH
};

// Theldurin's Fist reaches 10 yd (86563's cone and 86564's object search)
float const TheldurinPunchRange = 10.0f;

// The flying Deathwing's flight (ours: "Deathwing flies into frame and down the scar to the north-east", the wiki). The Sky camera
// (CameraMode 80) looks from (-7126.9, -2711.3, 253.2) towards (-7110.6, -2726.5, 265.0): north-east and about 28 degrees up, with a
// vertical field of view of about 44 degrees. From his summon point 71 yd above the camp he enters the frame high, crosses it
// down the line of the trench (the second point is 29 degrees up, the third 8) and leaves it towards the trench's end
Position const TheldurinDeathwingFlight[] =
{
    { -7085.0f, -2752.0f, 300.0f },
    { -7020.0f, -2830.0f, 285.0f },
    { -6930.0f, -2930.0f, 275.0f },
    { -6820.0f, -3060.0f, 270.0f }
};

// 46466 - Theldurin the Lost (the player's Theldurin)
// What the player sees (wiki transcript, broadcast texts 46563-46570, DBC; timings ours): Theldurin's shape at the camp (86621), a
// bright sunny sky; the Sky camera: "I remember it well.  It was a bright, shiny day...", Deathwing flies over and down the Scar,
// "...Deathwing appeared!"; the Ground camera on Theldurin: the narration and his three yells; then the player drives Theldurin
// with one button, Theldurin's Fist (86561): a leap and a punch that knocks elementals back and breaks the rock walls. Kills of
// the Dang-Blasted Rock Elementals credit the player (the vehicle is his charm). Punching Deathwing, who stands in his ring of
// flames at the end of the trench, is the last objective: the story ends right there (wiki) and the player is back at the camp.
struct npc_badlands_theldurin_story : public npc_badlands_story_vehicle
{
    npc_badlands_theldurin_story(Creature* creature) : npc_badlands_story_vehicle(creature, QUEST_TDDC_THELDURIN) { }

    void DoAction(int32 action) override
    {
        // The leap lands 0.2 s after the cast (5 yd at the jump's speed); the punch comes then
        if (action == ACTION_TDDC_FIST && !_punched)
            _events.ScheduleEvent(EVENT_TDDC1_PUNCH, 300ms);
    }

protected:
    uint8 WrongWayGroup() const override { return TALK_TDDC1_WRONG_WAY; }

    void StartScene(Player* player) override
    {
        me->CastSpell(me, SPELL_TDDC1_THELDURIN_TRANSFORM, true);
        // The elementals keep their sniffed quest invisibility (49414, type 7): the player and Theldurin see them through See Quest
        // Invis 1 (86637). Its vehicle form 87785 targets TARGET_UNIT_UNK_105, which this core does not implement, so the vehicle
        // gets 86637 too; this core's invisible units only see those that detect them, so the elementals see Theldurin by it
        player->CastSpell(player, SPELL_SEE_QUEST_INVIS_1, true);
        me->CastSpell(me, SPELL_SEE_QUEST_INVIS_1, true);

        _events.ScheduleEvent(EVENT_TDDC1_LINE_SHINY_DAY, 1s);
        _events.ScheduleEvent(EVENT_TDDC1_DEATHWING_FLIES, 2s);
        _events.ScheduleEvent(EVENT_TDDC1_LINE_APPEARED, 5s);
        _events.ScheduleEvent(EVENT_TDDC1_GROUND_CAMERA, 9s);
        _events.ScheduleEvent(EVENT_TDDC1_YELL_PUNCH_DRAGON, 13s);
        _events.ScheduleEvent(EVENT_TDDC1_LINE_ELEMENTALS, 16s);
        _events.ScheduleEvent(EVENT_TDDC1_LINE_I_SAID, 20s);
        _events.ScheduleEvent(EVENT_TDDC1_YELL_ROCK_ELEMENTALS, 24s);
        _events.ScheduleEvent(EVENT_TDDC1_YELL_PUNCH_YOU_TOO, 26s);
        _events.ScheduleEvent(EVENT_TDDC1_CONTROL, 28s);
    }

    void SceneEvent(uint32 eventId, Player* player) override
    {
        switch (eventId)
        {
            case EVENT_TDDC1_LINE_SHINY_DAY:
                Narrate(TALK_TDDC1_BRIGHT_SHINY_DAY, player);
                break;
            case EVENT_TDDC1_DEATHWING_FLIES:
                player->CastSpell(player, SPELL_TDDC1_SUMMON_DEATHWING, true);
                if (Creature* deathwing = FindOwnSummon(player, NPC_TDDC1_FLYING_DEATHWING, 120.0f))
                {
                    Track(deathwing);
                    FlyAway(deathwing, TheldurinDeathwingFlight, std::size(TheldurinDeathwingFlight));
                }
                break;
            case EVENT_TDDC1_LINE_APPEARED:
                Narrate(TALK_TDDC1_DEATHWING_APPEARED, player);
                break;
            case EVENT_TDDC1_GROUND_CAMERA:
                ChangeRiderSeat(player, SEAT_CAMERA_GROUND);
                Narrate(TALK_TDDC1_I_SAID_TO_MYSELF, player);
                break;
            case EVENT_TDDC1_YELL_PUNCH_DRAGON:
                Say(TALK_TDDC1_YELL_PUNCH_THAT_DRAGON, player);
                break;
            case EVENT_TDDC1_LINE_ELEMENTALS:
                Narrate(TALK_TDDC1_ANGRY_ELEMENTALS, player);
                break;
            case EVENT_TDDC1_LINE_I_SAID:
                Narrate(TALK_TDDC1_I_SAID, player);
                break;
            case EVENT_TDDC1_YELL_ROCK_ELEMENTALS:
                Say(TALK_TDDC1_YELL_ROCK_ELEMENTALS, player);
                break;
            case EVENT_TDDC1_YELL_PUNCH_YOU_TOO:
                Say(TALK_TDDC1_YELL_PUNCH_YOU_TOO, player);
                break;
            case EVENT_TDDC1_CONTROL:
                ChangeRiderSeat(player, SEAT_CONTROL);
                break;
            case EVENT_TDDC1_PUNCH:
                Punch(player);
                break;
            default:
                break;
        }
    }

private:
    // Theldurin's Fist after the leap (86561's two triggered spells are done here, at the landing point: as DBC triggers they
    // would run at the take-off, 86563 with the vehicle itself as its enemy target): 86563 on the nearest elemental, or Deathwing,
    // within 10 yd in front, which deals the cone's damage and knocks back; every closed rock wall within 10 yd in front opens
    // (86564: ACTIVATE_OBJECT, "open"; the walls close again by their template's autoClose). Punching Deathwing gives the last
    // credit whether or not the punch lands (he is level 87: a level 47 spell rarely hits him) and ends the story 3 s later
    void Punch(Player* player)
    {
        if (_punched || !IsControlling(player))
            return;

        Unit* target = nullptr;
        float best = TheldurinPunchRange;
        Creature* deathwing = nullptr;

        std::list<Creature*> creatures;
        me->GetCreatureListWithEntryInGrid(creatures, NPC_DANG_BLASTED_ROCK_ELEMENTAL, TheldurinPunchRange + 10.0f);
        me->GetCreatureListWithEntryInGridAppend(creatures, NPC_TDDC_DEATHWING, TheldurinPunchRange + 20.0f);
        for (Creature* creature : creatures)
        {
            if (!creature->IsAlive() || !me->InSamePhase(creature) || !me->isInFront(creature, float(M_PI)))
                continue;

            float const dist = me->GetDistance(creature);
            if (dist > TheldurinPunchRange)
                continue;

            if (creature->GetEntry() == NPC_TDDC_DEATHWING)
                deathwing = creature;
            if (dist <= best)
            {
                best = dist;
                target = creature;
            }
        }

        // Set before the cast: its damage on Deathwing asks for a punch again (DamageTaken), which must not run a second one
        if (deathwing)
            _punched = true;

        if (target && me->IsValidAttackTarget(target))
            me->CastSpell(target, SPELL_TDDC1_KNOCKBACK_ELEMENTAL, true);

        std::list<GameObject*> walls;
        me->GetGameObjectListWithEntryInGrid(walls, GO_GOL_DURNED_ROCK_HEAP, TheldurinPunchRange + 10.0f);
        for (GameObject* wall : walls)
            if (wall->GetGoState() == GO_STATE_READY && me->InSamePhase(wall) && me->GetDistance(wall) <= TheldurinPunchRange
                && (me->isInFront(wall, float(M_PI)) || me->GetExactDist2d(wall) < 4.0f))
                wall->UseDoorOrButton(0, false, me);

        if (urand(0, 2) == 0)
            Say(TALK_TDDC1_PUNCH, player);

        if (deathwing)
        {
            Credit(player, NPC_TDDC_DEATHWING);
            EndIn(3s);
        }
    }

    bool _punched = false;

public:
    // Sends a flying actor along a smooth path and lets it go once out of sight
    static void FlyAway(Creature* actor, Position const* points, size_t count)
    {
        actor->SetCanFly(true);
        actor->SetDisableGravity(true);
        actor->SetSpeed(MOVE_FLIGHT, 3.0f);
        actor->SetSpeed(MOVE_RUN, 3.0f);

        std::vector<Position> path;
        path.push_back(actor->GetPosition());
        for (size_t i = 0; i < count; ++i)
            path.push_back(points[i]);

        actor->GetMotionMaster()->Clear();
        actor->GetMotionMaster()->MoveSmoothPath(1, path.data(), path.size(), false, true);
        actor->DespawnOrUnsummon(30 * IN_MILLISECONDS);
    }
};

// 86561 - Theldurin's Fist (46466's only button: "Plant an angry fist in any obstacle that gets in your way.")
// The leap (JUMP_DEST 5 yd in front) stays the spell's; its two triggers are left to the vehicle, which punches at the landing
// point (npc_badlands_theldurin_story::Punch)
class spell_badlands_theldurins_fist : public SpellScript
{
    PrepareSpellScript(spell_badlands_theldurins_fist);

    void PreventTrigger(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
    }

    void HandleAfterCast()
    {
        if (Creature* vehicle = GetCaster()->ToCreature())
            if (vehicle->GetEntry() == NPC_THELDURIN_VEHICLE && vehicle->IsAIEnabled)
                vehicle->AI()->DoAction(ACTION_TDDC_FIST);
    }

    void Register() override
    {
        OnEffectLaunch += SpellEffectFn(spell_badlands_theldurins_fist::PreventTrigger, EFFECT_1, SPELL_EFFECT_TRIGGER_SPELL);
        OnEffectLaunch += SpellEffectFn(spell_badlands_theldurins_fist::PreventTrigger, EFFECT_2, SPELL_EFFECT_TRIGGER_SPELL);
        OnEffectLaunchTarget += SpellEffectFn(spell_badlands_theldurins_fist::PreventTrigger, EFFECT_1, SPELL_EFFECT_TRIGGER_SPELL);
        OnEffectLaunchTarget += SpellEffectFn(spell_badlands_theldurins_fist::PreventTrigger, EFFECT_2, SPELL_EFFECT_TRIGGER_SPELL);
        AfterCast += SpellCastFn(spell_badlands_theldurins_fist::HandleAfterCast);
    }
};

// 46471 - Deathwing (in human form: 161640 at the end of Theldurin's trench, phase 293; 161582 on Martek's pillar, phase 310)
// "He just stands there" (comments 2011-01-24, 2010-11-25): never moves, never attacks, never falls (858 million health in the
// TDBs; nothing takes it off him here). Theldurin's punch reaches him (the template loses NON_ATTACKABLE and IMMUNE_TO_PC, as
// both TDBs have none), and any damage from a Theldurin also gives the punch's credit
struct npc_badlands_tddc_deathwing : public ScriptedAI
{
    npc_badlands_tddc_deathwing(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        me->SetReactState(REACT_PASSIVE);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override
    {
        me->CombatStop(true);
    }

    void DamageTaken(Unit* attacker, uint32& damage) override
    {
        damage = 0;

        if (attacker && attacker->GetEntry() == NPC_THELDURIN_VEHICLE && attacker->IsAIEnabled)
            attacker->ToCreature()->AI()->DoAction(ACTION_TDDC_FIST);
    }

    void UpdateAI(uint32 /*diff*/) override { }
};

/*######
## A player who logged out inside a story was saved where the vehicle stood (the auras are DONT_SAVE). At login whatever a story
## put on him is taken off, and one saved in the air (Martek's hog flies) is set down at the camp rather than dropped: ours.
######*/

class player_badlands_stories : public PlayerScript
{
public:
    player_badlands_stories() : PlayerScript("player_badlands_stories") { }

    void OnLogin(Player* player) override
    {
        if (player->GetVehicle())
            return;

        StripStoryAuras(player);

        if (player->GetMapId() != MAP_EASTERN_KINGDOMS || player->GetZoneId() != ZONE_BADLANDS || !player->IsAlive())
            return;

        // Only Martek's hog flies: only a player holding his story, not on a mount of his own (a flying mount is saved with
        // him), and within the ride's reach of the camp (the trench and the pillar lie 600-650 yd from it)
        StoryInfo const* open = GetStoryByQuest(QUEST_TDDC_MARTEK);
        if (player->GetQuestStatus(open->Quest) != QUEST_STATUS_INCOMPLETE || player->IsMounted() || player->HasAuraType(SPELL_AURA_FLY)
            || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED) || player->GetExactDist2d(&open->ReturnPos) > StoryLoginReach)
            return;

        if (OnPillarTop(player))
        {
            SetDownAtCampNow(player, open);
            return;
        }

        float const ground = player->GetMap()->GetHeight(player->GetPhaseMask(), player->GetPositionX(), player->GetPositionY(),
            player->GetPositionZ(), true, 500.0f);
        if (ground <= INVALID_HEIGHT || player->GetPositionZ() - ground <= 10.0f)
            return;

        SetDownAtCampNow(player, open);
    }

private:
    static void SetDownAtCampNow(Player* player, StoryInfo const* story)
    {
        Position const& dest = story->ReturnPos;
        player->NearTeleportTo(dest.GetPositionX(), dest.GetPositionY(), dest.GetPositionZ(),
            dest.GetAngle(story->TellerPos.GetPositionX(), story->TellerPos.GetPositionY()));
    }

    // Saved on the ground of the pillar top during Martek's last scene (his hog hovers there): set down too (added with his story)
    static bool OnPillarTop(Player* /*player*/) { return false; }
};

void AddSC_badlands_stories()
{
    new creature_script<npc_badlands_storyteller>("npc_badlands_storyteller");
    new creature_script<npc_badlands_tddc_actor>("npc_badlands_tddc_actor");
    new creature_script<npc_badlands_theldurin_story>("npc_badlands_theldurin_story");
    new spell_script<spell_badlands_theldurins_fist>("spell_badlands_theldurins_fist");
    new creature_script<npc_badlands_tddc_deathwing>("npc_badlands_tddc_deathwing");
    new player_badlands_stories();
}
