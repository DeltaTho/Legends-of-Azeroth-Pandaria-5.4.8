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
SDName: Blasted_Lands
SD%Complete: 90
SDComment: Quest support: 25701 / 26171 (You Are Rakh'likh, Demon): the Deathly Usher's group teleport and the fight with
           Razelikh the Defiler on the Rise of the Defiler.
SDCategory: Blasted Lands
EndScriptData */

/* ContentData
spell_blasted_lands_teleport_to_razelikh_group
npc_blasted_lands_loramus_rise
npc_blasted_lands_razelikh
npc_blasted_lands_loramus_defiled
spell_blasted_lands_stone_knife
EndContentData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "Group.h"
#include "ObjectAccessor.h"
#include "SpellMgr.h"
#include "SpellInfo.h"
#include "SpellScript.h"
#include "TemporarySummon.h"
#include "Corpse.h"
#include "MotionMaster.h"

enum DeathlyUsher
{
    SPELL_TELEPORT_SINGLE               = 12885,
    SPELL_TELEPORT_SINGLE_IN_GROUP      = 13142,
    SPELL_TELEPORT_GROUP                = 27686
};

// 27686 - Teleport to Razelikh (GROUP), cast by the Deathly Usher 8816 on the player who chose "We wish to face the Defiler."
// (gossip 1541 option 1, TDB SmartAI). Every group member within 20 yd of that player and alive goes up with him (13142); TDB
// script name, behaviour ported from TCPP spell_razelikh_teleport_group. The spell's second target (37, the target's party) can
// hit each member: only the hit on the gossiping player acts, so nobody is sent twice
class spell_blasted_lands_teleport_to_razelikh_group : public SpellScript
{
    PrepareSpellScript(spell_blasted_lands_teleport_to_razelikh_group);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return sSpellMgr->GetSpellInfo(SPELL_TELEPORT_SINGLE) && sSpellMgr->GetSpellInfo(SPELL_TELEPORT_SINGLE_IN_GROUP);
    }

    void HandleScript(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
        Player* player = GetHitPlayer();
        if (!player || (GetExplTargetUnit() && GetExplTargetUnit() != player))
            return;

        Group* group = player->GetGroup();
        if (!group)
        {
            player->CastSpell(player, SPELL_TELEPORT_SINGLE, true);
            return;
        }

        for (GroupReference* itr = group->GetFirstMember(); itr != nullptr; itr = itr->next())
            if (Player* member = itr->GetSource())
                if (member->IsInMap(player) && member->IsAlive() && member->IsWithinDistInMap(player, 20.0f))
                    member->CastSpell(member, SPELL_TELEPORT_SINGLE_IN_GROUP, true);
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_blasted_lands_teleport_to_razelikh_group::HandleScript, EFFECT_0, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

/*######
## You Are Rakh'likh, Demon (25701 H / 26171 A): the Rise of the Defiler
##
## Loramus Thalipedes 41279 (the static spawn on the summit) runs the event. Sourced (wiki 25701 / 26171 notes, comments 181947,
## 387878, 819747, 769627, Pypode, radicarl, Taishigi; broadcast_text 41232-41246, 42291, 42292; DBC 10854, 77371-77406): his
## three lines and Razelikh's answer when you arrive; Razelikh attackable after it; Strong Cleave, Decimate, Flames of Chaos
## (knocks you off the Rise), Frenzy, felhounds; at a quarter of his health the four lines, Transfer Soul on Loramus and the body
## credit; Loramus the Defiled fights you, begs for the knife when almost beaten, the Stone Knife seals the soul, "It is done".
## Ours: the timers of Flames of Chaos, a felhound with each Flames, the 5 % beg point, damage floors so nobody skips a phase,
## the credit rule (every player with the quest within 60 yd, alive or dead, at the transfer and at the knife), the summons'
## spots, the 60 s before Loramus stands again.
######*/

enum RiseData
{
    QUEST_RAKHLIKH_H                    = 25701,
    QUEST_RAKHLIKH_A                    = 26171,

    NPC_LORAMUS_RISE                    = 41279,
    NPC_RAZELIKH                        = 41280,
    NPC_DEFILED_FELHOUND                = 41290,
    NPC_LORAMUS_DEFILED                 = 41292,

    SPELL_DEMON_HUNTERS_RESOLVE         = 77371,    // Loramus' aura: heals allies, its 77372 grip every 2.5 s
    SPELL_SHADOW_BOLT_VOLLEY            = 9081,
    SPELL_STRONG_CLEAVE                 = 8255,
    SPELL_DECIMATE                      = 13459,
    SPELL_FLAMES_OF_CHAOS               = 10854,    // 5 s cast, knockback 10-30 yd
    SPELL_FRENZY                        = 8269,
    SPELL_SUMMON_MINION                 = 77374,    // a Defiled Felhound for 60 s
    SPELL_TRANSFER_SOUL                 = 77382,    // stun on Loramus
    SPELL_DEMON_LORAMUS_STUN            = 77388,    // the Defiled stuns himself: the knife may be used
    SPELL_STONE_KNIFE                   = 77380,    // item 56012: jump to the target + dummy
    SPELL_LORAMUS_DEMISE                = 77406,

    // creature_text, all TextRange 0 (the actors stand in plain sight on the summit)
    TALK_LORAMUS_RETURNED               = 0,        // 41232 say
    TALK_LORAMUS_MEMORY                 = 1,        // 41233 say
    TALK_LORAMUS_RAKHLIKH               = 2,        // 41234 yell

    TALK_RAZELIKH_FOOL                  = 0,        // 41235 yell
    TALK_RAZELIKH_ENOUGH                = 1,        // 41236 yell
    TALK_RAZELIKH_ALTAR                 = 2,        // 41237 say
    TALK_RAZELIKH_FEEL_IT               = 3,        // 41238 say
    TALK_RAZELIKH_SPEED_UP              = 4,        // 41239 yell
    TALK_RAZELIKH_FRENZY                = 5,        // 2384 emote

    TALK_DEFILED_FINISH_ME              = 0,        // 41241 say
    TALK_DEFILED_PAIN                   = 1,        // 41240 yell, Demonic
    TALK_DEFILED_QUICKLY                = 2,        // 41242 say
    TALK_DEFILED_USE_IT_NOW             = 3,        // 41244 say
    TALK_DEFILED_DELIGHTS               = 4,        // 41243 say, Demonic
    TALK_DEFILED_IT_IS_DONE             = 5,        // 41246 say

    ACTION_RAZELIKH_RELEASE             = 1,        // controller -> Razelikh / Defiled: fight
    ACTION_RAZELIKH_STOP                = 2,        // controller -> Razelikh / Defiled: stop, passive, immune
    ACTION_DEFILED_BEG                  = 3,        // controller -> Defiled: stun himself
    ACTION_DEFILED_SEALED               = 4,        // controller -> Defiled: the knife has struck
    ACTION_TRANSFER                     = 10,       // Razelikh -> controller: down to 25 %
    ACTION_BEG                          = 11,       // Defiled -> controller: down to 5 %

    DATA_KNIFE                          = 1,        // SetGUID on the controller: this player used the knife

    EVENT_INTRO_MEMORY                  = 1,
    EVENT_INTRO_RAKHLIKH,
    EVENT_INTRO_FOOL,
    EVENT_INTRO_RELEASE,
    EVENT_TRANSFER_ALTAR,
    EVENT_TRANSFER_FEEL_IT,
    EVENT_TRANSFER_SPEED_UP,
    EVENT_TRANSFER_DEFILED,
    EVENT_DEFILED_ENGAGE,
    EVENT_BEG_QUICKLY,
    EVENT_BEG_NAG,
    EVENT_STAND_AGAIN,

    EVENT_CLEAVE                        = 1,
    EVENT_DECIMATE,
    EVENT_FLAMES,
    EVENT_AFTER_FLAMES,
};

enum RiseState
{
    RISE_IDLE,          // Loramus stands on the summit and waits for a player with the quest
    RISE_INTRO,
    RISE_PHASE_1,       // Razelikh
    RISE_TRANSFER,
    RISE_PHASE_2,       // Loramus the Defiled
    RISE_BEGGING,       // the Defiled stunned at 5 %, waiting for the knife
    RISE_DONE,          // sealed; Loramus hidden until he stands again
    RISE_FALLEN,        // Loramus beaten: the event is over, he gets up again
};

Position const RiseLoramusHome      = { -11239.0f, -2838.34f, 158.053f, 5.63741f };
Position const RiseRazelikhSpawn    = { -11234.5f, -2842.73f, 158.034f, 2.19912f };     // mop's static 313940 = Wowhead pin
Position const RiseUsherSide        = { -11112.0f, -2901.0f, 10.75f, 2.47f };           // 6 yd from the Deathly Usher, facing him (ours)

float const RiseEventRange          = 60.0f;    // players taking part, and credited
float const RiseStartRange          = 25.0f;    // a player with the quest this close starts it (the Usher lands him 7 yd away)
float const RiseCorpseRange         = 80.0f;    // a participant whose corpse lies this close to Loramus died on the Rise
uint32 const RiseHoldMs             = 10 * MINUTE * IN_MILLISECONDS;    // a held fight resets after this long with nobody back (ours)

static bool HoldsRakhlikh(Player const* player)
{
    return player->GetQuestStatus(QUEST_RAKHLIKH_H) == QUEST_STATUS_INCOMPLETE
        || player->GetQuestStatus(QUEST_RAKHLIKH_A) == QUEST_STATUS_INCOMPLETE;
}

// Every player within range of the Rise, alive or dead (the grid searchers skip the dead)
static void GetRisePlayers(Creature* me, float range, std::list<Player*>& players)
{
    for (auto const& ref : me->GetMap()->GetPlayers())
        if (Player* player = ref.GetSource())
            if (player->IsInWorld() && me->IsWithinDistInMap(player, range))
                players.push_back(player);
}

static Creature* GetRiseController(Creature* summon)
{
    if (TempSummon* tempSummon = summon->ToTempSummon())
        if (Unit* summoner = tempSummon->GetSummoner())
            if (Creature* controller = summoner->ToCreature())
                if (controller->GetEntry() == NPC_LORAMUS_RISE && controller->IsAIEnabled)
                    return controller;
    return nullptr;
}

// 41280 Razelikh the Defiler, summoned by Loramus at the intro. Passive and immune until released; never evades on his own
// (the controller holds or ends the fight); cannot be brought below 25 % (TCPP static flags: UNKILLABLE): there the transfer begins
struct npc_blasted_lands_razelikh : public ScriptedAI
{
    npc_blasted_lands_razelikh(Creature* creature) : ScriptedAI(creature), _hounds(creature) { }

    void Reset() override { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->setRegeneratingHealth(false);
        Stop();
    }

    void DoAction(int32 action) override
    {
        switch (action)
        {
            case ACTION_RAZELIKH_RELEASE:
                if (_transferring)
                    return;
                _released = true;
                me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
                me->SetReactState(REACT_AGGRESSIVE);
                _events.Reset();
                _events.ScheduleEvent(EVENT_CLEAVE, urand(2000, 4500));
                _events.ScheduleEvent(EVENT_DECIMATE, urand(8000, 11000));
                _events.ScheduleEvent(EVENT_FLAMES, 15000);
                if (Creature* controller = GetRiseController(me))
                    AttackStart(controller);
                break;
            case ACTION_RAZELIKH_STOP:
                Stop();
                break;
            default:
                break;
        }
    }

    void Stop()
    {
        _released = false;
        _events.Reset();
        _hounds.DespawnAll();
        me->InterruptNonMeleeSpells(false);
        me->CombatStop(true);
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveIdle();
    }

    void DespawnHounds()
    {
        _hounds.DespawnAll();
    }

    void DamageTaken(Unit* /*attacker*/, uint32& damage) override
    {
        if (!_released || _transferring)
        {
            damage = 0;
            return;
        }

        if (me->HealthBelowPctDamaged(25, damage))
        {
            uint32 const floor = me->CountPctFromMaxHealth(25);
            damage = me->GetHealth() > floor ? me->GetHealth() - floor : 0;
            _transferring = true;
            if (Creature* controller = GetRiseController(me))
                controller->AI()->DoAction(ACTION_TRANSFER);
        }
    }

    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void JustSummoned(Creature* summon) override
    {
        if (summon->GetEntry() != NPC_DEFILED_FELHOUND)
            return;

        _hounds.Summon(summon);
        if (Unit* victim = me->GetVictim())
            if (summon->IsAIEnabled)
                summon->AI()->AttackStart(victim);
    }

    void SummonedCreatureDespawn(Creature* summon) override
    {
        _hounds.Despawn(summon);
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_released || !UpdateVictim())
            return;

        _events.Update(diff);

        if (!_frenzied && me->HealthBelowPct(30))
        {
            _frenzied = true;
            DoCast(me, SPELL_FRENZY, true);
            Talk(TALK_RAZELIKH_FRENZY);
        }

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_CLEAVE:
                    DoCastVictim(SPELL_STRONG_CLEAVE);
                    _events.ScheduleEvent(EVENT_CLEAVE, urand(12000, 14000));
                    break;
                case EVENT_DECIMATE:
                    DoCastVictim(SPELL_DECIMATE);
                    _events.ScheduleEvent(EVENT_DECIMATE, urand(24000, 28000));
                    break;
                case EVENT_FLAMES:
                    DoCast(me, SPELL_FLAMES_OF_CHAOS);
                    _events.ScheduleEvent(EVENT_AFTER_FLAMES, 5500);
                    _events.ScheduleEvent(EVENT_FLAMES, urand(20000, 25000));
                    break;
                case EVENT_AFTER_FLAMES:
                {
                    // the hounds were thrown off with you; one comes back with you (Pypode, 819747). Summoned 4-10 yd from the
                    // summit's centre rather than by 77374 (10 yd round Razelikh, who may stand at the edge): the summit is level
                    // (z 158) out to 15 yd all round, so the hound never lands on the slope (ours)
                    _hounds.DespawnAll();
                    float const angle = frand(0.0f, 2.0f * float(M_PI));
                    float const dist = frand(4.0f, 10.0f);
                    float const x = RiseLoramusHome.GetPositionX() + dist * std::cos(angle);
                    float const y = RiseLoramusHome.GetPositionY() + dist * std::sin(angle);
                    float z = RiseLoramusHome.GetPositionZ();
                    me->UpdateAllowedPositionZ(x, y, z);
                    me->SummonCreature(NPC_DEFILED_FELHOUND, x, y, z, angle + float(M_PI), TEMPSUMMON_TIMED_DESPAWN, 60s);
                    break;
                }
                default:
                    break;
            }

            if (me->HasUnitState(UNIT_STATE_CASTING))
                return;
        }

        DoMeleeAttackIfReady();
    }

