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

// Badlands: the companions of the Dragonflight arc. The Lost Vikings (Eric "The Swift" 46855, Baelog 46856, Olaf 46857) for the
// Alliance and the Bad Dogs (Amakkar 47021, Jurrix Whitemane 47024, Gargal 47022) for the Horde join the player with the first of
// their three training quests (27828 / 27834 / 27835, 27891 / 27892 / 27893) and stay through The Wrath of a Dragonflight, Their
// Hunt Continues and The Sorrow and the Fury until The Hidden Clutch (27832 / 27897) is handed in.
//
// What the player sees (sourced: wiki notes of 27828-27835, 27891-27893, 27829, 27832; Wowhead comments, research
// badlands\dossiers\vikings-dragonflight.md claims C1-C22):
// - Taking any one training quest brings all three at once; a hunter's or warlock's own pet is dismissed. Taken in combat, they
//   come when the fight is over.
// - A pet bar: Attack and Follow, and two buttons per training quest taken (all six once the three are taken), at buttons 3-4,
//   6-7 and 9-10. Each button use ticks that ability's objective; the two aimed at the player's target (Charge / Kidney Shot,
//   Valhalla Shot / Fiery Blast) need a hostile target selected, and none works while the player is mounted. Eric / Amakkar
//   charges and stuns or hands out potions; Baelog / Jurrix shoots the player's target or speeds the three's attacks; Olaf /
//   Gargal raises his shield or taunts the player's target onto himself, or the enemies around him without one.
// - All three follow, fight what the player fights and whatever hostile comes within 40 yd of them, and obey Passive / Defensive
//   (/petpassive, /petdefensive) and Follow / Attack given to the leader.
// - A viking helmet on the player while the dwarves are out (Viking Helmet 87391; the Horde twin Ex-KEF: Active Aura 87592).
// - The Bad Dogs ride Mechano-Hogs while the player is mounted; the dwarves walk.
// - They vanish in Dustbelch Grotto, the Scar of the Worldbreaker or anywhere outside the arc's areas and come back on return; a
//   companion that dies comes back, at full health, once the fight is over; after a relog, a death and resurrection or a Dismiss
//   they come back. A hunter cannot call his pet while Eric / Amakkar holds the pet slot (Spell::CheckCast); a pet summoned
//   after a Dismiss, or a warlock's demon, is replaced by the leader again within 5 s (Freeboosie2791).
// How (ours where no source says): the summon aura 87262 / 87589 on the player stands for "the trio is with you" (spell_area rows
// for the three quests in the arc's seven areas, until The Hidden Clutch is rewarded; the static trio at the camps is shown exactly
// while the player does not hold it, section B's rows). Its effect 0 summons all three; its aura ticks every 5 s and brings back a
// missing or dead companion while the player is alive and out of combat; its removal takes them away. Bots get no trio (a bot never
// presses a pet bar); a bot in the group beside the player gets each ability credit the player earns.

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "TemporarySummon.h"
#include "MotionMaster.h"
#include "Group.h"
#include "DBCStores.h"
#include "WorldSession.h"
#include "GridNotifiers.h"
#include "GridNotifiersImpl.h"
#include "CellImpl.h"

enum BadlandsCompanions
{
    NPC_ERIC                        = 46855,
    NPC_BAELOG                      = 46856,
    NPC_OLAF                        = 46857,
    NPC_AMAKKAR                     = 47021,
    NPC_GARGAL                      = 47022,
    NPC_JURRIX                      = 47024,

    SPELL_SUMMON_ERIC               = 87262,   // effect 0 summons Eric (SummonProperties 3039: pet category), effect 1 the aura
    SPELL_SUMMON_BAELOG             = 87263,   // SummonProperties 2341 (ally guardian, no slot)
    SPELL_SUMMON_OLAF               = 87264,
    SPELL_SUMMON_AMAKKAR            = 87589,
    SPELL_SUMMON_GARGAL             = 87590,
    SPELL_SUMMON_JURRIX             = 87591,

    SPELL_VIKING_HELMET             = 87391,
    SPELL_EXKEF_ACTIVE_AURA         = 87592,

    // The bar (cast by the leader)
    SPELL_ERIC_CHARGE               = 87278,
    SPELL_ERIC_POCKET_POTION        = 87279,
    SPELL_BAELOG_VALHALLA_SHOT      = 87281,
    SPELL_BAELOG_WARCRY             = 87280,
    SPELL_OLAF_SHIELD_WALL          = 87282,
    SPELL_OLAF_MIGHTY_SHOUT         = 87283,
    SPELL_AMAKKAR_KIDNEY_SHOT       = 87608,
    SPELL_AMAKKAR_POCKET_POTION     = 87609,
    SPELL_JURRIX_FIERY_BLAST        = 87612,
    SPELL_JURRIX_TIME_WARP          = 87611,
    SPELL_GARGAL_SHIELD_WALL        = 87613,
    SPELL_GARGAL_MIGHTY_SHOUT       = 87614,

    // What the bar's orders make the other two cast
    SPELL_VALHALLA_SHOT_HIT         = 87276,
    SPELL_WARCRY_BUFF               = 87277,
    SPELL_OLAF_SHIELD_WALL_BUFF     = 87275,
    SPELL_OLAF_MIGHTY_SHOUT_TAUNT   = 87274,
    SPELL_FIERY_BLAST_HIT           = 87593,
    SPELL_TIME_WARP_BUFF            = 87596,
    SPELL_GARGAL_SHIELD_WALL_BUFF   = 87607,
    SPELL_GARGAL_MIGHTY_SHOUT_TAUNT = 87606,

    SUMMON_PROPERTIES_LEADER        = 3039,
    SUMMON_PROPERTIES_HELPER        = 2341,

