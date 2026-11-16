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
        // The leap lands 0.2 s after the cast (5 yd at the jump's speed); the punch comes then. Where the Fist was pressed is kept:
        // the spell's jump has only been launched (Spell::EffectJumpDest at launch), the vehicle still stands at the take-off
        // (a punch already on its way keeps the take-off of its own Fist: Deathwing's DamageTaken asks for a punch too)
        if (action == ACTION_TDDC_FIST && !_punched && !_punchPending)
        {
            _punchPending = true;
            _fistFrom = me->GetPosition();
            _events.ScheduleEvent(EVENT_TDDC1_PUNCH, 300ms);
        }
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
    // credit whether or not the punch lands (he is level 87: a level 47 spell rarely hits him) and ends the story 3 s later.
    // In reach is what is within 10 yd in front of the landing point or in front of the take-off: the leap carries Theldurin
    // 5 yd on, past an elemental that stood at his fists when the button was pressed (an elemental's melee reaches about 3.8 yd
    // from Theldurin's centre), and from the landing point alone that elemental is behind him and was never punched. Only a
    // creature the punch can land on is chosen (one that is evading, or behind a closed wall, would take the punch and nothing
    // would happen: the spell's own line-of-sight check drops the whole cast without a word)
    void Punch(Player* player)
    {
        _punchPending = false;
        if (_punched || !IsControlling(player))
            return;

        Unit* target = nullptr;
        float best = 0.0f;
        Creature* deathwing = nullptr;

        std::list<Creature*> creatures;
        me->GetCreatureListWithEntryInGrid(creatures, NPC_DANG_BLASTED_ROCK_ELEMENTAL, TheldurinPunchRange + 15.0f);
        me->GetCreatureListWithEntryInGridAppend(creatures, NPC_TDDC_DEATHWING, TheldurinPunchRange + 25.0f);
        for (Creature* creature : creatures)
        {
            if (!creature->IsAlive() || !me->InSamePhase(creature))
                continue;

            float const size = me->GetObjectSize() + creature->GetObjectSize();
            bool const fromLanding = me->isInFront(creature, float(M_PI)) && me->GetDistance(creature) <= TheldurinPunchRange;
            bool const fromTakeOff = _fistFrom.HasInArc(float(M_PI), creature) && _fistFrom.GetExactDist(creature) - size <= TheldurinPunchRange;
            if (!fromLanding && !fromTakeOff)
                continue;

            // Deathwing's credit keeps its own rule: within 10 yd in front of the landing point
            if (creature->GetEntry() == NPC_TDDC_DEATHWING && fromLanding)
                deathwing = creature;

            // The spell's own range check (Spell::CheckRange, strict for a triggered cast too) is made from where the vehicle is
            // now: a creature at the side of the take-off at full reach can be beyond it from the landing point
            if (creature->IsInEvadeMode() || !me->IsValidAttackTarget(creature) || !me->IsWithinCombatRange(creature, TheldurinPunchRange)
                || !me->IsWithinLOSInMap(creature))
                continue;

            float const dist = me->GetExactDist(creature) - size;
            if (!target || dist < best)
            {
                best = dist;
                target = creature;
            }
        }

        // Set before the cast: its damage on Deathwing asks for a punch again (DamageTaken), which must not run a second one
        if (deathwing)
            _punched = true;

        if (target)
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
    bool _punchPending = false;
    Position _fistFrom;

public:
    // Sends a flying actor along a smooth path and lets it go once out of sight. Creature::SetFlying puts him on the Fly
    // animation tier (UNIT_FIELD_BYTES_1 byte 3), from which the client picks FlyRun / FlyStand; gravity alone leaves the Ground
    // tier and he walks through the air. Nothing takes it off again: MoveSmoothPath is an effect movement, for which
    // Creature::UpdateMovementFlags does nothing, and after the path a creature with gravity off counts as flying (CanFly)
    static void FlyAway(Creature* actor, Position const* points, size_t count)
    {
        actor->SetCanFly(true);
        actor->SetFlying(true);
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
## The Day that Deathwing Came: The Real Story (27714), Lucien's story (TDDC 2)
######*/

enum LucienStory
{
    NPC_TDDC2_FLYING_DEATHWING          = 46502,
    NPC_TDDC2_CLOUD                     = 47097,    // nine across the zone, 18 yd above the ground (phase 295)
    NPC_COWARDLY_DEATHWING              = 47103,
    NPC_TDDC2_GROW_CREDIT               = 47080,    // "Grow large enough to reach the clouds" (the vehicle's own entry)
    GO_TDDC2_THE_SUN                    = 206550,

    SPELL_TDDC2_LUCIEN_TRANSFORM        = 87741,
    SPELL_TDDC2_LUCIEN_TRANSFORM_2      = 87748,    // "Lucien Tosselwrench (5x Size)" 47084's display, once grown
    SPELL_TDDC2_SUMMON_DEATHWING        = 86681,
    SPELL_SHRINK_THE_WORLD              = 87743,    // +200% size and +80% speed a stack, 5 stacks
    SPELL_TDDC2_WALK_ANIM               = 87745,    // "Walk (Anim Replacement)": the giant walks fast with a slow walk
    SPELL_TDDC2_SUMMON_COWARDLY_DW      = 87802,    // Deathwing 15 yd in front, and the "Find Deathwing" credit

    SEAT_TDDC2_HELD_DEATHWING           = 7,        // VehicleSeat 8905 (87783 "Ride Vehicle - Seat 8")
    SHRINK_STACKS_TO_GROW               = 5,
    CLOUDS_TO_SEARCH                    = 5,

    // 47080 text groups (broadcast texts, order from the wiki's transcript)
    TALK_TDDC2_IT_WAS_CLOUDY            = 0,        // 47121
    TALK_TDDC2_FLEW_INTO_CLOUDS         = 1,        // 47122
    TALK_TDDC2_I_YELLED                 = 2,        // 47124
    TALK_TDDC2_YELL_FIND_YOU            = 3,        // 47125 (yell)
    TALK_TDDC2_YELL_KALIMDOR            = 4,        // 47126 (yell)
    TALK_TDDC2_TINKERING                = 5,        // 47123
    TALK_TDDC2_KEEP_SHRINKING           = 6,        // 47127 (with the Shrink the World icon)
    TALK_TDDC2_SMALL_ENOUGH             = 7,        // 47154 (with the Search Cloud icon)
    TALK_TDDC2_SEARCH                   = 8,        // 47170-47177, random, about one search in two
    TALK_TDDC2_SEARCHED_EVERY_CLOUD     = 9,        // 47163
    TALK_TDDC2_HIDING_IN_THE_SUN        = 10,       // 47164
    TALK_TDDC2_SLIMY_NECK               = 11,       // 47166
    TALK_TDDC2_THREW_HIM                = 12,       // 47167
    TALK_TDDC2_WRONG_WAY                = 13,       // 46595

    EVENT_TDDC2_LINE_CLOUDY             = EVENT_STORY_FIRST_SCENE_EVENT,
    EVENT_TDDC2_DEATHWING_FLIES,
    EVENT_TDDC2_LINE_INTO_CLOUDS,
    EVENT_TDDC2_GROUND_CAMERA,
    EVENT_TDDC2_YELL_FIND_YOU,
    EVENT_TDDC2_YELL_KALIMDOR,
    EVENT_TDDC2_LINE_TINKERING,
    EVENT_TDDC2_CONTROL,
    EVENT_TDDC2_SUMMON_SUN,
    EVENT_TDDC2_THROW
};

// Search Cloud's reach (SpellRange 15 yd). The nine clouds float 43-72 yd above the ground under them (ground.py), "at the giant's
// eye height", "walk into them, it gets foggy around your head, press 2" (comments): the reach is measured from the giant's body,
// not his feet. Across: 15 yd plus both bodies (the core's body-to-body rule, flattened; 41.5 yd for the grown giant, combat reach
// 1.5 x 11, and a cloud, 10). Up: 15 yd plus the cloud's body plus the giant's height (his scale, and five times that once he has
// the 5x display: 80 yd grown, 26 yd for a small Lucien, who reaches only a cloud over a hilltop, as a 2025 comment found)
float const SearchCloudRange = 15.0f;
float const LucienModelHeight = 1.0f;
float const LucienGrownModelFactor = 5.0f;
// The sun comes 10 yd ahead of the giant and 70 yd above his feet: over his head, as "I looked up" and the comments ("a big ball over
// your head") have it, and inside the client's reach for The Sun (CheckRange: the player's position in the object's own frame within
// the display's box scaled by its size, 7967 x 3 = +-44 x, +-103 y, +-101 z, plus the interact distance; 87790's 45 yd ahead sat on
// the box's edge, the retail "too far away")
float const SunAhead = 10.0f;
float const SunAbove = 70.0f;

// The flying Deathwing turns away and flies up into the clouds (ours: the wiki's "flew into the clouds"), through the Sky camera
Position const LucienDeathwingFlight[] =
{
    { -7090.0f, -2750.0f, 345.0f },
    { -7030.0f, -2820.0f, 380.0f },
    { -6960.0f, -2900.0f, 420.0f }
};

// Thrown to Kalimdor: from the giant's hands far to the west (+y) and up (ours)
float const ThrowDistance = 250.0f;

// 47080 - Lucien Tosselwrench (the player's Lucien)
// What the player sees (wiki transcript, broadcast texts 47121-47177, comments, DBC; timings ours): a cloudy sky (87737, 86723);
// the Sky camera: "First of all, it wasn't sunny out...", Deathwing flies off into the clouds; the Ground camera on Lucien with the
// narration and his two yells; then the player is Lucien with two buttons. Shrink the World (87743) five times makes him a giant
// ("Grow large enough", 47154); Search Cloud (87777) near the grey clouds all over the zone (five searched; a random line about
// one search in two). After the fifth cloud: "I had searched every cloud...", "...he was hiding in the sun.  I looked up.", a sunny
// sky and The Sun in front of him (87790, two minutes; growing or searching again once it is gone brings it back: four comments).
// Clicking it: Deathwing is in his hand ("Find Deathwing"), Lucien is burnt to a tenth of his health, "I summoned all my strength,
// faced west, and threw him to Kalimdor.", Deathwing flies off west and the story ends at the camp. No mob fights the giant.
struct npc_badlands_lucien_story : public npc_badlands_story_vehicle
{
    npc_badlands_lucien_story(Creature* creature) : npc_badlands_story_vehicle(creature, QUEST_TDDC_LUCIEN) { }

    void DoAction(int32 action) override
    {
        Player* player = GetPlayer();
        if (!player || !IsControlling(player))
            return;

        switch (action)
        {
            case ACTION_TDDC_GROW:
            {
                Aura const* shrink = me->GetAura(SPELL_SHRINK_THE_WORLD);
                // Grown: the 5x Lucien's display (the clouds at his eye height, "so big I could hardly see where I was going")
                if (shrink && shrink->GetStackAmount() >= SHRINK_STACKS_TO_GROW && !me->HasAura(SPELL_TDDC2_LUCIEN_TRANSFORM_2))
                    me->CastSpell(me, SPELL_TDDC2_LUCIEN_TRANSFORM_2, true);
                if (shrink && shrink->GetStackAmount() >= SHRINK_STACKS_TO_GROW && !CreditCount(player, NPC_TDDC2_GROW_CREDIT))
                {
                    Credit(player, NPC_TDDC2_GROW_CREDIT);
                    Narrate(TALK_TDDC2_SMALL_ENOUGH, player);
                }
                if (!EndIfComplete(player))
                    TrySun(player);
                break;
            }
            case ACTION_TDDC_CLOUD_SEARCHED:
                // One credit a search, as 87777's KILL_CREDIT gives (the same cloud may be searched again)
                Credit(player, NPC_TDDC2_CLOUD);
                if (urand(0, 1))
                    Say(TALK_TDDC2_SEARCH, player);
                if (!EndIfComplete(player))
                    TrySun(player);
                break;
            case ACTION_TDDC_SUN_CLICKED:
                CatchDeathwing(player);
                break;
            default:
                break;
        }
    }

protected:
    uint8 WrongWayGroup() const override { return TALK_TDDC2_WRONG_WAY; }

    // An unclicked sun (personal, 120 s, with the player's phases: also seen outside the story) goes with the story
    void OnEnd(Player* player) override
    {
        std::list<GameObject*> suns;
        player->GetGameObjectListWithEntryInGrid(suns, GO_TDDC2_THE_SUN, 100.0f);
        for (GameObject* sun : suns)
            if (sun->GetPrivateObjectOwner() == player->GetGUID())
            {
                sun->SetRespawnTime(0);
                sun->Delete();
            }
    }

    void OnSummoned(Player* /*player*/) override
    {
        // "I never saw any [mobs]" (comment 2011-08-21), "never attacked" (2010-12-05 [+66]): the giant walks the normal Badlands,
        // whose mobs cannot fight a unit immune to NPCs (ours)
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);
    }

    void StartScene(Player* player) override
    {
        me->CastSpell(me, SPELL_TDDC2_LUCIEN_TRANSFORM, true);
        player->CastSpell(player, SPELL_TDDC2_WEATHER, true);

        _events.ScheduleEvent(EVENT_TDDC2_LINE_CLOUDY, 1s);
        _events.ScheduleEvent(EVENT_TDDC2_DEATHWING_FLIES, 2s);
        _events.ScheduleEvent(EVENT_TDDC2_LINE_INTO_CLOUDS, 6s);
        _events.ScheduleEvent(EVENT_TDDC2_GROUND_CAMERA, 10s);
        _events.ScheduleEvent(EVENT_TDDC2_YELL_FIND_YOU, 14s);
        _events.ScheduleEvent(EVENT_TDDC2_YELL_KALIMDOR, 16s);
        _events.ScheduleEvent(EVENT_TDDC2_LINE_TINKERING, 19s);
        _events.ScheduleEvent(EVENT_TDDC2_CONTROL, 23s);
    }

    void SceneEvent(uint32 eventId, Player* player) override
    {
        switch (eventId)
        {
            case EVENT_TDDC2_LINE_CLOUDY:
                Narrate(TALK_TDDC2_IT_WAS_CLOUDY, player);
                break;
            case EVENT_TDDC2_DEATHWING_FLIES:
                player->CastSpell(player, SPELL_TDDC2_SUMMON_DEATHWING, true);
                if (Creature* deathwing = FindOwnSummon(player, NPC_TDDC2_FLYING_DEATHWING, 120.0f))
                {
                    Track(deathwing);
                    npc_badlands_theldurin_story::FlyAway(deathwing, LucienDeathwingFlight, std::size(LucienDeathwingFlight));
                }
                break;
            case EVENT_TDDC2_LINE_INTO_CLOUDS:
                Narrate(TALK_TDDC2_FLEW_INTO_CLOUDS, player);
                break;
            case EVENT_TDDC2_GROUND_CAMERA:
                ChangeRiderSeat(player, SEAT_CAMERA_GROUND);
                Narrate(TALK_TDDC2_I_YELLED, player);
                break;
            case EVENT_TDDC2_YELL_FIND_YOU:
                Say(TALK_TDDC2_YELL_FIND_YOU, player);
                break;
            case EVENT_TDDC2_YELL_KALIMDOR:
                Say(TALK_TDDC2_YELL_KALIMDOR, player);
                break;
            case EVENT_TDDC2_LINE_TINKERING:
                Narrate(TALK_TDDC2_TINKERING, player);
                break;
            case EVENT_TDDC2_CONTROL:
                Narrate(TALK_TDDC2_KEEP_SHRINKING, player);
                ChangeRiderSeat(player, SEAT_CONTROL);
                me->CastSpell(me, SPELL_TDDC2_WALK_ANIM, true);
                break;
            case EVENT_TDDC2_SUMMON_SUN:
                _sunComing = false;
                if (!_caught && !me->HasAura(SPELL_TDDC2_SUMMON_THE_SUN) && IsControlling(player))
                {
                    if (!_sunToldOnce)
                        Narrate(TALK_TDDC2_HIDING_IN_THE_SUN, player);
                    _sunToldOnce = true;
                    player->CastSpell(player, SPELL_TDDC2_SUMMON_THE_SUN, true);
                }
                break;
            case EVENT_TDDC2_THROW:
                Throw(player);
                break;
            default:
                break;
        }
    }

private:
    // A retold story whose last missing objective was the growth or a cloud (Deathwing already found in an earlier telling):
    // that credit completes the quest and the story ends there, as it does after the throw
    bool EndIfComplete(Player* player)
    {
        if (_caught || _ending || player->GetQuestStatus(QUEST_TDDC_LUCIEN) != QUEST_STATUS_COMPLETE)
            return false;

        _ending = true;
        EndIn(3s);
        return true;
    }

    // Grown large enough (the wiki's order: grow, then search) and five clouds searched, Deathwing not found yet, and no sun up:
    // the sun comes (again). Without the growth a player who searched first would find Deathwing and be sent back to the camp with
    // "Grow large enough" open
    void TrySun(Player* player)
    {
        if (_caught || _sunComing || !CreditCount(player, NPC_TDDC2_GROW_CREDIT) || CreditCount(player, NPC_TDDC2_CLOUD) < CLOUDS_TO_SEARCH
            || CreditCount(player, NPC_COWARDLY_DEATHWING)
            || me->HasAura(SPELL_TDDC2_SUMMON_THE_SUN) || player->HasAura(SPELL_TDDC2_SUMMON_THE_SUN))
            return;

        _sunComing = true;
        if (!_sunToldOnce)
        {
            Narrate(TALK_TDDC2_SEARCHED_EVERY_CLOUD, player);
            _events.ScheduleEvent(EVENT_TDDC2_SUMMON_SUN, 4s);
        }
        else
            _events.ScheduleEvent(EVENT_TDDC2_SUMMON_SUN, 500ms);
    }

    // The Sun clicked: 87802 summons the Cowardly Deathwing in front of Lucien and gives "Find Deathwing"; he is put in Lucien's
    // hand (seat 7, the seat 87783 names), and the sun burns Lucien to a tenth of his health (wiki)
    void CatchDeathwing(Player* player)
    {
        if (_caught)
            return;
        _caught = true;

        player->CastSpell(player, SPELL_TDDC2_SUMMON_COWARDLY_DW, true);
        if (!CreditCount(player, NPC_COWARDLY_DEATHWING))
            Credit(player, NPC_COWARDLY_DEATHWING);
        else
            CheckGroupCredit(player);

        if (Creature* deathwing = FindOwnSummon(player, NPC_COWARDLY_DEATHWING, 60.0f))
        {
            // 87802's summon is not personal (SummonProperties 64) and keeps the player's phase 169: it is made the player's own,
            // so that passers-by in the open world do not see a dragon in an invisible hand (ours)
            deathwing->SetPrivateObjectOwner(player->GetGUID());
            deathwing->UpdateObjectVisibility();
            _heldGUID = deathwing->GetGUID();
            Track(deathwing);
            deathwing->EnterVehicle(me, SEAT_TDDC2_HELD_DEATHWING);
        }

        me->SetHealth(std::max<uint32>(1, me->CountPctFromMaxHealth(10)));
        Narrate(TALK_TDDC2_SLIMY_NECK, player);
        _events.ScheduleEvent(EVENT_TDDC2_THROW, 5s);
    }

    void Throw(Player* player)
    {
        Narrate(TALK_TDDC2_THREW_HIM, player);

        if (Creature* deathwing = GetActor(_heldGUID))
        {
            // 87811 "Eject Passenger 8" (a script effect) is this
            deathwing->ExitVehicle();
            float const facing = float(M_PI) / 2.0f;   // west
            Position const dest = { me->GetPositionX(), me->GetPositionY() + ThrowDistance, me->GetPositionZ() + 80.0f };
            deathwing->SetFacingTo(facing);
            Position const path[] = { dest };
            npc_badlands_theldurin_story::FlyAway(deathwing, path, 1);
            deathwing->DespawnOrUnsummon(6 * IN_MILLISECONDS);
        }

        EndIn(3s);
    }

    ObjectGuid _heldGUID;
    bool _ending = false;
    bool _caught = false;
    bool _sunComing = false;
    bool _sunToldOnce = false;
};

// 87743 - Shrink the World (Lucien's first button): the size and speed are the aura's; at five stacks the vehicle credits "Grow
// large enough" (its SCRIPT_EFFECT), and a grow after the sun has gone brings it back
class spell_badlands_shrink_the_world : public SpellScript
{
    PrepareSpellScript(spell_badlands_shrink_the_world);

    void HandleAfterHit()
    {
        if (Creature* vehicle = GetCaster()->ToCreature())
            if (vehicle->GetEntry() == NPC_LUCIEN_VEHICLE && vehicle->IsAIEnabled)
                vehicle->AI()->DoAction(ACTION_TDDC_GROW);
    }

    void Register() override
    {
        AfterHit += SpellHitFn(spell_badlands_shrink_the_world::HandleAfterHit);
    }
};

// 87777 - Search Cloud (Lucien's second button): a cloud within 15 yd (conditions: 47097, the core's nearby-entry search). The cast
// is refused with no cloud in reach (the core would carry on without a target). The search's credit is given by the vehicle to its
// driver (effect 1's KILL_CREDIT names the cloud's passenger, which a cloud never has). Not while the sun is up (the DBC's
// excludeCasterAura 87790)
class spell_badlands_search_cloud : public SpellScript
{
    PrepareSpellScript(spell_badlands_search_cloud);

    static bool InReach(Unit* giant, Creature* cloud)
    {
        float const height = giant->GetObjectScale() * LucienModelHeight
            * (giant->HasAura(SPELL_TDDC2_LUCIEN_TRANSFORM_2) ? LucienGrownModelFactor : 1.0f);
        return cloud->IsAlive() && giant->InSamePhase(cloud)
            && giant->GetExactDist2d(cloud) <= SearchCloudRange + giant->GetObjectSize() + cloud->GetObjectSize()
            && std::fabs(cloud->GetPositionZ() - giant->GetPositionZ()) <= SearchCloudRange + cloud->GetObjectSize() + height;
    }

    SpellCastResult CheckCloud()
    {
        Unit* caster = GetCaster();
        std::list<Creature*> clouds;
        caster->GetCreatureListWithEntryInGrid(clouds, NPC_TDDC2_CLOUD, 150.0f);
        for (Creature* cloud : clouds)
            if (InReach(caster, cloud))
                return SPELL_CAST_OK;
        return SPELL_FAILED_NO_VALID_TARGETS;
    }

    // The search counts here, by the reach above: the core's own nearby-entry search for effect 0 (15 yd body to body in 3D) finds
    // none of the clouds from the ground
    void HandleSearch()
    {
        if (Creature* vehicle = GetCaster()->ToCreature())
            if (vehicle->GetEntry() == NPC_LUCIEN_VEHICLE && vehicle->IsAIEnabled)
                vehicle->AI()->DoAction(ACTION_TDDC_CLOUD_SEARCHED);
    }

    void PreventCredit(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_badlands_search_cloud::CheckCloud);
        AfterCast += SpellCastFn(spell_badlands_search_cloud::HandleSearch);
        OnEffectHitTarget += SpellEffectFn(spell_badlands_search_cloud::PreventCredit, EFFECT_1, SPELL_EFFECT_KILL_CREDIT);
    }
};

