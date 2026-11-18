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
           crate that floats away); the Rockpool march (murlocs dragging crates of tadpoles from Rockpool Village to Bloodwash
           Cavern and Bloodwash Shrine, Atrocities 25703)
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

/*######
## The Rockpool march. What the player sees (sources: 25703 comment 2010-12-04 [+16] "long line stretching to the horizon, mostly
## little helpless tadpoles"; 25707 2013-03-01 [+8] "an endless line of enslaved murlocs, dragging their babies across the
## desert"; 25706 2012-06-23 [+4] "as these murloc despawn, you are watching an entire people vanish"; 2011-01-27 [+23] the march
## remains after the quests; the Bloodwash Crate Spawner 41359 and its spells 77476 / 77481 / 77480; the TDB snapshot of 30
## pullers 41384 with their tadpole triplets 41385, all facing along one line; mop's 330 sniffed walker paths):
## From Rockpool Village a line of Rockpool murlocs and tadpoles walks south-west along the beach at a dragging pace, murlocs
## pulling crates with three tadpoles on each, others on foot beside them; at the fork most go back north-east along the inland
## side into Bloodwash Cavern, some north-west to Bloodwash Shrine, and vanish there. It never ends.
##
## Ours: the rates (a crate every 13 s and a murloc or tadpole on foot every 5 s, from the snapshot's density: 30 pullers over the
## route at 2 yd/s; mop's 50 crates : 142 murlocs : 138 tadpoles), one in seven to the shrine (the sniffed paths: 60 cave
## fragments, 10 shrine), the walkers on foot 1-3 yd to either side of the line; the crate's vehicle (822, mop-only data: neither
## TDB spawns 41362) carrying the TDB's puller and tadpoles; the life cycle below. The walkers are summoned directly, not by
## casting 77476 / 77481 / 77480 (same creatures; the line has to be placed along the route).
##
## Life cycle. The live server runs with Map.UpdatableObjectList = 0, so Map::Update updates only the cells within about 90 yd of
## a player or of an active object (Map.cpp:1016-1042): nothing here may rely on being updated otherwise.
## - Wake: player_rockpool_march_watch (PlayerScript::OnUpdate, called from every Player::Update, Player.cpp:1428) sees a
##   player who is not a playerbot, on map 0 in zone 4, standing in one of the route's areas (5078 The Red Reaches, 5079
##   Rockpool Village, 5080 Bloodwash Fighting Pits, 5081 Bloodwash Shrine, 5082 Bloodwash Cavern, read from the server's map
##   tiles) and, at most every 2 s, loads the spawner's grid if it is not loaded (Map::LoadGrid) and tells the spawner
##   (DoAction). Area ids are the player's cached ones.
## - The spawner is an active object while the march runs (its grid stays loaded and it is updated wherever the players are);
##   on waking with nothing out it places the line as it would stand had it been running (a few summons per update).
## - Every marcher is an active object for its whole life, so it keeps walking out of everyone's sight and loads the grids it
##   walks into (Map::CreatureCellRelocation -> EnsureGridLoadedForActiveObject); it vanishes at the end of its route, after
##   30 s without moving, or at 7 minutes (its TempSummon timer: the longest route takes 352 s at 2 yd/s).
## - The spawner tracks each marcher with its summoning time: every 5 s it forgets those gone and despawns any older than
##   7 minutes; caps 32 crates and 80 on foot.
## - Stop: 3 minutes without a player (not a bot) in those areas the spawner despawns every marcher it tracks (riders first)
##   and stops being active; its grid may then unload. A player coming back wakes it again.
## Worst case: 32 crates x (1 + 4 riders) + 80 on foot = 240 summoned creatures, of which 113 active objects (the spawner, the
## crates, the walkers; the riders ride along); not counted: riders left standing 2 s after an unforeseen exit from their crate
## (Unit::_ExitVehicle) and corpses (none expected, nothing fights them). No leak: a summon exists only in the capped lists from
## its creation; it leaves them only when gone or despawned by the spawner; the spawner, active while running, despawns all of
## them at the stop, and each marcher, active and so always updated, despawns itself at 7 minutes even if the spawner were gone.
##
## Core notes. A summoned vehicle installs its accessories when it is added to the world (Creature::AddToWorld ->
## AIM_Initialize -> Vehicle::Reset -> InstallAllAccessories; Creature::Update skips the second reset for summons), each boarding
## by its 46598 spellclick row (Vehicle::InstallAccessory, unsummoned without one). Seat 0 of vehicle 822 has no CAN_CONTROL, so
## the puller does not charm the crate and this AI keeps driving it. While the crate walks, each relocation moves its passengers
## (Map::CreatureRelocation and MoveAllCreaturesInMoveList -> Vehicle::RelocatePassengers; the client draws them on the crate's
## transport). Nothing else takes them off: they are friendly to everyone and the naga are neutral to them (faction 35), and an
## evade or reset of the crate only reinstalls minions into empty seats. Fiona's Caravan in Eastern Plaguelands is the same
## thing (a summoned vehicle driven point by point with its accessories seated) and was seen working in game on 2026-11-14.
## Each leg is one MovePoint with path finding (a long linear spline is drawn in the wrong place by the client, C20).
######*/

