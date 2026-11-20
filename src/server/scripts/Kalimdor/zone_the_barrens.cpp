/*
* This file is part of the Legends of Azeroth Pandaria Project. See THANKS file for Copyright information
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
SDName: The_Barrens
SD%Complete: 90
SDComment: Quest support: 863
SDCategory: Barrens
EndScriptData */

/* ContentData
npc_wizzlecrank_shredder
EndContentData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "ScriptedEscortAI.h"
#include "Player.h"
#include "Pet.h"
#include "SpellInfo.h"
#include "TemporarySummon.h"

/*######
## npc_beaten_corpse
######*/

#define GOSSIP_CORPSE "Examine corpse in detail..."

enum eQuests
{
    QUEST_LOST_IN_BATTLE      = 4921,
    QUEST_DRAG_IT_OUT_OF_THEM = 13961,
};

enum eSpells
{
    SPELL_SNARED_IN_NET        = 65581,
    SPELL_SNARED_NET_CONNECTOR = 65596,
    SPELL_SUMMON_RAZORMANE     = 65595,
    SPELL_DRAGING_A_RAZORMANE  = 65601,
};

enum eCreatures
{
    NPC_RAZORMANE_PILLAGER_SUMMONED = 34514,
};

enum eDragItOutOfThem
{
    FACTION_NETTED_PILLAGER    = 35,
    NET_DURATION               = 300 * IN_MILLISECONDS,
    TALK_PILLAGER_ENSNARED     = 0,    // "%s is ensnared!" (BT 34691)
    TALK_PILLAGER_BREAKS_FREE  = 1,    // "%s breaks out of the net." (BT 34690)
};

class npc_beaten_corpse : public CreatureScript
{
public:
    npc_beaten_corpse() : CreatureScript("npc_beaten_corpse") { }

    bool OnGossipSelect(Player* player, Creature* creature, uint32 /*sender*/, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();
        if (action == GOSSIP_ACTION_INFO_DEF +1)
        {
            player->SEND_GOSSIP_MENU(3558, creature->GetGUID());
            player->TalkedToCreature(creature->GetEntry(), creature->GetGUID());
        }
        return true;
    }

    bool OnGossipHello(Player* player, Creature* creature) override
    {
        if (player->GetQuestStatus(QUEST_LOST_IN_BATTLE) == QUEST_STATUS_INCOMPLETE || player->GetQuestStatus(QUEST_LOST_IN_BATTLE) == QUEST_STATUS_COMPLETE)
            player->ADD_GOSSIP_ITEM(GOSSIP_ICON_CHAT, GOSSIP_CORPSE, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF+1);

        player->SEND_GOSSIP_MENU(3557, creature->GetGUID());
        return true;
    }

};

/*######
# npc_gilthares
######*/

enum Gilthares
{
    SAY_GIL_START               = 0,
    SAY_GIL_AT_LAST             = 1,
    SAY_GIL_PROCEED             = 2,
    SAY_GIL_FREEBOOTERS         = 3,
    SAY_GIL_AGGRO               = 4,
    SAY_GIL_ALMOST              = 5,
    SAY_GIL_SWEET               = 6,
    SAY_GIL_FREED               = 7,

    QUEST_FREE_FROM_HOLD        = 898,
    AREA_MERCHANT_COAST         = 391,
    FACTION_ESCORTEE            = 232                       //guessed, possible not needed for this quest
};

class npc_gilthares : public CreatureScript
{
public:
    npc_gilthares() : CreatureScript("npc_gilthares") { }

    bool OnQuestAccept(Player* player, Creature* creature, const Quest* quest) override
    {
        if (quest->GetQuestId() == QUEST_FREE_FROM_HOLD)
        {
            creature->SetFaction(FACTION_ESCORTEE);
            creature->SetStandState(UNIT_STAND_STATE_STAND);

            creature->AI()->Talk(SAY_GIL_START, player);

            if (npc_giltharesAI* pEscortAI = CAST_AI(npc_gilthares::npc_giltharesAI, creature->AI()))
                pEscortAI->Start(false, false, player->GetGUID(), quest);
        }
        return true;
    }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_giltharesAI(creature);
    }

    struct npc_giltharesAI : public npc_escortAI
    {
        npc_giltharesAI(Creature* creature) : npc_escortAI(creature) { }

        void Reset() override { }

        void WaypointReached(uint32 waypointId) override
        {
            Player* player = GetPlayerForEscort();
            if (!player)
                return;

            switch (waypointId)
            {
                case 16:
                    Talk(SAY_GIL_AT_LAST, player);
                    break;
                case 17:
                    Talk(SAY_GIL_PROCEED, player);
                    break;
                case 18:
                    Talk(SAY_GIL_FREEBOOTERS, player);
                    break;
                case 37:
                    Talk(SAY_GIL_ALMOST, player);
                    break;
                case 47:
                    Talk(SAY_GIL_SWEET, player);
                    break;
                case 53:
                    Talk(SAY_GIL_FREED, player);
                    player->GroupEventHappens(QUEST_FREE_FROM_HOLD, me);
                    break;
            }
        }

        void JustEngagedWith(Unit* who) override
        {
            //not always use
            if (rand()%4)
                return;

            //only aggro text if not player and only in this area
            if (who->GetTypeId() != TYPEID_PLAYER && me->GetAreaId() == AREA_MERCHANT_COAST)
            {
                //appears to be pretty much random (possible only if escorter not in combat with who yet?)
                Talk(SAY_GIL_AGGRO, who);
            }
        }
    };

};

