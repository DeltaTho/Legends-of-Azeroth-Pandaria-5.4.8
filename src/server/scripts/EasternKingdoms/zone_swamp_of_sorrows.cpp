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

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedEscortAI.h"
#include "CellImpl.h"
#include "CreatureTextMgr.h"
#include "GameObject.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "Group.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "TemporarySummon.h"
#include "WorldSession.h"

/*######
## npc_galen_goodward
######*/

enum Galen
{
    QUEST_GALENS_ESCAPE     = 1393,
    GO_GALENS_CAGE          = 37118,
    SAY_PERIODIC            = 0,
    SAY_QUEST_ACCEPTED      = 1,
    SAY_ATTACKED            = 2,
    SAY_QUEST_COMPLETE      = 3,
    EMOTE_WHISPER           = 4,
    EMOTE_DISAPPEAR         = 5
};

class npc_galen_goodward : public CreatureScript
{
public:
    npc_galen_goodward() : CreatureScript("npc_galen_goodward") { }

    bool OnQuestAccept(Player* player, Creature* creature, Quest const* quest) override
    {
        if (quest->GetQuestId() == QUEST_GALENS_ESCAPE)
        {
            creature->SetFaction(FACTION_ESCORT_N_NEUTRAL_ACTIVE);
            creature->AI()->Talk(SAY_QUEST_ACCEPTED, player);
            if (npc_galen_goodwardAI* pEscortAI = CAST_AI(npc_galen_goodward::npc_galen_goodwardAI, creature->AI()))
                pEscortAI->Start(false, false, player->GetGUID(), quest);
        }
        return true;
    }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_galen_goodwardAI(creature);
    }

    struct npc_galen_goodwardAI : public npc_escortAI
    {
        npc_galen_goodwardAI(Creature* creature) : npc_escortAI(creature)
        {
            galensCageGUID.Clear();
            periodicSay = 6000;
        }

        void Reset() override
        {
            periodicSay = 6000;
        }

        void JustEngagedWith(Unit* who) override
        {
            if (HasEscortState(STATE_ESCORT_ESCORTING))
                Talk(SAY_ATTACKED, who);
        }

        void WaypointStart(uint32 pointId) override
        {
            switch (pointId)
            {
                case 0:
                {
                    GameObject* cage = nullptr;
                    if (galensCageGUID)
                        cage = ObjectAccessor::GetGameObject(*me, galensCageGUID);
                    else
                        cage = me->FindNearestGameObject(GO_GALENS_CAGE, INTERACTION_DISTANCE);
                    if (cage)
                    {
                        cage->UseDoorOrButton();
                        galensCageGUID = cage->GetGUID();
                    }
                    break;
                }
                case 21:
                    Talk(EMOTE_DISAPPEAR);
                    break;
            }
        }

        void WaypointReached(uint32 waypointId) override
        {
            switch (waypointId)
            {
                case 0:
                    if (GameObject* cage = ObjectAccessor::GetGameObject(*me, galensCageGUID))
                        cage->ResetDoorOrButton();
                    break;
                case 20:
                    if (Player* player = GetPlayerForEscort())
                    {
                        me->SetFacingToObject(player);
                        Talk(SAY_QUEST_COMPLETE, player);
                        Talk(EMOTE_WHISPER, player);
                        player->GroupEventHappens(QUEST_GALENS_ESCAPE, me);
                    }
                    SetRun(true);
                    break;
            }
        }

        void UpdateEscortAI(uint32 diff) override
        {
            if (periodicSay < diff)
            {
                if (!HasEscortState(STATE_ESCORT_ESCORTING))
                    Talk(SAY_PERIODIC);
                periodicSay = 15000;
            }
            else
                periodicSay -= diff;

            npc_escortAI::UpdateEscortAI(diff);
        }

    private:
        ObjectGuid galensCageGUID;
        uint32 periodicSay;
    };
};

/*######
## Remember the Light (24913, Alliance): Velen comes for Magtoor
######*/

enum RememberTheLight
{
    QUEST_REMEMBER_THE_LIGHT            = 24913,

    NPC_RTL_PROPHET_VELEN               = 46986,
    NPC_RTL_EXODAR_PORTAL               = 46988,
    NPC_RTL_ANCHORITE_AVUUN             = 47001,
    NPC_RTL_MAGTOOR                     = 47004,
    NPC_RTL_PROXY_CREDIT                = 47541,    // "Magtoor passed on"

    SPELL_RTL_MASTER_SUMMON_TRIGGER     = 87530,    // the quest's start spell: summons the portal (personal, 240 s)
    SPELL_RTL_SUMMON_AVUUN              = 87534,    // 47001 on the resident Avuun's spot and facing (personal, no duration)
    SPELL_RTL_SUMMON_VELEN              = 87536,    // 46986 at the portal (personal, 240 s)
    SPELL_RTL_SUMMON_MAGTOOR            = 87538,    // 47004 in the resident Magtoor's bed, same facing (personal, no duration)
    SPELL_RTL_EXODAR_PORTAL_STATE       = 87488,    // the portal's look (visual 18486)
    SPELL_RTL_EXTREME_UNCTION           = 87524,    // Velen's channel on Magtoor; ticks Rise to the Light 87525 (the light)
    SPELL_RTL_SCENE_INVISIBILITY        = 81717,    // Generic Quest Invisibility 14 (type 22) on the portal and the actors
    SPELL_RTL_SCENE_DETECTION           = 81742,    // its detection: spell_area while 24913 is in progress, kept past the credit

