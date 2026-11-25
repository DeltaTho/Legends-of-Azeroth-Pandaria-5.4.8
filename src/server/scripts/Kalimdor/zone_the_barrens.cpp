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
#include "Map.h"
#include "MapManager.h"
#include "SmartScriptMgr.h"
#include "Group.h"
#include "MotionMaster.h"
#include "ObjectAccessor.h"
#include "GameObject.h"
#include "SpellMgr.h"
#include "CreatureTextMgr.h"

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

            // Only a netted pillager can be pounded (the net gives it the gossip flag, see spell_snared_in_net)
            if (player->GetQuestStatus(QUEST_DRAG_IT_OUT_OF_THEM) != QUEST_STATUS_INCOMPLETE || !creature->HasAura(SPELL_SNARED_IN_NET))
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
// The gossip flag (the "pound it" option) exists only while the net holds: both TDBs have npcflag 0 on 34503, and a hostile
// pillager that always carried GOSSIP opened gossip on right-click instead of being attacked (play test 2026-11-24, 13973).
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
        owner->SetFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
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

        owner->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_GOSSIP);
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

/*######
## A Growing Problem (13988): Tonga's Eyes 34615 at Thunderhead Summit
######*/

enum AGrowingProblem
{
    QUEST_A_GROWING_PROBLEM         = 13988,
    NPC_TONGAS_SPIRIT               = 34623,
    NPC_SUMMIT_CREDIT               = 34631,   // "Tonga's Eyes Taken to Summit"
    GO_THUNDERHEAD_SUMMIT           = 195146,  // the summit circle's focus (type 8, radius 10), at the retail POI
    SPELL_SUMMON_TONGAS_SPIRIT      = 65763,   // only for its spell_target_position (the spirit is summoned private, below)
    SPELL_SUMMIT_QUEST_CREDIT       = 65773,   // KILL_CREDIT 34631 on the caster's master

    TALK_EAGLE_CALLS_OUT            = 0,       // BT 34863 "Tonga's eagle calls out, then circles toward the peak."
    TALK_SPIRIT_WELL_DONE           = 0,       // BT 34864
    TALK_SPIRIT_DEVASTATION         = 1,       // BT 34865
    TALK_SPIRIT_SOUTH               = 2,       // BT 34866
    TALK_SPIRIT_FLORA               = 3,       // BT 34867 (the wiki gives all five lines to the spirit)
    TALK_SPIRIT_INVESTIGATE         = 4,       // BT 34868

    EVENT_EYES_CHECK                = 1,
    EVENT_EYES_SPIRIT               = 2,
    EVENT_EYES_LINE_1               = 3,
    EVENT_EYES_LINE_2               = 4,
    EVENT_EYES_LINE_3               = 5,
    EVENT_EYES_LINE_4               = 6,
    EVENT_EYES_LINE_5               = 7,
    EVENT_EYES_LAND                 = 8,
    EVENT_EYES_END                  = 9,

    POINT_EYES_CIRCLE               = 1,
    POINT_EYES_LAND                 = 2,
};

static constexpr float EYES_TRIGGER_RANGE   = 10.0f;   // "the eagle itself must be near the banner" (the focus radius 10)
static constexpr float EYES_CIRCLE_RADIUS   = 8.0f;
static constexpr float EYES_CIRCLE_HEIGHT   = 7.0f;
static constexpr uint32 EYES_CIRCLE_POINTS  = 6;
static constexpr float EYES_ABORT_RANGE     = 80.0f;
static Position const TongasSpiritPos = { -1481.44f, -3292.72f, 210.767f, 0.0f };   // 65763's spell_target_position

// What the player sees (sourced: Wowhead 13988 comments 2010-07-07 beta, 2011-01-14 [+20], 2012-02-19 [+214] and replies,
// 2013-04-04 [+9], 2014-02-09; broadcast texts 34863-34868; video k9qcPVg-bv8 (2014-07-22, 5.4.8) in research\northern-barrens\
// second-pass.md: the eagle flies with the player, the spirit appears beside the circle and says "Well done, friend!", and the
// quest is complete within ~10 s of the spirit appearing): Tonga's eagle follows the player; when it reaches the summit circle
// (totems and banner, GO 195146) with the quest in progress it calls out (personal emote), flies one circle round the banner,
// and a ghostly Tonga appears at the circle; the objective completes as he appears (65773, a kill credit, so the group shares
// it); Tonga surveys the devastation in five lines (the wiki: all his), the eagle lands by the spirit and both go.
// The eagle flies all the way (creature_template_movement Flight 1; the video shows it flying with the player).
// Ours: the circle's size, height and timing, the 4.5 s between lines, the lines personal (TextRange 5), the spirit private to the player (65763 would
// put a public ghost on the summit for every player's scene), the eagle immune and passive, and the eagle leaving as soon as
// 13988 is no longer in the log (abandon) - it otherwise lives its hour.
struct npc_tonga_eyes : public ScriptedAI
{
    npc_tonga_eyes(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (summoner->GetTypeId() != TYPEID_PLAYER)
            return;

        _ownerGUID = summoner->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        _events.Reset();
        _events.ScheduleEvent(EVENT_EYES_CHECK, 1s);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }

