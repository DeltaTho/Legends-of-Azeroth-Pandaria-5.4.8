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
           Shadowsworn Obstructor waves; 25695 (Horde) / 26174 (Alliance) Watching Our Back - the walking Portal-Sentries
           catch a reader of the plans
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
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "CreatureTextMgr.h"
#include "Random.h"

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
    SPELL_LORAMUS_RITUAL_AURA       = 77211,    // template addon aura of the body (dummy, the ritual's look)

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
                    _events.ScheduleEvent(EVENT_BODY_WALK_OFF, 2000);
                    break;
                case EVENT_BODY_WALK_OFF:
                    // "he'll leave and head back to the cave" (25688 2011-04-28 [+5]): off the altar and down the ramp on foot,
                    // gone on arrival (MovementInform). About 48 yd at walking speed (2.5 yd/s): ~20 s; the 40 s despawn only
                    // catches a walk that never arrives
                    me->RemoveAurasDueToSpell(SPELL_LORAMUS_RITUAL_AURA);
                    me->SetDisableGravity(false);
                    me->SetFall(false); // SetDisableGravity(false) marks a non-flyer falling; NO_MOVE_FLAGS_UPDATE leaves it set
                    me->SetAnimTier(AnimTier::Ground);
                    me->SetWalk(true);
                    me->GetMotionMaster()->MovePoint(POINT_BODY_RAMP, LoramusBodyWalkOff);
                    _events.ScheduleEvent(EVENT_BODY_DESPAWN, 40000);
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

/* Shadowsworn Obstructor 41191, summoned round the altar by Loramus' Body (77092 / 77115 / 77116 / 77118 / 77120, 180 s).
   What the player sees (25688 2010-12-19 [+71] and replies, 2011-02-19 [+2], 2011-04-24, 2011-05-25 [+1], 2011-01-13 [-1]): they
   channel green lightning at the body and keep moving about; a player who comes near, mounted or not, pulls them off the body and
   they chase him round the platform; attacked, they stop channelling and fight.
   Sourced: the channel's timers (first after 2-4.5 s, then every 18-19 s) and the in-combat Disrupt Ritual on the victim, as the
   SmartAI row both TDBs have. Ours: the wander between channels to points within 4 yd of the summon spot (anchored there, so they
   never drift); the pull range while they work for the body: 5 yd instead of the aggro radius (~20 yd at equal level, 18-22 for
   levels 54-58). The nearest summon spot (77092, north) is 15.4 yd from the altar, so with the default radius a player standing at
   the altar to click it pulled the first wave before it ever channelled; at 5 yd a player within 5 yd of the altar's centre and an
   Obstructor wandered 4 yd towards it are still 6.4 yd apart, while riding or running over them (the sources' tactic) pulls them.
   Back to channelling after an evade; gone as soon as the body is gone (the body also despawns them on success and on death). A
   static or GM-spawned Obstructor (no body) is a plain mob. */
enum ShadowswornObstructor
{
    EVENT_OBSTRUCTOR_CHANNEL        = 1,
    EVENT_OBSTRUCTOR_WANDER,
    EVENT_OBSTRUCTOR_CHECK_BODY,
    EVENT_OBSTRUCTOR_DISRUPT,

    POINT_OBSTRUCTOR_WANDER         = 1,
};

static float const OBSTRUCTOR_PULL_RANGE = 5.0f;
static float const OBSTRUCTOR_WANDER_RADIUS = 4.0f;

struct npc_blasted_lands_shadowsworn_obstructor : public ScriptedAI
{
    npc_blasted_lands_shadowsworn_obstructor(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (summoner && summoner->GetEntry() == NPC_LORAMUS_BODY)
            _bodyGUID = summoner->GetGUID();
        _anchor = me->GetPosition();
        ScheduleRitualWork();
    }

    // Also after an evade (CreatureAI::EnterEvadeMode): back to the body once home
    void Reset() override
    {
        _combatEvents.Reset();
        ScheduleRitualWork();
    }