/*######
## npc_taskmaster_fizzule
######*/

enum TaskmasterFizzule
{
    FACTION_FRIENDLY_F  = 35,
    SPELL_FLARE         = 10113,
    SPELL_FOLLY         = 10137,
};

class npc_taskmaster_fizzule : public CreatureScript
{
public:
    npc_taskmaster_fizzule() : CreatureScript("npc_taskmaster_fizzule") { }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_taskmaster_fizzuleAI(creature);
    }

    struct npc_taskmaster_fizzuleAI : public ScriptedAI
    {
        npc_taskmaster_fizzuleAI(Creature* creature) : ScriptedAI(creature)
        {
            factionNorm = creature->GetFaction();
        }

        uint32 factionNorm;
        bool IsFriend;
        uint32 ResetTimer;
        uint8 FlareCount;

        void Reset() override
        {
            IsFriend = false;
            ResetTimer = 120000;
            FlareCount = 0;
            me->SetFaction(factionNorm);
        }

        void DoFriend()
        {
            me->RemoveAllAuras();
            me->GetThreatManager().RemoveMeFromThreatLists();
            me->GetThreatManager().ClearAllThreat();
            me->CombatStop(true);

            me->StopMoving();
            me->GetMotionMaster()->MoveIdle();

            me->SetFaction(FACTION_FRIENDLY_F);
            me->HandleEmoteCommand(EMOTE_ONESHOT_SALUTE);
        }

        void SpellHit(Unit* /*caster*/, const SpellInfo* spell) override
        {
            if (spell->Id == SPELL_FLARE || spell->Id == SPELL_FOLLY)
            {
                ++FlareCount;

                if (FlareCount >= 2)
                    IsFriend = true;
            }
        }

        void JustEngagedWith(Unit* /*who*/) override { }

        void UpdateAI(uint32 diff) override
        {
            if (IsFriend)
            {
                if (ResetTimer <= diff)
                {
                    EnterEvadeMode();
                    return;
                } else ResetTimer -= diff;
            }

            if (!UpdateVictim())
                return;

            DoMeleeAttackIfReady();
        }

        void ReceiveEmote(Player* /*player*/, uint32 emote) override
        {
            if (emote == TEXT_EMOTE_SALUTE)
            {
                if (FlareCount >= 2)
                {
                    if (me->GetFaction() == FACTION_FRIENDLY_F)
                        return;

                    DoFriend();
                }
            }
        }
    };

};

/*#####
## npc_twiggy_flathead
#####*/

enum TwiggyFlathead
{
    NPC_BIG_WILL                = 6238,
    NPC_AFFRAY_CHALLENGER       = 6240,

    SAY_BIG_WILL_READY          = 0,
    SAY_TWIGGY_FLATHEAD_BEGIN   = 0,
    SAY_TWIGGY_FLATHEAD_FRAY    = 1,
    SAY_TWIGGY_FLATHEAD_DOWN    = 2,
    SAY_TWIGGY_FLATHEAD_OVER    = 3
};

Position const AffrayChallengerLoc[6] =
{
    {-1683.0f, -4326.0f, 2.79f, 0.0f},
    {-1682.0f, -4329.0f, 2.79f, 0.0f},
    {-1683.0f, -4330.0f, 2.79f, 0.0f},
    {-1680.0f, -4334.0f, 2.79f, 1.49f},
    {-1674.0f, -4326.0f, 2.79f, 3.49f},
    {-1677.0f, -4334.0f, 2.79f, 1.66f}
};