    // Out of the scene an evade only sends it back to its owner (CreatureAI::EnterEvadeMode follows the owner)
    void EnterEvadeMode(EvadeReason why) override
    {
        if (_inScene)
            return;
        ScriptedAI::EnterEvadeMode(why);
    }

    Player* GetOwnerPlayer() const
    {
        return ObjectAccessor::GetPlayer(*me, _ownerGUID);
    }

    Creature* GetSpirit() const
    {
        return ObjectAccessor::GetCreature(*me, _spiritGUID);
    }

    void SayTo(Creature* speaker, uint8 group)
    {
        if (speaker)
            if (Player* owner = GetOwnerPlayer())
                sCreatureTextMgr->SendChat(speaker, group, owner);
    }

    void StartScene(GameObject* summit)
    {
        _inScene = true;
        _circleCenter = summit->GetPosition();
        SayTo(me, TALK_EAGLE_CALLS_OUT);

        // One circle round the banner, starting on the eagle's side of it
        float const start = summit->GetAngle(me);
        _circle.clear();
        for (uint32 i = 1; i <= EYES_CIRCLE_POINTS; ++i)
        {
            float const angle = Position::NormalizeOrientation(start + float(i) * 2.0f * float(M_PI) / float(EYES_CIRCLE_POINTS));
            _circle.emplace_back(_circleCenter.GetPositionX() + EYES_CIRCLE_RADIUS * std::cos(angle),
                _circleCenter.GetPositionY() + EYES_CIRCLE_RADIUS * std::sin(angle), _circleCenter.GetPositionZ() + EYES_CIRCLE_HEIGHT);
        }
        _nextPoint = 0;

        me->GetMotionMaster()->Clear();
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        MoveNextCirclePoint();
    }

