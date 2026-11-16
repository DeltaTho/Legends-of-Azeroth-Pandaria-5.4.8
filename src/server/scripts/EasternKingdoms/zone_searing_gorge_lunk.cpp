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

// Searing Gorge: the Grimesilt Dig Site's Dig-Boss Dinwhisker (27964) and Lunk's adventures (Spider Rider 27959, Cranky Little
// Dwarfs 27983, Rendan's Weakness 28034). Research: research\searing-gorge\dossiers\grimesilt-lunk.md (E1, E2, SP2, SP3 and the
// 2010 screenshots of the orchestrator's addendum), plan.md section D.

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "Group.h"
#include "GameObject.h"
#include "Map.h"
#include "MotionMaster.h"
#include "TemporarySummon.h"

enum SearingGorgeDinwhisker
{
    NPC_DIG_BOSS_DINWHISKER         = 47271,
    NPC_DARK_IRON_FOOTMAN           = 47275,
    NPC_DARK_IRON_EXCAVATOR         = 47276,

    GO_DARK_EMBER                   = 206573,
    ITEM_DARK_EMBER                 = 62806,
    QUEST_DIG_BOSS_DINWHISKER       = 27964,

    SPELL_DINWHISKER_CHARGE         = 22120,
    SPELL_DINWHISKER_BATTLE_SHOUT   = 32064,

    SAY_DINWHISKER_ARRIVE           = 0,    // BT 47398 "What in hell's name is going on out here?"
    SAY_DINWHISKER_AGGRO            = 1,    // BT 50365 "So you're the ones causing all that ruckus!"

    PATH_DINWHISKER                 = 4727100,

    DATA_DIG_SITE_DWARF_DIED        = 1,
    DINWHISKER_KILLS_NEEDED         = 12,

    EVENT_DINWHISKER_BATTLE_SHOUT   = 1,
};

// Where Dinwhisker rides in: the west end of the dig (Wowhead pin 52.4,45.2, the westmost of his 36 pins; z from the terrain)
Position const DinwhiskerArrivalPos = { -6772.4f, -1492.1f, 180.7f, 5.0f };

// 47271 - Dig-Boss Dinwhisker (summoned by npc_sg_dinwhisker_controller)
// What the player sees (sourced, Wowhead comments of 27964 / 47271 and the wiki's quest notes): after about a dozen Excavators and
// Footmen are killed he rides in on a black ram from the west end yelling "What in hell's name is going on out here?" and circles
// the area counter-clockwise; when attacked he yells "So you're the ones causing all that ruckus!", charges and uses Battle Shout
// (his SmartAI before this script, TDB = mop). His loop (waypoint_data 4727100) runs through his Wowhead pins (ours: the order and
// spacing). Out of combat for 5 minutes he leaves (TEMPSUMMON_TIMED_OR_DEAD_DESPAWN, ours); his corpse stays the usual time.
struct npc_sg_dig_boss_dinwhisker : public ScriptedAI
{
    npc_sg_dig_boss_dinwhisker(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        Talk(SAY_DINWHISKER_ARRIVE);
        me->SetWalk(true);
        me->GetMotionMaster()->MovePath(PATH_DINWHISKER, true);
    }

    void Reset() override
    {
        _events.Reset();
    }

    void JustEngagedWith(Unit* who) override
    {
        ScriptedAI::JustEngagedWith(who);
        if (!_aggroYelled)
        {
            Talk(SAY_DINWHISKER_AGGRO);    // once (plan D-1); a second pull after an evade gets only the charge
            _aggroYelled = true;
        }
        if (who)
            DoCast(who, SPELL_DINWHISKER_CHARGE);
        _events.ScheduleEvent(EVENT_DINWHISKER_BATTLE_SHOUT, 5s, 7s);
    }

    void UpdateAI(uint32 diff) override
    {
        if (!UpdateVictim())
            return;

        _events.Update(diff);

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = _events.ExecuteEvent())
        {
            if (eventId == EVENT_DINWHISKER_BATTLE_SHOUT)
            {
                DoCast(me, SPELL_DINWHISKER_BATTLE_SHOUT);
                _events.ScheduleEvent(EVENT_DINWHISKER_BATTLE_SHOUT, 120s, 125s);
            }
        }

        DoMeleeAttackIfReady();
    }

private:
    EventMap _events;
    bool _aggroYelled = false;
};

// ELM General Purpose Bunny 23837, spawn 3132001 in the east Cauldron (ScriptName on the spawn: the entry's own SmartAI must not
// run here) - the dig site's foreman
// - Each Dark Iron Footman 47275 or Excavator 47276 that dies (anyone's kill: their SmartAI "On Death" sends data 1 here) counts;
//   at 12 (comments: "about a dozen", 6-20 reported; the value is ours) Dinwhisker is summoned at the west end, one at a time.
//   Kills while he is out do not count. A restart or a grid unload loses the count (ours, harmless).
// - The Dark Ember (SP2, sourced: "you need to click the item that spawns on the ground after the mob is dead. You can do that even
//   if someone else kills him first", 2013-04-11 [+11]): when he dies, every player within 40 yd of the body who has 27964 in
//   progress and no ember gets one Dark Ember object at the body, seen by him alone, for 2 minutes; a player who comes up within
//   those 2 minutes gets his too (checked every 2 s). One shared object would go to the first looter only (gate G3). The 40 yd,
//   the 2 minutes and the private copies are ours.
struct npc_sg_dinwhisker_controller : public ScriptedAI
{
    npc_sg_dinwhisker_controller(Creature* creature) : ScriptedAI(creature) { }

