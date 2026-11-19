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

/* Durotar: the Dranosh'ar Blockade and the north
 *
 * The Wolf and The Kodo (25205)   Shin Stonepillar's fable, lived through as The Wolf
 * Thunder Down Under (25236)      a laborer on the shore hauls the tethered Drowned Thunder Lizard out
 * Skull Rock (25262)              the Burning Blade cultists outside the cave survive the 5.4 Kor'kron, so players still get their kills
 *
 * The rest of Durotar's scripts are in zone_durotar.cpp.
 */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "CombatAI.h"
#include "Player.h"
#include "Vehicle.h"
#include "TemporarySummon.h"
#include "SpellScript.h"
#include "SpellAuraEffects.h"
#include "SmartAI.h"
#include "WorldSession.h"

namespace
{

enum SkullRock
{
    // NPCs take a cultist down to this share of its health and no further (as creature_sparring_template's limit)
    SKULL_ROCK_NPC_DAMAGE_FLOOR_PCT     = 85,
    // A cultist no player has hit for this long, with no player or player's unit left in its fight, drops the player's tag (ours)
    SKULL_ROCK_TAG_TIMEOUT_MS           = 10 * IN_MILLISECONDS
};

// 3197 Burning Blade Fanatic, 3198 Burning Blade Apprentice (every spawn is at Skull Rock, area 817)
// Since 5.4 the Kor'kron (Grunts 71379, Motivators 71052, Spotters 71055, level 90 elites) camp outside Skull Rock and fight the
// cultists; on retail "the Fanatics aren't dying to them - they're tough" (Wowhead 71055, 2013-09-19), and the 2013-12-13 comment on
// Skull Rock shows a Fanatic holding off eight of them. Here a single Kor'kron hit is far above a cultist's health:
// creature_sparring_template alone only stops it at 1 hp (Unit::DealDamage's first check), which would leave the player a 1-hp
// cultist that gives no loot (the player must do half its health, Creature::IsDamageEnoughForLootingAndReward). So damage from any
// creature no player controls is cut at 85 % of the cultist's health as well; players, their pets and guardians are not limited.
// The cultists' own SmartAI (both TDBs) is kept. Plan ruling R20. Ours: the 85 % (the sparring value used elsewhere here).
struct npc_durotar_skull_rock_cultist : public SmartAI
{
    npc_durotar_skull_rock_cultist(Creature* creature) : SmartAI(creature) { }

    void DamageTaken(Unit* attacker, uint32& damage) override
    {
        SmartAI::DamageTaken(attacker, damage);

        if (attacker && attacker->IsCharmedOwnedByPlayerOrPlayer())
            _lastPlayerHit = getMSTime();

        if (!attacker || attacker == me || attacker->IsCharmedOwnedByPlayerOrPlayer())
            return;

        uint32 const floor = me->CountPctFromMaxHealth(SKULL_ROCK_NPC_DAMAGE_FLOOR_PCT);
        uint32 const health = me->GetHealth();
        damage = health > floor ? std::min(damage, health - floor) : 0;
    }

    // A cultist a player hit and then left (died, ran off) while it goes on fighting a Kor'kron would stay tagged to him at reduced
    // health for good: the core clears a tag only at an evade or a death (SmartAI::EnterEvadeMode, Creature::setDeathState), and the
    // endless fight never evades. Once no player or player's unit of its fight has been within 60 yd for 10 s (dead, run off, on
    // another map or logged out) and none has hit it for 10 s, the tag and the
    // player-damage requirement are cleared and its health is restored, so the next player gets the kill, the loot and the collar
    void UpdateAI(uint32 diff) override
    {
        SmartAI::UpdateAI(diff);

        if (_tagCheckTimer > diff)
        {
            _tagCheckTimer -= diff;
            return;
        }
        _tagCheckTimer = 1000;

        if (!me->IsAlive() || !me->IsInCombat() || !me->HasLootRecipient())
            return;

        // A player (or his unit) of the fight within 60 yd keeps it; one who ran off alive stays on the threat list (the endless
        // fight never evades) but no longer counts once he is farther, on another map or gone
        for (ThreatReference const* ref : me->GetThreatManager().GetUnsortedThreatList())
        {
            Unit* victim = ref->GetVictim();
            if (victim->IsCharmedOwnedByPlayerOrPlayer() && victim->IsInWorld() && victim->IsInMap(me) && me->IsWithinDistInMap(victim, 60.0f))
            {
                _lastPlayerNear = getMSTime();
                return;
            }
        }

        if (getMSTimeDiff(_lastPlayerHit, getMSTime()) < SKULL_ROCK_TAG_TIMEOUT_MS
            || getMSTimeDiff(_lastPlayerNear, getMSTime()) < SKULL_ROCK_TAG_TIMEOUT_MS)
            return;

        me->SetLootRecipient(nullptr);
        me->SetFullHealth();
        me->ResetPlayerDamageReq();
    }

private:
    uint32 _lastPlayerHit = 0;
    uint32 _lastPlayerNear = 0;
    uint32 _tagCheckTimer = 1000;
};

enum ThunderDownUnder
{
    NPC_DROWNED_THUNDER_LIZARD          = 39464,
    NPC_HULKING_ORCISH_LABORER          = 39465,
    SPELL_LIFT_DROWNED_LIZARD_EFFECT    = 73951,
    DATA_LIZARD_HAULED                  = 1
};

// Ours: the nearest dry ground to each of the 19 lizard spawns of the Thunder Ridge lake (ground.py over the 5.4.8 maps: the
// first point at least 3 yd onto land at the water's level, 17.9; the lizards lie 11-31 yd under it, 12-40 yd from these points)
Position const ThunderRidgeShore[] =
{
    { 713.0f, -4018.0f, 19.20f }, { 829.1f, -4008.2f, 22.29f }, { 758.0f, -4045.2f, 23.11f }, { 902.9f, -4140.2f, 19.05f },
    { 988.2f, -4177.1f, 19.48f }, { 916.3f, -4256.7f, 20.63f }, { 948.9f, -3999.6f, 21.02f }, { 985.3f, -4105.6f, 19.22f },
    { 918.5f, -4117.9f, 22.51f }, { 913.6f, -4201.4f, 19.75f }, { 997.9f, -4046.0f, 22.59f }, { 983.5f, -4281.3f, 21.14f },
    { 886.0f, -3993.8f, 21.73f }, { 768.9f, -4085.6f, 21.90f }, { 842.9f, -4084.0f, 22.54f }, { 816.9f, -4011.9f, 22.63f },
    { 840.0f, -4077.2f, 21.13f }, { 865.0f, -4063.5f, 21.88f }, { 918.3f, -4071.6f, 22.19f }
};

// 73945 - Attach Tether (Thunder Down Under 25236; the player's click on a Drowned Thunder Lizard, cast_flags 1)
// Sourced: a 1 s cast attaches the rope (2011-08-09 [+8]), a Hulking Orcish Laborer hauls the carcass out and it is gone (npc
// 39465 [+11]; quest text "I've got grunts that can lift them out"; 2011-11-30 "tether them up to surface"). The spell's summon
// (effect 0, DEST_NEARBY_ENTRY: the lizard itself, by its source-13 condition) would put the laborer inside the carcass on the
// lake floor; it is replaced: the laborer stands on the nearest shore point, facing the lizard, and casts the rope (73951, a
// channelled dummy aura) on it, while the carcass floats up towards him and is gone after 7 s (back in 60 s with its click). The
// lizard stops discharging once hauled (SmartAI phase 2). The credit is effect 1 (KILL_CREDIT2, unchanged), so it does not
// depend on any of this. Ours: the shore points, the haul's way and timings.
class spell_durotar_attach_tether : public SpellScript
{
    PrepareSpellScript(spell_durotar_attach_tether);

