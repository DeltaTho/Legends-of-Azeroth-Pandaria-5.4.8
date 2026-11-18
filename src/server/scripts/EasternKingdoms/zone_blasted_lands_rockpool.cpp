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
SDName: Blasted Lands, the Rockpool murlocs
SDComment: Quest support: 25707 The Future of the Rockpool (dragging an Abandoned Bloodwash Crate into the Forbidding Sea, the
           crate that floats away)
SDCategory: Blasted Lands
EndScriptData */

/*######
## The Future of the Rockpool 25707. What the player sees (sources: quest 25707 comments 2010-11-24 [+76], 2010-11-25,
## 2010-11-26, 2010-11-30 [+118] and its reply [+15], 2010-12-01 and reply, 2010-12-04 [+10] and [+7] with replies, 2010-12-09,
## 2010-12-23 [+49], 2011-02-22 [+12], 2012-04-27, 2012-10-26 reply, 2013-10-15, 2013-11-21, 2014-05-04 [+6]; 41402 comments
## 2010-12-05 [+5], 2011-10-16 [+5]; 41454 2013-11-25 [+9]; the wiki's notes; spells 77549 / 77563, vehicles 820 / 824):
## An Abandoned Bloodwash Crate with three baby murlocs on it stands at the mouth of Bloodwash Cavern (four of them). There is no
## "!": once Atrocities is handed in, talking to it offers "<Help the Rockpool tadpoles.>" / "<Leave them to fend for
## themselves.>". Helping starts the quest (a player too low for it still drags the crate) and puts the player in front of the
## crate, pulling it (vehicle seat 0); he can cast, a leave-vehicle button takes him out. Being hit, or attacking in melee, drops
## the crate where it is (stealth, Sap, a stun opener keep it); talking to it again: "<These baby Rockpool murlocs look toward the
## ocean.>" / "<Continue helping the Rockpool tadpoles.>", and anyone holding the quest may take a dropped crate over. Dragged
## across the beach into the Forbidding Sea (subzone 5096) the quest completes by itself and is handed in from the quest log; a
## group member who fought beside the dragger gets the credit too; the crate is gone and a crate with the three tadpoles floats
## slowly away out to sea for several minutes. The crate cannot be dragged out of the zone.
##
## Ours (no source says how): the half-second check; a crate left without a driver for 2 minutes away from its spot is put back
## there (5 s later; retail's GM had to clear stuck crates; it stays an active object meanwhile so the 2 minutes run with nobody
## near); no distance leash (the source only bounds the drag by the zone, so a detour along the beach never drops it); the drift
## route (out to sea, then south-east, 20 yd legs at 1 yd/s for 4 minutes, 1.4 yd under the surface as the sniffed 41454 lay);
## the crate never takes damage (being hit drops it instead); the crate adrift 41454 and its vehicle 824 are mop-only data (neither
## TDB spawns it). Not built: the ropes (no spell in the data draws them).
##
## Core notes. The crate's spellclick flag (forced by Vehicle::Vehicle for its CAN_ENTER_OR_EXIT seats) is hidden from players
## by the 46598 rows conditioned to the tadpoles (Player::CanSeeSpellClickOn), so a right-click opens the gossip. 77549's
## CONTROL_VEHICLE effect hits every unit within 6 yd (no condition but the entry): the SpellScript keeps the crate talked to.
## Seat 0 charms the crate (CAN_CONTROL): OnCharmed is overridden without CreatureAI::OnCharmed, which would swap this AI for a
## PossessedAI until the charm ends (Unit::UpdateCharmAI), and without VehicleAI's dismissal 5 s after the seat empties. Deep
## water: the charm ends in Creature::RefreshSwimmingFlag (Unit::SetCharmedBy), which gives the crate UNIT_FLAG_CAN_SWIM (it
## cannot fly, so Creature::CanSwim holds); the 5.4.8 client lets a unit swim on that flag unless it has UNIT_FLAG_CANNOT_SWIM
## (CGUnit::CanSwim; the template has neither), and the server takes the moving crate's position as the client sends it
## (WorldSession::HandleMovementOpcode, no check for a vehicle mover). The sea area 5096 begins 10-60 yd out, where the water is
## 2.4-7.6 yd deep (server map tiles), so the crate must swim, or walk the sea floor, to get there. 77563's KILL_CREDIT2
## credits the driver's group within reward distance of him (Player::RewardPlayerAndGroupAtEvent); its QUEST_COMPLETE effect
## carries the quest in the base points, not the misc value, and does nothing here (the kill credit completes the objective).
######*/

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "SpellScript.h"
#include "Player.h"
#include "Vehicle.h"
#include "TemporarySummon.h"
#include "ObjectAccessor.h"
#include "MoveSplineInit.h"
#include "Map.h"