    TALK_RTL_AVUUN_NOTHING              = 0,        // 47001: bt 47047 "Even now, nothing..."
    TALK_RTL_AVUUN_PROPHET              = 1,        // 47001: bt 47048 "Prophet Velen!"
    TALK_RTL_AVUUN_THANK_YOU            = 2,        // 47001: bt 47049 "...thank you, Prophet..."
    TALK_RTL_VELEN_DECADES              = 0,        // 46986: bt 47041 "Some have spent decades..."
    TALK_RTL_VELEN_SUFFERING            = 1,        // 46986: bt 47042 "The Light wishes suffering on none..."
    TALK_RTL_VELEN_BATTLE               = 2,        // 46986: bt 47043 "Even now, the true battle..."
    TALK_RTL_VELEN_READY                = 3,        // 46986: bt 47044 "Magtoor, you have endured your plight bravely..."
    TALK_RTL_VELEN_RAISE_YOU            = 4,        // 46986: bt 47045 "Then may the Light save you and raise you up."
    TALK_RTL_VELEN_REMEMBER             = 5,        // 46986: bt 47046 "Remember, Avuun. Not all who wander are lost."
    TALK_RTL_MAGTOOR_YES                = 0,        // 47004: bt 47051 "Yes..."

    // The rows' emotes (creature_text keeps Emote 0 for these entries): played once per line, not once per viewer
    EMOTE_RTL_QUESTION                  = 6,
    EMOTE_RTL_EXCLAMATION               = 5,
    EMOTE_RTL_TALK_PRIEST               = 396,
    EMOTE_RTL_THANKS                    = 273,

    POINT_RTL_VELEN_ARRIVED             = 1,
    POINT_RTL_VELEN_LEFT                = 2,

    DATA_RTL_SCENE                      = 1,        // GetData: 1 while the portal's scene is starting, running or ending
    DATA_RTL_ENDING                     = 2,        // GetData: 1 once it has credited (Velen is leaving)
    ACTION_RTL_ABORT                    = 1,
    ACTION_RTL_SHARE_WITH_GROUP         = 2,
};

enum RtlStep : uint32
{
    RTL_STEP_AVUUN_DESPAIRS             = 1,
    RTL_STEP_PORTAL_OPENS,
    RTL_STEP_VELEN_STEPS_THROUGH,
    RTL_STEP_VELEN_DECADES,
    RTL_STEP_AVUUN_PROPHET,
    RTL_STEP_VELEN_SUFFERING,
    RTL_STEP_VELEN_BATTLE,
    RTL_STEP_VELEN_ASKS_MAGTOOR,
    RTL_STEP_MAGTOOR_YES,
    RTL_STEP_VELEN_RAISE_YOU,
    RTL_STEP_EXTREME_UNCTION,
    RTL_STEP_MAGTOOR_GONE,
    RTL_STEP_VELEN_REMEMBER,
    RTL_STEP_AVUUN_THANKS,
    RTL_STEP_AVUUN_FACES_BED,
    RTL_STEP_CREDIT_VELEN_LEAVES,
    RTL_STEP_PORTAL_CLOSES,
    RTL_STEP_CHECK_VIEWERS,                         // not a cue: every RtlViewerCheckMs while the scene runs
};

struct RtlCue
{
    uint32 atMs;                                    // after the accept
    RtlStep step;
};

// ===== Remember the Light: the scene's choices, in one place =====
// Sourced (wiki quest_24913 "On accept"; Wowhead 24913 2011-08-11 [+14], 2010-12-18 [+20]; DBC spells 87524-87538; the summon
// spells' SummonProperties are personal): it plays when the quest is accepted, as a personal scene; the order of what happens and
// of the lines (Avuun's despair first, then the portal opens and Velen steps through); he channels Extreme Unction on Magtoor, light
// fills the room and Magtoor disappears; Velen walks back to the portal and returns to the Exodar; the quest completes at the end.
// Ours, built as the plan's defaults while user question 6 (plan section 14) is open:
//  (a) the times below, about 53 s to the credit. Another length: change the atMs values (keep their order).
//  (b) the scene is shown to the player and those of his group who hold the quest in progress (RtlSceneSharedWithGroup); every
//      line goes to each of them alone (personal text), so nobody else in the house sees or hears it. "Others saw it": no private
//      owner, no scene invisibility and range-0 text; the residents would then have to be hidden from everyone in the house during
//      anyone's scene, so it is not a one-line change.
//  (c) Avuun's "I have failed you, my friend" (bt 46964) and Magtoor's "It is my time, Avuun" (bt 46965) are not said: no source
//      places them. If they opened the scene: creature_text 47001 group 3 / 47004 group 1 and two cues before
//      RTL_STEP_AVUUN_DESPAIRS (everything after moves back about 6 s); if they were the residents' ambient lines: 17127 group 0-1
//      and 1776 group 1 (reserved) with a timer of their own, said only to players who see the residents.
//  (d) the portal's look is the DBC's "Exodar Portal State" 87488 on the invisible portal unit (RtlPortalVisual). Another look
//      would be another aura or a gameobject here.
//  (e) Velen walks from the portal to the bed and back (RtlVelenWalks); false: he appears beside the bed and vanishes there.
static constexpr RtlCue RtlTimeline[] =
{
    {  1000, RTL_STEP_AVUUN_DESPAIRS        },      // Avuun: "Even now, nothing. Why?..." (question emote)
    {  3000, RTL_STEP_PORTAL_OPENS          },      // the portal from the Exodar opens by the door
    {  4500, RTL_STEP_VELEN_STEPS_THROUGH   },      // Velen comes out of the portal and walks to the bed (about 2 s)
    {  7500, RTL_STEP_VELEN_DECADES         },      // Velen: "Some have spent decades..."
    { 10500, RTL_STEP_AVUUN_PROPHET         },      // Avuun turns to him: "Prophet Velen!" (exclamation)
    { 13500, RTL_STEP_VELEN_SUFFERING       },      // Velen: "The Light wishes suffering on none..."
    { 19500, RTL_STEP_VELEN_BATTLE          },      // Velen: "Even now, the true battle..."
    { 27000, RTL_STEP_VELEN_ASKS_MAGTOOR    },      // Velen turns to the bed: "Magtoor, ... Are you ready...?"
    { 33000, RTL_STEP_MAGTOOR_YES           },      // Magtoor: "Yes..."
    { 36000, RTL_STEP_VELEN_RAISE_YOU       },      // Velen: "Then may the Light save you and raise you up."
    { 38000, RTL_STEP_EXTREME_UNCTION       },      // Velen channels Extreme Unction on Magtoor (5 s, the light)
    { 43000, RTL_STEP_MAGTOOR_GONE          },      // Magtoor disappears
    { 45000, RTL_STEP_VELEN_REMEMBER        },      // Velen turns to Avuun: "Remember, Avuun. Not all who wander are lost."
    { 50000, RTL_STEP_AVUUN_THANKS          },      // Avuun: "...thank you, Prophet..."
    { 52500, RTL_STEP_AVUUN_FACES_BED       },      // Avuun turns back to where the resident faces (no snap at the swap)
    { 53500, RTL_STEP_CREDIT_VELEN_LEAVES   },      // the credit; Avuun's copy goes, the resident is back; Velen walks to the portal
    { 59500, RTL_STEP_PORTAL_CLOSES         },      // whatever is left goes, the portal closes
};
static constexpr bool RtlSceneSharedWithGroup   = true;
static constexpr bool RtlPortalVisual           = true;
static constexpr bool RtlVelenWalks             = true;