// 87790 - TDDC 2: Summon the Sun: The Sun comes down 20 yd in front of the giant at his feet's height instead of 45 yd in front of
// the player (stories S2, from the client's reach check for a spell caster object)
class spell_badlands_summon_the_sun : public SpellScript
{
    PrepareSpellScript(spell_badlands_summon_the_sun);

    void SetSunSpot(SpellDestination& dest)
    {
        Unit* caster = GetCaster();
        Unit* giant = caster->GetVehicleBase() ? caster->GetVehicleBase() : caster;
        Position spot = giant->GetNearPosition(SunAhead, 0.0f);
        spot.m_positionZ = giant->GetPositionZ() + SunAbove;
        dest.Relocate(spot);
    }

    void Register() override
    {
        OnDestinationTargetSelect += SpellDestinationTargetSelectFn(spell_badlands_summon_the_sun::SetSunSpot, EFFECT_0, TARGET_DEST_CASTER_FRONT);
    }
};

// 206550 - The Sun (personal to the player, two minutes): "click on the sun" (the wiki). Its spell (87814 forcing 87802) is cast by
// the giant's story, which also puts Deathwing in his hand; the sun goes
class go_badlands_tddc_sun : public GameObjectScript
{
public:
    go_badlands_tddc_sun() : GameObjectScript("go_badlands_tddc_sun") { }