    void MoveNextCirclePoint()
    {
        if (_nextPoint >= _circle.size())
        {
            _events.ScheduleEvent(EVENT_EYES_SPIRIT, 200ms);
            return;
        }
        Position const& pos = _circle[_nextPoint];
        me->GetMotionMaster()->MovePoint(POINT_EYES_CIRCLE, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), false);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type == POINT_MOTION_TYPE && id == POINT_EYES_CIRCLE && _inScene && !_ended)
        {
            ++_nextPoint;
            MoveNextCirclePoint();
        }
    }

    void SummonSpiritAndCredit()
    {
        Player* owner = GetOwnerPlayer();
        if (!owner)
        {
            End();
            return;
        }

        Position pos = TongasSpiritPos;
        if (SpellTargetPosition const* target = sSpellMgr->GetSpellTargetPosition(SPELL_SUMMON_TONGAS_SPIRIT, EFFECT_0))
            pos.Relocate(target->target_X, target->target_Y, target->target_Z);
        pos.SetOrientation(pos.GetAngle(owner));

        if (TempSummon* spirit = me->SummonCreature(NPC_TONGAS_SPIRIT, pos, TEMPSUMMON_TIMED_DESPAWN, 60s, 0, _ownerGUID))
        {
            _spiritGUID = spirit->GetGUID();
            spirit->SetReactState(REACT_PASSIVE);
        }

        // The credit comes with the spirit. 65773 targets the caster's master (Spell.cpp TARGET_UNIT_MASTER ->
        // GetCharmerOrOwner); should it find nobody, the owner is credited directly.
        me->CastSpell(me, SPELL_SUMMIT_QUEST_CREDIT, true);
        if (owner->GetQuestStatus(QUEST_A_GROWING_PROBLEM) == QUEST_STATUS_INCOMPLETE)
            owner->KilledMonsterCredit(NPC_SUMMIT_CREDIT);

        _events.ScheduleEvent(EVENT_EYES_LINE_1, 2s);
        _events.ScheduleEvent(EVENT_EYES_LINE_2, 6500ms);
        _events.ScheduleEvent(EVENT_EYES_LINE_3, 11s);
        _events.ScheduleEvent(EVENT_EYES_LINE_4, 15500ms);
        _events.ScheduleEvent(EVENT_EYES_LINE_5, 20s);
        _events.ScheduleEvent(EVENT_EYES_LAND, 23s);
        _events.ScheduleEvent(EVENT_EYES_END, 27s);
    }

    void UnsummonSpirit()
    {
        if (Creature* spirit = GetSpirit())
            if (TempSummon* summon = spirit->ToTempSummon())
                summon->UnSummon();
        _spiritGUID.Clear();
    }

    // Every end: the spirit and the eagle go
    void End()
    {
        if (_ended)
            return;
        _ended = true;
        _events.Reset();
        UnsummonSpirit();
        me->DespawnOrUnsummon();
    }

    // The hour running out, the owner's death or logout (his guardians go with him), a new totem use (same slot)
    void Unsummoned() override
    {
        UnsummonSpirit();
    }

    void JustDied(Unit* /*killer*/) override
    {
        UnsummonSpirit();
    }

    void UpdateAI(uint32 diff) override
    {
        if (_ended)
            return;

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_EYES_CHECK:
                {
                    _events.ScheduleEvent(EVENT_EYES_CHECK, 1s);
                    Player* owner = GetOwnerPlayer();
                    if (!owner || !owner->IsInWorld())
                    {
                        End();
                        return;
                    }

                    if (_inScene)
                    {
                        // The scene is the owner's: it stops if he leaves or dies
                        if (!owner->IsAlive() || owner->GetMapId() != me->GetMapId() || owner->GetDistance(me) > EYES_ABORT_RANGE)
                        {
                            End();
                            return;
                        }
                        break;
                    }

                    QuestStatus const status = owner->GetQuestStatus(QUEST_A_GROWING_PROBLEM);
                    if (status == QUEST_STATUS_NONE || status == QUEST_STATUS_REWARDED)
                    {
                        End();   // abandoned (or a totem kept after the turn-in)
                        return;
                    }

                    if (status == QUEST_STATUS_INCOMPLETE)
                        if (GameObject* summit = me->FindNearestGameObject(GO_THUNDERHEAD_SUMMIT, EYES_TRIGGER_RANGE))
                            StartScene(summit);
                    break;
                }
                case EVENT_EYES_SPIRIT:
                    SummonSpiritAndCredit();
                    break;
                case EVENT_EYES_LINE_1:
                    SayTo(GetSpirit(), TALK_SPIRIT_WELL_DONE);
                    break;
                case EVENT_EYES_LINE_2:
                    SayTo(GetSpirit(), TALK_SPIRIT_DEVASTATION);
                    break;
                case EVENT_EYES_LINE_3:
                    SayTo(GetSpirit(), TALK_SPIRIT_SOUTH);
                    break;
                case EVENT_EYES_LINE_4:
                    SayTo(GetSpirit(), TALK_SPIRIT_FLORA);
                    break;
                case EVENT_EYES_LINE_5:
                    SayTo(GetSpirit(), TALK_SPIRIT_INVESTIGATE);
                    break;
                case EVENT_EYES_LAND:
                    // The eagle comes down beside the spirit ("landed with the spirit", 2012-02-19 replies)
                    if (Creature* spirit = GetSpirit())
                    {
                        Position land = spirit->GetNearPosition(2.0f, float(M_PI) / 2.0f);
                        me->GetMotionMaster()->MovePoint(POINT_EYES_LAND, land.GetPositionX(), land.GetPositionY(), spirit->GetPositionZ(), false);
                    }
                    break;
                case EVENT_EYES_END:
                    End();
                    return;
                default:
                    break;
            }
            if (_ended)
                return;
        }
    }

private:
    EventMap _events;
    ObjectGuid _ownerGUID;
    ObjectGuid _spiritGUID;
    Position _circleCenter;
    std::vector<Position> _circle;
    size_t _nextPoint = 0;
    bool _inScene = false;
    bool _ended = false;
};

/*######
## King of Centaur Mountain (13995): Gorgal Angerscar 34634, his banner and Kurak 34635
######*/

enum KingOfCentaurMountain
{
    QUEST_KING_OF_CENTAUR_MOUNTAIN  = 13995,
    NPC_KURAK                       = 34635,
    NPC_SHOE                        = 34638,
    NPC_KOLKAR_BLOODCHARGER         = 3397,    // the wave make-up is ours (plan Q12; the video shows 2-3 Kolkar at a time, types
    NPC_KOLKAR_STORMER              = 3273,    // not legible): the Kolkar of the Stagnant Oasis below the hill; a Stormer "hurts
    NPC_KOLKAR_WRANGLER             = 3272,    // him most" (2011 comment); no Pack Runner. 3397's own Verog death rows (ids 2-3)
                                               // are handed to S1, which deletes 3274's (review round 1, W2)
    GO_HORDE_BANNER                 = 195148,

    SPELL_PLANT_HORDE_BANNER        = 65804,   // GO 195148 in front of him, 150 s (his template spell2)
    SPELL_GORGAL_MORTAL_STRIKE      = 16856,   // template spell1
    SPELL_GORGAL_WHIRLWIND          = 15578,   // template spell4

    BT_KOLKAR_FLEES                 = 34894,   // "%s flees in terror as Kurak falls."

