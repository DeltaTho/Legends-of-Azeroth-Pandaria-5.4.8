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
SDName: Blasted Lands, the bloodstone ritual
SDComment: Quest support: 25688 (Horde) / 26162 (Alliance) The Altar of Storms - the Blood Altar, Loramus' Body and the
           Shadowsworn Obstructor waves
SDCategory: Blasted Lands
EndScriptData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "GameObject.h"
#include "GameObjectAI.h"
#include "Player.h"
#include "ObjectAccessor.h"
#include "TemporarySummon.h"
#include "MotionMaster.h"
#include "Map.h"

/*######
## The Altar of Storms (25688 Horde / 26162 Alliance)
##
## What the player sees (sources: comments 25688 2010-12-19 [+71], 2011-02-10 [+7], 2011-02-19 [+2], 2011-04-24, 2011-04-28 [+5],
## 2012-07-21, 2010-11-27 [-3], 2013-11-08 [+1], 2012-12-29 [+1], 2011-01-13; 26162 2010-12-20 [+51], 2011-10-31 [+6], 2011-05-15
## [+4], 2012-11-28 [+60]; npc 41193 2011-02-27 [+6], 2013-06-16 [+4]; npc 7783 2013-12-27 [+55]; the wiki 26162 notes; the spells
## 77159, 77092 / 77115 / 77116 / 77118 / 77120, 77129, 77211 and their spell_target_position rows; broadcast texts 41141, 41144,
## 41147, 41280, 41281, 41283, 41284, 41285):
## A player on the quest right-clicks the small bone-coloured altar on the spine at the top of the Altar of Storms. Loramus' Body
## appears on it ("Protect Loramus' Body until the ritual completes!"; he yells in Demonic "Holy moley!"). Shadowsworn Obstructors
## appear round the altar in waves (1, 1, 2, 2, 5) and channel Disrupt Ritual (green lightning) at the body; they keep moving, and a
## player who runs or rides close pulls them off the channel and they chase him. At the first hit: "Loramus' Body is under attack!
## Protect him!" and "This is horrible!". If the body dies: "The resurrection ritual has failed!", the Obstructors vanish, and the
## altar can be used again when its 140 s are up. If he lives about two minutes: "Grol!!", "You, what have you done?", "I see...
## this is the path I must take. Meet up with me back in the cave, heroes."; everyone round the altar on the quest is credited,
## even a dead player or a passer-by; he walks off towards the cave and is gone. Loramus himself waits at the bloodmages' cave
## (Horde) or under the tent by Kasim (Alliance), where the quest is handed in (section D's window).
##
## Sourced besides: the credit radius, 40 yd round the body (77250 Quest Complete - The Altar of Storms, KILL_CREDIT2 41193 at
## TARGET_UNIT_DEST_AREA_ENTRY, max radius index 23 = 40 yd); the hovering pose (the template addon's AnimTier 3; comments
## "hovers", "the Robot").
## Ours (no source says how): a player not on the quest cannot start it; the timing (waves at 5 / 20 / 35 / 50 / 65 s, success at
## 120 s, lines 3 s apart; the -3 comment gives the counts, "spawned way too fast" and "protect him for like 2 mins" the scale);
## the emotes reach the whole Altar of Storms area (1441); the point he walks to (a sniffed Shadowsworn spot at the foot of the
## ramp) and his despawn there or after 40 s. A player in a raid group gets no kill credit (Player::KilledMonsterCredit skips raid
## groups for quests not allowed in raids), as for any kill credit.
##
## Core notes:
## - The altar is a goober with autoClose 140 s; GameObject::Use flags it IN_USE for that long and casts 77159 through a summoned
##   trigger, with the user as original caster: the user is the body's summoner, and Unit::RemoveFromWorld unsummons a player's
##   summons, so his logout would end the ritual for everyone. The body takes itself off his summon list (UpdateAI, because
##   Map::SummonCreature adds it only after IsSummonedBy).
## - The goober has noDamageImmune 0, so it never despawns after a use (GO_FLAG_NODESPAWN at load): after 140 s it is usable again.
## - Disrupt Ritual (77129) is a harmful channel cast by a hostile mob on the neutral IMMUNE_TO_PC body. Two paths would put them in
##   combat, and an Obstructor in combat with the body finds nobody on its threat list, evades (cancelling the channel before its
##   first tick), and loops; the body would also lose IMMUNE_TO_PC (Unit::SetInCombatState):
##   1. the first hit: Spell::DoAllEffectOnTarget -> Unit::CombatStart -> Unit::SetInCombatWith -> SetInCombatState, which does not
##      ask the CombatManager. 77129 carries SPELL_ATTR0_CU_DONT_SET_IN_COMBAT_STATE (spell_custom_attribute), so CombatStart runs
##      with initialAggro false and skips both SetInCombatWith calls;
##   2. each tick and the spell's threat (DealDamage / Spell::HandleThreatSpells -> ThreatManager::AddThreat ->
##      CombatManager::SetInCombatWith; neutral is not friendly). The body has combat disallowed, so CanBeginCombat refuses.
##   Together the channel runs its 10 s, every tick hurts the body (ModifyHealth comes before AddThreat), neither side enters combat
##   and the body keeps its flags (dossier U6). Never in combat, the body would regenerate: regeneration is off.
## - Hover: the body has CREATURE_FLAG_EXTRA_NO_MOVE_FLAGS_UPDATE, so Creature::UpdateMovementFlags does not undo the script's
##   gravity-off Fly tier; the script gives gravity back for the walk-off.
######*/

