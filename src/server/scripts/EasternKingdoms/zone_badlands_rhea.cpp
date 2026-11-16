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
SDName: Badlands, Rhea's events
SDComment: Quest support: 27769 Rhea Revealed, 27770 Lifting the Veil, 27858 / 27898 Rheastrasza's Gift
SDCategory: Badlands
EndScriptData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "Group.h"
#include "WorldSession.h"
#include "GameObject.h"
#include "GameObjectData.h"
#include "Map.h"
#include "SpellMgr.h"
#include "SpellInfo.h"
#include "SpellScript.h"
#include "TemporarySummon.h"
#include "Vehicle.h"

enum RheaEvents
{
    QUEST_RHEA_REVEALED                         = 27769,
    QUEST_LIFTING_THE_VEIL                      = 27770,

    NPC_RHEA                                    = 46654,    // Rhea Revealed's objective: "Discover Rhea's true identity"
    NPC_NYXONDRA                                = 46658,    // Lifting the Veil's objective: "Witness the final piece of Rhea's studies"

    // Rhea 46654: creature_text groups, all personal (TextRange 5): every copy of her is quest-invisible to whoever is outside
    // her window (80852), and text reaches everyone in range whether or not they see the speaker
    TALK_RHEA_REVEALED                          = 0,        // BT 46758 "Deathwing's madness overcomes him ..."
    TALK_RHEA_LIFT_THE_VEIL                     = 1,        // BT 46757 "I will now remove the fog from your eyes.  Behold, our captive."
};

// Who of a player's group gets a credit the player earned in a scripted event (decisions R4 as amended by the user): only the
// playerbots beside the player, who cannot play the event themselves. Other real players earn their own
uint32 const RheaBotCreditRangeYd = 40;

