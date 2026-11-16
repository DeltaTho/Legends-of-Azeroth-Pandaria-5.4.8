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
#include "SpellScript.h"
#include "SpellAuraEffects.h"

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

enum SearingGorgeLunk
{
    NPC_LUNK_SPIDER_RIDER           = 47281,
    NPC_LUNK_CRANKY_DWARFS          = 47333,
    NPC_LUNK_RENDANS_WEAKNESS       = 47430,

    SPELL_SUMMON_LUNK_SPIDER_RIDER  = 88166,
    SPELL_SUMMON_LUNK_CRANKY_DWARFS = 88292,
    SPELL_SUMMON_LUNK_RENDAN        = 88450,
    SPELL_LUNKS_INFECTIOUS_DANCE    = 88451,
    SPELL_SUMMON_DANCER_1           = 88457,
    SPELL_SUMMON_DANCER_2           = 88459,
    SPELL_SUMMON_DANCER_3           = 88460,

    QUEST_LUNK_SPIDER_RIDER         = 27959,
    QUEST_LUNK_CRANKY_DWARFS        = 27983,
    QUEST_LUNK_RENDANS_WEAKNESS     = 28034,

    SAY_LUNK_NO_KILL                = 2,    // BT 47698-47703, TextRange 5 (owner only)

    ACTION_LUNK_SCOLD               = 1,
    ACTION_LUNK_DISMISS             = 2,

    EVENT_LUNK_CHECK                = 1,

    LUNK_SCOLD_COOLDOWN             = 20 * IN_MILLISECONDS,  // the summon auras' proc cooldown (SpellAuraOptions 20000)
};

struct LunkFollowerInfo
{
    uint32 Entry;
    uint32 Spell;
    uint32 Quest;
};

LunkFollowerInfo const LunkFollowers[] =
{
    { NPC_LUNK_SPIDER_RIDER,     SPELL_SUMMON_LUNK_SPIDER_RIDER,  QUEST_LUNK_SPIDER_RIDER     },
    { NPC_LUNK_CRANKY_DWARFS,    SPELL_SUMMON_LUNK_CRANKY_DWARFS, QUEST_LUNK_CRANKY_DWARFS    },
    { NPC_LUNK_RENDANS_WEAKNESS, SPELL_SUMMON_LUNK_RENDAN,        QUEST_LUNK_RENDANS_WEAKNESS },
};

static LunkFollowerInfo const* GetLunkInfoByEntry(uint32 entry)
{
    for (LunkFollowerInfo const& info : LunkFollowers)
        if (info.Entry == entry)
            return &info;
    return nullptr;
}

static LunkFollowerInfo const* GetLunkInfoBySpell(uint32 spellId)
{
    for (LunkFollowerInfo const& info : LunkFollowers)
        if (info.Spell == spellId)
            return &info;
    return nullptr;
}

// The player's own living Lunk of this entry. The followers are private, but a search from their owner finds them.
static Creature* FindLunkFollower(Player* player, uint32 entry, float range = 150.0f)
{
    std::list<Creature*> lunks;
    player->GetCreatureListWithEntryInGrid(lunks, entry, range);
    for (Creature* lunk : lunks)
        if (lunk->IsAlive() && !lunk->IsDestroyedObject() && lunk->GetOwnerGUID() == player->GetGUID())
            return lunk;
    return nullptr;
}

static void DismissLunkFollowers(Player* player, uint32 entry)
{
    std::list<Creature*> lunks;
    player->GetCreatureListWithEntryInGrid(lunks, entry, 250.0f);
    for (Creature* lunk : lunks)
        if (lunk->GetOwnerGUID() == player->GetGUID() && lunk->IsAIEnabled)
            lunk->AI()->DoAction(ACTION_LUNK_DISMISS);
}

// A kill while Lunk is out: one scold per kill however many Lunks follow (the first of the player's Lunks in table order speaks,
// his 20 s cooldown applying; the kill proc of each summon aura and the player's own kill hook all come here)
static void ScoldForKill(Player* player)
{
    for (LunkFollowerInfo const& info : LunkFollowers)
        if (player->HasAura(info.Spell))
            if (Creature* lunk = FindLunkFollower(player, info.Entry))
            {
                if (lunk->IsAIEnabled)
                    lunk->AI()->DoAction(ACTION_LUNK_SCOLD);
                return;
            }
}

