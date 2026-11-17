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
SDName: Burning_Steppes
SD%Complete: 0
SDComment:
SDCategory: Burning Steppes
EndScriptData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "GameObject.h"
#include "GameObjectAI.h"
#include "Player.h"
#include "Random.h"
#include "SpellScript.h"
#include "MotionMaster.h"
#include "ObjectAccessor.h"
#include "GameTime.h"
#include <unordered_map>

enum ScrappedGolemsType
{
    SPELL_CREATE_WAR_REAVER_PARTS_AB = 89413, // Sieve & Piston
    SPELL_CREATE_WAR_REAVER_PARTS_AC = 89416, // Sieve & Gearshaft
    SPELL_CREATE_WAR_REAVER_PARTS_AD = 89417, // Sieve & Core
    SPELL_CREATE_WAR_REAVER_PARTS_BC = 89418, // Piston & Gearshaft
    SPELL_UPPERCUTE                  = 10966,
    SPELL_FLAME_BLAST                = 84165,
    SPELL_BATTLE_READY               = 89353, // second defeat: Flame Blast 91313 needs it
    SPELL_WELL_HONED                 = 89352, // first defeat: Heave 91314 needs it
    SPELL_PERFECTLY_TUNNED           = 89355, // credit after this
    SPELL_HEAVE                      = 91314,
    SPELL_FLAME_BLAST_TRAIN          = 91313,

    EVENT_UPPERCUTE = 1,
    EVENT_FLAME_BLAST,

    ITEM_OBSIDIAN_PISTON             = 63333,
    ITEM_FLUX_EXHAUST_SIEVE          = 63336,
    ITEM_THORIUM_GEARSHAFT           = 63335,
    ITEM_STONE_POWER_CORE            = 63334,

    GO_PART_AB                       = 206971,
    GO_PART_AC                       = 206972,
    GO_PART_AD                       = 206973,
    GO_PART_BC                       = 206974,

    QUEST_GOLEM_TRAINING             = 28227,
    QUEST_SCRAPPED_GOLEMS            = 28226,

    ACTION_GOLEM_TRAINING = 0,

    TALK_DEFEAT_1 = 0,
    TALK_OVERRIDE,
    TALK_DEFEAT_2,
    TALK_TRAINING_SUCCESS,
};

const std::list<uint32> reaverSpellParts =
{
    SPELL_CREATE_WAR_REAVER_PARTS_AB,
    SPELL_CREATE_WAR_REAVER_PARTS_AC,
    SPELL_CREATE_WAR_REAVER_PARTS_AD,
    SPELL_CREATE_WAR_REAVER_PARTS_BC,
};

const std::map<uint32, std::array<uint32, 2>> golemParts =
{
    { GO_PART_AB, { ITEM_FLUX_EXHAUST_SIEVE,ITEM_OBSIDIAN_PISTON } },
    { GO_PART_AC, { ITEM_FLUX_EXHAUST_SIEVE, ITEM_THORIUM_GEARSHAFT } },
    { GO_PART_AD, { ITEM_FLUX_EXHAUST_SIEVE, ITEM_STONE_POWER_CORE } },
    { GO_PART_BC, { ITEM_OBSIDIAN_PISTON, ITEM_THORIUM_GEARSHAFT } },
};

// War Reaver 7039
struct npc_burning_steppes_war_reaver : public customCreatureAI
{
    npc_burning_steppes_war_reaver(Creature* creature) : customCreatureAI(creature) { }

    void Reset() override
    {
        events.Reset();
    }

    void JustEngagedWith(Unit* /*who*/) override
    {
        events.ScheduleEvent(EVENT_UPPERCUTE, 5.5 * IN_MILLISECONDS);
        events.ScheduleEvent(EVENT_FLAME_BLAST, 8 * IN_MILLISECONDS);
    }

    // Scrapped Golems 28226: every kill leaves parts (2010-11-24 reply [+16] "with every kill", 2010-12-01, 2013; one 2012 reply
    // "not always now": the less grindy reading). Was 80 %.
    void JustDied(Unit* /*killer*/) override
    {
        DoCast(me, Trinity::Containers::SelectRandomContainerElement(reaverSpellParts));
    }

    void UpdateAI(uint32 diff) override
    {
        if (!UpdateVictim())
            return;

        events.Update(diff);

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = events.ExecuteEvent())
        {
            ExecuteTargetEvent(SPELL_UPPERCUTE, 10.5 * IN_MILLISECONDS, EVENT_UPPERCUTE, eventId);
            ExecuteTargetEvent(SPELL_FLAME_BLAST, urand(12 * IN_MILLISECONDS, 15 * IN_MILLISECONDS), EVENT_FLAME_BLAST, eventId, PRIORITY_CHANNELED);
            break;
        }

        DoMeleeAttackIfReady();
    }
};

// War Reaver Parts 206971, 206972, 206973, 206974
class go_burning_steppes_war_reaver_part : public GameObjectScript
{
    public:
        go_burning_steppes_war_reaver_part() : GameObjectScript("go_burning_steppes_war_reaver_part") { }

        // The salvage options only for a player on Scrapped Golems (the object's data10 PlayerCondition 11083, which the core does
        // not read for type 2); others see the text alone.
        bool OnGossipHello(Player* player, GameObject* go) override
        {
            if (player->GetQuestStatus(QUEST_SCRAPPED_GOLEMS) == QUEST_STATUS_INCOMPLETE)
            {
                player->ADD_GOSSIP_ITEM_DB(player->GetDefaultGossipMenuForSource(go), 0, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);
                player->ADD_GOSSIP_ITEM_DB(player->GetDefaultGossipMenuForSource(go), 1, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);
            }

            player->SEND_GOSSIP_MENU(player->GetGossipTextId(go), go->GetGUID());

            return true;
        }

        bool OnGossipSelect(Player* player, GameObject* go, uint32 /*sender*/, uint32 action) override
        {
            player->PlayerTalkClass->ClearMenus();

            // Send item to player; with full bags the part stays for another try
            auto itr = golemParts.find(go->GetEntry());
            bool stored = itr != golemParts.end() && (action == GOSSIP_ACTION_INFO_DEF + 1 || action == GOSSIP_ACTION_INFO_DEF + 2)
                && player->AddItem(action == GOSSIP_ACTION_INFO_DEF + 1 ? itr->second[0] : itr->second[1], 1);

            player->CLOSE_GOSSIP_MENU();
            if (stored)
                go->Delete();

            return true;
        }
};

// Chiseled Golem 48037
class npc_burning_steppes_chiseled_golem : public CreatureScript
{
    public:
        npc_burning_steppes_chiseled_golem() : CreatureScript("npc_burning_steppes_chiseled_golem") { }