enum RockpoolData
{
    NPC_ABANDONED_BLOODWASH_CRATE   = 41402,
    NPC_ABANDONED_CRATE_ADRIFT      = 41454,

    QUEST_ATROCITIES                = 25703,
    QUEST_FUTURE_OF_THE_ROCKPOOL    = 25707,

    SPELL_QUEST_LAUNCH              = 77549,    // quest start, CONTROL_VEHICLE on the crate (seat in bp 1), the dragging marker
    SPELL_CRATE_KILL_CREDIT         = 77563,    // KILL_CREDIT2 41402, summon 41454 at the crate

    MENU_ABANDONED_CRATE            = 11507,
    OPTION_HELP                     = 0,
    OPTION_LEAVE                    = 1,
    OPTION_CONTINUE                 = 2,

    SEAT_PULLER                     = 0,

    ZONE_BLASTED_LANDS              = 4,
    AREA_THE_FORBIDDING_SEA         = 5096,

    DATA_CRATE_DROP                 = 1,
    GUID_CRATE_PENDING_RIDER        = 1,
};

static constexpr uint32 CrateCheckMs        = 500;
static constexpr uint32 CrateAbandonMs      = 2 * MINUTE * IN_MILLISECONDS;
static constexpr uint32 CrateHomeRespawnSec = 5;
static constexpr uint32 CrateSeaRespawnSec  = 60;

static constexpr uint32 AdriftLegs          = 12;
static constexpr float  AdriftLegYd         = 20.0f;
static constexpr float  AdriftSpeed         = 1.0f;
static constexpr float  AdriftUnderSurface  = 1.4f;
static constexpr float  AdriftMinDepth      = 3.0f;
static constexpr uint32 AdriftLifeMs        = 4 * MINUTE * IN_MILLISECONDS;

// The creatures seated on a vehicle go before it: an accessory left by a despawning vehicle stands about for 2 s
// (Unit::_ExitVehicle), or dies with it and leaves a corpse
static void DespawnSeatedCreatures(Unit* base)
{
    Vehicle* kit = base->GetVehicleKit();
    if (!kit)
        return;

    for (auto const& seat : kit->Seats)
        if (Creature* passenger = ObjectAccessor::GetCreature(*base, seat.second.Passenger.Guid))
            passenger->DespawnOrUnsummon();
}

// 41402 - Abandoned Bloodwash Crate (vehicle 820: seat 0 the player pulling, seats 1-3 the tadpoles)
struct npc_abandoned_bloodwash_crate : public CreatureAI
{
    npc_abandoned_bloodwash_crate(Creature* creature) : CreatureAI(creature) { }

    void Reset() override
    {
        _driverGUID.Clear();
        _pendingRiderGUID.Clear();
        _driverHadQuest = false;
        _dropPending = false;
        _done = false;
        _checkMs = CrateCheckMs;
        _aloneMs = 0;
        if (_awayActive)
            SetAwayActive(false);
        me->SetReactState(REACT_PASSIVE);
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    // Keep this AI while the crate is dragged (see the core notes above)
    void OnCharmed(bool apply) override
    {
        if (!apply)
            me->RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_PLAYER_CONTROLLED);
    }

    // The crate is never worn down; a hit on it while it is dragged drops it
    void DamageTaken(Unit* attacker, uint32& damage) override
    {
        damage = 0;
        if (attacker && attacker != me && !_driverGUID.IsEmpty())
            _dropPending = true;
    }

    // From unit_rockpool_crate_drop: the driver was hit
    void SetData(uint32 id, uint32 /*value*/) override
    {
        if (id == DATA_CRATE_DROP && !_driverGUID.IsEmpty())
            _dropPending = true;
    }