// As the spells' own summon effect does it (Spell::EffectSummonType, ALLY category, no SummonProperties): private to the player,
// his faction, owned by him. Manual despawn instead of the ~49 days a -1 duration becomes: the follower goes with the aura.
static ObjectGuid SummonLunkFollower(Player* player, LunkFollowerInfo const& info)
{
    if (Creature* lunk = FindLunkFollower(player, info.Entry))
        return lunk->GetGUID();
    if (!player->IsAlive())
        return ObjectGuid::Empty;

    Position pos = player->GetNearPosition(3.0f, float(M_PI) * 0.75f);
    TempSummon* lunk = player->SummonCreature(info.Entry, pos, TEMPSUMMON_MANUAL_DESPAWN, 0ms, 0, player->GetGUID());
    if (!lunk)
        return ObjectGuid::Empty;

    lunk->SetOwnerGUID(player->GetGUID());
    lunk->SetFaction(player->GetFaction());
    lunk->SetUInt32Value(UNIT_FIELD_CREATED_BY_SPELL, info.Spell);
    return lunk->GetGUID();
}

// 47281, 47333, 47430 - Lunk, following the player on Spider Rider, Cranky Little Dwarfs and Rendan's Weakness
// What the player sees (sourced: Wowhead 27959 / 27983 / 28034 / 47269 comments and the wiki): Lunk follows the player while the
// quest is in his log; killing anything while he is out makes him scold ("You stop killing now! Lunk doesn't like!" and five more,
// broadcast texts 47698-47703); he is gone when the quest is handed in from the log or abandoned; a relog brings him back
// (2010-12-02 [+23]). On Rendan's Weakness he dances (screenshot 202159).
// Ours: he keeps 4 yd behind-left (the comments complain he stood so close he hid small characters), cannot be attacked and
// fights nothing (retail let him die, which stalled the quest), leaves when the player leaves Searing Gorge and comes back on
// return (a 2012 comment had him follow to Ironforge), is brought along when left more than 50 yd behind, and comes back within
// 5 s after a death, a resurrection or anything else that lost him (spell_sg_lunk_summon_aura). The kill scold is one line at
// most every 20 s (the auras' proc cooldown), to the owner only.
struct npc_sg_lunk_follower : public ScriptedAI
{
    npc_sg_lunk_follower(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        _info = GetLunkInfoByEntry(me->GetEntry());
        if (!_info || !summoner->IsPlayer())
            return;

        _ownerGUID = summoner->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        // Left behind out of sight his grid would stop and he would stand there while the aura blocks a new summon
        me->setActive(true, ActiveFlags::Script);

        if (me->GetEntry() == NPC_LUNK_RENDANS_WEAKNESS)
        {
            me->SetEmoteState(EMOTE_STATE_DANCE);
            DoCast(me, SPELL_LUNKS_INFECTIOUS_DANCE, true);
        }

        FollowOwner(summoner);
        _events.Reset();
        _events.ScheduleEvent(EVENT_LUNK_CHECK, 500ms);
    }

    void Reset() override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void JustDied(Unit* /*killer*/) override
    {
        _events.Reset();
        me->DespawnOrUnsummon(2000);
    }

    void DoAction(int32 action) override
    {
        switch (action)
        {
            case ACTION_LUNK_SCOLD:
                Scold(false);
                break;
            case ACTION_LUNK_DISMISS:
                Dismiss();
                break;
            default:
                break;
        }
    }

    void UpdateAI(uint32 diff) override
    {
        _scoldCooldown = _scoldCooldown > diff ? _scoldCooldown - diff : 0;
        _events.Update(diff);

        while (uint32 eventId = _events.ExecuteEvent())
        {
            if (eventId == EVENT_LUNK_CHECK)
            {
                _events.ScheduleEvent(EVENT_LUNK_CHECK, 500ms);
                Check();
            }
        }
    }

protected:
    Player* GetOwner() const
    {
        return ObjectAccessor::GetPlayer(*me, _ownerGUID);
    }

    void FollowOwner(Unit* owner)
    {
        me->SetWalk(false);
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveFollow(owner, 4.0f, 2.0f);
    }

    void Scold(bool always)
    {
        if (!always && _scoldCooldown)
            return;
        if (Player* owner = GetOwner())
        {
            Talk(SAY_LUNK_NO_KILL, owner);
            _scoldCooldown = LUNK_SCOLD_COOLDOWN;
        }
    }