    DISPLAY_MECHANO_HOG             = 25871,   // Mechano-Hog 29929 (mount aura of 55531)

    EVENT_COMPANION_SETUP           = 1,
    EVENT_COMPANION_CHECK,

    ACTION_COMPANION_FOLLOW         = 1,
};

enum CompanionRole : uint8
{
    ROLE_LEADER = 0,    // Eric / Amakkar: the pet (bar, stance)
    ROLE_RANGED = 1,    // Baelog / Jurrix
    ROLE_TANK   = 2,    // Olaf / Gargal
    MAX_COMPANION_ROLES
};

float const CompanionAssistRange   = 40.0f;   // wiki 27829 / 27894: "within 40 yards of a hostile unit"
float const CompanionCatchUpRange  = 60.0f;   // ours (as the Eastern Plaguelands followers)
float const CompanionShotRange     = 100.0f;  // 87276 / 87593
float const CompanionBotCreditRange = 40.0f;  // plan rule 2 (R4)
uint32 const CompanionCheckPeriod  = 5000;    // ours

struct CompanionTrio
{
    uint32 SummonSpell;                         // the aura on the player and the leader's summon
    uint32 Entries[MAX_COMPANION_ROLES];
    uint32 CreatedBy[MAX_COMPANION_ROLES];      // the spell each one carries as UNIT_FIELD_CREATED_BY_SPELL
    uint32 Quests[MAX_COMPANION_ROLES];         // the training quest whose pair of buttons this companion brings
    uint32 BarSpells[MAX_COMPANION_ROLES][2];
    uint32 Credits[MAX_COMPANION_ROLES][2];     // quest_objective objectId of each button (Horde: Fiery Blast 46865, Time Warp 46864)
    uint32 ActiveAura;
    bool Hogs;                                  // ride Mechano-Hogs with a mounted player
};

CompanionTrio const CompanionTrios[2] =
{
    {
        SPELL_SUMMON_ERIC,
        { NPC_ERIC, NPC_BAELOG, NPC_OLAF },
        { SPELL_SUMMON_ERIC, SPELL_SUMMON_BAELOG, SPELL_SUMMON_OLAF },
        { 27828, 27834, 27835 },
        { { SPELL_ERIC_CHARGE, SPELL_ERIC_POCKET_POTION }, { SPELL_BAELOG_VALHALLA_SHOT, SPELL_BAELOG_WARCRY }, { SPELL_OLAF_SHIELD_WALL, SPELL_OLAF_MIGHTY_SHOUT } },
        { { 46862, 46863 }, { 46864, 46865 }, { 46866, 46867 } },
        SPELL_VIKING_HELMET,
        false,
    },
    {
        SPELL_SUMMON_AMAKKAR,
        { NPC_AMAKKAR, NPC_JURRIX, NPC_GARGAL },
        { SPELL_SUMMON_AMAKKAR, SPELL_SUMMON_JURRIX, SPELL_SUMMON_GARGAL },
        { 27891, 27892, 27893 },
        { { SPELL_AMAKKAR_KIDNEY_SHOT, SPELL_AMAKKAR_POCKET_POTION }, { SPELL_JURRIX_FIERY_BLAST, SPELL_JURRIX_TIME_WARP }, { SPELL_GARGAL_SHIELD_WALL, SPELL_GARGAL_MIGHTY_SHOUT } },
        { { 46862, 46863 }, { 46865, 46864 }, { 46866, 46867 } },
        SPELL_EXKEF_ACTIVE_AURA,
        true,
    },
};

// Where each companion walks beside the player (ours): Eric left, Baelog behind, Olaf right
float const CompanionFollowAngles[MAX_COMPANION_ROLES] = { float(M_PI) / 2.0f, float(M_PI), float(M_PI) * 1.5f };

// Bar slots of each pair (comment of annick 2011-02-28: buttons 3,4 - 6,7 - 9,10 of the ten)
uint8 const CompanionBarSlots[MAX_COMPANION_ROLES][2] = { { 2, 3 }, { 5, 6 }, { 8, 9 } };

static CompanionTrio const* GetTrioBySummonSpell(uint32 spellId)
{
    for (CompanionTrio const& trio : CompanionTrios)
        if (trio.SummonSpell == spellId)
            return &trio;
    return nullptr;
}

static CompanionTrio const* GetTrioByEntry(uint32 entry, uint8& role)
{
    for (CompanionTrio const& trio : CompanionTrios)
        for (uint8 r = 0; r < MAX_COMPANION_ROLES; ++r)
            if (trio.Entries[r] == entry)
            {
                role = r;
                return &trio;
            }
    return nullptr;
}

static CompanionTrio const* GetTrioByBarSpell(uint32 spellId, uint8& role, uint8& index)
{
    for (CompanionTrio const& trio : CompanionTrios)
        for (uint8 r = 0; r < MAX_COMPANION_ROLES; ++r)
            for (uint8 i = 0; i < 2; ++i)
                if (trio.BarSpells[r][i] == spellId)
                {
                    role = r;
                    index = i;
                    return &trio;
                }
    return nullptr;
}

static Creature* FindLivingCompanion(Unit* owner, uint32 entry)
{
    std::list<Creature*> minions;
    owner->GetAllMinionsByEntry(minions, entry);
    for (Creature* minion : minions)
        if (minion->IsAlive() && !minion->IsDestroyedObject())
            return minion;
    return nullptr;
}

// A pair of buttons shows while its training quest is taken, done or handed in (C3; after the three hand-ins all six stay)
static bool CompanionPairShown(Player* player, CompanionTrio const* trio, uint8 role)
{
    return player->GetQuestStatus(trio->Quests[role]) != QUEST_STATUS_NONE;
}