class npc_twiggy_flathead : public CreatureScript
{
public:
    npc_twiggy_flathead() : CreatureScript("npc_twiggy_flathead") { }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_twiggy_flatheadAI(creature);
    }

    struct npc_twiggy_flatheadAI : public ScriptedAI
    {
        npc_twiggy_flatheadAI(Creature* creature) : ScriptedAI(creature) { }

        bool EventInProgress;
        bool EventGrate;
        bool EventBigWill;
        bool ChallengerDown[6];
        uint8 Wave;
        uint32 WaveTimer;
        uint32 ChallengerChecker;
        ObjectGuid PlayerGUID;
        ObjectGuid AffrayChallenger[6];
        ObjectGuid BigWill;

        void Reset() override
        {
            EventInProgress = false;
            EventGrate = false;
            EventBigWill = false;
            WaveTimer = 600000;
            ChallengerChecker = 0;
            Wave = 0;
            PlayerGUID = ObjectGuid::Empty;

            for (uint8 i = 0; i < 6; ++i)
            {
                AffrayChallenger[i] = ObjectGuid::Empty;
                ChallengerDown[i] = false;
            }
            BigWill = ObjectGuid::Empty;
        }

        void JustEngagedWith(Unit* /*who*/) override { }

        void MoveInLineOfSight(Unit* who) override

        {
            if (!who || !who->IsAlive() || EventInProgress)
                return;

            if (who->GetTypeId() == TYPEID_PLAYER && me->IsWithinDistInMap(who, 10.0f))
                if (Player* player = who->ToPlayer())
                    if (player->GetQuestStatus(1719) == QUEST_STATUS_INCOMPLETE)
                    {
                        PlayerGUID = who->GetGUID();
                        EventInProgress = true;
                    }
        }

        void KilledUnit(Unit* /*victim*/) override { }

        void UpdateAI(uint32 diff) override
        {
            if (EventInProgress)
            {
                Player* warrior = NULL;

                if (PlayerGUID)
                    warrior = ObjectAccessor::GetPlayer(*me, PlayerGUID);

                if (!warrior)
                    return;

                if (!warrior->IsAlive() && warrior->GetQuestStatus(1719) == QUEST_STATUS_INCOMPLETE)
                {
                    Talk(SAY_TWIGGY_FLATHEAD_DOWN);
                    warrior->FailQuest(1719);

                    for (uint8 i = 0; i < 6; ++i) // unsummon challengers
                    {
                        if (AffrayChallenger[i])
                        {
                            Creature* creature = Unit::GetCreature((*me), AffrayChallenger[i]);
                            if (creature && creature->IsAlive())
                                creature->DisappearAndDie();
                        }
                    }

                    if (BigWill) // unsummon bigWill
                    {
                        Creature* creature = Unit::GetCreature((*me), BigWill);
                        if (creature && creature->IsAlive())
                            creature->DisappearAndDie();
                    }
                    Reset();
                }

                if (!EventGrate && EventInProgress)
                {
                    float x, y, z;
                    warrior->GetPosition(x, y, z);

                    if (x >= -1684 && x <= -1674 && y >= -4334 && y <= -4324)
                    {
                        warrior->AreaExploredOrEventHappens(1719);
                        Talk(SAY_TWIGGY_FLATHEAD_BEGIN, warrior);

                        for (uint8 i = 0; i < 6; ++i)
                        {
                            Creature* creature = me->SummonCreature(NPC_AFFRAY_CHALLENGER, AffrayChallengerLoc[i], TEMPSUMMON_TIMED_OR_DEAD_DESPAWN, 600000ms);
                            if (!creature)
                                continue;
                            creature->SetFaction(35);
                            creature->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                            creature->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
                            creature->HandleEmoteCommand(EMOTE_ONESHOT_ROAR);
                            AffrayChallenger[i] = creature->GetGUID();
                        }
                        WaveTimer = 5000;
                        ChallengerChecker = 1000;
                        EventGrate = true;
                    }
                }
                else if (EventInProgress)
                {
                    if (ChallengerChecker <= diff)
                    {
                        for (uint8 i = 0; i < 6; ++i)
                        {
                            if (AffrayChallenger[i])
                            {
                                Creature* creature = Unit::GetCreature((*me), AffrayChallenger[i]);
                                if ((!creature || (!creature->IsAlive())) && !ChallengerDown[i])
                                {
                                    Talk(SAY_TWIGGY_FLATHEAD_DOWN);
                                    ChallengerDown[i] = true;
                                }
                            }
                        }
                        ChallengerChecker = 1000;
                    } else ChallengerChecker -= diff;

                    if (WaveTimer <= diff)
                    {
                        if (Wave < 6 && AffrayChallenger[Wave] && !EventBigWill)
                        {
                            Talk(SAY_TWIGGY_FLATHEAD_FRAY);
                            Creature* creature = ObjectAccessor::GetCreature(*me, AffrayChallenger[Wave]);
                            if (creature && (creature->IsAlive()))
                            {
                                creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
                                creature->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
                                creature->HandleEmoteCommand(EMOTE_ONESHOT_ROAR);
                                creature->SetFaction(14);
                                creature->AI()->AttackStart(warrior);
                                ++Wave;
                                WaveTimer = 20000;
                            }
                        }
                        else if (Wave >= 6 && !EventBigWill)
                        {
                            if (Creature* creature = me->SummonCreature(NPC_BIG_WILL, -1722, -4341, 6.12f, 6.26f, TEMPSUMMON_TIMED_OR_DEAD_DESPAWN, 480000ms))
                            {
                                BigWill = creature->GetGUID();
                                //creature->GetMotionMaster()->MovePoint(0, -1693, -4343, 4.32f);
                                //creature->GetMotionMaster()->MovePoint(1, -1684, -4333, 2.78f);
                                creature->GetMotionMaster()->MovePoint(2, -1682, -4329, 2.79f);
                                creature->HandleEmoteCommand(EMOTE_STATE_READY_UNARMED);
                                EventBigWill = true;
                                WaveTimer = 1000;
                            }
                        }
                        else if (Wave >= 6 && EventBigWill && BigWill)
                        {
                            Creature* creature = ObjectAccessor::GetCreature(*me, BigWill);
                            if (!creature || !creature->IsAlive())
                            {
                                Talk(SAY_TWIGGY_FLATHEAD_OVER);
                                Reset();
                            }
                        }
                    } else WaveTimer -= diff;
                }
            }
        }
    };

};