        bool OnGossipSelect(Player* player, Creature* creature, uint32 /*sender*/, uint32 action) override
        {
            player->PlayerTalkClass->ClearMenus();

            if (action == GOSSIP_ACTION_INFO_DEF + 1)
            {
                creature->AI()->SetGUID(player->GetGUID());
                creature->AI()->DoAction(ACTION_GOLEM_TRAINING);
            }

            player->CLOSE_GOSSIP_MENU();

            return true;
        }

        bool OnGossipHello(Player* player, Creature* creature) override
        {
            if (player->GetQuestStatus(QUEST_GOLEM_TRAINING) == QUEST_STATUS_INCOMPLETE)
                player->ADD_GOSSIP_ITEM_DB(player->GetDefaultGossipMenuForSource(creature), 0, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);

            player->SEND_GOSSIP_MENU(player->GetGossipTextId(creature), creature->GetGUID());
            return true;
        }

        struct npc_burning_steppes_chiseled_golemAI : public customCreatureAI
        {
            npc_burning_steppes_chiseled_golemAI(Creature* creature) : customCreatureAI(creature) { }

            TaskScheduler scheduler;
            ObjectGuid targetGUID;
            bool hasDefeat;

            void Reset() override
            {
                events.Reset();
                scheduler.CancelAll();
                targetGUID = ObjectGuid::Empty;
                hasDefeat = false;
                me->SetReactState(REACT_AGGRESSIVE);
                me->SetFaction(1474); // default
            }

            void SetGUID(ObjectGuid guid, int32 /*type*/) override
            {
                targetGUID = guid;
            }

            void DoAction(int32 actionId) override
            {
                if (actionId == ACTION_GOLEM_TRAINING)
                {
                    me->SetFaction(16);

                    if (Player* target = ObjectAccessor::GetPlayer(*me, targetGUID))
                        AttackStart(target);
                }
            }

            void DamageTaken(Unit* attacker, uint32& damage) override
            {
                if (hasDefeat)
                    damage = 0;

                if (damage >= me->GetHealth() && !hasDefeat)
                {
                    damage = 0;
                    hasDefeat = true;

                    // Golem Training 28227: defeat 1 learns Heave, defeat 2 Flame Blast (wiki; 2010-11-26 [+23]); was the other way round
                    if (!me->HasAura(SPELL_WELL_HONED))
                    {
                        me->PrepareChanneledCast(me->GetOrientation());
                        DoCast(me, SPELL_WELL_HONED);
                        Talk(TALK_DEFEAT_1);

                        scheduler
                            .Schedule(Seconds(5), [this](TaskContext context)
                        {
                            me->SetFullHealth();
                            Talk(TALK_OVERRIDE);
                            hasDefeat = false;

                            if (Player* target = ObjectAccessor::GetPlayer(*me, targetGUID))
                                me->RemoveChanneledCast(target->GetGUID());

                            events.ScheduleEvent(EVENT_UPPERCUTE, 2 * IN_MILLISECONDS);
                        });
                    }
                    else if (!me->HasAura(SPELL_BATTLE_READY))
                    {
                        me->PrepareChanneledCast(me->GetOrientation());
                        DoCast(me, SPELL_BATTLE_READY);
                        Talk(TALK_DEFEAT_2);

                        scheduler
                            .Schedule(Seconds(5), [this](TaskContext context)
                        {
                            me->SetFullHealth();
                            Talk(TALK_OVERRIDE);
                            hasDefeat = false;

                            if (Player* target = ObjectAccessor::GetPlayer(*me, targetGUID))
                                me->RemoveChanneledCast(target->GetGUID());

                            events.ScheduleEvent(EVENT_FLAME_BLAST, 2 * IN_MILLISECONDS);
                        });
                    }
                    else // training success
                    {
                        Talk(TALK_TRAINING_SUCCESS);
                        DoCast(me, SPELL_PERFECTLY_TUNNED);
                        me->PrepareChanneledCast(me->GetOrientation());

                        if (Player* target = ObjectAccessor::GetPlayer(*me, targetGUID))
                            target->KilledMonsterCredit(me->GetEntry());

                        me->DespawnOrUnsummon(4 * IN_MILLISECONDS);
                    }
                }
            }

            void JustEngagedWith(Unit* /*who*/) override { }

            // A golem left in a training fight (it leashed) leaves and comes back friendly at its respawn (2010-11-27 reply [+2]);
            // before, it stood there friendly with its training auras gone.
            void EnterEvadeMode(EvadeReason why) override
            {
                if (!targetGUID.IsEmpty())
                {
                    me->DespawnOrUnsummon();
                    return;
                }
                customCreatureAI::EnterEvadeMode(why);
            }

            void UpdateAI(uint32 diff) override
            {
                scheduler.Update(diff);

                if (!UpdateVictim())
                    return;

                events.Update(diff);

                if (me->HasUnitState(UNIT_STATE_CASTING))
                    return;

                while (uint32 eventId = events.ExecuteEvent())
                {
                    ExecuteTargetEvent(SPELL_HEAVE, 10.5 * IN_MILLISECONDS, EVENT_UPPERCUTE, eventId);
                    ExecuteTargetEvent(SPELL_FLAME_BLAST_TRAIN, urand(12 * IN_MILLISECONDS, 15 * IN_MILLISECONDS), EVENT_FLAME_BLAST, eventId, PRIORITY_CHANNELED);
                    break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* creature) const override
        {
            return new npc_burning_steppes_chiseled_golemAI(creature);
        }
};

/* A Perfect Costume (28202-28205 / 28428-28431): the Tailor's Table 206947 and Thelaron Direneedle 48001 at Black Tooth Hovel.
   What the player sees (wiki 28428 / 28431 notes and reaction tables; 28428 2012-07-01 [+6] jtbalogh; 28205 2010-11-28; 28202
   [+4]): at the table "Several piles..." -> "Investigate the hides." -> take one to four hides -> one to four handfuls of mud ->
   one to four spools of thread -> "You have gathered your supplies. Bring them to Thelaron..." (menu 12375, reached through
   gossip_menu_option 12374 ActionMenuID 12375). Thelaron: "What have ye brought me?" and "I brought you some hides, mud, and
   thread." only for a player who took all three; he checks the race recipe (orc 2-4-2, ogre 4-1-3, goblin 1-3-4, troll 3-2-1) in
   the order hides, mud, thread and says what is wrong (48235 / 48237 hides, 48238 / 48236 mud, 48239 / 48240 thread; the player
   goes back to the table), or "This... this is perfect! ..." (48241) with the Costume Credit 47910; the disguise itself comes on accepting
   Into the Black Tooth Hovel (its StartItem; 28202 reply 773680), or from Thelaron when remaking a lost one.
   The choice is per player (the old SmartAI set Thelaron's gossip flag for everybody).
   Ours: who may use the table (a costume quest in the log, or one handed in while the player has no disguise in bags or bank and
   Locked and Loaded 28327 / 28453 is not done: the remake of D11, 28202 [+6], item [+12], GM quote in 28278) - everyone else sees
   "There is nothing of interest on the table" (17382); the choice kept 10 minutes; a remake only for a player without a
   disguise, refused with the bag-full error (choice kept) when it does not fit. Bots never use the table or the gossip (playerbots list). */
enum TailorsTable
{
    GO_TAILORS_TABLE                = 206947,
    NPC_THELARON_DIRENEEDLE         = 48001,
    NPC_COSTUME_CREDIT              = 47910,
    ITEM_BLACKROCK_DISGUISE         = 63357,

