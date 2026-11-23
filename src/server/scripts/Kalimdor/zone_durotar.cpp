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

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "Vehicle.h"
#include "ObjectMgr.h"
#include "ScriptedEscortAI.h"
#include "CombatAI.h"
#include "PassiveAI.h"
#include "Player.h"
#include "SpellInfo.h"
#include "CreatureTextMgr.h"
#include "DatabaseEnv.h"
#include "Group.h"
#include "Map.h"
#include "TemporarySummon.h"
#include <mutex>
#include <set>

/*######
## Quest 25134: Lazy Peons
## npc_lazy_peon
######*/

enum eYells
{
    SAY_INTRO = 0,
    SAY_SPECIAL_1,
    SAY_SPECIAL_2,
    SAY_SPECIAL_3,
    SAY_SPECIAL_4,
    SAY_SPECIAL_5,
    SAY_SPECIAL_6,
    SAY_SPECIAL_7,
    SAY_SPECIAL_8,
    SAY_SPECIAL_9,
    SAY_SPECIAL_10,
    SAY_SPECIAL_11,
    SAY_SPECIAL_12,
    SAY_SPECIAL_13,
    SAY_SPECIAL_14,
    SAY_SPECIAL_15,
    SAY_SPECIAL_16,
    SAY_SPECIAL_17,
    SAY_SPECIAL_18,
    SAY_SPECIAL_19,
    SAY_SPECIAL_20,
    SAY_SPECIAL_21,
    SAY_SPECIAL_22,
};

enum eSpells
{
    SPELL_SUMMON_GARROSH_JI          = 121139,
    SPELL_SUMMON_JI                  = 120749,
                                     
    // Garrosh Abilities             
    SPELL_BERSERK_CHARGE             = 84742,
    SPELL_WHIRLWIND                  = 84724,
    SPELL_SHOCKWAVE                  = 84715,

    // Quest: Gift of Hellscream 
    // So, will use 6td phase for player and 2 for creatures because i didn`t find phase aura.
    SPELL_TELEPORT_OUT_BLACKOUT      = 121123,
    SPELL_RING_OF_VALOR_IN_THE_ARENA = 132633,
    SPELL_VISUAL_TELEPORT            = 132629, // for creatures
};

enum eEvents
{
    EVENT_CHARGE_B  = 1,
    EVENT_WHIRLWIND = 2,
    EVENT_SHOCKWAVE = 3,
};

enum eQuests
{
    QUEST_LAZY_PEONS                   = 25134,
    QUEST_THE_HORDE_WAY                = 31013,
    QUEST_GIFT_OF_HELLSCREAM           = 31014,
    QUEST_LOST_IN_THE_FLOODS           = 25187,
    QUEST_WATERSHED_PATROL             = 25188,
    QUEST_LOST_BUT_NOT_FORGOTTEN       = 25193, // trigger kc3
    QUEST_SPIRIT_BE_PRAISED            = 25189, // trigger kc1
    QUEST_RAGGARANS_FURY               = 25192, // trigger kc2
    QUEST_THATS_THE_END_OF_THIS_RAPTOR = 25195, // trigger kc4
};

enum eCreatures
{
    NPC_GARROSH_HORDE_WAY        = 62087, // should be summoned to trigged (DEST_NEARBY_ENTRY) cuz used by same spell in prev quest
    NPC_JI_FIREPAWN_HORDE_WAY    = 62081, // Same like Garrosh
    NPC_GARROSH_HORDE_WAY_CREDIT = 62089,

    /*Lost in the Floods*/
    NPC_LOST_IN_THE_FLOOD_KC1    = 39357,
    NPC_LOST_IN_THE_FLOOD_KC2    = 39358,
    NPC_LOST_IN_THE_FLOOD_KC3    = 39359,
    NPC_LOST_IN_THE_FLOOD_KC4    = 39360,

    /*Watershed Patrol*/
    NPC_WATERSHED_PATROL_KC1     = 39331,
    NPC_WATERSHED_PATROL_KC2     = 39332,
    NPC_WATERSHED_PATROL_KC3     = 39333,
    NPC_WATERSHED_PATROL_KC4     = 39334,

    /*Gift of Hellscream*/
    NPC_ARENA_CREDIT             = 62209,
    NPC_GADOON                   = 62100,
    NPC_FROZENGORE               = 62097,
    NPC_OGGAX                    = 62102,
};

enum eActions
{
    ACTION_GIFT_OF_HELLSCREAM,
    ACTION_CREAURE_SLAIN,
    ACTION_INIT_TRIAL,
    ACTION_TRIAL_WON,       // #510: Garrosh -> Ji, the third challenger fell
};

const Position GarroshHordeWayPath[6]
{
    { 1658.80f, -4348.18f, 26.35f, 3.61f },
    { 1662.11f, -4342.89f, 26.36f, 1.28f },
    { 1659.93f, -4337.30f, 26.45f, 1.19f },
    { 1646.26f, -4359.82f, 26.76f, 3.29f },
    { 1633.08f, -4362.12f, 26.77f, 3.52f },
    { 1624.11f, -4366.82f, 24.61f, 3.54f },
};

const Position TrialSpawnPoints[3]
{
    { 2001.87f, -4730.90f, 86.77f, 6.03f},
    { 1999.71f, -4739.68f, 86.77f, 6.23f },
    { 2000.45f, -4747.63f, 86.77f, 6.28f },
};

const Position GarroshArenaPos  = { 2030.34f, -4713.97f, 95.93f, 4.75f };
const Position RingOfValor      = { 2031.56f, -4753.59f, 86.77f, 1.56f };
const Position LeaveRingOfValor = { 2125.208f, -4731.869f, 50.304f, 2.581132f };

const std::map<uint32, uint32> trialMatchType =
{
    { NPC_GADOON,     0 },
    { NPC_FROZENGORE, 1 },
    { NPC_OGGAX,      2 },
};

const std::map<uint32, uint32> watershedMatchType =
{
    { QUEST_SPIRIT_BE_PRAISED,            NPC_WATERSHED_PATROL_KC1 },
    { QUEST_RAGGARANS_FURY,               NPC_WATERSHED_PATROL_KC2 },
    { QUEST_LOST_BUT_NOT_FORGOTTEN,       NPC_WATERSHED_PATROL_KC3 },
    { QUEST_THATS_THE_END_OF_THIS_RAPTOR, NPC_WATERSHED_PATROL_KC4 },
};

enum LazyPeon
{
    SAY_PEON_AWOKEN             = 0,       // creature_text 10556 group 0: four lines, Sound 7514
    SPELL_PEON_SLEEPING         = 17743,   // root + sleep visual; 120 s in the DBC, kept on for as long as he sleeps
    SPELL_AWAKEN_PEON           = 19938,   // Foreman's Blackjack; Spell::CheckCast only lets it hit a peon with 17743
    GO_LUMBERPILE               = 175784,

    POINT_PEON_PILE             = 1,
    POINT_PEON_HOME             = 2,

    EVENT_PEON_STOP_WORK        = 1,
    EVENT_PEON_PILE_TIMEOUT,
    EVENT_PEON_HOME_TIMEOUT,
    EVENT_PEON_KEEP_ASLEEP
};

// 10556 - Lazy Peon (Lazy Peons 25134)
// Sourced: the peons sleep under the valley's trees; the Foreman's Blackjack wakes one (credit, one of four lines with the
// "boink" Sound 7514: TDB 4.4.2 / 12.1.0 creature_text), he goes back to work at the wood pile and falls asleep again about
// 1 min 20 s after the wake (Wowhead 2009-08-08 "they go to sleep 1min and 20secs after you wake them up"; wiki "a minute or
// two"). An awake peon cannot be hit ("wait for him to fall asleep", 2014-03-31; Spell.cpp's 17743 check).
// Ours: he walks (not runs) to the nearest pile within 20 yd, chops there for 80 s, walks back and sleeps at his spawn;
// without a pile he chops where he stands. A peon nobody wakes stays asleep: the wiki's cycle and the 2014 comment are read
// as peons other players woke (the 2009 comment ties the timing to the wake, no source shows a peon waking on his own, and
// the other reading is the grindier one). 17743 lasts 120 s in the DBC: the script keeps it on while he sleeps.
struct npc_lazy_peon : public ScriptedAI
{
    enum class PeonState { Asleep, ToPile, Chopping, ToHome, Fighting };

    npc_lazy_peon(Creature* creature) : ScriptedAI(creature), _state(PeonState::Asleep) { }

    void Reset() override
    {
        _events.Reset();
        me->SetEmoteState(EMOTE_ONESHOT_NONE);

        // After an evade (EnterEvadeMode below) he is on his way home and falls asleep there (JustReachedHome); otherwise
        // (spawn, respawn) he sleeps where he is: his spawn point
        if (me->HasUnitState(UNIT_STATE_EVADE))
            _state = PeonState::ToHome;
        else
            FallAsleep();
    }

    void JustAppeared() override
    {
        ScriptedAI::JustAppeared();
        FallAsleep();
    }

    void SpellHit(Unit* caster, SpellInfo const* spell) override
    {
        if (spell->Id != SPELL_AWAKEN_PEON)
            return;

        Player* player = caster->ToPlayer();
        if (!player || player->GetQuestStatus(QUEST_LAZY_PEONS) != QUEST_STATUS_INCOMPLETE)
            return;

        // A sleeping peon wakes and credits. A second player's Blackjack that passed CheckCast while he still slept (the hits
        // land in the same moment, within 1 s of the wake, whether he is walking to a pile or, without one, already chopping)
        // credits that player too (ours: he hit a sleeping peon, and it is the
        // less grindy reading); later hits on the awake peon cannot be cast at all (Spell.cpp's 17743 check)
        if (_state == PeonState::Asleep)
        {
            _wakeTime = getMSTime();
            _wokenBy.clear();
        }
        else if ((_state != PeonState::ToPile && _state != PeonState::Chopping) || getMSTimeDiff(_wakeTime, getMSTime()) > 1000)
            return;

        if (!_wokenBy.insert(player->GetGUID()).second)
            return;

        player->KilledMonsterCredit(me->GetEntry(), me->GetGUID());
        Talk(SAY_PEON_AWOKEN, player);

        if (_state == PeonState::Asleep)
        {
            me->RemoveAurasDueToSpell(SPELL_PEON_SLEEPING);
            GoToPile();
        }
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type != POINT_MOTION_TYPE)
            return;

        if (pointId == POINT_PEON_PILE && _state == PeonState::ToPile)
            StartChopping();
        else if (pointId == POINT_PEON_HOME && _state == PeonState::ToHome)
            FallAsleep();
    }

    void JustEngagedWith(Unit* who) override
    {
        ScriptedAI::JustEngagedWith(who);

        // Attacked (an Alliance player: faction 29): he wakes and fights back
        _state = PeonState::Fighting;
        _events.Reset();
        me->SetEmoteState(EMOTE_ONESHOT_NONE);
        me->RemoveAurasDueToSpell(SPELL_PEON_SLEEPING);
    }

    // _EnterEvadeMode reloads the template addon, whose 17743 roots him: HomeMovementGenerator does not move a rooted unit and
    // "arrives" where he stands. Take the root off so he walks home, then sleeps there (JustReachedHome)
    void EnterEvadeMode(EvadeReason why) override
    {
        if (!_EnterEvadeMode(why))
            return;

        me->RemoveAurasDueToSpell(SPELL_PEON_SLEEPING);
        me->AddUnitState(UNIT_STATE_EVADE);
        me->GetMotionMaster()->MoveTargetedHome();
        Reset();
    }

    void JustReachedHome() override
    {
        FallAsleep();
    }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_PEON_PILE_TIMEOUT:
                    // No way to the pile: work where he is
                    if (_state == PeonState::ToPile)
                        StartChopping();
                    break;
                case EVENT_PEON_STOP_WORK:
                    if (_state == PeonState::Chopping)
                        GoHome();
                    break;
                case EVENT_PEON_HOME_TIMEOUT:
                    if (_state == PeonState::ToHome)
                    {
                        Position const& home = me->GetHomePosition();
                        me->NearTeleportTo(home.GetPositionX(), home.GetPositionY(), home.GetPositionZ(), home.GetOrientation());
                        FallAsleep();
                    }
                    break;
                case EVENT_PEON_KEEP_ASLEEP:
                    KeepAsleep();
                    _events.ScheduleEvent(EVENT_PEON_KEEP_ASLEEP, 5s);
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
    void FallAsleep()
    {
        _state = PeonState::Asleep;
        _events.Reset();
        me->SetEmoteState(EMOTE_ONESHOT_NONE);

        if (!me->IsInWorld())
            return;

        if (me->GetExactDist2d(me->GetHomePosition()) < 1.0f)
            me->SetFacingTo(me->GetHomePosition().GetOrientation());

        KeepAsleep();
        _events.ScheduleEvent(EVENT_PEON_KEEP_ASLEEP, 5s);
    }

    // The sleep aura on, and without its 120 s end: an untouched peon stays asleep
    void KeepAsleep()
    {
        if (_state != PeonState::Asleep || me->IsInCombat())
            return;

        Aura* sleep = me->GetAura(SPELL_PEON_SLEEPING);
        if (!sleep)
            sleep = me->AddAura(SPELL_PEON_SLEEPING, me);
        if (sleep && sleep->GetMaxDuration() != -1)
        {
            sleep->SetMaxDuration(-1);
            sleep->SetDuration(-1);
        }
    }

    void GoToPile()
    {
        _events.Reset();
        _state = PeonState::ToPile;
        me->SetWalk(true);

        if (GameObject* pile = me->FindNearestGameObject(GO_LUMBERPILE, 20.0f))
        {
            _pileGUID = pile->GetGUID();
            // Beside the pile, on the side he comes from
            float angle = pile->GetAngle(me);
            me->GetMotionMaster()->MovePoint(POINT_PEON_PILE, pile->GetPositionX() + 1.5f * std::cos(angle),
                pile->GetPositionY() + 1.5f * std::sin(angle), pile->GetPositionZ());
            _events.ScheduleEvent(EVENT_PEON_PILE_TIMEOUT, 20s);
        }
        else
        {
            _pileGUID.Clear();
            StartChopping();
        }
    }

    void StartChopping()
    {
        _events.Reset();
        _state = PeonState::Chopping;
        me->StopMoving();

        if (GameObject* pile = ObjectAccessor::GetGameObject(*me, _pileGUID))
            me->SetFacingToObject(pile);

        // The looping chop (emote state 234), set once: the old script sent the one-shot 466 on every AI tick, asleep or not
        me->SetEmoteState(EMOTE_STATE_WORK_CHOPWOOD);
        _events.ScheduleEvent(EVENT_PEON_STOP_WORK, 80s);
    }

    void GoHome()
    {
        _events.Reset();
        _state = PeonState::ToHome;
        me->SetEmoteState(EMOTE_ONESHOT_NONE);

        if (me->GetExactDist2d(me->GetHomePosition()) < 1.0f)
        {
            FallAsleep();
            return;
        }

        me->SetWalk(true);
        me->GetMotionMaster()->MovePoint(POINT_PEON_HOME, me->GetHomePosition());
        _events.ScheduleEvent(EVENT_PEON_HOME_TIMEOUT, 30s);
    }

    EventMap _events;
    ObjectGuid _pileGUID;
    PeonState _state;
    uint32 _wakeTime = 0;
    std::set<ObjectGuid> _wokenBy;
};

// Garrosh Hellscream warchief 39605
class npc_garrosh_hellscream_warchief : public CreatureScript
{
    public:
        npc_garrosh_hellscream_warchief() : CreatureScript("npc_garrosh_hellscream_warchief") { }