    bool OnGossipHello(Player* player, GameObject* go) override
    {
        if (Unit* base = player->GetVehicleBase())
            if (base->GetEntry() == NPC_LUCIEN_VEHICLE && base->IsAIEnabled)
            {
                base->ToCreature()->AI()->DoAction(ACTION_TDDC_SUN_CLICKED);
                go->SetRespawnTime(0);
                go->Delete();
            }
        return true;
    }
};

/*######
## The Day that Deathwing Came: What Really Happened (27715), Martek's story (TDDC 3)
######*/

enum MartekStory
{
    NPC_MARTEK_THE_AWESOME              = 46497,
    NPC_NIGHT_ELF_ADMIRER               = 47123,
    NPC_HUMAN_ADMIRER                   = 47124,
    NPC_ORC_ADMIRER                     = 47125,
    NPC_BLOOD_ELF_ADMIRER               = 47126,
    NPC_TDDC3_THELDURIN                 = 47157,
    NPC_TDDC3_GIANT_LUCIEN              = 47163,
    NPC_CAVE_IN_TRIGGER                 = 47128,
    NPC_TDDC3_CANYON_CREDIT             = 47178,
    NPC_TDDC3_MOUNTAIN_CREDIT           = 47179,
    NPC_TDDC3_ADMIRER_CREDIT            = 47123,    // "Choose an admirer to save" (47124-47126 have KillCredit1 47123)