    TALK_GORGAL_ACCEPT              = 0,       // BT 34877 "Hah, yes $n! That's what I want to hear. Let's make some noise!"
    TALK_GORGAL_BANNER              = 1,       // BT 34878 (yell) "Come get some, you horsefaced maggot farms!"
    TALK_GORGAL_MORE                = 2,       // BT 34879 "More.... More!"
    TALK_GORGAL_TARGET              = 3,       // BT 34881 "Ah, there's our target. I can smell him from here."
    TALK_GORGAL_VICTORY             = 4,       // BT 34882 "Victory!"
    TALK_GORGAL_SHOE                = 5,       // BT 34893 "Wait 'til Shoe hears about THIS."
    TALK_GORGAL_BICKER              = 6,       // BT 34891 "Bah! Perhaps I WANT to be seen? I tire of skulking."
    TALK_SHOE_BICKER                = 0,       // BT 34890 "Quit your pacing, mon! You're gonna be seen."

    EVENT_GORGAL_CHECK              = 1,
    EVENT_GORGAL_WAVE_1             = 2,
    EVENT_GORGAL_WAVE_2             = 3,
    EVENT_GORGAL_WAVE_3             = 4,
    EVENT_GORGAL_KURAK              = 5,
    EVENT_GORGAL_SHOE_LINE          = 6,
    EVENT_GORGAL_GO_HOME            = 7,
    EVENT_GORGAL_MORTAL_STRIKE      = 8,
    EVENT_GORGAL_WHIRLWIND          = 9,
    EVENT_GORGAL_BICKER             = 10,
    EVENT_GORGAL_BICKER_REPLY       = 11,
    EVENT_GORGAL_TIMEOUT            = 12,
    EVENT_GORGAL_FLAGS_FALLBACK     = 13,

    POINT_GORGAL_BANNER             = 1,
    POINT_GORGAL_HOME               = 2,
};

// The static banner 183493 (a sniff copy of 65804's object) stood at (-1196.85, -2912.18, 118.02) facing 2.41: Gorgal stands 2 yd
// behind that spot facing the same way, so the banner he plants lands about where the sniff saw it.
static Position const GorgalBannerStandPos = { -1195.36f, -2913.52f, 117.08f, 2.407f };
// The Kolkar come up from the oasis at the foot of the hill (ours). Kurak starts where the static Kurak's sniffed path began
// (guid 310960, from -1154.8,-2956.8 up to -1180.0,-2931.9) and comes up the hill at Gorgal, so the fight is a few yards
// downhill of the banner (the video); review round 1 (walk M2): he no longer appears out of nothing below the banner.
static Position const KolkarWaveSpawnPos[3] =
{
    { -1150.0f, -2925.0f, 93.50f, 2.6f },
    { -1158.0f, -2945.0f, 93.81f, 2.4f },
    { -1163.0f, -2903.0f, 93.68f, 3.0f },
};
static Position const KurakArrivalPos = { -1154.81f, -2956.84f, 93.59f, 2.36f };

static constexpr float GORGAL_ABORT_RANGE = 80.0f;
static constexpr float GORGAL_CREDIT_RANGE = 74.0f;   // the core's group kill-credit distance (KillRewarder)

// What the player sees (sourced: Wowhead 13995 comments 2010-07-07 beta [+6], 2010-12-11 [+4], 2011-01-09, 2011-09-05,
// 2012-01-19, 2012-08-19; the wiki's lines; broadcast texts 34877-34893; video q1U-6HUmuwg (5.4.8, second-pass.md: banner at
// ~0:17, 2-3 Kolkar at a time for ~65 s with Gorgal's lines at ~0:26, 0:44 and 1:04, then Kurak a few yards downhill, dead by
// ~1:30, Gorgal's last line ~1:34)): on accept Gorgal says "Hah, yes $n! ... Let's make some noise!", stops offering the quest
// and runs up the hill by the oasis, plants a Horde banner and yells "Come get some, you horsefaced maggot farms!". Kolkar
// come up from the oasis two or three at a time and attack him (and you); "More.... More!"; then "Ah, there's our target. I can
// smell him from here." and Kurak comes up the hill from the oasis and is fought a few yards below the banner. When Kurak falls the Kolkar still standing flee in
// terror, Gorgal says "Victory!" and "Wait 'til Shoe hears about THIS.", and walks back down to his spot; the banner goes.
// Leaving him (80 yd), dying, abandoning, or 4 minutes without Kurak dead ends it the same way and the quest stays incomplete
// (sourced: "if you leave the quest giver vanishes", "abandon and redo it"). Out of the event, now and then Shoe tells him to
// quit his pacing and he answers (comment 2010-11-23 [+18], broadcast 34890 / 34891).
// Ours: wave make-up and spawn points (waves at +2, +18 and +30 s after the banner, Kurak at +38 s, from the video's timings),
// his Mortal Strike / Whirlwind timers (his template spells), the 80 yd / 4 min limits, the bicker interval (2.5-4 min, only
// with a player within 30 yd), and Kurak's kill credited by script to the starter and his group members within 74 yd who have
// the quest (Gorgal's damage would otherwise cost them the kill: Unit::Kill gives no credit for a creature NPCs wore down).
struct npc_gorgal_angerscar : public ScriptedAI
{
    npc_gorgal_angerscar(Creature* creature) : ScriptedAI(creature), _summons(creature) { }