    // While it works for the body, only a unit within 5 yd pulls it (see above); damage and assistance still engage it as usual
    void MoveInLineOfSight(Unit* who) override
    {
        if (_bodyGUID && !me->IsInCombat() && !me->IsWithinDistInMap(who, OBSTRUCTOR_PULL_RANGE))
            return;

        ScriptedAI::MoveInLineOfSight(who);
    }

    void EnterCombat(Unit* /*who*/) override
    {
        // Unit::SetInCombatState moves the home position to where a point movement (the wander) was engaged: back to the spot
        if (_bodyGUID)
            me->SetHomePosition(_anchor);
        _ritualEvents.Reset();
        me->InterruptNonMeleeSpells(false);
        _combatEvents.ScheduleEvent(EVENT_OBSTRUCTOR_DISRUPT, urand(2000, 4500));
    }

    void UpdateAI(uint32 diff) override
    {
        if (!UpdateVictim())
        {
            UpdateRitualWork(diff);
            return;
        }

        _combatEvents.Update(diff);
        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = _combatEvents.ExecuteEvent())
        {
            if (eventId == EVENT_OBSTRUCTOR_DISRUPT)
            {
                DoCastVictim(SPELL_DISRUPT_RITUAL);
                _combatEvents.ScheduleEvent(EVENT_OBSTRUCTOR_DISRUPT, urand(18000, 19000));
            }
        }

        DoMeleeAttackIfReady();
    }

private:
    Creature* GetBody() const
    {
        Creature* body = _bodyGUID ? ObjectAccessor::GetCreature(*me, _bodyGUID) : nullptr;
        return body && body->IsAlive() ? body : nullptr;
    }

    void ScheduleRitualWork()
    {
        _ritualEvents.Reset();
        if (!_bodyGUID)
            return;

        _ritualEvents.ScheduleEvent(EVENT_OBSTRUCTOR_CHANNEL, urand(2000, 4500));
        _ritualEvents.ScheduleEvent(EVENT_OBSTRUCTOR_CHECK_BODY, 1000);
    }

    // Out of combat: channel at the body, wander between channels. The channel does not put either side in combat (the body has
    // combat disallowed), so a player coming near still pulls them (CreatureAI::MoveInLineOfSight, REACT_AGGRESSIVE).
    void UpdateRitualWork(uint32 diff)
    {
        _ritualEvents.Update(diff);
        while (uint32 eventId = _ritualEvents.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_OBSTRUCTOR_CHECK_BODY:
                    if (!GetBody())
                    {
                        me->DespawnOrUnsummon();
                        return;
                    }
                    _ritualEvents.ScheduleEvent(EVENT_OBSTRUCTOR_CHECK_BODY, 1000);
                    break;
                case EVENT_OBSTRUCTOR_CHANNEL:
                {
                    Creature* body = GetBody();
                    if (!body)
                        break;
                    if (me->HasUnitState(UNIT_STATE_EVADE) || me->HasUnitState(UNIT_STATE_CASTING))
                    {
                        _ritualEvents.ScheduleEvent(EVENT_OBSTRUCTOR_CHANNEL, 1000);
                        break;
                    }
                    me->GetMotionMaster()->Clear(false);
                    me->GetMotionMaster()->MoveIdle();
                    me->StopMoving();
                    me->SetFacingToObject(body);
                    me->CastSpell(body, SPELL_DISRUPT_RITUAL, true);
                    _ritualEvents.ScheduleEvent(EVENT_OBSTRUCTOR_WANDER, 10500);
                    _ritualEvents.ScheduleEvent(EVENT_OBSTRUCTOR_WANDER, 14500);
                    _ritualEvents.ScheduleEvent(EVENT_OBSTRUCTOR_CHANNEL, urand(18000, 19000));
                    break;
                }
                case EVENT_OBSTRUCTOR_WANDER:
                    // A point within 4 yd of the summon spot, not of where it stands: MoveRandom would
                    // re-centre on the current spot and let it drift
                    if (!me->HasUnitState(UNIT_STATE_EVADE) && !me->HasUnitState(UNIT_STATE_CASTING))
                    {
                        float x, y, z;
                        me->GetRandomPoint(_anchor, OBSTRUCTOR_WANDER_RADIUS, x, y, z);
                        me->GetMotionMaster()->MovePoint(POINT_OBSTRUCTOR_WANDER, x, y, z);
                    }
                    break;
                default:
                    break;
            }
        }
    }

    EventMap _ritualEvents;
    EventMap _combatEvents;
    ObjectGuid _bodyGUID;
    Position _anchor;
};