        bool OnQuestAccept(Player* player, Creature* creature, Quest const* quest) override
        {
            if (quest->GetQuestId() == QUEST_THE_HORDE_WAY)
                creature->CastSpell(player, SPELL_SUMMON_GARROSH_JI, true);

            return false;
        }

        struct npc_garrosh_hellscream_warchiefAI : public ScriptedAI
        {
            npc_garrosh_hellscream_warchiefAI(Creature* creature) : ScriptedAI(creature) { }

            EventMap events;

            void Reset() override
            {
                events.Reset();
            }

            void JustEngagedWith(Unit* /*who*/) override
            {
                events.ScheduleEvent(EVENT_WHIRLWIND, 25 * IN_MILLISECONDS);
                events.ScheduleEvent(EVENT_CHARGE_B, urand(1 * IN_MILLISECONDS, 5 * IN_MILLISECONDS));
                events.ScheduleEvent(EVENT_SHOCKWAVE, 15 * IN_MILLISECONDS);
            }

            void UpdateAI(uint32 diff) override
            {
                if (!UpdateVictim())
                    return;

                events.Update(diff);

                while (uint32 eventId = events.ExecuteEvent())
                {
                    switch (eventId)
                    {
                        case EVENT_CHARGE_B:
                            if (HandleDelayIfInWhirlwind(eventId))
                                break;

                            if (Unit* target = SelectTarget(SELECT_TARGET_RANDOM, 0, NonTankTargetSelector(me)))
                                DoCast(target, SPELL_BERSERK_CHARGE, false);

                            events.ScheduleEvent(EVENT_CHARGE_B, urand(12.5 * IN_MILLISECONDS, 31 * IN_MILLISECONDS));
                            break;
                        case EVENT_WHIRLWIND:
                            DoCast(me, SPELL_WHIRLWIND);
                            events.ScheduleEvent(EVENT_WHIRLWIND, 50 * IN_MILLISECONDS);
                            me->ClearUnitState(UNIT_STATE_CASTING);
                            break;
                        case EVENT_SHOCKWAVE:
                            if (HandleDelayIfInWhirlwind(eventId))
                                break;

                            if (Unit* target = SelectTarget(SELECT_TARGET_RANDOM, 0, 180.0f, true))
                                DoCast(target, SPELL_SHOCKWAVE, false);

                            events.ScheduleEvent(EVENT_SHOCKWAVE, 15 * IN_MILLISECONDS);
                            break;
                    }
                }

                DoMeleeAttackIfReady();
            }

            private:
                bool HandleDelayIfInWhirlwind(uint32 eventID)
                {
                    if (me->HasAura(SPELL_WHIRLWIND))
                    {
                        events.RescheduleEvent(eventID, urand(1 * IN_MILLISECONDS, 2 * IN_MILLISECONDS));
                        return true;
                    }

                    return false;
                }
        };

        CreatureAI* GetAI(Creature* creature) const override
        {
            return new npc_garrosh_hellscream_warchiefAI(creature);
        }
};

// Garrosh Horde Way 62087
class npc_garrosh_horde_way_quest : public CreatureScript
{
    public:
        npc_garrosh_horde_way_quest() : CreatureScript("npc_garrosh_horde_way_quest") { }

        struct npc_garrosh_horde_way_questAI : public ScriptedAI
        {
            npc_garrosh_horde_way_questAI(Creature* creature) : ScriptedAI(creature) { }

            ObjectGuid summonerGUID;
            uint32 delay, slainCount;
            std::vector<ObjectGuid> challengerGUIDs;
            bool trialRunning = false;      // #510: Ring of Valor trial in progress (player alive and on this map)
            uint32 trialCheckTimer = 1000;

            // #510: the arena Ji 62081 that AreaTrigger_at_ring_of_valor_entrance summoned for this Garrosh's player.
            Creature* FindOwnerJi()
            {
                std::list<Creature*> jiList;
                me->GetCreatureListWithEntryInGrid(jiList, NPC_JI_FIREPAWN_HORDE_WAY, 100.0f);
                for (Creature* ji : jiList)
                    if (ji->IsAlive() && ji->IsSummon() && ji->ToTempSummon()->GetSummonerGUID() == summonerGUID)
                        return ji;
                return nullptr;
            }

            // #510: the player died or left the Ring of Valor before the three challengers fell ("Victory, or death!").
            // Nothing ended the trial: Garrosh, Ji and the challengers (all TEMPSUMMON_MANUAL_DESPAWN) stayed on map 1043,
            // the player kept the arena aura 132633 (effect 2 = aura 314 PREVENT_RESURRECTION) and phase 6, and the
            // area trigger refuses a phase-6 player, so the quest could not be retried. End it so the player can.
            void FailTrial()
            {
                trialRunning = false;
                me->m_Events.KillAllEvents(false);

                for (auto&& itr : challengerGUIDs)
                    if (Creature* challenger = ObjectAccessor::GetCreature(*me, itr))
                        challenger->DespawnOrUnsummon();
                challengerGUIDs.clear();

                if (Creature* ji = FindOwnerJi())
                    ji->DespawnOrUnsummon();

                // Map-local lookup only (a player who left map 1043 is updated by another map thread; the zone change
                // there recomputes his phase).
                if (Player* owner = ObjectAccessor::GetPlayer(*me, summonerGUID))
                {
                    owner->RemoveAurasDueToSpell(SPELL_RING_OF_VALOR_IN_THE_ARENA);
                    if (owner->GetPhaseMask() == 6)
                        owner->SetPhaseMask(PHASEMASK_NORMAL, true);
                }

                me->DespawnOrUnsummon();
            }

            void UpdateAI(uint32 diff) override
            {
                if (trialRunning)
                {
                    if (trialCheckTimer <= diff)
                    {
                        trialCheckTimer = 1000;
                        Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID);
                        if (!owner || !owner->IsAlive())
                        {
                            FailTrial();
                            return;
                        }
                    }
                    else
                        trialCheckTimer -= diff;
                }

                ScriptedAI::UpdateAI(diff);
            }

            void IsSummonedBy(Unit* summoner) override
            {
                summonerGUID = summoner->GetGUID();
                challengerGUIDs.clear();

                if (summoner->ToPlayer() && summoner->ToPlayer()->GetQuestStatus(QUEST_THE_HORDE_WAY) == QUEST_STATUS_REWARDED)
                {
                    slainCount = 0;
                    DoAction(ACTION_GIFT_OF_HELLSCREAM);
                    return;
                }
                me->SetWalk(true);
                delay = 0;
                me->SetPhaseMask(2, true);
                // #541: 120753 effect 0 is TARGET_DEST_NEARBY_ENTRY with range 0 and no target conditions (none in LoA), so the summon point is whatever object the nearby search returns. In waves 6 and 7 Garrosh
                // needed ~74 s to reach the first waypoint (11 yd from the throne) and his intro was never heard, while
                // the rest of the walk ran in normal time - and Ji's 45-s "Yes, warchief." (an answer to "Do you
                // understand this, pandaren?", Wowpedia "The Horde Way") came before the walk had even started. Start
                // the walk on the hall floor next to the first waypoint instead of wherever the search put him.
                me->NearTeleportTo(GarroshHordeWayPath[1].GetPositionX(), GarroshHordeWayPath[1].GetPositionY(), GarroshHordeWayPath[1].GetPositionZ(), GarroshHordeWayPath[1].GetOrientation());
                me->SetFacingToObject(summoner);
                // #516: said after spell_summ_garrosh_horde_way's AfterCast has put the player into phase 3.
                me->m_Events.Schedule(1000, [this]() { Talk(SAY_INTRO); });
                me->m_Events.Schedule(3000, [this]() { me->GetMotionMaster()->MovePoint(0, GarroshHordeWayPath[0]); });
            }

            void DoAction(int32 actionId) override
            {
                switch (actionId)
                {
                    case ACTION_GIFT_OF_HELLSCREAM:
                        me->SetPhaseMask(2, true);
                        delay = 0;
                        trialRunning = true;

                        me->m_Events.Schedule(delay += 1000, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_17);
                        });

                        me->m_Events.Schedule(delay += 10000, 2, [this]()
                        {
                            if (Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID))
                                owner->CastSpell(owner, SPELL_RING_OF_VALOR_IN_THE_ARENA, true);

                            Talk(SAY_SPECIAL_18);

                            for (auto&& itr : trialMatchType)
                                if (Creature* challenger = me->SummonCreature(itr.first, TrialSpawnPoints[itr.second], TEMPSUMMON_MANUAL_DESPAWN))
                                    challengerGUIDs.push_back(challenger->GetGUID());
                        });

                        // #510: Ji's yell when the challengers come out (Wowpedia "Hellscream's Gift": "Ji Firepaw yells:
                        // What is that thing?" between "...prepare to fight." and "This is my gift to you"; BroadcastText
                        // 61608 = creature_text 62081 group 3, added by 2026_10_06_63_world_hellscreams_gift_ji_yell.sql).
                        me->m_Events.Schedule(delay + 4000, 2, [this]()
                        {
                            if (Creature* ji = FindOwnerJi())
                                ji->AI()->Talk(SAY_SPECIAL_3);
                        });

                        me->m_Events.Schedule(delay += 11000, 3, [this]()
                        {
                            Talk(SAY_SPECIAL_19);
                        });

                        me->m_Events.Schedule(delay += 7000, 4, [this]()
                        {
                            Talk(SAY_SPECIAL_20);
                        });

                        me->m_Events.Schedule(delay += 11000, 5, [this]()
                        {
                            Talk(SAY_SPECIAL_21);

                            // #510: Ji fights at the player's back (Wowpedia "Hellscream's Gift", fetched 2026-10-05: "Well
                            // fought. I don't think I could have survived that battle without you at my back." = creature_text
                            // 62081 group 2). The challengers open on him, so a level-10 pandaren is not killed by three elites
                            // at once (t445 H4 wave 9: dead 7 s after the release, before the first swing).
                            Creature* ji = FindOwnerJi();
                            for (auto&& itr : challengerGUIDs)
                                if (Creature* challenger = ObjectAccessor::GetCreature(*me, itr))
                                {
                                    if (ji)
                                        challenger->AI()->SetGUID(ji->GetGUID());
                                    challenger->AI()->DoAction(ACTION_INIT_TRIAL);
                                }

                            if (ji)
                                ji->AI()->DoAction(ACTION_INIT_TRIAL);
                        });

                        me->m_Events.Schedule(delay += 4500, 6, [this]()
                        {
                            Talk(SAY_SPECIAL_22);
                        });
                        break;
                    case ACTION_CREAURE_SLAIN:
                        if (++slainCount >= 3)
                        {
                            trialRunning = false;

                            // #510: Ji's "Well fought." (Wowpedia "Hellscream's Gift", said after the monsters are
                            // defeated). It cannot come from Ji's EnterEvadeMode: the last challenger's death ends Ji's
                            // only combat reference (Unit::CombatStop -> CombatManager::EndAllPvECombat), Ji leaves combat,
                            // and CreatureAI::UpdateVictim returns at its !IsInCombat() check (CreatureAI.cpp:472) before
                            // SelectVictim could call EnterEvadeMode - so in wave 12 Ji never spoke (t445 H4 chat=0).
                            if (Creature* ji = FindOwnerJi())
                                ji->AI()->DoAction(ACTION_TRIAL_WON);

                            delay = 0;
                            me->m_Events.Schedule(delay += 6000, 7, [this]()
                            {
                                if (Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID))
                                    owner->CastSpell(owner, SPELL_TELEPORT_OUT_BLACKOUT, true);

                                // #510: the arena Ji (summoned by the owner through AreaTrigger_at_ring_of_valor_entrance,
                                // TEMPSUMMON_MANUAL_DESPAWN) leaves with the trial instead of staying on map 1043 forever.
                                if (Creature* ji = FindOwnerJi())
                                    ji->DespawnOrUnsummon();

                                me->DespawnOrUnsummon();
                            });
                        }
                        break;
                }
            }

            void MovementInform(uint32 type, uint32 pointId) override
            {
                if (type != POINT_MOTION_TYPE)
                    return;

                switch (pointId)
                {
                    case 0:
                        Talk(SAY_SPECIAL_1);
                        me->m_Events.Schedule(delay += 8000, 1, [this]()
                        {
                            if (Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID))
                                me->SetFacingTo(me->GetAngle(owner));

                            Talk(SAY_SPECIAL_2);
                        });

                        me->m_Events.Schedule(delay += 6000, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_3);
                            me->GetMotionMaster()->MovePoint(1, GarroshHordeWayPath[1]);
                        });

                        me->m_Events.Schedule(delay += 3000, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_4);
                            me->GetMotionMaster()->MovePoint(2, GarroshHordeWayPath[2]);
                        });
                        break;
                    case 2:
                        delay = 0;
                        me->m_Events.Schedule(delay += 4500, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_5);
                            me->GetMotionMaster()->MovePoint(3, GarroshHordeWayPath[0]);
                        });
                        break;
                    case 3:
                        me->SetFacingTo(3.59f);
                        Talk(SAY_SPECIAL_6);

                        delay = 0;
                        me->m_Events.Schedule(delay += 9000, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_7);
                        });

                        me->m_Events.Schedule(delay += 6500, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_8);
                        });

                        me->m_Events.Schedule(delay += 4000, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_9);
                            me->GetMotionMaster()->MovePoint(4, GarroshHordeWayPath[3]);
                        });
                        break;
                    case 4:
                        Talk(SAY_SPECIAL_10);

                        delay = 0;
                        me->m_Events.Schedule(delay += 5000, 1, [this]()
                        {
                            if (Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID))
                                me->SetFacingTo(me->GetAngle(owner));

                            Talk(SAY_SPECIAL_11);
                        });

                        me->m_Events.Schedule(delay += 3000, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_12);
                        });

                        me->m_Events.Schedule(delay += 13500, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_13);
                            me->GetMotionMaster()->MovePoint(5, GarroshHordeWayPath[4]);
                        });
                        break;
                    case 5:
                        me->SetFacingTo(Position::NormalizeOrientation(me->GetOrientation() + M_PI));

                        delay = 0;
                        me->m_Events.Schedule(delay += 6500, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_14);
                        });

                        me->m_Events.Schedule(delay += 6500, 1, [this]()
                        {
                            me->SetFacingTo(Position::NormalizeOrientation(me->GetOrientation() + M_PI));
                            Talk(SAY_SPECIAL_15);
                        });

                        me->m_Events.Schedule(delay += 5500, 1, [this]()
                        {
                            Talk(SAY_SPECIAL_16);

                            if (Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID))
                                owner->RemoveAurasDueToSpell(SPELL_SUMMON_JI);

                            me->GetMotionMaster()->MovePoint(6, GarroshHordeWayPath[5]);
                        });
                        break;
                    case 6:
                        me->DespawnOrUnsummon();
                        break;
                }
            }
        };

        CreatureAI* GetAI(Creature* creature) const override
        {
            return new npc_garrosh_horde_way_questAI(creature);
        }
};

// Ji Firepawn Horde Way 62081
class npc_ji_firepaw_horde_way_quest : public CreatureScript
{
    public:
        npc_ji_firepaw_horde_way_quest() : CreatureScript("npc_ji_firepaw_horde_way_quest") { }

        struct npc_ji_firepaw_horde_way_questAI : public ScriptedAI
        {
            npc_ji_firepaw_horde_way_questAI(Creature* creature) : ScriptedAI(creature) { }

            ObjectGuid summonerGUID;
            uint32 delay;
            bool allowFollow;
            bool inTrial = false;           // #510: fighting the Ring of Valor challengers next to the player

