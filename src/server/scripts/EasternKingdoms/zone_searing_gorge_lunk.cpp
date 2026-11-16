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
#include "ObjectMgr.h"
#include "LootMgr.h"
#include "Mail.h"
#include "Item.h"
#include "Pet.h"
#include "DatabaseEnv.h"

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
    EVENT_LUNK_TARGET_TIMEOUT,
    EVENT_LUNK_RIDE_END,
    EVENT_LUNK_SIT_CREDIT,
    EVENT_LUNK_SIT_END,
    EVENT_LUNK_RELEASE_TARGET,
    EVENT_LUNK_RESUME,

    LUNK_SCOLD_COOLDOWN             = 20 * IN_MILLISECONDS,  // the summon auras' proc cooldown (SpellAuraOptions 20000)

    // Spider Rider / Cranky Little Dwarfs
    NPC_GLASSWEB_SPIDER             = 5856,
    NPC_DARK_IRON_STEAMSMITH        = 5840,

    SPELL_TUMMY_VENOM               = 88154,    // 30 s dummy aura (the green blob) + KILL_CREDIT 47279 to his summoner
    SPELL_HOLDING_LOOT              = 88320,    // 30 s dummy aura + KILL_CREDIT 47381 to his summoner
    SPELL_CRANKY_DWARFS_SUFFOCATING = 88305,    // hidden dummy aura on the dwarf ("server-side script")
    SPELL_SLEEP_VISUAL_FLAVOR       = 34664,

    QUEST_A_PROPER_ANTIVENOM        = 27958,
    QUEST_RECON_ESSENTIALS          = 27977,
    ITEM_GLASSWEB_VENOM             = 62809,
    GLASSWEB_VENOM_NEEDED           = 14,       // quest_objective of 27958
    ITEM_SMITHING_TUYERE            = 18959,

    SAY_LUNK_RIDE                   = 0,        // 47281: BT 47405-47409 (yells)
    SAY_LUNK_VENOM                  = 1,        // 47281: BT 47411-47416
    SAY_LUNK_LAUGH                  = 3,        // 47281: BT 47410 "Ha ha ha!"
    SAY_LUNK_STOLE                  = 0,        // 47333: BT 47525-47530
    SAY_STEAMSMITH_SLEEP            = 0,        // 5840: BT 47498-47514

    ANIMKIT_SWIM_LOOP               = 1505,     // AnimKit 1505: one full-body segment, anim 42 Swim, looping
    POINT_LUNK_TARGET               = 1,
    POINT_LUNK_RIDE                 = 2,
};

float const LUNK_RIDE_LIFT = 1.0f;     // yd above the spider's feet during the ride (ours; screenshot 202121: his body over it)

// A spider or steamsmith Lunk has taken: it stops fighting everyone (its evade drops every fight and every aura others put on it,
// so no DoT kills it), stands still, cannot be attacked and attacks nobody. Its own event lets it go after `releaseAfter` should
// Lunk not (he was dismissed, his map unloaded): the safety and, for the dwarf, the end of his sleep.
static void ReleaseLunkVictim(Creature* victim)
{
    if (!victim->IsInWorld() || !victim->IsAlive() || !victim->HasFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC))
        return;

    // Unit flags and these auras are not reset by a respawn (Creature::setDeathState(JUST_RESPAWNED)): restore them first
    victim->RemoveAurasDueToSpell(SPELL_SLEEP_VISUAL_FLAVOR);
    victim->RemoveAurasDueToSpell(SPELL_CRANKY_DWARFS_SUFFOCATING);
    victim->SetStandState(UNIT_STAND_STATE_STAND);
    victim->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
    victim->SetReactState(REACT_AGGRESSIVE);
    victim->ClearUnitState(UNIT_STATE_EVADE);
    victim->DespawnOrUnsummon(100);
}