static constexpr uint32 RtlViewerCheckMs        = 500;
static constexpr uint32 RtlMaxDurationMs        = 240000;   // 87530's duration
static constexpr uint32 AREA_THE_HARBORAGE      = 657;
static constexpr float RtlStartRange            = 25.0f;    // a player holding the quest this close to Avuun with no scene gets one
static constexpr float RtlHearRange             = 60.0f;    // the lines reach the scene's viewers this close to the portal
static constexpr float RtlStayRange             = 100.0f;   // a holder of the quest keeps the scene going and is credited while in
                                                            // The Harborage or this close to Avuun
static constexpr float RtlSearchRange           = 160.0f;   // covers The Harborage from the portal (its far edge is about 145 yd)
static constexpr float RtlDeadCreditRange       = 40.0f;    // a dead holder (corpse or ghost) is credited this close to Avuun

Position const RtlPortalSpot = { -10106.0f, -2755.07f, 25.3386f, 6.09001f };    // spell_target_position 87530 / 87536 (both TDBs)
Position const RtlVelenSpot  = { -10101.9f, -2756.57f, 25.3471f, 6.24392f };    // ours: by the bed (the old SmartAI scene's spot)
Position const RtlAvuunSpot  = { -10096.9f, -2754.94f, 25.4567f, 4.55531f };    // the resident Avuun's spawn = 87534's target

// Players who see a scene's portal and actors as far as privacy goes: its owner, or the owner's group for a group scene
// (WorldObject::CheckPrivateObjectOwnerVisibility), within range of the portal, alive or dead
static void GetRtlViewers(Creature* portal, std::vector<Player*>& viewers, float range)
{
    std::list<Player*> players;
    Trinity::AnyPlayerInObjectRangeCheck check(portal, range, false);
    Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcher(portal, players, check);
    portal->VisitNearbyWorldObject(range, searcher);

    for (Player* player : players)
        if (player->IsInWorld() && portal->CheckPrivateObjectOwnerVisibility(player))
            viewers.push_back(player);
}

// A holder of the quest who belongs to the scene: still in The Harborage or near Avuun; a dead one only near Avuun
static bool IsRtlParticipant(Player* player)
{
    if (player->GetQuestStatus(QUEST_REMEMBER_THE_LIGHT) != QUEST_STATUS_INCOMPLETE)
        return false;

    float dist = player->GetExactDist(&RtlAvuunSpot);
    if (!player->IsAlive())
        return dist <= RtlDeadCreditRange;
    return player->GetAreaId() == AREA_THE_HARBORAGE || dist <= RtlStayRange;
}

// A scene the player belongs to that is starting, running or ending. Every portal is summoned by a player's accept (or by the
// restart below), so it is among its summoner's summons: the player's own, or a group member's on the same map. A scene a member
// started before the group was formed is shared with the group when another member looks for it
static Creature* FindRtlScene(Player* player)
{
    Group* group = player->GetGroup();
    auto scan = [player, group](Player* summoner) -> Creature*
    {
        std::list<TempSummon*> portals;
        summoner->GetSummons(portals, NPC_RTL_EXODAR_PORTAL);
        for (TempSummon* portal : portals)
        {
            if (!portal->IsInWorld() || portal->IsDestroyedObject() || !portal->IsAlive() || !portal->IsAIEnabled
                || !portal->AI()->GetData(DATA_RTL_SCENE))
                continue;

            if (RtlSceneSharedWithGroup && summoner != player && group && portal->GetPrivateObjectOwner() == summoner->GetGUID())
                portal->AI()->DoAction(ACTION_RTL_SHARE_WITH_GROUP);

            if (portal->CheckPrivateObjectOwnerVisibility(player))
                return portal;
        }
        return nullptr;
    };

    if (Creature* portal = scan(player))
        return portal;

    if (group)
        for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
            if (Player* member = ref->GetSource())
                if (member != player && member->IsInWorld() && member->IsInMap(player))
                    if (Creature* portal = scan(member))
                        return portal;

    // A scene whose owner has left the group is still the group's (its private owner is the group): find it by place
    if (group)
    {
        std::list<Creature*> portals;
        player->GetCreatureListWithEntryInGrid(portals, NPC_RTL_EXODAR_PORTAL, RtlSearchRange);
        for (Creature* portal : portals)
            if (portal->IsAlive() && !portal->IsDestroyedObject() && portal->IsAIEnabled && portal->AI()->GetData(DATA_RTL_SCENE)
                && portal->GetPrivateObjectOwner() == group->GetGUID())
                return portal;
    }

    return nullptr;
}