            // #510: the nearest released challenger of this player's trial (summoned by the Garrosh this player summoned).
            Creature* SelectChallenger()
            {
                std::list<Creature*> challengers;
                for (uint32 entry : { NPC_GADOON, NPC_FROZENGORE, NPC_OGGAX })
                    me->GetCreatureListWithEntryInGridAppend(challengers, entry, 100.0f);

                Creature* nearest = nullptr;
                for (Creature* challenger : challengers)
                {
                    if (!challenger->IsAlive() || !challenger->IsSummon() || challenger->HasFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PACIFIED))
                        continue;

                    Unit* garrosh = challenger->ToTempSummon()->GetSummoner();
                    if (!garrosh || !garrosh->IsSummon() || garrosh->ToTempSummon()->GetSummonerGUID() != summonerGUID)
                        continue;

                    if (!nearest || me->GetExactDist2d(challenger) < me->GetExactDist2d(nearest))
                        nearest = challenger;
                }
                return nearest;
            }

            void IsSummonedBy(Unit* summoner) override
            {
                summonerGUID = summoner->GetGUID();
                me->SetPhaseMask(2, true);
                allowFollow = true;

                if (summoner->ToPlayer() && summoner->ToPlayer()->GetQuestStatus(QUEST_THE_HORDE_WAY) == QUEST_STATUS_REWARDED)
                {
                    allowFollow = false;
                    DoAction(ACTION_GIFT_OF_HELLSCREAM);
                    return;
                }

                me->DespawnOrUnsummon(1 * MINUTE * IN_MILLISECONDS + 50 * IN_MILLISECONDS);
                delay = 0;
                me->m_Events.Schedule(delay += 45000, 1, [this]()
                {
                    Talk(SAY_INTRO);
                });

                me->m_Events.Schedule(delay += 50000, 1, [this]()
                {
                    Talk(SAY_SPECIAL_1);
                });
            }

            void EnterEvadeMode(EvadeReason why = EVADE_REASON_OTHER) override 
            {
                // #510: a challenger fell and the next one is not on Ji's threat list yet - go on with the trial.
                if (inTrial)
                {
                    if (Creature* challenger = SelectChallenger())
                    {
                        AttackStart(challenger);
                        return;
                    }
                    inTrial = false;
                }

                me->HandleEmoteStateCommand(EMOTE_STATE_NONE);
                Talk(SAY_SPECIAL_2);
                me->DespawnOrUnsummon(6 * IN_MILLISECONDS);
            }

            void DoAction(int32 actionId) override
            {
                if (actionId == ACTION_GIFT_OF_HELLSCREAM)
                {
                    me->SetPhaseMask(2, true);
                    me->HandleEmoteStateCommand(EMOTE_STATE_READY_UNARMED);
                }
                else if (actionId == ACTION_INIT_TRIAL)
                {
                    // #510: faction 35 cannot attack the faction-16 challengers; fight under the player's faction.
                    if (Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID))
                        me->SetFaction(owner->GetFaction());
                    me->SetReactState(REACT_AGGRESSIVE);
                    inTrial = true;
                }
                else if (actionId == ACTION_TRIAL_WON)
                {
                    // #510: the third challenger fell (npc_garrosh_horde_way_quest, ACTION_CREAURE_SLAIN). Garrosh
                    // despawns Ji with the teleport out 6 s later.
                    inTrial = false;
                    me->AttackStop();
                    me->SetReactState(REACT_PASSIVE);
                    me->HandleEmoteStateCommand(EMOTE_STATE_NONE);
                    if (Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID))
                        me->SetFacingToObject(owner);
                    Talk(SAY_SPECIAL_2);
                }
            }

            void UpdateAI(uint32 diff) override
            {
                if (allowFollow)
                {
                    if (Unit* owner = ObjectAccessor::GetUnit(*me, summonerGUID))
                        me->GetMotionMaster()->MoveFollow(owner, 2.5f, me->GetAngle(owner));
                    return;
                }

                if (!inTrial)
                    return;

                if (!UpdateVictim())
                {
                    // The challengers are unpacified 2 s after the release (npc_trial_challengers).
                    if (Creature* challenger = SelectChallenger())
                        AttackStart(challenger);
                    return;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* creature) const override
        {
            return new npc_ji_firepaw_horde_way_questAI(creature);
        }
};

// Trial Challengers 62100, 62097, 62102
struct npc_trial_challengers : public ScriptedAI
{
    npc_trial_challengers(Creature* creature) : ScriptedAI(creature) { }

    ObjectGuid ownerGUID;
    ObjectGuid jiGUID;  // #510: the player's Ji, who takes the challengers' first rush
    uint32 delay;
    float x, y;

    void SetGUID(ObjectGuid guid, int32 /*id*/) override
    {
        jiGUID = guid;
    }

    void IsSummonedBy(Unit* summoner) override
    {
        ownerGUID = summoner->GetGUID();
        x = 0.0f; y = 0.0f;
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PACIFIED | UNIT_FLAG_IMMUNE_TO_PC);
        delay = 0;
    }

    // Idk how it should work? 8.4m HP...
    void DamageTaken(Unit* attacker, uint32& damage) override
    {
        // #510: Ji is level 90; his swings only wear the challengers down (10% each), the pandaren's blows finish them.
        if (attacker && attacker->GetTypeId() == TYPEID_UNIT && attacker->GetEntry() == NPC_JI_FIREPAWN_HORDE_WAY)
        {
            damage = std::min(damage, me->CountPctFromMaxHealth(10));
            return;
        }

        damage *= 10000;
    }

    void DoAction(int32 actionId) override
    {
        if (actionId == ACTION_INIT_TRIAL)
        {
            if (Unit* owner = ObjectAccessor::GetUnit(*me, ownerGUID))
            {
                GetPositionWithDistInOrientation(owner, 25.0f, owner->GetOrientation(), x, y);
                DoCast(me, SPELL_VISUAL_TELEPORT);
                me->NearTeleportTo(x + frand(-10.0f, 10.0f), y, 86.77f, owner->GetOrientation());

                me->m_Events.Schedule(delay += 2000, 1, [this]()
                {
                    me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PACIFIED | UNIT_FLAG_IMMUNE_TO_PC);

                    // #510: open on Ji (see npc_garrosh_horde_way_quest, event 5).
                    if (Creature* ji = ObjectAccessor::GetCreature(*me, jiGUID))
                        if (ji->IsAlive())
                        {
                            me->GetThreatManager().AddThreat(ji, 100.0f);
                            AttackStart(ji);
                        }
                });
            }
        }
    }

    void JustDied(Unit* /*killer*/) override
    {
        if (Creature* owner = ObjectAccessor::GetCreature(*me, ownerGUID))
            owner->AI()->DoAction(ACTION_CREAURE_SLAIN);

    }
};

// Watershed Patrol 25188 (ours, plan EB-3): each objective is earned at the hand-in of that person's (last) quest, by the
// SmartAI REWARD_QUEST rows of Raggaran 39326 (25189, 25192), Misha 3193 (25193) and Zen'Taji 39324 (25195). Those quests
// cannot be done twice, so a patrol abandoned and taken again, or taken by a character who handed one in before the patrol
// could be credited (the dead npc_watershed_patrol hook), could never be finished. Taking the patrol, and logging in with it,
// credits every person already helped. KilledMonsterCredit stops at the objective's count of 1: never twice.
static void CreditWatershedPatrolHelped(Player* player)
{
    if (player->GetQuestStatus(QUEST_WATERSHED_PATROL) != QUEST_STATUS_INCOMPLETE)
        return;

    for (auto const& helped : watershedMatchType)
        if (player->GetQuestRewardStatus(helped.first))
            player->KilledMonsterCredit(helped.second);
}

class quest_durotar_watershed_patrol : public QuestScript
{
public:
    quest_durotar_watershed_patrol() : QuestScript("quest_durotar_watershed_patrol") { }

    void OnQuestStatusChange(Player* player, Quest const* /*quest*/, QuestStatus /*oldStatus*/, QuestStatus newStatus) override
    {
        if (newStatus != QUEST_STATUS_INCOMPLETE)
            return;

        // A moment later, outside the quest code that is adding the quest (its objectives are set, the accept is sent)
        player->m_Events.AddLambdaEventAtOffset([player]()
        {
            if (player->IsInWorld() && !player->GetSession()->PlayerLogout())
                CreditWatershedPatrolHelped(player);
        }, 500);
    }
};

enum GrandmatronTekla
{
    NPC_RAGGARAN                    = 39326,

    SPELL_TEKLA_WATER_WALKING       = 73887,   // self + allies within 25 yd, 10 min
    SPELL_TEKLA_AIR_SPIRITS_BOON    = 73889,   // dummy aura, no duration: the float itself is scripted

    FACTION_TEKLA_ESCORT            = 250,     // friendly to players, hostile to the beasts (14, 48, 413) and quilboar (109)

    SAY_TEKLA_START                 = 0,       // broadcast_text 39456
    SAY_TEKLA_WADING                = 1,       // 39452
    SAY_TEKLA_BETTER                = 2,       // 39453
    SAY_TEKLA_ANKLE                 = 3,       // 39457
    YELL_TEKLA_SPIRITS_OF_AIR       = 4,       // 39458
    SAY_TEKLA_PRESS_ON              = 5,       // 39459
    SAY_TEKLA_SAFE                  = 6,       // 39454
    SAY_RAGGARAN_ALIVE              = 0,       // 39455

    POINT_TEKLA_ROUTE               = 1,       // + route index
    POINT_TEKLA_RISE                = 100,
    POINT_TEKLA_LAND                = 101,
    POINT_TEKLA_HOME_ROUTE          = 200,     // + route index, walking back
    POINT_TEKLA_HUT                 = 300,

    EVENT_TEKLA_SET_OFF             = 1,
    EVENT_TEKLA_CHECK_ESCORT,
    EVENT_TEKLA_WATER_CAST,
    EVENT_TEKLA_WATER_BETTER,
    EVENT_TEKLA_WATER_ON,
    EVENT_TEKLA_AIR_YELL,
    EVENT_TEKLA_RISE,
    EVENT_TEKLA_FLOAT_ON,
    EVENT_TEKLA_RAGGARAN,
    EVENT_TEKLA_DESPAWN,
    EVENT_TEKLA_HOME_TIMEOUT
};

struct TeklaRoutePoint
{
    float X, Y, Z;
};

// Her way from the doorway of the flooded hut (309907 in both TDBs: 562.012 -4103.38 16.8399) to Raggaran, through the one
// sourced point on it (310152 in both TDBs, a sniff of her walking: 392.446 -4081.49 20.5023). Ours: the other points, ~30 yd
// apart on the straight legs between, z from the extracted terrain and liquid (the flood's surface is 17.88); the wading stop
// at the edge of the deep pool (z 13 under 17.9 of water, the second pool after the shallow one at 440 -4087), the ankle stop
// about a quarter of the way from the end (134 yd of 533). The float points are 9 yd over the ground or the rocks and the
// roof below Raggaran's spot (38.9 at 62,-4209.5).
TeklaRoutePoint const TeklaRoute[] =
{
    { 533.75f, -4099.73f, 17.88f },
    { 505.49f, -4096.08f, 20.28f },
    { 477.23f, -4092.43f, 20.77f },
    { 448.97f, -4088.79f, 19.16f },
    { 420.71f, -4085.14f, 19.70f },
    { 392.45f, -4081.49f, 20.43f },     // TDB 310152
    { 365.63f, -4091.89f, 22.88f },
    { 338.82f, -4102.30f, 22.86f },
    { 312.00f, -4112.70f, 20.14f },     // TEKLA_WATER_STOP
    { 284.40f, -4123.40f, 17.88f },
    { 256.80f, -4134.10f, 17.88f },
    { 229.20f, -4144.80f, 21.16f },
    { 201.60f, -4155.50f, 22.52f },
    { 174.00f, -4166.20f, 22.67f },     // TEKLA_ANKLE_STOP
    { 144.25f, -4177.70f, 31.07f },     // floating from here
    { 114.50f, -4189.20f, 29.85f },
    {  84.75f, -4200.70f, 33.24f },
    {  63.50f, -4209.00f, 48.00f },
    {  55.00f, -4212.20f, 44.00f },
};

size_t const TEKLA_WATER_STOP = 8;
size_t const TEKLA_ANKLE_STOP = 13;
size_t const TEKLA_ROUTE_SIZE = sizeof(TeklaRoute) / sizeof(TeklaRoute[0]);
float const TEKLA_FLOAT_HEIGHT = 9.0f;
float const TEKLA_ESCORT_RANGE = 60.0f;

// Beside Raggaran, facing him (mop's two Tekla spawns stood here: the escort's end)
Position const TeklaArrival = { 47.2917f, -4215.24f, 35.0482f, 5.06901f };

// 39325 - Grandmatron Tekla (Spirits Be Praised 25189)
// Sourced (Wowhead 2010-11-24 [+12] with every line, 2011-06-04, 2012-05-05 [+9], 2012-10-04 [+7], 2011-02-08 replies,
// 2010-12-03 [+8], 2013-05-13 [+2]; wiki Notes; Thonk's reward text; the DBC): she waits in the doorway of the flooded hut;
// accepting starts the escort ("Let us be off then..."), she walks to Raggaran faster than most escorts (template speed_walk
// 1.4, applied by Creature::UpdateEntry; the float keeps that pace: flight rate 0.5) and
// fights what comes near; at the second pool she casts Water Walking on herself and the player ("I'm tired of wading..." /
// "There, isn't that much better?"); near the end she hurts her ankle, yells "Spirits of air!", gets Air Spirit's Boon and
// floats about 30 ft up for the rest of the way, no longer drawing anything ("summons an elemental spirit": 73889 carries
// SpellVisual 8206, which the client plays on her while the aura is on; the visual DBCs are not extracted here, so what it
// shows is not checked); at Raggaran "Raggaran, I'm safe." / "Grandmatron...
// you're alive!". Too far ahead and "she simply turns around and goes home" (2011-06-04): the quest fails. One escort at a
// time; if she is gone, "wait three to four minutes and she should show up in the hut" (2010-11-24).
// Ours: the route between the sourced points and the two stops, the 9 yd float and the landing, the 60 yd range, failing on
// her death or when no escorting player is left near her (gone, dead, too far, or the quest abandoned), the completion for
// the escorting player and his group members within 60 yd (dead ones too unless released, as Player::GroupEventHappens;
// searched with the alive check off),
// the timings of the lines, the walk home on a failure (back along her route, neutral again, no quest mark until she is in the
// hut), 6 s at Raggaran and a 30 s respawn after the success (the whole cycle about 3-3.5 min), and the restart: a player who
// holds the quest without an escort (it was taken while she was away) starts one by talking to her at the hut.
// C++ rather than SmartAI or npc_escortAI: npc_escortAI's JustDied never fails the quest (it requires the jumping state), its
// evade drops every aura (Water Walking, the Boon) and walks back to the spawn point; SmartAI's escort cannot float her and
// does not restore the faction. Here an evade keeps her auras and resumes the way from where the fight left her (also checked
// each second: a creature attacked but never engaged leaves combat without an evade); the faction and quest flag are restored
// at the hut (the walk home's end, or the respawn after the success or her death: JustAppeared).
struct npc_durotar_grandmatron_tekla : public ScriptedAI
{
    enum class TeklaState { Idle, Escorting, Stopped, Arrived, Returning, Done };

    npc_durotar_grandmatron_tekla(Creature* creature) : ScriptedAI(creature), _state(TeklaState::Idle), _point(0), _homePoint(-1), _floating(false) { }