// Summons whichever of the three is missing (C1, C18-C20): never two of one, never for a dead player or one in combat, on a taxi or
// in a vehicle (ours: the next check brings them once he is off). The leader first: his pet category dismisses a hunter's or
// warlock's own pet (Unit::SetMinion), as the sources say. SummonProperties 2341 and 3039 have no slot, so the three never evict
// each other.
static void SummonMissingCompanions(Player* player, CompanionTrio const* trio)
{
    if (!player || !player->IsInWorld() || !player->IsAlive() || player->IsInCombat() || player->IsInFlight() || player->GetVehicle())
        return;
    if (!player->HasAura(trio->SummonSpell))
        return;

    for (uint8 role = 0; role < MAX_COMPANION_ROLES; ++role)
    {
        uint32 entry = trio->Entries[role];
        if (FindLivingCompanion(player, entry))
            continue;
        player->RemoveAllMinionsByEntry(entry);

        SummonPropertiesEntry const* properties = sSummonPropertiesStore.LookupEntry(role == ROLE_LEADER ? SUMMON_PROPERTIES_LEADER : SUMMON_PROPERTIES_HELPER);
        if (!properties)
            continue;

        Position pos = player->GetNearPosition(2.5f, CompanionFollowAngles[role]);
        if (TempSummon* summon = player->GetMap()->SummonCreature(entry, pos, properties, Milliseconds(0), player, trio->CreatedBy[role]))
            if (summon->HasUnitTypeMask(UNIT_MASK_MINION))
                static_cast<Minion*>(summon)->SetFollowAngle(CompanionFollowAngles[role]);
    }
}

static void DismissCompanions(Unit* owner, CompanionTrio const* trio)
{
    for (uint8 role = 0; role < MAX_COMPANION_ROLES; ++role)
        owner->RemoveAllMinionsByEntry(trio->Entries[role]);
}

// The ability credit (C10), per use; a playerbot in the player's group within 40 yd gets it too (plan rule 2 as amended: bots
// only, a second real player uses his own companions). KilledMonsterCredit only counts for a quest in the log that needs it.
static void CreditCompanionAbility(Player* player, uint32 credit)
{
    player->KilledMonsterCredit(credit);

    Group* group = player->GetGroup();
    if (!group)
        return;

    for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
    {
        Player* member = ref->GetSource();
        if (!member || member == player || !member->GetSession()->IsBot())
            continue;
        if (!member->IsInMap(player) || !member->IsWithinDistInMap(player, CompanionBotCreditRange))
            continue;
        member->KilledMonsterCredit(credit);
    }
}

// ---------------------------------------------------------------------------------------------------------------------------
// The summon and its aura
// ---------------------------------------------------------------------------------------------------------------------------

// 87262 The Lost Vikings: Summon Eric, 87589 Ex-KEF: Summon Amakkar (effect 0, the leader's summon)
// Cast on the player by spell_area (accept, area change, login, resurrection, any quest status change). Effect 0 now brings all
// three (the spell_linked_spell rows to 87263/87264 and 87590/87591 are gone: they summoned a second trio on every area re-entry).
// Refused for a dead player (the summon does nothing for one, and he would hold the aura without companions until he left the
// area; resurrection casts it again) and for a playerbot (no trio of its own: plan, vikings VD-29).
class spell_badlands_companion_summon : public SpellScript
{
    PrepareSpellScript(spell_badlands_companion_summon);

    SpellCastResult CheckCast()
    {
        Unit* caster = GetCaster();
        if (!caster->IsAlive())
            return SPELL_FAILED_CASTER_DEAD;
        if (Player* player = caster->ToPlayer())
            if (player->GetSession()->IsBot())
                return SPELL_FAILED_DONT_REPORT;
        return SPELL_CAST_OK;
    }

    void HandleSummon(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
        // The aura (effect 1) is applied after this effect; the companions come with the first check if it is not on yet
        if (Player* player = GetCaster()->ToPlayer())
            if (CompanionTrio const* trio = GetTrioBySummonSpell(GetSpellInfo()->Id))
                player->m_Events.AddLambdaEventAtOffset([player, trio]()
                {
                    SummonMissingCompanions(player, trio);
                }, 100);
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_badlands_companion_summon::CheckCast);
        OnEffectHit += SpellEffectFn(spell_badlands_companion_summon::HandleSummon, EFFECT_0, SPELL_EFFECT_SUMMON);
    }
};

// The same spells, effect 1 (the dummy aura on the player: "the trio is with you")
// - Every 5 s: a missing or dead companion comes back while the player is alive and out of combat (C18-C20: after a fight, a death
//   and resurrection, a Dismiss, a class pet summoned in the leader's place; a relog needs nothing here, the aura is not saved and spell_area casts it
//   again at login). A saved aura from before that change (characters mid-arc) is covered the same way.
// - Removed (spell_area no longer fits: an area outside the set, every training quest abandoned before the hand-ins, The Hidden
//   Clutch rewarded): the three go (C16, C17). The aura is death persistent: at the player's death the core unsummons them and the
//   aura stays, so the resurrected player gets them back from the check.
class spell_badlands_companion_aura : public AuraScript
{
    PrepareAuraScript(spell_badlands_companion_aura);

    void CalcPeriodic(AuraEffect const* /*aurEff*/, bool& isPeriodic, int32& amplitude)
    {
        isPeriodic = true;
        amplitude = CompanionCheckPeriod;
    }