    MENU_TDDC3_ADMIRER                  = 12204,

    SPELL_TDDC3_HOG_TRANSFORM           = 86680,
    SPELL_TDDC3_SUMMON_NIGHT_ELF        = 87823,
    SPELL_TDDC3_SUMMON_HUMAN            = 87824,
    SPELL_TDDC3_SUMMON_ORC              = 87825,
    SPELL_TDDC3_SUMMON_BLOOD_ELF        = 87826,
    SPELL_CAVE_IN                       = 87831,    // the trigger: a Cave In Stalker where its target stands, 15 s
    SPELL_CAVE_IN_PERIODIC              = 87842,    // the stalker: rocks every few seconds, 127 in 6 yd
    SPELL_TDDC3_FLY                     = 87853,
    SPELL_TDDC3_SUMMON_THELDURIN        = 87857,
    SPELL_TDDC3_SUMMON_LUCIEN           = 87858,
    SPELL_TDDC3_PUNCH_DEATHWING         = 87912,

    SEAT_HOG_MARTEK                     = 3,        // VehicleSeat 8765: the visible rider
    SEAT_HOG_ADMIRER                    = 4,        // VehicleSeat 8916 (87830 / 87847-87849 "Ride Vehicle - Seat 5")

    // 46497 text groups (the narration: "Martek Boss Whisper" spells 04a-13 and the on-accept lines; broadcast texts 47198-47216)
    TALK_TDDC3_BLOOD_RAINED             = 0,        // 47198
    TALK_TDDC3_HOT_BABES                = 1,        // 47199
    TALK_TDDC3_ROOM_FOR_ONE             = 2,        // 47200
    TALK_TDDC3_PICKED_ORC               = 3,        // 47201
    TALK_TDDC3_PICKED_HUMAN             = 4,        // 47202
    TALK_TDDC3_PICKED_NIGHT_ELF         = 5,        // 47203
    TALK_TDDC3_PICKED_BLOOD_ELF         = 6,        // 47204
    TALK_TDDC3_RODE_OFF                 = 7,        // 47205
    TALK_TDDC3_CANYON_END               = 8,        // 47206
    TALK_TDDC3_HELPFUL_EARLIER          = 9,        // 47207
    TALK_TDDC3_FLEW_TO_PILLAR           = 10,       // 47208
    TALK_TDDC3_MOMENT_ORC               = 11,       // 47213
    TALK_TDDC3_MOMENT_HUMAN             = 12,       // 47214
    TALK_TDDC3_MOMENT_NIGHT_ELF         = 13,       // 47215
    TALK_TDDC3_MOMENT_BLOOD_ELF         = 14,       // 47216
    TALK_TDDC3_ATOP_THE_PILLAR          = 15,       // 47209
    TALK_TDDC3_STOP_IT_THELDURIN        = 16,       // 47210
    TALK_TDDC3_QUIT_INTERRUPTING        = 17,       // 47211
    TALK_TDDC3_KNIFE_FIGHT              = 18,       // 47212
    TALK_TDDC3_WRONG_WAY                = 19,       // 46595