    QUEST_LOCKED_AND_LOADED_A       = 28327,
    QUEST_LOCKED_AND_LOADED_H       = 28453,

    MENU_TABLE                      = 12371,
    MENU_TABLE_HIDES                = 12372,
    MENU_TABLE_MUD                  = 12373,
    MENU_TABLE_THREAD               = 12374,
    TEXT_TABLE_NOTHING              = 17382,
    TEXT_TABLE_PILES                = 17383,

    MENU_THELARON                   = 12376,
    TEXT_THELARON_GREETING          = 17394,
    TEXT_THELARON_WHAT_BROUGHT      = 17395,
    OPTION_THELARON_BROUGHT         = 0,

    SAY_THELARON_PERFECT            = 0,    // 48241
    SAY_THELARON_HIDE_TOO_LITTLE    = 1,    // 48235
    SAY_THELARON_MUD_TOO_MUCH       = 2,    // 48236
    SAY_THELARON_HIDE_TOO_MUCH      = 3,    // 48237
    SAY_THELARON_MUD_TOO_LITTLE     = 4,    // 48238
    SAY_THELARON_THREAD_TOO_LITTLE  = 5,    // 48239
    SAY_THELARON_THREAD_TOO_MUCH    = 6,    // 48240
};

static uint32 const CostumeQuests[] = { 28202, 28203, 28204, 28205, 28428, 28429, 28430, 28431 };

struct TailorsChoice
{
    uint8 Hides = 0;
    uint8 Mud = 0;
    uint8 Thread = 0;
    time_t TakenAt = 0;
};

// Per player, written by the table and read by Thelaron; both stand on map 0, so only that map's update thread touches it.
static std::unordered_map<ObjectGuid, TailorsChoice> TailorsChoices;
static time_t const TailorsChoiceExpiry = 10 * MINUTE;

static bool CanUseTailorsTable(Player* player)
{
    bool handedIn = false;
    for (uint32 questId : CostumeQuests)
    {
        if (player->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
            return true;
        if (player->IsQuestRewarded(questId))
            handedIn = true;
    }

    return handedIn && !player->HasItemCount(ITEM_BLACKROCK_DISGUISE, 1, true)
        && !player->IsQuestRewarded(QUEST_LOCKED_AND_LOADED_A) && !player->IsQuestRewarded(QUEST_LOCKED_AND_LOADED_H);
}

static TailorsChoice const* GetFullTailorsChoice(Player* player)
{
    auto itr = TailorsChoices.find(player->GetGUID());
    if (itr == TailorsChoices.end())
        return nullptr;

    if (GameTime::GetGameTime() > itr->second.TakenAt + TailorsChoiceExpiry)
    {
        TailorsChoices.erase(itr);
        return nullptr;
    }

    return itr->second.Thread ? &itr->second : nullptr;
}

// Tailor's Table 206947
struct go_burning_steppes_tailors_table : public GameObjectAI
{
    go_burning_steppes_tailors_table(GameObject* go) : GameObjectAI(go) { }

    bool OnGossipHello(Player* player, bool isUse) override
    {
        if (!isUse)
            return false;

        if (!CanUseTailorsTable(player))
        {
            player->PlayerTalkClass->ClearMenus();
            InitGossipMenuFor(player, MENU_TABLE);
            SendGossipMenuFor(player, TEXT_TABLE_NOTHING, me->GetGUID());
            return true;
        }

        player->PrepareGossipMenu(me, MENU_TABLE);
        SendGossipMenuFor(player, TEXT_TABLE_PILES, me->GetGUID());
        return true;
    }

    // Only records the choice: the menus go on through gossip_menu_option.ActionMenuID (Player::OnGossipSelect runs after this).
    bool OnGossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
    {
        // The menu id comes from the packet, for any object on the map: only the menu this player has open, in reach of the
        // table, and only while he may use it
        if (player->PlayerTalkClass->GetGossipMenu().GetMenuId() != menuId || !me->IsAtInteractDistance(player)
            || !CanUseTailorsTable(player))
            return false;

        uint8 amount = uint8(std::min<uint32>(gossipListId, 3) + 1);
        switch (menuId)
        {
            case MENU_TABLE:
                TailorsChoices.erase(player->GetGUID());
                break;
            case MENU_TABLE_HIDES:
            {
                TailorsChoice& choice = TailorsChoices[player->GetGUID()];
                choice = TailorsChoice();
                choice.Hides = amount;
                choice.TakenAt = GameTime::GetGameTime();
                break;
            }
            case MENU_TABLE_MUD:
            {
                auto itr = TailorsChoices.find(player->GetGUID());
                if (itr != TailorsChoices.end() && itr->second.Hides)
                    itr->second.Mud = amount;
                break;
            }
            case MENU_TABLE_THREAD:
            {
                auto itr = TailorsChoices.find(player->GetGUID());
                if (itr != TailorsChoices.end() && itr->second.Hides && itr->second.Mud)
                {
                    itr->second.Thread = amount;
                    itr->second.TakenAt = GameTime::GetGameTime();
                    TC_LOG_DEBUG("scripts", "Burning Steppes: player %u took %u hides, %u mud, %u thread at the Tailor's Table",
                        player->GetGUID().GetCounter(), itr->second.Hides, itr->second.Mud, itr->second.Thread);
                }
                break;
            }
            default:
                break;
        }
        return false;
    }
};

// Thelaron Direneedle 48001
struct npc_burning_steppes_thelaron_direneedle : public ScriptedAI
{
    npc_burning_steppes_thelaron_direneedle(Creature* creature) : ScriptedAI(creature) { }

    static std::array<uint8, 3> RecipeFor(Player* player)
    {
        switch (player->GetRace())
        {
            case RACE_TAUREN:
            case RACE_DRAENEI:
            case RACE_WORGEN:
            case RACE_PANDAREN_NEUTRAL:
            case RACE_PANDAREN_ALLIANCE:
            case RACE_PANDAREN_HORDE:
                return { 4, 1, 3 };     // ogre
            case RACE_GNOME:
            case RACE_GOBLIN:
                return { 1, 3, 4 };     // goblin
            case RACE_NIGHTELF:
            case RACE_TROLL:
            case RACE_BLOODELF:
                return { 3, 2, 1 };     // troll
            default:
                return { 2, 4, 2 };     // orc: Human, Orc, Dwarf, Undead
        }
    }

    bool OnGossipHello(Player* player) override
    {
        player->PlayerTalkClass->ClearMenus();
        InitGossipMenuFor(player, MENU_THELARON);
        player->PrepareQuestMenu(me->GetGUID());

        if (GetFullTailorsChoice(player))
        {
            AddGossipItemFor(player, MENU_THELARON, OPTION_THELARON_BROUGHT, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);
            SendGossipMenuFor(player, TEXT_THELARON_WHAT_BROUGHT, me->GetGUID());
        }
        else
            SendGossipMenuFor(player, TEXT_THELARON_GREETING, me->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
    {
        // The menu id comes from the packet: only the menu this player really has open
        if (menuId != MENU_THELARON || gossipListId != OPTION_THELARON_BROUGHT || player->PlayerTalkClass->GetGossipMenu().GetMenuId() != menuId)
            return false;

        CloseGossipMenuFor(player);

        TailorsChoice const* choice = GetFullTailorsChoice(player);
        if (!choice)
            return true;

        // The choice may be older than the player's state: abandoned the costume quest, or found / was given a disguise since.
        // Only a player who may still use the table gets an answer (a costume quest in the log, or a valid remake).
        if (!CanUseTailorsTable(player))
        {
            TailorsChoices.erase(player->GetGUID());
            return true;
        }

        std::array<uint8, 3> recipe = RecipeFor(player);
        uint8 line = SAY_THELARON_PERFECT;
        if (choice->Hides < recipe[0])
            line = SAY_THELARON_HIDE_TOO_LITTLE;
        else if (choice->Hides > recipe[0])
            line = SAY_THELARON_HIDE_TOO_MUCH;
        else if (choice->Mud < recipe[1])
            line = SAY_THELARON_MUD_TOO_LITTLE;
        else if (choice->Mud > recipe[1])
            line = SAY_THELARON_MUD_TOO_MUCH;
        else if (choice->Thread < recipe[2])
            line = SAY_THELARON_THREAD_TOO_LITTLE;
        else if (choice->Thread > recipe[2])
            line = SAY_THELARON_THREAD_TOO_MUCH;

        // During A Perfect Costume the right answer is the credit only: the disguise comes with Into the Black Tooth Hovel's
        // StartItem on accepting it (28202 2010-12-16 reply 773680 "doesn't appear in your inventory until you turn in this quest
        // and accept the next"; the costume quests' ItemDrop1 63357 would destroy one handed out here at the hand-in). A player
        // remaking a lost disguise (no costume quest in the log) gets the item - and with full bags nothing at all: the bag-full
        // error, and the choice is kept for the next try.
        bool remake = true;
        for (uint32 questId : CostumeQuests)
            if (player->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
                remake = false;

        if (line == SAY_THELARON_PERFECT && remake)
        {
            if (player->HasItemCount(ITEM_BLACKROCK_DISGUISE, 1, true)
                || player->IsQuestRewarded(QUEST_LOCKED_AND_LOADED_A) || player->IsQuestRewarded(QUEST_LOCKED_AND_LOADED_H))
            {
                TailorsChoices.erase(player->GetGUID());
                return true;
            }

            ItemPosCountVec dest;
            InventoryResult msg = player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, ITEM_BLACKROCK_DISGUISE, 1);
            if (msg != EQUIP_ERR_OK)
            {
                player->SendEquipError(msg, nullptr, nullptr, ITEM_BLACKROCK_DISGUISE);
                return true;
            }
        }

        // A wrong answer means a new trip to the table (28428 [+0] 700702).
        TailorsChoices.erase(player->GetGUID());
        Talk(line, player);

        if (line != SAY_THELARON_PERFECT)
            return true;

        if (remake)
            player->AddItem(ITEM_BLACKROCK_DISGUISE, 1);
        else
            player->KilledMonsterCredit(NPC_COSTUME_CREDIT);
        return true;
    }
};

/* Grunt Work (28245 / 28433): polishing Blackrock Boots 206977 sometimes lets Boot Spiders 48106 (~450 hp, level 50-51) out
   (28245 [+10] 141466 + reply; 28433 [+3] Catriona + replies "2-4, most times 4", "usually 3, sometimes 2"). The boots' data10
   89467 is a server-side spell 5.4.8 lacks; the DBC has 89465 "Summon Boot Spiders - 50% Hit" (89466 at 50 %) and 89466 Summon
   Boot Spiders (one 48106, wild, 3 min, at a random point 1-2 yd in front of the caster).
   What the player sees: after the "Polishing Vigorously" bar, 0-4 spiders crawl out of the boots and attack (also in the disguise:
   spiders are not Blackrock). Ours: two spiders plus two 50 % rolls per polish (2-4, 3 on average: the comments say "2-4, most
   times 4", "usually 3, sometimes 2"; the less grindy reading of them), each one cast of 89466 from the boots, only while Grunt
   Work is in the log incomplete. The polish credit is the goober's own (KillCreditGO). */
enum BlackrockBoots
{
    QUEST_GRUNT_WORK_A              = 28245,
    QUEST_GRUNT_WORK_H              = 28433,
    SPELL_SUMMON_BOOT_SPIDERS       = 89466,
    BOOT_SPIDERS_MIN                = 2,
    BOOT_SPIDER_ROLLS               = 2,
    BOOT_SPIDER_CHANCE              = 50,
};

// Blackrock Boots 206977
struct go_burning_steppes_blackrock_boots : public GameObjectAI
{
    go_burning_steppes_blackrock_boots(GameObject* go) : GameObjectAI(go) { }

    // isUse: GameObject::Use, once per completed polish; CMSG_GAMEOBJ_REPORT_USE calls this again with isUse false
    bool OnGossipHello(Player* player, bool isUse) override
    {
        if (!isUse)
            return false;

        if (player->GetQuestStatus(QUEST_GRUNT_WORK_A) != QUEST_STATUS_INCOMPLETE && player->GetQuestStatus(QUEST_GRUNT_WORK_H) != QUEST_STATUS_INCOMPLETE)
            return false;

        uint8 spiders = BOOT_SPIDERS_MIN;
        for (uint8 i = 0; i < BOOT_SPIDER_ROLLS; ++i)
            if (roll_chance_i(BOOT_SPIDER_CHANCE))
                ++spiders;
        for (uint8 i = 0; i < spiders; ++i)
            me->CastSpell(player, SPELL_SUMMON_BOOT_SPIDERS);

        return false; // the goober's own use (credit, despawn timer) goes on
    }
};

/* Strategic Cuts (28246 / 28434): the Razor-Sharp Scorpid Barb 89447 (a bare DUMMY, 7 yd) on the three marks.
   What the player sees (wiki 28246 notes; 28434 [+9] bum805, [+7]; 48100 [+8]; 48099 [+11] Zuljid; 9176 2011-02-06 [+19] Daniera,
   reply [+5] Mazik90; 28246 [+0] 285564):
   - Voodooist Timan 48100 atop the Pillar of Ash: yells "OW, MON!", hexes the stabber, yells "HEX YOU! HEX YOU! HEX YOU!" and falls
     off the tower to his death.
   - Worgmistress Othana 48099 in the worg pens berates her worgs now and then (five lines). Stabbed: "Ahh! I... I can't move!", the
     worgs close in, "No... no... get them away from me!", "NO! AHHHHHHH!!!!" and she is eaten alive.
   - Gorlop 9176 runs between two lava pools on the south side: at each "This lava hot.", a few seconds, "Gorlop wonder if other lava
     hot?", and off to the other. The barb works only while he stands at a pool ("Invalid target" otherwise); then "OWIE! GORLOP
     CAN'T MOVE! GORLOP GONNA FALL!" and he jumps into the lava and dies.
   Killing them the normal way (disguise off) still counts (kill credit by entry).
   Ours: C++ in place of their SmartAI (their combat spells and timers are carried over as they were); credit for the stabber and
   his group in reach, as a kill would give (a scripted death has no loot recipient); the barb refused ("Invalid target") on anything
   but a ready mark, which also covers Gorlop away from a pool; timings; Timan's landing point (-8086.7, -1867.9, 133.1), 15 yd north
   of the platform where the vmap shows open ground below; Gorlop's pools: the west one is his TDB spawn (= wiki 39.9, 60.5), the
   east one wiki 43.9, 60.1 at terrain height; he faces west at the west pool (TDB orientation) and east at the east one, and jumps
   3 yd ahead; the worgs walk to Othana, bite for three seconds and walk home; scenes run once per life. */
enum StrategicCuts
{
    SPELL_RAZOR_SHARP_SCORPID_BARB  = 89447,

    NPC_GORLOP                      = 9176,
    NPC_WORGMISTRESS_OTHANA         = 48099,
    NPC_VOODOOIST_TIMAN             = 48100,
    NPC_BLACKROCK_WORG              = 7055,

    DATA_BARB_READY                 = 1,
    POINT_MARK_FALL                 = 1,
    POINT_GORLOP_WEST_POOL          = 2,
    POINT_GORLOP_EAST_POOL          = 3,
    POINT_WORG_TO_OTHANA            = 4,

    // Timan
    SPELL_TIMAN_HEX                 = 89459,
    SPELL_TIMAN_SHRINK              = 15802,
    SPELL_TIMAN_DRAIN_LIFE          = 17173,
    SPELL_TIMAN_POISON_BOLT         = 21067,
    SAY_TIMAN_OW_MON                = 0,    // 48328 yell
    SAY_TIMAN_HEX_YOU               = 1,    // 48329 yell
    EVENT_TIMAN_HEX                 = 1,
    EVENT_TIMAN_SHRINK,
    EVENT_TIMAN_DRAIN_LIFE,
    EVENT_TIMAN_POISON_BOLT,

    // Othana
    SAY_OTHANA_WHIP                 = 0,    // 48319-48323
    SAY_OTHANA_CANT_MOVE            = 1,    // 48325
    SAY_OTHANA_GET_THEM_AWAY        = 2,    // 48326
    SAY_OTHANA_NO                   = 3,    // 48327 yell

    // Gorlop
    SPELL_GORLOP_GROUND_SMASH       = 12734,
    SPELL_GORLOP_KNOCK_AWAY         = 10101,
    SPELL_GORLOP_THRASH             = 12787,
    SAY_GORLOP_THIS_LAVA_HOT        = 0,    // 48334
    SAY_GORLOP_OTHER_LAVA           = 1,    // 48335
    SAY_GORLOP_GONNA_FALL           = 2,    // 48330 yell
    EVENT_GORLOP_GROUND_SMASH       = 1,
    EVENT_GORLOP_KNOCK_AWAY,
    EVENT_GORLOP_THRASH,
};

Position const TimanFallPos         = { -8086.7f, -1867.9f, 133.1f };
Position const GorlopWestPoolPos    = { -8258.11f, -1727.39f, 140.665f, 1.817f };
Position const GorlopEastPoolPos    = { -8247.5f, -1848.4f, 144.11f, 4.959f };

// Shared by the three marks: one scene per life, started by the barb, the credit for the stabber and his group.
struct npc_burning_steppes_strategic_mark : public customCreatureAI
{
    npc_burning_steppes_strategic_mark(Creature* creature) : customCreatureAI(creature) { }

    TaskScheduler scheduler;
    bool inScene = false;
    ObjectGuid stabberGUID;

    virtual bool IsBarbReady() const { return true; }
    virtual void StartScene(Player* stabber) = 0;

    uint32 GetData(uint32 type) const override
    {
        if (type == DATA_BARB_READY)
            return (!inScene && me->IsAlive() && IsBarbReady()) ? 1 : 0;
        return 0;
    }

    void Reset() override
    {
        events.Reset();
        scheduler.CancelAll();
        inScene = false;
        stabberGUID = ObjectGuid::Empty;
        me->SetReactState(REACT_AGGRESSIVE);
    }

    void SpellHit(Unit* caster, SpellInfo const* spellInfo) override
    {
        if (spellInfo->Id != SPELL_RAZOR_SHARP_SCORPID_BARB || inScene || !me->IsAlive())
            return;

        Player* stabber = caster ? caster->ToPlayer() : nullptr;
        if (!stabber)
            return;

        inScene = true;
        stabberGUID = stabber->GetGUID();
        events.Reset();
        scheduler.CancelAll();
        me->InterruptNonMeleeSpells(false);
        me->SetReactState(REACT_PASSIVE);
        me->AttackStop();
        me->StopMoving();
        TC_LOG_DEBUG("scripts", "Burning Steppes: %s stabbed by player %u, scene starts", me->GetName().c_str(), stabber->GetGUID().GetCounter());
        StartScene(stabber);
    }

    // An undisguised stabber is in combat with the mark: it stays put, passive, until its scene ends.
    void EnterEvadeMode(EvadeReason why) override
    {
        if (inScene)
            return;
        customCreatureAI::EnterEvadeMode(why);
    }

    void CreditAndDie()
    {
        if (!me->IsAlive())
            return;
        if (Player* stabber = ObjectAccessor::GetPlayer(*me, stabberGUID))
            stabber->RewardPlayerAndGroupAtEvent(me->GetEntry(), me);
        me->Kill(me);
    }
};

// Voodooist Timan 48100
struct npc_burning_steppes_voodooist_timan : public npc_burning_steppes_strategic_mark
{
    npc_burning_steppes_voodooist_timan(Creature* creature) : npc_burning_steppes_strategic_mark(creature) { }

    void JustEngagedWith(Unit* /*who*/) override
    {
        events.ScheduleEvent(EVENT_TIMAN_POISON_BOLT, 0);
        events.ScheduleEvent(EVENT_TIMAN_SHRINK, 5 * IN_MILLISECONDS);
        events.ScheduleEvent(EVENT_TIMAN_HEX, 9 * IN_MILLISECONDS);
        events.ScheduleEvent(EVENT_TIMAN_DRAIN_LIFE, 1 * IN_MILLISECONDS);
    }

    void StartScene(Player* stabber) override
    {
        Talk(SAY_TIMAN_OW_MON, stabber);
        scheduler
            .Schedule(Milliseconds(1500), [this](TaskContext /*context*/)
            {
                // Whether a triggered Hex lands on a player the disguise makes friendly is open (dossier S2 unknown 3); the line
                // comes either way.
                if (Player* stabber = ObjectAccessor::GetPlayer(*me, stabberGUID))
                    me->CastSpell(stabber, SPELL_TIMAN_HEX, true);
                Talk(SAY_TIMAN_HEX_YOU);
            })
            .Schedule(Milliseconds(3500), [this](TaskContext /*context*/)
            {
                me->GetMotionMaster()->Clear();
                me->GetMotionMaster()->MoveJump(TimanFallPos, 10.0f, 6.0f, POINT_MARK_FALL);
            })
            .Schedule(Milliseconds(9000), [this](TaskContext /*context*/)
            {
                CreditAndDie(); // the landing did not report
            });
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type == EFFECT_MOTION_TYPE && pointId == POINT_MARK_FALL && inScene)
            CreditAndDie();
    }

    void UpdateAI(uint32 diff) override
    {
        scheduler.Update(diff);

        if (inScene || !UpdateVictim())
            return;

        events.Update(diff);

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_TIMAN_POISON_BOLT:
                    DoCastVictim(SPELL_TIMAN_POISON_BOLT);
                    events.ScheduleEvent(EVENT_TIMAN_POISON_BOLT, urand(3400, 4700));
                    break;
                case EVENT_TIMAN_SHRINK:
                    DoCastVictim(SPELL_TIMAN_SHRINK);
                    events.ScheduleEvent(EVENT_TIMAN_SHRINK, urand(27000, 32000));
                    break;
                case EVENT_TIMAN_HEX:
                    if (Unit* target = SelectTarget(SELECT_TARGET_RANDOM, 0, 30.0f, true))
                        DoCast(target, SPELL_TIMAN_HEX);
                    events.ScheduleEvent(EVENT_TIMAN_HEX, urand(24000, 27000));
                    break;
                case EVENT_TIMAN_DRAIN_LIFE:
                    if (HealthBelowPct(40))
                    {
                        DoCastVictim(SPELL_TIMAN_DRAIN_LIFE);
                        events.ScheduleEvent(EVENT_TIMAN_DRAIN_LIFE, urand(22000, 25000));
                    }
                    else
                        events.ScheduleEvent(EVENT_TIMAN_DRAIN_LIFE, 1 * IN_MILLISECONDS);
                    break;
                default:
                    break;
            }
        }

        DoMeleeAttackIfReady();
    }
};

// Worgmistress Othana 48099
struct npc_burning_steppes_worgmistress_othana : public npc_burning_steppes_strategic_mark
{
    npc_burning_steppes_worgmistress_othana(Creature* creature) : npc_burning_steppes_strategic_mark(creature) { }