enum AltarOfStorms
{
    QUEST_ALTAR_OF_STORMS_H         = 25688,
    QUEST_ALTAR_OF_STORMS_A         = 26162,

    NPC_LORAMUS_BODY                = 41193,
    NPC_SHADOWSWORN_OBSTRUCTOR      = 41191,

    SPELL_SUMMON_OBSTRUCTOR_N       = 77092,
    SPELL_SUMMON_OBSTRUCTOR_NW      = 77115,
    SPELL_SUMMON_OBSTRUCTOR_SW      = 77116,
    SPELL_SUMMON_OBSTRUCTOR_SE      = 77118,
    SPELL_SUMMON_OBSTRUCTOR_NE      = 77120,
    SPELL_DISRUPT_RITUAL            = 77129,

    // Loramus' Body 41193 creature_text groups
    SAY_BODY_PROTECT                = 0,    // 41144 boss emote
    SAY_BODY_HOLY_MOLEY             = 1,    // 41284 yell, Demonic
    SAY_BODY_UNDER_ATTACK           = 2,    // 41147 boss emote
    SAY_BODY_HORRIBLE               = 3,    // 41285 yell, Demonic
    SAY_BODY_GROL                   = 4,    // 41280
    SAY_BODY_WHAT_HAVE_YOU_DONE     = 5,    // 41281
    SAY_BODY_PATH                   = 6,    // 41283
    SAY_BODY_FAILED                 = 7,    // 41141 boss emote

    EVENT_BODY_HOLY_MOLEY           = 1,
    EVENT_BODY_WAVE_1,
    EVENT_BODY_WAVE_2,
    EVENT_BODY_WAVE_3,
    EVENT_BODY_WAVE_4,
    EVENT_BODY_WAVE_5,
    EVENT_BODY_HORRIBLE,
    EVENT_BODY_SUCCESS,
    EVENT_BODY_SUCCESS_2,
    EVENT_BODY_SUCCESS_3,
    EVENT_BODY_WALK_OFF,
    EVENT_BODY_DESPAWN,

    POINT_BODY_RAMP                 = 1,
};

static float const ALTAR_CREDIT_RANGE = 40.0f;            // 77250's radius
static Position const LoramusBodyWalkOff = { -11305.1f, -2584.1f, 89.54f, 0.0f };   // ours: 6009 guid 163844's spot below the ramp

static bool HasAltarOfStormsIncomplete(Player const* player)
{
    return player->GetQuestStatus(QUEST_ALTAR_OF_STORMS_H) == QUEST_STATUS_INCOMPLETE
        || player->GetQuestStatus(QUEST_ALTAR_OF_STORMS_A) == QUEST_STATUS_INCOMPLETE;
}

// Blood Altar 203196
struct go_blasted_lands_blood_altar : public GameObjectAI
{
    go_blasted_lands_blood_altar(GameObject* go) : GameObjectAI(go) { }

    // isUse: GameObject::Use (after the opening cast); CMSG_GAMEOBJ_REPORT_USE calls this again with isUse false
    bool OnGossipHello(Player* player, bool isUse) override
    {
        if (!isUse)
            return false;

        // Ours: only a player on the quest starts the ritual; nothing while one is running (the 140 s IN_USE window) or while
        // the last body is still walking off
        if (!HasAltarOfStormsIncomplete(player) || me->getLootState() != GO_READY || me->FindNearestCreature(NPC_LORAMUS_BODY, 60.0f))
            return true;

        TC_LOG_DEBUG("scripts", "Blasted Lands: player %u starts the Altar of Storms ritual", player->GetGUID().GetCounter());
        return false; // the goober's own use: IN_USE for 140 s, 77159 summons Loramus' Body
    }
};

// Loramus' Body 41193, summoned by the Blood Altar (77159)
struct npc_blasted_lands_loramus_body : public ScriptedAI
{
    npc_blasted_lands_loramus_body(Creature* creature) : ScriptedAI(creature), _summons(creature)
    {
        me->SetReactState(REACT_PASSIVE);
        me->SetIsCombatDisallowed(true);
        me->setRegeneratingHealth(false);
    }

