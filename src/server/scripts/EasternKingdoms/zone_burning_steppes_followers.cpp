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

/* Burning Steppes: the story followers.
   John J. Keeshan (Alliance) and Ariok (Horde) go with the player three times, each time as another entry summoned by a "Summon
   Personal Guardian" spell (SummonProperties 3007: an ally guardian, public, no summon slot; AreaGroup 2830 = zone 46 only):
   - 01 for Chiselgrip, the Heart of the Steppes 28184 / 28426 (89674 Keeshan 48246, 90481 Ariok 48562);
   - 02 with Colonel Troteman / Eitrigg for Morgan's Vigil 28310 / Flame Crest 28442 (89868 Keeshan 48345 + 89871 Troteman 48347,
     90482 Ariok 48566 + 90485 Eitrigg 48570);
   - 03 for the Blood Tour group 28314-28316 / 28446-28448 and Glory Amidst Chaos 28321 / 28455 (89869 Keeshan 48346, 90483 Ariok
     48567); the 03 copies offer the other two quests of the group and take Blood Tour and Draconic Vanguard in the field.
   Nothing cast the spells: spell_area now does (2026_11_22_50-52), while one of the quests is in the log, complete or not.

   What the player sees (sources: warcraft.wiki.gg quest pages 28184, 28426, 28310, 28442, 28314, 28446, 28321 and Wowhead
   comments, R\evidence\web-research-gate1.md Q3):
   - On accept he appears beside the player and goes with him across the steppes, on foot or mounted ("runs fast enough to keep up
     with you while you ride").
   - He attacks a mob only once it hits the player, not when it hits the player's pet or minion; otherwise he shouts his aggro lines
     while the player fights and stands by (wiki 28184 / 28426 / 28446 notes). Lines: Keeshan broadcast 50371-50381, Ariok 50383 and
     50389-50397 (plan K6), said on engaging, on a kill and while he watches, with one shared cooldown (cooldown ours).
   - He leaves when his quest leaves the log: at the hand-in (Stebben for Chiselgrip, where the camp copy then stands south / west
     of him; Oralius / Kibler for the 02 pair; the last of the Blood Tour group, and Glory), on abandon, and when the player leaves
     the Burning Steppes.
   Ours (no source says): defends himself when attacked; while the player rides he follows and fights only what turns on him; one
   left more than 100 yd behind is brought to the player; one that dies comes back 30 s later while the quest is still held (a
   Glory comment says retail never brought him back, a fault); he is not with the player on a flight path and is back within 5 s of
   landing; the template's health modifier is applied (the guardian summon ignores it). */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "TemporarySummon.h"
#include "MotionMaster.h"
#include "DBCStores.h"
#include "SpellMgr.h"
#include "Random.h"

namespace BurningSteppesFollowers
{
enum
{
    SUMMON_PROPERTIES_PERSONAL_GUARDIAN = 3007,

    SAY_FOLLOWER_AGGRO                  = 0,

