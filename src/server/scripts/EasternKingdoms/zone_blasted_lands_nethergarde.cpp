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
SDName: Blasted Lands, Nethergarde Mines and the Shattershore
SDComment: Quest support: 25681 Some People Just Need Killing (the Inconspicuous Box), 25708 Our Fallen Friends (the spirits
           of the Drowned Gilneans)
SDCategory: Blasted Lands
EndScriptData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "GameObjectAI.h"
#include "ObjectAccessor.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "SpellMgr.h"
#include "SpellScript.h"
#include "Spell.h"
#include "Vehicle.h"
#include "CombatAI.h"
#include "Map.h"
#include "MoveSplineInit.h"

/*######
## 25681 Some People Just Need Killing: the Inconspicuous Box
##
## What the player sees (sources: quest text and wiki notes; comments 2010-11-23 [+43] and its replies, 2010-11-28 [+7],
## 2010-12-06 [+36], 2011-02-10 [+3], 2011-02-23 [+5], 2011-08-02 [+3], 2012-01-10 [+0], 2012-07-27 [+19], 2014-01-15 [+7];
## spells 77052 Summon Box, 77044 / 77049 Box Vehicle Trigger Aura / Spell; vehicle 810; broadcast texts 41184-41189,
## 41195, 41250-41253, 41290-41295):
## Clicking an Inconspicuous Box crate (203192) shows a short cast bar (its lock opens kneeling), then a box appears around the
## player: the Inconspicuous Box 41174 (77052), steered by him from its control seat, with a vehicle bar in place of his action
## bars (seat 7858: control, cast, exit). His feet show under it; it has no shadow and drops when he stands still (seat and
## model animation, client side). The Nethergarde dwarves ignore the box; Foremen and Engineers within 10 yd that see it say
## one of their lines (Foremen 8, Engineers 6, at most once a minute each), Hondo his canary line; miners say nothing. He has to
## leave the box to fight Hondo, and cannot climb into another one while in combat ("you will need to kill what's aggro'd on
## you first"); the crate by Hondo's platform takes him back. Leaving the mine as a box, he has 5 seconds to come back, or the
## box vanishes.
## Ours: who can use a crate (the quest in the log, incomplete or complete for the way back; nobody else gets a box); the box
## also goes when the quest leaves the log; how "in the mine" is told (below); the once-a-minute and twice-a-minute cooldowns
## of the lines (SmartAI rows); "nothing happens" for a click without the quest.
## Every way out ends with the box gone: the exit button, death, logout, a teleport (Unit::_ExitVehicle despawns a vehicle
## Minion when its owner leaves it), 5 s outside the mine, the quest dropped.
######*/

namespace
{
enum InconspicuousBox
{
    QUEST_SOME_PEOPLE_JUST_NEED_KILLING = 25681,

    SPELL_SUMMON_BOX                    = 77052,
    SPELL_BOX_VEHICLE_TRIGGER_AURA      = 77044,

    NPC_INCONSPICUOUS_BOX               = 41174,
    NPC_NETHERGARDE_ENGINEER            = 5997,
    NPC_NETHERGARDE_FOREMAN             = 5998,
    NPC_REASSURING_NETHERGARDE_FOREMAN  = 41171,
    NPC_CHIEF_PROSPECTOR_HONDO          = 41173,

    SEAT_BOX_CONTROL                    = 2,    // seat 7858: the only seat of vehicle 810 with CAN_CONTROL

    AREA_NETHERGARDE_MINES              = 1457,
    AREA_STAGALBOG_CAVE                 = 1817, // the Swamp of Sorrows cave next to the mine's west end

    DATA_SAW_THE_BOX                    = 1,    // SmartAI DATA_SET id the speakers' rows listen for