    std::vector<ObjectGuid> worgGUIDs;
    uint32 whipTimer = 0;

    void Reset() override
    {
        npc_burning_steppes_strategic_mark::Reset();
        me->SetControlled(false, UNIT_STATE_ROOT);
        me->SetUInt32Value(UNIT_FIELD_NPC_EMOTESTATE, 0);
        worgGUIDs.clear();
        whipTimer = urand(5000, 20000);
    }

    void StartScene(Player* stabber) override
    {
        me->SetControlled(true, UNIT_STATE_ROOT);
        me->SetUInt32Value(UNIT_FIELD_NPC_EMOTESTATE, EMOTE_STATE_STUN);
        Talk(SAY_OTHANA_CANT_MOVE, stabber);

        // Her own worgs close in; one already fighting someone stays in its fight.
        std::list<Creature*> worgs;
        GetCreatureListWithEntryInGrid(worgs, me, NPC_BLACKROCK_WORG, 20.0f);
        worgGUIDs.clear();
        for (Creature* worg : worgs)
        {
            if (!worg->IsAlive() || worg->IsInCombat())
                continue;
            float angle = me->GetAngle(worg);
            Position pos = me->GetPosition();
            pos.m_positionX += 2.5f * std::cos(angle);
            pos.m_positionY += 2.5f * std::sin(angle);
            worg->UpdateGroundPositionZ(pos.m_positionX, pos.m_positionY, pos.m_positionZ);
            worg->SetWalk(false);
            worg->GetMotionMaster()->MovePoint(POINT_WORG_TO_OTHANA, pos);
            worgGUIDs.push_back(worg->GetGUID());
        }

        scheduler
            .Schedule(Seconds(3), [this](TaskContext /*context*/)
            {
                Talk(SAY_OTHANA_GET_THEM_AWAY);
                WorgsBite();
            })
            .Schedule(Seconds(4), [this](TaskContext /*context*/) { WorgsBite(); })
            .Schedule(Seconds(5), [this](TaskContext /*context*/) { WorgsBite(); })
            .Schedule(Seconds(6), [this](TaskContext /*context*/)
            {
                Talk(SAY_OTHANA_NO);
                WorgsBite();
            })
            .Schedule(Seconds(7), [this](TaskContext /*context*/)
            {
                WorgsBite();
                SendWorgsHome();
                CreditAndDie();
            });
    }