enum RockpoolMarch
{
    NPC_ROCKPOOL_MURLOC_WALKER      = 41357,
    NPC_ROCKPOOL_TADPOLE_WALKER     = 41358,
    NPC_BLOODWASH_CRATE_SPAWNER     = 41359,
    NPC_BLOODWASH_CRATE             = 41362,

    MAP_ROCKPOOL                    = 0,
    SPAWNER_SPAWN_ID                = 163043,   // the one 41359 (both TDBs have one, at the same spot)

    AREA_THE_RED_REACHES            = 5078,
    AREA_ROCKPOOL_VILLAGE           = 5079,
    AREA_BLOODWASH_FIGHTING_PITS    = 5080,
    AREA_BLOODWASH_SHRINE           = 5081,
    AREA_BLOODWASH_CAVERN           = 5082,

    ACTION_MARCH_PLAYER_NEAR        = 1,

    MARCH_ROUTE_CAVE                = 0,
    MARCH_ROUTE_SHRINE              = 1,
};

static constexpr float  MarchSpeed          = 2.0f;     // speed_walk 0.8 x 2.5
static constexpr uint32 MarchCrateEveryMs   = 13 * IN_MILLISECONDS;
static constexpr uint32 MarchWalkerEveryMs  = 5 * IN_MILLISECONDS;
static constexpr uint32 MarchShrineOneIn    = 7;
static constexpr uint32 MarchMaxCrates      = 32;
static constexpr uint32 MarchMaxWalkers     = 80;
static constexpr uint32 MarchHeartbeatMs    = 2 * IN_MILLISECONDS;
static constexpr uint32 MarchQuietStopMs    = 3 * MINUTE * IN_MILLISECONDS;
static constexpr uint32 MarchPruneMs        = 5 * IN_MILLISECONDS;
static constexpr uint32 MarchLifeMs         = 7 * MINUTE * IN_MILLISECONDS;   // longest route 705 yd = 352 s, plus margin
static constexpr uint32 MarchPrefillPerTick = 6;
static constexpr uint32 MarchStuckMs        = 30 * IN_MILLISECONDS;
static Position const MarchSpawnerPos       = { -12089.8f, -3844.68f, 0.97766f };

static bool IsMarchArea(uint32 areaId)
{
    return areaId >= AREA_THE_RED_REACHES && areaId <= AREA_BLOODWASH_CAVERN;
}