static void NeutralizeLunkVictim(Creature* victim, uint32 releaseAfter)
{
    victim->SetHomePosition(victim->GetPositionX(), victim->GetPositionY(), victim->GetPositionZ(), victim->GetOrientation());
    if (victim->IsAIEnabled)
        victim->AI()->EnterEvadeMode(CreatureAI::EVADE_REASON_OTHER);
    victim->CombatStop(true);
    victim->SetReactState(REACT_PASSIVE);
    victim->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
    victim->RemoveAurasByType(SPELL_AURA_PERIODIC_DAMAGE);
    victim->RemoveAurasByType(SPELL_AURA_PERIODIC_DAMAGE_PERCENT);
    victim->RemoveAurasByType(SPELL_AURA_PERIODIC_LEECH);
    victim->GetMotionMaster()->Clear();
    victim->GetMotionMaster()->MoveIdle();
    victim->StopMoving();
    victim->m_Events.AddLambdaEventAtOffset([victim]() { ReleaseLunkVictim(victim); }, releaseAfter);
}

// Into the bags, or by mail when they are full (retail's Lunk froze with full bags, comments 2011-02-19 [+13], 2012-03-19 [+5]: ours)
static void GiveOrMailItem(Player* player, uint32 itemId, uint32 count, uint32 senderEntry)
{
    if (!count)
        return;

    ItemPosCountVec dest;
    if (player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, itemId, count) == EQUIP_ERR_OK)
    {
        if (Item* item = player->StoreNewItem(dest, itemId, true, Item::GenerateItemRandomPropertyId(itemId)))
            player->SendNewItem(item, count, true, false);
        return;
    }

    Item* item = Item::CreateItem(itemId, count, player);
    if (!item)
        return;

    CharacterDatabaseTransaction trans = CharacterDatabase.BeginTransaction();
    item->SaveToDB(trans);
    MailDraft("Lunk", "Lunk keep this for you. Your bags too full.").AddItem(item)
        .SendMailTo(trans, MailReceiver(player, player->GetGUID().GetCounter()), MailSender(MAIL_CREATURE, senderEntry));
    CharacterDatabase.CommitTransaction(trans);
    player->SendEquipError(EQUIP_ERR_INV_FULL, nullptr, nullptr, itemId);
}

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

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type != POINT_MOTION_TYPE)
            return;

        if (id == POINT_LUNK_TARGET && _state == LUNK_STATE_TO_TARGET)
            OnReachTarget();
        else if (id == POINT_LUNK_RIDE && _state == LUNK_STATE_RIDING)
            EndRide();
    }

    // Spider Rider venom (sourced: comments 2010-12-23 [+43], 2010-11-29 [+8]: after a ride Lunk has a green blob on his tummy,
    // click him with the gear cursor for 2 Glassweb Venom; players kept "exactly 14" from the rides before they took A Proper
    // Antivenom, 27958 2011-03-23 [+12], 27959 2010-11-29 reply): given whenever A Proper Antivenom is not yet rewarded. Ours:
    // clicking while mounted works too (retail lost the venom then, 2011-02-05), and never more than the 14 the quest needs.
    void OnSpellClick(Unit* clicker, bool& result) override
    {
        Player* player = clicker->ToPlayer();
        if (!player || player->GetGUID() != _ownerGUID || !me->HasAura(SPELL_TUMMY_VENOM) || !me->IsWithinDistInMap(player, 10.0f))
            return;

        me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);
        me->RemoveAurasDueToSpell(SPELL_TUMMY_VENOM);
        if (!WantsVenom(player))
            return;

        uint32 have = player->GetItemCount(ITEM_GLASSWEB_VENOM);
        uint32 count = have >= GLASSWEB_VENOM_NEEDED ? 0 : std::min<uint32>(2, GLASSWEB_VENOM_NEEDED - have);
        GiveOrMailItem(player, ITEM_GLASSWEB_VENOM, count, me->GetEntry());
        result = true;
    }

    void UpdateAI(uint32 diff) override
    {
        _scoldCooldown = _scoldCooldown > diff ? _scoldCooldown - diff : 0;
        _events.Update(diff);

        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_LUNK_CHECK:
                    _events.ScheduleEvent(EVENT_LUNK_CHECK, 500ms);
                    Check();
                    break;
                case EVENT_LUNK_TARGET_TIMEOUT:
                    // Could not get there (a ledge, a pillar): he gets there anyway
                    if (_state == LUNK_STATE_TO_TARGET)
                        if (Creature* target = GetTarget())
                        {
                            me->NearTeleportTo(target->GetPositionX(), target->GetPositionY(), target->GetPositionZ(), target->GetOrientation());
                            OnReachTarget();
                        }
                    break;
                case EVENT_LUNK_RIDE_END:
                    if (_state == LUNK_STATE_RIDING)
                        EndRide();
                    break;
                case EVENT_LUNK_SIT_CREDIT:
                    SitCredit();
                    break;
                case EVENT_LUNK_SIT_END:
                    me->SetStandState(UNIT_STAND_STATE_STAND);
                    _targetGUID.Clear();    // the dwarf sleeps on; his own event wakes him and sends him off
                    Resume();
                    break;
                case EVENT_LUNK_RELEASE_TARGET:
                    ReleaseTarget();
                    break;
                case EVENT_LUNK_RESUME:
                    Resume();
                    break;
                default:
                    break;
            }
        }
    }