    void Reset() override
    {
        if (_state == TeklaState::Idle)
            ResetToHut();
    }

    void JustAppeared() override
    {
        ScriptedAI::JustAppeared();
        _state = TeklaState::Idle;
        ResetToHut();
    }

    void OnQuestAccept(Player* player, Quest const* quest) override
    {
        if (quest->GetQuestId() == QUEST_SPIRIT_BE_PRAISED && _state == TeklaState::Idle)
            Start(player);
    }

    // The quest is in the log but no escort runs (taken while she was on her way with somebody else): talking to her at the hut
    // starts it
    bool OnGossipHello(Player* player) override
    {
        if (_state != TeklaState::Idle || player->GetQuestStatus(QUEST_SPIRIT_BE_PRAISED) != QUEST_STATUS_INCOMPLETE)
            return false;

        CloseGossipMenuFor(player);
        Start(player);
        return true;
    }

    void JustEngagedWith(Unit* who) override
    {
        ScriptedAI::JustEngagedWith(who);
        // The leash (Creature::CanCreatureAttack) is measured from the home position: keep it where the fight is
        if (IsUnderWay())
            me->SetHomePosition(me->GetPosition());
    }

    void EnterEvadeMode(EvadeReason why) override
    {
        if (!IsUnderWay() && _state != TeklaState::Returning)
        {
            ScriptedAI::EnterEvadeMode(why);
            return;
        }

        // Keep Water Walking and the Boon (CreatureAI::_EnterEvadeMode drops every aura) and go on from here
        EngagementOver();
        me->GetThreatManager().RemoveMeFromThreatLists();
        me->GetThreatManager().ClearAllThreat();
        me->CombatStop(true);
        me->SetLootRecipient(nullptr);
        me->ResetPlayerDamageReq();
        if (_state == TeklaState::Escorting)
            MoveOn();
        else if (_state == TeklaState::Returning)
            MoveHome();
        else
        {
            // A fight during a stop: stand there until the stop's timers move her on
            me->GetMotionMaster()->Clear();
            me->StopMoving();
        }
    }

    void JustDied(Unit* /*killer*/) override
    {
        if (IsUnderWay())
            FailEscort(true);
        _events.Reset();
        _state = TeklaState::Done;
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type != POINT_MOTION_TYPE)
            return;

        if (_state == TeklaState::Returning)
        {
            if (pointId == POINT_TEKLA_HUT)
                BackAtHut();
            else if (_homePoint >= 0 && pointId == uint32(POINT_TEKLA_HOME_ROUTE + _homePoint))
            {
                --_homePoint;
                MoveHome();
            }
            return;
        }

        if (!IsUnderWay())
            return;

        if (pointId == POINT_TEKLA_RISE)
        {
            Talk(SAY_TEKLA_PRESS_ON, GetEscorter());
            _events.ScheduleEvent(EVENT_TEKLA_FLOAT_ON, 2500ms);
            return;
        }

        if (pointId == POINT_TEKLA_LAND)
        {
            Arrive();
            return;
        }

        if (pointId != POINT_TEKLA_ROUTE + _point)
            return;

        me->SetHomePosition(me->GetPosition());

        if (_point == TEKLA_WATER_STOP && !me->HasAura(SPELL_TEKLA_WATER_WALKING))
        {
            _state = TeklaState::Stopped;
            Talk(SAY_TEKLA_WADING, GetEscorter());
            _events.ScheduleEvent(EVENT_TEKLA_WATER_CAST, 3s);
            return;
        }

        if (_point == TEKLA_ANKLE_STOP && !_floating)
        {
            _state = TeklaState::Stopped;
            Talk(SAY_TEKLA_ANKLE, GetEscorter());
            _events.ScheduleEvent(EVENT_TEKLA_AIR_YELL, 4s);
            return;
        }

        ++_point;
        MoveOn();
    }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_TEKLA_SET_OFF:
                    _state = TeklaState::Escorting;
                    MoveOn();
                    break;
                case EVENT_TEKLA_CHECK_ESCORT:
                    if (IsUnderWay() && !me->IsInCombat() && !AnyEscortNear())
                    {
                        FailEscort(false);
                        break;
                    }
                    // Out of combat with no victim and not walking: a fight that ended without an evade (attacked, never
                    // engaged: CreatureAI.cpp 506-509, 581-582) left her standing; go on
                    if ((_state == TeklaState::Escorting || _state == TeklaState::Returning) && !me->IsInCombat() && !me->GetVictim()
                        && me->GetMotionMaster()->GetCurrentMovementGeneratorType() != POINT_MOTION_TYPE)
                    {
                        if (_state == TeklaState::Escorting)
                            MoveOn();
                        else
                            MoveHome();
                    }
                    _events.ScheduleEvent(EVENT_TEKLA_CHECK_ESCORT, 1s);
                    break;
                case EVENT_TEKLA_HOME_TIMEOUT:
                    // Could not walk home (stuck): put her there
                    if (_state == TeklaState::Returning)
                    {
                        float x, y, z, o;
                        me->GetRespawnPosition(x, y, z, &o);
                        me->NearTeleportTo(x, y, z, o);
                        BackAtHut();
                    }
                    break;
                case EVENT_TEKLA_WATER_CAST:
                    DoCast(me, SPELL_TEKLA_WATER_WALKING);
                    _events.ScheduleEvent(EVENT_TEKLA_WATER_BETTER, 2500ms);
                    break;
                case EVENT_TEKLA_WATER_BETTER:
                    // The cast was interrupted (she was hit while casting): the water must still be walkable
                    if (!me->HasAura(SPELL_TEKLA_WATER_WALKING))
                        me->CastSpell(me, SPELL_TEKLA_WATER_WALKING, true);
                    Talk(SAY_TEKLA_BETTER, GetEscorter());
                    _events.ScheduleEvent(EVENT_TEKLA_WATER_ON, 2500ms);
                    break;
                case EVENT_TEKLA_WATER_ON:
                    _state = TeklaState::Escorting;
                    ++_point;
                    MoveOn();
                    break;
                case EVENT_TEKLA_AIR_YELL:
                    Talk(YELL_TEKLA_SPIRITS_OF_AIR, GetEscorter());
                    me->CastSpell(me, SPELL_TEKLA_AIR_SPIRITS_BOON, true);
                    // Nothing draws her any more: out of the fight, passive, and no NPC can attack her
                    _floating = true;
                    me->SetReactState(REACT_PASSIVE);
                    me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);
                    me->GetThreatManager().RemoveMeFromThreatLists();
                    me->GetThreatManager().ClearAllThreat();
                    me->CombatStop(true);
                    _events.ScheduleEvent(EVENT_TEKLA_RISE, 1500ms);
                    break;
                case EVENT_TEKLA_RISE:
                    // Gravity off before she leaves the ground: once in the air Creature::UpdateMovementFlags keeps it off
                    // (CanFly through IsFlying), and brings it back when she lands. In the air the spline takes the flight
                    // speed: rate 0.5 = her walking pace (1.4 x 2.5 yd/s)
                    me->SetCanFly(true);
                    me->SetDisableGravity(true);
                    me->SetSpeed(MOVE_FLIGHT, 0.5f);
                    me->GetMotionMaster()->MovePoint(POINT_TEKLA_RISE, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ() + TEKLA_FLOAT_HEIGHT, false);
                    break;
                case EVENT_TEKLA_FLOAT_ON:
                    _state = TeklaState::Escorting;
                    ++_point;
                    MoveOn();
                    break;
                case EVENT_TEKLA_RAGGARAN:
                    if (Creature* raggaran = me->FindNearestCreature(NPC_RAGGARAN, 30.0f))
                    {
                        raggaran->SetFacingToObject(me);
                        raggaran->AI()->Talk(SAY_RAGGARAN_ALIVE, GetEscorter());
                    }
                    break;
                case EVENT_TEKLA_DESPAWN:
                    // Back in the hut 30 s later (ours: with the escort's ~3 min, a player finding the hut empty waits about the
                    // "three to four minutes" of 2010-11-24); ForcedDespawn would add spawntimesecs and the corpse delay
                    _state = TeklaState::Done;
                    me->DespawnOrUnsummon();
                    me->SetRespawnTime(30);
                    return;
                default:
                    break;
            }
        }

        if (!UpdateVictim())
            return;

        DoMeleeAttackIfReady();
    }

private:
    bool IsUnderWay() const { return _state == TeklaState::Escorting || _state == TeklaState::Stopped; }

    // Back along her route, from the last point she reached (the last ground point if she was floating), to her spawn
    void MoveHome()
    {
        if (_state != TeklaState::Returning || me->IsInCombat())
            return;

        // The leash (CanCreatureAttack, from the home position) goes with her, so she can defend herself on the way
        me->SetHomePosition(me->GetPosition());

        if (_homePoint >= 0)
        {
            // Back along the float points first (straight, as she came); from the ankle point on, the ground with pathfinding
            TeklaRoutePoint const& point = TeklaRoute[_homePoint];
            me->GetMotionMaster()->MovePoint(POINT_TEKLA_HOME_ROUTE + _homePoint, point.X, point.Y, point.Z, _homePoint < int32(TEKLA_ANKLE_STOP));
            return;
        }

        float x, y, z, o;
        me->GetRespawnPosition(x, y, z, &o);
        me->GetMotionMaster()->MovePoint(POINT_TEKLA_HUT, x, y, z, true);
    }

    void BackAtHut()
    {
        float x, y, z, o;
        me->GetRespawnPosition(x, y, z, &o);
        me->SetHomePosition(x, y, z, o);
        me->SetFacingTo(o);
        _state = TeklaState::Idle;
        ResetToHut();
    }

    Player* GetEscorter() const { return ObjectAccessor::GetPlayer(*me, _escorterGUID); }

    // The player who started the escort, or a member of his group (his current one while he is here)
    bool IsOfEscort(Player* player)
    {
        if (player->GetGUID() == _escorterGUID)
            return true;

        if (Player* escorter = GetEscorter())
            _groupGUID = escorter->GetGroup() ? escorter->GetGroup()->GetGUID() : ObjectGuid::Empty;

        return !_groupGUID.IsEmpty() && player->GetGroup() && player->GetGroup()->GetGUID() == _groupGUID;
    }

    std::list<Player*> EscortHolders(float range, bool aliveOnly)
    {
        // GetPlayerListInGrid skips dead players (AnyPlayerInObjectRangeCheck's reqAlive): search with the alive check off
        std::list<Player*> players, holders;
        Trinity::AnyPlayerInObjectRangeCheck check(me, range, false);
        Trinity::PlayerListSearcher<Trinity::AnyPlayerInObjectRangeCheck> searcher(me, players, check);
        me->VisitNearbyWorldObject(range, searcher);
        for (Player* player : players)
            if (IsOfEscort(player) && (player->IsAlive() || (!aliveOnly && !player->GetCorpse()))
                && player->GetQuestStatus(QUEST_SPIRIT_BE_PRAISED) == QUEST_STATUS_INCOMPLETE)
                holders.push_back(player);
        return holders;
    }

    bool AnyEscortNear()
    {
        return !EscortHolders(TEKLA_ESCORT_RANGE, true).empty();
    }

    void ResetToHut()
    {
        _events.Reset();
        _escorterGUID.Clear();
        _groupGUID.Clear();
        _point = 0;
        _floating = false;

        me->RestoreFaction();
        me->ReplaceAllNpcFlags(NPCFlags(me->GetCreatureTemplate()->npcflag));
        me->SetReactState(REACT_AGGRESSIVE);
        me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);
        me->RemoveAurasDueToSpell(SPELL_TEKLA_AIR_SPIRITS_BOON);
        me->SetDisableGravity(false);
        me->SetCanFly(false);
        me->SetSpeed(MOVE_FLIGHT, 1.0f);
        me->SetWalk(true);
        me->setActive(false, ActiveFlags::Script);
    }

    void Start(Player* player)
    {
        _state = TeklaState::Stopped;
        _escorterGUID = player->GetGUID();
        _groupGUID = player->GetGroup() ? player->GetGroup()->GetGUID() : ObjectGuid::Empty;
        _point = 0;
        _floating = false;

        // One escort at a time: nobody else can take the quest from her while she is away
        me->ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
        me->SetFaction(FACTION_TEKLA_ESCORT);
        me->SetReactState(REACT_AGGRESSIVE);
        me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);
        me->SetWalk(true);
        me->setActive(true, ActiveFlags::Script);
        me->SetFacingToObject(player);
        Talk(SAY_TEKLA_START, player);

        _events.Reset();
        _events.ScheduleEvent(EVENT_TEKLA_SET_OFF, 3s);
        _events.ScheduleEvent(EVENT_TEKLA_CHECK_ESCORT, 1s);
    }

    void MoveOn()
    {
        if (_state != TeklaState::Escorting || me->IsInCombat())
            return;

        if (_point >= TEKLA_ROUTE_SIZE)
        {
            // Down beside Raggaran
            me->GetMotionMaster()->MovePoint(POINT_TEKLA_LAND, TeklaArrival.GetPositionX(), TeklaArrival.GetPositionY(), TeklaArrival.GetPositionZ(), false);
            return;
        }

        TeklaRoutePoint const& point = TeklaRoute[_point];
        me->GetMotionMaster()->MovePoint(POINT_TEKLA_ROUTE + _point, point.X, point.Y, point.Z, !_floating);
    }

    void Arrive()
    {
        _state = TeklaState::Arrived;
        _events.CancelEvent(EVENT_TEKLA_CHECK_ESCORT);

        me->SetDisableGravity(false);
        me->SetCanFly(false);
        me->SetFacingTo(TeklaArrival.GetOrientation());
        Talk(SAY_TEKLA_SAFE, GetEscorter());

        // The escorting player and his group members within 60 yd who still hold the quest (SpecialFlags 2: the event); a dead
        // one who has not released is credited too, as Player::GroupEventHappens does
        for (Player* player : EscortHolders(TEKLA_ESCORT_RANGE, false))
            player->AreaExploredOrEventHappens(QUEST_SPIRIT_BE_PRAISED);

        _events.ScheduleEvent(EVENT_TEKLA_RAGGARAN, 3s);
        _events.ScheduleEvent(EVENT_TEKLA_DESPAWN, 6s);
    }

    // The quest fails for the escorting player and his group members nearby who hold it. Unless she died, she turns round and
    // walks home along her route ("she simply turns around and goes home", 2011-06-04): neutral again (faction 29: nothing
    // attacks her or is attacked), no quest mark until she is in the hut, where she takes the quest again at once
    void FailEscort(bool died)
    {
        for (Player* player : EscortHolders(200.0f, false))
            player->FailQuest(QUEST_SPIRIT_BE_PRAISED);

        _events.Reset();
        _escorterGUID.Clear();
        _groupGUID.Clear();

        if (died)
        {
            _state = TeklaState::Done;
            return;
        }

        _state = TeklaState::Returning;
        me->RemoveAurasDueToSpell(SPELL_TEKLA_AIR_SPIRITS_BOON);
        me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_NPC);
        me->RestoreFaction();
        me->SetReactState(REACT_DEFENSIVE);
        me->GetThreatManager().ClearAllThreat();
        me->CombatStop(true);
        // From the last point she reached; a failure while floating goes back over the float points she came by (over the roof
        // below Raggaran's spot) down to the ankle point, where Creature::UpdateMovementFlags gives gravity back; a failure in
        // the rise (still at the ankle point) descends straight to the point before it (PathGenerator's flying shortcut)
        _homePoint = _point ? int32(std::min<size_t>(_point - 1, TEKLA_ROUTE_SIZE - 1)) : -1;
        _floating = false;
        me->SetSpeed(MOVE_FLIGHT, 0.5f);
        _events.ScheduleEvent(EVENT_TEKLA_CHECK_ESCORT, 1s);
        _events.ScheduleEvent(EVENT_TEKLA_HOME_TIMEOUT, 300s);
        MoveHome();
    }

    EventMap _events;
    ObjectGuid _escorterGUID;
    ObjectGuid _groupGUID;
    TeklaState _state;
    size_t _point;
    int32 _homePoint;
    bool _floating;
};