private:
    SummonList _hounds;
    EventMap _events;
    bool _released = false;
    bool _transferring = false;
    bool _frenzied = false;
};

// 41292 Loramus the Defiled, summoned on Loramus' spot at the transfer. Cannot die (TCPP static flags: UNKILLABLE); at 5 % he
// stuns himself and waits for the Stone Knife; never evades on his own
struct npc_blasted_lands_loramus_defiled : public ScriptedAI
{
    npc_blasted_lands_loramus_defiled(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->setRegeneratingHealth(false);
        Stop();
    }

    void DoAction(int32 action) override
    {
        switch (action)
        {
            case ACTION_RAZELIKH_RELEASE:
                if (_begging || _sealed)
                    return;
                _engaged = true;
                me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
                me->SetReactState(REACT_AGGRESSIVE);
                if (Player* player = SelectRiseTarget())
                    AttackStart(player);
                break;
            case ACTION_RAZELIKH_STOP:
                if (_begging || _sealed)
                    return;
                Stop();
                break;
            case ACTION_DEFILED_BEG:
                _begging = true;
                me->InterruptNonMeleeSpells(false);
                me->SetReactState(REACT_PASSIVE);
                me->AttackStop();
                DoCast(me, SPELL_DEMON_LORAMUS_STUN, true);
                break;
            case ACTION_DEFILED_SEALED:
                _sealed = true;
                me->RemoveAurasDueToSpell(SPELL_DEMON_LORAMUS_STUN);
                me->CombatStop(true);
                me->SetReactState(REACT_PASSIVE);
                me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
                me->SetControlled(true, UNIT_STATE_ROOT);
                Talk(TALK_DEFILED_IT_IS_DONE);
                DoCast(me, SPELL_LORAMUS_DEMISE, true);
                me->SetStandState(UNIT_STAND_STATE_KNEEL);
                me->DespawnOrUnsummon(30000);
                break;
            default:
                break;
        }
    }