protected:
    enum LunkState
    {
        LUNK_STATE_FOLLOW,
        LUNK_STATE_TO_TARGET,
        LUNK_STATE_RIDING,
        LUNK_STATE_AFTER_RIDE,
        LUNK_STATE_SITTING,
    };

    Player* GetOwner() const
    {
        return ObjectAccessor::GetPlayer(*me, _ownerGUID);
    }

    // Each quest's Lunk has his own spot, so the Spider Rider and Cranky Little Dwarfs Lunks (several Lunks did follow at once,
    // 2010-11-25 [+6]) and the dancing one do not stand in each other: behind-left, behind-right, straight behind (ours)
    float GetFollowAngle() const
    {
        switch (me->GetEntry())
        {
            case NPC_LUNK_CRANKY_DWARFS:    return 2.0f * float(M_PI) - 2.0f;
            case NPC_LUNK_RENDANS_WEAKNESS: return float(M_PI);
            default:                        return 2.0f;
        }
    }

    static bool WantsVenom(Player* player)
    {
        return !player->GetQuestRewardStatus(QUEST_A_PROPER_ANTIVENOM) && player->GetItemCount(ITEM_GLASSWEB_VENOM) < GLASSWEB_VENOM_NEEDED;
    }

    // Spider Rider: he rides while the quest is in the log, also after the 7th ride ("rode the 8th spider but had no venom",
    // 27959 2011-04-01 [+4]); Cranky Little Dwarfs: until the 7th dwarf
    bool WantsTarget(Player* owner) const
    {
        QuestStatus status = owner->GetQuestStatus(_info->Quest);
        if (me->GetEntry() == NPC_LUNK_SPIDER_RIDER)
            return status == QUEST_STATUS_INCOMPLETE || status == QUEST_STATUS_COMPLETE;
        return me->GetEntry() == NPC_LUNK_CRANKY_DWARFS && status == QUEST_STATUS_INCOMPLETE;
    }

    Creature* GetTarget() const
    {
        return _targetGUID ? ObjectAccessor::GetCreature(*me, _targetGUID) : nullptr;
    }

    void FollowOwner(Unit* owner)
    {
        me->SetWalk(false);
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveFollow(owner, 4.0f, GetFollowAngle());
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

    void ReleaseTarget()
    {
        if (Creature* target = GetTarget())
            ReleaseLunkVictim(target);
        _targetGUID.Clear();
    }

    void Dismiss()
    {
        ReleaseTarget();
        _events.Reset();
        me->DespawnOrUnsummon();
    }

    // Off the spider: back on his feet on the ground
    void Land()
    {
        if (!me->IsGravityDisabled())
            return;

        me->SetDisableGravity(false);
        float x = me->GetPositionX(), y = me->GetPositionY(), z = me->GetPositionZ();
        me->UpdateGroundPositionZ(x, y, z);
        me->NearTeleportTo(x, y, z, me->GetOrientation());
    }

    void Resume()
    {
        Land();
        me->SetAIAnimKitId(0);
        me->SetMovementAnimKitId(0);
        me->SetStandState(UNIT_STAND_STATE_STAND);
        _state = LUNK_STATE_FOLLOW;
        if (Player* owner = GetOwner())
            FollowOwner(owner);
    }

    // Every 0.5 s. The owner holds the summon aura and is on this map, or Lunk goes (twice in a row: a teleport inside the map
    // passes). Then: the venom click window, catching up, and the spider / dwarf to take.
    void Check()
    {
        Player* owner = GetOwner();
        if (!owner || !owner->IsInWorld() || !_info || !owner->HasAura(_info->Spell))
        {
            if (++_ownerMissing >= 2)
                Dismiss();
            return;
        }
        _ownerMissing = 0;

        if (me->HasFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK) && !me->HasAura(SPELL_TUMMY_VENOM))
            me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);

        switch (_state)
        {
            case LUNK_STATE_FOLLOW:
                CatchUp(owner);
                if (WantsTarget(owner))
                    if (Creature* target = FindWeakenedTarget(owner))
                        Take(target, owner);
                break;
            case LUNK_STATE_TO_TARGET:
            {
                // Killed before he got on: no credit, and he is not pleased (sourced)
                Creature* target = GetTarget();
                if (!target || !target->IsAlive())
                {
                    _targetGUID.Clear();
                    _events.CancelEvent(EVENT_LUNK_TARGET_TIMEOUT);
                    Scold(true);
                    Resume();
                }
                break;
            }
            default:
                break;
        }
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

    // "Knock the spider down to half health" / weaken the dwarf (sourced). Only the owner's own fight (R-9): his melee target,
    // or one within 30 yd that is fighting him or his pet; alive, at half health or less, not already taken by another Lunk.
    Creature* FindWeakenedTarget(Player* owner) const
    {
        uint32 entry = me->GetEntry() == NPC_LUNK_SPIDER_RIDER ? NPC_GLASSWEB_SPIDER : NPC_DARK_IRON_STEAMSMITH;
        Pet* pet = owner->GetPet();

        auto fits = [&](Creature* c)
        {
            return c && c->GetEntry() == entry && c->IsAlive() && c->IsInWorld() && c->GetHealthPct() <= 50.0f
                && !c->HasFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC) && owner->IsWithinDistInMap(c, 30.0f);
        };

        if (Unit* victim = owner->GetVictim())
            if (fits(victim->ToCreature()))
                return victim->ToCreature();

        std::list<Creature*> candidates;
        owner->GetCreatureListWithEntryInGrid(candidates, entry, 30.0f);
        for (Creature* c : candidates)
            if (fits(c) && (c->IsInCombatWith(owner) || (pet && c->IsInCombatWith(pet))))
                return c;

        return nullptr;
    }

    void Take(Creature* target, Player* owner)
    {
        bool spider = target->GetEntry() == NPC_GLASSWEB_SPIDER;
        _targetGUID = target->GetGUID();
        _state = LUNK_STATE_TO_TARGET;

        // The spider is let go by Lunk 2 s after the ride; the dwarf sleeps about 30 s (ours). The offsets are the safety.
        NeutralizeLunkVictim(target, spider ? 15 * IN_MILLISECONDS : 32 * IN_MILLISECONDS);

        if (spider)
            Talk(SAY_LUNK_RIDE, owner);     // "Look out spider! Here come Lunk!" ...

        // "at break-neck speed" (2011-03-23 [+12], said of his arrival with the quest; his rush to the spider is ours)
        me->SetWalk(false);
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MovePoint(POINT_LUNK_TARGET, target->GetPositionX(), target->GetPositionY(), target->GetPositionZ());
        _events.ScheduleEvent(EVENT_LUNK_TARGET_TIMEOUT, 8s);
    }

    void OnReachTarget()
    {
        _events.CancelEvent(EVENT_LUNK_TARGET_TIMEOUT);
        Creature* target = GetTarget();
        if (!target || !target->IsAlive())
            return;    // Check() scolds and resumes

        if (target->GetEntry() == NPC_GLASSWEB_SPIDER)
            StartRide(target);
        else
            StartSit(target);
    }

    // Spider Rider (screenshot 202121, 2010-12-20: Lunk belly-down on top of the spider, arms spread; comments: "rides it",
    // "swimming"): Lunk lies on the spider in the swim pose while it walks about 9 yd (3-4 s), then gets off with the venom on his
    // tummy and the credit. The pose (AnimKit 1505, swim, on the AI and movement kits), the walk and the 1 yd lift (gravity off,
    // so he lies over the spider rather than on the ground) are ours: vehicle 584 has no seat to board.
    void StartRide(Creature* spider)
    {
        _state = LUNK_STATE_RIDING;
        me->SetFacingTo(spider->GetOrientation());
        me->SetAIAnimKitId(ANIMKIT_SWIM_LOOP);
        me->SetMovementAnimKitId(ANIMKIT_SWIM_LOOP);
        if (Player* owner = GetOwner())
            Talk(SAY_LUNK_LAUGH, owner);

        Position dest = spider->GetNearPosition(9.0f, frand(-0.7f, 0.7f));
        spider->SetWalk(true);
        spider->GetMotionMaster()->MovePoint(1, dest);
        me->SetDisableGravity(true);
        me->NearTeleportTo(spider->GetPositionX(), spider->GetPositionY(), spider->GetPositionZ() + LUNK_RIDE_LIFT, spider->GetOrientation());
        me->SetWalk(true);
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MovePoint(POINT_LUNK_RIDE, dest.GetPositionX(), dest.GetPositionY(), dest.GetPositionZ() + LUNK_RIDE_LIFT, false);
        _events.ScheduleEvent(EVENT_LUNK_RIDE_END, 5s);
    }

    void EndRide()
    {
        _state = LUNK_STATE_AFTER_RIDE;
        _events.CancelEvent(EVENT_LUNK_RIDE_END);
        me->StopMoving();
        me->SetAIAnimKitId(0);
        me->SetMovementAnimKitId(0);
        Land();
        if (Creature* spider = GetTarget())
        {
            spider->StopMoving();
            spider->GetMotionMaster()->MoveIdle();
        }

        // 88154: the 30 s blob and the credit to his summoner (DBC). After the 7th ride: a ride without venom (sourced, above).
        Player* owner = GetOwner();
        if (owner && owner->GetQuestStatus(QUEST_LUNK_SPIDER_RIDER) == QUEST_STATUS_INCOMPLETE)
        {
            DoCast(me, SPELL_TUMMY_VENOM, true);
            Talk(SAY_LUNK_VENOM, owner);
            if (WantsVenom(owner))
                me->SetFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);
        }

        // "the spider despawns 2 s later" (mop's old SmartAI timing) and respawns as usual
        _events.ScheduleEvent(EVENT_LUNK_RELEASE_TARGET, 2s);
        _events.ScheduleEvent(EVENT_LUNK_RESUME, 2500ms);
    }

    // Cranky Little Dwarfs (screenshots 202129 / 267266: Lunk sitting, a small dwarf lying under him saying "This is... worse...
    // than death..."; comments 2010-11-28 [+40], 2011-03-31 [+11]): Lunk sits on the dwarf, who falls asleep with one of his lines
    // and 88305 Suffocating (DBC name, the quest's own spell); Lunk takes the credit and hands over the dwarf's things.
    // Ours: the Zzz of 34664 for the look (88305 has no visual), the dwarf lying down, the timings, a 30 s sleep before he goes.
    void StartSit(Creature* dwarf)
    {
        _state = LUNK_STATE_SITTING;
        dwarf->SetStandState(UNIT_STAND_STATE_SLEEP);
        dwarf->CastSpell(dwarf, SPELL_CRANKY_DWARFS_SUFFOCATING, true);
        dwarf->CastSpell(dwarf, SPELL_SLEEP_VISUAL_FLAVOR, true);
        // To Lunk's owner only (TextRange 5): nobody else sees Lunk sitting on him
        if (dwarf->IsAIEnabled)
            if (Player* owner = GetOwner())
                dwarf->AI()->Talk(SAY_STEAMSMITH_SLEEP, owner);

        me->StopMoving();
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveIdle();
        me->SetFacingTo(dwarf->GetOrientation());
        me->SetStandState(UNIT_STAND_STATE_SIT);
        _events.ScheduleEvent(EVENT_LUNK_SIT_CREDIT, 2s);
        _events.ScheduleEvent(EVENT_LUNK_SIT_END, 8s);
    }

    // "Here, I stealed this from little dwarf." and the dwarf's things: his pickpocket loot (the items the comments name are
    // exactly pickpocketing_loot_template 5840) to the owner; Recon Essentials' Smithing Tuyere to the owner and, ours (R-9), to
    // every group member within 30 yd who is on Recon Essentials without one. Ours: at least one pickpocket item (re-rolled up to
    // ten times), since Lunk always says he hands something over.
    void SitCredit()
    {
        Player* owner = GetOwner();
        Creature* dwarf = GetTarget();
        DoCast(me, SPELL_HOLDING_LOOT, true);    // 30 s aura + KILL_CREDIT 47381 to his summoner (DBC)
        if (!owner)
            return;

        Talk(SAY_LUNK_STOLE, owner);

        if (uint32 lootId = sObjectMgr->GetCreatureTemplate(NPC_DARK_IRON_STEAMSMITH)->pickpocketLootId)
        {
            std::vector<std::pair<uint32, uint32>> items;
            for (uint8 tries = 0; tries < 10 && items.empty(); ++tries)
            {
                Loot loot;
                loot.FillLoot(nullptr, lootId, LootTemplates_Pickpocketing, owner, true, true);
                uint32 slots = loot.GetMaxSlotInLootFor(owner);
                for (uint32 i = 0; i < slots; ++i)
                    if (LootItem* item = loot.LootItemInSlot(i, owner))
                        items.emplace_back(item->itemid, item->count);
            }
            for (auto const& item : items)
                GiveOrMailItem(owner, item.first, item.second, me->GetEntry());
        }

        WorldObject const* spot = dwarf ? static_cast<WorldObject const*>(dwarf) : me;
        auto giveTuyere = [&](Player* player)
        {
            if (player && player->IsInWorld() && player->IsAlive() && player->IsInMap(spot) && player->IsWithinDistInMap(spot, 30.0f)
                && player->GetQuestStatus(QUEST_RECON_ESSENTIALS) == QUEST_STATUS_INCOMPLETE && !player->HasItemCount(ITEM_SMITHING_TUYERE, 1, true))
                GiveOrMailItem(player, ITEM_SMITHING_TUYERE, 1, me->GetEntry());
        };

        if (Group* group = owner->GetGroup())
        {
            for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
                giveTuyere(ref->GetSource());
        }
        else
            giveTuyere(owner);
    }

    LunkFollowerInfo const* _info = nullptr;
    ObjectGuid _ownerGUID;
    ObjectGuid _targetGUID;
    LunkState _state = LUNK_STATE_FOLLOW;
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