    void WorgsBite()
    {
        for (ObjectGuid const& guid : worgGUIDs)
            if (Creature* worg = ObjectAccessor::GetCreature(*me, guid))
                if (worg->IsAlive() && !worg->IsInCombat())
                {
                    worg->SetFacingToObject(me);
                    worg->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK1H);
                }
    }

    void SendWorgsHome()
    {
        for (ObjectGuid const& guid : worgGUIDs)
            if (Creature* worg = ObjectAccessor::GetCreature(*me, guid))
                if (worg->IsAlive() && !worg->IsInCombat())
                {
                    worg->SetWalk(true);
                    worg->GetMotionMaster()->MoveTargetedHome();
                }
        worgGUIDs.clear();
    }

    void JustDied(Unit* /*killer*/) override
    {
        SendWorgsHome();
    }

    void UpdateAI(uint32 diff) override
    {
        scheduler.Update(diff);

        if (inScene)
            return;

        if (!me->IsInCombat())
        {
            if (whipTimer <= diff)
            {
                Talk(SAY_OTHANA_WHIP);
                whipTimer = urand(20000, 40000);
            }
            else
                whipTimer -= diff;
        }

        if (!UpdateVictim())
            return;

        DoMeleeAttackIfReady();
    }
};

// Gorlop 9176
struct npc_burning_steppes_gorlop : public npc_burning_steppes_strategic_mark
{
    npc_burning_steppes_gorlop(Creature* creature) : npc_burning_steppes_strategic_mark(creature) { }