    void HandleSummon(SpellEffIndex effIndex)
    {
        PreventHitDefaultEffect(effIndex);

        Player* caster = GetCaster()->ToPlayer();
        if (!caster)
            return;

        // The clicked lizard. The spell has no unit target (Spell::InitExplicitTargets drops the clickee), but a right-click selects
        // the unit: the player's selection, if it is a lizard within reach. A selected lizard already being hauled (another player
        // tethered it in the same second) is left alone: both are credited, one laborer. With no lizard selected, the nearest lizard
        // within 8 yd that can still be clicked
        Creature* lizard = nullptr;
        if (Creature* selected = ObjectAccessor::GetCreature(*caster, caster->GetTarget()))
            if (selected->GetEntry() == NPC_DROWNED_THUNDER_LIZARD && selected->IsWithinDistInMap(caster, 10.0f))
            {
                if (!selected->HasFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK))
                    return;
                lizard = selected;
            }
        if (!lizard)
        {
            std::list<Creature*> lizards;
            caster->GetCreatureListWithEntryInGrid(lizards, NPC_DROWNED_THUNDER_LIZARD, 8.0f);
            for (Creature* candidate : lizards)
                if (candidate->IsAlive() && candidate->HasFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK)
                    && (!lizard || caster->GetExactDist(candidate) < caster->GetExactDist(lizard)))
                    lizard = candidate;
        }
        if (!lizard)
            return;

        Position const* shore = &ThunderRidgeShore[0];
        for (Position const& pos : ThunderRidgeShore)
            if (lizard->GetExactDist(&pos) < lizard->GetExactDist(shore))
                shore = &pos;

        lizard->RemoveFlag(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);
        lizard->InterruptNonMeleeSpells(false);
        if (lizard->IsAIEnabled)
            lizard->AI()->SetData(DATA_LIZARD_HAULED, 1);

        // The rope is cast triggered (no cast bar to break) and ignores line of sight (disables 73951, flag 64): a bank between the
        // shore point and a lizard deep under the water must not leave a man standing on a beach. Passive, so a passing beast does
        // not draw him into a fight that would cut the channel
        if (Creature* laborer = caster->SummonCreature(NPC_HULKING_ORCISH_LABORER, *shore, TEMPSUMMON_TIMED_DESPAWN, 9000ms))
        {
            laborer->SetReactState(REACT_PASSIVE);
            laborer->SetFacingToObject(lizard);
            laborer->CastSpell(lizard, SPELL_LIFT_DROWNED_LIZARD_EFFECT, true);
        }

        // Up the rope: to 5 yd short of the laborer, straight (gravity off; it is a carcass)
        float dist = lizard->GetExactDist(shore);
        float f = dist > 5.0f ? (dist - 5.0f) / dist : 0.0f;
        lizard->SetDisableGravity(true);
        lizard->GetMotionMaster()->MovePoint(0, lizard->GetPositionX() + (shore->GetPositionX() - lizard->GetPositionX()) * f,
            lizard->GetPositionY() + (shore->GetPositionY() - lizard->GetPositionY()) * f,
            lizard->GetPositionZ() + (shore->GetPositionZ() - lizard->GetPositionZ()) * f, false);
        lizard->DespawnOrUnsummon(7000);
    }

    void Register() override
    {
        OnEffectHit += SpellEffectFn(spell_durotar_attach_tether::HandleSummon, EFFECT_0, SPELL_EFFECT_SUMMON);
    }
};