    EVENT_BOX_NO_RIDER                  = 1,
    EVENT_BOX_CHECK                     = 2,
};

float const BoxLineRange = 10.0f;               // 77049's radius (index 13)
uint32 const BoxOutsideMineLimitSec = 5;

uint32 const BoxSpeakers[] =
{
    NPC_NETHERGARDE_ENGINEER, NPC_NETHERGARDE_FOREMAN, NPC_REASSURING_NETHERGARDE_FOREMAN, NPC_CHIEF_PROSPECTOR_HONDO
};

bool HoldsBoxQuest(Player const* player)
{
    QuestStatus const status = player->GetQuestStatus(QUEST_SOME_PEOPLE_JUST_NEED_KILLING);
    return status == QUEST_STATUS_INCOMPLETE || status == QUEST_STATUS_COMPLETE;
}

// The mine runs under two zones: the server reports the Nethergarde Mines (1457) for most of it, but the tunnels toward Hondo
// lie under Stonard and the Swamp of Sorrows (the crates 155854 / 155857 are tagged 8/75 and 8/8, and the map tiles give 75 or 8
// there; retail dropped the box at that zone line from 5.1 on, a bug not reproduced here). So "in the mine" is: the server says
// 1457, or the box is under the terrain inside the mine's outline (every mine spawn is 8 to 100+ yd under it, map tiles), and
// not in Stagalbog Cave next door. Outside the entrances the box stands on the terrain.
// The area is read from the map at the box's position (the cached one of a unit driven by its client may lag)
uint32 BoxAreaId(Unit const* box)
{
    return box->GetMap()->GetAreaId(box->GetPhaseMask(), box->GetPositionX(), box->GetPositionY(), box->GetPositionZ());
}

bool BoxIsInMine(Unit const* box, uint32 areaId)
{
    if (areaId == AREA_NETHERGARDE_MINES)
        return true;

    if (areaId == AREA_STAGALBOG_CAVE)
        return false;

    float const x = box->GetPositionX();
    float const y = box->GetPositionY();
    if (x < -10870.0f || x > -10440.0f || y < -3700.0f || y > -3030.0f)
        return false;

    float const terrain = box->GetMap()->GetGridHeight(x, y);
    return terrain > INVALID_HEIGHT && terrain > box->GetPositionZ() + 3.0f;
}
}

// 203192 Inconspicuous Box (the crate). Its goober spell 77068 is not in the 5.4.8 data; the click (after the lock's cast bar)
// summons the box on the player instead. The crate is never activated, so it stays for the next player.
struct go_bl_inconspicuous_box : public GameObjectAI
{
    go_bl_inconspicuous_box(GameObject* go) : GameObjectAI(go) { }

    bool OnGossipHello(Player* player, bool isUse) override
    {
        if (!isUse)
            return false;

        if (!HoldsBoxQuest(player) || player->GetVehicle() || !player->IsAlive())
            return true;

        if (player->IsInCombat())
        {
            if (SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(SPELL_SUMMON_BOX))
                Spell::SendCastResult(player, spellInfo, 0, SPELL_FAILED_AFFECTING_COMBAT);
            return true;
        }

        // A vehicle summon: the player is put into the box at once (SpellEffects SUMMON_CATEGORY_VEHICLE), the box takes his
        // faction and is his Minion
        player->CastSpell(player, SPELL_SUMMON_BOX, true);
        return true;
    }
};

// 41174 Inconspicuous Box. The summon seats the player in the first free seat (index 0, which cannot steer); he is moved to the
// control seat. While he rides, 77044 pulses 77049 every 250 ms (the speakers' lines, spell_bl_box_vehicle_trigger).
struct npc_bl_inconspicuous_box : public VehicleAI
{
    npc_bl_inconspicuous_box(Creature* creature) : VehicleAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner ? summoner->ToPlayer() : nullptr;
        if (!player)
        {
            me->DespawnOrUnsummon();
            return;
        }

        _playerGUID = player->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        _events.ScheduleEvent(EVENT_BOX_NO_RIDER, 2s);
    }

    void PassengerBoarded(Unit* passenger, int8 seatId, bool apply) override
    {
        if (_changingSeat || passenger->GetGUID() != _playerGUID)
            return;

        Player* player = passenger->ToPlayer();
        if (!player)
            return;

        if (apply)
        {
            if (seatId != SEAT_BOX_CONTROL)
            {
                _changingSeat = true;
                player->ChangeSeat(SEAT_BOX_CONTROL);
                _changingSeat = false;
            }

            if (_seated)
                return;

            _seated = true;
            _outsideSec = 0;
            me->CastSpell(me, SPELL_BOX_VEHICLE_TRIGGER_AURA, true);
            _events.CancelEvent(EVENT_BOX_NO_RIDER);
            _events.ScheduleEvent(EVENT_BOX_CHECK, 1s);
            return;
        }

        if (!_seated)
            return;

        // He left the box (button, death, logout, teleport, or put out below): it goes with him (as Unit::_ExitVehicle does
        // for a Minion its owner leaves)
        _seated = false;
        _events.Reset();
        me->RemoveAurasDueToSpell(SPELL_BOX_VEHICLE_TRIGGER_AURA);
        me->DespawnOrUnsummon(1);
    }

    void UpdateAI(uint32 diff) override
    {
        VehicleAI::UpdateAI(diff);

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_BOX_NO_RIDER:
                    if (!_seated)
                        me->DespawnOrUnsummon();
                    return;
                case EVENT_BOX_CHECK:
                    if (!Check())
                        return;
                    _events.ScheduleEvent(EVENT_BOX_CHECK, 1s);
                    break;
                default:
                    break;
            }
        }
    }