    bool atPool = false;

    bool IsBarbReady() const override { return atPool && !me->IsInCombat(); }

    void Reset() override
    {
        npc_burning_steppes_strategic_mark::Reset();
        me->SetControlled(false, UNIT_STATE_ROOT);
        atPool = false;
        // A fresh spawn starts here; after an evade JustReachedHome starts the round.
        scheduler.Schedule(Seconds(2), [this](TaskContext /*context*/)
        {
            if (!me->HasUnitState(UNIT_STATE_EVADE) && !me->IsInCombat())
                RunTo(POINT_GORLOP_WEST_POOL);
        });
    }

    void JustReachedHome() override
    {
        RunTo(POINT_GORLOP_WEST_POOL);
    }

    void RunTo(uint32 pointId)
    {
        atPool = false;
        me->SetWalk(false);
        me->GetMotionMaster()->MovePoint(pointId, pointId == POINT_GORLOP_WEST_POOL ? GorlopWestPoolPos : GorlopEastPoolPos);
    }

    void MovementInform(uint32 type, uint32 pointId) override
    {
        if (type == EFFECT_MOTION_TYPE && pointId == POINT_MARK_FALL && inScene)
        {
            CreditAndDie();
            return;
        }

        if (type != POINT_MOTION_TYPE || inScene || (pointId != POINT_GORLOP_WEST_POOL && pointId != POINT_GORLOP_EAST_POOL))
            return;

        atPool = true;
        me->SetFacingTo(pointId == POINT_GORLOP_WEST_POOL ? GorlopWestPoolPos.GetOrientation() : GorlopEastPoolPos.GetOrientation());
        Talk(SAY_GORLOP_THIS_LAVA_HOT);
        uint32 next = pointId == POINT_GORLOP_WEST_POOL ? POINT_GORLOP_EAST_POOL : POINT_GORLOP_WEST_POOL;
        scheduler
            .Schedule(Seconds(6), [this](TaskContext /*context*/)
            {
                Talk(SAY_GORLOP_OTHER_LAVA);
            })
            .Schedule(Seconds(8), [this, next](TaskContext /*context*/)
            {
                RunTo(next);
            });
    }