    void HandlePeriodic(AuraEffect const* /*aurEff*/)
    {
        if (Player* player = GetTarget()->ToPlayer())
            if (CompanionTrio const* trio = GetTrioBySummonSpell(GetId()))
                SummonMissingCompanions(player, trio);
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (GetTargetApplication()->GetRemoveMode() == AURA_REMOVE_BY_DEATH)
            return;
        if (CompanionTrio const* trio = GetTrioBySummonSpell(GetId()))
            DismissCompanions(GetTarget(), trio);
    }

    void Register() override
    {
        DoEffectCalcPeriodic += AuraEffectCalcPeriodicFn(spell_badlands_companion_aura::CalcPeriodic, EFFECT_1, SPELL_AURA_DUMMY);
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_badlands_companion_aura::HandlePeriodic, EFFECT_1, SPELL_AURA_DUMMY);
        AfterEffectRemove += AuraEffectRemoveFn(spell_badlands_companion_aura::AfterRemove, EFFECT_1, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

// ---------------------------------------------------------------------------------------------------------------------------
// The companions
// ---------------------------------------------------------------------------------------------------------------------------

// 46855 Eric "The Swift", 46856 Baelog, 46857 Olaf, 47021 Amakkar, 47024 Jurrix Whitemane, 47022 Gargal
// - The leader is the player's pet (controllable guardian with a CharmInfo, whose bar is the pet bar the client shows): the bar is
//   built here (Attack, Follow, and each taken quest's pair at 3-4 / 6-7 / 9-10; slots 4 and 7 empty, ours) and rebuilt when the
//   quests change. His stance (Assist by default, /petdefensive, /petpassive) drives the other two (ours).
// - Targets, in order: what the player hits, the player's selected target while he fights it, the leader's target, what attacks
//   the player or the three, and (Assist) the nearest hostile creature within 40 yd (wiki; C12 "they pull extra packs"). Riding
//   past, only what has turned on them (as the Eastern Plaguelands followers).
// - Follow given to the leader brings all three back for a moment (3 s without picking a fight, ours).
// - Left more than 60 yd behind (the player rode on, or a same-map teleport), brought to the player (active, so their grid keeps
//   updating). A dead one is gone after 5 s; the aura's check brings him back after the fight.
// - The leader keeps the helmet aura on the player (87391 / 87592: put back after an evade); the Bad Dogs ride Mechano-Hogs while
//   the player is mounted (C15).
struct npc_badlands_companion : public ScriptedAI
{
    npc_badlands_companion(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        _trio = GetTrioByEntry(me->GetEntry(), _role);
        if (!_trio || summoner->GetTypeId() != TYPEID_PLAYER)
        {
            _trio = nullptr;
            return;
        }

        _ownerGUID = summoner->GetGUID();
        me->setActive(true, ActiveFlags::Script);
        if (_role != ROLE_LEADER)
            me->SetReactState(REACT_ASSIST);

        // Guardian::InitSummon sends the bar right after this hook (the quests held now: also after a login or a re-summon)
        if (_role == ROLE_LEADER)
        {
            _barMask = 0xFF;
            BuildBar(summoner->ToPlayer(), false);
        }

        _events.Reset();
        _events.ScheduleEvent(EVENT_COMPANION_SETUP, 500ms);
        _events.ScheduleEvent(EVENT_COMPANION_CHECK, 1s);
    }

    Player* GetOwnerPlayer() const
    {
        return ObjectAccessor::GetPlayer(*me, _ownerGUID);
    }

    Creature* GetLeader(Player* owner) const
    {
        if (_role == ROLE_LEADER)
            return me;
        return FindLivingCompanion(owner, _trio->Entries[ROLE_LEADER]);
    }

    ReactStates GetStance(Player* owner)
    {
        if (Creature* leader = GetLeader(owner))
            _stance = leader->GetReactState();
        return _stance;
    }

    void BuildBar(Player* owner, bool send)
    {
        CharmInfo* charmInfo = me->GetCharmInfo();
        if (!charmInfo || !owner)
            return;

        uint8 mask = 0;
        for (uint8 role = 0; role < MAX_COMPANION_ROLES; ++role)
            if (CompanionPairShown(owner, _trio, role))
                mask |= 1 << role;

        bool changed = mask != _barMask;
        if (!changed && !send)
            return;
        _barMask = mask;

        charmInfo->SetActionBar(0, COMMAND_ATTACK, ACT_COMMAND);
        charmInfo->SetActionBar(1, COMMAND_FOLLOW, ACT_COMMAND);
        for (uint8 slot = 2; slot < MAX_UNIT_ACTION_BAR_INDEX; ++slot)
            charmInfo->SetActionBar(slot, 0, ACT_PASSIVE);
        for (uint8 role = 0; role < MAX_COMPANION_ROLES; ++role)
            if (mask & (1 << role))
                for (uint8 i = 0; i < 2; ++i)
                    charmInfo->SetActionBar(CompanionBarSlots[role][i], _trio->BarSpells[role][i], ACT_PASSIVE);

        // A taken or abandoned quest changes the bar: the client knows the pet's buttons only from this packet
        if ((send || changed) && owner->GetMinionGUID() == me->GetGUID() && !owner->GetCharmGUID())
            owner->CharmSpellInitialize();
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }

    void AttackStart(Unit* who) override
    {
        if (!who || !_trio)
            return;

        if (Player* owner = GetOwnerPlayer())
            if (owner->IsMounted() && who->GetVictim() != me)
                return;

        if (me->IsMounted())
            me->Dismount();

        ScriptedAI::AttackStart(who);
    }

    void JustDied(Unit* /*killer*/) override
    {
        _events.Reset();
        me->DespawnOrUnsummon(5000);
    }

    void OnPetCommand(CommandStates command) override
    {
        if (command != COMMAND_FOLLOW || !_trio)
            return;

        if (Player* owner = GetOwnerPlayer())
            for (uint8 role = 0; role < MAX_COMPANION_ROLES; ++role)
                if (Creature* companion = FindLivingCompanion(owner, _trio->Entries[role]))
                    if (companion->IsAIEnabled)
                        companion->AI()->DoAction(ACTION_COMPANION_FOLLOW);
    }

    void DoAction(int32 action) override
    {
        if (action != ACTION_COMPANION_FOLLOW)
            return;

        _followLock = 3000;
        if (me->IsInCombat() || me->GetVictim())
            EnterEvadeMode(EVADE_REASON_OTHER);
        else if (Player* owner = GetOwnerPlayer())
        {
            me->GetMotionMaster()->Clear(false);
            me->GetMotionMaster()->MoveFollow(owner, PET_FOLLOW_DIST, me->GetFollowAngle());
        }
    }

    void Setup()
    {
        Player* owner = GetOwnerPlayer();
        if (!owner)
            return;

        if (!me->IsInCombat() && !me->GetVictim())
        {
            me->GetMotionMaster()->Clear(false);
            me->GetMotionMaster()->MoveFollow(owner, PET_FOLLOW_DIST, me->GetFollowAngle());
        }
    }

    // The player is gone or no longer holds the aura: go. Left far behind: brought along. The leader keeps the bar and the
    // helmet; the Bad Dogs mount with the player.
    bool Check()
    {
        Player* owner = GetOwnerPlayer();
        if (!owner || !owner->IsInWorld() || owner->GetMapId() != me->GetMapId() || !owner->HasAura(_trio->SummonSpell))
        {
            me->DespawnOrUnsummon();
            return false;
        }

        if (!me->IsWithinDist2d(owner, CompanionCatchUpRange) && !owner->IsInFlight() && !owner->GetVehicle())
        {
            if (me->IsInCombat() || me->GetVictim())
                EnterEvadeMode(EVADE_REASON_OTHER);

            Position pos = owner->GetNearPosition(2.5f, me->GetFollowAngle());
            float z = pos.GetPositionZ();
            me->UpdateGroundPositionZ(pos.GetPositionX(), pos.GetPositionY(), z);
            me->NearTeleportTo(pos.GetPositionX(), pos.GetPositionY(), z, owner->GetOrientation());
            me->GetMotionMaster()->Clear(false);
            me->GetMotionMaster()->MoveFollow(owner, PET_FOLLOW_DIST, me->GetFollowAngle());
        }

        if (_role == ROLE_LEADER)
        {
            // Back from a vehicle or a charm: the client shows that bar and forgets ours
            bool charmed = !owner->GetCharmGUID().IsEmpty();
            BuildBar(owner, _ownerCharmed && !charmed);
            _ownerCharmed = charmed;

            // An owner area aura of 40 yd: cast only within its reach, or it would be cast every second while he is farther
            if (!owner->HasAura(_trio->ActiveAura) && me->IsWithinDistInMap(owner, 35.0f))
                me->CastSpell(me, _trio->ActiveAura, true);
        }

        // Keep up with a mounted player (ours: guardians get no speed from their owner here, and were teleported up every second)
        if (owner->IsMounted() && !me->IsInCombat())
        {
            float rate = std::max(owner->GetSpeedRate(MOVE_RUN), owner->GetSpeedRate(MOVE_FLIGHT));
            if (rate > me->GetSpeedRate(MOVE_RUN))
            {
                me->SetSpeed(MOVE_RUN, rate);
                _speedSynced = true;
            }
        }
        else if (_speedSynced)
        {
            me->UpdateSpeed(MOVE_RUN, false);
            _speedSynced = false;
        }

        if (_trio->Hogs)
        {
            if (owner->IsMounted() && !me->IsMounted() && !me->IsInCombat())
                me->Mount(DISPLAY_MECHANO_HOG);
            else if (!owner->IsMounted() && me->IsMounted())
                me->Dismount();
        }
        return true;
    }

    Unit* SelectCompanionTarget(Player* owner, bool proximity)
    {
        auto canFight = [this](Unit* target)
        {
            return target && target->IsAlive() && me->IsWithinDistInMap(target, CompanionAssistRange) && me->IsValidAttackTarget(target)
                && !target->HasUnitState(UNIT_STATE_EVADE);
        };

        if (canFight(owner->GetVictim()))
            return owner->GetVictim();

        Unit* selected = owner->GetSelectedUnit();
        if (selected && owner->IsInCombatWith(selected) && canFight(selected))
            return selected;

        if (Creature* leader = GetLeader(owner))
            if (leader != me && canFight(leader->GetVictim()))
                return leader->GetVictim();

        for (Unit* attacker : owner->getAttackers())
            if (canFight(attacker))
                return attacker;

        for (uint8 role = 0; role < MAX_COMPANION_ROLES; ++role)
            if (Creature* companion = FindLivingCompanion(owner, _trio->Entries[role]))
                for (Unit* attacker : companion->getAttackers())
                    if (canFight(attacker))
                        return attacker;

        if (!proximity)
            return nullptr;

        std::list<Unit*> units;
        Trinity::AnyUnfriendlyUnitInObjectRangeCheck check(me, me, CompanionAssistRange);
        Trinity::UnitListSearcher<Trinity::AnyUnfriendlyUnitInObjectRangeCheck> searcher(me, units, check);
        me->VisitNearbyObject(CompanionAssistRange, searcher);

        Unit* nearest = nullptr;
        for (Unit* unit : units)
        {
            if (unit->GetTypeId() != TYPEID_UNIT || unit->IsControlledByPlayer() || !unit->IsHostileTo(owner) || !canFight(unit))
                continue;
            // Never the other faction's towns on their own (New Kargath for the Alliance, Dragon's Mouth for the Horde): no
            // guard, civilian or creature of a player faction; one that attacks the player or the three is fought above
            if (unit->ToCreature()->IsGuard() || unit->ToCreature()->IsCivilian())
                continue;
            if (FactionTemplateEntry const* faction = unit->GetFactionTemplateEntry())
                if (faction->ourMask & (FACTION_MASK_ALLIANCE | FACTION_MASK_HORDE))
                    continue;
            if (!me->IsWithinLOSInMap(unit))
                continue;
            if (!nearest || me->GetExactDist(unit) < me->GetExactDist(nearest))
                nearest = unit;
        }
        return nearest;
    }

    void Assist()
    {
        Player* owner = GetOwnerPlayer();
        if (!owner)
            return;

        if (owner->IsMounted())
        {
            // A mounted player fights nothing (Unit::Attack); a companion only flagged into a fight follows instead
            if (me->IsInCombat() && me->getAttackers().empty())
                EnterEvadeMode(EVADE_REASON_OTHER);
            return;
        }

        ReactStates stance = GetStance(owner);
        if (stance == REACT_PASSIVE)
        {
            if (_role != ROLE_LEADER && me->GetVictim())
                EnterEvadeMode(EVADE_REASON_OTHER);
            return;
        }

        if (_followLock || me->GetVictim())
            return;

        if (Unit* target = SelectCompanionTarget(owner, stance == REACT_ASSIST || stance == REACT_AGGRESSIVE))
            AttackStart(target);
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_trio)
            return;

        _followLock = _followLock > diff ? _followLock - diff : 0;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_COMPANION_SETUP:
                    Setup();
                    break;
                case EVENT_COMPANION_CHECK:
                    if (!Check())
                        return;
                    Assist();
                    _events.ScheduleEvent(EVENT_COMPANION_CHECK, 1s);
                    break;
                default:
                    break;
            }
        }

