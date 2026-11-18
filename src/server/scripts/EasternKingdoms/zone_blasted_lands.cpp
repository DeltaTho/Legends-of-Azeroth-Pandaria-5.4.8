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
SDComment: Quest support: 25701 / 26171 (You Are Rakh'likh, Demon): the Deathly Usher's group teleport.
SDCategory: Blasted Lands
EndScriptData */

/* ContentData
spell_blasted_lands_teleport_to_razelikh_group
EndContentData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "Player.h"
#include "Group.h"
#include "SpellMgr.h"
#include "SpellScript.h"

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

void AddSC_blasted_lands()
{
    new spell_script<spell_blasted_lands_teleport_to_razelikh_group>("spell_blasted_lands_teleport_to_razelikh_group");
}