enum SearingGorgeDancers
{
    NPC_IRON_SUMMIT_DANCER_1        = 47435,
    NPC_IRON_SUMMIT_DANCER_2        = 47436,
    NPC_IRON_SUMMIT_DANCER_3        = 47437,

    EVENT_DANCER_CHECK              = 1,

    ANIMKIT_DANCE_LOOP              = 1535,     // AnimKit 1535: one full-body segment, anim 69 EmoteDance, looping
};

static uint32 GetDancerSpell(uint32 entry)
{
    switch (entry)
    {
        case NPC_IRON_SUMMIT_DANCER_1: return SPELL_SUMMON_DANCER_1;
        case NPC_IRON_SUMMIT_DANCER_2: return SPELL_SUMMON_DANCER_2;
        case NPC_IRON_SUMMIT_DANCER_3: return SPELL_SUMMON_DANCER_3;
        default:                       return 0;
    }
}

static uint32 GetDancerEntry(uint32 spellId)
{
    switch (spellId)
    {
        case SPELL_SUMMON_DANCER_1: return NPC_IRON_SUMMIT_DANCER_1;
        case SPELL_SUMMON_DANCER_2: return NPC_IRON_SUMMIT_DANCER_2;
        case SPELL_SUMMON_DANCER_3: return NPC_IRON_SUMMIT_DANCER_3;
        default:                    return 0;
    }
}