        if (!UpdateVictim())
            return;

        DoMeleeAttackIfReady();
    }

private:
    CompanionTrio const* _trio = nullptr;
    uint8 _role = ROLE_LEADER;
    ObjectGuid _ownerGUID;
    EventMap _events;
    uint8 _barMask = 0xFF;
    bool _ownerCharmed = false;
    uint32 _followLock = 0;
    ReactStates _stance = REACT_ASSIST;
    bool _speedSynced = false;
};

// ---------------------------------------------------------------------------------------------------------------------------
// The bar's six abilities
// ---------------------------------------------------------------------------------------------------------------------------

// The player behind a companion's cast, and that cast's place in the trio
struct CompanionCastContext
{
    Player* Owner = nullptr;
    CompanionTrio const* Trio = nullptr;
    uint8 Role = 0;
    uint8 Index = 0;
};

static bool GetCompanionCastContext(Unit* caster, uint32 spellId, CompanionCastContext& ctx)
{
    if (!caster || caster->GetTypeId() != TYPEID_UNIT)
        return false;
    ctx.Trio = GetTrioByBarSpell(spellId, ctx.Role, ctx.Index);
    if (!ctx.Trio || caster->GetEntry() != ctx.Trio->Entries[ROLE_LEADER])
        return false;
    Unit* owner = caster->GetOwner();
    ctx.Owner = owner ? owner->ToPlayer() : nullptr;
    return ctx.Owner != nullptr;
}