const Position questPos[6] =
{
    // Jailor 1
   { -1158.725464f, -5520.14746f, 12.086f, 0.0f },
   { -1153.468384f, -5519.44726f, 11.987f, 0.0f },
   // Jailor 2
   { -1137.682007f, -5428.35058f, 13.705f, 0.0f },
   { -1136.194702f, -5417.04003f, 13.269f, 0.0f },
   // Scout 1
   { -1150.157837f, -5526.10009f, 8.1050f, 0.0f },
   // Scout 2
   { -1142.019531f, -5415.30566f, 10.597f, 0.0f },
};

enum ProvingPit
{
    DATA_START_EVENT = 1,
    DATA_END_EVENT   = 1,

    NPC_JAILOR       = 39062,
    NPC_SCOUT        = 38142,
};

struct npc_darkspear_jailor : public ScriptedAI
{
    npc_darkspear_jailor(Creature* creature) : ScriptedAI(creature) { }

    bool firstJailor = false;

    bool OnGossipSelect(Player* player, uint32 /*sender*/, uint32 /*action*/) override
    {
        player->CLOSE_GOSSIP_MENU();
        player->KilledMonsterCredit(NPC_JAILOR);

        if (!me->FindNearestCreature(NPC_SCOUT, 30.0f)) // not ready yet
            return false;

        firstJailor = false;
        if (me->FindNearestCreature(38243, 30.0f, true))
            firstJailor = true;

        Talk(0, player);
        me->SetWalk(false);
        me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
        me->GetMotionMaster()->MovePoint(1, questPos[firstJailor ? 0 : 2]);
        return true;
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type != POINT_MOTION_TYPE)
            return;

        me->m_Events.Schedule(1000, [this, pointId]()
        {
            switch (pointId)
            {
                case 1:
                    me->GetMotionMaster()->MovePoint(2, questPos[firstJailor ? 1 : 3]);
                    break;
                case 2:
                    me->HandleEmoteCommand(EMOTE_ONESHOT_USE_STANDING);
                    if (Creature* scout = me->FindNearestCreature(NPC_SCOUT, 30.0f))
                        scout->AI()->SetData(DATA_START_EVENT, firstJailor);
                    me->m_Events.Schedule(2000, [this]() { me->GetMotionMaster()->MovePoint(3, questPos[firstJailor ? 0 : 2]); });
                    break;
                case 3:
                    me->GetMotionMaster()->MovePoint(4, me->GetHomePosition());
                    break;
                case 4:
                    me->SetFacingTo(me->GetHomePosition().GetOrientation());
                    break;
            }
        });
    }

    void SetData(uint32 type, uint32 data) override
    {
        me->SetFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
    }
};

struct npc_captive_pitescale_scout : public ScriptedAI
{
    npc_captive_pitescale_scout(Creature* creature) : ScriptedAI(creature) { }

    void JustAppeared() override
    {
        if (GameObject* caje = me->FindNearestGameObject(201968, 30.0f))
            caje->ResetDoorOrButton();
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        if (Creature* jailor = me->FindNearestCreature(NPC_JAILOR, 30.0f))
            jailor->AI()->SetData(DATA_END_EVENT, 0);
    }

    void JustReachedHome() override
    {
        if (GameObject* caje = me->FindNearestGameObject(201968, 30.0f))
            caje->ResetDoorOrButton();
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        if (Creature* jailor = me->FindNearestCreature(NPC_JAILOR, 30.0f))
            jailor->AI()->SetData(DATA_END_EVENT, 0);
    }

    void SetData(uint32 data, uint32 type) override
    {
        if (GameObject* caje = me->FindNearestGameObject(201968, 30.0f))
            caje->UseDoorOrButton();
        me->GetMotionMaster()->MovePoint(1, questPos[type ? 4 : 5]);
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type != POINT_MOTION_TYPE)
            return;

        me->m_Events.Schedule(1000, [this, pointId]()
        {
            switch (pointId)
            {
                case 1:
                    me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
                    Talk(0);
                    if (Player* player = me->FindNearestPlayer(30.0f))
                        AttackStart(player);
                    break;
            }
        });
    }
};

/*######
## Quest 25167: Breaking the Chain
## npc_northwatch_caravan_spawner, npc_northwatch_caravan
######*/

namespace
{

// Sourced: Wowhead 25167 2010-11-23 [+3] "Northwatch Lug's will spawn carrying a crate", 2010-12-12 [+4] "they spawn from two
// places ... go for the crates first (if you're ranged)"; warcraft.wiki.gg Notes "the Northwatch Lugs spawn at regular intervals. If
// left unmolested, they will form a chain of mobs between the spawn point and the encampments in Northwatch Foothold ... coming three
// to a crate"; 2012-08-31 [+1] on 39245 (attacked lugs chase, then stay where they stopped). The data: Spell.dbc 73691 / 73736 / 73737
// Summon Northwatch Caravan A / B / C (39244 / 39318 / 39319, SummonProperties 64 = wild); the caravans are invisible walkers
// (InvisibleStalker 17345) with VehicleId 680 / 684 / 685: seats 7603 7604 7607 (A), 7615 (B), 7617 7621 (C) ride the Walk animation
// with the upper body holding up the load (HoldRifle / ChannelCastOmni), and 7605 / 7616 / 7619 sit 0.47 higher: the crate on top.
// Both TDBs spawn the lugs and crates as static groups (1, 2 or 3 lugs under a crate) along the way: snapshots of the caravans of all
// three kinds; mop's 17 caravan spawns with their short sniffed paths (removed 2026-11-18, 2026_11_27_95) trace the routes:
// B from the northern spawner east and then west to the camp of the Valley of Trials plan, A and C from the two southern spawners
// up the ridge to the camp of the Orgrimmar plan (every one of the 17 caravans and of the TDBs' groups fits that split).
// Ours: the timings (a caravan every 14-18 s from each spawner, at most 11 alive each, routes filled at once when the first player
// comes within 300 yd, nothing new after 60 s without one), the few route points between the sniffed pieces, what happens when a
// caravan is attacked (it stops, the lugs set the crate down and fight; what is left is cleared once nothing of it is in combat for
// 30 s, or 90 s while the crate is still alive), the lugs' places when they put the crate down (the seats' attachment offsets x10, which matches the TDBs'
// snapshots), and despawning at the camp. Not built: the old beta note (2010-10-31) and 2012-03-16 [+1] that a crate falling off
// its seat crushes its carriers (it would cost the player the lugs' credit).
enum BreakingTheChain
{
    NPC_NORTHWATCH_CARAVAN_A            = 39244,
    NPC_NORTHWATCH_CARAVAN_B            = 39318,
    NPC_NORTHWATCH_CARAVAN_C            = 39319,

    DATA_CARAVAN_NEXT_POINT             = 1,
    POINT_CARAVAN_ROUTE                 = 1,        // + route index

    CARAVAN_MAX_SEATS                   = 4,
    CARAVAN_MAX_ALIVE_PER_SPAWNER       = 11,       // ~160 s on the way / ~16 s apart, so the cap only bites when caravans are held up
    CARAVAN_INTERVAL_MIN_MS             = 14 * IN_MILLISECONDS,
    CARAVAN_INTERVAL_MAX_MS             = 18 * IN_MILLISECONDS,
    CARAVAN_SPAWNER_CHECK_MS            = 5 * IN_MILLISECONDS,
    CARAVAN_SPAWNER_IDLE_MS             = 60 * IN_MILLISECONDS,
    CARAVAN_CHECK_MS                    = 250,
    CARAVAN_COLLECT_MS                  = 3 * IN_MILLISECONDS,
    CARAVAN_CLEAR_AFTER_FIGHT_MS        = 30 * IN_MILLISECONDS,     // nothing of it in combat for this long
    CARAVAN_CLEAR_CRATE_LEFT_MS         = 90 * IN_MILLISECONDS,     // the same while the crate is still alive (time to destroy it)
    CARAVAN_CLEAR_LAST_RESORT_MS        = 540 * IN_MILLISECONDS,    // just under the caravan's own 10 min limit
};

float const CARAVAN_PLAYER_RANGE = 300.0f;          // most of the routes (Sen'jin's hub is ~314 yd away and does not wake them)

struct CaravanSeat
{
    int8 SeatId;
    bool IsCrate;
    float Forward, Left;                            // where a lug puts the crate down and stands, from the caravan's centre
};

struct CaravanRoute
{
    uint32 Entry;
    Position Spawner;                               // the Caravan Spawner A (39255) this caravan starts from
    Position const* Points;
    size_t Count;
    float SeedSpacing;                              // yd between caravans when a route is filled at once (interval x walk speed)
    CaravanSeat Seats[CARAVAN_MAX_SEATS];
    size_t SeatCount;
};

// A: three lugs and the crate, from the southern spawner to the Orgrimmar plan's camp (398 yd, walk 2.5 yd/s: ~160 s)
Position const CaravanRouteA[] =
{
    { -1061.00f, -4733.00f, 16.50f },   // mop caravan 252830's sniffed path
    { -1030.65f, -4724.10f, 14.68f },   // TDB group 309485 (2x 39249, 39245, crate)
    { -1021.23f, -4720.60f, 15.19f },   // TDB group 308283 (the same)
    { -1012.67f, -4712.58f, 16.48f },   // 252818 (A)
    { -1006.66f, -4705.92f, 17.64f },
    { -1001.35f, -4698.66f, 19.58f },
    { -995.45f, -4690.59f, 22.50f },
    { -992.30f, -4686.31f, 24.09f },
    { -984.22f, -4679.60f, 26.42f },    // 252814 (C)
    { -982.75f, -4671.74f, 27.65f },
    { -980.36f, -4658.97f, 28.98f },
    { -977.29f, -4642.40f, 29.73f },
    { -978.90f, -4625.00f, 25.46f },    // ours, between two sniffed pieces
    { -980.37f, -4609.93f, 25.59f },    // 252768 (C)
    { -983.36f, -4584.47f, 26.80f },
    { -985.51f, -4566.62f, 25.70f },
    { -996.05f, -4562.85f, 25.94f },    // 252758 (A)
    { -999.38f, -4529.25f, 25.86f },
    { -1009.25f, -4516.66f, 25.44f },   // 252772 / 252791 (A)
    { -1020.68f, -4502.05f, 25.75f },
    { -1019.30f, -4463.00f, 31.35f },   // ours, over the rise
    { -1016.21f, -4423.52f, 26.16f },   // 252743 (A)
    { -1001.40f, -4419.92f, 27.49f },
    { -993.23f, -4419.83f, 29.26f },    // the end of 252743's path, beside the camp
};

// C: two lugs and the crate, from the middle spawner, joining A's way (398 yd, ~160 s)
Position const CaravanRouteC[] =
{
    { -1045.07f, -4722.71f, 16.17f },   // 252826 (C)
    { -1022.15f, -4713.33f, 16.47f },   // TDB group 309473 (2x 39245, crate)
    { -1012.67f, -4712.58f, 16.48f },
    { -1006.66f, -4705.92f, 17.64f },
    { -1001.35f, -4698.66f, 19.58f },
    { -995.45f, -4690.59f, 22.50f },
    { -992.30f, -4686.31f, 24.09f },
    { -984.22f, -4679.60f, 26.42f },
    { -982.75f, -4671.74f, 27.65f },
    { -980.36f, -4658.97f, 28.98f },
    { -977.29f, -4642.40f, 29.73f },
    { -978.90f, -4625.00f, 25.46f },
    { -980.37f, -4609.93f, 25.59f },
    { -983.36f, -4584.47f, 26.80f },
    { -985.51f, -4566.62f, 25.70f },
    { -987.17f, -4536.44f, 25.80f },    // 252754 (C)
    { -1009.25f, -4516.66f, 25.44f },
    { -1020.68f, -4502.05f, 25.75f },
    { -1019.30f, -4463.00f, 31.35f },
    { -1016.21f, -4423.52f, 26.16f },
    { -1001.40f, -4419.92f, 27.49f },
    { -993.23f, -4419.83f, 29.26f },
};

// B: one lug and the crate, from the northern spawner to the Valley of Trials plan's camp (221 yd, walk 1.5 yd/s: ~150 s)
Position const CaravanRouteB[] =
{
    { -1066.67f, -4696.88f, 17.08f },   // 252777 (B)
    { -1060.42f, -4700.00f, 17.49f },
    { -1040.85f, -4700.11f, 17.34f },   // 252823 (B)
    { -1028.92f, -4698.90f, 20.14f },   // 252764 (B)
    { -1017.01f, -4697.66f, 21.59f },
    { -1002.84f, -4684.58f, 25.06f },   // 252809 (B)
    { -997.43f, -4677.05f, 26.82f },
    { -991.83f, -4668.00f, 28.13f },
    { -984.47f, -4652.23f, 30.38f },    // TDB group 308279 (39249, crate)
    { -979.50f, -4637.50f, 25.59f },    // ours, down the slope
    { -993.19f, -4615.53f, 25.73f },    // 252748 (B)
    { -1010.92f, -4603.45f, 25.73f },
    { -1034.08f, -4598.88f, 25.63f },   // 252796 (B)
    { -1057.25f, -4598.04f, 25.82f },   // the end of 252796's path, beside the camp
};

CaravanRoute const CaravanRoutes[] =
{
    { NPC_NORTHWATCH_CARAVAN_A, { -1066.41f, -4733.66f, 16.58f, 0.02f }, CaravanRouteA, std::size(CaravanRouteA), 40.0f,
        { { 0, false, 0.0f, 1.8f }, { 1, false, -1.2f, -1.0f }, { 2, true, 0.0f, 0.0f }, { 3, false, 1.1f, -1.0f } }, 4 },
    { NPC_NORTHWATCH_CARAVAN_B, { -1070.25f, -4698.30f, 16.81f, 6.11f }, CaravanRouteB, std::size(CaravanRouteB), 24.0f,
        { { 0, false, -1.5f, 0.0f }, { 1, true, 0.0f, 0.0f } }, 2 },   // both seats are at 0/0: the lug steps back from the crate (ours)
    { NPC_NORTHWATCH_CARAVAN_C, { -1069.62f, -4716.30f, 16.66f, 0.73f }, CaravanRouteC, std::size(CaravanRouteC), 40.0f,
        { { 0, false, 0.0f, 1.8f }, { 1, false, 0.0f, -1.8f }, { 2, true, 0.0f, 0.0f } }, 3 },
};

static CaravanRoute const* GetCaravanRouteByEntry(uint32 entry)
{
    for (CaravanRoute const& route : CaravanRoutes)
        if (route.Entry == entry)
            return &route;
    return nullptr;
}

// 39244 / 39318 / 39319 - Northwatch Caravan A / B / C: an invisible walker carrying its lugs and crate (vehicle_template_accessory,
// seated by the core when the caravan appears) along its route. A caravan is attacked when any of its lugs or its crate is in combat,
// hurt, dead or off its seat (checked every 250 ms; a lug also pulls a player who comes into its aggro range on the way): it stops,
// the crate is set down (it drops to the ground and can be destroyed there) and the lugs get off and fight the attacker. The caravan
// never walks on empty and nothing re-boards; it clears what is left once nothing of it has been in combat for 30 s (90 s while the
// crate is alive), never in the middle of a fight, and at the end of its route it despawns with its load. Accessories are not minions (a minion accessory is unsummoned as soon as it leaves its
// seat, Unit::_ExitVehicle) and have their own 10 min out-of-combat limit; the caravan has a 10 min limit too (TEMPSUMMON_TIMED_DESPAWN
// from the spawner). Active, so it walks on where no player is near.
struct npc_northwatch_caravan : public ScriptedAI
{
    enum class CaravanState { Starting, Walking, Stopped, Done };