    EVENT_FOLLOWER_SETUP                = 1,
    EVENT_FOLLOWER_ASSIST,
    EVENT_FOLLOWER_CHECK,
};

struct FollowerInfo
{
    uint32 Entry;
    uint32 Spell;       // its summon; effect 1 is the dummy aura on the player that stands for "he is with you"
    bool Talks;         // Keeshan and Ariok shout; Troteman and Eitrigg have no lines
    float FollowAngle;  // the 02 pair walk on both sides of the player
};

FollowerInfo const Followers[] =
{
    { 48246, 89674, true,  float(M_PI / 2) },       // John J. Keeshan 01 - Chiselgrip, the Heart of the Steppes 28184
    { 48562, 90481, true,  float(M_PI / 2) },       // Ariok 01 - Chiselgrip, the Heart of the Steppes 28426
    { 48345, 89868, true,  float(M_PI / 2) },       // John J. Keeshan 02 - Morgan's Vigil 28310
    { 48347, 89871, false, float(3 * M_PI / 2) },   // Colonel Troteman - Morgan's Vigil 28310
    { 48566, 90482, true,  float(M_PI / 2) },       // Ariok 02 - Flame Crest 28442
    { 48570, 90485, false, float(3 * M_PI / 2) },   // Eitrigg - Flame Crest 28442
    { 48346, 89869, true,  float(M_PI / 2) },       // John J. Keeshan 03 - Blood Tour group 28314-28316, Glory Amidst Chaos 28321
    { 48567, 90483, true,  float(M_PI / 2) },       // Ariok 03 - Blood Tour group 28446-28448, Glory Amidst Chaos 28455
};

float const FOLLOWER_LEASH_DISTANCE = 100.0f;   // plan.md section 9: re-join a follower left more than 100 yd behind
float const FOLLOWER_ASSIST_RANGE   = 50.0f;
uint32 const FOLLOWER_CORPSE_TIME   = 30 * IN_MILLISECONDS;

FollowerInfo const* GetInfoByEntry(uint32 entry)
{
    for (FollowerInfo const& info : Followers)
        if (info.Entry == entry)
            return &info;
    return nullptr;
}

FollowerInfo const* GetInfoBySpell(uint32 spell)
{
    for (FollowerInfo const& info : Followers)
        if (info.Spell == spell)
            return &info;
    return nullptr;
}

// His living copy among the player's minions; a corpse is reported through hasCorpse
Creature* FindFollower(Unit* owner, uint32 entry, bool* hasCorpse = nullptr)
{
    Creature* living = nullptr;
    std::list<Creature*> minions;
    owner->GetAllMinionsByEntry(minions, entry);
    for (Creature* minion : minions)
    {
        if (minion->IsDestroyedObject() || !minion->IsInWorld())
            continue;
        if (minion->IsAlive())
            living = minion;
        else if (hasCorpse)
            *hasCorpse = true;
    }
    return living;
}

// The summon as the spell's own effect makes it (Spell::EffectSummonType -> SummonGuardian for SummonProperties 3007, which has
// flag 0x200): an ally guardian at the player's level and with his faction, public, owned by the player (his kills credit the
// player, he goes with the player at logout). Done here so that the periodic re-summon is the same summon as the cast's.
Creature* SummonFollower(Player* player, FollowerInfo const& info)
{
    SummonPropertiesEntry const* properties = sSummonPropertiesStore.LookupEntry(SUMMON_PROPERTIES_PERSONAL_GUARDIAN);
    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(info.Spell);
    if (!properties || !spellInfo || !player->IsInWorld())
        return nullptr;

    Position pos = player->GetNearPosition(2.0f, info.FollowAngle);
    TempSummon* summon = player->GetMap()->SummonCreature(info.Entry, pos, properties, Milliseconds(spellInfo->GetDuration()), player, info.Spell);
    if (!summon)
        return nullptr;

    if (summon->HasUnitTypeMask(UNIT_MASK_GUARDIAN))
        static_cast<Guardian*>(summon)->InitStatsForLevel(player->GetLevel());
    summon->SetFaction(player->GetFaction());
    if (summon->HasUnitTypeMask(UNIT_MASK_MINION))
        static_cast<Minion*>(summon)->SetFollowAngle(info.FollowAngle);

    TC_LOG_DEBUG("scripts", "Burning Steppes follower %u summoned for %s (spell %u)", info.Entry, player->GetName().c_str(), info.Spell);
    return summon;
}
} // namespace BurningSteppesFollowers

using namespace BurningSteppesFollowers;

// 89674, 90481, 89868, 89871, 90482, 90485, 89869, 90483 - Summon Personal Guardian (effect 0, the summon)
// Cast on the player by spell_area (zone 46) while the follower's quest is in his log: on accept, at login (the aura is DONT_SAVE),
// after resurrection (Player::ResurrectPlayer -> UpdateZone) and on entering the zone. Never two: a player who still has a living
// follower of that entry keeps him. A player who is dead or on a flight path gets the aura without the follower; the aura's
// periodic check below brings him once the player is alive and on the ground.
class spell_burning_steppes_follower_summon : public SpellScript
{
    PrepareSpellScript(spell_burning_steppes_follower_summon);

    void HandleSummon(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);

        Player* player = GetCaster() ? GetCaster()->ToPlayer() : nullptr;
        FollowerInfo const* info = GetInfoBySpell(GetSpellInfo()->Id);
        if (!player || !info || !player->IsAlive() || player->IsInFlight())
            return;

        if (FindFollower(player, info->Entry))
            return;

        SummonFollower(player, *info);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_burning_steppes_follower_summon::HandleSummon, EFFECT_0, SPELL_EFFECT_SUMMON);
    }
};

// The same spells, effect 1 (the dummy aura on the player)
// The summon is not tied to the aura in this core, so he goes with it here: the aura is removed by spell_area when his quest leaves
// the log (hand-in, abandon), when the player leaves the zone (the spell's AreaGroup), at death and at logout. Every 5 s, while the
// aura stays: a player alive and not on a flight path who has no follower (he died more than 30 s ago and his corpse is gone, or
// the player has just landed) gets him again.
class spell_burning_steppes_follower_aura : public AuraScript
{
    PrepareAuraScript(spell_burning_steppes_follower_aura);

    void CalcPeriodic(AuraEffect const* /*aurEff*/, bool& isPeriodic, int32& amplitude)
    {
        isPeriodic = true;
        amplitude = 5 * IN_MILLISECONDS;
    }