    ObjectGuid GetGUID(int32 id) const override
    {
        return id == GUID_CRATE_PENDING_RIDER ? _pendingRiderGUID : ObjectGuid::Empty;
    }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 gossipListId) override
    {
        // The menu id comes from the packet: only the menu this player has open, and only an option it showed him
        if (menuId != MENU_ABANDONED_CRATE || player->PlayerTalkClass->GetGossipMenu().GetMenuId() != menuId
            || !player->PlayerTalkClass->GetGossipMenu().GetItem(gossipListId))
            return false;

        CloseGossipMenuFor(player);

        bool allowed = false;
        if (gossipListId == OPTION_HELP)
            allowed = player->GetQuestStatus(QUEST_ATROCITIES) == QUEST_STATUS_REWARDED
                && player->GetQuestStatus(QUEST_FUTURE_OF_THE_ROCKPOOL) == QUEST_STATUS_NONE;
        else if (gossipListId == OPTION_CONTINUE)
            allowed = player->GetQuestStatus(QUEST_FUTURE_OF_THE_ROCKPOOL) == QUEST_STATUS_INCOMPLETE;
        if (!allowed)
            return true;    // "Leave them to fend for themselves" closes

        Vehicle* kit = me->GetVehicleKit();
        if (_done || !me->IsAlive() || !kit || !player->IsAlive() || player->GetVehicle() || !me->IsWithinDistInMap(player, 10.0f))
            return true;

        if (!_driverGUID.IsEmpty() || !kit->HasEmptySeat(SEAT_PULLER))
            return true;

        // "Help" while mounted did nothing on retail (2012-10-26 reply): here the mount goes
        player->RemoveAurasByType(SPELL_AURA_MOUNTED);

        _pendingRiderGUID = player->GetGUID();
        player->CastCustomSpell(SPELL_QUEST_LAUNCH, SPELLVALUE_BASE_POINT1, SEAT_PULLER + 1, player, true);
        _pendingRiderGUID.Clear();

        // 77549's area selection missed the crate (it is 6 yd around the player): seat him by hand
        if (player->GetVehicleBase() != me && kit->HasEmptySeat(SEAT_PULLER) && !player->GetVehicle())
        {
            TC_LOG_DEBUG("scripts", "npc_abandoned_bloodwash_crate: 77549 did not seat player %u on crate %u, seating him directly",
                player->GetGUID().GetCounter(), me->GetDBTableGUIDLow());
            player->EnterVehicle(me, SEAT_PULLER);
        }
        return true;
    }

    void PassengerBoarded(Unit* passenger, int8 seatId, bool apply) override
    {
        Player* player = passenger->ToPlayer();
        if (!player || seatId != SEAT_PULLER)
            return;

        if (apply)
        {
            _driverGUID = player->GetGUID();
            _driverHadQuest = player->GetQuestStatus(QUEST_FUTURE_OF_THE_ROCKPOOL) == QUEST_STATUS_INCOMPLETE;
            _dropPending = false;
            _aloneMs = 0;
            _checkMs = CrateCheckMs;
            SetAwayActive(false);   // the driver's own updates carry it now
            return;
        }

        if (player->GetGUID() != _driverGUID)
            return;

        _driverGUID.Clear();
        _dropPending = false;
        _aloneMs = 0;

        // Left away from its spot: active at once, so that UpdateAI runs and the 2-minute return happens even when the driver
        // left the area with the crate (logout, teleport, death). Done here, not through the crate's m_Events: those are run by
        // Unit::Update (Unit.cpp:374), which a crate nobody is near never gets. setActive only adds the crate to the map's
        // active list; no vehicle state is touched. Not after the sea (_done: the crate vanishes)
        if (!_done && me->GetExactDist2d(&me->GetHomePosition()) > 5.0f)
            SetAwayActive(true);

        // The dragging marker (77549's third effect, on the player) goes with the crate; not from inside the exit
        player->m_Events.AddLambdaEventAtOffset([player]()
        {
            if (player->GetVehicleBase() && player->GetVehicleBase()->GetEntry() == NPC_ABANDONED_BLOODWASH_CRATE)
                return;
            player->RemoveAurasDueToSpell(SPELL_QUEST_LAUNCH);
        }, 1);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_done)
            return;

        Player* driver = _driverGUID.IsEmpty() ? nullptr : ObjectAccessor::GetPlayer(*me, _driverGUID);
        if (!_driverGUID.IsEmpty() && (!driver || driver->GetVehicleBase() != me))
        {
            _driverGUID.Clear();
            driver = nullptr;
        }

        // A hit or a melee swing drops the crate at once
        if (driver && (_dropPending || driver->HasUnitState(UNIT_STATE_MELEE_ATTACKING)))
        {
            _dropPending = false;
            driver->ExitVehicle();
            return;
        }

        if (_checkMs > diff)
        {
            _checkMs -= diff;
            return;
        }
        _checkMs = CrateCheckMs;

        if (!driver)
        {
            // Left away from its spot: back home after 2 minutes without anyone taking it up again
            if (me->GetExactDist2d(&me->GetHomePosition()) <= 5.0f)
            {
                _aloneMs = 0;
                SetAwayActive(false);
                return;
            }

            // A creature is updated only near a player or an active object (Map::Update with Map.UpdatableObjectList = 0):
            // it stays active until it is home again, so the 2 minutes run with nobody near
            SetAwayActive(true);
            _aloneMs += CrateCheckMs;
            if (_aloneMs >= CrateAbandonMs)
                Vanish(CrateHomeRespawnSec);
            return;
        }

        QuestStatus const status = driver->GetQuestStatus(QUEST_FUTURE_OF_THE_ROCKPOOL);
        if (status == QUEST_STATUS_INCOMPLETE)
            _driverHadQuest = true;

        uint32 zoneId = 0, areaId = 0;
        me->GetMap()->GetZoneAndAreaId(me->GetPhaseMask(), zoneId, areaId, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ());

        // Abandoned while dragging, or out of the zone (the only bound the sources give: 2011-02-22 [+12])
        if ((_driverHadQuest && status == QUEST_STATUS_NONE) || zoneId != ZONE_BLASTED_LANDS)
        {
            driver->ExitVehicle();
            return;
        }

        if (areaId == AREA_THE_FORBIDDING_SEA)
            ReachTheSea(driver);
    }