    // The admirers (47123-47126)
    TALK_ADMIRER_PICKED                 = 0,        // Woo hoo!  Martek picked me! (47230)
    TALK_ADMIRER_GOODBYE                = 1,        // 47222-47229
    // 47157 Theldurin
    TALK_TDDC3_THELDURIN_PUNCH          = 0,        // I'm gonna punch that dragon in the face! (47192, yell)

    EVENT_TDDC3_LINE_BLOOD              = EVENT_STORY_FIRST_SCENE_EVENT,
    EVENT_TDDC3_GROUND_CAMERA,
    EVENT_TDDC3_LINE_ROOM_FOR_ONE,
    EVENT_TDDC3_CONTROL,
    EVENT_TDDC3_GOODBYES,
    EVENT_TDDC3_LINE_RODE_OFF,
    EVENT_TDDC3_FLY,
    EVENT_TDDC3_LINE_FLEW,
    EVENT_TDDC3_LINE_MOMENT,
    EVENT_TDDC3_THELDURIN_COMES,
    EVENT_TDDC3_THELDURIN_PUNCHES,
    EVENT_TDDC3_LINE_STOP_IT,
    EVENT_TDDC3_LUCIEN_COMES,
    EVENT_TDDC3_LINE_INTERRUPTING,
    EVENT_TDDC3_LINE_KNIFE_FIGHT
};

struct AdmirerInfo
{
    uint32 Entry;
    uint32 SummonSpell;
    uint8 PickedLine;
    uint8 MomentLine;
};

AdmirerInfo const Admirers[] =
{
    // The whisper spells' letters (04a-d, 09a-d) carry no race; the texts do (stories U1): any fixed mapping, this one by race
    { NPC_NIGHT_ELF_ADMIRER, SPELL_TDDC3_SUMMON_NIGHT_ELF, TALK_TDDC3_PICKED_NIGHT_ELF, TALK_TDDC3_MOMENT_NIGHT_ELF },
    { NPC_HUMAN_ADMIRER,     SPELL_TDDC3_SUMMON_HUMAN,     TALK_TDDC3_PICKED_HUMAN,     TALK_TDDC3_MOMENT_HUMAN },
    { NPC_ORC_ADMIRER,       SPELL_TDDC3_SUMMON_ORC,       TALK_TDDC3_PICKED_ORC,       TALK_TDDC3_MOMENT_ORC },
    { NPC_BLOOD_ELF_ADMIRER, SPELL_TDDC3_SUMMON_BLOOD_ELF, TALK_TDDC3_PICKED_BLOOD_ELF, TALK_TDDC3_MOMENT_BLOOD_ELF }
};

