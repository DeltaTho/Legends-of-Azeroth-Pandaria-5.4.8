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

/* Echo Isles (zone 6453), the troll starting area.
   The older Echo Isles scripts (jailor, captive scout, territorial fetish, shrink) stay in zone_durotar.cpp; what is new for the
   area goes here. Research: research\echo-isles (dossiers EI-A, EI-B, plan section EI-E). */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "QuestDef.h"
#include "CreatureTextMgr.h"
#include "CombatManager.h"
#include "Timer.h"
#include <mutex>
#include <unordered_map>
#include <vector>

/*######
## npc_echo_isles_tiki_target (38038)
## The Basics: Hitting Things (kill 6) and The Arts of X (a class spell N times) on the Darkspear Training Grounds.
## Replaces the SmartAI the target had (smart_scripts 38038, lists 3803800-3803802), which it ports, and adds two things:
## - Combat with a player ends 5 s after his last hit or spell on the target (ours; npc_training_dummy's timer). Under SmartAI the
##   target disabled evade and its "combat stop" row ran out of combat only, so a target hit once and left alive kept the player in
##   combat (no eating, drinking or out-of-combat regen) until something killed it: CombatManager times out PvP combat only. The
##   novices' own fights with the targets are left alone: only the combat references of player-controlled units are ended, so a
##   novice keeps hitting his target. A player and everything he controls count as one side: his pet's or totem's hits keep his own
##   combat with the target too, and the whole side leaves together 5 s after the last hit of any of them (no in/out flicker).
## - The target vanishes 2 s after it dies (Wowhead 38038, 2011-02-10: "they vanish about 2 seconds after you kill them"); it
##   respawns 1 s later (spawntimesecs 1).
## Kept from the SmartAI: one of Tiki Target Visual 1-3 (71064-71066, permanent stun auras with the target's look) at random on
## every spawn, health regeneration off, Set Data 0 1 on the novices within 50 yd (they attack the closest target; the mop
## SmartAI's own wiring), Tiki Target Death 71240 on death, Spell Practice Credit 44175 for each of the nine practice spells
## (and Judgment, which the SmartAI listed) for every target it hits, as the SmartAI did (and TCPP): a Frost Nova among two
## targets counts twice - kept as the less grindy choice.
## The novices' damage no longer costs the player his kill credit: creature_template.flags_extra NO_PLAYER_DAMAGE_REQ (SQL). With
## that flag the kill goes to the player who tapped the target; a player whose combat with it ended loses the tap, so a target a
## novice finishes later credits nobody.
######*/

namespace EchoIslesTiki
{
enum
{
    NPC_SPELL_PRACTICE_CREDIT       = 44175,

    SPELL_TIKI_TARGET_VISUAL_1      = 71064,
    SPELL_TIKI_TARGET_VISUAL_2      = 71065,
    SPELL_TIKI_TARGET_VISUAL_3      = 71066,
    SPELL_TIKI_TARGET_DEATH         = 71240,
};

// The class spells The Arts of X asks for (5.4.8 quest objectives), plus Judgment from the SmartAI
uint32 const PracticeSpells[] =
{
    100,     // Charge - warrior 24640
    122,     // Frost Nova - mage 24752
    73899,   // Primal Strike - shaman 24760
    8921,    // Moonfire - druid 24766
    2098,    // Eviscerate - rogue 24772
    56641,   // Steady Shot - hunter 24778
    589,     // Shadow Word: Pain - priest 24784
    172,     // Corruption - warlock 26274
    100787,  // Tiger Palm - monk 31162
    20271,   // Judgment (no paladin set here; kept from the SmartAI)
};

// Novice Darkspear Warrior, Rogue, Priest, Mage, Druid, Shaman, Hunter, Warlock
uint32 const Novices[] = { 38268, 38272, 38278, 38279, 38280, 38281, 38282, 42619 };

float const NOVICE_WAKE_RANGE      = 50.0f;
uint32 const PLAYER_COMBAT_TIMEOUT = 5 * IN_MILLISECONDS;
uint32 const COMBAT_CHECK_INTERVAL = 1 * IN_MILLISECONDS;
uint32 const SPAWN_SETUP_DELAY     = 1 * IN_MILLISECONDS;   // the SmartAI lists waited 1 s before the visual
uint32 const CORPSE_DESPAWN_DELAY  = 2 * IN_MILLISECONDS;

// The player behind a player-controlled unit (himself, his pet, his totem): his side's activity is timed together
ObjectGuid GetSideGuid(Unit* unit)
{
    if (Player* player = unit->GetCharmerOrOwnerPlayerOrPlayerItself())
        return player->GetGUID();
    return unit->GetGUID();
}
}

using namespace EchoIslesTiki;

struct npc_echo_isles_tiki_target : public ScriptedAI
{
    npc_echo_isles_tiki_target(Creature* creature) : ScriptedAI(creature)
    {
        SetCombatMovement(false);
    }