/* The Wolf and The Kodo (25205)
 *
 * Sourced (Wowhead comments 2010-12-06 [+22], 2011-03-24 [+6], 2011-03-26 [+9], 2012-08-28 [+7]; warcraft.wiki.gg Notes and the
 * hotfix of 2010-11-24; screenshots 242284-242290 and 248811; DBC 5.4.8; broadcast_text): with the quest taken the player asks Shin
 * "Can you tell me your fable, Shin?" and becomes The Wolf (73840 Summon The Wolf: vehicle 39364, seat 7631 = control, hidden
 * passenger, Leave button; Dash 73851 on the bar). The player carries the invisibility aura 73919 and the Hunting buff 73841, and
 * sees the six otherwise invisible kodos 39365 (73919 type 7: invisibility and detection 100). "One day, The Wolf was very hungry,
 * so he ran east..." (39438); every Dash tells one more line of the story (39444-39451, in any order); at a pair of battling kodos
 * the rest is told by itself: "He happened upon a pair of battling kodos..." (39439), the weaker kodo drops (73868 Rumbling Hooves,
 * a feign death; "lies on its side"), "When the weaker Kodo died, The Wolf approached and tried to eat it." (39440), and once the
 * wolf walks up to the dead kodo ("nothing happened until I stood in between them") the other stuns it (73866 The Kodo - Stun Wolf)
 * and kills it: "The remaining Kodo, angry at The Wolf's impetuousness, swiftly killed The Wolf before he had a chance to eat."
 * (39441). The player is back at Shin with the quest done. The lines are boss emotes (wiki) shown to the player alone.
 *
 * Ours: the distances (a free pair is found within 12 yd of its midpoint; the dead kodo is approached within 5 yd: the stun's 20 yd
 * around the other kodo holds), the timings (5 s of fighting, 2 s before the dead kodo can be approached, the wolf lies dying 2 s,
 * the kodo stands up 10 s after the wolf is gone), the fight as attack emotes, the wolf's death shown as a stunned wolf lying on
 * its side (a vehicle summon is a minion of its rider and the core removes it the moment the rider leaves, so a real corpse would
 * vanish at once), the return spot 3 yd in front of Shin facing him, and the locking: a pair serves one wolf at a time, so three
 * players can be told the fable at once; a fourth finds no free pair until one is released.
 *
 * Invisibility: in this core an invisible unit sees only units that detect its invisibility type
 * (WorldObject::CanDetectInvisibilityOf), so 73919's invisibility would blind the rider to everything but the kodos and other
 * wolves. On players its invisibility effect is replaced by the server-side hiding a GM has (as spell_hillsbrad_scene_camera_ride);
 * its detection stays. The wolf carries 73919 whole, so bystanders see neither the rider nor his wolf (screenshots: the wolf is
 * drawn translucent for its rider, the look of an invisible unit one detects). Neither aura is saved at a logout
 * (spell_custom_attribute, the hotfix's exact fault); both carry AreaGroup 2561, so leaving Durotar takes them off, which ends the
 * fable.
 *
 * Every way out ends it once: the story's end credits and sets the player down at Shin; the Leave button, the player's death, a
 * hearth or teleport, a logout, abandoning the quest, leaving Durotar or the wolf being unsummoned by anything else end it without
 * credit where the player is (the quest stays open: talk to Shin again). The kodos are freed and stand up again on their own once
 * the wolf that held them is gone. The quest's LAUNCH_GOSSIP_ACCEPT flag makes the 5.4.8 client reopen Shin's dialogue by itself after
 * the accept (it sends a gossip hello; the server must not open it as well), so the story option is offered at once.
 */

enum WolfAndKodo
{
    QUEST_THE_WOLF_AND_THE_KODO         = 25205,

    NPC_THE_WOLF                        = 39364,
    NPC_THE_KODO                        = 39365,

    MENU_SHIN_FABLE                     = 11209,
    OPTION_SHIN_FABLE                   = 0,

    SPELL_SUMMON_THE_WOLF               = 73840,
    SPELL_HUNTING                       = 73841,
    SPELL_KODO_STUN_WOLF                = 73866,
    SPELL_RUMBLING_HOOVES               = 73868,
    SPELL_WOLF_AND_KODOS_INVISIBILITY   = 73919,

    // creature_text of The Wolf 39364, all personal boss emotes
    TALK_WOLF_OPENING                   = 0,    // 39438
    TALK_WOLF_DASH_FIRST                = 1,    // 39444 .. 39451 (groups 1-8)
    TALK_WOLF_DASH_COUNT                = 8,
    TALK_WOLF_PAIR_FOUND                = 9,    // 39439
    TALK_WOLF_WEAKER_DIES               = 10,   // 39440
    TALK_WOLF_KILLED                    = 11,   // 39441
    TALK_WOLF_PAIR_BUSY                 = 12,   // ours: another wolf holds the pair

    ACTION_WOLF_DASH_LINE               = 1,
    ACTION_KODO_RELEASE                 = 2,
    DATA_KODO_LOCK                      = 1,
    DATA_KODO_PARTNER                   = 2,