// The end of the canyon (TDB 1210's map area of "Ride to the end of the canyon"; radius ours) and the pillar top with Deathwing
// (161582; radius and height ours)
Position const MartekCanyonEnd = { -6764.0f, -3179.0f, 223.0f };
float const MartekCanyonRadius = 15.0f;
Position const MartekPillarTop = { -6647.12f, -3108.92f, 340.91f };
float const MartekPillarRadius = 25.0f;
float const MartekPillarMinZ = 325.0f;
// Unpicked admirer: Martek reminds the player once this far from the camp (ours)
float const MartekReminderDistance = 40.0f;
// Theldurin runs to Deathwing; the giant Lucien walks round the pillar from the east (ours: "walks around the side of the pillar")
Position const MartekTheldurinPunchSpot = { -6651.5f, -3109.2f, 341.0f };
// From his summon point at the pillar's south-east foot (y more negative = east) down to the low ground south of it, along its
// foot and round to its west side, about 300 yd, run at his 4.29 rate in some 10 s. Points 20-25 yd apart at the terrain's height
// (ground.py on the 5.4.8 maps; no model surface on the way): the earlier two points sat 25 and 86 yd inside the rock
Position const MartekLucienWalk[] =
{
    { -6676.7f, -3215.8f, 258.1f },
    { -6700.0f, -3222.0f, 224.2f },
    { -6721.0f, -3201.0f, 225.0f },
    { -6742.0f, -3180.0f, 223.2f },
    { -6744.0f, -3156.7f, 226.6f },
    { -6746.0f, -3133.3f, 230.8f },
    { -6748.0f, -3110.0f, 238.4f },
    { -6744.7f, -3088.3f, 255.2f },
    { -6741.3f, -3066.7f, 266.4f },
    { -6738.0f, -3045.0f, 259.9f },
    { -6714.0f, -3031.5f, 256.9f },
    { -6690.0f, -3018.0f, 262.9f }
};

// 46501 - Martek's Hog (the player rides it with Martek the Awesome)
// What the player sees (wiki transcript, broadcast texts 47198-47216 and 47222-47230, comments, DBC; timings ours): blood rain
// (86675); the hog looks like the Mechano-Hog (86680) with Martek the Awesome on it; four admirers beside it (87823-87826). The Sky
// camera: "The day that Deathwing came, blood rained from the skies.", the Ground camera: "...showing my motorcycle to some hot
// babes...", "...I only had room to rescue one of them." Then the player drives, with Speed Boost (87851): talking to one admirer
// ("Hop in, baby.") puts her (him) on the back ("Woo hoo!  Martek picked me!"), "Obviously, I picked the <race>." (credit) and the
// others say goodbye and go; "We rode off down the canyon, careful to avoid falling rocks." (the Cave In Triggers along the
// trench). At the end of the canyon (credit) "...my motorcycle could fly.", "That would have been helpful to know earlier." and
// the hog flies (87853); "I flew to the top of the pillar...", "...a tender moment with the <admirer>." On the pillar top, close to
// Deathwing (credit) "Atop the pillar, I saw him: Deathwing."; Theldurin appears, yells and punches Deathwing; "Hey, stop it
// Theldurin!  This is my story!"; a giant Lucien walks round the pillar; "Cut it out guys!  Quit interrupting!"; "Fine.  You don't
// get to hear about how I beat Deathwing in a knife fight.  Your loss." (the last credit), and the story ends at the camp.
struct npc_badlands_martek_story : public npc_badlands_story_vehicle
{
    npc_badlands_martek_story(Creature* creature) : npc_badlands_story_vehicle(creature, QUEST_TDDC_MARTEK) { }

    // An admirer the player talked to ("Hop in, baby."): the first one rides along
    void SetGUID(ObjectGuid guid, int32 id) override
    {
        if (id != DATA_TDDC_ADMIRER || !_pickedGUID.IsEmpty())
            return;

        Player* player = GetPlayer();
        Creature* admirer = GetActor(guid);
        AdmirerInfo const* info = admirer ? GetAdmirerInfo(admirer->GetEntry()) : nullptr;
        if (!player || !info || !IsControlling(player))
            return;

        _pickedGUID = guid;
        _picked = info;
        admirer->EnterVehicle(me, SEAT_HOG_ADMIRER);
        sCreatureTextMgr->SendChat(admirer, TALK_ADMIRER_PICKED, player);
        Narrate(info->PickedLine, player);
        Credit(player, NPC_TDDC3_ADMIRER_CREDIT);
        _events.ScheduleEvent(EVENT_TDDC3_GOODBYES, 2s);
        _events.ScheduleEvent(EVENT_TDDC3_LINE_RODE_OFF, 6s);
    }

protected:
    uint8 WrongWayGroup() const override { return TALK_TDDC3_WRONG_WAY; }

    Creature* Narrator() override
    {
        if (Vehicle* kit = me->GetVehicleKit())
            if (Unit* martek = kit->GetPassenger(SEAT_HOG_MARTEK))
                return martek->ToCreature();
        return nullptr;
    }

    void StartScene(Player* player) override
    {
        me->CastSpell(me, SPELL_TDDC3_HOG_TRANSFORM, true);

        // Martek the Awesome on the hog's visible seat ("Martek the Awesome" on the bike, with Doomhammer: comments)
        if (Creature* martek = me->SummonCreature(NPC_MARTEK_THE_AWESOME, me->GetPosition(), TEMPSUMMON_MANUAL_DESPAWN))
        {
            Track(martek);
            martek->EnterVehicle(me, SEAT_HOG_MARTEK);
        }

        for (AdmirerInfo const& info : Admirers)
        {
            player->CastSpell(player, info.SummonSpell, true);
            if (Creature* admirer = FindOwnSummon(player, info.Entry, 40.0f))
            {
                Track(admirer);
                _admirerGUIDs.push_back(admirer->GetGUID());
            }
        }

        _events.ScheduleEvent(EVENT_TDDC3_LINE_BLOOD, 1s);
        _events.ScheduleEvent(EVENT_TDDC3_GROUND_CAMERA, 6s);
        _events.ScheduleEvent(EVENT_TDDC3_LINE_ROOM_FOR_ONE, 10s);
        _events.ScheduleEvent(EVENT_TDDC3_CONTROL, 14s);
    }