    // Kept updating and its grid loaded: the far south dwarves are in the next grid and a player 40 yd past Dinwhisker's body
    // can be ~130 yd from here, outside the 90 yd in which a cell is updated
    void Reset() override
    {
        me->setActive(true, ActiveFlags::Script);
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void SetData(uint32 type, uint32 /*value*/) override
    {
        if (type != DATA_DIG_SITE_DWARF_DIED)
            return;

        if (Creature* boss = ObjectAccessor::GetCreature(*me, _bossGUID))
            if (boss->IsAlive())
                return;

        if (++_kills < DINWHISKER_KILLS_NEEDED)
            return;

        _kills = 0;
        if (TempSummon* boss = me->SummonCreature(NPC_DIG_BOSS_DINWHISKER, DinwhiskerArrivalPos, TEMPSUMMON_TIMED_OR_DEAD_DESPAWN, 300s))
            _bossGUID = boss->GetGUID();
    }

    void SummonedCreatureDies(Creature* summon, Unit* /*killer*/) override
    {
        if (summon->GetEntry() != NPC_DIG_BOSS_DINWHISKER)
            return;

        _emberPos.Relocate(summon->GetPositionX(), summon->GetPositionY(), summon->GetPositionZ(), summon->GetOrientation());
        _emberTimer = 120 * IN_MILLISECONDS;
        _emberCheckTimer = 0;
        _emberGiven.clear();
    }

    void SummonedCreatureDespawn(Creature* summon) override
    {
        if (summon->GetGUID() == _bossGUID)
            _bossGUID.Clear();
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_emberTimer)
            return;

        _emberTimer = _emberTimer > diff ? _emberTimer - diff : 0;
        if (_emberCheckTimer > diff)
        {
            _emberCheckTimer -= diff;
            return;
        }
        _emberCheckTimer = 2 * IN_MILLISECONDS;

        for (auto const& ref : me->GetMap()->GetPlayers())
        {
            Player* player = ref.GetSource();
            if (!player || !player->IsInWorld() || !player->IsAlive() || player->GetExactDist(&_emberPos) > 40.0f)
                continue;
            if (player->GetQuestStatus(QUEST_DIG_BOSS_DINWHISKER) != QUEST_STATUS_INCOMPLETE || player->HasItemCount(ITEM_DARK_EMBER, 1, true))
                continue;
            if (!_emberGiven.insert(player->GetGUID()).second)
                continue;

            SpawnEmberFor(player);
        }
    }

private:
    void SpawnEmberFor(Player* player)
    {
        Map* map = me->GetMap();
        float x = _emberPos.GetPositionX() + frand(-1.5f, 1.5f);
        float y = _emberPos.GetPositionY() + frand(-1.5f, 1.5f);
        float z = map->GetHeight(player->GetPhaseMask(), x, y, _emberPos.GetPositionZ() + 3.0f, true, 10.0f);
        if (z <= INVALID_HEIGHT)
            z = _emberPos.GetPositionZ();
        float o = frand(0.0f, 2.0f * float(M_PI));

        G3D::Quat const rot(G3D::Matrix3::fromEulerAnglesZYX(o, 0.0f, 0.0f));
        GameObject* go = new GameObject();
        if (!go->Create(map->GenerateLowGuid<HighGuid::GameObject>(), GO_DARK_EMBER, map, player->GetPhaseMask(), x, y, z, o, rot, 100, GO_STATE_READY))
        {
            delete go;
            return;
        }

        for (uint32 phase : player->GetPhases())
            go->SetPhased(phase, false, true);
        // Not spawned by default and no owner: looted, it is gone for good; unlooted, it goes after 2 minutes
        go->SetRespawnTime(120);
        go->SetSpawnedByDefault(false);
        go->SetPrivateObjectOwner(player->GetGUID());
        map->AddToMap(go);
        TC_LOG_DEBUG("scripts", "Searing Gorge: Dark Ember for %s at %.1f %.1f %.1f", player->GetName().c_str(), x, y, z);
    }

    uint32 _kills = 0;
    ObjectGuid _bossGUID;
    Position _emberPos;
    uint32 _emberTimer = 0;
    uint32 _emberCheckTimer = 0;
    GuidSet _emberGiven;
};

void AddSC_searing_gorge_lunk()
{
    new creature_script<npc_sg_dig_boss_dinwhisker>("npc_sg_dig_boss_dinwhisker");
    new creature_script<npc_sg_dinwhisker_controller>("npc_sg_dinwhisker_controller");
}