// The two abilities aimed at the player's target: Charge / Kidney Shot (87278 / 87608, all effects TARGET_UNIT_TARGET_ENEMY) and
// Valhalla Shot / Fiery Blast (87281 / 87612, whose shot 87276 / 87593 is TARGET_UNIT_TARGET_ENEMY; C6 "the enemy you have
// selected"). The other four act on the companions (Pocket Potion 87279 / 87609, Warcry / Time Warp 87277 / 87596: area entries
// around the caster; Shield Wall 87275 / 87607: the caster) or around the tank (Mighty Shout 87274 / 87606: TARGET_UNIT_SRC_AREA_ENEMY).
static bool CompanionAbilityNeedsTarget(uint32 spellId)
{
    switch (spellId)
    {
        case SPELL_ERIC_CHARGE:
        case SPELL_AMAKKAR_KIDNEY_SHOT:
        case SPELL_BAELOG_VALHALLA_SHOT:
        case SPELL_JURRIX_FIERY_BLAST:
            return true;
        default:
            return false;
    }
}

// Usable while the player holds the ability's quest (or has handed it in) and is not mounted (720258 2010-12-08 [+6]; the
// refusal is ours); the companion who carries it out must be there. Charge / Kidney Shot and Valhalla Shot / Fiery Blast need a
// hostile target selected (Adelorna 2010-12-01 [+30]: "you have to tag the mob ... before the abilities become active"), the
// shot within 100 yd of the shooter. Mighty Shout taunts a selected hostile target only within 40 yd of the tank (ours), else
// the enemies around him (the spell's own area, FilterShoutTargets).
static SpellCastResult CheckCompanionAbility(Unit* caster, uint32 spellId)
{
    CompanionCastContext ctx;
    if (!GetCompanionCastContext(caster, spellId, ctx))
        return SPELL_FAILED_DONT_REPORT;

    if (ctx.Owner->IsMounted())
        return SPELL_FAILED_NOT_MOUNTED;

    if (!CompanionPairShown(ctx.Owner, ctx.Trio, ctx.Role))
        return SPELL_FAILED_DONT_REPORT;

    Unit* target = ctx.Owner->GetSelectedUnit();
    if (target && (!target->IsAlive() || !ctx.Owner->IsValidAttackTarget(target)))
        target = nullptr;

    if (!target && CompanionAbilityNeedsTarget(spellId))
        return SPELL_FAILED_BAD_TARGETS;

    if (ctx.Role != ROLE_LEADER)
    {
        Creature* helper = FindLivingCompanion(ctx.Owner, ctx.Trio->Entries[ctx.Role]);
        if (!helper)
            return SPELL_FAILED_NO_VALID_TARGETS;

        if (spellId == SPELL_BAELOG_VALHALLA_SHOT || spellId == SPELL_JURRIX_FIERY_BLAST)
        {
            if (!target || !helper->IsWithinDistInMap(target, CompanionShotRange))
                return SPELL_FAILED_OUT_OF_RANGE;
        }
        else if (spellId == SPELL_OLAF_MIGHTY_SHOUT || spellId == SPELL_GARGAL_MIGHTY_SHOUT)
        {
            if (target && !helper->IsWithinDistInMap(target, CompanionAssistRange))
                return SPELL_FAILED_OUT_OF_RANGE;
        }
    }
    return SPELL_CAST_OK;
}