// Credits the player's playerbots within 40 yd of the player that hold the quest incomplete
static void CreditRheaBots(Player* player, uint32 questId, uint32 creditEntry)
{
    Group* group = player->GetGroup();
    if (!group)
        return;

    for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
    {
        Player* member = ref->GetSource();
        if (!member || member == player || !member->GetSession()->IsBot() || !member->IsInMap(player)
            || !member->IsWithinDistInMap(player, float(RheaBotCreditRangeYd)))
            continue;

        if (member->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
            member->KilledMonsterCredit(creditEntry);
    }
}

/*######
## Rheastrasza's Gift (27858 Alliance, 27898 Horde)
######*/

enum RheasGift
{
    QUEST_RHEAS_GIFT_A                          = 27858,
    QUEST_RHEAS_GIFT_H                          = 27898,

    NPC_RG_RHEA                                 = 46955,    // "Rhea", the actor (no quest flags)
    NPC_RG_MIRROR_IMAGE                         = 46956,    // Player Mirror Image: the player's copy hiding in the bushes
    NPC_RG_DEATHWING                            = 46957,
    NPC_RG_CAMERA                               = 46958,    // RG Event Camera, Vehicle 1230

    GO_RG_DRAGON_EGG                            = 206505,

    // The RG spell block (5.4.8 DBC). The summons are personal (SummonProperties 2993, flag 0x10; the camera 3118, a vehicle
    // that also goes on the summoner's death and logout) and land on their spell_target_position spots (mop = both TDBs)
    SPELL_RG_SUMMON_RHEA                        = 87433,
    SPELL_RG_SUMMON_MIRROR_IMAGE                = 87434,
    SPELL_RG_SUMMON_CAMERA                      = 87435,
    SPELL_RG_MASTER_FORCE_PHASE                 = 87436,    // phase 307 "Rheastrasza's Gift" + triggers 87435 RG: Summon Camera
    SPELL_RG_CANCEL_PHASE_AND_TELEPORT          = 87437,    // removes 87436, teleports to the mirror image's spot
    SPELL_RG_MIRROR_IMAGE_AURA                  = 87439,
    SPELL_RG_SUMMON_DEATHWING                   = 87442,
    // 87444 RG: Channel to Deathwing and 87446 RG: Channel to Player Mirror Image (the camera's aims for seats 1 and 2) are not
    // used: only their channel object is, set by hand (Aim); 87446's KILL_CREDIT targets 105, NYI here
    SPELL_RG_FLAME_BREATH                       = 87455,    // Deathwing's cosmetic breath, a 3 s channel on himself
    // 87456 RG: Summon Note (206504 for 60 s) is not used: the static note stands 0.4 yd from its spot (EVENT_RG_NOTE)
    SPELL_RG_HOLD_EGG                           = 87457,
    SPELL_RG_DEATHWING_FLYSITGROUND             = 87458,
    SPELL_RG_SUMMON_EGG                         = 87460,    // 206505 for 30 s: only its spell_target_position is used
    SPELL_RG_EMOTE_STATE_FALL                   = 87462,    // "Cosmetic - Emote State: Fall" (Rhea's end: ours)

    // Vehicle 1230's seats (VehicleSeat 8861 / 8862 / 8865, flags 0x42100206: the passenger hidden, can enter and switch, no
    // control), one CameraMode each (CameraMode.dbc, read against the client's CCameraModeLocked / CCameraTarget):
    //  seat 0, mode 90 "RG Event 1" (flags 0x100): eye at the passenger (= the camera), looking at the world point
    //   (-6467.59, -2479.16, 306.0): the back of the cave beside the egg (lockedTargetOffsetBase 2 = world).
    //  seat 1, mode 91 "RG Event 2" (flags 0x174, target base 1 = second target, offset z 15): first target the vehicle (0x10),
    //   second target the VEHICLE's channel object (0x20 hops to the vehicle, 0x40 takes its channel object): the view looks
    //   from the camera at a point 15 yd above the camera's channel object: Deathwing's head.
    //  seat 2, mode 94 "RG Event 3" (flags 0x174, target base 1, no offset): looks at the camera's channel object, the mirror image.
    // Without a channel object the second target is invalid and the view falls back to the vehicle's own facing: retail's
    // "camera turned around and just stood there" (2011-05-08). FOV 90 for all three: at 16:9 about +-22 degrees vertically and
    // +-36 horizontally (vertical = FOV / sqrt(aspect^2 + 1)).
    // The camera reads only the channel object (CCameraTarget::CalcTargetGUID). The channel spell field is left empty: the
    // client draws a channel spell's channel kit from the unit to its channel object (CGUnit_C::UpdateChannelEffects), and
    // 87444's SpellMisc visual 277 drew a blue beam from the eye to Deathwing across the whole seat 1 shot
    RG_SEAT_CAVE                                = 0,
    RG_SEAT_DEATHWING                           = 1,
    RG_SEAT_HIDING_PLACE                        = 2,

    // Rhea 46955 (TextRange 5: the actors are the player's private summons)
    TALK_RG_RHEA_LEAVE_THIS                     = 0,    // I'll just leave this right here. (BT 46974, emote 432 use standing)
    TALK_RG_RHEA_GET_THE_EGG                    = 1,    // Now to get the egg... (46975)
    TALK_RG_RHEA_LITTLE_BABY                    = 2,    // How's my little baby doing? (46976)
    TALK_RG_RHEA_ITS_YOU                        = 3,    // No... it's... it's you!  NO! (46977, emote state cower)
    TALK_RG_RHEA_MERCY                          = 4,    // Yes.  Just... just show mercy to the egg. (46981)
    // Deathwing 46957
    TALK_RG_DEATHWING_WHELP                     = 0,    // You impetuous little whelp... (46979)
    TALK_RG_DEATHWING_READY                     = 1,    // Are you ready to die, dragon? (46980)
    TALK_RG_DEATHWING_MERCY                     = 2,    // Mercy?! (46982, yell)
    TALK_RG_DEATHWING_NO_MERCY                  = 3,    // THERE IS NO MERCY!  YOU WILL BURN FOR THIS, DRAGON! (46983, yell)

    EVENT_RG_WAIT_FOR_RIDER                     = 1,
    EVENT_RG_RHEA_WALKS_IN,
    EVENT_RG_NOTE,
    EVENT_RG_TO_THE_EGG,
    EVENT_RG_LITTLE_BABY,
    EVENT_RG_PICKS_UP_THE_EGG,
    EVENT_RG_WALKS_OUT,
    EVENT_RG_ITS_YOU,
    EVENT_RG_SHOT_DEATHWING,
    EVENT_RG_WHELP,
    EVENT_RG_READY_TO_DIE,
    EVENT_RG_SHOW_MERCY,
    EVENT_RG_MERCY,
    EVENT_RG_NO_MERCY,
    EVENT_RG_BREATH,
    EVENT_RG_RHEA_FALLS,
    EVENT_RG_BREATH_AGAIN,
    EVENT_RG_FLIES_OFF,
    EVENT_RG_CAMERA_OUT,
    EVENT_RG_SHOT_HIDING_PLACE,
    EVENT_RG_END,

    POINT_RG_WALK                               = 1,
    POINT_RG_CAMERA                             = 2,
    POINT_RG_FLY_OFF                            = 3
};

// The Hidden Clutch copy of Rhea (section B, guid 3130202) stands here; only her accept starts the scene
Position const RgClutchRheaSpot = { -6540.0f, -2393.4f, 291.81f };
// The mirror image's spot (87434), where 87437 sets the player down at the end
Position const RgHidingPlace = { -6534.23f, -2388.45f, 295.384f };
// The static Rhea's Final Note 206504 (guid 183830), Devastation's ender, just inside the cave
Position const RgStaticNoteSpot = { -6473.92f, -2480.95f, 306.822f };
// The camera's summon spot (87435), in the bushes on the hill
Position const RgCameraSpot = { -6534.23f, -2394.83f, 293.107f };

// The camera (ours: no source places it beyond its summon spot; "the camera pans up to the cave and Rhea walks in", the wiki's
// notes). From the bushes the seat 0 line of sight to its look-at point runs into the hill 25 yd short of the cave (extracted
// maps and vmaps): the camera flies up the hill and in through the cave mouth to a spot 5 yd above the floor at the start of the
// tunnel (floor 305.2, ceiling 314.8). From there the seat 0 view looks down the tunnel at the back of the cave, 19 yd away: the
// note (17 yd, 19 degrees off the axis) and the egg (3 degrees) lie well inside the picture, and Rhea, summoned in the mouth behind the camera, walks past it
// into the picture. Seat 1 from the same spot turns round to Deathwing at the entrance (31 yd; the aim 15 yd above him is 7
// degrees up, through the open mouth): his head, which reaches 16 yd in front of him, is about 15 yd away. His model is far
// wider than its Stand box (Deathwing.m2 skinned at display scale 1.5): the wings reach +-40 yd sideways in ChannelCastOmni (the
// breath) and +-46 yd in FlySitGroundUp / ToFly / FlyRun / FlyStand (lift-off and flight). The tunnel spot lies on the line his
// breath takes from his mouth to Rhea, and the tunnel is the only view into the cave, so with his first line the camera cranes
// out: under the tunnel roof's edge, straight up the open cut in front of his head (11.5 yd from his mesh at the closest, 2.25 yd
// sideways from rock), over the hill to a spot 28 yd above the hillside south-west of the entrance. From there the aim 15 yd
// above him puts his mouth 8 degrees right of and 5 below the centre, his nose 12 / 7, the tunnel mouth his breath goes into
// 21 / 11 and the breath's middle 19 / 11 (the frame is +-36 / +-22 at 16:9), all in sight; the eye is 51 yd from the breath's
// box and 42 yd from his wings during it. As he lifts off and turns north-west his left wing comes no closer than 16 yd (18 if
// the client does not pitch him along the climb). 2 s later the camera flies north down the slope, below and behind him (22 yd
// or more from his mesh), to a spot 4.8 yd above the bushes, 11 yd from the mirror image, and cuts to seat 2: the view looks
// down at the player's copy. Every point of the three flights is 4 yd or more clear of ground and ceiling vertically. (Checked
// by stepping the FlyCurve splines and his path, his yaw and climb along it, against his skinned mesh in every frame of those
// animations, the extracted maps and the vmaps.)
Position const RgCameraFlyIn[] =
{
    { -6531.5f, -2398.0f, 300.0f },
    { -6506.0f, -2424.0f, 313.0f },
    { -6484.0f, -2448.5f, 312.5f },
    { -6473.5f, -2461.5f, 310.5f }
};
Position const RgCameraCrane[] =
{
    { -6475.0f, -2458.0f, 311.5f },
    { -6475.5f, -2456.0f, 313.0f },
    { -6475.5f, -2456.0f, 320.0f },
    { -6475.5f, -2456.0f, 327.0f },
    { -6478.0f, -2459.0f, 332.0f },
    { -6484.0f, -2466.0f, 335.0f },
    { -6496.0f, -2475.0f, 337.0f },
    { -6522.0f, -2488.0f, 343.0f }
};
Position const RgCameraFlyOut[] =
{
    { -6510.0f, -2460.0f, 322.0f },
    { -6515.0f, -2430.0f, 305.0f },
    { -6527.0f, -2396.0f, 299.0f }
};

// Rhea's stops in the cave (ours, on the vmap floor; she walks there by path finding): beside the note (87456's spot, 2.4 yd
// north of it), beside the egg (87460's spot, 1.6 yd west of it) and on the way back out, 9 yd in front of the camera, where she
// sees Deathwing
Position const RgRheaNoteStop = { -6472.8f, -2478.6f, 306.49f };
Position const RgRheaEggStop = { -6469.4f, -2480.4f, 305.66f };
Position const RgRheaSeesDeathwing = { -6472.6f, -2471.0f, 306.25f };

// Deathwing's way off (ours): up from the entrance and away north-west, over the bushes where the player hides ("flies off
// without noticing the player hiding in the bushes outside the cave", 2010-11-30)
Position const RgDeathwingFlyOff[] =
{
    { -6492.0f, -2428.0f, 318.0f },
    { -6515.0f, -2400.0f, 338.0f },
    { -6560.0f, -2350.0f, 355.0f },
    { -6620.0f, -2290.0f, 370.0f }
};

uint32 const RgActorEntries[] = { NPC_RG_RHEA, NPC_RG_MIRROR_IMAGE, NPC_RG_DEATHWING };

// The actors and the camera are the player's personal summons; the camera carries the player up to 110 yd from the copy
float const RgSearchRange = 200.0f;

static bool HoldsRheasGift(Player* player)
{
    return player->GetQuestStatus(QUEST_RHEAS_GIFT_A) == QUEST_STATUS_INCOMPLETE
        || player->GetQuestStatus(QUEST_RHEAS_GIFT_H) == QUEST_STATUS_INCOMPLETE;
}

// "Wait for Rhea to retrieve the egg" (kill credit 46654), once: only while the quest is in progress, also to a dead player.
// The DBC's own credit (87446 effect 1, KILL_CREDIT on target 105) cannot land in this core
static void CreditRheasGift(Player* player)
{
    if (HoldsRheasGift(player))
        player->KilledMonsterCredit(NPC_RHEA);
}

// The player's playerbots holding the quest within 40 yd of the player or of the hiding place (the player rides the camera up
// to the cave; bots follow the player or stay on the hill)
static void CreditRheasGiftBots(Player* player)
{
    Group* group = player->GetGroup();
    if (!group)
        return;

    for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
    {
        Player* member = ref->GetSource();
        if (!member || member == player || !member->GetSession()->IsBot() || !member->IsInMap(player))
            continue;

        if (member->IsWithinDistInMap(player, float(RheaBotCreditRangeYd))
            || member->GetExactDist(&RgHidingPlace) <= float(RheaBotCreditRangeYd))
            CreditRheasGift(member);
    }
}

static Creature* FindRgSummonOf(Player* player, uint32 entry)
{
    std::list<Creature*> creatures;
    player->GetCreatureListWithEntryInGrid(creatures, entry, RgSearchRange);
    for (Creature* creature : creatures)
        if (creature->IsAlive() && creature->IsSummon() && !creature->IsDestroyedObject()
            && creature->ToTempSummon()->GetSummonerGUID() == player->GetGUID())
            return creature;
    return nullptr;
}

// What is left of an earlier scene of this player's (the actors, and the camera if asked)
static void DespawnRgSummonsOf(Player* player, bool includingCamera)
{
    std::list<Creature*> creatures;
    for (uint32 entry : RgActorEntries)
        player->GetCreatureListWithEntryInGridAppend(creatures, entry, RgSearchRange);
    if (includingCamera)
        player->GetCreatureListWithEntryInGridAppend(creatures, NPC_RG_CAMERA, RgSearchRange);

    for (Creature* creature : creatures)
        if (creature->IsSummon() && creature->ToTempSummon()->GetSummonerGUID() == player->GetGUID())
            creature->DespawnOrUnsummon();
}

// A playerbot's group has a real player's scene running near the bot
static bool GroupRunsRheasGift(Player* bot)
{
    Group* group = bot->GetGroup();
    if (!group)
        return false;

    for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
        if (Player* member = ref->GetSource())
            if (member != bot && member->IsInMap(bot) && member->IsWithinDistInMap(bot, RgSearchRange)
                && FindRgSummonOf(member, NPC_RG_CAMERA))
                return true;
    return false;
}

// Taking the Gift on the Hidden Clutch hill plays the scene for a real player (decisions R4: never for a bot). It is started from
// the quest itself (quest_badlands_rheas_gift), not from Rhea's accept hook: 27832 / 27897 carry AUTO_SUBMIT and the Gift
// AUTO_TAKE, so the Gift can also be taken from the quest log or a share, with no Rhea involved. Only on the hill: all Rhea copies
// share the entry and its quest rows, and only the Clutch copy (and the player who took the Gift there) stands where the scene
// is staged; elsewhere the quest stays in progress until it is abandoned and taken again on the hill. The copy is made first, so
// that it takes the player's looks (a mount or a form included) before the camera's seat dismounts the player; then the master
// aura (phase 307, which no spawn uses: it hides nothing; DONT_SAVE) summons the camera, whose summon seats the player in seat 0
// (Ride Vehicle, the first seat that can be entered). A bot that takes the quest is credited when its player's scene ends, or at
// once when none runs near it (ours: a bot cannot watch one)
static void StartRheasGift(Player* player)
{
    if (player->GetSession()->IsBot())
    {
        if (!GroupRunsRheasGift(player))
            CreditRheasGift(player);
        return;
    }

    if (player->GetMapId() != 0 || player->GetExactDist2d(RgClutchRheaSpot.GetPositionX(), RgClutchRheaSpot.GetPositionY()) > 50.0f)
    {
        TC_LOG_ERROR("scripts", "quest_badlands_rheas_gift: %s took Rheastrasza's Gift at %.1f %.1f (map %u), away from the Hidden Clutch; "
            "no scene (abandon it and take it again from Rhea on the Clutch hill)", player->GetName().c_str(), player->GetPositionX(),
            player->GetPositionY(), player->GetMapId());
        return;
    }

    // Already watching; or not able to take a seat (a ghost or on a taxi cannot take a quest from Rhea, but a share can reach one)
    if (FindRgSummonOf(player, NPC_RG_CAMERA) || !player->IsAlive() || player->IsInFlight())
        return;

    // On another vehicle (a passenger mount): off it first, as the camera's seat would take the player off it anyway
    if (player->GetVehicle())
        player->ExitVehicle();

    DespawnRgSummonsOf(player, false);
    player->RemoveAurasDueToSpell(SPELL_RG_MASTER_FORCE_PHASE);

    // The seated player cannot be reached; mobs that followed let go (ours)
    player->CombatStop();

    player->CastSpell(player, SPELL_RG_SUMMON_MIRROR_IMAGE, true);
    player->CastSpell(player, SPELL_RG_MIRROR_IMAGE_AURA, true);
    player->CastSpell(player, SPELL_RG_MASTER_FORCE_PHASE, true);

    // The master aura's trigger is the camera's only summon: should it not have come, it is cast directly; with no camera at all
    // nothing would end the scene, so the quest is completed without it (the chain must not stop here)
    if (!FindRgSummonOf(player, NPC_RG_CAMERA))
        player->CastSpell(player, SPELL_RG_SUMMON_CAMERA, true);
    if (!FindRgSummonOf(player, NPC_RG_CAMERA))
    {
        TC_LOG_ERROR("scripts", "quest_badlands_rheas_gift: no RG Event Camera for %s; Rheastrasza's Gift is completed without its scene",
            player->GetName().c_str());
        DespawnRgSummonsOf(player, false);
        player->RemoveAurasDueToSpell(SPELL_RG_MASTER_FORCE_PHASE);
        CreditRheasGift(player);
        CreditRheasGiftBots(player);
    }
}

// 46955 Rhea, 46956 Player Mirror Image, 46957 Deathwing (Rheastrasza's Gift)
// Passive, out of reach, never in combat; the camera moves and voices them. They stand 60-110 yd from where the camera starts and
// the continent's visibility is 90 yd, so they are shown up to 200 yd (custom visibility) and keep updating far from players
// (active). Without their player or the player's camera they leave.
struct npc_badlands_rg_actor : public ScriptedAI
{
    npc_badlands_rg_actor(Creature* creature) : ScriptedAI(creature), _checkTimer(1 * IN_MILLISECONDS) { }

    void IsSummonedBy(Unit* summoner) override
    {
        _playerGUID = summoner->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
        me->setActive(true, ActiveFlags::Script);
        me->SetCustomVisibilityDistance(VISIBILITY_DISTANCE_LARGE, false);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void DamageTaken(Unit* /*attacker*/, uint32& damage) override
    {
        damage = 0;
    }

    void UpdateAI(uint32 diff) override
    {
        if (_checkTimer > diff)
        {
            _checkTimer -= diff;
            return;
        }

        _checkTimer = 1 * IN_MILLISECONDS;
        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player || !player->IsInWorld() || !FindRgSummonOf(player, NPC_RG_CAMERA))
            me->DespawnOrUnsummon();
    }

private:
    ObjectGuid _playerGUID;
    uint32 _checkTimer;
};

// 46958 - RG Event Camera
// Plays Rheastrasza's Gift once its summoner is seated. Sourced (comments 2010-11-30 [+19], 2011-07-30 [+8]; wiki 27858 / 27898
// / 27930 notes; broadcast texts 46974-46983 and their emotes; the RG spells): Rhea walks into the cave and leaves her note
// ("I'll just leave this right here.", 87456's note), "Now to get the egg...", takes the egg at the back ("How's my little baby
// doing?", 87460's egg, then 87457 Hold Egg), walks back towards the exit and sees Deathwing at the entrance (87442, landed:
// 87458): "No... it's... it's you! NO!", cowering; the camera turns to Deathwing peering in (seat 1); the five-line exchange;
// Deathwing breathes fire into the cave (87455), turns and flies off, the camera following him; then it cuts to the player's
// copy hiding in the bushes (seat 2) and the quest completes. About 20 s from "it's you" to the completion (2011-05-08).
// Ours: the camera's flight, the walking stops, the first half's timings, Rhea's end (87462 and lying down: no source says how
// she is shown), Deathwing's way off, the egg pick-up emote.
//  t+0 the camera flies up to the cave; Rhea appears in the mouth, the egg lies at the back. t+5.5 Rhea walks in. t+16 the note.
//  t+18.5 to the egg; t+20.5 the egg; t+22.5 she takes it; t+23.5 back towards the exit, Deathwing lands at the entrance.
//  t+26.5 "it's you"; t+28 seat 1; t+29 / 32.5 Deathwing, the camera cranes out of the tunnel (to t+36.6); t+35 Rhea; t+37.5 / 39
//  Deathwing yells; t+40.5 and t+43.5 the breath, t+42.5 Rhea falls; t+46.5 Deathwing flies off; t+48.5 the camera flies down to
//  the bushes (there at t+53.6); t+54 seat 2; t+57 the end (within the summons' 120 s).
// Every way out ends it once and completes the quest (the scene's end, death, getting off the seat, never being seated, the
// camera unsummoned by anything else, the player gone from the map; a logout: player_badlands_rg_login), as retail completed it
// when the camera broke or the scene was skipped (2011-05-07, 2011-05-30). Abandoning the quest during the scene ends it without
// credit. The player's playerbots within 40 yd are credited with the player (R4 as amended).
struct npc_badlands_rg_camera : public ScriptedAI
{
    npc_badlands_rg_camera(Creature* creature) : ScriptedAI(creature), _boardTries(0), _started(false), _done(false), _changingSeat(false) { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (Player* player = summoner->ToPlayer())
            _playerGUID = player->GetGUID();

        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC | UNIT_FLAG_NOT_SELECTABLE);
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        me->setActive(true, ActiveFlags::Script);

        _events.ScheduleEvent(EVENT_RG_WAIT_FOR_RIDER, 500ms);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    // Unsummoned by something other than Finish: the core unsummons a player's summons when the player dies, logs out or leaves
    // the map, and the camera (a minion) when the player leaves its seat. A logout is credited at the next login
    void Unsummoned() override
    {
        if (_done)
            return;
        _done = true;
        _events.Reset();
        Cleanup();

        Player* player = ObjectAccessor::FindPlayer(_playerGUID);
        if (!player || player->GetSession()->PlayerLogout())
            return;

        // Still on this map: the player left the seat (Leave Vehicle: the camera is the player's minion and goes at once, before
        // its next update) or died; credited now and set down as at the scene's end. Otherwise on the way out of the map
        if (player->IsInWorld() && player->GetMap() == me->GetMap())
        {
            CreditPlayerAndBots(player);
            if (player->GetVehicleBase() != me)
                SetDown(player);
        }
        else
            CreditLater(player);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_done)
            return;

        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player || !player->IsInWorld())
        {
            Finish(nullptr);
            return;
        }

        // Abandoned during the scene: nothing left to credit
        if (player->GetQuestStatus(QUEST_RHEAS_GIFT_A) == QUEST_STATUS_NONE && player->GetQuestStatus(QUEST_RHEAS_GIFT_H) == QUEST_STATUS_NONE)
        {
            Finish(player);
            return;
        }

        if (_started && !_changingSeat && (!player->IsAlive() || player->GetVehicleBase() != me))
        {
            Finish(player);
            return;
        }

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            SceneEvent(eventId, player);
            if (_done)
                return;
        }
    }

