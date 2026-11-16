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
SDName: Searing Gorge, Thorium Point events
SDComment: Quest support: 27981 Heat That Just Don't Quit
SDCategory: Searing Gorge
EndScriptData */

#include "ScriptMgr.h"
#include "SpellScript.h"
#include "SpellAuras.h"
#include "Player.h"
#include "Creature.h"
#include "Log.h"

enum ThoriumPointSpells
{
    SPELL_FILL_FURNACE_FLASK = 88418, // Furnace Flasks 62826 on use: eff0 DUMMY on the target, eff1 CREATE_ITEM 62827 on the caster
    SPELL_SHRINK             = 42824, // "Result: Shrink": MOD_SCALE -25 %, infinite, no school or mechanic an elemental is immune to
};

// 88418 - Fill Furnace Flask (27981 Heat That Just Don't Quit). Which targets are valid is the spell's conditions' (a living Blazing,
// Inferno or Magma Elemental or Rasha'krak). This script adds what the players saw: the sampled elemental shrinks ("It will shrink
// down to fun-size", wiki; comment 2012-08-19 "if you see the mobs shrink"). The shrink is only the look of a sampled elemental:
// it never refuses another fill, so one living elemental gives as many flasks as the player wants (2012-09-02 [+22] "as many of the
// quest items as you want from that single mob"; 2011-03-20 "spam the bottle on him 10 times" on Rasha'krak; the less grindy reading
// over the 2010-12-04 "patched ... Invalid Target" reply). The shrink spell is ours: nothing on disk names retail's.
// The shrink is added with the player as its caster, not cast by the elemental on itself: SmartAI's evade keeps the creature's own
// auras (SmartAI::RemoveAuras skips caster == me), so a self-cast shrink would outlive a reset on 5852 / 5855 / 47553. A player's
// aura goes on every evade (SmartAI::RemoveAuras, CreatureAI::_EnterEvadeMode for 5850) and on death. One shrink only: 42824 has a stack count
// (SpellAuraOptions 2595), so a shrunken elemental is not shrunk further.
// Bags full: Spell::CheckItems refuses the cast before it hits ("Inventory is full"), so the elemental does not shrink. Retail shrank
// it without a flask (2012-08-19); ours is kinder and is left so.
class spell_searing_gorge_fill_furnace_flask : public SpellScript
{
    PrepareSpellScript(spell_searing_gorge_fill_furnace_flask);

    bool Validate(SpellInfo const* /*spellInfo*/) override
    {
        return ValidateSpellInfo({ SPELL_SHRINK });
    }

    void HandleShrink(SpellEffIndex /*effIndex*/)
    {
        Unit* caster = GetCaster();
        Creature* elemental = GetHitCreature();
        if (!caster || !elemental || !elemental->IsAlive())
            return;

        if (!elemental->HasAura(SPELL_SHRINK))
            caster->AddAura(SPELL_SHRINK, elemental);
        TC_LOG_DEBUG("scripts", "Searing Gorge: %s filled a Furnace Flask from %s (entry %u, guid %u)",
            caster->GetName().c_str(), elemental->GetName().c_str(), elemental->GetEntry(), elemental->GetDBTableGUIDLow());
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_searing_gorge_fill_furnace_flask::HandleShrink, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

void AddSC_searing_gorge_thorium()
{
    new spell_script<spell_searing_gorge_fill_furnace_flask>("spell_searing_gorge_fill_furnace_flask");
}