/*#####
## npc_wizzlecrank_shredder
#####*/

enum Wizzlecrank
{
    SAY_MERCENARY       = 0,
    SAY_START           = 0,
    SAY_STARTUP1        = 1,
    SAY_STARTUP2        = 2,
    SAY_PROGRESS_1      = 3,
    SAY_PROGRESS_2      = 4,
    SAY_PROGRESS_3      = 5,
    SAY_END             = 6,

    QUEST_ESCAPE        = 863,
    FACTION_RATCHET     = 637,
    NPC_PILOT_WIZZ      = 3451,
    NPC_MERCENARY       = 3282,

    SPELL_SELF_EXPLOSION = 5162,   // both TDBs (actionlist 343903): an instakill on itself as the shredder gives out
    ESCAPE_START_DELAY   = 6000,   // both TDBs: Say 0, 6 s, Say 1 and the walk (343900)
    ESCAPE_START_RETRIES = 20,     // ours: while something fights it, Start is retried once a second this many times
};

class npc_wizzlecrank_shredder : public CreatureScript
{
public:
    npc_wizzlecrank_shredder() : CreatureScript("npc_wizzlecrank_shredder") { }

    struct npc_wizzlecrank_shredderAI : public npc_escortAI
    {
        npc_wizzlecrank_shredderAI(Creature* creature) : npc_escortAI(creature)
        {
            IsPostEvent = false;
            PostEventTimer = 1000;
            PostEventCount = 0;
            StartTimer = 0;
            StartTries = 0;
        }

        bool IsPostEvent;
        uint32 PostEventTimer;
        uint32 PostEventCount;
        uint32 StartTimer;
        uint32 StartTries;
        ObjectGuid StarterGUID;

        // The Escape (863) accepted: "Alright, alright! I think I can figure out how to operate this thing..." to the player,
        // the shredder stops offering the quest (both TDBs 343900: Remove NPC Flag Questgiver; dossier H finding 3), and the walk
        // starts 6 s later. It keeps its own faction (69, neutral to the Venture Co. mercenaries a few yards away) until the walk
        // starts and takes 637 only then: with 637 at accept the mercenaries fought it in those 6 s, npc_escortAI::Start refuses
        // a creature with a victim (ScriptedEscortAI.cpp:454) and it stood for ever with no quest flag (review round 1, walk B1).
        // Should something still fight it then, Start is retried each second; if it cannot start, the shredder offers the
        // quest again (AbortStart). Every end of a started escort despawns the shredder (end of path, player out of range, its
        // death) and its respawn puts the template npcflag and faction back (Creature::setDeathState JUST_RESPAWNED,
        // npc_escortAI::JustAppeared).
        void BeginEscape(Player* player)
        {
            if (HasEscortState(STATE_ESCORT_ESCORTING) || StartTimer)
                return;

            me->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_QUESTGIVER);
            Talk(SAY_START, player);
            StarterGUID = player->GetGUID();
            StartTimer = ESCAPE_START_DELAY;
            StartTries = 0;
        }

        void TryStartEscape()
        {
            if (me->GetVictim())
            {
                if (++StartTries < ESCAPE_START_RETRIES)
                    StartTimer = 1000;
                else
                    AbortStart();
                return;
            }

            me->SetFaction(FACTION_RATCHET);
            Start(true, false, StarterGUID);
            if (!HasEscortState(STATE_ESCORT_ESCORTING))
                AbortStart();
        }