    EVENT_WOLF_WAIT_FOR_RIDER           = 1,
    EVENT_WOLF_CHECK                    = 2,
    EVENT_WOLF_KODO_FALLS               = 3,
    EVENT_WOLF_MAY_APPROACH             = 4,
    EVENT_WOLF_DIES                     = 5,
    EVENT_WOLF_RETURN                   = 6,

    EVENT_KODO_FIGHT                    = 1,
    EVENT_KODO_CHECK_LOCK               = 2,
    EVENT_KODO_STAND_UP                 = 3
};

// Ours (see above)
float const WolfPairFoundRange          = 12.0f;
float const WolfKodoPartnerMaxDist      = 10.0f;
float const WolfLeavePairRange          = 40.0f;
float const WolfApproachDeadKodoRange   = 5.0f;
uint32 const WolfPairHoldMs             = 60 * IN_MILLISECONDS;    // a pair held this long without the story's end is freed
uint32 const WolfPairRetakeMs           = 60 * IN_MILLISECONDS;    // ... and that wolf cannot take it again for this long
uint32 const WolfPairBusyLineMs         = 20 * IN_MILLISECONDS;
Position const ShinReturnPos            = { 1288.3f, -4336.43f, 34.1176f, float(M_PI) };
// The three pairs' midpoints (the six kodos 39365, idle)
Position const KodoPairMidpoints[3]     = { { 1227.44f, -4735.37f, 16.95f }, { 1275.43f, -4825.40f, 17.65f }, { 1324.69f, -4771.56f, 24.48f } };

// Removes the hiding once the player stands at Shin's: a near teleport only takes effect when the client answers it (and inside
// the player's own update it is only queued), so the auras wait for it, 3 s at most
void RemoveFableAurasAtShin(Player* player, uint32 tries)
{
    player->m_Events.AddLambdaEventAtOffset([player, tries]()
    {
        if (!player->IsInWorld())
            return;
        if (tries > 1 && (player->IsBeingTeleported() || player->GetExactDist2d(ShinReturnPos.GetPositionX(), ShinReturnPos.GetPositionY()) > 10.0f))
        {
            RemoveFableAurasAtShin(player, tries - 1);
            return;
        }
        player->RemoveAurasDueToSpell(SPELL_WOLF_AND_KODOS_INVISIBILITY);
        player->RemoveAurasDueToSpell(SPELL_HUNTING);
    }, 200);
}

void RemoveFableAuras(Player* player)
{
    player->RemoveAurasDueToSpell(SPELL_WOLF_AND_KODOS_INVISIBILITY);
    player->RemoveAurasDueToSpell(SPELL_HUNTING);
}

// 39365 - The Kodo (six static spawns in three facing pairs east of Jaggedswine Farm; neither TDB has them: nobody off the quest
// sees them). Never fights. Locked to one wolf at a time (DATA_KODO_LOCK); while locked and both standing the pair butts heads
// (attack emotes, ours); the weaker one is felled by its partner's Rumbling Hooves (cast by the wolf's script). Once the wolf that
// locked it is gone the kodo waits 10 s, stands up again and is free (ours).
struct npc_durotar_the_kodo : public ScriptedAI
{
    npc_durotar_the_kodo(Creature* creature) : ScriptedAI(creature) { }

    void Reset() override
    {
        me->SetReactState(REACT_PASSIVE);
        _events.Reset();
        _events.ScheduleEvent(EVENT_KODO_CHECK_LOCK, 1s);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void SetGUID(ObjectGuid guid, int32 id) override
    {
        if (id == DATA_KODO_LOCK)
        {
            _lockGUID = guid;
            _standUpPending = false;
            _events.CancelEvent(EVENT_KODO_STAND_UP);
            if (!guid.IsEmpty())
                _events.RescheduleEvent(EVENT_KODO_FIGHT, 500ms);
        }
        else if (id == DATA_KODO_PARTNER)
        {
            _partnerGUID = guid;
            if (Creature* partner = ObjectAccessor::GetCreature(*me, guid))
                me->SetFacingToObject(partner);
        }
    }

    ObjectGuid GetGUID(int32 id) const override
    {
        return id == DATA_KODO_LOCK ? _lockGUID : ObjectGuid::Empty;
    }

    void DoAction(int32 action) override
    {
        if (action == ACTION_KODO_RELEASE)
            Release();
    }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_KODO_FIGHT:
                {
                    if (_lockGUID.IsEmpty() || me->HasAura(SPELL_RUMBLING_HOOVES))
                        break;
                    Creature* partner = ObjectAccessor::GetCreature(*me, _partnerGUID);
                    if (!partner || partner->HasAura(SPELL_RUMBLING_HOOVES))
                        break;
                    me->SetFacingToObject(partner);
                    me->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK1H);
                    _events.ScheduleEvent(EVENT_KODO_FIGHT, 1500ms);
                    break;
                }
                case EVENT_KODO_CHECK_LOCK:
                    // The wolf that holds the pair is gone (the fable ended or was left, its rider logged out...)
                    if (!_lockGUID.IsEmpty() && !ObjectAccessor::GetCreature(*me, _lockGUID) && !_standUpPending)
                    {
                        _standUpPending = true;
                        _events.ScheduleEvent(EVENT_KODO_STAND_UP, 10s);
                    }
                    _events.ScheduleEvent(EVENT_KODO_CHECK_LOCK, 1s);
                    break;
                case EVENT_KODO_STAND_UP:
                    _standUpPending = false;
                    if (!_lockGUID.IsEmpty() && !ObjectAccessor::GetCreature(*me, _lockGUID))
                        Release();
                    break;
                default:
                    break;
            }
        }
    }