    void Stop()
    {
        _engaged = false;
        me->InterruptNonMeleeSpells(false);
        me->CombatStop(true);
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveIdle();
    }

    Player* SelectRiseTarget() const
    {
        std::list<Player*> players;
        me->GetPlayerListInGrid(players, 40.0f);
        Player* best = nullptr;
        for (Player* player : players)
        {
            if (!player->IsAlive() || player->IsGameMaster() || !me->IsValidAttackTarget(player))
                continue;
            if (!best || me->GetDistance(player) < me->GetDistance(best)
                || (HoldsRakhlikh(player) && !HoldsRakhlikh(best)))
                best = player;
        }
        return best;
    }

    void DamageTaken(Unit* /*attacker*/, uint32& damage) override
    {
        if (_sealed || (!_engaged && !_begging))
        {
            damage = 0;
            return;
        }

        if (damage >= me->GetHealth())
            damage = me->GetHealth() - 1;

        if (!_begging && !_begNotified && me->HealthBelowPctDamaged(5, damage))
        {
            _begNotified = true;
            if (Creature* controller = GetRiseController(me))
                controller->AI()->DoAction(ACTION_BEG);
        }
    }

    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void UpdateAI(uint32 /*diff*/) override
    {
        if (!_engaged || _begging || _sealed || !UpdateVictim())
            return;

        DoMeleeAttackIfReady();
    }