    void Reset() override
    {
        // An evade during the event (between waves) keeps the event: he walks back to the banner (his home while it runs)
        if (_running)
            return;

        _events.Reset();
        me->SetReactState(REACT_DEFENSIVE);
        _events.ScheduleEvent(EVENT_GORGAL_BICKER, Seconds(urand(150, 240)));
    }

    void OnQuestAccept(Player* player, Quest const* quest) override
    {
        if (quest->GetQuestId() != QUEST_KING_OF_CENTAUR_MOUNTAIN || _running)
            return;

        _running = true;
        _atBanner = false;
        _kurakDead = false;
        _playerGUID = player->GetGUID();
        _spawnHome = me->GetHomePosition();   // his spot while idle
        _events.Reset();
        _summons.DespawnAll();

        me->RemoveNpcFlag(NPCFlags(UNIT_NPC_FLAG_QUESTGIVER | UNIT_NPC_FLAG_GOSSIP));
        me->SetReactState(REACT_PASSIVE);   // no detours on the way up
        // Home is the banner from the start: an evade on the way up (something engaged him) takes him there too, and
        // JustReachedHome plants the banner (review round 1, M1: he used to go back down and stall until the timeout)
        me->SetHomePosition(GorgalBannerStandPos);
        Talk(TALK_GORGAL_ACCEPT, player);
        me->SetWalk(false);
        me->GetMotionMaster()->MovePoint(POINT_GORGAL_BANNER, GorgalBannerStandPos);

        _events.ScheduleEvent(EVENT_GORGAL_CHECK, 1s);
        _events.ScheduleEvent(EVENT_GORGAL_TIMEOUT, 4min);
    }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type != POINT_MOTION_TYPE)
            return;

        if (id == POINT_GORGAL_BANNER)
            ArriveAtBanner();
        else if (id == POINT_GORGAL_HOME && !_running)
            BackHome();
    }

    void ArriveAtBanner()
    {
        if (!_running || _atBanner)
            return;

        _atBanner = true;
        me->SetFacingTo(GorgalBannerStandPos.GetOrientation());
        DoCast(me, SPELL_PLANT_HORDE_BANNER, true);
        // 65804 summons a wild object (SpellEffects.cpp SUMMON_OBJECT_WILD): it has no owner, so RemoveGameObject cannot find
        // it. Remember it to take it away at the end (review round 1, walk M1)
        if (GameObject* banner = me->FindNearestGameObject(GO_HORDE_BANNER, 10.0f))
            _bannerGUID = banner->GetGUID();
        Talk(TALK_GORGAL_BANNER);
        me->SetReactState(REACT_AGGRESSIVE);
        _events.ScheduleEvent(EVENT_GORGAL_WAVE_1, 2s);
        _events.ScheduleEvent(EVENT_GORGAL_WAVE_2, 18s);
        _events.ScheduleEvent(EVENT_GORGAL_WAVE_3, 30s);
        _events.ScheduleEvent(EVENT_GORGAL_KURAK, 38s);
    }

    void RemoveBanner()
    {
        if (GameObject* banner = ObjectAccessor::GetGameObject(*me, _bannerGUID))
            banner->Delete();
        _bannerGUID.Clear();
    }

    // MoveTargetedHome ends here instead of at a point: on the way up (an evade; home is the banner) and on the way down
    void JustReachedHome() override
    {
        if (_running && !_atBanner)
            ArriveAtBanner();
        else if (!_running && _returning)
            BackHome();
    }

    void BackHome()
    {
        _returning = false;
        _events.CancelEvent(EVENT_GORGAL_FLAGS_FALLBACK);
        me->SetFacingTo(_spawnHome.GetOrientation());
        me->SetNpcFlag(NPCFlags(me->GetCreatureTemplate()->npcflag & (UNIT_NPC_FLAG_QUESTGIVER | UNIT_NPC_FLAG_GOSSIP)));
    }

    void SummonKolkar(uint32 entry, uint32 spot)
    {
        Position pos = KolkarWaveSpawnPos[spot % 3];
        pos.Relocate(pos.GetPositionX() + frand(-3.0f, 3.0f), pos.GetPositionY() + frand(-3.0f, 3.0f), pos.GetPositionZ());
        me->SummonCreature(entry, pos, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 60s);
    }

    void JustSummoned(Creature* summon) override
    {
        _summons.Summon(summon);
        if (summon->IsAIEnabled)
            summon->AI()->AttackStart(me);
    }

    void SummonedCreatureDespawn(Creature* summon) override
    {
        _summons.Despawn(summon);
    }

    void SummonedCreatureDies(Creature* summon, Unit* /*killer*/) override
    {
        if (summon->GetEntry() != NPC_KURAK || !_running || _kurakDead)
            return;

        _kurakDead = true;
        CreditKurak(summon);

        // The Kolkar still standing flee in terror (BT 34894) and are gone a few seconds later
        for (ObjectGuid const& guid : _summons)
            if (Creature* kolkar = ObjectAccessor::GetCreature(*me, guid))
                if (kolkar->IsAlive() && kolkar->GetEntry() != NPC_KURAK)
                {
                    kolkar->TextEmote(BT_KOLKAR_FLEES);
                    kolkar->SetReactState(REACT_PASSIVE);
                    kolkar->CombatStop(true);
                    kolkar->GetMotionMaster()->Clear();
                    kolkar->GetMotionMaster()->MoveFleeing(me, 5000);
                    kolkar->DespawnOrUnsummon(5000);
                }

        _events.CancelEvent(EVENT_GORGAL_TIMEOUT);
        _events.CancelEvent(EVENT_GORGAL_WAVE_1);
        _events.CancelEvent(EVENT_GORGAL_WAVE_2);
        _events.CancelEvent(EVENT_GORGAL_WAVE_3);
        Talk(TALK_GORGAL_VICTORY);
        _events.ScheduleEvent(EVENT_GORGAL_SHOE_LINE, 4s);
        _events.ScheduleEvent(EVENT_GORGAL_GO_HOME, 7s);
    }

    void CreditKurak(Creature* kurak)
    {
        Player* starter = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!starter)
            return;

        auto credit = [kurak](Player* player)
        {
            if (player && player->IsInWorld() && player->IsAlive() && player->GetMapId() == kurak->GetMapId()
                && player->GetDistance(kurak) <= GORGAL_CREDIT_RANGE
                && player->GetQuestStatus(QUEST_KING_OF_CENTAUR_MOUNTAIN) == QUEST_STATUS_INCOMPLETE)
                player->KilledMonsterCredit(NPC_KURAK, kurak->GetGUID());
        };

        if (Group* group = starter->GetGroup())
        {
            for (GroupReference* itr = group->GetFirstMember(); itr; itr = itr->next())
                credit(itr->GetSource());
        }
        else
            credit(starter);
    }

    // Ends the event: the banner goes, he walks back down and offers the quest again on arrival (or after 30 s at the latest).
    // Kurak dead: the corpses stay to be looted (they go 60 s after death; the fleeing Kolkar go by themselves). Ended early:
    // every Kolkar and Kurak go at once.
    void EndEvent(bool kurakKilled)
    {
        if (!_running)
            return;

        _running = false;
        _atBanner = false;
        _returning = true;
        _events.Reset();
        if (!kurakKilled)
            _summons.DespawnAll();
        RemoveBanner();
        me->SetHomePosition(_spawnHome);
        me->SetReactState(REACT_DEFENSIVE);
        me->SetWalk(true);

        if (me->IsInCombat())
            EnterEvadeMode();   // home is his spot again: MoveTargetedHome, then JustReachedHome
        else
        {
            me->GetMotionMaster()->Clear();
            me->GetMotionMaster()->MovePoint(POINT_GORGAL_HOME, _spawnHome);
        }

        _events.ScheduleEvent(EVENT_GORGAL_FLAGS_FALLBACK, 30s);
        _events.CancelEvent(EVENT_GORGAL_BICKER);   // the evade's Reset may have scheduled one already (review round 1, M3)
        _events.ScheduleEvent(EVENT_GORGAL_BICKER, Seconds(urand(150, 240)));
    }

    void JustDied(Unit* /*killer*/) override
    {
        // He respawns at his spot with his flags (template); clear what the event left
        if (_running)
        {
            _summons.DespawnAll();
            RemoveBanner();
            me->SetHomePosition(_spawnHome);
        }
        _running = false;
        _returning = false;
        _events.Reset();
    }

    void JustEngagedWith(Unit* who) override
    {
        ScriptedAI::JustEngagedWith(who);
        _events.CancelEvent(EVENT_GORGAL_MORTAL_STRIKE);   // one chain each, however often he engages
        _events.CancelEvent(EVENT_GORGAL_WHIRLWIND);
        _events.ScheduleEvent(EVENT_GORGAL_MORTAL_STRIKE, Seconds(urand(4, 7)));
        _events.ScheduleEvent(EVENT_GORGAL_WHIRLWIND, Seconds(urand(10, 14)));
    }

    bool StarterStillWithMe() const
    {
        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        return player && player->IsInWorld() && player->IsAlive() && player->GetMapId() == me->GetMapId()
            && player->GetDistance(me) <= GORGAL_ABORT_RANGE
            && player->GetQuestStatus(QUEST_KING_OF_CENTAUR_MOUNTAIN) == QUEST_STATUS_INCOMPLETE;
    }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_GORGAL_CHECK:
                    // Until Kurak is dead the event is the starter's: gone, dead, 80 yd away or quest dropped -> it ends
                    if (_running && !_kurakDead && !StarterStillWithMe())
                    {
                        EndEvent(false);
                        return;
                    }
                    if (_running)
                        _events.ScheduleEvent(EVENT_GORGAL_CHECK, 1s);
                    break;
                case EVENT_GORGAL_TIMEOUT:
                    EndEvent(false);
                    return;
                case EVENT_GORGAL_FLAGS_FALLBACK:
                    if (!_running && _returning)
                        BackHome();
                    break;
                case EVENT_GORGAL_WAVE_1:
                    SummonKolkar(NPC_KOLKAR_BLOODCHARGER, 0);
                    SummonKolkar(NPC_KOLKAR_WRANGLER, 1);
                    break;
                case EVENT_GORGAL_WAVE_2:
                    Talk(TALK_GORGAL_MORE);
                    SummonKolkar(NPC_KOLKAR_BLOODCHARGER, 2);
                    SummonKolkar(NPC_KOLKAR_STORMER, 0);
                    SummonKolkar(NPC_KOLKAR_WRANGLER, 1);
                    break;
                case EVENT_GORGAL_WAVE_3:
                    SummonKolkar(NPC_KOLKAR_STORMER, 1);
                    SummonKolkar(NPC_KOLKAR_BLOODCHARGER, 2);
                    break;
                case EVENT_GORGAL_KURAK:
                    Talk(TALK_GORGAL_TARGET);
                    me->SummonCreature(NPC_KURAK, KurakArrivalPos, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 60s);
                    break;
                case EVENT_GORGAL_SHOE_LINE:
                    Talk(TALK_GORGAL_SHOE);
                    break;
                case EVENT_GORGAL_GO_HOME:
                    EndEvent(true);
                    return;
                case EVENT_GORGAL_MORTAL_STRIKE:
                    if (me->IsInCombat())
                    {
                        DoCastVictim(SPELL_GORGAL_MORTAL_STRIKE);
                        _events.ScheduleEvent(EVENT_GORGAL_MORTAL_STRIKE, Seconds(urand(8, 12)));
                    }
                    break;
                case EVENT_GORGAL_WHIRLWIND:
                    if (me->IsInCombat())
                    {
                        DoCast(me, SPELL_GORGAL_WHIRLWIND);
                        _events.ScheduleEvent(EVENT_GORGAL_WHIRLWIND, Seconds(urand(15, 20)));
                    }
                    break;
                case EVENT_GORGAL_BICKER:
                    _events.ScheduleEvent(EVENT_GORGAL_BICKER, Seconds(urand(150, 240)));
                    if (!_running && !me->IsInCombat() && me->FindNearestPlayer(30.0f))
                        if (Creature* shoe = me->FindNearestCreature(NPC_SHOE, 30.0f))
                        {
                            sCreatureTextMgr->SendChat(shoe, TALK_SHOE_BICKER);
                            _events.ScheduleEvent(EVENT_GORGAL_BICKER_REPLY, 4s);
                        }
                    break;
                case EVENT_GORGAL_BICKER_REPLY:
                    if (!_running && !me->IsInCombat())
                        Talk(TALK_GORGAL_BICKER);
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
    EventMap _events;
    SummonList _summons;
    ObjectGuid _playerGUID;
    ObjectGuid _bannerGUID;
    Position _spawnHome;
    bool _running = false;
    bool _atBanner = false;
    bool _kurakDead = false;
    bool _returning = false;
};