static void CreditRtl(Player* player)
{
    if (player->GetQuestStatus(QUEST_REMEMBER_THE_LIGHT) == QUEST_STATUS_INCOMPLETE)
        player->KilledMonsterCredit(NPC_RTL_PROXY_CREDIT);
}

// 46988 - Exodar Portal: the scene's controller.
// Summoned private to the player by the quest's start spell 87530 (quest_template_addon.SourceSpellID); for a grouped player the
// portal is re-owned to his group, so the group's holders watch one scene (the actors the portal summons inherit the owner,
// Spell::EffectSummonType). One scene per group (or per ungrouped player): a portal summoned while the player belongs to a scene
// (starting, running or ending, his own too after an abandon and retake) goes at once; the scene credits him at its end, or at once
// if it has already credited. A playerbot never starts a scene: it is credited by its group's scene, or at once when none runs.
// Who sees what: the residents Anchorite Avuun 17127 and Magtoor 1776 carry quest invisibility (template auras 49414 / 49415, both
// TDBs); spell_area in The Harborage gives 49416 (sees Avuun) unless 24913 is in progress and 49417 (sees Magtoor) only before it is
// taken. The portal and the actors carry Generic Quest Invisibility 14 (81717, type 22; template addons), seen only with its
// detection 81742, which spell_area gives in The Harborage while 24913 is in progress. So a holder sees the copies in place of the
// residents; everyone else, a group member who has not taken it or has done it included, sees the residents and nothing of the
// scene. The credited keep the detection until the portal closes, so they see Velen walk out; nobody else sees him.
// It ends early, without credit and with every actor gone, when no holder belongs to it any more (IsRtlParticipant: walked out of
// The Harborage, logged out, released his ghost, abandoned), at the 240 s limit, or when the owner leaves the world (a player's
// summons are unsummoned then). Whoever still holds the quest gets a new scene by coming back (player_rtl_scene_restart).
struct npc_rtl_exodar_portal : public ScriptedAI
{
    enum State
    {
        STATE_NONE,
        STATE_DISCARD,      // not a scene: goes at its first update (a bot's, or one of a player who belongs to a scene)
        STATE_STARTING,
        STATE_RUNNING,
        STATE_ENDING,       // credited; Velen is leaving
        STATE_DONE,
    };

    npc_rtl_exodar_portal(Creature* creature) : ScriptedAI(creature), _state(STATE_NONE), _elapsed(0) { }

    void IsSummonedBy(Unit* summoner) override
    {
        me->SetReactState(REACT_PASSIVE);

        Player* player = summoner->ToPlayer();
        if (!player)
        {
            _state = STATE_DISCARD;
            return;
        }

        _summonerGUID = player->GetGUID();
        if (player->GetSession()->IsBot() || FindRtlScene(player))
        {
            _state = STATE_DISCARD;
            return;
        }

        _ownerGUID = player->GetGUID();
        if (RtlSceneSharedWithGroup)
            if (Group* group = player->GetGroup())
                me->SetPrivateObjectOwner(group->GetGUID());

        // The copies come in the accept's tick, as the residents go for him
        _state = STATE_STARTING;
        me->CastSpell(me, SPELL_RTL_SUMMON_AVUUN, true);
        me->CastSpell(me, SPELL_RTL_SUMMON_MAGTOOR, true);
    }

    uint32 GetData(uint32 type) const override
    {
        switch (type)
        {
            case DATA_RTL_SCENE:
                return (_state == STATE_STARTING || _state == STATE_RUNNING || _state == STATE_ENDING) ? 1 : 0;
            case DATA_RTL_ENDING:
                return _state == STATE_ENDING ? 1 : 0;
            default:
                return 0;
        }
    }

    void DoAction(int32 action) override
    {
        if (action == ACTION_RTL_ABORT)
            Abort();
        else if (action == ACTION_RTL_SHARE_WITH_GROUP)
            ShareWithGroup();
    }

    void JustSummoned(Creature* summon) override
    {
        switch (summon->GetEntry())
        {
            case NPC_RTL_ANCHORITE_AVUUN:
                _avuunGUID = summon->GetGUID();
                break;
            case NPC_RTL_MAGTOOR:
                _magtoorGUID = summon->GetGUID();
                break;
            case NPC_RTL_PROPHET_VELEN:
                _velenGUID = summon->GetGUID();
                if (RtlVelenWalks)
                {
                    summon->SetWalk(true);
                    summon->GetMotionMaster()->MovePoint(POINT_RTL_VELEN_ARRIVED, RtlVelenSpot);
                }
                else
                    summon->NearTeleportTo(RtlVelenSpot.GetPositionX(), RtlVelenSpot.GetPositionY(), RtlVelenSpot.GetPositionZ(),
                        RtlVelenSpot.GetOrientation());
                break;
            default:
                break;
        }
    }