    void OnCheck(Player* player) override
    {
        if (!IsControlling(player))
            return;

        // The choice comes first (the wiki and the comments: "Choose to either save...", then "We rode off down the canyon"): a
        // player who rides off without picking hears Martek's "...I only had room to rescue one of them." again once he is away
        // from the camp and once more at the end of the canyon, which gives nothing until an admirer rides along (or was picked
        // in an earlier telling). The admirers wait at the camp. Ours: no source says what Martek did then
        bool const admirerDone = _picked || CreditCount(player, NPC_TDDC3_ADMIRER_CREDIT);
        if (!admirerDone && !_remindedAway && me->GetExactDist2d(&_story->ReturnPos) > MartekReminderDistance)
        {
            _remindedAway = true;
            Narrate(TALK_TDDC3_ROOM_FOR_ONE, player);
        }

        if (!_canyon && me->GetExactDist2d(&MartekCanyonEnd) <= MartekCanyonRadius
            && std::fabs(me->GetPositionZ() - MartekCanyonEnd.GetPositionZ()) <= 15.0f)
        {
            if (!admirerDone)
            {
                if (!_remindedCanyon)
                    Narrate(TALK_TDDC3_ROOM_FOR_ONE, player);
                _remindedCanyon = true;
                return;
            }

            _canyon = true;
            Narrate(TALK_TDDC3_CANYON_END, player);
            Credit(player, NPC_TDDC3_CANYON_CREDIT);
            _events.ScheduleEvent(EVENT_TDDC3_FLY, 4s);
            return;
        }

        if (_flying && !_pillar && me->GetExactDist2d(&MartekPillarTop) <= MartekPillarRadius && me->GetPositionZ() >= MartekPillarMinZ)
        {
            _pillar = true;
            Narrate(TALK_TDDC3_ATOP_THE_PILLAR, player);
            Credit(player, NPC_TDDC3_MOUNTAIN_CREDIT);
            _events.ScheduleEvent(EVENT_TDDC3_THELDURIN_COMES, 3s);
            _events.ScheduleEvent(EVENT_TDDC3_LINE_STOP_IT, 9s);
            _events.ScheduleEvent(EVENT_TDDC3_LUCIEN_COMES, 12s);
            _events.ScheduleEvent(EVENT_TDDC3_LINE_INTERRUPTING, 17s);
            _events.ScheduleEvent(EVENT_TDDC3_LINE_KNIFE_FIGHT, 22s);
        }
    }

    void SceneEvent(uint32 eventId, Player* player) override
    {
        switch (eventId)
        {
            case EVENT_TDDC3_LINE_BLOOD:
                Narrate(TALK_TDDC3_BLOOD_RAINED, player);
                break;
            case EVENT_TDDC3_GROUND_CAMERA:
                ChangeRiderSeat(player, SEAT_CAMERA_GROUND);
                Narrate(TALK_TDDC3_HOT_BABES, player);
                break;
            case EVENT_TDDC3_LINE_ROOM_FOR_ONE:
                Narrate(TALK_TDDC3_ROOM_FOR_ONE, player);
                break;
            case EVENT_TDDC3_CONTROL:
                ChangeRiderSeat(player, SEAT_CONTROL);
                break;
            case EVENT_TDDC3_GOODBYES:
                // The ones left behind say goodbye and go (comments: three of the lines; who says which is ours)
                for (ObjectGuid const& guid : _admirerGUIDs)
                    if (guid != _pickedGUID)
                        if (Creature* admirer = GetActor(guid))
                        {
                            sCreatureTextMgr->SendChat(admirer, TALK_ADMIRER_GOODBYE, player);
                            admirer->DespawnOrUnsummon(4 * IN_MILLISECONDS);
                        }
                break;
            case EVENT_TDDC3_LINE_RODE_OFF:
                Narrate(TALK_TDDC3_RODE_OFF, player);
                break;
            case EVENT_TDDC3_FLY:
                Narrate(TALK_TDDC3_HELPFUL_EARLIER, player);
                me->CastSpell(me, SPELL_TDDC3_FLY, true);
                _flying = true;
                _events.ScheduleEvent(EVENT_TDDC3_LINE_FLEW, 4s);
                break;
            case EVENT_TDDC3_LINE_FLEW:
                Narrate(TALK_TDDC3_FLEW_TO_PILLAR, player);
                if (_picked)
                    _events.ScheduleEvent(EVENT_TDDC3_LINE_MOMENT, 5s);
                break;
            case EVENT_TDDC3_LINE_MOMENT:
                if (_picked && !_pillar)
                    Narrate(_picked->MomentLine, player);
                break;
            case EVENT_TDDC3_THELDURIN_COMES:
                player->CastSpell(player, SPELL_TDDC3_SUMMON_THELDURIN, true);
                if (Creature* theldurin = FindOwnSummon(player, NPC_TDDC3_THELDURIN, 120.0f))
                {
                    _theldurinGUID = theldurin->GetGUID();
                    Track(theldurin);
                    sCreatureTextMgr->SendChat(theldurin, TALK_TDDC3_THELDURIN_PUNCH, player);
                    theldurin->SetWalk(false);
                    theldurin->GetMotionMaster()->MovePoint(1, MartekTheldurinPunchSpot);
                }
                _events.ScheduleEvent(EVENT_TDDC3_THELDURIN_PUNCHES, 3s);
                break;
            case EVENT_TDDC3_THELDURIN_PUNCHES:
                if (Creature* theldurin = GetActor(_theldurinGUID))
                {
                    if (Creature* deathwing = theldurin->FindNearestCreature(NPC_TDDC_DEATHWING, 20.0f))
                    {
                        theldurin->SetFacingToObject(deathwing);
                        theldurin->CastSpell(deathwing, SPELL_TDDC3_PUNCH_DEATHWING, true);
                    }
                    theldurin->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK_UNARMED);
                }
                break;
            case EVENT_TDDC3_LINE_STOP_IT:
                Narrate(TALK_TDDC3_STOP_IT_THELDURIN, player);
                break;
            case EVENT_TDDC3_LUCIEN_COMES:
                player->CastSpell(player, SPELL_TDDC3_SUMMON_LUCIEN, true);
                if (Creature* lucien = FindOwnSummon(player, NPC_TDDC3_GIANT_LUCIEN, 150.0f))
                {
                    Track(lucien);
                    std::vector<Position> path;
                    path.push_back(lucien->GetPosition());
                    for (Position const& point : MartekLucienWalk)
                        path.push_back(point);
                    lucien->SetWalk(false);
                    lucien->GetMotionMaster()->MoveSmoothPath(1, path.data(), path.size(), false, false);
                }
                break;
            case EVENT_TDDC3_LINE_INTERRUPTING:
                Narrate(TALK_TDDC3_QUIT_INTERRUPTING, player);
                break;
            case EVENT_TDDC3_LINE_KNIFE_FIGHT:
                Narrate(TALK_TDDC3_KNIFE_FIGHT, player);
                Credit(player, NPC_TDDC_DEATHWING);
                EndIn(4s);
                break;
            default:
                break;
        }
    }