/*######
## The Short Way Home (29094): a rider who logged out on the Silver Bullet X-831
######*/

enum SilverBullet
{
    SILVER_BULLET_PATH              = 52201,   // the flying rocket's SmartAI waypoints (`waypoints`), Nozzlepot's Outpost to Darsok
};

// Beside the parked rocket behind Sputtervalve (ours: on the ground, 6.5 yd from the parked rocket 52203, facing it)
static Position const SilverBulletLaunchGround = { 1145.0f, -3375.0f, 92.40f, 1.9f };
// 5 yd, not the Bogpaddle Bullet's 25: the Silver Bullet climbs out of Nozzlepot's and comes down by Darsok slowly, so a rider
// saved on the first or last legs is only a few yards up and fell at login (review round 1, walk M11). Ground and roofs are
// vmaps, so nobody standing anywhere is 5 yd above what GetWaterOrGroundLevel returns.
static constexpr float SILVER_BULLET_MIN_HEIGHT = 5.0f;

static float DistToSilverBulletSegment(Position const& p, Position const& a, Position const& b)
{
    float const dx = b.GetPositionX() - a.GetPositionX(), dy = b.GetPositionY() - a.GetPositionY(), dz = b.GetPositionZ() - a.GetPositionZ();
    float const len2 = dx * dx + dy * dy + dz * dz;
    float t = 0.0f;
    if (len2 > 0.0f)
        t = std::max(0.0f, std::min(1.0f, ((p.GetPositionX() - a.GetPositionX()) * dx + (p.GetPositionY() - a.GetPositionY()) * dy
            + (p.GetPositionZ() - a.GetPositionZ()) * dz) / len2));
    Position const q(a.GetPositionX() + dx * t, a.GetPositionY() + dy * t, a.GetPositionZ() + dz * t);
    return p.GetExactDist(&q);
}