        // The escort never started: faction and quest flag back, so 863 can be taken (and 858 handed in) again. The starter's
        // 863 stays incomplete: abandon and retake, as after any failed escort.
        void AbortStart()
        {
            StartTimer = 0;
            StartTries = 0;
            StarterGUID.Clear();
            me->RestoreFaction();
            me->SetFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_QUESTGIVER);
        }

        void JustDied(Unit* killer) override
        {
            StartTimer = 0;   // a death in the 6 s: the respawn starts clean
            StartTries = 0;
            npc_escortAI::JustDied(killer);
        }

        void Reset() override
        {
            if (!HasEscortState(STATE_ESCORT_ESCORTING))
            {
                if (me->GetStandState() == UNIT_STAND_STATE_DEAD)
                     me->SetStandState(UNIT_STAND_STATE_STAND);

                IsPostEvent = false;
                PostEventTimer = 1000;
                PostEventCount = 0;
            }
        }

        void WaypointReached(uint32 waypointId) override
        {
            switch (waypointId)
            {
                case 0:
                    Talk(SAY_STARTUP1);
                    break;
                case 9:
                    SetRun(false);
                    break;
                case 17:
                    if (Creature* temp = me->SummonCreature(NPC_MERCENARY, 1128.489f, -3037.611f, 92.701f, 1.472f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 120000ms))
                    {
                        temp->AI()->Talk(SAY_MERCENARY);
                        me->SummonCreature(NPC_MERCENARY, 1160.172f, -2980.168f, 97.313f, 3.690f, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, 120000ms);
                    }
                    break;
                case 24:
                    IsPostEvent = true;
                    break;
            }
        }

        void WaypointStart(uint32 PointId) override
        {
            Player* player = GetPlayerForEscort();

            if (!player)
                return;

            switch (PointId)
            {
                case 9:
                    Talk(SAY_STARTUP2, player);
                    break;
                case 18:
                    Talk(SAY_PROGRESS_1, player);
                    SetRun();
                    break;
            }
        }

        void JustSummoned(Creature* summoned) override
        {
            if (summoned->GetEntry() == NPC_PILOT_WIZZ)
                me->SetStandState(UNIT_STAND_STATE_DEAD);

            if (summoned->GetEntry() == NPC_MERCENARY)
                summoned->AI()->AttackStart(me);
        }

        void UpdateEscortAI(const uint32 Diff) override
        {
            if (StartTimer)
            {
                if (StartTimer <= Diff)
                {
                    StartTimer = 0;
                    TryStartEscape();
                }
                else
                    StartTimer -= Diff;
            }

            if (!UpdateVictim())
            {
                if (IsPostEvent)
                {
                    if (PostEventTimer <= Diff)
                    {
                        switch (PostEventCount)
                        {
                            case 0:
                                Talk(SAY_PROGRESS_2);
                                break;
                            case 1:
                                Talk(SAY_PROGRESS_3);
                                break;
                            case 2:
                                Talk(SAY_END);
                                break;
                            case 3:
                                // Both TDBs (343903): credit, Self Explosion, the pilot, despawn 10 s later. Self Explosion is an
                                // instakill (effect 1) on itself, so the shredder dies where it gives out (event 524 is empty);
                                // the pilot climbs out beside the wreck, which is gone 10 s later and respawns 300 s after that.
                                // The cast comes last: a dead creature's AI no longer updates.
                                if (Player* player = GetPlayerForEscort())
                                {
                                    player->GroupEventHappens(QUEST_ESCAPE, me);
                                    me->SummonCreature(NPC_PILOT_WIZZ, 0.0f, 0.0f, 0.0f, 0.0f, TEMPSUMMON_TIMED_DESPAWN, 180000ms);
                                }
                                DoCast(me, SPELL_SELF_EXPLOSION, true);
                                me->DespawnOrUnsummon(10 * IN_MILLISECONDS);
                                return;
                        }

                        ++PostEventCount;
                        PostEventTimer = 5000;
                    }
                    else
                        PostEventTimer -= Diff;
                }

                return;
            }

            DoMeleeAttackIfReady();
        }
    };

    bool OnQuestAccept(Player* player, Creature* creature, Quest const* quest) override
    {
        if (quest->GetQuestId() == QUEST_ESCAPE)
            if (npc_wizzlecrank_shredderAI* shredderAI = CAST_AI(npc_wizzlecrank_shredder::npc_wizzlecrank_shredderAI, creature->AI()))
                shredderAI->BeginEscape(player);
        return true;
    }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_wizzlecrank_shredderAI(creature);
    }

};

// Razormane Pillager 34503, 34514
class npc_razormane_pillager : public CreatureScript
{
    public:
        npc_razormane_pillager() : CreatureScript("npc_razormane_pillager") { }

        bool OnGossipSelect(Player* player, Creature* creature, uint32 /*sender*/, uint32 action) override
        {
            player->PlayerTalkClass->ClearMenus();

            if (action == GOSSIP_ACTION_INFO_DEF + 1)
            {
                creature->DespawnOrUnsummon();
                player->CastSpell(player, SPELL_SUMMON_RAZORMANE, true);
            }

            player->CLOSE_GOSSIP_MENU();

            return true;
        }

        bool OnGossipHello(Player* player, Creature* creature) override
        {
            if (creature->IsQuestGiver())
                player->PrepareQuestMenu(creature->GetGUID());

            if (player->GetQuestStatus(QUEST_DRAG_IT_OUT_OF_THEM) != QUEST_STATUS_INCOMPLETE)
                return false;

            player->ADD_GOSSIP_ITEM_DB(player->GetDefaultGossipMenuForSource(creature), 0, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);

            player->SEND_GOSSIP_MENU(player->GetGossipTextId(creature), creature->GetGUID());
            return true;
        }

        struct npc_razormane_pillagerAI : public ScriptedAI
        {
            npc_razormane_pillagerAI(Creature* creature) : ScriptedAI(creature) { }