// 47435, 47436, 47437 - Iron Summit Guard, dancing behind the player on Rendan's Weakness (Summon Dancer 1-3, cast by the player
// at a guard's "Care to join our dance?")
// What the player sees (sourced: comments 2011-01-19 [+22], 2011-02-20 [+9] "every character you approach joins in", screenshot
// 202161 of a guard dancing): each guard he talks to joins a dancing line behind him; the third completes the quest; they go at
// the turn-in at Rendan.
// The summons are guardians (SummonProperties 830), which here neither follow nor keep out of fights (gate GL-U3). Ours: the line
// (dancer 1 follows the player, dancer 2 dancer 1, dancer 3 dancer 2, 2 yd apart), unattackable and passive, dancing by emote
// state 10 (they run when they move, dance when they stand), brought along when left 50 yd behind, gone with their aura
// (handed in, abandoned, leaving the zone, death: spell_sg_lunk_summon_aura removes the three with Lunk's).
struct npc_sg_iron_summit_dancer : public ScriptedAI
{
    npc_sg_iron_summit_dancer(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (!summoner->IsPlayer())
            return;

        _ownerGUID = summoner->GetGUID();
        Setup();
        _events.Reset();
        // Spell::SummonGuardian sets level, faction and the guardian's stats after this hook: set up again then
        _events.ScheduleEvent(EVENT_DANCER_CHECK, 500ms);
    }