/*######
## Watching Our Back (25695 Horde / 26174 Alliance): Caught in the Act
##
## What the player sees (sources: comments 25695 2011-12-18 [+677], 2010-11-25 [+126], 2010-12-02 [+95], 2012-01-28 [+17],
## 2013-08-19 [+6] and reply, 2011-07-18 [-1]; 26174 2010-11-23 [+49], 2011-01-14 [+30], [+29] and replies, 2012-03, 2012-05,
## 2013-11; the wiki notes; the spells 77360 / 77361 / 77363 / 77364 / 77366 and 77366's spell_target_position; broadcast texts
## 41206, 41207, 41208, 42246):
## The player reads the other side's plans (a 10 s "Examining" cast on the plans by the cart / under the tent). Two Portal-Sentries
## walk a beat round each camp; if one of them faces the reader during the cast, it whispers "Begone, Horde thief!" / "Begone,
## Alliance thief!" or "Get away from those!" / "What do you think you're doing?", the cast stops and the reader is teleported next
## to his own commander (no stun, no damage); he can try again at once. A pet in the sentry's view gives its master away (only a
## combat pet or guardian: not a vanity pet or a totem, ours). Horde
## readers were also caught by a Horde sentry (2013-08-19 [+6]); standing on the tent roof or on top of the crates hid a reader.
##
## Ours (no source says how): only the four walking sentries detect (the comments only speak of the walkers), checked every
## second (77361's period) for the whole cast; their sight: 20 yd (77360's radius), a 100 degree arc in front, line of sight, and
## the reader (or his pet) at most 3 yd above the sentry's feet (the roof / crate reports); stealth and invisibility the sentry
## cannot see through hide the reader; a sentry of the reader's own faction whispers only "Get away from those!" / "What do you
## think you're doing?".
##
## Core notes: 77361 periodically casts 77360, a 4 s stun on every enemy in a cone, with a DUMMY second effect nobody scripts; the
## sentries are neutral and IMMUNE_TO_PC, so the cone would not pick players anyway. The AuraScript takes over the period instead
## of the trigger and selects the reader in code.
######*/

enum CaughtInTheAct
{
    SPELL_PORTAL_SENTRY_TRIGGER_AURA = 77361,   // on the four walking sentries (creature_addon)
    SPELL_EXAMINING                 = 77364,    // the plans' lock spell (lock 1900), 10 s
    SPELL_TELEPORT_TO_COMMANDERS    = 77366,    // spell_target_position (-11811.8, -3190.42, -30.7075)

    NPC_ALLIANCE_PORTAL_SENTRY      = 41269,
    NPC_HORDE_PORTAL_SENTRY         = 42301,

    // creature_text of both sentries
    SAY_SENTRY_BEGONE_THIEF         = 0,        // 41208 "Begone, Horde thief!" (41269) / 42246 "Begone, Alliance thief!" (42301)
    SAY_SENTRY_CAUGHT               = 1,        // 41206 "Get away from those!" / 41207 "What do you think you're doing?"
};

static float const SENTRY_SIGHT_RANGE = 20.0f;
static float const SENTRY_SIGHT_ARC = float(M_PI) * 100.0f / 180.0f;
static float const SENTRY_SIGHT_MAX_ABOVE = 3.0f;