    bool IsBegging() const { return _begging && !_sealed; }

private:
    bool _engaged = false;
    bool _begging = false;
    bool _begNotified = false;
    bool _sealed = false;
};

// 41279 Loramus Thalipedes on the Rise of the Defiler: the controller (see the block comment above)
struct npc_blasted_lands_loramus_rise : public ScriptedAI
{
    npc_blasted_lands_loramus_rise(Creature* creature) : ScriptedAI(creature)
    {
        SetCombatMovement(false);   // TCPP static flags: SESSILE
    }

    void Reset() override
    {
        _volleyTimer = urand(12000, 18000);
        if (_state == RISE_IDLE)
            me->SetReactState(REACT_PASSIVE);
    }

    void JustSummoned(Creature* summon) override
    {
        if (summon->GetEntry() == NPC_RAZELIKH)
            _razelikhGUID = summon->GetGUID();
        else if (summon->GetEntry() == NPC_LORAMUS_DEFILED)
            _defiledGUID = summon->GetGUID();
    }

    void DamageTaken(Unit* /*attacker*/, uint32& damage) override
    {
        // Losing Loramus loses the fight (819747): he is beaten, not killed, so the controller stays and the event can start again
        if (damage < me->GetHealth())
            return;

        damage = me->GetHealth() > 1 ? me->GetHealth() - 1 : 0;
        if (_state == RISE_INTRO || _state == RISE_PHASE_1)
            Fall();
    }

    void EnterEvadeMode(EvadeReason why) override
    {
        if (_state == RISE_IDLE)
        {
            ScriptedAI::EnterEvadeMode(why);
            return;
        }

        // during the event he only drops his target; the event decides when the fight ends
        me->CombatStop(true);
        KeepResolve();
    }

    void DoAction(int32 action) override
    {
        switch (action)
        {
            case ACTION_TRANSFER:
                if (_state == RISE_PHASE_1)
                    StartTransfer();
                break;
            case ACTION_BEG:
                if (_state == RISE_PHASE_2)
                    StartBegging();
                break;
            default:
                break;
        }
    }

    void SetGUID(ObjectGuid guid, int32 type) override
    {
        if (type != DATA_KNIFE || _state != RISE_BEGGING)
            return;

        Creature* defiled = GetDefiled();
        if (!defiled)
            return;

        TC_LOG_DEBUG("scripts", "Blasted Lands: the Stone Knife of player %u seals Razelikh's soul", guid.GetCounter());
        _state = RISE_DONE;
        _events.Reset();
        CreditPlayers(true, true);
        defiled->AI()->DoAction(ACTION_DEFILED_SEALED);
        _events.ScheduleEvent(EVENT_STAND_AGAIN, 60000);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_resolveTimer <= diff)
        {
            _resolveTimer = 5000;
            ResolveHeal();
        }
        else
            _resolveTimer -= diff;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
            HandleEvent(eventId);

        if (_scanTimer <= diff)
        {
            _scanTimer = 1000;
            Scan();
        }
        else
            _scanTimer -= diff;

        if (_state != RISE_PHASE_1 || _held || !UpdateVictim())
            return;