private:
    void Release()
    {
        _lockGUID.Clear();
        _partnerGUID.Clear();
        _events.CancelEvent(EVENT_KODO_FIGHT);
        _events.CancelEvent(EVENT_KODO_STAND_UP);
        _standUpPending = false;
        me->RemoveAurasDueToSpell(SPELL_RUMBLING_HOOVES);
        me->SetFacingTo(me->GetHomePosition().GetOrientation());
    }

    EventMap _events;
    ObjectGuid _lockGUID;
    ObjectGuid _partnerGUID;
    bool _standUpPending = false;
};

ObjectGuid GetKodoLock(Creature* kodo)
{
    return kodo->IsAIEnabled ? kodo->AI()->GetGUID(DATA_KODO_LOCK) : ObjectGuid::Empty;
}

// 39364 - The Wolf (summoned on the player by Summon The Wolf, a vehicle the player steers from seat 0)
struct npc_durotar_the_wolf : public VehicleAI
{
    enum Stage
    {
        STAGE_RUNNING,      // looking for a pair
        STAGE_PAIR_FOUND,   // the kodos fight
        STAGE_KODO_DOWN,    // the weaker kodo lies dead
        STAGE_KILLED        // the other kodo killed the wolf: credited, on the way back to Shin
    };

    npc_durotar_the_wolf(Creature* creature) : VehicleAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        if (Player* player = summoner->ToPlayer())
            _playerGUID = player->GetGUID();

        me->SetReactState(REACT_PASSIVE);
        // Bystanders see no riderless wolf run about; riders (73919's detection) and the kodos see it
        me->AddAura(SPELL_WOLF_AND_KODOS_INVISIBILITY, me);
        _events.ScheduleEvent(EVENT_WOLF_WAIT_FOR_RIDER, 500ms);
    }

    void PassengerBoarded(Unit* passenger, int8 /*seatId*/, bool apply) override
    {
        if (_done || passenger->GetGUID() != _playerGUID)
            return;

        Player* player = passenger->ToPlayer();
        if (!player)
            return;

        if (apply)
        {
            if (_seated)
                return;

            _seated = true;
            // Normally already given at Shin's (npc_durotar_shin_stonepillar); again for a wolf boarded some other way
            if (!player->HasAura(SPELL_WOLF_AND_KODOS_INVISIBILITY))
                player->AddAura(SPELL_WOLF_AND_KODOS_INVISIBILITY, player);
            if (!player->HasAura(SPELL_HUNTING))
                player->AddAura(SPELL_HUNTING, player);
            Talk(TALK_WOLF_OPENING, player);
            _events.ScheduleEvent(EVENT_WOLF_CHECK, 250ms);
            return;
        }

        // Out of the seat: Leave, death, hearth or teleport, logout. The core unsummons the wolf right after (a vehicle minion of
        // its rider), which arrives in Unsummoned with _done already set
        End(player);
    }

    // Unsummoned by anything but the end of the story (the rider got out, logged out or left the map)
    void Unsummoned() override
    {
        if (_done)
            return;

        // Only a player on the wolf's map is touched (another map updates in another thread); a player who left Durotar or the map
        // loses both auras by their AreaGroup and their map-change interrupt flag anyway
        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (player && (!player->IsInWorld() || player->GetSession()->PlayerLogout()))
            player = nullptr;
        End(player, false);
    }

    void DoAction(int32 action) override
    {
        if (action != ACTION_WOLF_DASH_LINE || _done || !_seated)
            return;

        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player)
            return;

        std::vector<uint8> unused;
        for (uint8 i = 0; i < TALK_WOLF_DASH_COUNT; ++i)
            if (!(_usedDashLines & (1 << i)))
                unused.push_back(i);
        if (unused.empty())
            return;

        uint8 line = Trinity::Containers::SelectRandomContainerElement(unused);
        _usedDashLines |= 1 << line;
        Talk(TALK_WOLF_DASH_FIRST + line, player);
    }

    void UpdateAI(uint32 diff) override
    {
        VehicleAI::UpdateAI(diff);

        if (_done)
            return;

        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player || !player->IsInWorld())
        {
            End(nullptr);
            return;
        }

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_WOLF_WAIT_FOR_RIDER:
                    // Never seated (the ride failed): nothing to tell, the player may ask Shin again
                    if (!_seated && ++_boardTries >= 10)
                    {
                        TC_LOG_DEBUG("scripts", "npc_durotar_the_wolf: %s was never seated in The Wolf, ending the fable", player->GetName().c_str());
                        End(player);
                        return;
                    }
                    if (!_seated)
                        _events.ScheduleEvent(EVENT_WOLF_WAIT_FOR_RIDER, 500ms);
                    break;
                case EVENT_WOLF_CHECK:
                    if (!Check(player))
                        return;
                    _events.ScheduleEvent(EVENT_WOLF_CHECK, 250ms);
                    break;
                case EVENT_WOLF_KODO_FALLS:
                    if (_stage == STAGE_PAIR_FOUND)
                    {
                        Creature* victor = ObjectAccessor::GetCreature(*me, _victorGUID);
                        Creature* weaker = ObjectAccessor::GetCreature(*me, _weakerGUID);
                        if (victor && weaker)
                        {
                            victor->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK1H);
                            victor->AddAura(SPELL_RUMBLING_HOOVES, weaker);
                            Talk(TALK_WOLF_WEAKER_DIES, player);
                            _stage = STAGE_KODO_DOWN;
                            _mayApproach = false;
                            _events.ScheduleEvent(EVENT_WOLF_MAY_APPROACH, 2s);
                        }
                        else
                            ReleasePair();
                    }
                    break;
                case EVENT_WOLF_MAY_APPROACH:
                    _mayApproach = true;
                    break;
                case EVENT_WOLF_DIES:
                    // The wolf lies dying, then the player is back at Shin
                    me->SetStandState(UNIT_STAND_STATE_DEAD);
                    _events.ScheduleEvent(EVENT_WOLF_RETURN, 2s);
                    break;
                case EVENT_WOLF_RETURN:
                    End(player);
                    return;
                default:
                    break;
            }
        }
    }