private:
    void SceneEvent(uint32 eventId, Player* player)
    {
        switch (eventId)
        {
            case EVENT_RG_WAIT_FOR_RIDER:
                if (player->GetVehicleBase() == me)
                    Start(player);
                else if (++_boardTries < 6 && player->IsAlive())
                {
                    if (!player->GetVehicle())
                        player->EnterVehicle(me, RG_SEAT_CAVE);
                    _events.ScheduleEvent(EVENT_RG_WAIT_FOR_RIDER, 500ms);
                }
                else
                {
                    // Last resort, not expected: the quest still completes (the chain must not stop here)
                    TC_LOG_ERROR("scripts", "npc_badlands_rg_camera: %s could not be seated in the RG Event Camera (on a vehicle: %u, alive: %u); "
                        "Rheastrasza's Gift is completed without its scene", player->GetName().c_str(), player->GetVehicle() ? 1 : 0, player->IsAlive() ? 1 : 0);
                    Finish(player);
                }
                break;
            case EVENT_RG_RHEA_WALKS_IN:
                RheaWalksTo(RgRheaNoteStop);
                break;
            case EVENT_RG_NOTE:
                // The note she leaves is the static Rhea's Final Note (183830), 0.4 yd from 87456's spot: Devastation's ender, in
                // view all scene long. A second, summoned note beside it would show two; she puts hers down there (emote 432)
                if (Creature* rhea = Actor(NPC_RG_RHEA))
                {
                    rhea->SetFacingTo(rhea->GetAngle(RgStaticNoteSpot.GetPositionX(), RgStaticNoteSpot.GetPositionY()));
                    rhea->AI()->Talk(TALK_RG_RHEA_LEAVE_THIS, player);
                }
                break;
            case EVENT_RG_TO_THE_EGG:
                if (Creature* rhea = Actor(NPC_RG_RHEA))
                    rhea->AI()->Talk(TALK_RG_RHEA_GET_THE_EGG, player);
                RheaWalksTo(RgRheaEggStop);
                break;
            case EVENT_RG_LITTLE_BABY:
                if (Creature* rhea = Actor(NPC_RG_RHEA))
                {
                    if (GameObject* egg = ObjectAccessor::GetGameObject(*me, _eggGUID))
                        rhea->SetFacingToObject(egg);
                    rhea->AI()->Talk(TALK_RG_RHEA_LITTLE_BABY, player);
                }
                break;
            case EVENT_RG_PICKS_UP_THE_EGG:
                // She lifts the egg (ours: the use emote) and carries it (Hold Egg)
                if (GameObject* egg = ObjectAccessor::GetGameObject(*me, _eggGUID))
                    egg->Delete();
                _eggGUID.Clear();
                if (Creature* rhea = Actor(NPC_RG_RHEA))
                {
                    rhea->HandleEmoteCommand(EMOTE_ONESHOT_USE_STANDING);
                    rhea->CastSpell(rhea, SPELL_RG_HOLD_EGG, true);
                }
                break;
            case EVENT_RG_WALKS_OUT:
                RheaWalksTo(RgRheaSeesDeathwing);
                // Deathwing lands at the entrance, behind the camera
                player->CastSpell(player, SPELL_RG_SUMMON_DEATHWING, true);
                Track(player, NPC_RG_DEATHWING);
                if (Creature* deathwing = Actor(NPC_RG_DEATHWING))
                    deathwing->CastSpell(deathwing, SPELL_RG_DEATHWING_FLYSITGROUND, true);
                break;
            case EVENT_RG_ITS_YOU:
                if (Creature* rhea = Actor(NPC_RG_RHEA))
                {
                    if (Creature* deathwing = Actor(NPC_RG_DEATHWING))
                        rhea->SetFacingToObject(deathwing);
                    rhea->AI()->Talk(TALK_RG_RHEA_ITS_YOU, player);
                    rhea->SetEmoteState(EMOTE_STATE_COWER);
                }
                break;
            case EVENT_RG_SHOT_DEATHWING:
                Aim(Actor(NPC_RG_DEATHWING));
                ChangeRiderSeat(player, RG_SEAT_DEATHWING);
                break;
            case EVENT_RG_WHELP:
                DeathwingSays(TALK_RG_DEATHWING_WHELP, player);
                // Out of his breath's way, seat 1 still on him: about 7.6 s (see RgCameraFlyIn's note)
                me->SetSpeed(MOVE_RUN, 1.5f);
                me->SetSpeed(MOVE_FLIGHT, 1.5f);
                FlyCurve(std::begin(RgCameraCrane), std::end(RgCameraCrane), 3.0f);
                break;
            case EVENT_RG_READY_TO_DIE:
                DeathwingSays(TALK_RG_DEATHWING_READY, player);
                break;
            case EVENT_RG_SHOW_MERCY:
                if (Creature* rhea = Actor(NPC_RG_RHEA))
                    rhea->AI()->Talk(TALK_RG_RHEA_MERCY, player);
                break;
            case EVENT_RG_MERCY:
                DeathwingSays(TALK_RG_DEATHWING_MERCY, player);
                break;
            case EVENT_RG_NO_MERCY:
                DeathwingSays(TALK_RG_DEATHWING_NO_MERCY, player);
                break;
            case EVENT_RG_BREATH:
            case EVENT_RG_BREATH_AGAIN:
                if (Creature* deathwing = Actor(NPC_RG_DEATHWING))
                    deathwing->CastSpell(deathwing, SPELL_RG_FLAME_BREATH, true);
                break;
            case EVENT_RG_RHEA_FALLS:
                if (Creature* rhea = Actor(NPC_RG_RHEA))
                {
                    rhea->SetEmoteState(EMOTE_ONESHOT_NONE);
                    rhea->RemoveAurasDueToSpell(SPELL_RG_HOLD_EGG);
                    rhea->CastSpell(rhea, SPELL_RG_EMOTE_STATE_FALL, true);
                    rhea->SetStandState(UNIT_STAND_STATE_DEAD);
                }
                break;
            case EVENT_RG_FLIES_OFF:
                if (Creature* deathwing = Actor(NPC_RG_DEATHWING))
                {
                    deathwing->InterruptNonMeleeSpells(false);
                    deathwing->RemoveAurasDueToSpell(SPELL_RG_DEATHWING_FLYSITGROUND);
                    // Flying for the client too: Creature::SetFlying sets the Fly animation tier (UNIT_FIELD_BYTES_1 byte 3), from
                    // which the client picks FlyRun / FlyStand instead of Walk / Run (CGUnit_C::UpdateAnimKitMgrTier); gravity
                    // alone leaves him on the Ground tier, walking through the air. 46957's template carries
                    // CREATURE_FLAG_EXTRA_NO_MOVE_FLAGS_UPDATE (2026_11_20_94): otherwise the movement flag update, seeing him
                    // still on the ground in the first tick of the climb and with no flight in his template, takes the flight
                    // and the tier off again for good
                    deathwing->SetCanFly(true);
                    deathwing->SetFlying(true);
                    deathwing->SetSpeed(MOVE_RUN, 2.5f);
                    deathwing->SetSpeed(MOVE_FLIGHT, 2.5f);
                    std::vector<Position> path(1, deathwing->GetPosition());
                    path.insert(path.end(), std::begin(RgDeathwingFlyOff), std::end(RgDeathwingFlyOff));
                    deathwing->GetMotionMaster()->Clear();
                    deathwing->GetMotionMaster()->MoveSmoothPath(POINT_RG_FLY_OFF, path.data(), path.size(), false, true);
                }
                break;
            case EVENT_RG_CAMERA_OUT:
                // Once he is well up and away: about 5.1 s to the bushes (see RgCameraFlyIn's note)
                me->SetSpeed(MOVE_RUN, 3.0f);
                me->SetSpeed(MOVE_FLIGHT, 3.0f);
                FlyCurve(std::begin(RgCameraFlyOut), std::end(RgCameraFlyOut), 6.0f);
                break;
            case EVENT_RG_SHOT_HIDING_PLACE:
                Aim(Actor(NPC_RG_MIRROR_IMAGE));
                ChangeRiderSeat(player, RG_SEAT_HIDING_PLACE);
                break;
            case EVENT_RG_END:
                Finish(player);
                break;
            default:
                break;
        }
    }

    void Start(Player* player)
    {
        _started = true;

        Track(player, NPC_RG_MIRROR_IMAGE);
        player->CastSpell(player, SPELL_RG_SUMMON_RHEA, true);
        Track(player, NPC_RG_RHEA);
        _eggGUID = SpawnSceneObject(player, GO_RG_DRAGON_EGG, SPELL_RG_SUMMON_EGG);

        me->SetSpeed(MOVE_RUN, 2.5f);
        me->SetSpeed(MOVE_FLIGHT, 2.5f);
        FlyCurve(std::begin(RgCameraFlyIn), std::end(RgCameraFlyIn), 6.0f);

        _events.ScheduleEvent(EVENT_RG_RHEA_WALKS_IN, 5500ms);
        _events.ScheduleEvent(EVENT_RG_NOTE, 16s);
        _events.ScheduleEvent(EVENT_RG_TO_THE_EGG, 18500ms);
        _events.ScheduleEvent(EVENT_RG_LITTLE_BABY, 20500ms);
        _events.ScheduleEvent(EVENT_RG_PICKS_UP_THE_EGG, 22500ms);
        _events.ScheduleEvent(EVENT_RG_WALKS_OUT, 23500ms);
        _events.ScheduleEvent(EVENT_RG_ITS_YOU, 26500ms);
        _events.ScheduleEvent(EVENT_RG_SHOT_DEATHWING, 28s);
        _events.ScheduleEvent(EVENT_RG_WHELP, 29s);
        _events.ScheduleEvent(EVENT_RG_READY_TO_DIE, 32500ms);
        _events.ScheduleEvent(EVENT_RG_SHOW_MERCY, 35s);
        _events.ScheduleEvent(EVENT_RG_MERCY, 37500ms);
        _events.ScheduleEvent(EVENT_RG_NO_MERCY, 39s);
        _events.ScheduleEvent(EVENT_RG_BREATH, 40500ms);
        _events.ScheduleEvent(EVENT_RG_RHEA_FALLS, 42500ms);
        _events.ScheduleEvent(EVENT_RG_BREATH_AGAIN, 43500ms);
        _events.ScheduleEvent(EVENT_RG_FLIES_OFF, 46500ms);
        _events.ScheduleEvent(EVENT_RG_CAMERA_OUT, 48500ms);
        _events.ScheduleEvent(EVENT_RG_SHOT_HIDING_PLACE, 54s);
        _events.ScheduleEvent(EVENT_RG_END, 57s);
    }

    void RheaWalksTo(Position const& stop)
    {
        if (Creature* rhea = Actor(NPC_RG_RHEA))
        {
            rhea->SetWalk(true);
            rhea->SetSpeed(MOVE_WALK, 1.8f);
            rhea->GetMotionMaster()->Clear();
            rhea->GetMotionMaster()->MovePoint(POINT_RG_WALK, stop);
        }
    }

    void DeathwingSays(uint8 textId, Player* player)
    {
        if (Creature* deathwing = Actor(NPC_RG_DEATHWING))
            deathwing->AI()->Talk(textId, player);
    }

    // The seats' CameraModes 91 and 94 look at the camera's channel object (see the seat note above); no channel spell, so that
    // no beam is drawn from the eye to the subject
    void Aim(Unit* target)
    {
        me->SetGuidValue(UNIT_FIELD_CHANNEL_OBJECT, target ? target->GetGUID() : ObjectGuid::Empty);
    }

    // Unit::ChangeSeat takes the passenger off and seats them again within the call: no early exit
    void ChangeRiderSeat(Player* player, int8 seatId)
    {
        if (player->GetVehicleBase() != me)
            return;

        _changingSeat = true;
        player->ChangeSeat(seatId);
        _changingSeat = false;
        player->RemoveAurasDueToSpell(VEHICLE_SPELL_PARACHUTE);
    }

    // A scene object (the egg) at its summon spell's spot, as SPELL_EFFECT_SUMMON_PERSONAL_GAMEOBJECT makes it (private
    // to the player) but with the spot's own facing, shown from 200 yd like the actors, and removed by the scene itself (the
    // effect sets no despawn for an object it does not hand to an owner)
    ObjectGuid SpawnSceneObject(Player* player, uint32 entry, uint32 spotSpellId)
    {
        SpellTargetPosition const* spot = sSpellMgr->GetSpellTargetPosition(spotSpellId, EFFECT_0);
        if (!spot || spot->target_mapId != me->GetMapId())
            return ObjectGuid::Empty;

        Map* map = me->GetMap();
        G3D::Quat const rot(G3D::Matrix3::fromEulerAnglesZYX(spot->target_Orientation, 0.0f, 0.0f));
        GameObject* go = new GameObject();
        if (!go->Create(map->GenerateLowGuid<HighGuid::GameObject>(), entry, map, player->GetPhaseMask(), spot->target_X, spot->target_Y,
            spot->target_Z, spot->target_Orientation, rot, 100, GO_STATE_READY))
        {
            delete go;
            return ObjectGuid::Empty;
        }

        for (uint32 phase : player->GetPhases())
            go->SetPhased(phase, false, true);
        // Gone after 120 s at the latest (the summons' duration), should no exit of the scene remove it
        go->SetRespawnTime(120);
        go->SetSpawnedByDefault(false);
        go->SetPrivateObjectOwner(player->GetGUID());
        go->SetCustomVisibilityDistance(VISIBILITY_DISTANCE_LARGE, false);
        map->AddToMap(go);
        _objects.push_back(go->GetGUID());
        return go->GetGUID();
    }

    // Flies the camera along one smooth curve through the corners at an even pace (scripted-quest-scenes, FlyCurve: a clamped
    // uniform cubic B-spline sampled every `step` yards), from where it is
    void FlyCurve(Position const* first, Position const* last, float step)
    {
        Position const here = me->GetPosition();
        std::vector<Position> controls(3, here);
        controls.insert(controls.end(), first, last);
        Position const end = controls.back();
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
        me->GetMotionMaster()->MoveSmoothPath(POINT_RG_CAMERA, path.data(), path.size(), false, true);
    }

    void Track(Player* player, uint32 entry)
    {
        if (Creature* actor = FindRgSummonOf(player, entry))
            _actors[entry] = actor->GetGUID();
    }

    Creature* Actor(uint32 entry)
    {
        auto itr = _actors.find(entry);
        if (itr == _actors.end())
            return nullptr;

        Creature* actor = ObjectAccessor::GetCreature(*me, itr->second);
        return actor && actor->IsAlive() ? actor : nullptr;
    }

    // The actors and the scene object go, and the aim with them
    void Cleanup()
    {
        Aim(nullptr);
        for (auto const& actor : _actors)
            if (Creature* creature = ObjectAccessor::GetCreature(*me, actor.second))
                creature->DespawnOrUnsummon();
        _actors.clear();

        for (ObjectGuid const& guid : _objects)
            if (GameObject* go = ObjectAccessor::GetGameObject(*me, guid))
                go->Delete();
        _objects.clear();
        _eggGUID.Clear();
    }

    // The player and the player's playerbots, only while the player still holds the quest (an abandoned Gift credits nobody)
    static void CreditPlayerAndBots(Player* player)
    {
        if (!HoldsRheasGift(player))
            return;

        CreditRheasGift(player);
        CreditRheasGiftBots(player);
    }

    // A player who may be in the middle of leaving the map: credited from the player's own event queue a moment later, once in a
    // map again. A logout destroys the queue with the player (player_badlands_rg_login credits at the next login)
    static void CreditLater(Player* player)
    {
        if (player->GetSession()->PlayerLogout())
            return;

        player->m_Events.AddLambdaEventAtOffset([player]()
        {
            if (!player->IsInWorld() || player->GetSession()->PlayerLogout())
                return;

            player->RemoveAurasDueToSpell(SPELL_RG_MASTER_FORCE_PHASE);
            CreditPlayerAndBots(player);
        }, 500);
    }

    // Sets a living player who is off the camera down at the hiding place, as the scene's end does (87437, which also ends the
    // master aura). As the Hillsbrad cameras: the player hovers where the camera let go (gravity off; not rooted: a root or a
    // teleport in the exit's own tick cuts the exit's jump off and leaves the view stuck in the camera), the end spell goes 300 ms
    // later, gravity comes back after it. Not for a dead player, nor one who has left the hill (another map, a teleport away)
    static void SetDown(Player* player)
    {
        if (!player->IsAlive())
        {
            player->RemoveAurasDueToSpell(SPELL_RG_MASTER_FORCE_PHASE);
            return;
        }

        player->SetDisableGravity(true);

        player->m_Events.AddLambdaEventAtOffset([player]()
        {
            if (!player->IsInWorld())
                return;

            if (!player->GetVehicle() && player->IsAlive() && player->GetMapId() == 0 && player->GetExactDist(&RgHidingPlace) < 300.0f)
            {
                player->CastSpell(player, SPELL_RG_CANCEL_PHASE_AND_TELEPORT, true);
                if (!player->IsBeingTeleported() && player->GetExactDist(&RgHidingPlace) > 5.0f)
                    player->NearTeleportTo(RgHidingPlace.GetPositionX(), RgHidingPlace.GetPositionY(), RgHidingPlace.GetPositionZ(),
                        RgHidingPlace.GetOrientation());
            }
            player->RemoveAurasDueToSpell(SPELL_RG_MASTER_FORCE_PHASE);

            // Once set down. The enable is sent twice: the player's own movement packets replace the server's flags, so one sent
            // before the client took the hold would leave the client hovering (scripted-quest-scenes, Finish)
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

    // Credits the player and the player's bots, lets the player out and sets the player down (SetDown)
    void Finish(Player* player)
    {
        if (_done)
            return;
        _done = true;
        _events.Reset();

        Cleanup();

        if (!player)
        {
            // Gone from this map but still playing (a teleport): the credit follows
            if (Player* away = ObjectAccessor::FindPlayer(_playerGUID))
                CreditLater(away);
            me->DespawnOrUnsummon(500);
            return;
        }

        DespawnRgSummonsOf(player, false);
        CreditPlayerAndBots(player);

        if (player->GetVehicleBase() == me)
            player->ExitVehicle();

        SetDown(player);
        me->DespawnOrUnsummon(500);
    }

    EventMap _events;
    ObjectGuid _playerGUID;
    std::map<uint32, ObjectGuid> _actors;
    std::vector<ObjectGuid> _objects;
    ObjectGuid _eggGUID;
    uint8 _boardTries;
    bool _started;
    bool _done;
    bool _changingSeat;
};

// A player who logged out during the scene was saved, before the scene's summons went, with the quest in progress, somewhere on
// the camera's way between the bushes and the cave. Logging in alive near the Hidden Clutch (within 150 yd of the camera's summon
// spot: the cave is 107 yd from it) with the quest in progress completes it (ours). A ghost is left out: a player who died in
// the scene was credited by the scene's end
class player_badlands_rg_login : public PlayerScript
{
public:
    player_badlands_rg_login() : PlayerScript("player_badlands_rg_login") { }

    void OnLogin(Player* player) override
    {
        if (player->GetMapId() != 0 || !player->IsAlive() || !HoldsRheasGift(player))
            return;

        if (player->GetExactDist2d(RgCameraSpot.GetPositionX(), RgCameraSpot.GetPositionY()) > 150.0f)
            return;

        player->RemoveAurasDueToSpell(SPELL_RG_MASTER_FORCE_PHASE);
        CreditRheasGift(player);
    }
};

// 27858 / 27898 - Rheastrasza's Gift
// Taken (from Rhea, the quest log or a share): the scene starts a moment later, outside the quest code that took it
class quest_badlands_rheas_gift : public QuestScript
{
public:
    quest_badlands_rheas_gift() : QuestScript("quest_badlands_rheas_gift") { }

    void OnQuestStatusChange(Player* player, Quest const* /*quest*/, QuestStatus oldStatus, QuestStatus newStatus) override
    {
        if (oldStatus != QUEST_STATUS_NONE || newStatus != QUEST_STATUS_INCOMPLETE)
            return;

        player->m_Events.AddLambdaEventAtOffset([player]()
        {
            if (player->IsInWorld() && !player->GetSession()->PlayerLogout() && HoldsRheasGift(player))
                StartRheasGift(player);
        }, 1);
    }
};

// 87439 - RG: Mirror Image Aura
// The player's copy takes the player's looks (effect 0, CLONE_CASTER) and weapons: effects 1 and 2 are script effects whose values
// are Copy Weapon 41055 and Copy Off-hand Weapon 45206, which the player casts on the copy (spell_gen_clone_weapon). The condition
// names only the entry; the target is the caster's own copy (as spell_epl_gfr_mirror_image)
class spell_badlands_rg_mirror_image : public SpellScript
{
    PrepareSpellScript(spell_badlands_rg_mirror_image);

    void SelectOwnCopy(WorldObject*& target)
    {
        if (Player* player = GetCaster()->ToPlayer())
            if (Creature* own = FindRgSummonOf(player, NPC_RG_MIRROR_IMAGE))
                if (own->IsWithinDistInMap(player, 40.0f))
                {
                    target = own;
                    return;
                }

        // Never someone else's copy standing on the same spot
        target = nullptr;
    }

    void HandleCopyWeapon(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);
        if (Unit* target = GetHitUnit())
            GetCaster()->CastSpell(target, uint32(GetEffectValue()), true);
    }

    void Register() override
    {
        OnObjectTargetSelect += SpellObjectTargetSelectFn(spell_badlands_rg_mirror_image::SelectOwnCopy, EFFECT_0, TARGET_UNIT_NEARBY_ENTRY);
        OnObjectTargetSelect += SpellObjectTargetSelectFn(spell_badlands_rg_mirror_image::SelectOwnCopy, EFFECT_1, TARGET_UNIT_NEARBY_ENTRY);
        OnObjectTargetSelect += SpellObjectTargetSelectFn(spell_badlands_rg_mirror_image::SelectOwnCopy, EFFECT_2, TARGET_UNIT_NEARBY_ENTRY);
        OnEffectHitTarget += SpellEffectFn(spell_badlands_rg_mirror_image::HandleCopyWeapon, EFFECT_1, SPELL_EFFECT_SCRIPT_EFFECT);
        OnEffectHitTarget += SpellEffectFn(spell_badlands_rg_mirror_image::HandleCopyWeapon, EFFECT_2, SPELL_EFFECT_SCRIPT_EFFECT);
    }
};

// 87436 - RG: Master Force Phase/Invis
// "Phase/Invis": the master aura of the scene. In the 5.4.8 DBC it carries only the phase (307, which no spawn uses) and the
// camera's summon; the "Invis" half is not in the data. The player rides the camera, a personal summon nobody else's client
// knows, so to everyone else the rider would hang in the air or fly about on nothing; the player's own copy (also personal)
// stands in the bushes for him. While the aura lasts the rider is hidden from everyone else the server-side way, as a GM is (as
// spell_hillsbrad_scene_camera_ride), which leaves the rider's own sight alone. Every exit of the scene removes the aura (the
// end's 87437, SetDown, CreditLater, death; DONT_SAVE at a logout), and the rider is shown again with it. Ours: another player
// on the hill sees the player vanish when he takes the Gift and reappear at the bushes 6 yd away when the scene ends.
class spell_badlands_rg_master_force_phase : public AuraScript
{
    PrepareAuraScript(spell_badlands_rg_master_force_phase);

    void AfterApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Player* player = GetTarget()->ToPlayer();
        if (!player || !player->IsVisible())
            return;

        _hidden = true;
        player->SetVisible(false);
    }

    void AfterRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (!_hidden)
            return;

        _hidden = false;
        GetTarget()->SetVisible(true);
    }

    void Register() override
    {
        AfterEffectApply += AuraEffectApplyFn(spell_badlands_rg_master_force_phase::AfterApply, EFFECT_0, SPELL_AURA_PHASE, AURA_EFFECT_HANDLE_REAL);
        AfterEffectRemove += AuraEffectRemoveFn(spell_badlands_rg_master_force_phase::AfterRemove, EFFECT_0, SPELL_AURA_PHASE, AURA_EFFECT_HANDLE_REAL);
    }

    bool _hidden = false;
};