        if (_volleyTimer <= diff)
        {
            if (!me->HasUnitState(UNIT_STATE_CASTING) && SelectEnemyWithin(8.0f))
            {
                DoCast(me, SPELL_SHADOW_BOLT_VOLLEY);
                _volleyTimer = urand(12000, 18000);
            }
            else
                _volleyTimer = 1000;
        }
        else
            _volleyTimer -= diff;

        DoMeleeAttackIfReady();
    }

private:
    // Demon Hunter's Resolve "periodically regenerates health and mana for nearby allies" (77371; comments 387878, 85389, 769627:
    // the player was healed). In this core its health effect (2, aura 20, 4 % every 5 s, 20 yd) is an enemy-side area aura, which
    // healed Razelikh and his hounds; the AuraScript below keeps the aura off the demons and this gives the players their 4 %
    // every 5 s (ours: the mechanism; the amount, period and range are the DBC's)
    void ResolveHeal()
    {
        if (!me->IsAlive() || !me->IsVisible() || _state == RISE_FALLEN || !me->HasAura(SPELL_DEMON_HUNTERS_RESOLVE))
            return;

        SpellInfo const* resolve = sSpellMgr->GetSpellInfo(SPELL_DEMON_HUNTERS_RESOLVE);
        if (!resolve)
            return;

        std::list<Player*> players;
        me->GetPlayerListInGrid(players, 20.0f);
        for (Player* player : players)
            if (player->IsAlive() && !player->IsFullHealth() && me->IsFriendlyTo(player))
                me->HealBySpell(player, resolve, player->CountPctFromMaxHealth(4));
    }

    Creature* GetRazelikh() const
    {
        Creature* razelikh = ObjectAccessor::GetCreature(*me, _razelikhGUID);
        return razelikh && razelikh->IsAlive() && razelikh->IsAIEnabled ? razelikh : nullptr;
    }

    Creature* GetDefiled() const
    {
        Creature* defiled = ObjectAccessor::GetCreature(*me, _defiledGUID);
        return defiled && defiled->IsAlive() && defiled->IsAIEnabled ? defiled : nullptr;
    }

    bool SelectEnemyWithin(float range) const
    {
        Creature* razelikh = GetRazelikh();
        return (razelikh && me->IsWithinCombatRange(razelikh, range)) || (me->GetVictim() && me->IsWithinCombatRange(me->GetVictim(), range));
    }

    void KeepResolve()
    {
        if (me->IsVisible() && me->IsAlive() && !me->HasAura(SPELL_DEMON_HUNTERS_RESOLVE))
            DoCast(me, SPELL_DEMON_HUNTERS_RESOLVE, true);
    }

    void Scan()
    {
        if (_state != RISE_FALLEN)
            KeepResolve();

        std::list<Player*> players;
        me->GetPlayerListInGrid(players, RiseEventRange);

        bool starter = false;
        bool fighter = false;
        for (Player* player : players)
        {
            // every player alive on the Rise during the event, with the quest or not (a helper the group option took up), is raised
            // by the Usher if he dies there and releases; only quest holders start the fight and keep it from holding
            if (_state != RISE_IDLE && _state != RISE_FALLEN && player->IsAlive())
                _participants.insert(player->GetGUID());
            if (!HoldsRakhlikh(player) || !player->IsAlive() || player->IsInFlight())
                continue;
            fighter = true;
            if (me->IsWithinDist3d(player, RiseStartRange))
                starter = true;
        }

        ResurrectParticipants();

        switch (_state)
        {
            case RISE_IDLE:
                if (starter)
                    StartIntro();
                else if (_participants.empty() && me->isActiveObject())
                    me->setActive(false, ActiveFlags::Script);
                break;
            case RISE_PHASE_1:
            case RISE_PHASE_2:
            case RISE_BEGGING:
                if (_state == RISE_PHASE_1 ? !GetRazelikh() : !GetDefiled())
                {
                    ResetEvent();
                    break;
                }

                // Death, wipe, leaving: the fight holds and picks up where it was left (819747); reset only after 10 min (ours)
                if (!fighter)
                {
                    if (!_held)
                        Hold();
                    else if ((_heldMs += 1000) >= RiseHoldMs)
                        ResetEvent();
                }
                else if (_held)
                    Resume();
                else if (_state == RISE_PHASE_1 && !me->GetVictim())
                    EngageRazelikh();
                break;
            default:
                break;
        }
    }

    // A participant who died on the Rise and released his spirit is raised beside the Deathly Usher at once, in his body: "you will
    // be in your physical form ... very close to the etheral being", then back up to "pick up the fight where you left off" (819747
    // [+29]; full health and the spot are ours). Without this his ghost lands at the Dreadmaul Hold graveyard with the corpse on a
    // summit a ghost cannot reach (the Usher does not talk to ghosts)
    void ResurrectParticipants()
    {
        for (auto itr = _participants.begin(); itr != _participants.end();)
        {
            Player* player = ObjectAccessor::GetPlayer(*me, *itr);
            if (!player)
            {
                itr = _state == RISE_IDLE ? _participants.erase(itr) : std::next(itr);
                continue;
            }

            if (player->HasFlag(PLAYER_FIELD_PLAYER_FLAGS, PLAYER_FLAGS_GHOST))
            {
                if (player->IsBeingTeleported())
                {
                    ++itr;
                    continue;
                }

                Corpse* corpse = player->GetCorpse();
                if (corpse && corpse->GetExactDist(&RiseLoramusHome) <= RiseCorpseRange)
                {
                    TC_LOG_DEBUG("scripts", "Blasted Lands: player %u released on the Rise of the Defiler, raised by the Deathly Usher",
                        player->GetGUID().GetCounter());
                    player->ResurrectPlayer(1.0f, false);
                    player->SpawnCorpseBones();
                    player->NearTeleportTo(RiseUsherSide.GetPositionX(), RiseUsherSide.GetPositionY(), RiseUsherSide.GetPositionZ(),
                        RiseUsherSide.GetOrientation());
                }
                else
                {
                    // died somewhere else: not ours to raise
                    itr = _participants.erase(itr);
                    continue;
                }
            }
            else if (_state == RISE_IDLE && player->IsAlive())
            {
                itr = _participants.erase(itr);
                continue;
            }
            ++itr;
        }
    }

    // Nobody with the quest alive on the Rise: everybody stops where they are and keeps his health (no evade, no regeneration)
    void Hold()
    {
        TC_LOG_DEBUG("scripts", "Blasted Lands: nobody left fighting on the Rise of the Defiler, the event holds");
        _held = true;
        _heldMs = 0;
        if (Creature* razelikh = GetRazelikh())
            razelikh->AI()->DoAction(ACTION_RAZELIKH_STOP);
        if (Creature* defiled = GetDefiled())
            defiled->AI()->DoAction(ACTION_RAZELIKH_STOP);
        if (_state == RISE_PHASE_1)
        {
            me->InterruptNonMeleeSpells(false);
            me->CombatStop(true);
            me->SetReactState(REACT_PASSIVE);
        }
    }

    void Resume()
    {
        TC_LOG_DEBUG("scripts", "Blasted Lands: a player is back on the Rise of the Defiler, the event resumes");
        _held = false;
        _heldMs = 0;
        if (_state == RISE_PHASE_1)
        {
            if (Creature* razelikh = GetRazelikh())
                razelikh->AI()->DoAction(ACTION_RAZELIKH_RELEASE);
            EngageRazelikh();
        }
        else if (Creature* defiled = GetDefiled())
            defiled->AI()->DoAction(ACTION_RAZELIKH_RELEASE);
    }

    void StartIntro()
    {
        TC_LOG_DEBUG("scripts", "Blasted Lands: Loramus begins the Rise of the Defiler event");
        _state = RISE_INTRO;
        _held = false;
        _heldMs = 0;
        me->setActive(true, ActiveFlags::Script);
        me->SetFacingTo(me->GetAngle(&RiseRazelikhSpawn));
        Talk(TALK_LORAMUS_RETURNED);
        _events.Reset();
        _events.ScheduleEvent(EVENT_INTRO_MEMORY, 4000);
    }

    void EngageRazelikh()
    {
        if (Creature* razelikh = GetRazelikh())
        {
            me->SetReactState(REACT_DEFENSIVE);
            AttackStart(razelikh);
        }
    }

    void StartTransfer()
    {
        _state = RISE_TRANSFER;
        me->InterruptNonMeleeSpells(false);
        me->CombatStop(true);
        me->SetReactState(REACT_PASSIVE);
        if (Creature* razelikh = GetRazelikh())
        {
            razelikh->AI()->DoAction(ACTION_RAZELIKH_STOP);
            razelikh->SetFacingToObject(me);
            razelikh->AI()->Talk(TALK_RAZELIKH_ENOUGH);
        }
        _events.Reset();
        _events.ScheduleEvent(EVENT_TRANSFER_ALTAR, 3000);
    }

    void StartBegging()
    {
        _state = RISE_BEGGING;
        if (Creature* defiled = GetDefiled())
        {
            defiled->AI()->Talk(TALK_DEFILED_PAIN);
            defiled->AI()->DoAction(ACTION_DEFILED_BEG);
        }
        _nagFlip = false;
        _events.ScheduleEvent(EVENT_BEG_QUICKLY, 3000);
    }

    // Every player holding the quest within 60 yd, alive or dead, is credited; at the knife the body credit too for whoever lacks it
    void CreditPlayers(bool body, bool soul)
    {
        std::list<Player*> players;
        GetRisePlayers(me, RiseEventRange, players);
        for (Player* player : players)
        {
            if (!HoldsRakhlikh(player))
                continue;
            if (body)
                player->KilledMonsterCredit(NPC_RAZELIKH);
            if (soul && HoldsRakhlikh(player))
                player->KilledMonsterCredit(NPC_LORAMUS_DEFILED);
        }
    }

    void Hide()
    {
        me->RemoveAurasDueToSpell(SPELL_DEMON_HUNTERS_RESOLVE);
        me->InterruptNonMeleeSpells(false);
        me->CombatStop(true);
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC | UNIT_FLAG_NOT_SELECTABLE);
        me->SetVisible(false);
    }

    void Show()
    {
        me->RemoveAurasDueToSpell(SPELL_TRANSFER_SOUL);
        me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC | UNIT_FLAG_NOT_SELECTABLE);
        me->SetStandState(UNIT_STAND_STATE_STAND);
        me->SetFullHealth();
        me->SetVisible(true);
        me->NearTeleportTo(RiseLoramusHome.GetPositionX(), RiseLoramusHome.GetPositionY(), RiseLoramusHome.GetPositionZ(),
            RiseLoramusHome.GetOrientation());
        KeepResolve();
    }

    // Beaten in phase 1: he sinks to the ground and Razelikh is gone; he stands again 10 s later (ours)
    void Fall()
    {
        TC_LOG_DEBUG("scripts", "Blasted Lands: Loramus is beaten on the Rise of the Defiler, the event ends");
        DespawnActors();
        _state = RISE_FALLEN;
        _held = false;
        _events.Reset();
        me->InterruptNonMeleeSpells(false);
        me->CombatStop(true);
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->SetStandState(UNIT_STAND_STATE_DEAD);
        _events.ScheduleEvent(EVENT_STAND_AGAIN, 10000);
    }

    void DespawnActors()
    {
        if (Creature* razelikh = ObjectAccessor::GetCreature(*me, _razelikhGUID))
        {
            if (razelikh->IsAIEnabled && razelikh->IsAlive())
                if (npc_blasted_lands_razelikh* razelikhAI = CAST_AI(npc_blasted_lands_razelikh, razelikh->AI()))
                    razelikhAI->DespawnHounds();
            razelikh->DespawnOrUnsummon();
        }
        if (Creature* defiled = ObjectAccessor::GetCreature(*me, _defiledGUID))
            defiled->DespawnOrUnsummon();
        _razelikhGUID.Clear();
        _defiledGUID.Clear();
    }

    void ResetEvent()
    {
        TC_LOG_DEBUG("scripts", "Blasted Lands: the Rise of the Defiler event resets");
        DespawnActors();
        _events.Reset();
        _state = RISE_IDLE;
        _held = false;
        _heldMs = 0;
        Show();
        me->CombatStop(true);
        me->SetReactState(REACT_PASSIVE);
        if (_participants.empty())     // else kept active until the dead among them are raised (ResurrectParticipants)
            me->setActive(false, ActiveFlags::Script);
    }

    void HandleEvent(uint32 eventId)
    {
        switch (eventId)
        {
            case EVENT_INTRO_MEMORY:
                Talk(TALK_LORAMUS_MEMORY);
                _events.ScheduleEvent(EVENT_INTRO_RAKHLIKH, 4000);
                break;
            case EVENT_INTRO_RAKHLIKH:
                Talk(TALK_LORAMUS_RAKHLIKH);
                me->SummonCreature(NPC_RAZELIKH, RiseRazelikhSpawn, TEMPSUMMON_MANUAL_DESPAWN);
                _events.ScheduleEvent(EVENT_INTRO_FOOL, 1500);
                break;
            case EVENT_INTRO_FOOL:
                if (Creature* razelikh = GetRazelikh())
                {
                    razelikh->SetFacingToObject(me);
                    razelikh->AI()->Talk(TALK_RAZELIKH_FOOL);
                }
                _events.ScheduleEvent(EVENT_INTRO_RELEASE, 3000);
                break;
            case EVENT_INTRO_RELEASE:
                if (Creature* razelikh = GetRazelikh())
                {
                    _state = RISE_PHASE_1;
                    _volleyTimer = urand(12000, 18000);
                    razelikh->AI()->DoAction(ACTION_RAZELIKH_RELEASE);
                    EngageRazelikh();
                }
                else
                    ResetEvent();
                break;
            case EVENT_TRANSFER_ALTAR:
                if (Creature* razelikh = GetRazelikh())
                    razelikh->AI()->Talk(TALK_RAZELIKH_ALTAR);
                _events.ScheduleEvent(EVENT_TRANSFER_FEEL_IT, 5000);
                break;
            case EVENT_TRANSFER_FEEL_IT:
                if (Creature* razelikh = GetRazelikh())
                    razelikh->AI()->Talk(TALK_RAZELIKH_FEEL_IT);
                _events.ScheduleEvent(EVENT_TRANSFER_SPEED_UP, 5000);
                break;
            case EVENT_TRANSFER_SPEED_UP:
                if (Creature* razelikh = GetRazelikh())
                {
                    razelikh->AI()->Talk(TALK_RAZELIKH_SPEED_UP);
                    razelikh->CastSpell(me, SPELL_TRANSFER_SOUL, true);
                    // "he kills himself" (387878): no loot (lootid 0)
                    razelikh->Kill(razelikh);
                    razelikh->DespawnOrUnsummon(5000);
                }
                CreditPlayers(true, false);
                _events.ScheduleEvent(EVENT_TRANSFER_DEFILED, 2000);
                break;
            case EVENT_TRANSFER_DEFILED:
                Hide();
                if (Creature* defiled = me->SummonCreature(NPC_LORAMUS_DEFILED, RiseLoramusHome, TEMPSUMMON_MANUAL_DESPAWN))
                    defiled->AI()->Talk(TALK_DEFILED_FINISH_ME);
                _events.ScheduleEvent(EVENT_DEFILED_ENGAGE, 3000);
                break;
            case EVENT_DEFILED_ENGAGE:
                if (Creature* defiled = GetDefiled())
                {
                    _state = RISE_PHASE_2;
                    defiled->AI()->DoAction(ACTION_RAZELIKH_RELEASE);
                }
                else
                    ResetEvent();
                break;
            case EVENT_BEG_QUICKLY:
                if (Creature* defiled = GetDefiled())
                    defiled->AI()->Talk(TALK_DEFILED_QUICKLY);
                _events.ScheduleEvent(EVENT_BEG_NAG, 20000);
                break;
            case EVENT_BEG_NAG:
                if (Creature* defiled = GetDefiled())
                    defiled->AI()->Talk(_nagFlip ? TALK_DEFILED_DELIGHTS : TALK_DEFILED_USE_IT_NOW);
                _nagFlip = !_nagFlip;
                _events.ScheduleEvent(EVENT_BEG_NAG, 20000);
                break;
            case EVENT_STAND_AGAIN:
                ResetEvent();
                break;
            default:
                break;
        }
    }

    EventMap _events;
    RiseState _state = RISE_IDLE;
    ObjectGuid _razelikhGUID;
    ObjectGuid _defiledGUID;
    GuidSet _participants;      // players with the quest seen within 60 yd since the intro
    uint32 _scanTimer = 1000;
    uint32 _volleyTimer = 15000;
    uint32 _resolveTimer = 5000;
    uint32 _heldMs = 0;
    bool _held = false;
    bool _nagFlip = false;
};