    // The summon has an owner (the ALLY summon makes the player its owner): it never follows him
    void JustAppeared() override { }
    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    // Unsummoned by something other than this script: its owner left the world (logout, another map), so the core removes his
    // summons. The actors go too (they also go on their own once the portal is gone)
    void Unsummoned() override
    {
        if (_state == STATE_DONE)
            return;
        _state = STATE_DONE;
        DespawnActors();
        ReleaseDetections();
    }

    void UpdateAI(uint32 diff) override
    {
        switch (_state)
        {
            case STATE_DISCARD:
                // A bot is credited unless a scene of its group runs (that one credits it); anyone whose scene has already
                // credited is credited now
                if (Player* player = ObjectAccessor::GetPlayer(*me, _summonerGUID))
                {
                    Creature* scene = FindRtlScene(player);
                    if ((scene && scene->AI()->GetData(DATA_RTL_ENDING)) || (!scene && player->GetSession()->IsBot()))
                        CreditRtl(player);
                }
                _state = STATE_DONE;
                me->DespawnOrUnsummon();
                return;
            case STATE_STARTING:
                Start();
                break;
            case STATE_NONE:
            case STATE_DONE:
                return;
            default:
                break;
        }

        _elapsed += diff;
        if (_elapsed >= RtlMaxDurationMs)
        {
            Abort();
            return;
        }

        _events.Update(diff);
        while (uint32 step = _events.ExecuteEvent())
        {
            RunStep(RtlStep(step));
            if (_state == STATE_DONE)
                return;
        }
    }

private:
    void Start()
    {
        // The ALLY summon gave the portal its summoner's faction and made him its owner after IsSummonedBy. An owned unit is always
        // visible to its owner's group (Unit::IsAlwaysVisibleFor, Visibility.GroupMode), past the private and invisibility checks:
        // the owner goes, so only holders of the quest see the portal (FindRtlScene and the logout unsummon use m_summons)
        me->SetOwnerGUID(ObjectGuid::Empty);
        me->RestoreFaction();
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC | UNIT_FLAG_NOT_SELECTABLE);
        me->UpdateObjectVisibility();