// 46654 - Rhea (every copy: the camp in Lethlor Ravine, and the staging copies at Dragon's Mouth, New Kargath and the Hidden Clutch)
// Replaces her SmartAI (ids 0-2: Rhea Revealed's line on accept and the credit 7 s later to the last invoker only).
// Rhea Revealed 27769: on accept she says her line (BT 46758, emote 5: the wiki's notes), and 7 s later the player "discovers
// her true identity": the credit completes the quest, spell_area 59073 moves the player to phasemask 2 and Rheastrasza 46655
// stands where Rhea stood (the swap is mop's, unchanged).
// Lifting the Veil 27770: on accept she says "I will now remove the fog from your eyes. Behold, our captive." (BT 46757, the
// wiki's notes) and Nyxondra appears to the south (her quest invisibility 83305 against the detection 87007 that the accept
// gives: section B); the quest needs no fight, "just stand there ... turn in the quest" (comments 2010-11-29, 2010-12-03): 3 s
// after the accept (ours) the player has witnessed the captive. Nyxondra cannot be killed at this point (27771, section A), so
// her kill credit is given by Rhea.
// Both happen in front of Rhea, so both run from her: at the accept from her, and otherwise (the quest taken by a party share,
// or a timer lost to a relog or to her grid unloading) as soon as the player holding the quest in progress stands within 30 yd
// of a Rhea copy the player can see (ours: the sources put the reveal and the veil at her; a share taken far away completes when
// the player comes to her). Each player has his own timer, so several players or bots are all credited; the credit also goes to
// the player's playerbots within 40 yd (R4 as amended; ours). A bot standing at her is credited on its own as well.
// Rheastrasza's Gift 27858 / 27898 is started from the quest (quest_badlands_rheas_gift), however it was taken
struct npc_badlands_rhea : public ScriptedAI
{
    npc_badlands_rhea(Creature* creature) : ScriptedAI(creature), _scanTimer(RheaScanMs) { }