            ObjectGuid summonerGUID;
            uint32 checkTimer = 1000;
            bool fled = false;

            // Hogtied Razormane 34514, summoned by 65595 when the player pounds a netted pillager.
            // What the player sees (sourced: aura 65601 Dragging a Razormane lasts 600 s and is limited to AreaGroup 2711 = the
            // Northern Barrens; Wowhead 13961 comments "10 mins" (reply to 2010-12-30) and "took him to Orgrimmar and he
            // disappeared" (2010-12-30, 2011-02-22)): the razormane lies trussed up and is dragged on a rope behind the player for
            // up to ten minutes; it is gone, with the rope, the moment the player abandons the quest, leaves the Barrens, dies,
            // logs out or delivers it. Before: it vanished after 300 s while the 600 s aura (which the areatrigger credits) stayed,
            // and it followed on after an abandon or a zone change; the rope aura was never removed (13961 CB-3).
            void IsSummonedBy(Unit* summoner) override
            {
                summonerGUID = summoner->GetGUID();
                me->CastSpell(summoner, SPELL_DRAGING_A_RAZORMANE, true);
                me->CastSpell(summoner, SPELL_SNARED_NET_CONNECTOR, true);
                me->SetFaction(35);
                me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PACIFIED | UNIT_FLAG_IMMUNE_TO_NPC);
                me->DespawnOrUnsummon(600 * IN_MILLISECONDS);   // as long as the drag aura
                me->SetStandState(UNIT_STAND_STATE_DEAD);
                me->GetMotionMaster()->MoveFollow(summoner, 2.5f, me->GetAngle(summoner));
                checkTimer = 1000;
            }

            // The hogtied razormane still belongs to its owner: he has the drag aura and 13961 in progress
            bool OwnerStillDragging(Player* owner) const
            {
                return owner && owner->IsInWorld() && owner->IsAlive() && owner->HasAura(SPELL_DRAGING_A_RAZORMANE)
                    && owner->GetQuestStatus(QUEST_DRAG_IT_OUT_OF_THEM) == QUEST_STATUS_INCOMPLETE;
            }

            // Whatever ends the drag (the 600 s, the checks below, the areatrigger's despawn, the owner leaving the world) takes the
            // rope and the drag aura off the owner as well
            void Unsummoned() override
            {
                if (me->GetEntry() != NPC_RAZORMANE_PILLAGER_SUMMONED)
                    return;

                if (Player* owner = ObjectAccessor::GetPlayer(*me, summonerGUID))
                {
                    owner->RemoveAurasDueToSpell(SPELL_DRAGING_A_RAZORMANE, me->GetGUID());
                    owner->RemoveAurasDueToSpell(SPELL_SNARED_NET_CONNECTOR, me->GetGUID());
                }
            }

            void Reset() override
            {
                // The free pillager takes its template faction (109) back, but not while it lies in the net: an evade of a netted
                // pillager used to turn it hostile again at once (13961 CB-1). The hogtied copy keeps the faction IsSummonedBy set.
                if (me->GetEntry() != NPC_RAZORMANE_PILLAGER_SUMMONED && !me->HasAura(SPELL_SNARED_IN_NET))
                    me->RestoreFaction();
                fled = false;
            }

            // Both TDBs' SmartAI row 34503/0 "Between 0-15% Health - Flee For Assist (No Repeat)", dead here because the C++
            // ScriptName wins over AIName (13973 claim 6, CB-4). Once per life / evade.
            void DamageTaken(Unit* /*attacker*/, uint32& damage) override
            {
                if (fled || me->GetEntry() == NPC_RAZORMANE_PILLAGER_SUMMONED || me->HasAura(SPELL_SNARED_IN_NET))
                    return;

                if (damage < me->GetHealth() && me->HealthBelowPctDamaged(15, damage))
                {
                    fled = true;
                    me->DoFleeToGetAssistance();
                }
            }

            void UpdateAI(uint32 diff) override
            {
                if (me->GetEntry() == NPC_RAZORMANE_PILLAGER_SUMMONED)
                {
                    if (checkTimer > diff)
                    {
                        checkTimer -= diff;
                        return;
                    }
                    checkTimer = 1000;

                    Player* owner = ObjectAccessor::GetPlayer(*me, summonerGUID);
                    if (!OwnerStillDragging(owner))
                    {
                        // Abandoned, left the Barrens (65601 is area-limited), dead, gone, or delivered
                        if (TempSummon* summon = me->ToTempSummon())
                            summon->UnSummon();
                        else
                            me->DespawnOrUnsummon();
                        return;
                    }

                    // Follow is issued once; only a lost follow (a teleport, a cleared motion master) is given again, so the
                    // rope does not stutter from a new follow every tick
                    if (me->GetMotionMaster()->GetCurrentMovementGeneratorType() != FOLLOW_MOTION_TYPE)
                        me->GetMotionMaster()->MoveFollow(owner, 2.5f, me->GetAngle(owner));
                    return;
                }

                // Netted: no victim, no evade (the net ended its fight; the aura's removal sends it home)
                if (me->HasAura(SPELL_SNARED_IN_NET))
                    return;

                if (!UpdateVictim())
                    return;

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* creature) const override
        {
            return new npc_razormane_pillagerAI(creature);
        }
};