// Within range (3D) of the rocket's flight, read from its waypoints so a route change in the DB is followed
static bool IsNearSilverBulletPath(Position const& pos, float range)
{
    WPPath const* path = sSmartWaypointMgr->GetPath(SILVER_BULLET_PATH);
    if (!path || path->empty())
        return false;

    std::vector<uint32> ids;
    for (auto const& node : *path)
        ids.push_back(node.first);
    std::sort(ids.begin(), ids.end());

    Position prev = SilverBulletLaunchGround;
    for (uint32 id : ids)
    {
        WayPoint const* wp = path->at(id);
        Position const next(wp->x, wp->y, wp->z);
        if (DistToSilverBulletSegment(pos, prev, next) <= range)
            return true;
        prev = next;
    }
    return false;
}

// Backport D1 (research\_prior-region-backports.md), checked in code: the rocket boards as it is - Gyrotilt takes seat 0 when
// the rocket enters the world (Creature::AddToWorld -> AIM_Initialize -> Vehicle::Reset -> InstallAllAccessories), and the
// clicker's Ride Vehicle Hardcoded (seat -1) then finds seat 1: VehicleSeat 9760 has flagsB 0x02000000
// (VEHICLE_SEAT_FLAG_B_USABLE_FORCED_4), so IsUsableByOverride holds for Vehicle::AddPassenger and GetAvailableSeatCount
// (Aura::CanStackWith keeps Gyrotilt's aura). Unlike the Badlands rocket's seat 9199, nothing needs scripting there.
// What it lacked is a way down for a rider who logs out in flight: the rocket (his Minion) goes with him and he is saved in
// mid-air on the route, to fall at his next login. Before he enters the world he is moved to the ground beside the parked
// rocket - only when all hold: map 1; no mount, flight or mounted-flight aura; within 40 yd of the rocket's route; 5 yd or
// more above the ground or water below him (vmaps counted). The ride's credit comes at its end, so he rides again (the parked
// rocket is visible to him while 29094 is in his log). Ours (no source says what retail did), as player_sos_bogpaddle_bullet.
class player_barrens_silver_bullet : public PlayerScript
{
public:
    player_barrens_silver_bullet() : PlayerScript("player_barrens_silver_bullet") { }