    void OnQuestAccept(Player* player, Quest const* quest) override
    {
        Begin(player, quest->GetQuestId());
    }

    void UpdateAI(uint32 diff) override
    {
        for (auto itr = _pending.begin(); itr != _pending.end();)
        {
            if (itr->timer > diff)
            {
                itr->timer -= diff;
                ++itr;
                continue;
            }

            if (Player* player = ObjectAccessor::GetPlayer(*me, itr->playerGUID))
            {
                if (player->GetQuestStatus(itr->questId) == QUEST_STATUS_INCOMPLETE)
                {
                    player->KilledMonsterCredit(itr->creditEntry);
                    CreditRheaBots(player, itr->questId, itr->creditEntry);
                }
            }
            itr = _pending.erase(itr);
        }

        if (_scanTimer > diff)
        {
            _scanTimer -= diff;
            return;
        }

        _scanTimer = RheaScanMs;
        std::list<Player*> players;
        me->GetPlayerListInGrid(players, RheaScanRangeYd);
        for (Player* player : players)
        {
            if (!player->IsAlive() || !player->CanSeeOrDetect(me))
                continue;

            for (uint32 questId : { uint32(QUEST_RHEA_REVEALED), uint32(QUEST_LIFTING_THE_VEIL) })
                if (player->GetQuestStatus(questId) == QUEST_STATUS_INCOMPLETE)
                    Begin(player, questId);
        }
    }

private:
    static constexpr uint32 RheaScanMs = 2 * IN_MILLISECONDS;
    static constexpr float RheaScanRangeYd = 30.0f;