    npc_northwatch_caravan(Creature* creature) : ScriptedAI(creature), _route(GetCaravanRouteByEntry(creature->GetEntry())) { }

    void InitializeAI() override
    {
        ScriptedAI::InitializeAI();
        me->SetReactState(REACT_PASSIVE);
    }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->setActive(true, ActiveFlags::Script);
    }

    void SetData(uint32 type, uint32 value) override
    {
        if (type == DATA_CARAVAN_NEXT_POINT && _state == CaravanState::Starting)
            _nextPoint = value;
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }     // never walk "home" to the spawner

    // Where a lug (or the crate) stands when it gets off: its place around the crate, not the caravan's centre
    void GetPassengerExitPosition(Unit* /*passenger*/, int8 seatId, Position& pos) override
    {
        if (!_route)
            return;

        for (size_t i = 0; i < _route->SeatCount; ++i)
        {
            CaravanSeat const& seat = _route->Seats[i];
            if (seat.SeatId != seatId)
                continue;

            float const o = me->GetOrientation();
            float const x = me->GetPositionX() + seat.Forward * std::cos(o) - seat.Left * std::sin(o);
            float const y = me->GetPositionY() + seat.Forward * std::sin(o) + seat.Left * std::cos(o);
            float z = me->GetPositionZ();
            me->UpdateAllowedPositionZ(x, y, z);
            pos.Relocate(x, y, z, o);
            return;
        }
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type != POINT_MOTION_TYPE || _state != CaravanState::Walking || !_route || pointId != POINT_CARAVAN_ROUTE + _nextPoint)
            return;

        ++_nextPoint;
        if (_nextPoint < _route->Count)
            MoveToNextPoint();
        else
            _arrived = true;                    // despawned from UpdateAI, not from inside the movement generator
    }

    void UpdateAI(uint32 diff) override
    {
        if (_state == CaravanState::Done)
            return;

        if (!_route)
        {
            _state = CaravanState::Done;
            me->DespawnOrUnsummon();
            return;
        }

        if (_state == CaravanState::Starting)
        {
            _state = CaravanState::Walking;
            me->SetWalk(true);
            if (_nextPoint >= _route->Count)
                _arrived = true;
            else
                MoveToNextPoint();
        }

        if (_checkTimer > diff)
        {
            _checkTimer -= diff;
            return;
        }
        uint32 const elapsed = CARAVAN_CHECK_MS - _checkTimer + diff;
        _checkTimer = CARAVAN_CHECK_MS;

        if (_state == CaravanState::Walking)
        {
            if (_collectMs < CARAVAN_COLLECT_MS)
            {
                _collectMs += elapsed;
                CollectLoad();
                if (_collectMs >= CARAVAN_COLLECT_MS && !HasAnyLoad())
                {
                    TC_LOG_ERROR("scripts", "npc_northwatch_caravan: caravan %u (entry %u) got no lugs or crate from vehicle_template_accessory; "
                        "despawned", me->GetGUID().GetCounter(), me->GetEntry());
                    Finish();
                    return;
                }
            }

            if (_arrived)
            {
                Finish();
                return;
            }

            if (Unit* attacker = nullptr; IsAttacked(attacker))
                Stop(attacker);
            return;
        }

        // Stopped: clear up once the fight is over
        _stoppedMs += elapsed;
        bool anyAlive = false;
        bool anyInCombat = false;
        bool crateAlive = false;
        for (size_t i = 0; i < _route->SeatCount; ++i)
        {
            Creature* member = _load[i].IsEmpty() ? nullptr : ObjectAccessor::GetCreature(*me, _load[i]);
            if (!member || !member->IsAlive())
                continue;
            anyAlive = true;
            if (_route->Seats[i].IsCrate)
                crateAlive = true;
            if (member->IsInCombat())
                anyInCombat = true;
        }

        if (anyInCombat)
            _quietMs = 0;
        else
            _quietMs += elapsed;

        // Never in the middle of a fight; an untouched crate is left long enough to be destroyed. The last resort is for a crate
        // that stays in combat with a player who walked off (NullCreatureAI never evades).
        uint32 const quietNeeded = crateAlive ? CARAVAN_CLEAR_CRATE_LEFT_MS : CARAVAN_CLEAR_AFTER_FIGHT_MS;
        if (!anyAlive || _quietMs >= quietNeeded || _stoppedMs >= CARAVAN_CLEAR_LAST_RESORT_MS)
            Finish();
    }

private:
    void MoveToNextPoint()
    {
        Position const& point = _route->Points[_nextPoint];
        me->GetMotionMaster()->MovePoint(POINT_CARAVAN_ROUTE + _nextPoint, point.GetPositionX(), point.GetPositionY(), point.GetPositionZ());
    }

    Vehicle* Kit() const { return me->GetVehicleKit(); }

    // The core seats the accessories when the caravan appears (Vehicle::Reset from AIM_Initialize and again on the first update);
    // remember who sits where
    void CollectLoad()
    {
        Vehicle* kit = Kit();
        if (!kit)
            return;

        for (size_t i = 0; i < _route->SeatCount; ++i)
            if (_load[i].IsEmpty())
                if (Unit* passenger = kit->GetPassenger(_route->Seats[i].SeatId))
                    _load[i] = passenger->GetGUID();
    }

    bool HasAnyLoad() const
    {
        for (size_t i = 0; i < _route->SeatCount; ++i)
            if (!_load[i].IsEmpty())
                return true;
        return false;
    }

    bool IsAttacked(Unit*& attacker)
    {
        bool attacked = false;
        for (size_t i = 0; i < _route->SeatCount; ++i)
        {
            if (_load[i].IsEmpty())
                continue;

            Creature* member = ObjectAccessor::GetCreature(*me, _load[i]);
            if (!member || !member->IsAlive() || member->GetVehicleBase() != me || member->IsInCombat()
                || member->GetHealth() < member->GetMaxHealth())
                attacked = true;

            if (!attacker && member)
                attacker = FindAttacker(member);
        }
        return attacked;
    }

    Unit* FindAttacker(Creature* member) const
    {
        if (member->IsAlive())
        {
            if (Unit* victim = member->GetVictim())
                return victim;
            if (Unit* target = member->GetCombatManager().GetAnyTarget())
                return target;
        }
        return member->GetLootRecipient();      // who hit it first (also kept on a corpse)
    }

    void Stop(Unit* attacker)
    {
        _state = CaravanState::Stopped;
        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveIdle();
        me->StopMoving();

        Vehicle* kit = Kit();
        for (size_t i = 0; i < _route->SeatCount; ++i)
        {
            Creature* member = _load[i].IsEmpty() ? nullptr : ObjectAccessor::GetCreature(*me, _load[i]);
            if (!member || !member->IsAlive() || !kit || member->GetVehicle() != kit)
                continue;

            member->ExitVehicle();              // the crate drops to the ground (Unit::_ExitVehicle starts the fall)
            if (_route->Seats[i].IsCrate)
                continue;

            // An evading lug walks back to where it put the crate down, not to the spawner it was summoned at
            member->SetHomePosition(member->GetPosition());
            if (!member->IsInCombat() && attacker && attacker->IsInWorld() && attacker->IsAlive() && member->IsAIEnabled
                && member->IsValidAttackTarget(attacker))
                member->AI()->AttackStart(attacker);
        }

        // Nothing should ride an emptied caravan (it is unselectable; RemovePassenger gives it the spellclick flag back)
        me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);
    }

    // Despawn whatever of the load is alive (corpses decay by their own summon type), then the caravan
    void Finish()
    {
        _state = CaravanState::Done;
        for (ObjectGuid const& guid : _load)
            if (Creature* member = guid.IsEmpty() ? nullptr : ObjectAccessor::GetCreature(*me, guid))
                if (member->IsAlive())
                    member->DespawnOrUnsummon();
        me->DespawnOrUnsummon();
    }

    CaravanRoute const* _route;
    CaravanState _state = CaravanState::Starting;
    size_t _nextPoint = 0;
    bool _arrived = false;
    uint32 _checkTimer = CARAVAN_CHECK_MS;
    uint32 _collectMs = 0;
    uint32 _stoppedMs = 0;
    uint32 _quietMs = 0;
    ObjectGuid _load[CARAVAN_MAX_SEATS];
};

// 39255 - Northwatch Caravan Spawner A (three spawns on the shore; mop's and both TDBs' positions): each sends out its own caravan
// kind (the caravans and TDB groups standing on each spot: B at the northern one, C in the middle, A at the southern one). While a
// player (bots included) is within 300 yd it sends one every 14-18 s, at most 11 alive; when it wakes with none out it fills its route
// at once, spaced as if it had been running, so a player arriving finds the chain. Active, because the route's far end is beyond the
// range at which the map updates it for a player there.
struct npc_northwatch_caravan_spawner : public ScriptedAI
{
    npc_northwatch_caravan_spawner(Creature* creature) : ScriptedAI(creature) { }

    void InitializeAI() override
    {
        ScriptedAI::InitializeAI();
        me->SetReactState(REACT_PASSIVE);
    }

    void JustAppeared() override
    {
        ScriptedAI::JustAppeared();
        _route = nullptr;
        for (CaravanRoute const& route : CaravanRoutes)
            if (me->GetHomePosition().GetExactDist2d(&route.Spawner) < 5.0f)
                _route = &route;

        if (!_route)
        {
            TC_LOG_ERROR("scripts", "npc_northwatch_caravan_spawner: spawner %u at (%.1f, %.1f) is not one of the three Breaking the Chain spawners",
                me->GetGUID().GetCounter(), me->GetHomePosition().GetPositionX(), me->GetHomePosition().GetPositionY());
            return;
        }

        me->setActive(true, ActiveFlags::Script);
        _awake = false;
        _idleMs = 0;
        _checkTimer = 0;
        _spawnTimer = urand(CARAVAN_INTERVAL_MIN_MS, CARAVAN_INTERVAL_MAX_MS);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void UpdateAI(uint32 diff) override
    {
        if (!_route)
            return;

        if (_checkTimer <= diff)
        {
            _checkTimer = CARAVAN_SPAWNER_CHECK_MS;
            PruneCaravans();

            if (IsPlayerNear())
            {
                _idleMs = 0;
                if (!_awake)
                {
                    _awake = true;
                    if (_caravans.empty())
                        FillRoute();
                    _spawnTimer = urand(CARAVAN_INTERVAL_MIN_MS, CARAVAN_INTERVAL_MAX_MS);
                }
            }
            else if (_awake)
            {
                _idleMs += CARAVAN_SPAWNER_CHECK_MS;
                if (_idleMs >= CARAVAN_SPAWNER_IDLE_MS)
                    _awake = false;             // what is out walks on to the camp and despawns there
            }
        }
        else
            _checkTimer -= diff;

        if (!_awake)
            return;

        if (_spawnTimer > diff)
        {
            _spawnTimer -= diff;
            return;
        }

        _spawnTimer = urand(CARAVAN_INTERVAL_MIN_MS, CARAVAN_INTERVAL_MAX_MS);
        PruneCaravans();
        if (_caravans.size() < CARAVAN_MAX_ALIVE_PER_SPAWNER)
            SendCaravan(me->GetHomePosition(), 0);
    }

private:
    bool IsPlayerNear() const
    {
        Map::PlayerList const& players = me->GetMap()->GetPlayers();
        for (Map::PlayerList::const_iterator itr = players.begin(); itr != players.end(); ++itr)
            if (Player* player = itr->GetSource())
                if (player->IsInWorld() && player->GetDistance2d(me) < CARAVAN_PLAYER_RANGE)
                    return true;
        return false;
    }

    void PruneCaravans()
    {
        _caravans.erase(std::remove_if(_caravans.begin(), _caravans.end(), [this](ObjectGuid const& guid)
        {
            Creature* caravan = ObjectAccessor::GetCreature(*me, guid);
            return !caravan || !caravan->IsInWorld();
        }), _caravans.end());
    }

    void SendCaravan(Position const& pos, size_t nextPoint)
    {
        if (TempSummon* caravan = me->SummonCreature(_route->Entry, pos, TEMPSUMMON_TIMED_DESPAWN, 10min))
        {
            if (caravan->IsAIEnabled)
                caravan->AI()->SetData(DATA_CARAVAN_NEXT_POINT, uint32(nextPoint));
            _caravans.push_back(caravan->GetGUID());
        }
    }

    // Caravans along the route every SeedSpacing yd, each walking on from the route point it stands at
    void FillRoute()
    {
        float walked = 0.0f;
        float nextAt = _route->SeedSpacing;
        Position prev = me->GetHomePosition();
        for (size_t i = 0; i + 1 < _route->Count && _caravans.size() + 1 < CARAVAN_MAX_ALIVE_PER_SPAWNER; ++i)
        {
            Position const& point = _route->Points[i];
            walked += prev.GetExactDist2d(&point);
            prev = point;
            if (walked < nextAt)
                continue;

            nextAt = walked + _route->SeedSpacing;
            Position const& next = _route->Points[i + 1];
            Position pos(point.GetPositionX(), point.GetPositionY(), point.GetPositionZ(), point.GetAngle(&next));
            SendCaravan(pos, i + 1);
        }
    }

    CaravanRoute const* _route = nullptr;
    std::vector<ObjectGuid> _caravans;
    bool _awake = false;
    uint32 _idleMs = 0;
    uint32 _checkTimer = 0;
    uint32 _spawnTimer = 0;
};

} // namespace

enum VoodooSpells
{
    SPELL_BREW      = 16712, // Special Brew
    SPELL_GHOSTLY   = 16713, // Ghostly
    SPELL_HEX1      = 16707, // Hex
    SPELL_HEX2      = 16708, // Hex
    SPELL_HEX3      = 16709, // Hex
    SPELL_GROW      = 16711, // Grow
    SPELL_LAUNCH    = 16716, // Launch (Whee!)
};

// 17009
class spell_voodoo : public SpellScriptLoader
{
    public:
        spell_voodoo() : SpellScriptLoader("spell_voodoo") { }

        class spell_voodoo_SpellScript : public SpellScript
        {
            PrepareSpellScript(spell_voodoo_SpellScript);

            bool Validate(SpellInfo const* /*spellInfo*/) override
            {
                if (!sSpellMgr->GetSpellInfo(SPELL_BREW) || !sSpellMgr->GetSpellInfo(SPELL_GHOSTLY) ||
                    !sSpellMgr->GetSpellInfo(SPELL_HEX1) || !sSpellMgr->GetSpellInfo(SPELL_HEX2) ||
                    !sSpellMgr->GetSpellInfo(SPELL_HEX3) || !sSpellMgr->GetSpellInfo(SPELL_GROW) ||
                    !sSpellMgr->GetSpellInfo(SPELL_LAUNCH))
                    return false;
                return true;
            }

            void HandleDummy(SpellEffIndex /*effIndex*/)
            {
                uint32 spellid = RAND(SPELL_BREW, SPELL_GHOSTLY, RAND(SPELL_HEX1, SPELL_HEX2, SPELL_HEX3), SPELL_GROW, SPELL_LAUNCH);
                if (Unit* target = GetHitUnit())
                    GetCaster()->CastSpell(target, spellid, false);
            }

