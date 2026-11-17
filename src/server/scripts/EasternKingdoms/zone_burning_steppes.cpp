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
    SPELL_BATTLE_READY               = 89353, // first defeat
    SPELL_WELL_HONED                 = 89352, // second defeat
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
        events.ScheduleEvent(SPELL_FLAME_BLAST, 8 * IN_MILLISECONDS);
    }

    void JustDied(Unit* /*killer*/) override
    {
        if (!roll_chance_i(80))
            return;

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

        bool OnGossipHello(Player* player, GameObject* go) override
        {
            player->ADD_GOSSIP_ITEM_DB(player->GetDefaultGossipMenuForSource(go), 0, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);
            player->ADD_GOSSIP_ITEM_DB(player->GetDefaultGossipMenuForSource(go), 1, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 2);

            player->SEND_GOSSIP_MENU(player->GetGossipTextId(go), go->GetGUID());

            return true;
        }

        bool OnGossipSelect(Player* player, GameObject* go, uint32 /*sender*/, uint32 action) override
        {
            player->PlayerTalkClass->ClearMenus();

            // Send item to player
            auto itr = golemParts.find(go->GetEntry());
            player->AddItem(action == GOSSIP_ACTION_INFO_DEF + 1 ? itr->second[0] : itr->second[1], 1);

            player->CLOSE_GOSSIP_MENU();
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

                    // select powerful depend of current
                    if (!me->HasAura(SPELL_BATTLE_READY))
                    {
                        me->PrepareChanneledCast(me->GetOrientation());
                        DoCast(me, SPELL_BATTLE_READY);
                        Talk(TALK_DEFEAT_1);

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
                    else if (!me->HasAura(SPELL_WELL_HONED))
                    {
                        me->PrepareChanneledCast(me->GetOrientation());
                        DoCast(me, SPELL_WELL_HONED);
                        Talk(TALK_DEFEAT_2);

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
   goes back to the table), or "This... this is perfect! ..." (48241) with the Costume Credit 47910 and the Blackrock Disguise.
   The choice is per player (the old SmartAI set Thelaron's gossip flag for everybody).
   Ours: who may use the table (a costume quest in the log, or one handed in while the player has no disguise in bags or bank and
   Locked and Loaded 28327 / 28453 is not done: the remake of D11, 28202 [+6], item [+12], GM quote in 28278) - everyone else sees
   "There is nothing of interest on the table" (17382); the choice kept 10 minutes; the disguise given only to a player without
   one. Bots never use the table or the gossip (playerbots list). */
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
        if (menuId != MENU_THELARON || gossipListId != OPTION_THELARON_BROUGHT)
            return false;

        CloseGossipMenuFor(player);

        TailorsChoice const* choice = GetFullTailorsChoice(player);
        if (!choice)
            return true;

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

        // A wrong answer means a new trip to the table (28428 [+0] 700702).
        TailorsChoices.erase(player->GetGUID());
        Talk(line, player);

        if (line != SAY_THELARON_PERFECT)
            return true;

        player->KilledMonsterCredit(NPC_COSTUME_CREDIT);
        if (!player->HasItemCount(ITEM_BLACKROCK_DISGUISE, 1, true)
            && !player->IsQuestRewarded(QUEST_LOCKED_AND_LOADED_A) && !player->IsQuestRewarded(QUEST_LOCKED_AND_LOADED_H))
            player->AddItem(ITEM_BLACKROCK_DISGUISE, 1);
        return true;
    }
};

void AddSC_burning_steppes()
{
    new creature_script<npc_burning_steppes_war_reaver>("npc_burning_steppes_war_reaver");
    new go_burning_steppes_war_reaver_part();
    new npc_burning_steppes_chiseled_golem();
    RegisterGameObjectAI(go_burning_steppes_tailors_table);
    RegisterCreatureAI(npc_burning_steppes_thelaron_direneedle);
}