        _state = STATE_RUNNING;
        for (RtlCue const& cue : RtlTimeline)
            _events.ScheduleEvent(cue.step, cue.atMs);
        _events.ScheduleEvent(RTL_STEP_CHECK_VIEWERS, RtlViewerCheckMs);
    }

    void RunStep(RtlStep step)
    {
        Creature* avuun = Actor(_avuunGUID);
        Creature* magtoor = Actor(_magtoorGUID);
        Creature* velen = Actor(_velenGUID);

        switch (step)
        {
            case RTL_STEP_CHECK_VIEWERS:
                if (_state != STATE_RUNNING)
                    break;
                if (!HasParticipant())
                {
                    Abort();
                    return;
                }
                _events.ScheduleEvent(RTL_STEP_CHECK_VIEWERS, RtlViewerCheckMs);
                break;
            case RTL_STEP_AVUUN_DESPAIRS:
                Say(avuun, TALK_RTL_AVUUN_NOTHING, EMOTE_RTL_QUESTION);
                break;
            case RTL_STEP_PORTAL_OPENS:
                if (RtlPortalVisual)
                    me->CastSpell(me, SPELL_RTL_EXODAR_PORTAL_STATE, true);
                break;
            case RTL_STEP_VELEN_STEPS_THROUGH:
                me->CastSpell(me, SPELL_RTL_SUMMON_VELEN, true);
                break;
            case RTL_STEP_VELEN_DECADES:
                Say(velen, TALK_RTL_VELEN_DECADES, 0);
                break;
            case RTL_STEP_AVUUN_PROPHET:
                if (avuun && velen)
                    avuun->SetFacingToObject(velen);
                Say(avuun, TALK_RTL_AVUUN_PROPHET, EMOTE_RTL_EXCLAMATION);
                break;
            case RTL_STEP_VELEN_SUFFERING:
                Say(velen, TALK_RTL_VELEN_SUFFERING, EMOTE_RTL_TALK_PRIEST);
                break;
            case RTL_STEP_VELEN_BATTLE:
                Say(velen, TALK_RTL_VELEN_BATTLE, EMOTE_RTL_TALK_PRIEST);
                break;
            case RTL_STEP_VELEN_ASKS_MAGTOOR:
                if (velen && magtoor)
                    velen->SetFacingToObject(magtoor);
                Say(velen, TALK_RTL_VELEN_READY, EMOTE_RTL_TALK_PRIEST);
                break;
            case RTL_STEP_MAGTOOR_YES:
                Say(magtoor, TALK_RTL_MAGTOOR_YES, 0);
                break;
            case RTL_STEP_VELEN_RAISE_YOU:
                Say(velen, TALK_RTL_VELEN_RAISE_YOU, 0);
                break;
            case RTL_STEP_EXTREME_UNCTION:
                // TARGET_UNIT_NEARBY_ENTRY: conditions 13 name 47004; another player's Magtoor on the same spot is not his to see
                // (SpellInfo::CheckTarget, private owners), so the channel finds this scene's
                if (velen && magtoor)
                    velen->CastSpell(magtoor, SPELL_RTL_EXTREME_UNCTION, true);
                break;
            case RTL_STEP_MAGTOOR_GONE:
                if (magtoor)
                    magtoor->DespawnOrUnsummon();
                break;
            case RTL_STEP_VELEN_REMEMBER:
                if (velen && avuun)
                    velen->SetFacingToObject(avuun);
                Say(velen, TALK_RTL_VELEN_REMEMBER, EMOTE_RTL_TALK_PRIEST);
                break;
            case RTL_STEP_AVUUN_THANKS:
                Say(avuun, TALK_RTL_AVUUN_THANK_YOU, EMOTE_RTL_THANKS);
                break;
            case RTL_STEP_AVUUN_FACES_BED:
                if (avuun)
                    avuun->SetFacingTo(RtlAvuunSpot.GetOrientation());
                break;
            case RTL_STEP_CREDIT_VELEN_LEAVES:
                Finish(avuun, magtoor, velen);
                break;
            case RTL_STEP_PORTAL_CLOSES:
                _state = STATE_DONE;
                DespawnActors();
                ReleaseDetections();
                me->DespawnOrUnsummon();
                return;
            default:
                break;
        }
    }

    // The credit, to every holder who belongs to the scene (the owner, group members, playerbots). It turns the quest complete, and
    // spell_area shows the resident Avuun again in the same tick, so his copy goes now (the quest ender is usable at once). spell_area
    // also takes the scene's detection away then: the credited keep it (an aura of ours, not spell_area's) until the portal closes,
    // so they see Velen walk out, and nobody else ever sees him
    void Finish(Creature* avuun, Creature* magtoor, Creature* velen)
    {
        _state = STATE_ENDING;

        std::vector<Player*> viewers;
        GetRtlViewers(me, viewers, RtlSearchRange);
        for (Player* viewer : viewers)
        {
            if (!IsRtlParticipant(viewer))
                continue;
            CreditRtl(viewer);
            if (viewer->IsAlive() && !viewer->HasAura(SPELL_RTL_SCENE_DETECTION))
                viewer->AddAura(SPELL_RTL_SCENE_DETECTION, viewer);
            _keptDetection.insert(viewer->GetGUID());
        }

        if (avuun)
            avuun->DespawnOrUnsummon();
        if (magtoor)
            magtoor->DespawnOrUnsummon();

        if (velen)
        {
            if (RtlVelenWalks)
            {
                velen->SetWalk(true);
                velen->GetMotionMaster()->MovePoint(POINT_RTL_VELEN_LEFT, RtlPortalSpot);
            }
            else
                velen->DespawnOrUnsummon();
        }
    }

    void Abort()
    {
        if (_state == STATE_DONE)
            return;
        _state = STATE_DONE;
        _events.Reset();
        DespawnActors();
        ReleaseDetections();
        me->DespawnOrUnsummon();
    }

    bool HasParticipant()
    {
        std::vector<Player*> viewers;
        GetRtlViewers(me, viewers, RtlSearchRange);
        for (Player* viewer : viewers)
            if (IsRtlParticipant(viewer))
                return true;
        return false;
    }

    // A scene started before its owner joined a group: from now on the group sees it
    void ShareWithGroup()
    {
        Player* owner = ObjectAccessor::GetPlayer(*me, _ownerGUID);
        Group* group = owner ? owner->GetGroup() : nullptr;
        if (!group || me->GetPrivateObjectOwner() == group->GetGUID())
            return;

        me->SetPrivateObjectOwner(group->GetGUID());
        me->UpdateObjectVisibility();
        for (ObjectGuid const& guid : { _avuunGUID, _magtoorGUID, _velenGUID })
        {
            if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
            {
                actor->SetPrivateObjectOwner(group->GetGUID());
                actor->UpdateObjectVisibility();
            }
        }
    }

    // The detection kept past the credit goes: spell_area takes off what no longer fits the player's quest state where he is
    void ReleaseDetections()
    {
        for (ObjectGuid const& guid : _keptDetection)
            if (Player* player = ObjectAccessor::GetPlayer(*me, guid))
                if (player->IsInWorld() && !player->GetSession()->PlayerLogout())
                    player->UpdateAreaDependentAuras(player->GetAreaId());
        _keptDetection.clear();
    }

    void DespawnActors()
    {
        for (ObjectGuid const& guid : { _avuunGUID, _magtoorGUID, _velenGUID })
            if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                actor->DespawnOrUnsummon();
    }

    Creature* Actor(ObjectGuid const& guid) const
    {
        Creature* actor = ObjectAccessor::GetCreature(*me, guid);
        return actor && actor->IsAlive() && actor->IsInWorld() ? actor : nullptr;
    }

    // Each line goes to each viewer who sees the speaker, alone (TEXT_RANGE_PERSONAL whatever the row says): others in the house
    // hear nothing. The emote is played once (everyone who sees the speaker sees it)
    void Say(Creature* actor, uint8 group, uint32 emote)
    {
        if (!actor)
            return;

        std::vector<Player*> viewers;
        GetRtlViewers(me, viewers, RtlHearRange);
        for (Player* viewer : viewers)
            if (viewer->CanSeeOrDetect(actor))
                sCreatureTextMgr->SendChat(actor, group, viewer, CHAT_MSG_ADDON, LANG_ADDON, TEXT_RANGE_PERSONAL);

        if (emote)
            actor->HandleEmoteCommand(emote);
    }

    State _state;
    uint32 _elapsed;
    EventMap _events;
    ObjectGuid _summonerGUID;
    ObjectGuid _ownerGUID;
    ObjectGuid _avuunGUID;
    ObjectGuid _magtoorGUID;
    ObjectGuid _velenGUID;
    std::set<ObjectGuid> _keptDetection;
};

// 46986 Prophet Velen, 47001 Anchorite Avuun, 47004 Magtoor - the scene's actors, summoned by the portal. They never fight
// (passive, immune to players and NPCs, no reaction to anyone), take back their own faction (the ALLY summon gives them the
// portal's, which is the player's), and go once their portal is gone: 47001 / 47004 have no duration of their own
struct npc_rtl_scene_actor : public ScriptedAI
{
    npc_rtl_scene_actor(Creature* creature) : ScriptedAI(creature), _fresh(true), _checkTimer(1000) { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->SetReactState(REACT_PASSIVE);
    }