            void Register() override
            {
                OnEffectHitTarget += SpellEffectFn(spell_voodoo_SpellScript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
            }
        };

        SpellScript* GetSpellScript() const override
        {
            return new spell_voodoo_SpellScript();
        }
};

// Summon Garrosh horde way 120753
class spell_summ_garrosh_horde_way : public SpellScript
{
    PrepareSpellScript(spell_summ_garrosh_horde_way);

    void HandleAfterCast()
    {
        if (Player* pCaster = GetCaster()->ToPlayer())
        {
            // #516: 120753 effect 1 (SPELL_EFFECT_FORCE_PLAYER_INTERACTION, trigger 120749) already makes the player
            // cast Summon Ji; casting it again here summoned a second Ji (every Ji line was said twice).
            pCaster->SetPhaseMask(3, true);
        }
    }

    void Register() override
    {
        AfterCast += SpellCastFn(spell_summ_garrosh_horde_way::HandleAfterCast);
    }
};

// Summon Ji horde way 120749
class spell_summ_ji_horde_way : public AuraScript
{
    PrepareAuraScript(spell_summ_ji_horde_way);

    void Remove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (Player* pCaster = GetCaster()->ToPlayer())
        {
            pCaster->KilledMonsterCredit(NPC_GARROSH_HORDE_WAY_CREDIT);
            
            uint32 delay = 0;
            pCaster->m_Events.Schedule(delay += 3500, 1, [pCaster]()
            {
                pCaster->SetPhaseMask(1, true);
            });
        }
    }

    void Register() override
    {
        OnEffectRemove += AuraEffectRemoveFn(spell_summ_ji_horde_way::Remove, EFFECT_1, SPELL_AURA_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

// Place Territorial Fetish 72070
class spell_place_territorial_fetish : public SpellScript
{
    PrepareSpellScript(spell_place_territorial_fetish);

    SpellCastResult CheckCondition()
    {
        if (Player* player = GetCaster()->ToPlayer())
        {
            if (Creature* creature = player->FindNearestCreature(38560, 50.0f))
            {
                if (creature->HasAura(72072))
                    return SPELL_FAILED_BAD_TARGETS;
            }
            else
                return SPELL_FAILED_BAD_TARGETS;
        }

        return SPELL_CAST_OK;
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_place_territorial_fetish::CheckCondition);
    }
};

enum ThonksSpyglassSpells
{
    SPELL_TELESCOPE_1        = 73741,
    SPELL_TELESCOPE_2        = 73763,
    SPELL_TELESCOPE_3        = 73764,
    SPELL_TELESCOPE_4        = 73765,

    OBJECTIVE_RAGGARAN       = 256157,
    OBJECTIVE_FLOODED_HUT    = 256158,
    OBJECTIVE_MISHA          = 256159,
    OBJECTIVE_ZEN_TAJI       = 256160,
};

// Thonk's Spyglass 73817
// Each use shows the next survivor not yet found (73741 / 73763 / 73764 / 73765 summon that view's telescope camera, which
// seats the player). Nothing while the player is already on a vehicle: a second view must never start from inside the first
class spell_thonks_spyglass : public SpellScript
{
    PrepareSpellScript(spell_thonks_spyglass);

    void HandleAfterCast()
    {
        if (Player* player = GetCaster()->ToPlayer())
        {
            if (player->GetVehicle())
                return;

            if (player->GetQuestStatus(QUEST_LOST_IN_THE_FLOODS) == QUEST_STATUS_INCOMPLETE && !player->GetQuestObjectiveCounter(OBJECTIVE_RAGGARAN))
            {
                player->CastSpell(player, SPELL_TELESCOPE_1);
                return;
            }
            else if (player->GetQuestStatus(QUEST_LOST_IN_THE_FLOODS) == QUEST_STATUS_INCOMPLETE && !player->GetQuestObjectiveCounter(OBJECTIVE_FLOODED_HUT))
            {
                player->CastSpell(player, SPELL_TELESCOPE_2);
                return;
            }
            else if (player->GetQuestStatus(QUEST_LOST_IN_THE_FLOODS) == QUEST_STATUS_INCOMPLETE && !player->GetQuestObjectiveCounter(OBJECTIVE_MISHA))
            {
                player->CastSpell(player, SPELL_TELESCOPE_3);
                return;
            }
            else if (player->GetQuestStatus(QUEST_LOST_IN_THE_FLOODS) == QUEST_STATUS_INCOMPLETE && !player->GetQuestObjectiveCounter(OBJECTIVE_ZEN_TAJI))
            {
                player->CastSpell(player, SPELL_TELESCOPE_4);
                return;
            }
        }
    }

    void Register() override
    {
        AfterCast += SpellCastFn(spell_thonks_spyglass::HandleAfterCast);
    }
};

enum WatershedTelescope
{
    POINT_TELESCOPE_VIEW        = 1,

    EVENT_TELESCOPE_BOARDED     = 1,
    EVENT_TELESCOPE_VIEW_END,
    EVENT_TELESCOPE_EXPIRE
};

struct WatershedTelescopeView
{
    uint32 Entry;
    uint32 Credit;          // the objective's kill credit (Durotar Telescope Quest KC 1-4)
    Position End;           // where the camera stops and holds
    Position Subject;       // what the view looks at
};

// The end points are the last points of the four telescope paths mop had (`waypoints` 39320, 39345, 39346, 39347; Misha's
// raised 2.4 yd: its approach skimmed 2.2 yd over the slope before her farm), the subjects the spawns they frame: Raggaran 253002, Tekla at the flooded hut (309907 in both TDBs), Misha 251212, Zen'Taji 251574
WatershedTelescopeView const WatershedTelescopeViews[] =
{
    { 39320, 39357, {  60.7847f, -4232.33f, 38.4023f }, {  49.1719f, -4220.28f, 35.3841f } },
    { 39345, 39358, { 555.582f,  -4146.90f, 28.3467f }, { 562.012f,  -4103.38f, 16.8399f } },
    { 39346, 39359, { 721.934f,  -4260.48f, 25.5000f }, { 728.602f,  -4256.38f, 20.0780f } },
    { 39347, 39360, { 349.146f,  -3869.01f, 25.0690f }, { 349.856f,  -3857.87f, 21.1875f } },
};

// Beside Thonk on the tower top, facing him (the point the old SmartAI teleported to: 393.527 -4581.75 76.592)
Position const WatershedTelescopeReturn = { 393.527f, -4581.75f, 76.592f, 4.29f };

// Players let out of a camera and not yet set down on the tower (the 300 ms between the exit and the teleport): a logout then,
// like a logout in the seat, would save them in the air (player_durotar_watershed::OnLogout)
std::mutex WatershedTelescopePendingLock;
std::set<ObjectGuid> WatershedTelescopePending;

bool IsWatershedTelescope(uint32 entry)
{
    for (WatershedTelescopeView const& view : WatershedTelescopeViews)
        if (view.Entry == entry)
            return true;
    return false;
}

// 39320, 39345, 39346, 39347 - Durotar Watershed Telescope 01-04 (Lost in the Floods 25187)
// Sourced: each use of the spyglass on the tower top plays a short camera view, letterboxed, without the character, of one
// survivor; nothing is said; credit only for a view watched to the end ("It wont count if you skip the cinematic!", Wowhead
// 2010-11-06 [+91]; wiki Notes); summon spell, vehicle 686 and seat 7622 (hidden passenger, no control, can leave) from the
// DBC; after the view the player is back on the tower ("sit tight ... while still up by Thonk", 2011-11-12).
// Ours (no source has the flight): one smooth curve from the summon spot straight towards the survivor, a few yards up at
// first and down to the old paths' end points (no backward first leg: the generated paths backed away 37 yd first), at the
// template's speed (rate 6, about 42 yd/s: 11 s to Raggaran, the hut and Misha, 17 s to Zen'Taji), then a 10 s hold facing
// the survivor (the old SmartAI's hold), then back on the tower beside Thonk, facing him.
// Every way out ends once: the end of the view credits (only then, and only while seated) and sets the player down on the
// tower; leaving early, death, the camera unsummoned by anything else, or the 60 s safety end set the player down on the
// tower without credit; a logout (or a shutdown) in the seat or before the set-down is saved on the tower. Getting off and the teleport are never in the same tick (a
// teleport in the exit's tick left the client stuck in the camera view in Hillsbrad: scripted-quest-scenes, "Ending"): the
// seated player is let out and held in the air with gravity off, the teleport follows 300 ms later, gravity comes back after
// it. The camera is the summoner's own (the summon effect seats its caster): a second player on the tower gets a camera of
// his own and is never carried or credited by this one.
struct npc_durotar_watershed_telescope : public ScriptedAI
{
    npc_durotar_watershed_telescope(Creature* creature) : ScriptedAI(creature), _view(nullptr), _boardTries(0), _started(false), _done(false) { }

    void IsSummonedBy(Unit* summoner) override
    {
        for (WatershedTelescopeView const& view : WatershedTelescopeViews)
            if (view.Entry == me->GetEntry())
                _view = &view;

        Player* player = summoner->ToPlayer();
        if (!player || !_view)
        {
            _done = true;
            me->DespawnOrUnsummon();
            return;
        }

        _playerGUID = player->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC | UNIT_FLAG_NOT_SELECTABLE);
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        me->SetSpeed(MOVE_RUN, 6.0f);
        me->SetSpeed(MOVE_FLIGHT, 6.0f);
        me->setActive(true, ActiveFlags::Script);

        _events.ScheduleEvent(EVENT_TELESCOPE_BOARDED, 250ms);
        _events.ScheduleEvent(EVENT_TELESCOPE_EXPIRE, 60s);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        if (apply || _done || passenger->GetGUID() != _playerGUID)
            return;

        Player* player = passenger->ToPlayer();
        if (!player)
            return;

        // Logging out: the saved position was already put on the tower (player_durotar_watershed::OnLogout)
        if (player->GetSession()->PlayerLogout())
        {
            _done = true;
            _events.Reset();
            return;
        }

        // Left the seat early (the leave button), died, or was taken off by anything else: no credit
        Finish(player, false);
    }

    // Unsummoned by something other than Finish while the player may still be seated (the owner's logout or death can unsummon
    // his minions before the seat is emptied)
    void Unsummoned() override
    {
        if (_done)
            return;

        if (Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID))
            if (!player->GetSession()->PlayerLogout())
            {
                Finish(player, false);
                return;
            }

        _done = true;
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (_done || pointId != POINT_TELESCOPE_VIEW || (type != EFFECT_MOTION_TYPE && type != POINT_MOTION_TYPE))
            return;

        me->SetFacingTo(me->GetAngle(_view->Subject.GetPositionX(), _view->Subject.GetPositionY()));
        _events.ScheduleEvent(EVENT_TELESCOPE_VIEW_END, 10s);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_done)
            return;

        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player || !player->IsInWorld())
        {
            _done = true;
            me->DespawnOrUnsummon();
            return;
        }

        if (_started && player->GetVehicleBase() != me)
        {
            Finish(player, false);
            return;
        }

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_TELESCOPE_BOARDED:
                    if (player->GetVehicleBase() == me)
                    {
                        _started = true;
                        FlyToView();
                    }
                    else if (++_boardTries < 8)
                        _events.ScheduleEvent(EVENT_TELESCOPE_BOARDED, 250ms);
                    else
                    {
                        // Never seated (the ride failed): the player never left the tower; nothing to undo
                        _done = true;
                        me->DespawnOrUnsummon();
                        return;
                    }
                    break;
                case EVENT_TELESCOPE_VIEW_END:
                    Finish(player, true);
                    return;
                case EVENT_TELESCOPE_EXPIRE:
                    Finish(player, false);
                    return;
                default:
                    break;
            }
        }
    }

private:
    // One curve from the summon spot towards the survivor: lifted a little over the first third, down to 6 yd above the end
    // point near the end, sampled as evenly spaced points so the speed does not jump (scripted-quest-scenes, FlyCurve)
    void FlyToView()
    {
        Position const here = me->GetPosition();
        Position const& end = _view->End;
        float const dx = end.GetPositionX() - here.GetPositionX();
        float const dy = end.GetPositionY() - here.GetPositionY();

        std::vector<Position> controls(3, here);
        controls.emplace_back(here.GetPositionX() + dx * 0.30f, here.GetPositionY() + dy * 0.30f, here.GetPositionZ() + 4.0f);
        controls.emplace_back(here.GetPositionX() + dx * 0.85f, here.GetPositionY() + dy * 0.85f, end.GetPositionZ() + 6.0f);
        controls.push_back(end);
        controls.push_back(end);
        controls.push_back(end);

        uint32 const subSteps = 16;
        std::vector<Position> dense(1, here);
        for (size_t i = 0; i + 3 < controls.size(); ++i)
        {
            Position const& c0 = controls[i];
            Position const& c1 = controls[i + 1];
            Position const& c2 = controls[i + 2];
            Position const& c3 = controls[i + 3];
            for (uint32 k = 1; k <= subSteps; ++k)
            {
                float t = float(k) / subSteps;
                float b0 = (1.0f - t) * (1.0f - t) * (1.0f - t) / 6.0f;
                float b1 = (3.0f * t * t * t - 6.0f * t * t + 4.0f) / 6.0f;
                float b2 = (-3.0f * t * t * t + 3.0f * t * t + 3.0f * t + 1.0f) / 6.0f;
                float b3 = t * t * t / 6.0f;
                dense.emplace_back(
                    b0 * c0.GetPositionX() + b1 * c1.GetPositionX() + b2 * c2.GetPositionX() + b3 * c3.GetPositionX(),
                    b0 * c0.GetPositionY() + b1 * c1.GetPositionY() + b2 * c2.GetPositionY() + b3 * c3.GetPositionY(),
                    b0 * c0.GetPositionZ() + b1 * c1.GetPositionZ() + b2 * c2.GetPositionZ() + b3 * c3.GetPositionZ());
            }
        }

        float length = 0.0f;
        for (size_t i = 0; i + 1 < dense.size(); ++i)
            length += dense[i].GetExactDist(dense[i + 1]);

        float const step = 6.0f;
        size_t const count = std::max<size_t>(1, size_t(std::lround(length / step)));
        float const spacing = length / count;

        std::vector<Position> path(1, here);
        float walked = 0.0f;
        float next = spacing;
        for (size_t i = 0; i + 1 < dense.size(); ++i)
        {
            Position const& a = dense[i];
            Position const& b = dense[i + 1];
            float segment = a.GetExactDist(b);
            while (segment > 0.0f && walked + segment >= next && path.size() < count)
            {
                float f = (next - walked) / segment;
                path.emplace_back(a.GetPositionX() + (b.GetPositionX() - a.GetPositionX()) * f,
                    a.GetPositionY() + (b.GetPositionY() - a.GetPositionY()) * f,
                    a.GetPositionZ() + (b.GetPositionZ() - a.GetPositionZ()) * f);
                next += spacing;
            }
            walked += segment;
        }
        path.push_back(end);

        me->GetMotionMaster()->Clear();
        me->GetMotionMaster()->MoveSmoothPath(POINT_TELESCOPE_VIEW, path.data(), path.size(), false, true);
    }

    // Credit (only at the end of the view, only while seated), let the player out, set him down on the tower
    void Finish(Player* player, bool credit)
    {
        if (_done)
            return;

        _done = true;
        _events.Reset();

        bool const seated = player->GetVehicleBase() == me;
        if (credit && seated)
            player->KilledMonsterCredit(_view->Credit);

        // Held where the camera lets go (gravity off; not rooted: a root or a teleport in the exit's own tick cuts the exit
        // off and leaves the view stuck). A player who got out himself is already falling: not held, the teleport catches him
        if (seated)
        {
            player->ExitVehicle();
            player->SetDisableGravity(true);
        }

        // Where the camera let him go: the set-down only moves a player still there (held, or falling after the leave button);
        // one teleported or summoned out of the seat (Player::TeleportTo exits the vehicle first) is left where he went
        if (_started)
            SetDownOnTower(player, seated, player->GetPosition());

        me->DespawnOrUnsummon(500);
    }

    // Runs from the player's own event queue, so it outlives the camera; a dead player is moved too (the corpse then lies on
    // the tower, not in the flood)
    static void SetDownOnTower(Player* player, bool held, Position released)
    {
        {
            std::lock_guard<std::mutex> lock(WatershedTelescopePendingLock);
            WatershedTelescopePending.insert(player->GetGUID());
        }

        uint32 const mapId = player->GetMapId();
        player->m_Events.AddLambdaEventAtOffset([player, held, released, mapId]()
        {
            {
                std::lock_guard<std::mutex> lock(WatershedTelescopePendingLock);
                WatershedTelescopePending.erase(player->GetGUID());
            }

            if (!player->IsInWorld())
                return;

            if (!player->GetVehicle() && !player->IsBeingTeleported() && player->GetMapId() == mapId
                && player->GetExactDist(&released) < 20.0f)
                player->NearTeleportTo(WatershedTelescopeReturn.GetPositionX(), WatershedTelescopeReturn.GetPositionY(),
                    WatershedTelescopeReturn.GetPositionZ(), WatershedTelescopeReturn.GetOrientation());

            if (!held)
                return;

            // The enable is sent twice: the player's own movement packets replace the server's flags, so one sent before the
            // client took the hold would leave the client hovering (scripted-quest-scenes, Finish)
            for (uint32 delay : { 100, 1500 })
                player->m_Events.AddLambdaEventAtOffset([player]()
                {
                    if (!player->IsInWorld() || player->GetVehicle() || player->IsInFlight() || player->HasAuraType(SPELL_AURA_FLY)
                        || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
                        return;

                    if (!player->SetDisableGravity(false))
                        player->SetDisableGravity(false, true);
                }, delay);
        }, 300);
    }

    EventMap _events;
    ObjectGuid _playerGUID;
    WatershedTelescopeView const* _view;
    uint8 _boardTries;
    bool _started;
    bool _done;
};