private:
    // Once a second while he rides: the quest gone from his log, or 5 s out of the mine, puts him out (and the box goes)
    bool Check()
    {
        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player || player->GetVehicleBase() != me)
        {
            me->DespawnOrUnsummon();
            return false;
        }

        if (!HoldsBoxQuest(player))
        {
            player->ExitVehicle();
            return false;
        }

        uint32 const areaId = BoxAreaId(me);
        bool const inMine = BoxIsInMine(me, areaId);
        if (areaId != _lastAreaId)
        {
            _lastAreaId = areaId;
            TC_LOG_DEBUG("scripts", "Inconspicuous Box (player %s) now in area %u at %.1f %.1f %.1f, in the mine: %u",
                player->GetName().c_str(), areaId, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ(), uint32(inMine));
        }

        if (inMine)
        {
            _outsideSec = 0;
            return true;
        }

        if (++_outsideSec >= BoxOutsideMineLimitSec)
        {
            player->ExitVehicle();
            return false;
        }
        return true;
    }

    EventMap _events;
    ObjectGuid _playerGUID;
    uint32 _outsideSec = 0;
    uint32 _lastAreaId = 0;
    bool _seated = false;
    bool _changingSeat = false;
};

// 77049 Box Vehicle Trigger Spell (pulsed by the box's 77044). Effect 1 (a dummy on enemies in 10 yd) is the "who sees the box"
// test, but a box that carries IMMUNE_TO_NPC finds no NPC target (Unit::IsValidAttackTarget), and a hit would draw them into
// combat with it (Spell::DoSpellHitOnUnit -> CombatStart): its target list is emptied and effect 0 tells each Foreman, Engineer
// and Hondo within 10 yd, alive, out of combat and in sight of the box, that he saw it. Their SmartAI DATA_SET rows say the line
// (with the cooldowns there); miners have none ("Miners don't respond", wiki).
class spell_bl_box_vehicle_trigger : public SpellScript
{
    PrepareSpellScript(spell_bl_box_vehicle_trigger);

    void ClearTargets(std::list<WorldObject*>& targets)
    {
        targets.clear();
    }

    void HandleScript(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);

        Unit* box = GetCaster();
        if (!box || box->GetEntry() != NPC_INCONSPICUOUS_BOX || !box->GetVehicleKit())
            return;

        Unit* rider = box->GetVehicleKit()->GetPassenger(SEAT_BOX_CONTROL);
        if (!rider || rider->GetTypeId() != TYPEID_PLAYER)
            return;