    void Reset() override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            if (eventId != EVENT_DANCER_CHECK)
                continue;

            _events.ScheduleEvent(EVENT_DANCER_CHECK, 1s);
            Check();
        }
    }

private:
    void Setup()
    {
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->SetEmoteState(EMOTE_STATE_DANCE);
        me->setActive(true, ActiveFlags::Script);
    }

    Creature* GetDancer(Player* owner, uint32 entry) const
    {
        std::list<Creature*> dancers;
        owner->GetAllMinionsByEntry(dancers, entry);
        for (Creature* dancer : dancers)
            if (dancer->IsAlive() && !dancer->IsDestroyedObject())
                return dancer;
        return nullptr;
    }

    void Check()
    {
        Player* owner = ObjectAccessor::GetPlayer(*me, _ownerGUID);
        if (!owner || !owner->IsInWorld() || !owner->HasAura(GetDancerSpell(me->GetEntry())))
        {
            _events.Reset();
            me->DespawnOrUnsummon();
            return;
        }

        if (!_setupDone)
        {
            Setup();
            _setupDone = true;
        }

        if (!owner->IsInFlight() && !me->IsWithinDistInMap(owner, 50.0f))
        {
            Position pos = owner->GetNearPosition(3.0f, float(M_PI));
            me->NearTeleportTo(pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), owner->GetOrientation());
            _leaderGUID.Clear();
        }

        Unit* leader = owner;
        if (me->GetEntry() == NPC_IRON_SUMMIT_DANCER_2)
        {
            if (Creature* first = GetDancer(owner, NPC_IRON_SUMMIT_DANCER_1))
                leader = first;
        }
        else if (me->GetEntry() == NPC_IRON_SUMMIT_DANCER_3)
        {
            if (Creature* second = GetDancer(owner, NPC_IRON_SUMMIT_DANCER_2))
                leader = second;
            else if (Creature* first = GetDancer(owner, NPC_IRON_SUMMIT_DANCER_1))
                leader = first;
        }

        if (leader->GetGUID() != _leaderGUID || me->GetMotionMaster()->GetCurrentMovementGeneratorType() != FOLLOW_MOTION_TYPE)
        {
            _leaderGUID = leader->GetGUID();
            me->SetWalk(false);
            me->GetMotionMaster()->Clear();
            me->GetMotionMaster()->MoveFollow(leader, 2.0f, float(M_PI));
        }
    }

    ObjectGuid _ownerGUID;
    ObjectGuid _leaderGUID;
    EventMap _events;
    bool _setupDone = false;
};