static void CreditCompanionCast(Unit* caster, uint32 spellId)
{
    CompanionCastContext ctx;
    if (GetCompanionCastContext(caster, spellId, ctx))
        CreditCompanionAbility(ctx.Owner, ctx.Trio->Credits[ctx.Role][ctx.Index]);
}

// 87278 Eric's Charge, 87608 Amakkar's Kidney Shot: the core charges and stuns the explicit target; credit 46862
class spell_badlands_companion_charge : public SpellScript
{
    PrepareSpellScript(spell_badlands_companion_charge);

    SpellCastResult CheckCast()
    {
        return CheckCompanionAbility(GetCaster(), GetSpellInfo()->Id);
    }

    void HandleAfterCast()
    {
        CreditCompanionCast(GetCaster(), GetSpellInfo()->Id);
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_badlands_companion_charge::CheckCast);
        AfterCast += SpellCastFn(spell_badlands_companion_charge::HandleAfterCast);
    }
};

// 87279 Eric's Pocket Potion, 87609 Amakkar's Pocket Potion: heals the three over 10 s (effect 0, area entries conditioned to the
// three entries; limited here to this player's three, not another player's beside him); credit 46863
class spell_badlands_companion_potion : public SpellScript
{
    PrepareSpellScript(spell_badlands_companion_potion);

    SpellCastResult CheckCast()
    {
        return CheckCompanionAbility(GetCaster(), GetSpellInfo()->Id);
    }

    void FilterTargets(std::list<WorldObject*>& targets)
    {
        targets.clear();
        CompanionCastContext ctx;
        if (!GetCompanionCastContext(GetCaster(), GetSpellInfo()->Id, ctx))
            return;
        for (uint8 role = 0; role < MAX_COMPANION_ROLES; ++role)
            if (Creature* companion = FindLivingCompanion(ctx.Owner, ctx.Trio->Entries[role]))
                targets.push_back(companion);
    }

    void HandleAfterCast()
    {
        CreditCompanionCast(GetCaster(), GetSpellInfo()->Id);
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_badlands_companion_potion::CheckCast);
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_badlands_companion_potion::FilterTargets, EFFECT_0, TARGET_UNIT_DEST_AREA_ENTRY);
        AfterCast += SpellCastFn(spell_badlands_companion_potion::HandleAfterCast);
    }
};

// 87281 Baelog's Valhalla Shot / 87612 Jurrix's Fiery Blast (script effect), 87280 Baelog's Warcry / 87611 Jurrix's Time Warp,
// 87282 / 87613 Shield Wall, 87283 / 87614 Mighty Shout (dummies): the leader's order, carried out by the right companion of this
// player (the effect's area entry target, set here): the shot at the player's selected target (C6, 808808 "click on the
// flameblade, not the npc"), the attack speed buff on the three (87277 / 87596), the shield on himself (87275 / 87607), the taunt
// onto himself (87274 / 87606) of the player's target, or without one of the enemies within 15 yd of him. Credits 46864-46867
// (Horde: Fiery Blast 46865, Time Warp 46864).
class spell_badlands_companion_order : public SpellScript
{
    PrepareSpellScript(spell_badlands_companion_order);

    SpellCastResult CheckCast()
    {
        return CheckCompanionAbility(GetCaster(), GetSpellInfo()->Id);
    }

    void FilterTargets(std::list<WorldObject*>& targets)
    {
        targets.clear();
        CompanionCastContext ctx;
        if (!GetCompanionCastContext(GetCaster(), GetSpellInfo()->Id, ctx))
            return;
        if (Creature* helper = FindLivingCompanion(ctx.Owner, ctx.Trio->Entries[ctx.Role]))
            targets.push_back(helper);
    }

    void HandleOrder(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);

        Unit* helper = GetHitUnit();
        CompanionCastContext ctx;
        if (!helper || !GetCompanionCastContext(GetCaster(), GetSpellInfo()->Id, ctx))
            return;
        _orderCarried = true;
        Unit* target = ctx.Owner->GetSelectedUnit();

        auto attack = [helper](Unit* victim)
        {
            if (victim && helper->IsAIEnabled && !helper->GetVictim() && helper->IsValidAttackTarget(victim))
                helper->ToCreature()->AI()->AttackStart(victim);
        };