class spell_blasted_lands_portal_sentry_trigger : public AuraScript
{
    PrepareAuraScript(spell_blasted_lands_portal_sentry_trigger);

    static bool IsReadingPlans(Player const* player)
    {
        Spell const* spell = player->GetCurrentSpell(CURRENT_GENERIC_SPELL);
        return spell && spell->GetSpellInfo()->Id == SPELL_EXAMINING;
    }

    // The reader's combat pet or guardian (a hunter's or warlock's pet, a ghoul, a treant...): not a vanity pet or a totem
    static bool IsCombatCompanion(Unit const* unit)
    {
        if (unit->IsTotem() || !unit->HasUnitTypeMask(UNIT_MASK_GUARDIAN))
            return false;
        Creature const* creature = unit->ToCreature();
        return !creature || creature->GetCreatureType() != CREATURE_TYPE_NON_COMBAT_PET;
    }

    static bool Sees(Creature const* sentry, Unit const* who)
    {
        return who->IsInWorld() && who->IsAlive() && sentry->IsWithinDistInMap(who, SENTRY_SIGHT_RANGE)
            && sentry->HasInArc(SENTRY_SIGHT_ARC, who)
            && who->GetPositionZ() - sentry->GetPositionZ() <= SENTRY_SIGHT_MAX_ABOVE
            && sentry->CanSeeOrDetect(who) && sentry->IsWithinLOSInMap(who);
    }

    void HandlePeriodic(AuraEffect const* /*aurEff*/)
    {
        PreventDefaultAction(); // no 77360 cone stun

        Creature* sentry = GetTarget()->ToCreature();
        if (!sentry || !sentry->IsAlive() || sentry->IsInCombat())
            return;

        std::list<Player*> players;
        sentry->GetPlayerListInGrid(players, SENTRY_SIGHT_RANGE + 40.0f);
        for (Player* reader : players)
        {
            if (!reader->IsAlive() || reader->IsGameMaster() || !IsReadingPlans(reader))
                continue;

            bool caught = Sees(sentry, reader);
            if (!caught)
            {
                for (Unit* controlled : reader->m_Controlled)
                {
                    if (controlled && IsCombatCompanion(controlled) && Sees(sentry, controlled))
                    {
                        caught = true;
                        break;
                    }
                }
            }

            if (caught)
                Catch(sentry, reader);
        }
    }

    static void Catch(Creature* sentry, Player* reader)
    {
        bool const otherSide = (sentry->GetEntry() == NPC_ALLIANCE_PORTAL_SENTRY && reader->GetTeam() == HORDE)
            || (sentry->GetEntry() == NPC_HORDE_PORTAL_SENTRY && reader->GetTeam() == ALLIANCE);
        uint8 const line = (otherSide && roll_chance_i(50)) ? SAY_SENTRY_BEGONE_THIEF : SAY_SENTRY_CAUGHT;

        reader->InterruptNonMeleeSpells(false);
        sCreatureTextMgr->SendChat(sentry, line, reader);
        sentry->CastSpell(reader, SPELL_TELEPORT_TO_COMMANDERS, true);
        TC_LOG_DEBUG("scripts", "Blasted Lands: Portal-Sentry %u caught player %u reading the plans", sentry->GetDBTableGUIDLow(),
            reader->GetGUID().GetCounter());
    }

    void Register() override
    {
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_blasted_lands_portal_sentry_trigger::HandlePeriodic, EFFECT_0, SPELL_AURA_PERIODIC_TRIGGER_SPELL);
    }
};

void AddSC_blasted_lands_bloodstone()
{
    RegisterGameObjectAI(go_blasted_lands_blood_altar);
    RegisterCreatureAI(npc_blasted_lands_loramus_body);
    RegisterCreatureAI(npc_blasted_lands_shadowsworn_obstructor);
    new aura_script<spell_blasted_lands_portal_sentry_trigger>("spell_blasted_lands_portal_sentry_trigger");
}