private:
    void ReachTheSea(Player* driver)
    {
        _done = true;

        // Credit to him and to his group near him (KILL_CREDIT2), and the crate adrift appears here; a driver without the quest
        // gets only the crate adrift (41402 comment 2011-10-16)
        me->CastSpell(driver, SPELL_CRATE_KILL_CREDIT, true);
        driver->ExitVehicle();

        TC_LOG_DEBUG("scripts", "npc_abandoned_bloodwash_crate: crate %u reached the Forbidding Sea with player %u (quest status %u)",
            me->GetDBTableGUIDLow(), driver->GetGUID().GetCounter(), uint32(driver->GetQuestStatus(QUEST_FUTURE_OF_THE_ROCKPOOL)));

        Vanish(CrateSeaRespawnSec);
    }

    void SetAwayActive(bool on)
    {
        if (on == _awayActive)
            return;
        _awayActive = on;
        me->setActive(on, ActiveFlags::Script);
    }

    void Vanish(uint32 respawnSec)
    {
        _done = true;
        SetAwayActive(false);
        DespawnSeatedCreatures(me);
        me->DespawnOrUnsummon();
        me->SetRespawnTime(respawnSec);
    }

    ObjectGuid _driverGUID;
    ObjectGuid _pendingRiderGUID;
    uint32 _checkMs = CrateCheckMs;
    uint32 _aloneMs = 0;
    bool _driverHadQuest = false;
    bool _dropPending = false;
    bool _done = false;
    bool _awayActive = false;
};

// 41454 - Abandoned Bloodwash Crate (adrift; vehicle 824, the three tadpoles on top), summoned by 77563 where the dragged crate
// reached the sea. It floats out to sea and away, slowly, and is gone after 4 minutes
struct npc_bloodwash_crate_adrift : public CreatureAI
{
    npc_bloodwash_crate_adrift(Creature* creature) : CreatureAI(creature) { }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        me->setActive(true, ActiveFlags::Script);
        me->SetReactState(REACT_PASSIVE);
        me->SetDisableGravity(true);
        _heading = 1.5f * float(M_PI);   // east: straight out from the beach
        _leg = 0;
        _legMs = 1000;
        _lifeMs = AdriftLifeMs;
        _started = true;
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    void OnCharmed(bool /*apply*/) override { }

    void DamageTaken(Unit* /*attacker*/, uint32& damage) override
    {
        damage = 0;
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_started)
            return;

        if (_lifeMs <= diff)
        {
            _started = false;
            DespawnSeatedCreatures(me);
            me->DespawnOrUnsummon();
            return;
        }
        _lifeMs -= diff;