    virtual void Dismiss()
    {
        _events.Reset();
        me->DespawnOrUnsummon();
    }

    // The owner holds the summon aura and is on this map: true. Gone or without the aura twice in a row: dismissed.
    virtual bool Check()
    {
        Player* owner = GetOwner();
        if (!owner || !owner->IsInWorld() || !_info || !owner->HasAura(_info->Spell))
        {
            if (++_ownerMissing >= 2)
                Dismiss();
            return false;
        }
        _ownerMissing = 0;
        return true;
    }

    // Left behind (the player rode on): brought along
    void CatchUp(Player* owner)
    {
        if (owner->IsInFlight() || me->IsWithinDistInMap(owner, 50.0f))
            return;

        Position pos = owner->GetNearPosition(3.0f, float(M_PI) * 0.75f);
        me->NearTeleportTo(pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), owner->GetOrientation());
        FollowOwner(owner);
    }

    LunkFollowerInfo const* _info = nullptr;
    ObjectGuid _ownerGUID;
    EventMap _events;
    uint32 _scoldCooldown = 0;
    uint8 _ownerMissing = 0;
};

// 88166, 88292, 88450 - Summon Lunk (effect 0), cast by spell_area while the quest is in the log in Searing Gorge
// The summon effect makes a follower that nothing takes away again (a -1 duration, not in the player's controlled list). It does
// nothing here: the aura (effect 1, spell_sg_lunk_summon_aura) summons him with a manual despawn and keeps track of him.
class spell_sg_lunk_summon : public SpellScript
{
    PrepareSpellScript(spell_sg_lunk_summon);

    void HandleSummon(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_sg_lunk_summon::HandleSummon, EFFECT_0, SPELL_EFFECT_SUMMON);
    }
};

// The same spells, effect 1 (the aura on the player; spell_custom_attribute DONT_SAVE, so a relog re-casts it and brings Lunk)
// - Applied: Lunk is summoned (not for a ghost) and this aura remembers him, so there is never a second one: after a flight or
//   a hearth inside the gorge the old Lunk is still this aura's, wherever he is on the map, and he catches up by himself.
// - Every 5 s: a living player in the gorge whose Lunk is gone (never summoned because he was a ghost when the aura came, or
//   lost in some other way) gets a new one.
// - Removed (log hand-in, abandon, leaving the zone): Lunk goes; for Rendan's Weakness the dancers go with him.
// - The kill proc (PROC_FLAG_KILL, 20 s cooldown) would trigger 88584, which no 5.4.8 data has: it is refused, and Lunk scolds
//   (also covers the kills of the player's pet; the player's own kills, critters and grey mobs too, come through
//   player_sg_lunk_kill).
class spell_sg_lunk_summon_aura : public AuraScript
{
    PrepareAuraScript(spell_sg_lunk_summon_aura);

    void CalcPeriodic(AuraEffect const* /*aurEff*/, bool& isPeriodic, int32& amplitude)
    {
        isPeriodic = true;
        amplitude = 5 * IN_MILLISECONDS;
    }

    void EnsureLunk()
    {
        Player* player = GetTarget()->ToPlayer();
        LunkFollowerInfo const* info = GetLunkInfoBySpell(GetId());
        if (!player || !info || !player->IsInWorld() || !player->IsAlive() || player->IsInFlight())
            return;

        if (Creature* lunk = ObjectAccessor::GetCreature(*player, _lunkGUID))
            if (lunk->IsAlive() && !lunk->IsDestroyedObject())
                return;

        _lunkGUID = SummonLunkFollower(player, *info);
    }