    void Reset() override
    {
        // Template unit_flags keep it stunned and pacified; it never turns, moves or attacks
        me->setRegeneratingHealth(false);
        _checkTimer = COMBAT_CHECK_INTERVAL;
    }

    void JustAppeared() override
    {
        _hitTimers.clear();
        me->setRegeneratingHealth(false);
        _setupTimer = SPAWN_SETUP_DELAY;
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }

    // Evades are not ours (the 5 s timer ends single combat references), but the core may still call one: keep the look it had
    void EnterEvadeMode(EvadeReason why) override
    {
        if (!_EnterEvadeMode(why))
            return;

        _hitTimers.clear();
        ApplyRandomVisual();
        Reset();
    }

    void DamageTaken(Unit* attacker, uint32& /*damage*/) override
    {
        NoteActivity(attacker);
    }

    void SpellHit(Unit* caster, SpellInfo const* spell) override
    {
        NoteActivity(caster);

        for (uint32 practiceSpell : PracticeSpells)
            if (spell->Id == practiceSpell)
            {
                if (Player* player = caster ? caster->ToPlayer() : nullptr)
                    player->KilledMonsterCredit(NPC_SPELL_PRACTICE_CREDIT);
                break;
            }
    }

    void JustDied(Unit* /*killer*/) override
    {
        _hitTimers.clear();
        DoCast(me, SPELL_TIKI_TARGET_DEATH, true);
        me->DespawnOrUnsummon(CORPSE_DESPAWN_DELAY);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_setupTimer)
        {
            if (_setupTimer <= diff)
            {
                _setupTimer = 0;
                ApplyRandomVisual();
                WakeNovices();
            }
            else
                _setupTimer -= diff;
        }

        if (!me->IsInCombat())
        {
            _hitTimers.clear();
            return;
        }

        for (auto& entry : _hitTimers)
            entry.second = entry.second > diff ? entry.second - diff : 0;

        if (_checkTimer > diff)
        {
            _checkTimer -= diff;
            return;
        }
        _checkTimer = COMBAT_CHECK_INTERVAL;

        EndIdlePlayerCombat();
    }

private:
    void NoteActivity(Unit* who)
    {
        if (who && who->IsControlledByPlayer())
            _hitTimers[GetSideGuid(who)] = PLAYER_COMBAT_TIMEOUT;
    }

    void ApplyRandomVisual()
    {
        if (me->HasAura(SPELL_TIKI_TARGET_VISUAL_1) || me->HasAura(SPELL_TIKI_TARGET_VISUAL_2) || me->HasAura(SPELL_TIKI_TARGET_VISUAL_3))
            return;

        uint32 const visuals[] = { SPELL_TIKI_TARGET_VISUAL_1, SPELL_TIKI_TARGET_VISUAL_2, SPELL_TIKI_TARGET_VISUAL_3 };
        DoCast(me, visuals[urand(0, 2)], true);
    }

    void WakeNovices()
    {
        for (uint32 entry : Novices)
        {
            std::list<Creature*> novices;
            me->GetCreatureListWithEntryInGrid(novices, entry, NOVICE_WAKE_RANGE);
            for (Creature* novice : novices)
                if (novice->IsAlive() && novice->IsAIEnabled)
                    novice->AI()->SetData(0, 1);
        }
    }

    // A player's side (he, his pet, his totems) whose last hit or spell on the target is 5 s old leaves combat with it, every unit of
    // it at once. A side in combat with the target without a hit noted (a miss, a ref made by a spell that did not land) gets its
    // 5 s from now.
    void EndIdlePlayerCombat()
    {
        std::vector<ObjectGuid> idle;       // combat references to end, by the other unit's guid
        std::vector<ObjectGuid> idleSides;
        for (auto const& pair : me->GetCombatManager().GetPvECombatRefs())
        {
            Unit* other = pair.second->GetOther(me);
            if (!other || !other->IsControlledByPlayer())
                continue;

            ObjectGuid const side = GetSideGuid(other);
            auto itr = _hitTimers.find(side);
            if (itr == _hitTimers.end())
                _hitTimers[side] = PLAYER_COMBAT_TIMEOUT;
            else if (!itr->second)
            {
                idle.push_back(pair.first);
                idleSides.push_back(side);
            }
        }

        for (ObjectGuid const& side : idleSides)
            _hitTimers.erase(side);

        for (ObjectGuid const& guid : idle)
        {

            // Looked up again: ending one reference can end others (a pet's AI reacts to leaving combat)
            auto const& refs = me->GetCombatManager().GetPvECombatRefs();
            auto itr = refs.find(guid);
            if (itr == refs.end())
                continue;

            TC_LOG_DEBUG("scripts", "npc_echo_isles_tiki_target: guid %u ends combat with %s (5 s without a hit)",
                me->GetGUID().GetCounter(), itr->second->GetOther(me)->GetName().c_str());
            itr->second->EndCombat();
        }

        if (!idle.empty())
            ReleaseStaleTap();
    }

    // The tap goes with the player once neither he nor anything he controls is fighting the target any more
    void ReleaseStaleTap()
    {
        if (!me->IsAlive() || !me->HasLootRecipient())
            return;

        Player* recipient = me->GetLootRecipient();
        if (recipient)
            for (auto const& pair : me->GetCombatManager().GetPvECombatRefs())
                if (Unit* other = pair.second->GetOther(me))
                    if (other->GetCharmerOrOwnerPlayerOrPlayerItself() == recipient)
                        return;

        me->SetLootRecipient(nullptr);
    }

    std::unordered_map<ObjectGuid, uint32> _hitTimers;
    uint32 _checkTimer = COMBAT_CHECK_INTERVAL;
    uint32 _setupTimer = 0;
};