    void JustEngagedWith(Unit* /*who*/) override
    {
        atPool = false;
        scheduler.CancelAll();
        events.ScheduleEvent(EVENT_GORLOP_GROUND_SMASH, urand(10100, 12000));
        events.ScheduleEvent(EVENT_GORLOP_KNOCK_AWAY, urand(17300, 20800));
        events.ScheduleEvent(EVENT_GORLOP_THRASH, urand(4800, 18800));
    }

    void StartScene(Player* stabber) override
    {
        atPool = false;
        me->GetMotionMaster()->Clear();
        me->SetControlled(true, UNIT_STATE_ROOT);
        Talk(SAY_GORLOP_GONNA_FALL, stabber);
        scheduler
            .Schedule(Milliseconds(2000), [this](TaskContext /*context*/)
            {
                me->SetControlled(false, UNIT_STATE_ROOT);
                Position pos = me->GetNearPosition(3.0f, 0.0f);
                me->GetMotionMaster()->MoveJump(pos, 6.0f, 6.0f, POINT_MARK_FALL);
            })
            .Schedule(Milliseconds(6000), [this](TaskContext /*context*/)
            {
                CreditAndDie(); // the landing did not report
            });
    }

    void UpdateAI(uint32 diff) override
    {
        scheduler.Update(diff);

        if (inScene || !UpdateVictim())
            return;

        events.Update(diff);

        if (me->HasUnitState(UNIT_STATE_CASTING))
            return;

        while (uint32 eventId = events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_GORLOP_GROUND_SMASH:
                    DoCast(me, SPELL_GORLOP_GROUND_SMASH);
                    events.ScheduleEvent(EVENT_GORLOP_GROUND_SMASH, urand(18900, 23400));
                    break;
                case EVENT_GORLOP_KNOCK_AWAY:
                    DoCastVictim(SPELL_GORLOP_KNOCK_AWAY);
                    events.ScheduleEvent(EVENT_GORLOP_KNOCK_AWAY, urand(38600, 44300));
                    break;
                case EVENT_GORLOP_THRASH:
                    DoCast(me, SPELL_GORLOP_THRASH);
                    events.ScheduleEvent(EVENT_GORLOP_THRASH, urand(7300, 12100));
                    break;
                default:
                    break;
            }
        }

        DoMeleeAttackIfReady();
    }
};

// 89447 Razor-Sharp Scorpid Barb: only on a mark that is ready for its scene ("Invalid target" otherwise, as retail on Gorlop)
class spell_burning_steppes_scorpid_barb : public SpellScript
{
    PrepareSpellScript(spell_burning_steppes_scorpid_barb);

    SpellCastResult CheckTarget()
    {
        Creature* target = GetExplTargetUnit() ? GetExplTargetUnit()->ToCreature() : nullptr;
        if (!target || !target->IsAlive())
            return SPELL_FAILED_BAD_TARGETS;

        switch (target->GetEntry())
        {
            case NPC_GORLOP:
            case NPC_WORGMISTRESS_OTHANA:
            case NPC_VOODOOIST_TIMAN:
                break;
            default:
                return SPELL_FAILED_BAD_TARGETS;
        }

        if (!target->IsAIEnabled || !target->AI()->GetData(DATA_BARB_READY))
            return SPELL_FAILED_BAD_TARGETS;

        return SPELL_CAST_OK;
    }

    void Register() override
    {
        OnCheckCast += SpellCheckCastFn(spell_burning_steppes_scorpid_barb::CheckTarget);
    }
};