    void Reset() override { }
    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackedBy(Unit* /*attacker*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (summoner)
            _summonerGUID = summoner->GetGUID();

        me->SetIsCombatDisallowed(true);
        me->setRegeneratingHealth(false);
        me->SetDisableGravity(true);
        me->SetAnimTier(AnimTier::Fly);
        _started = true;
        Talk(SAY_BODY_PROTECT);
        _events.ScheduleEvent(EVENT_BODY_HOLY_MOLEY, 2000);
        _events.ScheduleEvent(EVENT_BODY_WAVE_1, 5000);
        _events.ScheduleEvent(EVENT_BODY_WAVE_2, 20000);
        _events.ScheduleEvent(EVENT_BODY_WAVE_3, 35000);
        _events.ScheduleEvent(EVENT_BODY_WAVE_4, 50000);
        _events.ScheduleEvent(EVENT_BODY_WAVE_5, 65000);
        _events.ScheduleEvent(EVENT_BODY_SUCCESS, 120000);
    }

    void JustSummoned(Creature* summon) override
    {
        _summons.Summon(summon);
    }

    void SummonedCreatureDespawn(Creature* summon) override
    {
        _summons.Despawn(summon);
    }

    void DamageTaken(Unit* attacker, uint32& damage) override
    {
        if (!_started || _finished || _underAttack || !damage || attacker == me)
            return;

        _underAttack = true;
        Talk(SAY_BODY_UNDER_ATTACK);
        _events.ScheduleEvent(EVENT_BODY_HORRIBLE, 3000);
    }

    void JustDied(Unit* /*killer*/) override
    {
        _events.Reset();
        _summons.DespawnAll();
        if (_started && !_finished)
        {
            Talk(SAY_BODY_FAILED);
            TC_LOG_DEBUG("scripts", "Blasted Lands: the Altar of Storms ritual failed");
        }
        _finished = true;
        me->DespawnOrUnsummon(5000);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == POINT_MOTION_TYPE && id == POINT_BODY_RAMP)
            me->DespawnOrUnsummon(500);
    }

    void UpdateAI(uint32 diff) override
    {
        // The altar's user is the summoner: take the body off his summon list, so that his logout leaves the ritual running
        if (!_detached)
        {
            _detached = true;
            if (Player* summoner = ObjectAccessor::GetPlayer(*me, _summonerGUID))
                if (TempSummon* self = me->ToTempSummon())
                    summoner->RemoveSummon(self);
        }

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_BODY_HOLY_MOLEY:
                    Talk(SAY_BODY_HOLY_MOLEY);
                    break;
                case EVENT_BODY_WAVE_1:
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_N, true);
                    break;
                case EVENT_BODY_WAVE_2:
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_NW, true);
                    break;
                case EVENT_BODY_WAVE_3:
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_SW, true);
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_SE, true);
                    break;
                case EVENT_BODY_WAVE_4:
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_N, true);
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_NE, true);
                    break;
                case EVENT_BODY_WAVE_5:
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_N, true);
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_NW, true);
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_SW, true);
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_SE, true);
                    DoCast(me, SPELL_SUMMON_OBSTRUCTOR_NE, true);
                    break;
                case EVENT_BODY_HORRIBLE:
                    if (!_finished)
                        Talk(SAY_BODY_HORRIBLE);
                    break;
                case EVENT_BODY_SUCCESS:
                    _finished = true;
                    _events.CancelEvent(EVENT_BODY_HORRIBLE);
                    _summons.DespawnAll();
                    me->RemoveAurasDueToSpell(SPELL_DISRUPT_RITUAL);
                    Talk(SAY_BODY_GROL);
                    CreditPlayersAround();
                    _events.ScheduleEvent(EVENT_BODY_SUCCESS_2, 3000);
                    break;
                case EVENT_BODY_SUCCESS_2:
                    Talk(SAY_BODY_WHAT_HAVE_YOU_DONE);
                    _events.ScheduleEvent(EVENT_BODY_SUCCESS_3, 3000);
                    break;
                case EVENT_BODY_SUCCESS_3:
                    Talk(SAY_BODY_PATH);
                    _events.ScheduleEvent(EVENT_BODY_DESPAWN, 4000);
                    break;
                case EVENT_BODY_DESPAWN:
                    me->DespawnOrUnsummon();
                    break;
                default:
                    break;
            }
        }
    }

private:
    // Everyone within 40 yd of the body on the quest, dead or alive, playerbots included (sourced: bystanders and a dead player
    // credited; 77250's radius)
    void CreditPlayersAround()
    {
        uint32 credited = 0;
        for (auto const& ref : me->GetMap()->GetPlayers())
        {
            Player* player = ref.GetSource();
            if (!player || !player->IsInWorld() || !player->InSamePhase(me) || !me->IsWithinDistInMap(player, ALTAR_CREDIT_RANGE))
                continue;
            if (!HasAltarOfStormsIncomplete(player))
                continue;

            player->KilledMonsterCredit(NPC_LORAMUS_BODY, me->GetGUID());
            ++credited;
        }
        TC_LOG_DEBUG("scripts", "Blasted Lands: the Altar of Storms ritual succeeded, %u player(s) credited", credited);
    }

    EventMap _events;
    SummonList _summons;
    ObjectGuid _summonerGUID;
    bool _started = false;
    bool _finished = false;
    bool _underAttack = false;
    bool _detached = false;
};

void AddSC_blasted_lands_bloodstone()
{
    RegisterGameObjectAI(go_blasted_lands_blood_altar);
    RegisterCreatureAI(npc_blasted_lands_loramus_body);
}