    // Owned by the portal (ALLY summon): never follows it
    void JustAppeared() override { }
    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type != POINT_MOTION_TYPE)
            return;

        if (id == POINT_RTL_VELEN_ARRIVED)
            me->SetFacingTo(RtlVelenSpot.GetOrientation());
        else if (id == POINT_RTL_VELEN_LEFT)
            me->DespawnOrUnsummon();     // back through the portal to the Exodar
    }

    void UpdateAI(uint32 diff) override
    {
        if (_fresh)
        {
            _fresh = false;
            me->SetOwnerGUID(ObjectGuid::Empty);   // the portal (ALLY summon); nothing reads it, the portal is found as summoner
            me->RestoreFaction();
            me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        }

        if (_checkTimer > diff)
        {
            _checkTimer -= diff;
            return;
        }
        _checkTimer = 1000;

        TempSummon* summon = me->ToTempSummon();
        Creature* portal = summon ? summon->GetSummonerCreatureBase() : nullptr;
        if (!portal || !portal->IsAlive() || !portal->IsInWorld())
            me->DespawnOrUnsummon();
    }

private:
    bool _fresh;
    uint32 _checkTimer;
};

// A player holding Remember the Light in progress near Avuun's spot, with no scene to belong to, gets one: after a scene that
// ended early (walked off, logged out, released, owner left), and when logging in there. Without it he could not see Avuun, whom
// the quest's spell_area hides from him while it is in progress. Alive, out of combat and on his feet only; a playerbot is credited
// instead (bots never start a scene), and so is anyone who reaches Avuun while his group's scene is ending (it has credited).
// Checked on every update, but only past a position test for players by the house
class player_rtl_scene_restart : public PlayerScript
{
public:
    player_rtl_scene_restart() : PlayerScript("player_rtl_scene_restart") { }

    void OnUpdate(Player* player, uint32 /*diff*/) override
    {
        if (player->GetMapId() != 0
            || player->GetExactDist2dSq(RtlAvuunSpot.GetPositionX(), RtlAvuunSpot.GetPositionY()) > RtlStartRange * RtlStartRange
            || std::fabs(player->GetPositionZ() - RtlAvuunSpot.GetPositionZ()) > 15.0f)
            return;

        if (!player->IsInWorld() || !player->IsAlive() || player->IsInCombat() || player->GetVehicle() || player->IsInFlight()
            || player->IsBeingTeleported())
            return;

        if (player->GetQuestStatus(QUEST_REMEMBER_THE_LIGHT) != QUEST_STATUS_INCOMPLETE)
            return;

        if (Creature* scene = FindRtlScene(player))
        {
            if (scene->AI()->GetData(DATA_RTL_ENDING))
                CreditRtl(player);
            return;
        }

        if (player->GetSession()->IsBot())
        {
            CreditRtl(player);
            return;
        }

        player->CastSpell(player, SPELL_RTL_MASTER_SUMMON_TRIGGER, true);
    }
};

/*######
## With Dying Breath (27911, Horde): Helgrum's last moments
######*/

enum WithDyingBreath
{
    QUEST_WITH_DYING_BREATH         = 27911,
    NPC_HELGRUM_THE_SWIFT           = 1442,

    TALK_HELGRUM_WATCH_OVER_YOU     = 0,    // 1442 group 0: bt 49703 "Be strong, Neeka. I will watch over you..." (say)
    TALK_NEEKA_CRIES                = 0,    // 47041 group 0: bt 6104 "%s cries." (text emote, EMOTE_ONESHOT_CRY)

    EVENT_WDB_HELGRUM_RISES         = 1,
    EVENT_WDB_HELGRUM_DIES,
    EVENT_WDB_NEEKA_CRIES,
    EVENT_WDB_RESTORE_DELAYS,
};

// ===== With Dying Breath: the scene's choices, in one place =====
// Sourced (wiki quest_27911 "On accept"; Wowhead 27911 2011-08-25 [+13], 2012-04-30 [+23], 2012-07-05 [+6], 2014-05-19 [+1]):
// it plays on accept; Helgrum shoots up out of bed, stands, says "Be strong, Neeka. I will watch over you..." and dies with the
// normal death animation and cry; Neeka cries; afterwards he is "there again like nothing happened", and every abandon and
// retake plays it again ("resurrected and died again and again"). Ours: the times below, 30 s until he is back in bed, and that
// it is public (everyone on the tower sees and hears it; the sources describe only what the taker saw).
// Guard: an accept plays the scene when Helgrum lies alive in his bed and no scene is under way; an accept while one is (he is
// standing, dead, or not yet back) watches that one. So each retake after he is back plays it again.
// User question 9 (plan section 14) is open: only his one sourced line is said. To add the unplaced lines (Neeka 49699 "Helgrum!",
// Helgrum 49700-49702), give them creature_text rows (47041 group 2 is reserved for 49699; 1442 groups 1-3) and say them between
// EVENT_WDB_HELGRUM_RISES and EVENT_WDB_HELGRUM_DIES at about 4 s spacing (the death moves back by about 16 s).
static constexpr uint32 WdbHelgrumRisesMs       = 1000;   // he stands up and says his line
static constexpr uint32 WdbHelgrumDiesMs        = 3500;   // he dies
static constexpr uint32 WdbNeekaCriesMs         = 4500;   // she cries
static constexpr uint32 WdbCorpseSeconds        = 25;     // his body lies by the bed this long...
static constexpr uint32 WdbRespawnSeconds       = 5;      // ...and he is back in bed (template StandState 3) this much later