// Rockpool Village -> the fork (-12380.6, -3563.1) -> Bloodwash Cavern (area 5082); from the sniffed walker paths
static Position const MarchCave[] =
{
    { -12089.8f, -3844.7f,  0.98f }, { -12092.6f, -3842.6f,  0.8f  }, { -12106.6f, -3817.2f,  3.1f  }, { -12120.9f, -3800.1f,  4.0f  },
    { -12128.2f, -3787.7f,  4.3f  }, { -12138.3f, -3780.3f,  4.7f  }, { -12146.2f, -3768.5f,  5.6f  }, { -12155.6f, -3762.3f,  6.2f  },
    { -12167.4f, -3748.3f,  6.5f  }, { -12176.8f, -3739.3f,  5.9f  }, { -12188.7f, -3726.5f,  6.4f  }, { -12194.6f, -3721.6f,  7.8f  },
    { -12208.0f, -3707.7f,  9.2f  }, { -12218.9f, -3695.6f,  9.8f  }, { -12225.9f, -3686.9f, 10.8f  }, { -12235.5f, -3677.2f, 11.7f  },
    { -12246.6f, -3666.3f, 12.7f  }, { -12257.2f, -3657.9f, 13.7f  }, { -12268.7f, -3643.5f, 14.9f  }, { -12277.8f, -3638.5f, 15.3f  },
    { -12297.9f, -3626.7f, 16.2f  }, { -12328.0f, -3603.1f, 16.3f  }, { -12337.0f, -3595.5f, 16.8f  }, { -12348.5f, -3587.7f, 17.8f  },
    { -12357.5f, -3583.1f, 19.1f  }, { -12370.8f, -3573.7f, 19.1f  }, { -12380.6f, -3563.1f, 19.1f  }, { -12372.8f, -3534.4f, 20.2f  },
    { -12370.2f, -3528.7f, 21.2f  }, { -12363.9f, -3519.7f, 20.2f  }, { -12350.6f, -3502.2f, 17.9f  }, { -12316.0f, -3484.2f, 18.0f  },
    { -12302.7f, -3479.0f, 18.0f  }, { -12272.9f, -3476.3f, 20.2f  }, { -12259.9f, -3475.2f, 23.8f  }, { -12232.7f, -3472.7f, 27.4f  },
    { -12194.0f, -3461.8f, 27.4f  }, { -12162.3f, -3446.9f, 27.1f  }, { -12144.2f, -3441.4f, 29.1f  }, { -12136.0f, -3441.7f, 31.9f  },
};

// The same trunk, then from the fork north-west to Bloodwash Shrine (area 5081)
static Position const MarchShrine[] =
{
    { -12089.8f, -3844.7f,  0.98f }, { -12092.6f, -3842.6f,  0.8f  }, { -12106.6f, -3817.2f,  3.1f  }, { -12120.9f, -3800.1f,  4.0f  },
    { -12128.2f, -3787.7f,  4.3f  }, { -12138.3f, -3780.3f,  4.7f  }, { -12146.2f, -3768.5f,  5.6f  }, { -12155.6f, -3762.3f,  6.2f  },
    { -12167.4f, -3748.3f,  6.5f  }, { -12176.8f, -3739.3f,  5.9f  }, { -12188.7f, -3726.5f,  6.4f  }, { -12194.6f, -3721.6f,  7.8f  },
    { -12208.0f, -3707.7f,  9.2f  }, { -12218.9f, -3695.6f,  9.8f  }, { -12225.9f, -3686.9f, 10.8f  }, { -12235.5f, -3677.2f, 11.7f  },
    { -12246.6f, -3666.3f, 12.7f  }, { -12257.2f, -3657.9f, 13.7f  }, { -12268.7f, -3643.5f, 14.9f  }, { -12277.8f, -3638.5f, 15.3f  },
    { -12297.9f, -3626.7f, 16.2f  }, { -12328.0f, -3603.1f, 16.3f  }, { -12337.0f, -3595.5f, 16.8f  }, { -12348.5f, -3587.7f, 17.8f  },
    { -12357.5f, -3583.1f, 19.1f  }, { -12370.8f, -3573.7f, 19.1f  }, { -12380.6f, -3563.1f, 19.1f  }, { -12391.9f, -3559.5f, 20.0f  },
    { -12396.6f, -3540.1f, 22.8f  }, { -12404.7f, -3525.4f, 22.8f  }, { -12413.8f, -3512.2f, 23.6f  }, { -12425.2f, -3495.0f, 25.7f  },
    { -12438.8f, -3476.7f, 23.3f  }, { -12444.9f, -3462.2f, 19.3f  }, { -12446.7f, -3445.2f, 16.7f  }, { -12446.0f, -3416.0f, 16.4f  },
};