// Grol`dom Net 65580
class spell_groldom_net : public SpellScript
{
    PrepareSpellScript(spell_groldom_net);

    void HandleDummy(SpellEffIndex /*effIndex*/)
    {
        if (Unit* target = GetHitUnit())
            target->CastSpell(target, SPELL_SNARED_IN_NET, true);
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_groldom_net::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

// Snared in Net 65581
// What the player sees (sourced: Wowhead 13961 comments 2010-12-04 [+59] and 2011-07-17 [+12] with its reply - charging pillagers
// that the guards are shooting can be netted too, they turn green and can be pounded; creature_text 34503 groups 0/1, broadcast
// 34691 "%s is ensnared!" / 34690 "%s breaks out of the net."): the netted pillager stops fighting at once, emotes that it is
// ensnared, turns friendly (green) and lies stunned; whoever was fighting it (the player, Grol'dom Grunts) lets go. If nobody
// pounds it, after 300 s it emotes that it breaks out, turns hostile and walks home. Ours: the 300 s (kept from the old script).
// Before: a pillager in combat went friendly with a victim still set, evaded the next tick and Reset made it hostile (CB-1).
class spell_snared_in_net : public AuraScript
{
    PrepareAuraScript(spell_snared_in_net);

    void AfterApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Creature* owner = GetTarget()->ToCreature();
        if (!owner)
            return;

        owner->CombatStop(true);   // also makes its attackers (players, Grunts) let go: Unit::RemoveAllAttackers
        owner->GetThreatManager().ClearAllThreat();
        owner->GetMotionMaster()->Clear();
        owner->GetMotionMaster()->MoveIdle();
        owner->SetFaction(FACTION_NETTED_PILLAGER);
        if (owner->IsAIEnabled)
            owner->AI()->Talk(TALK_PILLAGER_ENSNARED);

        // The aura itself is infinite (DBC); the net holds 300 s
        GetAura()->SetMaxDuration(NET_DURATION);
        GetAura()->SetDuration(NET_DURATION);
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Creature* owner = GetTarget()->ToCreature();
        if (!owner || !owner->IsAlive() || !owner->IsInWorld())
            return;

        owner->RestoreFaction();
        if (GetTargetApplication()->GetRemoveMode() == AURA_REMOVE_BY_EXPIRE && owner->IsAIEnabled)
        {
            owner->AI()->Talk(TALK_PILLAGER_BREAKS_FREE);
            owner->AI()->EnterEvadeMode();   // back to its spot or path
        }
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_snared_in_net::AfterApply, EFFECT_0, SPELL_AURA_MOD_STUN, AURA_EFFECT_HANDLE_REAL);
        AfterEffectRemove += AuraEffectRemoveFn(spell_snared_in_net::AfterRemove, EFFECT_0, SPELL_AURA_MOD_STUN, AURA_EFFECT_HANDLE_REAL);
    }
};

// AreaTrigger 5465
class AreaTrigger_at_groldom_farm : public AreaTriggerScript
{
    public:
        AreaTrigger_at_groldom_farm() : AreaTriggerScript("AreaTrigger_at_groldom_farm") { }

        bool OnTrigger(Player* player, AreaTriggerEntry const* trigger) override
        {
            if (player->HasAura(SPELL_DRAGING_A_RAZORMANE) && player->GetQuestStatus(QUEST_DRAG_IT_OUT_OF_THEM) == QUEST_STATUS_INCOMPLETE)
            {
                if (Aura* dragAura = player->GetAura(SPELL_DRAGING_A_RAZORMANE))
                    if (Unit* caster = dragAura->GetCaster())
                        if (caster->ToCreature())
                            caster->ToCreature()->DespawnOrUnsummon(1000);

                player->RemoveAurasDueToSpell(SPELL_DRAGING_A_RAZORMANE);
                player->RemoveAurasDueToSpell(SPELL_SNARED_NET_CONNECTOR);
                // Counts the "Razormane Prisoner Delivered" objective (type 10) as well as completing: CompleteQuest left the log
                // line at 0/1 (13961 CB-2)
                player->AreaExploredOrEventHappens(QUEST_DRAG_IT_OUT_OF_THEM);
            }

            return false;
        }
};

enum BackInTheFightType
{
    NPC_WOUNDED_DEFENDER = 38805,

    ACTION_HEALED_BY_BANDAGE = 0,

    TALK_HEALED = 0,
};

// Wounded Defender 38805
struct npc_barrent_wounded_defender : public ScriptedAI
{
    npc_barrent_wounded_defender(Creature* creature) : ScriptedAI(creature) { }