        if (_legMs > diff)
        {
            _legMs -= diff;
            return;
        }
        _legMs = NextLeg();
    }

private:
    // Out to sea for the first two legs, then south-east; a leg whose end is not open water turns further out
    uint32 NextLeg()
    {
        if (_leg >= AdriftLegs)
            return _lifeMs;

        static float const turns[] = { 0.0f, -float(M_PI) / 4.0f, float(M_PI) / 4.0f, -float(M_PI) / 2.0f };
        float const wanted = _leg < 2 ? 1.5f * float(M_PI) : 1.25f * float(M_PI);
        ++_leg;

        Map* map = me->GetMap();
        for (float turn : turns)
        {
            float const heading = Position::NormalizeOrientation(wanted + turn);
            float const x = me->GetPositionX() + AdriftLegYd * std::cos(heading);
            float const y = me->GetPositionY() + AdriftLegYd * std::sin(heading);
            float const water = map->GetWaterLevel(x, y);
            if (water <= INVALID_HEIGHT)
                continue;

            float const ground = map->GetHeight(me->GetPhaseMask(), x, y, water, true, 500.0f);
            if (ground > INVALID_HEIGHT && water - ground < AdriftMinDepth)
                continue;

            Movement::MoveSplineInit init(me);
            init.MoveTo(x, y, water - AdriftUnderSurface, false);
            init.SetVelocity(AdriftSpeed);
            int32 const ms = init.Launch();
            _heading = heading;
            return ms > 0 ? uint32(ms) : 1000;
        }

        // Nowhere to go: it stays where it is until its time is up
        return _lifeMs;
    }

    float _heading = 0.0f;
    uint32 _leg = 0;
    uint32 _legMs = 0;
    uint32 _lifeMs = 0;
    bool _started = false;
};

// 77549 - The Future of the Rockpool: Quest Launch. Its CONTROL_VEHICLE effect boards only the crate the player talked to
// (npc_abandoned_bloodwash_crate sets him as its pending rider for the cast): two crates on one spot can't both be boarded, and
// nothing else within its 6 yd is
class spell_rockpool_quest_launch : public SpellScript
{
    PrepareSpellScript(spell_rockpool_quest_launch);

    void FilterCrate(std::list<WorldObject*>& targets)
    {
        Unit* caster = GetCaster();
        targets.remove_if([caster](WorldObject* target)
        {
            Creature* crate = target->ToCreature();
            return !caster || !crate || crate->GetEntry() != NPC_ABANDONED_BLOODWASH_CRATE || !crate->IsAIEnabled
                || crate->AI()->GetGUID(GUID_CRATE_PENDING_RIDER) != caster->GetGUID();
        });
    }

    void Register() override
    {
        OnObjectAreaTargetSelect += SpellObjectAreaTargetSelectFn(spell_rockpool_quest_launch::FilterCrate, EFFECT_1, TARGET_UNIT_DEST_AREA_ENTRY);
    }
};

// A player pulling an Abandoned Bloodwash Crate who is hit drops it ("on entering combat, you will drop the crate"; Sap and a
// stun opener keep it, being hit does not: comments 2010-12-04 [+7] and replies, 2010-12-01, 2010-12-09)
class unit_rockpool_crate_drop : public UnitScript
{
public:
    unit_rockpool_crate_drop() : UnitScript("unit_rockpool_crate_drop") { }

    void OnDamage(Unit* attacker, Unit* victim, uint32& /*damage*/) override
    {
        if (!attacker || !victim || attacker == victim || victim->GetTypeId() != TYPEID_PLAYER)
            return;

        Unit* base = victim->GetVehicleBase();
        if (!base || base->GetEntry() != NPC_ABANDONED_BLOODWASH_CRATE || victim->GetTransSeat() != SEAT_PULLER)
            return;

        if (Creature* crate = base->ToCreature())
            if (crate->IsAIEnabled)
                crate->AI()->SetData(DATA_CRATE_DROP, 1);
    }
};

void AddSC_blasted_lands_rockpool()
{
    new creature_script<npc_abandoned_bloodwash_crate>("npc_abandoned_bloodwash_crate");
    new creature_script<npc_bloodwash_crate_adrift>("npc_bloodwash_crate_adrift");
    new spell_script<spell_rockpool_quest_launch>("spell_rockpool_quest_launch");
    new unit_rockpool_crate_drop();
}