private:
    static AdmirerInfo const* GetAdmirerInfo(uint32 entry)
    {
        for (AdmirerInfo const& info : Admirers)
            if (info.Entry == entry)
                return &info;
        return nullptr;
    }

    std::vector<ObjectGuid> _admirerGUIDs;
    ObjectGuid _pickedGUID;
    ObjectGuid _theldurinGUID;
    AdmirerInfo const* _picked = nullptr;
    bool _canyon = false;
    bool _remindedAway = false;
    bool _remindedCanyon = false;
    bool _flying = false;
    bool _pillar = false;
};

// 47123-47126 - the admirers (summoned private to the player beside the hog)
// "You pick one by talking to them" (gossip 12204 "Hop in, baby.", both TDBs): the player talks to one from the hog's seat (it
// allows interaction); the first one picked rides along, a later pick does nothing
struct npc_badlands_tddc_admirer : public ScriptedAI
{
    npc_badlands_tddc_admirer(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
    }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 /*gossipListId*/) override
    {
        if (menuId != MENU_TDDC3_ADMIRER)
            return false;

        CloseGossipMenuFor(player);
        if (Unit* hog = player->GetVehicleBase())
            if (hog->GetEntry() == NPC_MARTEKS_HOG && hog->IsAIEnabled && !me->GetVehicle())
                hog->ToCreature()->AI()->SetGUID(me->GetGUID(), DATA_TDDC_ADMIRER);
        return true;
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    void UpdateAI(uint32 /*diff*/) override { }
};

// 47128 - Cave In Trigger (23 along the trench, phase 310): rocks fall where Martek's hog passes ("careful to avoid falling rocks",
// the wiki; "falling rocks hit you", comments). Each trigger casts Cave In (87831) at a hog it sees within 40 yd, then waits 10 s
// (range and pace ours)
struct npc_badlands_tddc_cave_in_trigger : public ScriptedAI
{
    npc_badlands_tddc_cave_in_trigger(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        me->SetReactState(REACT_PASSIVE);
        _timer = 1 * IN_MILLISECONDS;
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void UpdateAI(uint32 diff) override
    {
        if (_timer > diff)
        {
            _timer -= diff;
            return;
        }
        _timer = 1 * IN_MILLISECONDS;

        std::list<Creature*> hogs;
        me->GetCreatureListWithEntryInGrid(hogs, NPC_MARTEKS_HOG, 40.0f);
        for (Creature* hog : hogs)
        {
            if (!hog->IsAlive() || !me->InSamePhase(hog) || !me->IsWithinLOSInMap(hog) || !me->IsValidAttackTarget(hog))
                continue;

            me->CastSpell(hog, SPELL_CAVE_IN, true);
            _timer = 10 * IN_MILLISECONDS;
            break;
        }
    }

private:
    uint32 _timer = 1 * IN_MILLISECONDS;
};

// 47129 - Cave In Stalker (summoned by Cave In for 15 s): the falling rocks (87842 -> 87843 -> 87841, 127 physical in 6 yd). It
// takes its trigger's faction, so that the rocks hit the hog (its own faction 35 is friendly to everyone)
struct npc_badlands_tddc_cave_in_stalker : public ScriptedAI
{
    npc_badlands_tddc_cave_in_stalker(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        me->SetFaction(summoner->GetFaction());
        me->SetReactState(REACT_PASSIVE);
        me->CastSpell(me, SPELL_CAVE_IN_PERIODIC, true);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
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

    // Saved on the pillar top during Martek's last scene (his hog hovers there, 115 yd above the canyon, on "ground"): set down too
    static bool OnPillarTop(Player* player)
    {
        return player->GetExactDist2d(&MartekPillarTop) <= 40.0f && player->GetPositionZ() > 300.0f;
    }
};

void AddSC_badlands_stories()
{
    new creature_script<npc_badlands_storyteller>("npc_badlands_storyteller");
    new creature_script<npc_badlands_tddc_actor>("npc_badlands_tddc_actor");
    new creature_script<npc_badlands_theldurin_story>("npc_badlands_theldurin_story");
    new spell_script<spell_badlands_theldurins_fist>("spell_badlands_theldurins_fist");
    new creature_script<npc_badlands_tddc_deathwing>("npc_badlands_tddc_deathwing");
    new creature_script<npc_badlands_lucien_story>("npc_badlands_lucien_story");
    new spell_script<spell_badlands_shrink_the_world>("spell_badlands_shrink_the_world");
    new spell_script<spell_badlands_search_cloud>("spell_badlands_search_cloud");
    new spell_script<spell_badlands_summon_the_sun>("spell_badlands_summon_the_sun");
    new go_badlands_tddc_sun();
    new creature_script<npc_badlands_martek_story>("npc_badlands_martek_story");
    new creature_script<npc_badlands_tddc_admirer>("npc_badlands_tddc_admirer");
    new creature_script<npc_badlands_tddc_cave_in_trigger>("npc_badlands_tddc_cave_in_trigger");
    new creature_script<npc_badlands_tddc_cave_in_stalker>("npc_badlands_tddc_cave_in_stalker");
    new player_badlands_stories();
}