    void OnLoadFromDB(Player* player) override
    {
        if (player->GetMapId() != 1 || player->HasAuraType(SPELL_AURA_MOUNTED) || player->HasAuraType(SPELL_AURA_FLY)
            || player->HasAuraType(SPELL_AURA_MOD_INCREASE_MOUNTED_FLIGHT_SPEED))
            return;

        // Cheap box test first: the route lies inside x -440 .. 1145, y -3370 .. -1560
        Position const pos = player->GetPosition();
        if (pos.GetPositionX() < -480.0f || pos.GetPositionX() > 1185.0f || pos.GetPositionY() < -3410.0f || pos.GetPositionY() > -1520.0f)
            return;

        if (!IsNearSilverBulletPath(pos, 40.0f))
            return;

        Map* map = sMapMgr->FindBaseNonInstanceMap(1);
        if (!map)
            return;
        float const below = map->GetWaterOrGroundLevel(PHASEMASK_NORMAL, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ());
        if (pos.GetPositionZ() < below + SILVER_BULLET_MIN_HEIGHT)
            return;

        TC_LOG_DEBUG("scripts", "player_barrens_silver_bullet: %s logged in on the Silver Bullet X-831's route at %.1f %.1f %.1f (%.1f yd up), moved to the launch",
            player->GetName().c_str(), pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), pos.GetPositionZ() - below);
        player->Relocate(SilverBulletLaunchGround);
        player->SetFallInformation(0, SilverBulletLaunchGround.GetPositionZ());
    }
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
    new creature_script<npc_tonga_eyes>("npc_tonga_eyes");
    new creature_script<npc_gorgal_angerscar>("npc_gorgal_angerscar");
    new player_barrens_silver_bullet();
}