    void AfterApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        EnsureLunk();
    }

    void OnPeriodic(AuraEffect const* /*aurEff*/)
    {
        PreventDefaultAction();
        EnsureLunk();
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Player* player = GetTarget()->ToPlayer();
        LunkFollowerInfo const* info = GetLunkInfoBySpell(GetId());
        if (!player || !info)
            return;

        if (Creature* lunk = ObjectAccessor::GetCreature(*player, _lunkGUID))
            if (lunk->IsAIEnabled)
                lunk->AI()->DoAction(ACTION_LUNK_DISMISS);
        _lunkGUID.Clear();
        DismissLunkFollowers(player, info->Entry);
        if (info->Spell == SPELL_SUMMON_LUNK_RENDAN)
            for (uint32 spellId : { SPELL_SUMMON_DANCER_1, SPELL_SUMMON_DANCER_2, SPELL_SUMMON_DANCER_3 })
                player->RemoveAurasDueToSpell(spellId);
    }

    bool CheckProc(ProcEventInfo& /*eventInfo*/)
    {
        if (Player* player = GetTarget()->ToPlayer())
            ScoldForKill(player);
        return false;
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_sg_lunk_summon_aura::AfterApply, EFFECT_1, SPELL_AURA_PROC_TRIGGER_SPELL, AURA_EFFECT_HANDLE_REAL);
        DoEffectCalcPeriodic += AuraEffectCalcPeriodicFn(spell_sg_lunk_summon_aura::CalcPeriodic, EFFECT_1, SPELL_AURA_PROC_TRIGGER_SPELL);
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_sg_lunk_summon_aura::OnPeriodic, EFFECT_1, SPELL_AURA_PROC_TRIGGER_SPELL);
        AfterEffectRemove += AuraEffectRemoveFn(spell_sg_lunk_summon_aura::AfterRemove, EFFECT_1, SPELL_AURA_PROC_TRIGGER_SPELL, AURA_EFFECT_HANDLE_REAL);
        DoCheckProc += AuraCheckProcFn(spell_sg_lunk_summon_aura::CheckProc);
    }

    ObjectGuid _lunkGUID;
};

// 88152 - Summon Lunk (effect 0): the Spider Rider giver 47280, cast by a Glassweb Spider's killer (5856 SmartAI id 0)
// Its SummonProperties 2983 make him public and leave him standing where he appears: anyone could take the quest from him (and
// his accept row despawned him for his killer), a live one within 100 yd kept other killers from getting theirs, and spiders
// killed him. Sourced: he runs up and "follows you around for a minute or two" (2010-11-25 [+6], 2011-03-23 [+12]). Now he is
// the killer's own (private, as the steamsmith giver 47332 already is), follows him for the spell's 2 minutes, and is passive
// and unattackable (ours).
class spell_sg_summon_lunk_giver : public SpellScript
{
    PrepareSpellScript(spell_sg_summon_lunk_giver);

    void HandleSummon(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);

        Player* player = GetCaster() ? GetCaster()->ToPlayer() : nullptr;
        if (!player || !player->IsAlive())
            return;

        Position pos = player->GetNearPosition(4.0f, frand(0.0f, 2.0f * float(M_PI)));
        TempSummon* lunk = player->SummonCreature(uint32(GetSpellInfo()->Effects[effIndex].MiscValue), pos, TEMPSUMMON_TIMED_DESPAWN,
            Milliseconds(GetSpellInfo()->GetDuration()), 0, player->GetGUID());
        if (!lunk)
            return;

        lunk->SetReactState(REACT_PASSIVE);
        lunk->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        lunk->SetWalk(false);
        lunk->GetMotionMaster()->Clear();
        lunk->GetMotionMaster()->MoveFollow(player, 4.0f, 2.0f);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_sg_summon_lunk_giver::HandleSummon, EFFECT_0, SPELL_EFFECT_SUMMON);
    }
};

// A player with a Lunk out kills a creature: Lunk scolds (the kill proc misses critters and mobs that give no experience; the
// comments have him scold for critters too, 2012-06-15 [+4])
class player_sg_lunk_kill : public PlayerScript
{
public:
    player_sg_lunk_kill() : PlayerScript("player_sg_lunk_kill") { }

    void OnCreatureKill(Player* killer, Creature* killed) override
    {
        if (!killed || !killer->IsInWorld())
            return;

        ScoldForKill(killer);
    }
};

void AddSC_searing_gorge_lunk()
{
    new creature_script<npc_sg_lunk_follower>("npc_sg_lunk_follower");
    new spell_script<spell_sg_lunk_summon>("spell_sg_lunk_summon");
    new aura_script<spell_sg_lunk_summon_aura>("spell_sg_lunk_summon_aura");
    new player_sg_lunk_kill();
    new spell_script<spell_sg_summon_lunk_giver>("spell_sg_summon_lunk_giver");
    new creature_script<npc_sg_dig_boss_dinwhisker>("npc_sg_dig_boss_dinwhisker");
    new creature_script<npc_sg_dinwhisker_controller>("npc_sg_dinwhisker_controller");
}
