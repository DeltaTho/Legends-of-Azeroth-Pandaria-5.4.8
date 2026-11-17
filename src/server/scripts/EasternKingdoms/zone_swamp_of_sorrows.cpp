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
    new creature_script<npc_neeka_bloodscar>("npc_neeka_bloodscar");
}