// A logout (also the shutdown's) while seated in a telescope or in the 300 ms before the set-down: WorldSession::LogoutPlayer
// has just saved the player in the air (it saves before RemoveFromWorld empties the seat; OnPlayerLogout runs in between, the
// player still seated). First line: the saved position is moved to the tower spot by an update queued after that save. This
// ASSUMES the character-database async queue runs in order, i.e. one worker (CharacterDatabase.WorkerThreads = 1, the
// default and the live setting), and that the queue is drained at shutdown (DatabaseWorkerPool::Close does not drain it: core
// issue). Backstop at login (OnLogin): a player who logs in on map 1 within the cameras' area, more than 4 yd over the ground
// or water, not on a vehicle, with Lost in the Floods in the log, is set down on the tower; this also covers a crash after an
// autosave in the seat.
// Login: also Watershed Patrol credits for the people already helped (CreditWatershedPatrolHelped)
class player_durotar_watershed : public PlayerScript
{
public:
    player_durotar_watershed() : PlayerScript("player_durotar_watershed") { }

    void OnLogout(Player* player) override
    {
        bool pending = false;
        {
            std::lock_guard<std::mutex> lock(WatershedTelescopePendingLock);
            pending = WatershedTelescopePending.erase(player->GetGUID()) > 0;
        }

        Unit* vehicle = player->GetVehicleBase();
        bool const seated = vehicle && vehicle->GetTypeId() == TYPEID_UNIT && IsWatershedTelescope(vehicle->GetEntry());
        // A player teleported or summoned away inside the 300 ms (a far teleport is completed before the logout) is left there
        bool const stillHere = pending && player->GetMapId() == 1 && player->GetExactDist2d(WatershedTelescopeReturn.GetPositionX(),
            WatershedTelescopeReturn.GetPositionY()) < 1000.0f && !player->GetVehicle();
        if (!seated && !stillHere)
            return;

        CharacterDatabase.PExecute("UPDATE characters SET map = 1, position_x = %f, position_y = %f, position_z = %f, orientation = %f, "
            "trans_x = 0, trans_y = 0, trans_z = 0, trans_o = 0, transguid = 0 WHERE guid = %u",
            WatershedTelescopeReturn.GetPositionX(), WatershedTelescopeReturn.GetPositionY(), WatershedTelescopeReturn.GetPositionZ(),
            WatershedTelescopeReturn.GetOrientation(), player->GetGUID().GetCounter());
    }

    void OnLogin(Player* player) override
    {
        SetDownAfterLogin(player);
        CreditWatershedPatrolHelped(player);
    }

private:
    // The cameras fly between the tower and the four survivors: x 30..760, y -4600..-3840 (the paths with some margin)
    static bool InTelescopeArea(Player* player)
    {
        return player->GetMapId() == 1 && player->GetPositionX() > 30.0f && player->GetPositionX() < 760.0f
            && player->GetPositionY() > -4600.0f && player->GetPositionY() < -3840.0f;
    }

    // A camera's player saved in the air logs in on foot and falls; one on a flying mount, in flight form, levitating or
    // hovering is up there on purpose and is left alone
    static bool MayBeCameraLeftover(Player* player)
    {
        return InTelescopeArea(player) && !player->GetVehicle() && !player->IsInFlight() && !player->IsMounted()
            && !player->IsFlying() && !player->HasAuraType(SPELL_AURA_FLY) && !player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED)
            && !player->HasAuraType(SPELL_AURA_HOVER);
    }

    static void SetDownAfterLogin(Player* player)
    {
        QuestStatus const status = player->GetQuestStatus(QUEST_LOST_IN_THE_FLOODS);
        if ((status != QUEST_STATUS_INCOMPLETE && status != QUEST_STATUS_COMPLETE) || !MayBeCameraLeftover(player))
            return;

        // A second later, once the player is in the world for the client too (a teleport inside OnLogin lands during the
        // loading screen)
        player->m_Events.AddLambdaEventAtOffset([player]()
        {
            if (!player->IsInWorld() || player->IsBeingTeleported() || !MayBeCameraLeftover(player))
                return;

            float const level = player->GetMap()->GetWaterOrGroundLevel(player->GetPhaseMask(), player->GetPositionX(), player->GetPositionY(),
                player->GetPositionZ());
            if (player->GetPositionZ() - level <= 4.0f)
                return;

            player->NearTeleportTo(WatershedTelescopeReturn.GetPositionX(), WatershedTelescopeReturn.GetPositionY(),
                WatershedTelescopeReturn.GetPositionZ(), WatershedTelescopeReturn.GetOrientation());
        }, 1000);
    }
};

enum Felblood
{
    SPELL_FELBLOOD                  = 80174,
    SPELL_FEL_INFUSED               = 77647,
    FELBLOOD_STACKS_FOR_DEMON_FORM  = 5
};

// Five Felblood stacks (from any Burning Blade, whichever entry cast them, alive or dying; summed over casters:
// Unit::GetAuraCount) turn the target, player or pet, into a
// demon: the stacks go and Fel-Infused takes them, transform to 41787 Metamorphosis, 5 % health every 3 s, +25 % critical
// strike, 60 s (DBC). Run from the target's own event queue, outside the aura code that added the stack
static void CheckFelInfused(Unit* target)
{
    // Players and what they control (pets) only: the sources speak of the player and his pet; Felblood also lands on NPCs in
    // melee with a cultist (the Kor'kron at Skull Rock), which never become the demon
    if (target->GetTypeId() != TYPEID_PLAYER && !target->IsControlledByPlayer())
        return;

    if (!target->IsInWorld() || !target->IsAlive() || target->HasAura(SPELL_FEL_INFUSED))
        return;

    if (target->GetAuraCount(SPELL_FELBLOOD) < FELBLOOD_STACKS_FOR_DEMON_FORM)
        return;

    target->RemoveAurasDueToSpell(SPELL_FELBLOOD);
    target->CastSpell(target, SPELL_FEL_INFUSED, true);
}

// 80174 - Felblood (The Burning Blade 25232)
// Sourced: at five stacks you (and your pet) turn into a demon, gaining critical strike and health regeneration for "a minute"
// (Wowhead 2010-11-24 [+15], 2010-11-25 [+6], 2011-07-10 [+5] and replies on pets; wiki The Burning Blade Notes); "you lost
// all stacks of Felblood" (2011-07-10). The spell is 77647 Fel-Infused, the only DBC spell with that transform, heal and crit
// (no TDB row of either dump casts or links it, nor 80174 to it). Ours: the check runs whenever a stack is added and on
// Felblood's own 3 s periodic dummy (effect 2: no other use is known for it), summing the stacks of every caster.
class spell_durotar_felblood_aura : public AuraScript
{
    PrepareAuraScript(spell_durotar_felblood_aura);

    void ScheduleCheck()
    {
        Unit* target = GetTarget();
        target->m_Events.AddLambdaEventAtOffset([target]() { CheckFelInfused(target); }, 1);
    }

    void AfterApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        ScheduleCheck();
    }

    void HandlePeriodic(AuraEffect const* /*aurEff*/)
    {
        ScheduleCheck();
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_durotar_felblood_aura::AfterApply, EFFECT_2, SPELL_AURA_PERIODIC_DUMMY, AURA_EFFECT_HANDLE_REAL_OR_REAPPLY_MASK);
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_durotar_felblood_aura::HandlePeriodic, EFFECT_2, SPELL_AURA_PERIODIC_DUMMY);
    }
};

// 80174 - Felblood: no Felblood while Fel-Infused ("along with immunity to Felblood", wiki Notes): neither the stack nor its
// fire damage reaches a demon-form target
class spell_durotar_felblood : public SpellScript
{
    PrepareSpellScript(spell_durotar_felblood);

    void FilterTargets(std::list<WorldObject*>& targets)
    {
        targets.remove_if([](WorldObject* target)
        {
            Unit* unit = target->ToUnit();
            return unit && unit->HasAura(SPELL_FEL_INFUSED);
        });
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_durotar_felblood::FilterTargets, EFFECT_ALL, TARGET_UNIT_SRC_AREA_ENEMY);
    }
};

// Shrink 72249
class spell_shrink : public SpellScript
{
    PrepareSpellScript(spell_shrink);

    void FilterTargets(std::list<WorldObject*>& targets)
    {
        targets.remove_if([=](WorldObject* obj) { return obj->GetEntry() != 38300 && obj->GetEntry() != 38301; });
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_shrink::FilterTargets, EFFECT_ALL, TARGET_UNIT_SRC_AREA_ENTRY);
    }
};

// Teleport Out Blackout 121123
class spell_teleport_out_blackout : public AuraScript
{
    PrepareAuraScript(spell_teleport_out_blackout);

    void OnApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (Player* owner = GetOwner()->ToPlayer())
            owner->KilledMonsterCredit(NPC_ARENA_CREDIT);
    }

    void OnRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (Player* owner = GetOwner()->ToPlayer())
        {
            // #510: the trial is over. Drop the arena fight aura (infinite duration, PREVENT_RESURRECTION) the way the
            // Brawler's Guild does at the end of a fight (brawlers_guild.cpp:521), and the trial phase 6 set by
            // AreaTrigger_at_ring_of_valor_entrance - otherwise Garrosh 39605 (the quest ender) and every phase-1 NPC
            // stay invisible until relog. The Alliance twin (npc_varian_wrynn_alliance_way_quest) also resets phase 1.
            owner->RemoveAurasDueToSpell(SPELL_RING_OF_VALOR_IN_THE_ARENA);
            owner->SetPhaseMask(PHASEMASK_NORMAL, true);
            owner->TeleportTo(1, LeaveRingOfValor.GetPositionX(), LeaveRingOfValor.GetPositionY(), LeaveRingOfValor.GetPositionZ(), LeaveRingOfValor.GetOrientation(), TELE_TO_NOT_UNSUMMON_PET);
        }
    }

    void Register() override
    {
        OnEffectApply += AuraEffectApplyFn(spell_teleport_out_blackout::OnApply, EFFECT_1, SPELL_AURA_SCREEN_EFFECT, AURA_EFFECT_HANDLE_REAL);
        OnEffectRemove += AuraEffectRemoveFn(spell_teleport_out_blackout::OnRemove, EFFECT_1, SPELL_AURA_SCREEN_EFFECT, AURA_EFFECT_HANDLE_REAL);
    }
};

// Areatrigger 8730
class AreaTrigger_at_ring_of_valor_entrance : public AreaTriggerScript
{
    public:
        AreaTrigger_at_ring_of_valor_entrance() : AreaTriggerScript("AreaTrigger_at_ring_of_valor_entrance") { }

        bool OnTrigger(Player* player, AreaTriggerEntry const* trigger) override
        {
            if (player->GetQuestStatus(QUEST_GIFT_OF_HELLSCREAM) == QUEST_STATUS_INCOMPLETE && player->GetPhaseMask() != 6)
            {
                player->SetPhaseMask(6, true);

                player->SummonCreature(NPC_GARROSH_HORDE_WAY, GarroshArenaPos, TEMPSUMMON_MANUAL_DESPAWN);
                player->SummonCreature(NPC_JI_FIREPAWN_HORDE_WAY, RingOfValor.GetPositionX() + frand(-5.0f, 5.0f), RingOfValor.GetPositionY() + frand(-2.0f, 4.0f), RingOfValor.GetPositionZ(), RingOfValor.GetOrientation(), TEMPSUMMON_MANUAL_DESPAWN);
                return true;
            }
            return false;
    }
};

void AddSC_durotar()
{
    new creature_script<npc_lazy_peon>("npc_lazy_peon");
    new npc_garrosh_hellscream_warchief();
    new npc_garrosh_horde_way_quest();
    new npc_ji_firepaw_horde_way_quest();
    new creature_script<npc_trial_challengers>("npc_trial_challengers");
    new quest_durotar_watershed_patrol();
    new creature_script<npc_durotar_grandmatron_tekla>("npc_durotar_grandmatron_tekla");
    new creature_script<npc_darkspear_jailor>("npc_darkspear_jailor");
    new creature_script<npc_captive_pitescale_scout>("npc_captive_pitescale_scout");
    new creature_script<npc_northwatch_caravan_spawner>("npc_northwatch_caravan_spawner");
    new creature_script<npc_northwatch_caravan>("npc_northwatch_caravan");
    new spell_voodoo();
    new spell_script<spell_summ_garrosh_horde_way>("spell_summ_garrosh_horde_way");
    new aura_script<spell_summ_ji_horde_way>("spell_summ_ji_horde_way");
    new spell_script<spell_place_territorial_fetish>("spell_place_territorial_fetish");
    new spell_script<spell_thonks_spyglass>("spell_thonks_spyglass");
    new creature_script<npc_durotar_watershed_telescope>("npc_durotar_watershed_telescope");
    new player_durotar_watershed();
    new spell_script<spell_shrink>("spell_shrink");
    new aura_script<spell_durotar_felblood_aura>("spell_durotar_felblood_aura");
    new spell_script<spell_durotar_felblood>("spell_durotar_felblood");
    new aura_script<spell_teleport_out_blackout>("spell_teleport_out_blackout");
    new AreaTrigger_at_ring_of_valor_entrance();
}