    struct PendingCredit
    {
        ObjectGuid playerGUID;
        uint32 questId;
        uint32 creditEntry;
        uint32 timer;
    };

    // Her line and the player's timer, once per player and quest while it runs
    void Begin(Player* player, uint32 questId)
    {
        uint8 textId;
        uint32 creditEntry;
        uint32 delay;
        switch (questId)
        {
            case QUEST_RHEA_REVEALED:
                textId = TALK_RHEA_REVEALED;
                creditEntry = NPC_RHEA;
                delay = 7 * IN_MILLISECONDS;
                break;
            case QUEST_LIFTING_THE_VEIL:
                textId = TALK_RHEA_LIFT_THE_VEIL;
                creditEntry = NPC_NYXONDRA;
                delay = 3 * IN_MILLISECONDS;
                break;
            default:
                return;
        }

        if (player->GetQuestStatus(questId) != QUEST_STATUS_INCOMPLETE)
            return;

        for (PendingCredit const& pending : _pending)
            if (pending.playerGUID == player->GetGUID() && pending.questId == questId)
                return;

        Talk(textId, player);
        _pending.push_back({ player->GetGUID(), questId, creditEntry, delay });
    }

    std::list<PendingCredit> _pending;
    uint32 _scanTimer;
};

void AddSC_badlands_rhea()
{
    new creature_script<npc_badlands_rhea>("npc_badlands_rhea");
    new creature_script<npc_badlands_rg_actor>("npc_badlands_rg_actor");
    new creature_script<npc_badlands_rg_camera>("npc_badlands_rg_camera");
    new player_badlands_rg_login();
    new quest_badlands_rheas_gift();
    new spell_script<spell_badlands_rg_mirror_image>("spell_badlands_rg_mirror_image");
    new aura_script<spell_badlands_rg_master_force_phase>("spell_badlands_rg_master_force_phase");
}