    TaskScheduler scheduler;
    ObjectGuid questReceiverGUID;
    bool hasCredit;

    void Reset() override
    {
        hasCredit = false;
        questReceiverGUID = ObjectGuid::Empty;
        me->SetStandState(UNIT_STAND_STATE_SLEEP);
    }

    void SetGUID(ObjectGuid guid, int32 /*type*/) override
    {
        questReceiverGUID = guid;
    }

    void DoAction(int32 actionId) override
    {
        if (actionId == ACTION_HEALED_BY_BANDAGE && !hasCredit)
        {
            hasCredit = true;
            me->SetStandState(UNIT_STAND_STATE_STAND);

            if (Player* questReceiver = ObjectAccessor::GetPlayer(*me, questReceiverGUID))
                questReceiver->KilledMonsterCredit(me->GetEntry());

            scheduler
                .Schedule(Seconds(2), [this](TaskContext context)
            {
                Talk(TALK_HEALED);
            });

            scheduler
                .Schedule(Seconds(4), [this](TaskContext context)
            {
                // Move away!
                Position pos = me->GetNearPosition(15.0f, frand(0.0f, 2 * M_PI));
                me->GetMotionMaster()->MovePoint(0, pos);
                me->DespawnOrUnsummon(me->GetSplineDuration());
            });
        }
    }

    void UpdateAI(uint32 diff) override
    {
        scheduler.Update(diff);

        if (!UpdateVictim())
            return;

        DoMeleeAttackIfReady();
    }
};

// Bandage 72925
class spell_barrens_bandage : public SpellScript
{
    PrepareSpellScript(spell_barrens_bandage);

    void HandleEffectHit(SpellEffIndex /*effIndex*/)
    {
        if (Player* caster = GetCaster()->ToPlayer())
        {
            if (Creature* target = GetHitCreature())
            {
                if (target->GetEntry() == NPC_WOUNDED_DEFENDER)
                {
                    target->AI()->SetGUID(caster->GetGUID());
                    target->AI()->DoAction(ACTION_HEALED_BY_BANDAGE);
                }
            }
        }
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_barrens_bandage::HandleEffectHit, EFFECT_0, SPELL_EFFECT_DUMMY);
    }
};

enum Echeyakee
{
    QUEST_ECHEYAKEE         = 881,
    NPC_ECHEYAKEE           = 3475,
};

// 13481 - Tame Beast (the effect spell 1515 triggers when the 10 s tame channel completes; Spell::EffectTameCreature)
// What the player sees (sourced: the quest log text of 881 "Slay or subdue him"; Wowhead 881 comments 2010-11-24 [+47],
// 2011-01-04, 2011-03-05, 2011-05-26, 2011-06-04 that taming him counted - several 2011 replies say it did not, the quest text
// decides, plan question 8): a hunter who tames Echeyakee with Echeyakee (881) in progress gets "Conquer Echeyakee" done, as if
// he had killed him; his group gets nothing for a tame. Only a tame that really made a pet counts: the hunter had no pet before
// the effect and has a pet of entry 3475 after it (EffectTameCreature returns early with a pet out, a full stable, etc.). Every
// other tame is untouched. Ours: the hook point (a SpellScript here rather than a core edit).
class spell_barrens_tame_echeyakee : public SpellScript
{
    PrepareSpellScript(spell_barrens_tame_echeyakee);

    void RecordTarget()
    {
        _hadPet = !GetCaster()->GetPetGUID().IsEmpty();
        Creature* target = GetHitCreature();
        _isEcheyakee = target && target->GetEntry() == NPC_ECHEYAKEE;
    }

    void CreditTame()
    {
        if (_hadPet || !_isEcheyakee)
            return;

        Player* player = GetCaster()->ToPlayer();
        if (!player || player->GetQuestStatus(QUEST_ECHEYAKEE) != QUEST_STATUS_INCOMPLETE)
            return;

        Pet* pet = player->GetPet();
        if (!pet || pet->GetEntry() != NPC_ECHEYAKEE)
            return;

        player->KilledMonsterCredit(NPC_ECHEYAKEE);
    }

    void Register() override
    {
        BeforeHit += SpellHitFn(spell_barrens_tame_echeyakee::RecordTarget);
        AfterHit += SpellHitFn(spell_barrens_tame_echeyakee::CreditTame);
    }

private:
    bool _hadPet = true;
    bool _isEcheyakee = false;
};

void AddSC_the_barrens()
{
    new npc_wizzlecrank_shredder();
    new npc_razormane_pillager();
    new spell_script<spell_groldom_net>("spell_groldom_net");
    new aura_script<spell_snared_in_net>("spell_snared_in_net");
    new AreaTrigger_at_groldom_farm();
    new creature_script<npc_barrent_wounded_defender>("npc_barrent_wounded_defender");
    new spell_script<spell_barrens_bandage>("spell_barrens_bandage");
    new spell_script<spell_barrens_tame_echeyakee>("spell_barrens_tame_echeyakee");
}
