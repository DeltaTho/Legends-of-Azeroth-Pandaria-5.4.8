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

/* Durotar: the Dranosh'ar Blockade and the north
 *
 * Thunder Down Under (25236)      a laborer on the shore hauls the tethered Drowned Thunder Lizard out
 * Skull Rock (25262)    the Burning Blade cultists outside the cave survive the 5.4 Kor'kron, so players still get their kills
 *
 * The rest of Durotar's scripts are in zone_durotar.cpp.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "SpellScript.h"
#include "SmartAI.h"

namespace
{

enum SkullRock
{
    // NPCs take a cultist down to this share of its health and no further (as creature_sparring_template's limit)
    SKULL_ROCK_NPC_DAMAGE_FLOOR_PCT     = 85,
    // A cultist no player has hit for this long, with no player or player's unit left in its fight, drops the player's tag (ours)
    SKULL_ROCK_TAG_TIMEOUT_MS           = 10 * IN_MILLISECONDS
};

// 3197 Burning Blade Fanatic, 3198 Burning Blade Apprentice (every spawn is at Skull Rock, area 817)
// Since 5.4 the Kor'kron (Grunts 71379, Motivators 71052, Spotters 71055, level 90 elites) camp outside Skull Rock and fight the
// cultists; on retail "the Fanatics aren't dying to them - they're tough" (Wowhead 71055, 2013-09-19), and the 2013-12-13 comment on
// Skull Rock shows a Fanatic holding off eight of them. Here a single Kor'kron hit is far above a cultist's health:
// creature_sparring_template alone only stops it at 1 hp (Unit::DealDamage's first check), which would leave the player a 1-hp
// cultist that gives no loot (the player must do half its health, Creature::IsDamageEnoughForLootingAndReward). So damage from any
// creature no player controls is cut at 85 % of the cultist's health as well; players, their pets and guardians are not limited.
// The cultists' own SmartAI (both TDBs) is kept. Plan ruling R20. Ours: the 85 % (the sparring value used elsewhere here).
struct npc_durotar_skull_rock_cultist : public SmartAI
{
    npc_durotar_skull_rock_cultist(Creature* creature) : SmartAI(creature) { }

    void DamageTaken(Unit* attacker, uint32& damage) override
    {
        SmartAI::DamageTaken(attacker, damage);

        if (attacker && attacker->IsCharmedOwnedByPlayerOrPlayer())
            _lastPlayerHit = getMSTime();

        if (!attacker || attacker == me || attacker->IsCharmedOwnedByPlayerOrPlayer())
            return;

        uint32 const floor = me->CountPctFromMaxHealth(SKULL_ROCK_NPC_DAMAGE_FLOOR_PCT);
        uint32 const health = me->GetHealth();
        damage = health > floor ? std::min(damage, health - floor) : 0;
    }

    // A cultist a player hit and then left (died, ran off) while it goes on fighting a Kor'kron would stay tagged to him at reduced
    // health for good: the core clears a tag only at an evade or a death (SmartAI::EnterEvadeMode, Creature::setDeathState), and the
    // endless fight never evades. Once no player or player's unit of its fight has been within 60 yd for 10 s (dead, run off, on
    // another map or logged out) and none has hit it for 10 s, the tag and the
    // player-damage requirement are cleared and its health is restored, so the next player gets the kill, the loot and the collar
    void UpdateAI(uint32 diff) override
    {
        SmartAI::UpdateAI(diff);

        if (_tagCheckTimer > diff)
        {
            _tagCheckTimer -= diff;
            return;
        }
        _tagCheckTimer = 1000;

        if (!me->IsAlive() || !me->IsInCombat() || !me->HasLootRecipient())
            return;

        // A player (or his unit) of the fight within 60 yd keeps it; one who ran off alive stays on the threat list (the endless
        // fight never evades) but no longer counts once he is farther, on another map or gone
        for (ThreatReference const* ref : me->GetThreatManager().GetUnsortedThreatList())
        {
            Unit* victim = ref->GetVictim();
            if (victim->IsCharmedOwnedByPlayerOrPlayer() && victim->IsInWorld() && victim->IsInMap(me) && me->IsWithinDistInMap(victim, 60.0f))
            {
                _lastPlayerNear = getMSTime();
                return;
            }
        }

        if (getMSTimeDiff(_lastPlayerHit, getMSTime()) < SKULL_ROCK_TAG_TIMEOUT_MS
            || getMSTimeDiff(_lastPlayerNear, getMSTime()) < SKULL_ROCK_TAG_TIMEOUT_MS)
            return;

        me->SetLootRecipient(nullptr);
        me->SetFullHealth();
        me->ResetPlayerDamageReq();
    }

private:
    uint32 _lastPlayerHit = 0;
    uint32 _lastPlayerNear = 0;
    uint32 _tagCheckTimer = 1000;
};

enum ThunderDownUnder
{
    NPC_DROWNED_THUNDER_LIZARD          = 39464,
    NPC_HULKING_ORCISH_LABORER          = 39465,
    SPELL_LIFT_DROWNED_LIZARD_EFFECT    = 73951,
    DATA_LIZARD_HAULED                  = 1
};

// Ours: the nearest dry ground to each of the 19 lizard spawns of the Thunder Ridge lake (ground.py over the 5.4.8 maps: the
// first point at least 3 yd onto land at the water's level, 17.9; the lizards lie 11-31 yd under it, 12-40 yd from these points)
Position const ThunderRidgeShore[] =
{
    { 713.0f, -4018.0f, 19.20f }, { 829.1f, -4008.2f, 22.29f }, { 758.0f, -4045.2f, 23.11f }, { 902.9f, -4140.2f, 19.05f },
    { 988.2f, -4177.1f, 19.48f }, { 916.3f, -4256.7f, 20.63f }, { 948.9f, -3999.6f, 21.02f }, { 985.3f, -4105.6f, 19.22f },
    { 918.5f, -4117.9f, 22.51f }, { 913.6f, -4201.4f, 19.75f }, { 997.9f, -4046.0f, 22.59f }, { 983.5f, -4281.3f, 21.14f },
    { 886.0f, -3993.8f, 21.73f }, { 768.9f, -4085.6f, 21.90f }, { 842.9f, -4084.0f, 22.54f }, { 816.9f, -4011.9f, 22.63f },
    { 840.0f, -4077.2f, 21.13f }, { 865.0f, -4063.5f, 21.88f }, { 918.3f, -4071.6f, 22.19f }
};

// 73945 - Attach Tether (Thunder Down Under 25236; the player's click on a Drowned Thunder Lizard, cast_flags 1)
// Sourced: a 1 s cast attaches the rope (2011-08-09 [+8]), a Hulking Orcish Laborer hauls the carcass out and it is gone (npc
// 39465 [+11]; quest text "I've got grunts that can lift them out"; 2011-11-30 "tether them up to surface"). The spell's summon
// (effect 0, DEST_NEARBY_ENTRY: the lizard itself, by its source-13 condition) would put the laborer inside the carcass on the
// lake floor; it is replaced: the laborer stands on the nearest shore point, facing the lizard, and casts the rope (73951, a
// channelled dummy aura) on it, while the carcass floats up towards him and is gone after 7 s (back in 60 s with its click). The
// lizard stops discharging once hauled (SmartAI phase 2). The credit is effect 1 (KILL_CREDIT2, unchanged), so it does not
// depend on any of this. Ours: the shore points, the haul's way and timings.
class spell_durotar_attach_tether : public SpellScript
{
    PrepareSpellScript(spell_durotar_attach_tether);

    void HandleSummon(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);

        Player* caster = GetCaster()->ToPlayer();
        if (!caster)
            return;

        // The clicked lizard. The spell has no unit target (Spell::InitExplicitTargets drops the clickee), but a right-click selects
        // the unit: the player's selection, if it is a lizard within reach. A selected lizard already being hauled (another player
        // tethered it in the same second) is left alone: both are credited, one laborer. With no lizard selected, the nearest lizard
        // within 8 yd that can still be clicked
        Creature* lizard = nullptr;
        if (Creature* selected = ObjectAccessor::GetCreature(*caster, caster->GetTarget()))
            if (selected->GetEntry() == NPC_DROWNED_THUNDER_LIZARD && selected->IsWithinDistInMap(caster, 10.0f))
            {
                if (!selected->HasFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK))
                    return;
                lizard = selected;
            }
        if (!lizard)
        {
            std::list<Creature*> lizards;
            caster->GetCreatureListWithEntryInGrid(lizards, NPC_DROWNED_THUNDER_LIZARD, 8.0f);
            for (Creature* candidate : lizards)
                if (candidate->IsAlive() && candidate->HasFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK)
                    && (!lizard || caster->GetExactDist(candidate) < caster->GetExactDist(lizard)))
                    lizard = candidate;
        }
        if (!lizard)
            return;

        Position const* shore = &ThunderRidgeShore[0];
        for (Position const& pos : ThunderRidgeShore)
            if (lizard->GetExactDist(&pos) < lizard->GetExactDist(shore))
                shore = &pos;

        lizard->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);
        lizard->InterruptNonMeleeSpells(false);
        if (lizard->IsAIEnabled)
            lizard->AI()->SetData(DATA_LIZARD_HAULED, 1);

        // The rope is cast triggered (no cast bar to break) and ignores line of sight (disables 73951, flag 64): a bank between the
        // shore point and a lizard deep under the water must not leave a man standing on a beach. Passive, so a passing beast does
        // not draw him into a fight that would cut the channel
        if (Creature* laborer = caster->SummonCreature(NPC_HULKING_ORCISH_LABORER, *shore, TEMPSUMMON_TIMED_DESPAWN, 9000ms))
        {
            laborer->SetReactState(REACT_PASSIVE);
            laborer->SetFacingToObject(lizard);
            laborer->CastSpell(lizard, SPELL_LIFT_DROWNED_LIZARD_EFFECT, true);
        }

        // Up the rope: to 5 yd short of the laborer, straight (gravity off; it is a carcass)
        float dist = lizard->GetExactDist(shore);
        float f = dist > 5.0f ? (dist - 5.0f) / dist : 0.0f;
        lizard->SetDisableGravity(true);
        lizard->GetMotionMaster()->MovePoint(0, lizard->GetPositionX() + (shore->GetPositionX() - lizard->GetPositionX()) * f,
            lizard->GetPositionY() + (shore->GetPositionY() - lizard->GetPositionY()) * f,
            lizard->GetPositionZ() + (shore->GetPositionZ() - lizard->GetPositionZ()) * f, false);
        lizard->DespawnOrUnsummon(7000);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_durotar_attach_tether::HandleSummon, EFFECT_0, SPELL_EFFECT_SUMMON);
    }
};

} // namespace

void AddSC_durotar_blockade()
{
    new creature_script<npc_durotar_skull_rock_cultist>("npc_durotar_skull_rock_cultist");
    new spell_script<spell_durotar_attach_tether>("spell_durotar_attach_tether");
}