// 77380 Stone Knife (item 56012 Stone Knife of Sealing): only on Loramus the Defiled once he has stunned himself (77388), so the
// leap goes nowhere else; the strike seals Razelikh's soul (the controller credits every player with the quest nearby)
class spell_blasted_lands_stone_knife : public SpellScript
{
    PrepareSpellScript(spell_blasted_lands_stone_knife);

    SpellCastResult CheckCast()
    {
        Unit* target = GetExplTargetUnit();
        if (!target || target->GetEntry() != NPC_LORAMUS_DEFILED || !target->HasAura(SPELL_DEMON_LORAMUS_STUN))
            return SPELL_FAILED_BAD_TARGETS;
        return SPELL_CAST_OK;
    }

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        Creature* defiled = GetHitCreature();
        Unit* caster = GetCaster();
        if (!defiled || !caster || defiled->GetEntry() != NPC_LORAMUS_DEFILED)
            return;

        if (Creature* controller = GetRiseController(defiled))
            controller->AI()->SetGUID(caster->GetGUID(), DATA_KNIFE);
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_blasted_lands_stone_knife::CheckCast);
        OnEffectHitTarget += SpellEffectFn(spell_blasted_lands_stone_knife::HandleDummy, EFFECT_1, SPELL_EFFECT_DUMMY);
    }
};