private:
    // Every 250 ms while the player rides: the exits the hooks may not see, then the story's triggers. False once ended
    bool Check(Player* player)
    {
        if (_stage != STAGE_KILLED)
        {
            // Abandoned (or completed some other way); 73919 gone = left Durotar (AreaGroup); out of the seat without the hook
            if (player->GetQuestStatus(QUEST_THE_WOLF_AND_THE_KODO) != QUEST_STATUS_INCOMPLETE
                || !player->HasAura(SPELL_WOLF_AND_KODOS_INVISIBILITY) || player->GetVehicleBase() != me)
            {
                End(player);
                return false;
            }
        }

        switch (_stage)
        {
            case STAGE_RUNNING:
                FindPair(player);
                break;
            case STAGE_PAIR_FOUND:
            case STAGE_KODO_DOWN:
            {
                Creature* victor = ObjectAccessor::GetCreature(*me, _victorGUID);
                Creature* weaker = ObjectAccessor::GetCreature(*me, _weakerGUID);
                if (!victor || !weaker)
                {
                    ReleasePair();
                    break;
                }

                // Ran off: the pair is freed (the fallen kodo stands up) and the story goes on at the next pair reached
                float midX = (victor->GetPositionX() + weaker->GetPositionX()) / 2.0f;
                float midY = (victor->GetPositionY() + weaker->GetPositionY()) / 2.0f;
                if (me->GetExactDist2d(midX, midY) > WolfLeavePairRange)
                {
                    ReleasePair();
                    break;
                }

                // Held too long (the rider idles by the pair): freed for other storytellers, and not retaken by this wolf for a while
                if (getMSTimeDiff(_pairSince, getMSTime()) > WolfPairHoldMs)
                {
                    _retakeBlockedGUID = victor->GetGUID();
                    _retakeBlockedSince = getMSTime();
                    ReleasePair();
                    break;
                }

                if (_stage == STAGE_KODO_DOWN && _mayApproach && me->GetExactDist2d(weaker) <= WolfApproachDeadKodoRange)
                {
                    // Credited here: the story is told (getting out from now on still ends at Shin)
                    _stage = STAGE_KILLED;
                    _credited = true;
                    player->KilledMonsterCredit(NPC_THE_KODO);
                    victor->SetFacingToObject(me);
                    victor->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK1H);
                    victor->AddAura(SPELL_KODO_STUN_WOLF, me);
                    // Held until the player is set down (the stun aura lasts 1 s)
                    me->SetControlled(true, UNIT_STATE_STUNNED);
                    Talk(TALK_WOLF_KILLED, player);
                    _events.ScheduleEvent(EVENT_WOLF_DIES, 1s);
                }
                break;
            }
            default:
                break;
        }
        return true;
    }

    void FindPair(Player* player)
    {
        std::list<Creature*> kodos;
        me->GetCreatureListWithEntryInGrid(kodos, NPC_THE_KODO, 30.0f);

        if (!_retakeBlockedGUID.IsEmpty() && getMSTimeDiff(_retakeBlockedSince, getMSTime()) > WolfPairRetakeMs)
            _retakeBlockedGUID.Clear();

        for (Creature* first : kodos)
        {
            if (!first->IsAlive())
                continue;

            // At a pair another wolf holds: say so, now and then (ours). A pair this wolf gave up a minute ago is skipped silently
            if (!GetKodoLock(first).IsEmpty() || first->GetGUID() == _retakeBlockedGUID)
            {
                if (!GetKodoLock(first).IsEmpty() && me->GetExactDist2d(first) <= WolfPairFoundRange
                    && getMSTimeDiff(_busyLineSince, getMSTime()) > WolfPairBusyLineMs)
                {
                    _busyLineSince = getMSTime();
                    Talk(TALK_WOLF_PAIR_BUSY, player);
                }
                continue;
            }

            Creature* second = nullptr;
            float best = WolfKodoPartnerMaxDist;
            for (Creature* other : kodos)
            {
                if (other == first || !other->IsAlive())
                    continue;
                float dist = first->GetExactDist2d(other);
                if (dist < best)
                {
                    best = dist;
                    second = other;
                }
            }

            if (!second || !GetKodoLock(second).IsEmpty() || second->GetGUID() == _retakeBlockedGUID)
                continue;

            float midX = (first->GetPositionX() + second->GetPositionX()) / 2.0f;
            float midY = (first->GetPositionY() + second->GetPositionY()) / 2.0f;
            if (me->GetExactDist2d(midX, midY) > WolfPairFoundRange)
                continue;

            // The weaker kodo is the one nearer the wolf (ours): it falls on the wolf's side, the victor stands beyond it
            Creature* weaker = me->GetExactDist2d(first) <= me->GetExactDist2d(second) ? first : second;
            Creature* victor = weaker == first ? second : first;
            _weakerGUID = weaker->GetGUID();
            _victorGUID = victor->GetGUID();

            for (Creature* kodo : { weaker, victor })
            {
                if (!kodo->IsAIEnabled)
                    continue;
                kodo->AI()->SetGUID(kodo == weaker ? victor->GetGUID() : weaker->GetGUID(), DATA_KODO_PARTNER);
                kodo->AI()->SetGUID(me->GetGUID(), DATA_KODO_LOCK);
            }

            _stage = STAGE_PAIR_FOUND;
            _pairSince = getMSTime();
            Talk(TALK_WOLF_PAIR_FOUND, player);
            _events.ScheduleEvent(EVENT_WOLF_KODO_FALLS, 5s);
            return;
        }
    }

    void ReleasePair()
    {
        for (ObjectGuid const& guid : { _weakerGUID, _victorGUID })
            if (Creature* kodo = ObjectAccessor::GetCreature(*me, guid))
                if (kodo->IsAIEnabled && GetKodoLock(kodo) == me->GetGUID())
                    kodo->AI()->DoAction(ACTION_KODO_RELEASE);

        _weakerGUID.Clear();
        _victorGUID.Clear();
        _events.CancelEvent(EVENT_WOLF_KODO_FALLS);
        _events.CancelEvent(EVENT_WOLF_MAY_APPROACH);
        if (_stage != STAGE_KILLED)
            _stage = STAGE_RUNNING;
    }

    // Ends the fable once, whichever way. Credited (the story was told): the player is let out and, a moment later (a teleport in
    // the tick of the exit leaves the client's view behind), set down in front of Shin; the auras go once he is there, so nobody
    // at the kodos sees the player appear. Not credited: the auras go now and the player stays where he is. The pair stays locked
    // after a credited end (the victor over the fallen kodo) and frees itself 10 s after the wolf is gone; otherwise it is freed now
    void End(Player* player, bool despawn = true)
    {
        if (_done)
            return;

        _done = true;
        _events.Reset();

        if (!_credited)
            ReleasePair();

        if (player)
        {
            if (_credited)
            {
                if (player->GetVehicleBase() == me)
                    player->ExitVehicle();

                player->m_Events.AddLambdaEventAtOffset([player]()
                {
                    if (!player->IsInWorld())
                        return;
                    if (!player->GetVehicle() && !player->IsBeingTeleported() && player->GetMapId() == 1)
                        player->NearTeleportTo(ShinReturnPos.GetPositionX(), ShinReturnPos.GetPositionY(), ShinReturnPos.GetPositionZ(), ShinReturnPos.GetOrientation());
                    RemoveFableAurasAtShin(player, 15);
                }, 400);
            }
            else
            {
                RemoveFableAuras(player);
                if (player->GetVehicleBase() == me)
                    player->ExitVehicle();
            }
        }

        // Already on its way out when called from Unsummoned
        if (despawn)
            me->DespawnOrUnsummon(500);
    }

    EventMap _events;
    ObjectGuid _playerGUID;
    ObjectGuid _weakerGUID;
    ObjectGuid _victorGUID;
    Stage _stage = STAGE_RUNNING;
    uint8 _usedDashLines = 0;
    uint32 _boardTries = 0;
    uint32 _pairSince = 0;
    uint32 _busyLineSince = 0;
    uint32 _retakeBlockedSince = 0;
    ObjectGuid _retakeBlockedGUID;
    bool _seated = false;
    bool _mayApproach = false;
    bool _credited = false;
    bool _done = false;
};