    void OnPeriodic(AuraEffect const* /*aurEff*/)
    {
        PreventDefaultAction();

        Player* player = GetTarget()->ToPlayer();
        FollowerInfo const* info = GetInfoBySpell(GetId());
        if (!player || !info || !player->IsInWorld() || !player->IsAlive() || player->IsInFlight())
            return;

        bool hasCorpse = false;
        if (FindFollower(player, info->Entry, &hasCorpse) || hasCorpse)
            return;

        SummonFollower(player, *info);
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (FollowerInfo const* info = GetInfoBySpell(GetId()))
            GetTarget()->RemoveAllMinionsByEntry(info->Entry);
    }

    void Register() override
    {
        DoEffectCalcPeriodic += AuraEffectCalcPeriodicFn(spell_burning_steppes_follower_aura::CalcPeriodic, EFFECT_1, SPELL_AURA_DUMMY);
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_burning_steppes_follower_aura::OnPeriodic, EFFECT_1, SPELL_AURA_DUMMY);
        AfterEffectRemove += AuraEffectRemoveFn(spell_burning_steppes_follower_aura::AfterRemove, EFFECT_1, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

// 48246, 48562, 48345, 48347, 48566, 48570, 48346, 48567 - Keeshan / Ariok 01-03, Colonel Troteman, Eitrigg following the player
// - A plain guardian starts aggressive (Guardian::InitStats) and pulls every pack he passes: he is defensive here and starts no fight
//   of his own (no line-of-sight aggro).
// - He attacks what attacks the player (the player's attackers: a mob that hits the pet is not one of them), within 50 yd, and what
//   attacks him. While the player rides he only answers what has turned on him, and a fight he was only flagged into is dropped.
// - While the player fights something that is not hitting him, Keeshan / Ariok shout a line now and then and stand by.
// - Gone when his owner is gone, dead, on a flight path, or lacks the summon aura; brought to the player when more than 100 yd
//   behind (not while the player flies or rides a vehicle: he follows on the ground meanwhile).
struct npc_burning_steppes_follower : public ScriptedAI
{
    npc_burning_steppes_follower(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        _info = GetInfoByEntry(me->GetEntry());
        if (!_info || summoner->GetTypeId() != TYPEID_PLAYER)
            return;

        _ownerGUID = summoner->GetGUID();
        me->SetReactState(REACT_DEFENSIVE);
        // Left behind out of every player's sight his grid would stop updating and he would stand there for good: active, Check()
        // brings him along
        me->setActive(true, ActiveFlags::Script);

        _events.Reset();
        // Level, health and faction are set by SummonFollower after this hook
        _events.ScheduleEvent(EVENT_FOLLOWER_SETUP, 500ms);
        _events.ScheduleEvent(EVENT_FOLLOWER_ASSIST, 1s);
        _events.ScheduleEvent(EVENT_FOLLOWER_CHECK, 1s);
    }

    Player* GetOwnerPlayer() const
    {
        return ObjectAccessor::GetPlayer(*me, _ownerGUID);
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }

    void AttackStart(Unit* who) override
    {
        if (!who)
            return;

        // Riding past: only what has turned on him
        if (Player* owner = GetOwnerPlayer())
            if (owner->IsMounted() && who->GetVictim() != me)
                return;

        ScriptedAI::AttackStart(who);
    }

    void JustEngagedWith(Unit* /*who*/) override
    {
        TryTalk();
    }

    void KilledUnit(Unit* /*victim*/) override
    {
        TryTalk();
    }

    void JustDied(Unit* /*killer*/) override
    {
        _events.Reset();
        // The corpse stays 30 s; the summon aura's periodic check brings a new one after it is gone
        me->DespawnOrUnsummon(FOLLOWER_CORPSE_TIME);
    }

    void TryTalk()
    {
        if (!_info || !_info->Talks || _talkCooldown)
            return;

        Talk(SAY_FOLLOWER_AGGRO);
        _talkCooldown = urand(10, 20) * IN_MILLISECONDS;
    }

    // Once: the guardian summon took level and health from the base stats of the player's level and left out the template's health
    // modifier (Guardian::InitStatsForLevel); TDB 4.4.2 gives Keeshan and Ariok 2, Troteman 1.1, Eitrigg 20
    void Setup()
    {
        if (CreatureTemplate const* cinfo = me->GetCreatureTemplate())
            if (cinfo->ModHealth > 0.0f && cinfo->ModHealth != 1.0f)
            {
                me->SetCreateHealth(uint32(me->GetCreateHealth() * cinfo->ModHealth));
                me->UpdateMaxHealth();
                me->SetFullHealth();
            }

        if (Player* owner = GetOwnerPlayer())
            if (!me->IsInCombat() && !me->GetVictim())
            {
                me->GetMotionMaster()->Clear(false);
                me->GetMotionMaster()->MoveFollow(owner, PET_FOLLOW_DIST, me->GetFollowAngle());
            }
    }

    bool Check()
    {
        Player* owner = GetOwnerPlayer();
        if (!owner || !owner->IsInWorld() || owner->GetMapId() != me->GetMapId() || !owner->IsAlive() || owner->IsInFlight()
            || !owner->HasAura(_info->Spell))
        {
            TC_LOG_DEBUG("scripts", "Burning Steppes follower %u leaves (owner gone, dead, flying a taxi or without aura %u)", me->GetEntry(), _info->Spell);
            me->DespawnOrUnsummon();
            return false;
        }

        if (!me->IsWithinDistInMap(owner, FOLLOWER_LEASH_DISTANCE) && !owner->IsFlying() && !owner->GetVehicle())
        {
            if (me->IsInCombat() || me->GetVictim())
                EnterEvadeMode(EVADE_REASON_OTHER);

            Position pos = owner->GetNearPosition(2.0f, me->GetFollowAngle());
            me->NearTeleportTo(pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), owner->GetOrientation());
            me->GetMotionMaster()->Clear(false);
            me->GetMotionMaster()->MoveFollow(owner, PET_FOLLOW_DIST, me->GetFollowAngle());
        }
        return true;
    }

    void Assist()
    {
        Player* owner = GetOwnerPlayer();
        if (!owner || !owner->IsAlive())
            return;

        if (owner->IsMounted())
        {
            // A mounted player fights nothing; a follower in a fight he was only flagged into follows instead
            if (me->IsInCombat() && me->getAttackers().empty())
                EnterEvadeMode(EVADE_REASON_OTHER);
            return;
        }

        if (me->GetVictim())
            return;

        // Only what hits the player: his attackers, not his pet's
        for (Unit* attacker : owner->getAttackers())
            if (attacker && attacker->IsAlive() && me->IsWithinDistInMap(attacker, FOLLOWER_ASSIST_RANGE) && me->IsValidAttackTarget(attacker))
            {
                AttackStart(attacker);
                return;
            }

        // The player fights something that does not hit him (his pet holds it, or it has not reached him): lines, no help
        if (owner->IsInCombat() && owner->GetVictim())
            TryTalk();
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_info)
            return;

        if (_talkCooldown)
            _talkCooldown = _talkCooldown > diff ? _talkCooldown - diff : 0;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_FOLLOWER_SETUP:
                    Setup();
                    break;
                case EVENT_FOLLOWER_ASSIST:
                    Assist();
                    _events.ScheduleEvent(EVENT_FOLLOWER_ASSIST, 1s);
                    break;
                case EVENT_FOLLOWER_CHECK:
                    if (!Check())
                        return;
                    _events.ScheduleEvent(EVENT_FOLLOWER_CHECK, 1s);
                    break;
                default:
                    break;
            }
        }

        // Not UpdateVictim: for a guardian Creature::SelectVictim falls back to the owner's victim and to the attackers of
        // everything the owner controls (his pet included), so after a kill he went on to the pet's mob. Only what attacks the
        // player or himself are taken as new victims (review C-E M3).
        if (!me->IsInCombat() && !me->GetVictim())
            return;

        Unit* target = SelectAllowedVictim();
        if (!target)
        {
            EnterEvadeMode(EVADE_REASON_NO_HOSTILES);
            return;
        }

        if (target != me->GetVictim())
            AttackStart(target);

        DoMeleeAttackIfReady();
    }

    // His victim until it dies or he evades; a new one only among the attackers of the player, else his own
    Unit* SelectAllowedVictim() const
    {
        Player* owner = GetOwnerPlayer();
        auto canFight = [this](Unit* target)
        {
            return target && target->IsAlive() && me->IsWithinDistInMap(target, FOLLOWER_ASSIST_RANGE) && me->IsValidAttackTarget(target);
        };

        // Once engaged he stays on his mob until it dies or he evades, even if it turns to the pet or a tank (review M2);
        // the "only what hits the player or me" rule is for choosing a new one
        Unit* victim = me->GetVictim();
        if (canFight(victim))
            return victim;

        if (owner && !owner->IsMounted())
            for (Unit* attacker : owner->getAttackers())
                if (canFight(attacker))
                    return attacker;

        for (Unit* attacker : me->getAttackers())
            if (canFight(attacker))
                return attacker;

        return nullptr;
    }

private:
    FollowerInfo const* _info = nullptr;
    ObjectGuid _ownerGUID;
    EventMap _events;
    uint32 _talkCooldown = 0;
};

void AddSC_burning_steppes_followers()
{
    new spell_script<spell_burning_steppes_follower_summon>("spell_burning_steppes_follower_summon");
    new aura_script<spell_burning_steppes_follower_aura>("spell_burning_steppes_follower_aura");
    new creature_script<npc_burning_steppes_follower>("npc_burning_steppes_follower");
}