struct MarchRoute
{
    Position const* Points;
    uint32 Count;
};

static MarchRoute const MarchRoutes[] =
{
    { MarchCave,   uint32(std::extent<decltype(MarchCave)>::value) },
    { MarchShrine, uint32(std::extent<decltype(MarchShrine)>::value) },
};

// A route point moved sideways (to the walker's left for a positive offset) along the leg that arrives at it
static Position MarchPoint(uint8 route, uint32 index, float lateral)
{
    MarchRoute const& r = MarchRoutes[route];
    Position const& p = r.Points[index];
    if (lateral == 0.0f || r.Count < 2)
        return p;

    Position const& a = index > 0 ? r.Points[index - 1] : r.Points[0];
    Position const& b = index > 0 ? p : r.Points[1];
    float const dir = std::atan2(b.GetPositionY() - a.GetPositionY(), b.GetPositionX() - a.GetPositionX());
    float const side = dir + float(M_PI) / 2.0f;
    return Position(p.GetPositionX() + lateral * std::cos(side), p.GetPositionY() + lateral * std::sin(side), p.GetPositionZ());
}

// 41362 Bloodwash Crate (with its riders), 41357 Rockpool Murloc, 41358 Rockpool Tadpole: summoned by the spawner, they walk
// their route point by point from where they were placed and vanish at its end. Active objects for their whole life (see above)
struct npc_rockpool_marcher : public CreatureAI
{
    npc_rockpool_marcher(Creature* creature) : CreatureAI(creature) { }

    void Start(uint8 route, uint32 nextPoint, float lateral)
    {
        _route = route;
        _next = nextPoint;
        _lateral = lateral;
        _started = true;
        _moveNext = true;
        _stuckMs = 0;
        me->setActive(true, ActiveFlags::Script);
        me->SetReactState(REACT_PASSIVE);
        me->SetWalk(true);
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    void OnCharmed(bool /*apply*/) override { }

    void MovementInform(uint32 type, uint32 id) override
    {
        if (type != POINT_MOTION_TYPE || !_started || id != _next)
            return;

        ++_next;
        _moveNext = true;
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_started)
            return;

        if (_moveNext)
        {
            _moveNext = false;
            _stuckMs = 0;
            MoveNext();
            return;
        }

        // Something stopped it for good (a failed path): it goes rather than standing in the line
        if (!me->isMoving())
        {
            _stuckMs += diff;
            if (_stuckMs >= MarchStuckMs)
                Vanish();
        }
        else
            _stuckMs = 0;
    }

private:
    void MoveNext()
    {
        if (_next >= MarchRoutes[_route].Count)
        {
            Vanish();
            return;
        }

        me->SetWalk(true);
        me->GetMotionMaster()->MovePoint(_next, MarchPoint(_route, _next, _lateral), true);
    }

    void Vanish()
    {
        _started = false;
        DespawnSeatedCreatures(me);
        me->setActive(false, ActiveFlags::Script);
        me->DespawnOrUnsummon();
    }

    uint8 _route = MARCH_ROUTE_CAVE;
    uint32 _next = 0;
    uint32 _stuckMs = 0;
    float _lateral = 0.0f;
    bool _started = false;
    bool _moveNext = false;
};