// 39380 - Shin Stonepillar (inside Gor's hut at the Dranosh'ar Blockade)
// "Can you tell me your fable, Shin?" (menu 11209, shown only with the quest in progress) starts the fable: the player gets the
// invisibility aura and Hunting, then Summon The Wolf seats him in his wolf. If no wolf came, the auras are taken off and the quest
// is completed at once, so that the chain can never stop here (ours, as the Hillsbrad scenes).
struct npc_durotar_shin_stonepillar : public ScriptedAI
{
    npc_durotar_shin_stonepillar(Creature* creature) : ScriptedAI(creature) { }

    static bool HasOwnWolf(Player* player)
    {
        std::list<Creature*> wolves;
        player->GetCreatureListWithEntryInGrid(wolves, NPC_THE_WOLF, 200.0f);
        for (Creature* wolf : wolves)
            if (wolf->IsAlive() && !wolf->IsDestroyedObject() && wolf->IsSummon() && wolf->ToTempSummon()->GetSummonerGUID() == player->GetGUID())
                return true;
        return false;
    }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
    {
        if (menuId != MENU_SHIN_FABLE || gossipListId != OPTION_SHIN_FABLE)
            return false;

        CloseGossipMenuFor(player);

        if (player->GetQuestStatus(QUEST_THE_WOLF_AND_THE_KODO) != QUEST_STATUS_INCOMPLETE || player->GetVehicle())
            return true;

        // A wolf of his is still about (the fable just ended or is ending): no second one
        if (HasOwnWolf(player))
            return true;

        // The detection first, so the wolf (invisible to others) is in sight the moment it appears
        player->AddAura(SPELL_WOLF_AND_KODOS_INVISIBILITY, player);
        player->AddAura(SPELL_HUNTING, player);
        player->CastSpell(player, SPELL_SUMMON_THE_WOLF, true);

        // Seated: the wolf tells the rest. A wolf that came without its rider ends itself within 5 s (the player may ask again)
        if (Unit* wolf = player->GetVehicleBase())
            if (wolf->GetEntry() == NPC_THE_WOLF)
                return true;
        if (HasOwnWolf(player))
            return true;

        TC_LOG_ERROR("scripts", "npc_durotar_shin_stonepillar: Summon The Wolf brought no wolf for %s; completing The Wolf and The Kodo without the fable",
            player->GetName().c_str());
        RemoveFableAuras(player);
        player->KilledMonsterCredit(NPC_THE_KODO);
        return true;
    }
};

