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
 * Skull Rock (25262)    the Burning Blade cultists outside the cave survive the 5.4 Kor'kron, so players still get their kills
 *
 * The rest of Durotar's scripts are in zone_durotar.cpp.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
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

} // namespace

void AddSC_durotar_blockade()
{
    new creature_script<npc_durotar_skull_rock_cultist>("npc_durotar_skull_rock_cultist");
}