        for (uint32 entry : BoxSpeakers)
        {
            std::list<Creature*> speakers;
            box->GetCreatureListWithEntryInGrid(speakers, entry, BoxLineRange);
            for (Creature* speaker : speakers)
                if (speaker->IsAlive() && !speaker->IsInCombat() && speaker->IsAIEnabled && speaker->IsWithinLOSInMap(box))
                    speaker->AI()->SetData(DATA_SAW_THE_BOX, 1);
        }
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_bl_box_vehicle_trigger::ClearTargets, EFFECT_1, TARGET_UNIT_DEST_AREA_ENEMY);
        OnEffectHitTarget += SpellEffectFn(spell_bl_box_vehicle_trigger::HandleScript, EFFECT_0, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

/*######
## 25708 Our Fallen Friends: the spirits of the Drowned Gilneans
##
## What the player sees (sources: one comment, 2010-11-24 by one user, posted alike on 42249 [+19], 42244 [+8], 42248 [+5] and
## 42252 [+5]; 2014-06-21 [+4]; the wiki notes; spells 78849 / 78847 / 78848; the spirits' addon auras 33900 Shroud of Death and 78853 Drowned Gilnean
## Spirit Flight): each Drowned Gilnean Merchant, Sailor or Settler killed (its SmartAI death row casts 78849) releases its spirit
## in human form, a man from a man and a woman from a woman, in a pillar of light; it waves at the one who killed it and rises
## into the sky, then is gone. Credit is the kill's own (KillCredit1 42252 on the three).
## Ours: the wave (the 2010 comment and the wiki note) rather than the bow (the 2014 comment); waving at the player who tagged the corpse, else the nearest
## player; the rise of 20 yd starting after 1.5 s at 4 yd/s, gone after 8 s.
######*/

namespace
{
enum DrownedGilneans
{
    SPELL_SUMMON_DROWNED_GILNEAN_SPIRIT_MALE    = 78847,
    SPELL_SUMMON_DROWNED_GILNEAN_SPIRIT_FEMALE  = 78848,

    EVENT_SPIRIT_RISE                           = 1,
    EVENT_SPIRIT_GONE                           = 2,
};

float const SpiritRiseHeight = 20.0f;
float const SpiritRiseSpeed = 4.0f;
}

// 78849 Summon Drowned Gilnean Spirit (Master): two dummies that carry the male (78847, effect 0) and the female (78848, effect 1)
// summon; the corpse's model decides (creature_model_info.gender). Its effects have no target type, so the hooks run in the hit
// phase with or without the corpse as target: the guard makes it one spirit per death.
class spell_bl_summon_drowned_gilnean_spirit : public SpellScript
{
    PrepareSpellScript(spell_bl_summon_drowned_gilnean_spirit);

    void HandleDummy(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
        if (_summoned)
            return;

        Unit* caster = GetCaster();
        if (!caster)
            return;

        _summoned = true;
        uint8 gender = GENDER_MALE;
        if (CreatureModelInfo const* modelInfo = sObjectMgr->GetCreatureModelInfo(caster->GetDisplayId()))
            gender = modelInfo->gender;

        caster->CastSpell(caster, gender == GENDER_FEMALE ? SPELL_SUMMON_DROWNED_GILNEAN_SPIRIT_FEMALE : SPELL_SUMMON_DROWNED_GILNEAN_SPIRIT_MALE, true);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_bl_summon_drowned_gilnean_spirit::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        OnEffectHit += SpellEffectFn(spell_bl_summon_drowned_gilnean_spirit::HandleDummy, EFFECT_1, SPELL_EFFECT_DUMMY);
        OnEffectHitTarget += SpellEffectFn(spell_bl_summon_drowned_gilnean_spirit::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        OnEffectHitTarget += SpellEffectFn(spell_bl_summon_drowned_gilnean_spirit::HandleDummy, EFFECT_1, SPELL_EFFECT_DUMMY);
    }

    bool _summoned = false;
};

// 42252 / 42253 Drowned Gilnean Spirit: a visual, never in a fight (template immune to both and not selectable). The summon is
// infinite (duration index 21) and owned by a corpse, so the spirit takes itself away.
struct npc_bl_drowned_gilnean_spirit : public ScriptedAI
{
    npc_bl_drowned_gilnean_spirit(Creature* creature) : ScriptedAI(creature)
    {
        me->SetReactState(REACT_PASSIVE);
    }

    void IsSummonedBy(Unit* summoner) override
    {
        Unit* lookAt = nullptr;
        if (Creature* corpse = summoner ? summoner->ToCreature() : nullptr)
            lookAt = corpse->GetLootRecipient();
        if (!lookAt || !lookAt->IsInMap(me) || !me->IsWithinDist(lookAt, 40.0f))
            lookAt = me->SelectNearestPlayer(40.0f);

        if (lookAt)
            me->SetFacingToObject(lookAt);
        me->HandleEmoteCommand(EMOTE_ONESHOT_WAVE);

        _events.ScheduleEvent(EVENT_SPIRIT_RISE, 1500ms);
        _events.ScheduleEvent(EVENT_SPIRIT_GONE, 8s);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_SPIRIT_RISE:
                {
                    me->SetDisableGravity(true);
                    Movement::MoveSplineInit init(me);
                    init.MoveTo(me->GetPositionX(), me->GetPositionY(), me->GetPositionZ() + SpiritRiseHeight, false);
                    init.SetFly();
                    init.SetVelocity(SpiritRiseSpeed);
                    init.Launch();
                    break;
                }
                case EVENT_SPIRIT_GONE:
                    me->DespawnOrUnsummon();
                    return;
                default:
                    break;
            }
        }
    }

private:
    EventMap _events;
};

void AddSC_blasted_lands_nethergarde()
{
    RegisterGameObjectAI(go_bl_inconspicuous_box);
    new creature_script<npc_bl_inconspicuous_box>("npc_bl_inconspicuous_box");
    new spell_script<spell_bl_box_vehicle_trigger>("spell_bl_box_vehicle_trigger");
    new spell_script<spell_bl_summon_drowned_gilnean_spirit>("spell_bl_summon_drowned_gilnean_spirit");
    new creature_script<npc_bl_drowned_gilnean_spirit>("npc_bl_drowned_gilnean_spirit");
}
