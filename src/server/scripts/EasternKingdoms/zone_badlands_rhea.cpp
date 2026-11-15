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
SDName: Badlands, Rhea's events
SDComment: Quest support: 27769 Rhea Revealed
SDCategory: Badlands
EndScriptData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "Group.h"
#include "WorldSession.h"

enum RheaEvents
{
    QUEST_RHEA_REVEALED                         = 27769,

    NPC_RHEA                                    = 46654,    // Rhea Revealed's objective: "Discover Rhea's true identity"

    // Rhea 46654: creature_text groups, all personal (TextRange 5): every copy of her is quest-invisible to whoever is outside
    // her window (80852), and text reaches everyone in range whether or not they see the speaker
    TALK_RHEA_REVEALED                          = 0,        // BT 46758 "Deathwing's madness overcomes him ..."
};

// Who of a player's group gets a credit the player earned in a scripted event (decisions R4 as amended by the user): only the
// playerbots beside the player, who cannot play the event themselves. Other real players earn their own
uint32 const RheaBotCreditRangeYd = 40;

// Credits the player's playerbots within 40 yd of the player that hold the quest incomplete
static void CreditRheaBots(Player* player, uint32 questId, uint32 creditEntry)
{
    Group* group = player->GetGroup();
    if (!group)
        return;

    for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
    {
        Player* member = ref->GetSource();
        if (!member || member == player || !member->GetSession()->IsBot() || !member->IsInMap(player)
            || !member->IsWithinDistInMap(player, float(RheaBotCreditRangeYd)))
            continue;

        if (member->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
            member->KilledMonsterCredit(creditEntry);
    }
}

// 46654 - Rhea (every copy: the camp in Lethlor Ravine, and the staging copies at Dragon's Mouth, New Kargath and the Hidden Clutch)
// Replaces her SmartAI (ids 0-2: Rhea Revealed's line on accept and the credit 7 s later to the last invoker only).
// Rhea Revealed 27769: on accept she says her line (BT 46758, emote 5: the wiki's notes), and 7 s later the player "discovers
// her true identity": the credit completes the quest, spell_area 59073 moves the player to phasemask 2 and Rheastrasza 46655
// stands where Rhea stood (the swap is mop's, unchanged). Each accept keeps its own timer, so several players or bots who take
// it within 7 s are all credited; the credit also goes to the accepter's playerbots within 40 yd (R4 as amended; ours)
struct npc_badlands_rhea : public ScriptedAI
{
    npc_badlands_rhea(Creature* creature) : ScriptedAI(creature) { }

    void OnQuestAccept(Player* player, Quest const* quest) override
    {
        switch (quest->GetQuestId())
        {
            case QUEST_RHEA_REVEALED:
                Talk(TALK_RHEA_REVEALED, player);
                Schedule(player->GetGUID(), QUEST_RHEA_REVEALED, NPC_RHEA, 7 * IN_MILLISECONDS);
                break;
            default:
                break;
        }
    }

    void UpdateAI(uint32 diff) override
    {
        for (auto itr = _pending.begin(); itr != _pending.end();)
        {
            if (itr->timer > diff)
            {
                itr->timer -= diff;
                ++itr;
                continue;
            }

            if (Player* player = ObjectAccessor::GetPlayer(*me, itr->playerGUID))
            {
                if (player->GetQuestStatus(itr->questId) == QUEST_STATUS_INCOMPLETE)
                    player->KilledMonsterCredit(itr->creditEntry);
                CreditRheaBots(player, itr->questId, itr->creditEntry);
            }
            itr = _pending.erase(itr);
        }
    }

private:
    struct PendingCredit
    {
        ObjectGuid playerGUID;
        uint32 questId;
        uint32 creditEntry;
        uint32 timer;
    };

    void Schedule(ObjectGuid playerGUID, uint32 questId, uint32 creditEntry, uint32 delay)
    {
        _pending.push_back({ playerGUID, questId, creditEntry, delay });
    }

    std::list<PendingCredit> _pending;
};

void AddSC_badlands_rhea()
{
    new creature_script<npc_badlands_rhea>("npc_badlands_rhea");
}