/* Unmask 89596 (I Am the Law and I Am the Lash 28278 / 28439, Abuse of Power 28279 / 28440; designed with the Black Tooth Hovel).
   Cast by a Blackrock troop on the disguised player who cudgeled it (Blackrock Soldier 7025, Smolderthorn Assassin 48119, Firegut
   Flamespeaker 48121 on a "notice" roll, Blackrock Sergeant 48201 on his first hit: their SmartAI, target = the invoker). An 8 s
   channel; its aura's one periodic dummy tick is the end of the channel. Nothing scripted it, so nobody was ever unmasked.
   What the player sees (28278 2011-04-27 [+18] entropicdragon, 2010-12-03 [+5], 2011-01-30 [+2], 2013-05-07 [+6]; wiki 28278):
   at once a raid-boss whisper "You've been spotted! Club your target to death before you are unmasked!" (48432) and the Unmask
   buff counting down; killing the troop in time, breaking its channel or right-clicking the buff (core change in
   HandleCancelAuraOpcode) and nothing happens - the troop "just stands there"; otherwise the player casts Unmask Effect 89594 on
   himself (removes 89261, and through spell_linked_spell the race aura and its forced reaction), gets "You've been unmasked! Get to
   safety, then put your disguise back on!" (48433) and the troop and every Blackrock within 10 yd attack.
   Ours: the whispers as raid-boss whispers from the troop, sent only to a player who wears the disguise (the troops' in-combat
   "Unmask on close" casts on an undisguised player stay silent and do nothing); the unmask fired on the tick or on removal by
   expiry, whichever comes first (Spell::SendChannelUpdate sets the aura's duration to 0 when the channel ends, so the expiry can
   come before the tick when the caster updates first), only once; the attack and the 10 yd call for help. Removal by cancel
   (right-click, the caster's death or interrupt), death or logout: nothing.
   The troop does not regenerate health while it channels Unmask on a disguised player. A cudgeled troop stays friendly and out of
   combat (the cudgel has NO_THREAT and the player is forced friendly), and Creature::Regenerate heals an out-of-combat creature
   whose isRegeneratingHealth() is set by a third of its health every 2 s (amount in Unit::RegenerateHealth), more than one cudgel
   hit: a spotted troop could not be clubbed to death in time. Sourced: four quick hits kill it within the few seconds the unmask
   takes (wiki 28278 / 28279; 28440 2010-12-06, "just keep clicking the cudgel"); ours: the mechanism. Regeneration comes back
   (the template's value) when the aura ends, however it ends; and, because that restore finds the troop through the player's map
   (a player who changes map inside the 8 s takes the aura with him), the troop also restores it itself 9 s after the hold began,
   or later while it still channels Unmask. Creature::Respawn does not reset the flag (UpdateEntry only on an entry change). */
enum Unmask
{
    SPELL_BLACKROCK_DISGUISE        = 89261,
    SPELL_UNMASK                    = 89596,
    SPELL_UNMASK_EFFECT             = 89594,
    TEXT_YOU_HAVE_BEEN_SPOTTED      = 48432,
    TEXT_YOU_HAVE_BEEN_UNMASKED     = 48433,
};

// The troop's own backstop for the regeneration hold: restore the template's value once it no longer channels Unmask
static void ScheduleUnmaskRegenBackstop(Creature* troop, uint32 delay)
{
    troop->m_Events.Schedule(delay, [troop]()
    {
        Spell* channel = troop->GetCurrentSpell(CURRENT_CHANNELED_SPELL);
        if (channel && channel->GetSpellInfo()->Id == SPELL_UNMASK)
        {
            ScheduleUnmaskRegenBackstop(troop, 1000);
            return;
        }
        troop->setRegeneratingHealth(troop->GetCreatureTemplate()->RegenHealth);
    });
}

// 89596 Unmask
class spell_burning_steppes_unmask : public AuraScript
{
    PrepareAuraScript(spell_burning_steppes_unmask);

    bool unmasked = false;
    bool regenHeld = false;

    void AfterApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Player* player = GetTarget()->ToPlayer();
        Unit* caster = GetCaster();
        if (!player || !caster || !player->HasAura(SPELL_BLACKROCK_DISGUISE))
            return;

        caster->Whisper(TEXT_YOU_HAVE_BEEN_SPOTTED, player, true);

        // Out of combat it would heal a third of its health every 2 s: the player could not club it to death before the unmask
        if (Creature* troop = caster->ToCreature())
        {
            troop->setRegeneratingHealth(false);
            regenHeld = true;
            ScheduleUnmaskRegenBackstop(troop, 9000);
        }
    }

    void RestoreRegen()
    {
        if (!regenHeld)
            return;
        regenHeld = false;

        if (Creature* troop = GetCaster() ? GetCaster()->ToCreature() : nullptr)
            troop->setRegeneratingHealth(troop->GetCreatureTemplate()->RegenHealth);
    }

    void DoUnmask()
    {
        if (unmasked)
            return;
        unmasked = true;

        Player* player = GetTarget()->ToPlayer();
        if (!player || !player->IsAlive() || !player->HasAura(SPELL_BLACKROCK_DISGUISE))
            return;

        player->CastSpell(player, SPELL_UNMASK_EFFECT, true);
        TC_LOG_DEBUG("scripts", "Burning Steppes: player %u unmasked", player->GetGUID().GetCounter());

        Creature* troop = GetCaster() ? GetCaster()->ToCreature() : nullptr;
        if (!troop || !troop->IsAlive())
            return;

        troop->Whisper(TEXT_YOU_HAVE_BEEN_UNMASKED, player, true);
        if (troop->IsAIEnabled && troop->IsValidAttackTarget(player))
        {
            troop->AI()->AttackStart(player);
            troop->CallForHelp(10.0f);
        }
    }

    void HandleTick(AuraEffect const* /*aurEff*/)
    {
        DoUnmask();
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (GetTargetApplication()->GetRemoveMode() == AURA_REMOVE_BY_EXPIRE)
            DoUnmask();

        RestoreRegen();
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_burning_steppes_unmask::AfterApply, EFFECT_0, SPELL_AURA_PERIODIC_DUMMY, AURA_EFFECT_HANDLE_REAL);
        OnEffectPeriodic += AuraEffectPeriodicFn(spell_burning_steppes_unmask::HandleTick, EFFECT_0, SPELL_AURA_PERIODIC_DUMMY);
        AfterEffectRemove += AuraEffectRemoveFn(spell_burning_steppes_unmask::AfterRemove, EFFECT_0, SPELL_AURA_PERIODIC_DUMMY, AURA_EFFECT_HANDLE_REAL);
    }
};

// 89594 Unmask Effect: eff0 removes 89261; eff1 SCRIPT_EFFECT has nothing left to do (the race aura goes by spell_linked_spell)
class spell_burning_steppes_unmask_effect : public SpellScript
{
    PrepareSpellScript(spell_burning_steppes_unmask_effect);

    void HandleScript(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
    }

    void Register() override
    {
        OnEffectHitTarget += SpellEffectFn(spell_burning_steppes_unmask_effect::HandleScript, EFFECT_1, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

void AddSC_burning_steppes()
{
    new creature_script<npc_burning_steppes_war_reaver>("npc_burning_steppes_war_reaver");
    new go_burning_steppes_war_reaver_part();
    new npc_burning_steppes_chiseled_golem();
    RegisterGameObjectAI(go_burning_steppes_tailors_table);
    RegisterCreatureAI(npc_burning_steppes_thelaron_direneedle);
    RegisterGameObjectAI(go_burning_steppes_blackrock_boots);
    RegisterCreatureAI(npc_burning_steppes_voodooist_timan);
    RegisterCreatureAI(npc_burning_steppes_worgmistress_othana);
    RegisterCreatureAI(npc_burning_steppes_gorlop);
    RegisterSpellScript(spell_burning_steppes_scorpid_barb);
    new aura_script<spell_burning_steppes_unmask>("spell_burning_steppes_unmask");
    new spell_script<spell_burning_steppes_unmask_effect>("spell_burning_steppes_unmask_effect");
}