// 41359 Bloodwash Crate Spawner (Rockpool Village): keeps the march going while players are in its areas (see above)
struct npc_bloodwash_crate_spawner : public CreatureAI
{
    npc_bloodwash_crate_spawner(Creature* creature) : CreatureAI(creature) { }

    void Reset() override
    {
        me->SetReactState(REACT_PASSIVE);
    }

    void MoveInLineOfSight(Unit* /*who*/) override { }
    void AttackStart(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    void OnCharmed(bool /*apply*/) override { }

    // From player_rockpool_march_watch: a player stands in the march's areas
    void DoAction(int32 action) override
    {
        if (action != ACTION_MARCH_PLAYER_NEAR)
            return;

        _quietMs = 0;
        if (!_running)
            Wake();
    }

    void UpdateAI(uint32 diff) override
    {
        if (!_running)
            return;

        _quietMs += diff;
        if (_quietMs >= MarchQuietStopMs)
        {
            Stop();
            return;
        }

        _sinceWakeMs += diff;

        if (_pruneMs <= diff)
        {
            _pruneMs = MarchPruneMs;
            Prune(_crates);
            Prune(_walkers);
        }
        else
            _pruneMs -= diff;

        // The line placed at wake-up, a few each update (each summon finds a path)
        for (uint32 i = 0; i < MarchPrefillPerTick && !_prefill.empty(); ++i)
        {
            Pending const pending = _prefill.back();
            _prefill.pop_back();
            Summon(pending.Entry, pending.Route, float(pending.AgeMs + _sinceWakeMs) / IN_MILLISECONDS);
        }

        if (_crateMs <= diff)
        {
            _crateMs = MarchCrateEveryMs;
            Summon(NPC_BLOODWASH_CRATE, NextRoute(_crateCount), 0.0f);
        }
        else
            _crateMs -= diff;

        if (_walkerMs <= diff)
        {
            _walkerMs = MarchWalkerEveryMs;
            uint32 const entry = (_walkerCount % 2) ? NPC_ROCKPOOL_TADPOLE_WALKER : NPC_ROCKPOOL_MURLOC_WALKER;
            Summon(entry, NextRoute(_walkerCount), 0.0f);
        }
        else
            _walkerMs -= diff;
    }

private:
    struct Pending
    {
        uint32 Entry;
        uint8 Route;
        uint32 AgeMs;
    };

    struct Marcher
    {
        ObjectGuid Guid;
        uint32 BornMs;
    };

    // The line as it would stand had the march been running: one entry per interval back in time, as long as it is still on
    // its route
    void Wake()
    {
        _running = true;
        _quietMs = 0;
        _sinceWakeMs = 0;
        _pruneMs = MarchPruneMs;
        _crateMs = MarchCrateEveryMs;
        _walkerMs = MarchWalkerEveryMs;
        _prefill.clear();
        me->setActive(true, ActiveFlags::Script);

        if (!_crates.empty() || !_walkers.empty())
            return;

        float const longest = std::max(RouteLength(MARCH_ROUTE_CAVE), RouteLength(MARCH_ROUTE_SHRINE));
        for (uint32 age = MarchCrateEveryMs; float(age) / IN_MILLISECONDS * MarchSpeed < longest; age += MarchCrateEveryMs)
            _prefill.push_back({ NPC_BLOODWASH_CRATE, NextRoute(_crateCount), age });
        for (uint32 age = MarchWalkerEveryMs; float(age) / IN_MILLISECONDS * MarchSpeed < longest; age += MarchWalkerEveryMs)
        {
            uint32 const entry = (_walkerCount % 2) ? NPC_ROCKPOOL_TADPOLE_WALKER : NPC_ROCKPOOL_MURLOC_WALKER;
            _prefill.push_back({ entry, NextRoute(_walkerCount), age });
        }
    }

    // Nobody near for 3 minutes: every marcher goes, riders first, and the spawner rests (its grid may unload)
    void Stop()
    {
        _running = false;
        _prefill.clear();
        for (std::vector<Marcher>* list : { &_crates, &_walkers })
        {
            for (Marcher const& marcher : *list)
                if (Creature* creature = ObjectAccessor::GetCreature(*me, marcher.Guid))
                {
                    DespawnSeatedCreatures(creature);
                    creature->DespawnOrUnsummon();
                }
            list->clear();
        }
        me->setActive(false, ActiveFlags::Script);
    }

    uint8 NextRoute(uint32& counter)
    {
        return (counter++ % MarchShrineOneIn) == MarchShrineOneIn - 1 ? MARCH_ROUTE_SHRINE : MARCH_ROUTE_CAVE;
    }

    static float RouteLength(uint8 route)
    {
        MarchRoute const& r = MarchRoutes[route];
        float length = 0.0f;
        for (uint32 i = 1; i < r.Count; ++i)
            length += r.Points[i - 1].GetExactDist(&r.Points[i]);
        return length;
    }

    // Forget the marchers that are gone; despawn any that outlived the longest route (it cannot have been updated)
    void Prune(std::vector<Marcher>& list)
    {
        uint32 const now = getMSTime();
        list.erase(std::remove_if(list.begin(), list.end(), [this, now](Marcher const& marcher)
        {
            Creature* creature = ObjectAccessor::GetCreature(*me, marcher.Guid);
            if (!creature || !creature->IsAlive() || creature->IsDestroyedObject())
                return true;
            if (getMSTimeDiff(marcher.BornMs, now) < MarchLifeMs)
                return false;
            DespawnSeatedCreatures(creature);
            creature->DespawnOrUnsummon();
            return true;
        }), list.end());
    }

    // One marcher, placed where one summoned ageSec seconds ago would now be (0: at the spawner)
    void Summon(uint32 entry, uint8 route, float ageSec)
    {
        bool const crate = entry == NPC_BLOODWASH_CRATE;
        std::vector<Marcher>& list = crate ? _crates : _walkers;
        if (list.size() >= (crate ? MarchMaxCrates : MarchMaxWalkers))
            return;

        float const lateral = crate ? 0.0f : frand(1.0f, 3.0f) * (urand(0, 1) ? 1.0f : -1.0f);

        // Find the leg it is on
        MarchRoute const& r = MarchRoutes[route];
        float left = ageSec * MarchSpeed;
        uint32 next = 1;
        Position from = MarchPoint(route, 0, lateral);
        Position to = MarchPoint(route, 1, lateral);
        while (next < r.Count)
        {
            from = MarchPoint(route, next - 1, lateral);
            to = MarchPoint(route, next, lateral);
            float const leg = from.GetExactDist(&to);
            if (left < leg)
                break;
            left -= leg;
            ++next;
        }
        if (next >= r.Count)
            return;     // it would have arrived already

        float const legLength = std::max(from.GetExactDist(&to), 0.1f);
        float const t = left / legLength;
        float x = from.GetPositionX() + (to.GetPositionX() - from.GetPositionX()) * t;
        float y = from.GetPositionY() + (to.GetPositionY() - from.GetPositionY()) * t;
        float z = from.GetPositionZ() + (to.GetPositionZ() - from.GetPositionZ()) * t;
        if (ageSec <= 0.0f)
        {
            // at the spawner, a little to the side as 77476 / 77481 / 77480 place them (within 8 yd)
            x = me->GetPositionX() + (crate ? 0.0f : frand(-2.0f, 2.0f));
            y = me->GetPositionY() + (crate ? 0.0f : frand(-2.0f, 2.0f));
            z = me->GetPositionZ();
            next = 1;
        }

        float const ground = me->GetMap()->GetHeight(me->GetPhaseMask(), x, y, z + 5.0f, true, 30.0f);
        if (ground > INVALID_HEIGHT)
            z = ground;

        // A marcher placed in a grid nobody has loaded would not be updated there (the walkers are active only once added)
        if (!me->GetMap()->IsGridLoaded(x, y))
            me->GetMap()->LoadGrid(x, y);

        float const facing = std::atan2(to.GetPositionY() - y, to.GetPositionX() - x);
        TempSummon* summon = me->SummonCreature(entry, Position(x, y, z, facing), TEMPSUMMON_TIMED_DESPAWN, Milliseconds(MarchLifeMs));
        if (!summon)
            return;

        list.push_back({ summon->GetGUID(), getMSTime() });
        if (npc_rockpool_marcher* ai = CAST_AI(npc_rockpool_marcher, summon->AI()))
            ai->Start(route, next, lateral);
        else
            summon->DespawnOrUnsummon();
    }

    std::vector<Marcher> _crates;
    std::vector<Marcher> _walkers;
    std::vector<Pending> _prefill;
    uint32 _quietMs = 0;
    uint32 _pruneMs = MarchPruneMs;
    uint32 _sinceWakeMs = 0;
    uint32 _crateMs = MarchCrateEveryMs;
    uint32 _walkerMs = MarchWalkerEveryMs;
    uint32 _crateCount = 0;
    uint32 _walkerCount = 0;
    bool _running = false;
};

// Wakes the march (and keeps it awake) while a player stands in one of its areas. Called on every player update: the cheap
// tests come first (map, cached zone and area), then at most one request every 2 s
class player_rockpool_march_watch : public PlayerScript
{
public:
    player_rockpool_march_watch() : PlayerScript("player_rockpool_march_watch") { }