// 88457, 88459, 88460 - Summon Dancer 1-3 (effect 1, the dummy aura on the player; spell_custom_attribute DONT_SAVE: a relog
// starts the line again, the guardians do not outlive a logout). Removed, its dancer goes.
class spell_sg_summon_dancer : public AuraScript
{
    PrepareAuraScript(spell_sg_summon_dancer);

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (uint32 entry = GetDancerEntry(GetId()))
            GetTarget()->RemoveAllMinionsByEntry(entry);
    }

    void Register() override
    {
        AfterEffectRemove += AuraEffectRemoveFn(spell_sg_summon_dancer::AfterRemove, EFFECT_1, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

// 88451 - Lunk's Infectious Dance, cast by the dancing Lunk 47430 on himself (APPLY_AREA_AURA_FRIEND, dummy, 30 yd)
// Sourced: the player danced too while Lunk was with him, walking, fighting, mounted and flying, and stopped once far from Lunk
// (27959/28034 comments 2011-02-20 [+9], 2011-02-27 [+15] "the upper body turned around, but not the legs", 2011-08-23 [+5]
// "flew to the Badlands and I stopped, seems you need Lunk", 2011-11-03 [+5], 2013-03-12, 2013-12-21 [+3]); Wowhead: "Only
// Target If Same Creator". Here the aura reaches only Lunk's owner and the owner's dancers (the area aura would otherwise land on
// every friendly unit within 30 yd, strangers who cannot see Lunk included). On the owner it plays a dance: AnimKit 1535 (one
// full-body EmoteDance segment, looping) as his AI anim kit, ours, since the aura's own client visual cannot be read here; it
// ends when the aura does (Lunk gone, or the owner more than 30 yd from him).
class spell_sg_lunks_infectious_dance : public AuraScript
{
    PrepareAuraScript(spell_sg_lunks_infectious_dance);

    bool CheckAreaTarget(Unit* target)
    {
        Unit* caster = GetCaster();
        if (!caster || target == caster)
            return true;

        ObjectGuid owner = caster->GetOwnerGUID();
        if (!owner)
            return false;
        if (target->GetGUID() == owner)
            return true;

        switch (target->GetEntry())
        {
            case NPC_IRON_SUMMIT_DANCER_1:
            case NPC_IRON_SUMMIT_DANCER_2:
            case NPC_IRON_SUMMIT_DANCER_3:
                return target->GetOwnerGUID() == owner;
            default:
                return false;
        }
    }

    void AfterApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (Player* player = GetTarget()->ToPlayer())
            player->SetAIAnimKitId(ANIMKIT_DANCE_LOOP);
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (Player* player = GetTarget()->ToPlayer())
            if (player->GetAIAnimKitId() == ANIMKIT_DANCE_LOOP)
                player->SetAIAnimKitId(0);
    }

    void Register() override
    {
        DoCheckAreaTarget += AuraCheckAreaTargetFn(spell_sg_lunks_infectious_dance::CheckAreaTarget);
        AfterEffectApply += AuraEffectApplyFn(spell_sg_lunks_infectious_dance::AfterApply, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
        AfterEffectRemove += AuraEffectRemoveFn(spell_sg_lunks_infectious_dance::AfterRemove, EFFECT_0, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

void AddSC_searing_gorge_lunk()
{
    new aura_script<spell_sg_lunks_infectious_dance>("spell_sg_lunks_infectious_dance");
    new creature_script<npc_sg_iron_summit_dancer>("npc_sg_iron_summit_dancer");
    new aura_script<spell_sg_summon_dancer>("spell_sg_summon_dancer");
    new creature_script<npc_sg_lunk_follower>("npc_sg_lunk_follower");
    new spell_script<spell_sg_lunk_summon>("spell_sg_lunk_summon");
    new aura_script<spell_sg_lunk_summon_aura>("spell_sg_lunk_summon_aura");
    new player_sg_lunk_kill();
    new spell_script<spell_sg_summon_lunk_giver>("spell_sg_summon_lunk_giver");
    new creature_script<npc_sg_dig_boss_dinwhisker>("npc_sg_dig_boss_dinwhisker");
    new creature_script<npc_sg_dinwhisker_controller>("npc_sg_dinwhisker_controller");
}