// 10854 Flames of Chaos (Razelikh). Effects: 0 triggers 10857 (feather fall, 10 s) and 1 knocks back (5 yd/s outwards, 18.7 up) on
// the enemies round him: the players float off the summit (387878, Pypode, 819747: knocked off the Rise and pulled back). Effect 2
// (straight up at 40, target type 7 "area entry") has no target condition in mop or either TDB; unconditioned it hit every unit
// within 30 yd, Razelikh and his hounds included, and its vertical throw replaced effect 1's, so nobody left the summit. Effects 0
// and 1 are kept to players and their pets; effect 2 hits nothing (ours: no source says what it was meant for)
class spell_blasted_lands_flames_of_chaos : public SpellScript
{
    PrepareSpellScript(spell_blasted_lands_flames_of_chaos);

    void FilterPlayers(std::list<WorldObject*>& targets)
    {
        targets.remove_if([](WorldObject* object)
        {
            Unit* unit = object->ToUnit();
            return !unit || !unit->IsControlledByPlayer();
        });
    }

    void FilterAll(std::list<WorldObject*>& targets)
    {
        targets.clear();
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_blasted_lands_flames_of_chaos::FilterPlayers, EFFECT_0, TARGET_UNIT_SRC_AREA_ENEMY);
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_blasted_lands_flames_of_chaos::FilterPlayers, EFFECT_1, TARGET_UNIT_SRC_AREA_ENEMY);
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_blasted_lands_flames_of_chaos::FilterAll, EFFECT_2, TARGET_UNIT_SRC_AREA_ENTRY);
    }
};