// 47041 - Neeka Bloodscar
// With Dying Breath has no objective and completes on accept, so the scene carries no credit: a playerbot that takes it from her
// plays it like a player (or watches the one under way); one that got it by a share fires no accept and plays nothing. Helgrum's
// death and return use his own corpse and respawn delays, so he is back in bed even if Neeka dies meanwhile; the delays are put
// back once he is up (if Neeka is dead then, they stay 25 / 5 s until she is back: harmless, nothing else kills him). If Neeka
// dies or evades after he has stood up but before he dies, he lies down in his bed again and the scene is over.
struct npc_neeka_bloodscar : public ScriptedAI
{
    npc_neeka_bloodscar(Creature* creature) : ScriptedAI(creature), _sceneActive(false), _delaysSaved(false), _oldCorpseDelay(0),
        _oldRespawnDelay(0) { }

    void OnQuestAccept(Player* /*player*/, Quest const* quest) override
    {
        if (quest->GetQuestId() != QUEST_WITH_DYING_BREATH || _sceneActive)
            return;     // he is up and about to die: this accept watches that

        Creature* helgrum = ObjectAccessor::GetCreature(*me, _helgrumGUID);
        if (!helgrum)
            helgrum = me->FindNearestCreature(NPC_HELGRUM_THE_SWIFT, 15.0f, false);
        if (!helgrum || !helgrum->IsAlive())
            return;     // dead, or not yet back in his bed: the scene under way is the one to watch

        _helgrumGUID = helgrum->GetGUID();
        _sceneActive = true;
        _events.ScheduleEvent(EVENT_WDB_HELGRUM_RISES, WdbHelgrumRisesMs);
        _events.ScheduleEvent(EVENT_WDB_HELGRUM_DIES, WdbHelgrumDiesMs);
        _events.ScheduleEvent(EVENT_WDB_NEEKA_CRIES, WdbNeekaCriesMs);
    }

    void JustDied(Unit* /*killer*/) override
    {
        StopScene();
    }

    void EnterEvadeMode(EvadeReason why) override
    {
        StopScene();
        ScriptedAI::EnterEvadeMode(why);
    }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            Creature* helgrum = ObjectAccessor::GetCreature(*me, _helgrumGUID);
            switch (eventId)
            {
                case EVENT_WDB_HELGRUM_RISES:
                    if (helgrum && helgrum->IsAlive())
                    {
                        helgrum->SetStandState(UNIT_STAND_STATE_STAND);
                        sCreatureTextMgr->SendChat(helgrum, TALK_HELGRUM_WATCH_OVER_YOU);
                    }
                    break;
                case EVENT_WDB_HELGRUM_DIES:
                    _sceneActive = false;   // from now on "he is dead" guards the replay, until he is back in his bed
                    if (helgrum && helgrum->IsAlive())
                    {
                        // A kill by himself: no loot recipient, so no loot, experience or reputation for anyone
                        if (!_delaysSaved)
                        {
                            _oldCorpseDelay = helgrum->GetCorpseDelay();
                            _oldRespawnDelay = helgrum->GetRespawnDelay();
                            _delaysSaved = true;
                        }
                        helgrum->SetCorpseDelay(WdbCorpseSeconds);
                        helgrum->SetRespawnDelay(WdbRespawnSeconds);
                        helgrum->Kill(helgrum);
                        _events.ScheduleEvent(EVENT_WDB_RESTORE_DELAYS, Milliseconds((WdbCorpseSeconds + WdbRespawnSeconds + 1) * IN_MILLISECONDS));
                    }
                    break;
                case EVENT_WDB_NEEKA_CRIES:
                    Talk(TALK_NEEKA_CRIES);
                    break;
                case EVENT_WDB_RESTORE_DELAYS:
                    if (helgrum && helgrum->IsAlive())
                    {
                        helgrum->SetCorpseDelay(_oldCorpseDelay);
                        helgrum->SetRespawnDelay(_oldRespawnDelay);
                    }
                    else if (helgrum)
                        _events.ScheduleEvent(EVENT_WDB_RESTORE_DELAYS, 1s);
                    break;
                default:
                    break;
            }
        }

        if (UpdateVictim())
            DoMeleeAttackIfReady();
    }

private:
    // Neeka died or evaded during the scene: a Helgrum still standing lies down in his bed again and the scene is over; a dead
    // one comes back by his own delays (her restore event survives her evade, and runs after her respawn if she died)
    void StopScene()
    {
        if (!_sceneActive)
            return;
        _sceneActive = false;

        _events.CancelEvent(EVENT_WDB_HELGRUM_RISES);
        _events.CancelEvent(EVENT_WDB_HELGRUM_DIES);
        _events.CancelEvent(EVENT_WDB_NEEKA_CRIES);

        if (Creature* helgrum = ObjectAccessor::GetCreature(*me, _helgrumGUID))
            if (helgrum->IsAlive())
                helgrum->SetStandState(UNIT_STAND_STATE_SLEEP);
    }

    EventMap _events;
    ObjectGuid _helgrumGUID;
    bool _sceneActive;
    bool _delaysSaved;
    uint32 _oldCorpseDelay;
    uint32 _oldRespawnDelay;
};

void AddSC_swamp_of_sorrows()
{
    new npc_galen_goodward();
    new creature_script<npc_rtl_exodar_portal>("npc_rtl_exodar_portal");
    new creature_script<npc_rtl_scene_actor>("npc_rtl_scene_actor");
    new player_rtl_scene_restart();
    new creature_script<npc_neeka_bloodscar>("npc_neeka_bloodscar");
}