// A player who logged out in the 3 s between the credit and the return (the wolf lying dying) was saved at the kodos: with the quest
// complete and within 10 yd of a pair's midpoint at login (the wolf dies within 5 yd of the fallen kodo, 3.3 yd from the midpoint;
// the kodos are invisible to everyone else, so nobody else stops there), he is set down in front of Shin as the story's end would
// have (ours)
class player_durotar_wolf_and_kodo_login : public PlayerScript
{
public:
    player_durotar_wolf_and_kodo_login() : PlayerScript("player_durotar_wolf_and_kodo_login") { }

    void OnLogin(Player* player) override
    {
        if (player->GetMapId() != 1 || !player->IsAlive() || player->GetQuestStatus(QUEST_THE_WOLF_AND_THE_KODO) != QUEST_STATUS_COMPLETE)
            return;

        bool atPair = false;
        for (Position const& mid : KodoPairMidpoints)
            if (player->GetExactDist2d(mid.GetPositionX(), mid.GetPositionY()) < 10.0f)
                atPair = true;
        if (!atPair)
            return;

        player->m_Events.AddLambdaEventAtOffset([player]()
        {
            if (player->IsInWorld() && !player->IsBeingTeleported() && player->GetMapId() == 1)
                player->NearTeleportTo(ShinReturnPos.GetPositionX(), ShinReturnPos.GetPositionY(), ShinReturnPos.GetPositionZ(), ShinReturnPos.GetOrientation());
        }, 1000);
    }
};

// 73919 - Durotar Quest Invis 1 - Wolf and Kodos
// On the kodos and the wolf the invisibility works as it is. On a player its invisibility effect is not applied (it would blind
// him to every unit without type-7 detection, see above); he is hidden the server-side way instead while the aura lasts, and its
// detection effect lets him see the kodos and the wolves
class spell_durotar_wolf_and_kodos_invisibility : public AuraScript
{
    PrepareAuraScript(spell_durotar_wolf_and_kodos_invisibility);

    void HandleApply(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        Player* player = GetTarget()->ToPlayer();
        if (!player)
            return;

        PreventDefaultAction();
        if (!player->IsVisible())
            return;

        _hidden = true;
        player->SetVisible(false);
    }

    void HandleRemove(AuraEffect const* /*aurEff*/, AuraEffectHandleModes /*mode*/)
    {
        if (GetTarget()->GetTypeId() != TYPEID_PLAYER)
            return;

        PreventDefaultAction();
        if (!_hidden)
            return;

        _hidden = false;
        GetTarget()->SetVisible(true);
    }

    void Register() override
    {
        OnEffectApply += AuraEffectApplyFn(spell_durotar_wolf_and_kodos_invisibility::HandleApply, EFFECT_0, SPELL_AURA_MOD_INVISIBILITY, AURA_EFFECT_HANDLE_CHANGE_AMOUNT_SEND_FOR_CLIENT_MASK);
        OnEffectRemove += AuraEffectRemoveFn(spell_durotar_wolf_and_kodos_invisibility::HandleRemove, EFFECT_0, SPELL_AURA_MOD_INVISIBILITY, AURA_EFFECT_HANDLE_CHANGE_AMOUNT_SEND_FOR_CLIENT_MASK);
    }

    bool _hidden = false;
};

// 73851 - Dash (The Wolf's bar: +60 % speed for 5 s; effect 1, a script effect on the rider, tells the next line of the story)
// The line is told after the cast, not from effect 1: that effect's target, the rider (TARGET_UNIT_PASSENGER_0), is hidden
// server-side, and SpellInfo::CheckTarget drops him twice for a player-controlled caster (the caster's sight, and the GM /
// invisible-player test, Spell.cpp AddUnitTarget -> SpellInfo.cpp ~1964 and ~2082), so the effect never hits
class spell_durotar_wolf_dash : public SpellScript
{
    PrepareSpellScript(spell_durotar_wolf_dash);

    void HandleAfterCast()
    {
        if (Creature* wolf = GetCaster()->ToCreature())
            if (wolf->GetEntry() == NPC_THE_WOLF && wolf->IsAIEnabled)
                wolf->AI()->DoAction(ACTION_WOLF_DASH_LINE);
    }

    void Register() override
    {
        AfterCast += SpellCastFn(spell_durotar_wolf_dash::HandleAfterCast);
    }
};

} // namespace

void AddSC_durotar_blockade()
{
    new creature_script<npc_durotar_skull_rock_cultist>("npc_durotar_skull_rock_cultist");
    new spell_script<spell_durotar_attach_tether>("spell_durotar_attach_tether");
    new creature_script<npc_durotar_shin_stonepillar>("npc_durotar_shin_stonepillar");
    new creature_script<npc_durotar_the_wolf>("npc_durotar_the_wolf");
    new creature_script<npc_durotar_the_kodo>("npc_durotar_the_kodo");
    new player_durotar_wolf_and_kodo_login();
    new aura_script<spell_durotar_wolf_and_kodos_invisibility>("spell_durotar_wolf_and_kodos_invisibility");
    new spell_script<spell_durotar_wolf_dash>("spell_durotar_wolf_dash");
}
