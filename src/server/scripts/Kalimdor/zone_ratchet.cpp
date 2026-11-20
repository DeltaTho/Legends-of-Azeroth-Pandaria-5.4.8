/*
 * Northern Barrens: Ratchet's scripted events (research\northern-barrens\dossiers\F.md, plan.md section S4).
 *
 * Gazlowe's Fortune (14050): the Baron's ambush at the Curious Pirate Landmark.
 *
 * What is sourced and what is ours is said at each script; nothing here is in either TDB.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "GameObjectAI.h"
#include "GameObject.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "TemporarySummon.h"

/*######
## Gazlowe's Fortune (14050): the Baron's ambush
######*/

enum GazlowesFortune
{
    QUEST_GAZLOWES_FORTUNE          = 14050,

    NPC_BARON_LONGSHORE             = 3467,
    NPC_SOUTHSEA_CUTTHROAT          = 3383,

    FACTION_SOUTHSEA_FREEBOOTERS    = 230,      // the Privateers' faction: hostile to both player teams

    SAY_BARON_HOLD_IT               = 1,        // creature_text 3467/1, BT 35060 "Hold it, $r! ..."
};

// Ours: the Baron comes from the side of both TDBs' second Baron spawn (guid 302182, (-1107.2,-3648.1), 70 yd from the
// landmark: the sniffed ambusher), but 20 yd out, so he reaches the digger while the "Digging" cast is still on or just over;
// the two cutthroats 3 yd to either side of him. Open ground, terrain z from the 5.4.8 maps.
static Position const AmbushBaronPos         = { -1146.01f, -3617.41f, 95.93f, 2.47f };
static Position const AmbushCutthroatPos[2]  =
{
    { -1144.94f, -3614.43f, 95.29f, 2.47f },
    { -1148.66f, -3619.14f, 96.32f, 2.47f },
};

// Sourced: they "don't follow long, despawn after a few moments" (comment 2014-07-31 [+1]). Ours: 15 s out of combat.
static constexpr Milliseconds AmbushOutOfCombatDespawn = 15s;

// 195206 Curious Pirate Landmark (the treasure chest under the mast; lock 43 "Digging", Gazlowe's Fortune 46833)
// What the player sees (sourced: beta comment [+12], comments 2010-11-30 [+6], 2011-03-08 [+3], 2011-08-06, the wiki, BT 35060
// with emote 5, the offer-reward text "Oh, the Baron tried to stop you, did he?"): digging up the treasure brings Baron
// Longshore and one or two Southsea Cutthroats, who attack; the Baron yells "Hold it, <race>! I promised told ye where the
// treasure is, but never promised ye could keep it!". Running away, they give up after a while and vanish.
// Ours: two cutthroats; the summon spots; one ambush per digger at a time (a second digger gets his own; opening a chest calls
// OnGossipHello several times, core C97, so a digger whose ambush still lives gets no other); sprung when the chest is opened
// (GameObject::Use / the Opening spell's loot, isUse true), not on the click's CMSG_GAMEOBJ_REPORT_USE (isUse false,
// SpellHandler.cpp:669), so the "Digging" cast comes first; the Baron's copy is not a quest giver, stands (no sitting), is hostile to both
// teams like the Privateers, and keeps his loot (Garvey's Head is a quest drop of WANTED: Cap'n Garvey only). The ambush is
// summoned by the chest, not by the player (a gameobject summoner fires no JustSummoned / IsSummonedBy, TemporarySummon.cpp:
// 305-312, so the copy's SmartAI could not set this up itself; plan ruling R3's JUST_SUMMONED rows are replaced by this).
struct go_ratchet_curious_pirate_landmark : public GameObjectAI
{
    go_ratchet_curious_pirate_landmark(GameObject* go) : GameObjectAI(go) { }

    bool OnGossipHello(Player* player, bool isUse) override
    {
        if (isUse && player->GetQuestStatus(QUEST_GAZLOWES_FORTUNE) == QUEST_STATUS_INCOMPLETE && !AmbushAlive(player->GetGUID()))
            Ambush(player);
        return false;   // the chest opens as before
    }

private:
    bool AmbushAlive(ObjectGuid const& digger)
    {
        GuidVector& ambushers = _ambushers[digger];
        for (ObjectGuid const& guid : ambushers)
            if (Creature* ambusher = ObjectAccessor::GetCreature(*me, guid))
                if (ambusher->IsAlive())
                    return true;
        _ambushers.erase(digger);
        return false;
    }

    static void Prepare(Creature* ambusher, Player* player)
    {
        ambusher->ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
        ambusher->SetStandState(UNIT_STAND_STATE_STAND);
        ambusher->SetFaction(FACTION_SOUTHSEA_FREEBOOTERS);
        ambusher->SetHomePosition(ambusher->GetPosition());
        ambusher->AI()->AttackStart(player);
    }

    void Ambush(Player* player)
    {
        GuidVector& ambushers = _ambushers[player->GetGUID()];

        if (TempSummon* baron = me->SummonCreature(NPC_BARON_LONGSHORE, AmbushBaronPos, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, AmbushOutOfCombatDespawn))
        {
            ambushers.push_back(baron->GetGUID());
            Prepare(baron, player);
            baron->AI()->Talk(SAY_BARON_HOLD_IT, player);
        }

        for (Position const& pos : AmbushCutthroatPos)
            if (TempSummon* cutthroat = me->SummonCreature(NPC_SOUTHSEA_CUTTHROAT, pos, TEMPSUMMON_TIMED_DESPAWN_OUT_OF_COMBAT, AmbushOutOfCombatDespawn))
            {
                ambushers.push_back(cutthroat->GetGUID());
                Prepare(cutthroat, player);
            }
    }

    std::unordered_map<ObjectGuid, GuidVector> _ambushers;   // per digger
};

void AddSC_ratchet()
{
    RegisterGameObjectAI(go_ratchet_curious_pirate_landmark);
}