/*######
## quest_echo_isles_trainer_praise
## The Basics: Hitting Things and Proving Pit of all nine troll-area class sets. When one of them becomes complete, the class
## trainer who gave it speaks to the player: "Not bad, $n. Not bad." for The Basics (broadcast 37928; warcraft.wiki.gg The Basics:
## Hitting Things (hunter), Notes: "After destroying the tiki targets: Ortezza says: Not bad, <name>. Not bad.") and "Well done,
## $n!" for Proving Pit (broadcast 37898; both TDBs give it to the same nine trainers as group 1, no source says when: ours).
## The lines are personal (creature_text TextRange 5, ours): the trainer is up to ~200 yd from the far end of the training
## grounds, beyond say range, and other players need not read a stranger's name. Only the quest's own trainer, the nearest
## within 250 yd, speaks; no trainer in range, no line.
######*/

namespace EchoIslesTrainers
{
enum
{
    SAY_TRAINER_BASICS_COMPLETE     = 0,
    SAY_TRAINER_PROVING_PIT_DONE    = 1,
};

struct TrainerLine
{
    uint32 Quest;
    uint32 Trainer;
    uint8 Group;
};

TrainerLine const TrainerLines[] =
{
    { 24639, 38037, SAY_TRAINER_BASICS_COMPLETE },  // warrior - Nortet
    { 24751, 38246, SAY_TRAINER_BASICS_COMPLETE },  // mage - Soratha
    { 24759, 38242, SAY_TRAINER_BASICS_COMPLETE },  // shaman - Nekali
    { 24765, 38243, SAY_TRAINER_BASICS_COMPLETE },  // druid - Zen'tabra
    { 24771, 38244, SAY_TRAINER_BASICS_COMPLETE },  // rogue - Legati
    { 24777, 38247, SAY_TRAINER_BASICS_COMPLETE },  // hunter - Ortezza
    { 24783, 38245, SAY_TRAINER_BASICS_COMPLETE },  // priest - Tunari
    { 26273, 42618, SAY_TRAINER_BASICS_COMPLETE },  // warlock - Voldreka
    { 31158, 63310, SAY_TRAINER_BASICS_COMPLETE },  // monk - Zabrax
    { 24642, 38037, SAY_TRAINER_PROVING_PIT_DONE }, // warrior
    { 24754, 38246, SAY_TRAINER_PROVING_PIT_DONE }, // mage
    { 24762, 38242, SAY_TRAINER_PROVING_PIT_DONE }, // shaman
    { 24768, 38243, SAY_TRAINER_PROVING_PIT_DONE }, // druid
    { 24774, 38244, SAY_TRAINER_PROVING_PIT_DONE }, // rogue
    { 24780, 38247, SAY_TRAINER_PROVING_PIT_DONE }, // hunter
    { 24786, 38245, SAY_TRAINER_PROVING_PIT_DONE }, // priest
    { 26276, 42618, SAY_TRAINER_PROVING_PIT_DONE }, // warlock
    { 31161, 63310, SAY_TRAINER_PROVING_PIT_DONE }, // monk
};

float const TRAINER_SEARCH_RANGE = 250.0f;
}

class quest_echo_isles_trainer_praise : public QuestScript
{
public:
    quest_echo_isles_trainer_praise() : QuestScript("quest_echo_isles_trainer_praise") { }

    void OnQuestStatusChange(Player* player, Quest const* quest, QuestStatus oldStatus, QuestStatus newStatus) override
    {
        using namespace EchoIslesTrainers;

        // Player::CompleteQuest: the last objective met. Not on login (statuses are loaded, not changed) or turn-in.
        if (oldStatus != QUEST_STATUS_INCOMPLETE || newStatus != QUEST_STATUS_COMPLETE || !player->IsInWorld())
            return;

        for (TrainerLine const& line : TrainerLines)
        {
            if (line.Quest != quest->GetQuestId())
                continue;

            if (Creature* trainer = player->FindNearestCreature(line.Trainer, TRAINER_SEARCH_RANGE))
                sCreatureTextMgr->SendChat(trainer, line.Group, player);
            return;
        }
    }
};

void AddSC_echo_isles()
{
    new creature_script<npc_echo_isles_tiki_target>("npc_echo_isles_tiki_target");
    new quest_echo_isles_trainer_praise();
}