// 77371 Demon Hunter's Resolve (Loramus 41279 and Loramus the Defiled 41292). Its area effects reach only the owner and players
// (and their pets): effect 1 (friend, mana) gives Loramus' allies mana as before; effect 2 (enemy, health) can then heal only the
// players the owner is hostile to, i.e. the Defiled's copy heals the players fighting him (as the comments describe), and
// Loramus' copy no longer heals Razelikh and the hounds - Loramus heals the players from his AI instead (ResolveHeal)
class spell_blasted_lands_demon_hunters_resolve : public AuraScript
{
    PrepareAuraScript(spell_blasted_lands_demon_hunters_resolve);

    bool CheckAreaTarget(Unit* target)
    {
        return target == GetUnitOwner() || target->IsControlledByPlayer();
    }

    void Register() override
    {
        DoCheckAreaTarget += AuraCheckAreaTargetFn(spell_blasted_lands_demon_hunters_resolve::CheckAreaTarget);
    }
};

void AddSC_blasted_lands()
{
    new spell_script<spell_blasted_lands_teleport_to_razelikh_group>("spell_blasted_lands_teleport_to_razelikh_group");
    new creature_script<npc_blasted_lands_loramus_rise>("npc_blasted_lands_loramus_rise");
    new creature_script<npc_blasted_lands_razelikh>("npc_blasted_lands_razelikh");
    new creature_script<npc_blasted_lands_loramus_defiled>("npc_blasted_lands_loramus_defiled");
    new spell_script<spell_blasted_lands_stone_knife>("spell_blasted_lands_stone_knife");
    new spell_script<spell_blasted_lands_flames_of_chaos>("spell_blasted_lands_flames_of_chaos");
    new aura_script<spell_blasted_lands_demon_hunters_resolve>("spell_blasted_lands_demon_hunters_resolve");
}