    void OnUpdate(Player* player, uint32 /*diff*/) override
    {
        if (player->GetMapId() != MAP_ROCKPOOL || player->GetZoneId() != ZONE_BLASTED_LANDS || !IsMarchArea(player->GetAreaId()))
            return;

        // Playerbots do not count: a random bot standing on the beach would keep the march running for nobody. The heartbeat
        // is the only thing that keeps the spawner awake, so bots hold it open neither (a real player with bots wakes it)
        if (player->GetSession()->IsBot())
            return;

        // Only map 0's update thread gets here
        uint32 const now = getMSTime();
        if (_lastRequestMs && getMSTimeDiff(_lastRequestMs, now) < MarchHeartbeatMs)
            return;
        _lastRequestMs = now;

        Map* map = player->GetMap();
        Creature* spawner = FindSpawner(map);
        if (!spawner)
        {
            // A player who comes to the cave or the shrine first: the village's grid is not loaded yet
            map->LoadGrid(MarchSpawnerPos.GetPositionX(), MarchSpawnerPos.GetPositionY());
            spawner = FindSpawner(map);
        }

        if (spawner && spawner->IsAIEnabled)
            spawner->AI()->DoAction(ACTION_MARCH_PLAYER_NEAR);
    }

private:
    static Creature* FindSpawner(Map* map)
    {
        auto bounds = map->GetCreatureBySpawnIdStore().equal_range(SPAWNER_SPAWN_ID);
        for (auto itr = bounds.first; itr != bounds.second; ++itr)
            if (itr->second->IsInWorld() && itr->second->IsAlive() && itr->second->GetEntry() == NPC_BLOODWASH_CRATE_SPAWNER)
                return itr->second;
        return nullptr;
    }

    uint32 _lastRequestMs = 0;
};

void AddSC_blasted_lands_rockpool()
{
    new creature_script<npc_rockpool_marcher>("npc_rockpool_marcher");
    new creature_script<npc_bloodwash_crate_spawner>("npc_bloodwash_crate_spawner");
    new player_rockpool_march_watch();
    new creature_script<npc_abandoned_bloodwash_crate>("npc_abandoned_bloodwash_crate");
    new creature_script<npc_bloodwash_crate_adrift>("npc_bloodwash_crate_adrift");
    new spell_script<spell_rockpool_quest_launch>("spell_rockpool_quest_launch");
    new unit_rockpool_crate_drop();
}
