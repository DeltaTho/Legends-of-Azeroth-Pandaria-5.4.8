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
SDComment: Quest support: 27769 Rhea Revealed, 27770 Lifting the Veil
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
    QUEST_LIFTING_THE_VEIL                      = 27770,

    NPC_RHEA                                    = 46654,    // Rhea Revealed's objective: "Discover Rhea's true identity"
    NPC_NYXONDRA                                = 46658,    // Lifting the Veil's objective: "Witness the final piece of Rhea's studies"

    // Rhea 46654: creature_text groups, all personal (TextRange 5): every copy of her is quest-invisible to whoever is outside
    // her window (80852), and text reaches everyone in range whether or not they see the speaker
    TALK_RHEA_REVEALED                          = 0,        // BT 46758 "Deathwing's madness overcomes him ..."
    TALK_RHEA_LIFT_THE_VEIL                     = 1,        // BT 46757 "I will now remove the fog from your eyes.  Behold, our captive."
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
// stands where Rhea stood (the swap is mop's, unchanged).
// Lifting the Veil 27770: on accept she says "I will now remove the fog from your eyes. Behold, our captive." (BT 46757, the
// wiki's notes) and Nyxondra appears to the south (her quest invisibility 83305 against the detection 87007 that the accept
// gives: section B); the quest needs no fight, "just stand there ... turn in the quest" (comments 2010-11-29, 2010-12-03): 3 s
// after the accept (ours) the player has witnessed the captive. Nyxondra cannot be killed at this point (27771, section A), so
// her kill credit is given by Rhea.
// Both happen in front of Rhea, so both run from her: at the accept from her, and otherwise (the quest taken by a party share,
// or a timer lost to a relog or to her grid unloading) as soon as the player holding the quest in progress stands within 30 yd
// of a Rhea copy the player can see (ours: the sources put the reveal and the veil at her; a share taken far away completes when
// the player comes to her). Each player has his own timer, so several players or bots are all credited; the credit also goes to
// the player's playerbots within 40 yd (R4 as amended; ours). A bot standing at her is credited on its own as well.
// Rheastrasza's Gift 27858 / 27898 is started from the quest (quest_badlands_rheas_gift), however it was taken
struct npc_badlands_rhea : public ScriptedAI
{
    npc_badlands_rhea(Creature* creature) : ScriptedAI(creature), _scanTimer(RheaScanMs) { }

    void OnQuestAccept(Player* player, Quest const* quest) override
    {
        Begin(player, quest->GetQuestId());
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
                {
                    player->KilledMonsterCredit(itr->creditEntry);
                    CreditRheaBots(player, itr->questId, itr->creditEntry);
                }
            }
            itr = _pending.erase(itr);
        }

        if (_scanTimer > diff)
        {
            _scanTimer -= diff;
            return;
        }

        _scanTimer = RheaScanMs;
        std::list<Player*> players;
        me->GetPlayerListInGrid(players, RheaScanRangeYd);
        for (Player* player : players)
        {
            if (!player->IsAlive() || !player->CanSeeOrDetect(me))
                continue;

            for (uint32 questId : { uint32(QUEST_RHEA_REVEALED), uint32(QUEST_LIFTING_THE_VEIL) })
                if (player->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
                    Begin(player, questId);
        }
    }

private:
    static constexpr uint32 RheaScanMs = 2 * IN_MILLISECONDS;
    static constexpr float RheaScanRangeYd = 30.0f;

    struct PendingCredit
    {
        ObjectGuid playerGUID;
        uint32 questId;
        uint32 creditEntry;
        uint32 timer;
    };

    // Her line and the player's timer, once per player and quest while it runs
    void Begin(Player* player, uint32 questId)
    {
        uint8 textId;
        uint32 creditEntry;
        uint32 delay;
        switch (questId)
        {
            case QUEST_RHEA_REVEALED:
                textId = TALK_RHEA_REVEALED;
                creditEntry = NPC_RHEA;
                delay = 7 * IN_MILLISECONDS;
                break;
            case QUEST_LIFTING_THE_VEIL:
                textId = TALK_RHEA_LIFT_THE_VEIL;
                creditEntry = NPC_NYXONDRA;
                delay = 3 * IN_MILLISECONDS;
                break;
            default:
                return;
        }

        if (player->GetQuestStatus(questId) != QUEST_STATUS_INCOMPLETE)
            return;

        for (PendingCredit const& pending : _pending)
            if (pending.playerGUID == player->GetGUID() && pending.questId == questId)
                return;

        Talk(textId, player);
        _pending.push_back({ player->GetGUID(), questId, creditEntry, delay });
    }

    std::list<PendingCredit> _pending;
    uint32 _scanTimer;
};

void AddSC_badlands_rhea()
{
    new creature_script<npc_badlands_rhea>("npc_badlands_rhea");
}