        switch (GetSpellInfo()->Id)
        {
            case SPELL_BAELOG_VALHALLA_SHOT:
                if (target)
                {
                    helper->CastSpell(target, SPELL_VALHALLA_SHOT_HIT, true);
                    attack(target);
                }
                break;
            case SPELL_JURRIX_FIERY_BLAST:
                if (target)
                {
                    helper->CastSpell(target, SPELL_FIERY_BLAST_HIT, true);
                    attack(target);
                }
                break;
            case SPELL_BAELOG_WARCRY:
                helper->CastSpell(helper, SPELL_WARCRY_BUFF, true);
                break;
            case SPELL_JURRIX_TIME_WARP:
                helper->CastSpell(helper, SPELL_TIME_WARP_BUFF, true);
                break;
            case SPELL_OLAF_SHIELD_WALL:
                helper->CastSpell(helper, SPELL_OLAF_SHIELD_WALL_BUFF, true);
                break;
            case SPELL_GARGAL_SHIELD_WALL:
                helper->CastSpell(helper, SPELL_GARGAL_SHIELD_WALL_BUFF, true);
                break;
            case SPELL_OLAF_MIGHTY_SHOUT:
                helper->CastSpell(helper, SPELL_OLAF_MIGHTY_SHOUT_TAUNT, true);
                attack(target);
                break;
            case SPELL_GARGAL_MIGHTY_SHOUT:
                helper->CastSpell(helper, SPELL_GARGAL_MIGHTY_SHOUT_TAUNT, true);
                attack(target);
                break;
            default:
                break;
        }
    }

    // Only an order that reached its companion counts (the target can be lost to line of sight in Spell::AddUnitTarget)
    void HandleAfterCast()
    {
        if (_orderCarried)
            CreditCompanionCast(GetCaster(), GetSpellInfo()->Id);
    }

    bool _orderCarried = false;

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_badlands_companion_order::CheckCast);
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_badlands_companion_order::FilterTargets, EFFECT_0, TARGET_UNIT_DEST_AREA_ENTRY);
        // Script effect on the two shots, dummy on the other four
        OnEffectHitTarget += SpellEffectFn(spell_badlands_companion_order::HandleOrder, EFFECT_0, SPELL_EFFECT_ANY);
        AfterCast += SpellCastFn(spell_badlands_companion_order::HandleAfterCast);
    }
};

// 87277 Baelog's Warcry, 87596 Jurrix's Time Warp (effect 0, area entries conditioned to the three entries): this player's three
// only, not another player's beside them
class spell_badlands_companion_buff : public SpellScript
{
    PrepareSpellScript(spell_badlands_companion_buff);

    void FilterTargets(std::list<WorldObject*>& targets)
    {
        Unit* caster = GetCaster();
        Unit* owner = caster ? caster->GetOwner() : nullptr;
        targets.remove_if([owner](WorldObject* object)
        {
            Unit* unit = object->ToUnit();
            return !owner || !unit || unit->GetOwnerGUID() != owner->GetGUID();
        });
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_badlands_companion_buff::FilterTargets, EFFECT_0, TARGET_UNIT_DEST_AREA_ENTRY);
    }
};

// 87274 Olaf's Mighty Shout, 87606 Gargal's Mighty Shout (taunt, effects 0 and 1 on enemies around him): "Taunts the target to
// attack Olaf" (87283): the player's selected target when it is in reach (ours); without one the spell's own area
static void FilterShoutTargets(Unit* caster, std::list<WorldObject*>& targets)
{
    Unit* owner = caster ? caster->GetOwner() : nullptr;
    Player* player = owner ? owner->ToPlayer() : nullptr;
    if (!player)
        return;

    Unit* target = player->GetSelectedUnit();
    if (!target || !target->IsAlive() || !caster->IsValidAttackTarget(target) || !caster->IsWithinDistInMap(target, CompanionAssistRange))
        return;

    targets.clear();
    targets.push_back(target);
}

class spell_badlands_companion_shout : public SpellScript
{
    PrepareSpellScript(spell_badlands_companion_shout);

    void FilterTargets(std::list<WorldObject*>& targets)
    {
        FilterShoutTargets(GetCaster(), targets);
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_badlands_companion_shout::FilterTargets, EFFECT_0, TARGET_UNIT_SRC_AREA_ENEMY);
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_badlands_companion_shout::FilterTargets, EFFECT_1, TARGET_UNIT_SRC_AREA_ENEMY);
    }
};

// 87391 Viking Helmet, 87592 Ex-KEF: Active Aura (cast by the leader, area aura on his owner): the helmet on the player (wiki
// 27828 / 27834 / 27835 notes and screenshot; the Horde twin shows nothing described). The spell data also cut the player's kill
// XP by half (effect 1, MOD_XP_PCT -50), which no source mentions: kept at 0 (questions.md 1, the default; KillRewarder reads
// the aura's amount).
class spell_badlands_companion_active_aura : public AuraScript
{
    PrepareAuraScript(spell_badlands_companion_active_aura);

    void CalcXpAmount(AuraEffect const* /*aurEff*/, float& amount, bool& /*canBeRecalculated*/)
    {
        amount = 0;
    }

    void Register() override
    {
        DoEffectCalcAmount += AuraEffectCalcAmountFn(spell_badlands_companion_active_aura::CalcXpAmount, EFFECT_1, SPELL_AURA_MOD_XP_PCT);
    }
};

void AddSC_badlands_companions()
{
    new spell_script<spell_badlands_companion_summon>("spell_badlands_companion_summon");
    new aura_script<spell_badlands_companion_aura>("spell_badlands_companion_aura");
    new creature_script<npc_badlands_companion>("npc_badlands_companion");
    new spell_script<spell_badlands_companion_charge>("spell_badlands_companion_charge");
    new spell_script<spell_badlands_companion_potion>("spell_badlands_companion_potion");
    new spell_script<spell_badlands_companion_order>("spell_badlands_companion_order");
    new spell_script<spell_badlands_companion_buff>("spell_badlands_companion_buff");
    new spell_script<spell_badlands_companion_shout>("spell_badlands_companion_shout");
    new aura_script<spell_badlands_companion_active_aura>("spell_badlands_companion_active_aura");
}
