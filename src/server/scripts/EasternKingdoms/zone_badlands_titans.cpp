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

/* Badlands, Tomb of the Watchers (area 5526): The Warden's Game (27693 / 27885) and The Sentinel's Game (27709 / 27886).

   Both boards are laid out when the Pawn quest is handed in at its slab (the Game is auto-accepted there), are private to the
   player who placed the statue (SummonProperties 2841: personal, despawn when expired; the wiki: "visible only to the player")
   and last 20 minutes (the summon spells' duration). Solving one completes the quest, handed in from the log.

   The Warden's Game. Sourced: 86343 Summon Controller (46339 on the stone slab, spell_target_position) with its 20-minute marker
   aura on the player, 86368 Teleport Effect, 86394 Despawn All Summons (3 s feign death: the statues fall); eight jade statues
   46344 round an empty centre, all facing out; clicking any statue makes it jump to the empty square, any distance, keeping its
   facing; solved when all face the centre, i.e. each stands on the square opposite its start (comments; 12 clicks). Ours: the
   2.4 yd squares (the slab model is about 7.2 yd across), the statues summoned directly by the controller at the squares (86342
   is the DBC's summon; same entry, SummonProperties and owner).

   The Sentinel's Game. Sourced: 86429 Summon Start Pawn (the red statue 46397 on the marble slab, facing 4.71, with the marker
   aura), the nine stone statues 46395 and the red statue 46398 in the far alcove at the points of 86431 / 86546-86553 / 86430,
   86432 Beam (cone 10 deg, 60 yd), 86555 Despawn All Summons; every statue, the placed one too, turns through three facings,
   clockwise, on a click; a statue under the beam passes it on in its own facing; one statue is never used and it is the first
   one the beam touches; three statues by the far door are on the path; one solution; when the beam reaches the alcove statue,
   all fall over (comments, wiki). Ours: the facings (no source holds them; research/badlands/dossiers/titans.md 9.1, checked by
   brute force over all 3^10 boards in research/badlands/tmp/coder-e/sentinel_cw.py: one path S-P3-P2-P9-P8-P5-P4-P7-P6-C,
   13 clicks, no loop anywhere, every click a clockwise turn), the beam drawn as 86432's channel from each statue to the next.

   Ours for both: the slab starts the board on quest accept (SourceSpellID is not cast on the auto-accept path) and offers
   "Place the statue down on the slab." (BroadcastText 47074) when the Game is in the log and no board is out (after a logout,
   the 20-minute expiry or a death); a playerbot never gets a board; when the owner solves, the playerbots of his group within 40 yd
   holding the same Game incomplete are credited too (another real player plays his own board; nobody else sees it: the private owner is the player's guid, and
   WorldObject::CheckPrivateObjectOwnerVisibility shows a private object to a group only when its owner is the group's guid). The board ends on abandon, on the
   owner's logout or map change (a player's summons go with him), at the expiry, when a new board of the same player replaces
   it, and falls over when the quest is completed some other way (a GM command). */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "GameObjectAI.h"
#include "GameObject.h"
#include "Player.h"
#include "Group.h"
#include "ObjectAccessor.h"
#include "TemporarySummon.h"
#include "SpellAuras.h"
#include "WorldSession.h"
#include "CreatureTextMgr.h"

enum BadlandsTitanGames
{
    QUEST_WARDENS_GAME_A            = 27693,
    QUEST_WARDENS_GAME_H            = 27885,
    QUEST_SENTINELS_GAME_A          = 27709,
    QUEST_SENTINELS_GAME_H          = 27886,

    NPC_WARDENS_GAME_CONTROLLER     = 46339,
    NPC_WARDENS_PAWN                = 46344,
    NPC_SENTINELS_PAWN              = 46395,
    NPC_SENTINELS_START_PAWN        = 46397,
    NPC_SENTINELS_COMPLETE_PAWN     = 46398,

    SPELL_WARDENS_SUMMON_CONTROLLER = 86343,
    SPELL_WARDENS_TELEPORT_EFFECT   = 86368,
    SPELL_WARDENS_DESPAWN_ALL       = 86394,
    SPELL_SENTINELS_SUMMON_START    = 86429,
    SPELL_SENTINELS_BEAM            = 86432,
    SPELL_SENTINELS_DESPAWN_ALL     = 86555,

    GOSSIP_MENU_MARBLE_SLAB         = 12171,
    GOSSIP_MENU_STONE_SLAB          = 12172,
};

float const GameCreditRange     = 40.0f;
uint32 const GameDurationMs     = 20 * MINUTE * IN_MILLISECONDS;   // 86343 / 86429 and every game summon: 1200000 ms
uint32 const GameFallMs         = 3000;                            // 86394 / 86555 feign death
uint32 const GameCheckMs        = 1000;

// Where the board masters stand when the summon spell cannot be cast (spell_target_position of 86343 / 86429)
Position const WardensControllerPos = { -6964.45f, -3445.20f, 201.065f, 3.11646f };
Position const SentinelsStartPos    = { -6895.69f, -3375.16f, 202.281f, 4.71162f };

struct TitanGame
{
    uint32 questA;
    uint32 questH;
    uint32 creditEntry;     // the objective's creature (KilledMonsterCredit)
    uint32 boardEntry;      // the board's master, summoned by the marker spell
    uint32 markerSpell;     // summons the master and marks the player for 20 minutes
    uint32 fallSpell;
    Position const* fallbackPos;
};

TitanGame const WardensGame   = { QUEST_WARDENS_GAME_A,   QUEST_WARDENS_GAME_H,   NPC_WARDENS_GAME_CONTROLLER, NPC_WARDENS_GAME_CONTROLLER,
                                  SPELL_WARDENS_SUMMON_CONTROLLER, SPELL_WARDENS_DESPAWN_ALL,   &WardensControllerPos };
TitanGame const SentinelsGame = { QUEST_SENTINELS_GAME_A, QUEST_SENTINELS_GAME_H, NPC_SENTINELS_COMPLETE_PAWN, NPC_SENTINELS_START_PAWN,
                                  SPELL_SENTINELS_SUMMON_START,    SPELL_SENTINELS_DESPAWN_ALL, &SentinelsStartPos };

static bool HasGameIncomplete(Player* player, TitanGame const& game)
{
    return player->GetQuestStatus(game.questA) == QUEST_STATUS_INCOMPLETE || player->GetQuestStatus(game.questH) == QUEST_STATUS_INCOMPLETE;
}

static bool HasGameDone(Player* player, TitanGame const& game)
{
    for (uint32 questId : { game.questA, game.questH })
    {
        QuestStatus status = player->GetQuestStatus(questId);
        if (status == QUEST_STATUS_COMPLETE || status == QUEST_STATUS_REWARDED)
            return true;
    }
    return false;
}

// The board of this player (its master is private to him), if one is out near him
static Creature* FindBoardOf(Player* player, uint32 boardEntry)
{
    std::list<Creature*> masters;
    player->GetCreatureListWithEntryInGrid(masters, boardEntry, 150.0f);
    for (Creature* master : masters)
        if (master->IsAlive() && master->IsInWorld() && !master->IsDestroyedObject() && master->GetPrivateObjectOwner() == player->GetGUID())
            return master;
    return nullptr;
}

// The owner solved the board: he gets the objective, and so does every playerbot of his group within 40 yd holding the Game
// incomplete (a bot can never play a board). Another real player of the group plays his own board: the boards are personal.
static void CreditGame(Player* solver, TitanGame const& game)
{
    std::vector<Player*> players = { solver };
    if (Group* group = solver->GetGroup())
        for (GroupReference* ref = group->GetFirstMember(); ref; ref = ref->next())
        {
            Player* member = ref->GetSource();
            if (member && member != solver && member->GetSession()->IsBot() && member->IsInMap(solver)
                && member->IsWithinDistInMap(solver, GameCreditRange))
                players.push_back(member);
        }

    for (Player* player : players)
        if (HasGameIncomplete(player, game))
        {
            player->KilledMonsterCredit(game.creditEntry);
            TC_LOG_DEBUG("scripts", "Badlands titans: board of %s solved, credit %u to %s", solver->GetName().c_str(), game.creditEntry, player->GetName().c_str());
        }
}

// The board's master: the Warden's controller, the Sentinel's start statue. It owns the other pieces and every end path.
struct npc_badlands_titan_board : public ScriptedAI
{
    npc_badlands_titan_board(Creature* creature, TitanGame const& game) : ScriptedAI(creature), _game(game) { }

    virtual void SetupBoard() = 0;
    virtual void PieceClicked(Creature* piece, Player* clicker) = 0;
    virtual void BeforeFall() { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner->ToPlayer();
        if (!player)
        {
            me->DespawnOrUnsummon();
            return;
        }

        _ownerGUID = player->GetGUID();
        _startTime = getMSTime();
        me->SetReactState(REACT_PASSIVE);
        me->SetUInt32Value(UNIT_FIELD_NPC_FLAGS, 0);   // 46339 / 46398 are quest starters in the DB: no quest dialog on a game piece
        SetupBoard();
        TC_LOG_DEBUG("scripts", "Badlands titans: board %u laid out for %s", me->GetEntry(), player->GetName().c_str());
    }

    void JustSummoned(Creature* summon) override
    {
        _pieces.push_back(summon->GetGUID());
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    // Expiry (20 min), the owner's logout or map change (a player's summons are unsummoned with him), a replacing board, the
    // end of the fall: the pieces go, and the marker unless a fall already took it
    void Unsummoned() override
    {
        End();
    }

    void UpdateAI(uint32 diff) override
    {
        if (_done || _ended)
            return;

        if (_checkTimer > diff)
        {
            _checkTimer -= diff;
            return;
        }
        _checkTimer = GameCheckMs;

        Player* owner = ObjectAccessor::GetPlayer(*me, _ownerGUID);
        if (!owner || !owner->IsInMap(me))
        {
            Abort();
            return;
        }

        if (HasGameIncomplete(owner, _game))
            return;

        // Completed some other way (a GM command): the statues fall as if solved here. Abandoned: gone at once.
        if (HasGameDone(owner, _game))
            Fall();
        else
            Abort();
    }

    // Ends the board now (abandon, replaced by a new board, owner gone)
    void Abort()
    {
        End();
        me->DespawnOrUnsummon();
    }

protected:
    Player* GetBoardOwner() const { return ObjectAccessor::GetPlayer(*me, _ownerGUID); }
    bool IsOwner(Player* player) const { return player && player->GetGUID() == _ownerGUID; }
    bool IsPlaying() const { return !_done && !_ended; }

    void Solved()
    {
        if (!IsPlaying())
            return;

        if (Player* owner = GetBoardOwner())
            CreditGame(owner, _game);
        Fall();
    }

    // "The jade statue becomes one again" / "The red statue falls over": every piece feigns death for 3 s, then all go
    void Fall()
    {
        if (!IsPlaying())
            return;
        _done = true;

        RemoveMarker();
        BeforeFall();
        PlayEnd();
    }

    // Every piece feigns death (the despawn spell's 3 s aura), then all go. The Warden's board merges instead.
    virtual void PlayEnd()
    {
        for (ObjectGuid const& guid : _pieces)
            if (Creature* piece = ObjectAccessor::GetCreature(*me, guid))
            {
                me->AddAura(_game.fallSpell, piece);
                piece->DespawnOrUnsummon(GameFallMs);
            }
        if (FallsItself())
            me->AddAura(_game.fallSpell, me);
        me->DespawnOrUnsummon(GameFallMs + 200);
    }

    virtual bool FallsItself() const { return false; }

public:
    // The marker means "a board is out" for the slab's restart option, but its AreaGroup (the tomb, area 5526) strips it when
    // the player walks out, and a death strips the Warden's. The slab puts it back, for the board's remaining time, when the
    // player comes back to a board that is still out (go_badlands_titan_slab::OnGossipHello).
    void RestoreMarker(Player* player)
    {
        if (!IsPlaying() || !IsOwner(player) || player->HasAura(_game.markerSpell))
            return;
        uint32 age = GetMSTimeDiffToNow(_startTime);
        if (age + 1000 >= GameDurationMs)
            return;
        if (Aura* marker = player->AddAura(_game.markerSpell, player))
        {
            marker->SetMaxDuration(int32(GameDurationMs - age));
            marker->SetDuration(int32(GameDurationMs - age));
            _markerRemoved = false;
        }
    }

protected:

    ObjectGuid const& GetOwnerGUID() const { return _ownerGUID; }
    GuidVector const& GetPieces() const { return _pieces; }

private:
    void End()
    {
        if (_ended)
            return;
        _ended = true;

        for (ObjectGuid const& guid : _pieces)
            if (Creature* piece = ObjectAccessor::GetCreature(*me, guid))
                piece->DespawnOrUnsummon();
        _pieces.clear();
        RemoveMarker();
    }

    // The 20-minute marker means "this player has a board out" (the slab's restart option is shown without it). Not touched
    // while the player is being removed from the world: it is not saved anyway (spell_custom_attribute DONT_SAVE).
    void RemoveMarker()
    {
        if (_markerRemoved)
            return;
        _markerRemoved = true;

        if (Player* owner = GetBoardOwner())
            if (owner->IsInWorld() && !owner->IsDuringRemoveFromWorld())
                owner->RemoveAurasDueToSpell(_game.markerSpell);
    }

    TitanGame const& _game;
    ObjectGuid _ownerGUID;
    GuidVector _pieces;
    uint32 _checkTimer = GameCheckMs;
    uint32 _startTime = 0;
    bool _done = false;
    bool _ended = false;
    bool _markerRemoved = false;
};

// 46344 Warden's Pawn, 46395 Sentinel's Pawn (stone), 46398 Sentinel's Pawn (alcove): pieces of a board. A click goes to the
// board; a piece whose board is gone goes too.
struct npc_badlands_titan_game_piece : public ScriptedAI
{
    npc_badlands_titan_game_piece(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        _boardGUID = summoner->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        // The template has no spellclick flag (a flag without an npc_spellclick_spells row is stripped at load); the click is
        // handled here, not by a spell. The alcove statue is not turned.
        me->SetUInt32Value(UNIT_FIELD_NPC_FLAGS, me->GetEntry() == NPC_SENTINELS_COMPLETE_PAWN ? 0 : UNIT_NPC_FLAG_SPELLCLICK);
    }

    void OnSpellClick(Unit* clicker, bool& /*result*/) override
    {
        Player* player = clicker->ToPlayer();
        Creature* board = ObjectAccessor::GetCreature(*me, _boardGUID);
        if (!player || !board || !board->IsAIEnabled)
            return;

        if (npc_badlands_titan_board* ai = dynamic_cast<npc_badlands_titan_board*>(board->AI()))
            ai->PieceClicked(me, player);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    void UpdateAI(uint32 diff) override
    {
        if (!me->IsSummon())
            return;

        if (_checkTimer > diff)
        {
            _checkTimer -= diff;
            return;
        }
        _checkTimer = GameCheckMs;

        Creature* board = ObjectAccessor::GetCreature(*me, _boardGUID);
        if (!board || !board->IsAlive() || board->IsDestroyedObject())
            me->DespawnOrUnsummon();
    }

private:
    ObjectGuid _boardGUID;
    uint32 _checkTimer = GameCheckMs;
};

/* The Warden's Game board: squares 0-8 of a 3x3 board on the stone slab, 4 the centre. Pawn p starts on square p (p != 4)
   facing out, and belongs on square 8 - p, where the same facing points at the centre.
   State: _square[s] = pawn on square s, or -1 (exactly one empty square). Click on pawn p: p moves to the empty square, facing
   kept. Solved: _square[8 - p] == p for every pawn (then the centre is empty). Every arrangement is reachable from every other
   (research/badlands/tmp/coder-e/warden_check.py: 362880 states, the solution 12 clicks from the start), so no click can leave
   the board unsolvable. */
enum WardensGameEvents
{
    EVENT_WARDEN_SPLIT_2 = 1,
    EVENT_WARDEN_SPLIT_4,
    EVENT_WARDEN_SPLIT_8,
    EVENT_WARDEN_MERGE_CORNERS,
    EVENT_WARDEN_MERGE_ACROSS,
    EVENT_WARDEN_MERGE_LAST,
    EVENT_WARDEN_MERGED,
};

float const WardenSquareSpacing = 2.4f;      // ours: the slab model 10061 is +-1.2 yd at scale 1, the slab has size 3
float const StoneSlabOrientation = 6.23083f; // gameobject 155385 (-0.052359): the board's rows run along the slab

struct npc_badlands_wardens_game_controller : public npc_badlands_titan_board
{
    npc_badlands_wardens_game_controller(Creature* creature) : npc_badlands_titan_board(creature, WardensGame) { }

    void SetupBoard() override
    {
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NOT_SELECTABLE);
        _centre = me->GetPosition();

        for (int8 square = 0; square < 9; ++square)
        {
            _square[square] = -1;
            if (square != 4)
            {
                Position pos = SquarePosition(square);
                _pawnFacing[square] = Position::NormalizeOrientation(std::atan2(pos.GetPositionY() - _centre.GetPositionY(), pos.GetPositionX() - _centre.GetPositionX()));
            }
        }

        // "You see the statue split into two, then four, then eight identical statues in a square formation"
        _events.ScheduleEvent(EVENT_WARDEN_SPLIT_2, 500);
        _events.ScheduleEvent(EVENT_WARDEN_SPLIT_4, 1700);
        _events.ScheduleEvent(EVENT_WARDEN_SPLIT_8, 2900);
    }

    void UpdateAI(uint32 diff) override
    {
        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_WARDEN_SPLIT_2: SplitTo({ 1, 7 }); break;
                case EVENT_WARDEN_SPLIT_4: SplitTo({ 3, 5 }); break;
                case EVENT_WARDEN_SPLIT_8: SplitTo({ 0, 2, 6, 8 }); _ready = true; break;
                case EVENT_WARDEN_MERGE_CORNERS: MergeFrom({ 0, 2, 6, 8 }); break;
                case EVENT_WARDEN_MERGE_ACROSS: MergeFrom({ 3, 5 }); break;
                case EVENT_WARDEN_MERGE_LAST: MergeFrom({ 1, 7 }); break;
                case EVENT_WARDEN_MERGED: Merged(); return;
                default: break;
            }
        }

        npc_badlands_titan_board::UpdateAI(diff);
    }

    void PieceClicked(Creature* piece, Player* clicker) override
    {
        if (!IsPlaying() || !_ready || !IsOwner(clicker))
            return;

        int8 pawn = -1;
        for (int8 p = 0; p < 9; ++p)
            if (p != 4 && _pawnGUID[p] == piece->GetGUID())
                pawn = p;

        int8 empty = -1, from = -1;
        for (int8 square = 0; square < 9; ++square)
        {
            if (_square[square] == -1)
                empty = square;
            else if (_square[square] == pawn)
                from = square;
        }
        if (pawn < 0 || empty < 0 || from < 0)
            return;

        Position dest = SquarePosition(empty);
        piece->CastSpell(dest.GetPositionX(), dest.GetPositionY(), dest.GetPositionZ(), SPELL_WARDENS_TELEPORT_EFFECT, true);
        piece->NearTeleportTo(dest.GetPositionX(), dest.GetPositionY(), dest.GetPositionZ(), _pawnFacing[pawn]);
        _square[empty] = pawn;
        _square[from] = -1;

        for (int8 p = 0; p < 9; ++p)
            if (p != 4 && _square[8 - p] != p)
                return;

        Solved();
    }

private:
    // Pawns appear on these squares (pawn p starts on square p), each with the jump's visual
    void SplitTo(std::initializer_list<int8> squares)
    {
        for (int8 square : squares)
        {
            Position pos = SquarePosition(square);
            pos.SetOrientation(_pawnFacing[square]);
            TempSummon* pawn = me->SummonCreature(NPC_WARDENS_PAWN, pos, TEMPSUMMON_TIMED_DESPAWN, Milliseconds(GameDurationMs), 0, me->GetPrivateObjectOwner());
            if (!pawn)
                continue;
            _pawnGUID[square] = pawn->GetGUID();
            _square[square] = square;
            pawn->CastSpell(pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ(), SPELL_WARDENS_TELEPORT_EFFECT, true);
        }
    }

    // "The jade statue becomes one again": the reverse of the split, eight -> four -> two -> one on the centre square, which
    // then fades (the despawn spell's aura and visual)
    void PlayEnd() override
    {
        _events.Reset();
        _events.ScheduleEvent(EVENT_WARDEN_MERGE_CORNERS, 600);
        _events.ScheduleEvent(EVENT_WARDEN_MERGE_ACROSS, 1800);
        _events.ScheduleEvent(EVENT_WARDEN_MERGE_LAST, 3000);
        _events.ScheduleEvent(EVENT_WARDEN_MERGED, 3600);
    }

    // The pawns on these squares jump into the centre; all but the last one go there
    void MergeFrom(std::initializer_list<int8> squares)
    {
        bool last = *squares.begin() == 1;
        for (int8 square : squares)
        {
            int8 pawn = _square[square];
            Creature* piece = pawn >= 0 ? ObjectAccessor::GetCreature(*me, _pawnGUID[pawn]) : nullptr;
            if (!piece)
                continue;
            piece->CastSpell(_centre.GetPositionX(), _centre.GetPositionY(), _centre.GetPositionZ(), SPELL_WARDENS_TELEPORT_EFFECT, true);
            piece->NearTeleportTo(_centre.GetPositionX(), _centre.GetPositionY(), _centre.GetPositionZ(), _pawnFacing[pawn]);
            if (last && !_lastPawn)
                _lastPawn = piece->GetGUID();
            else
                piece->DespawnOrUnsummon(300);
        }
    }

    void Merged()
    {
        if (Creature* piece = ObjectAccessor::GetCreature(*me, _lastPawn))
        {
            me->AddAura(SPELL_WARDENS_DESPAWN_ALL, piece);
            piece->DespawnOrUnsummon(1500);
        }
        me->DespawnOrUnsummon(1700);
    }

    Position SquarePosition(int8 square) const
    {
        float row = float(square / 3 - 1), col = float(square % 3 - 1);
        float c = std::cos(StoneSlabOrientation), s = std::sin(StoneSlabOrientation);
        // row along the slab's facing, column to its left
        float dx = WardenSquareSpacing * (row * c - col * s);
        float dy = WardenSquareSpacing * (row * s + col * c);
        return { _centre.GetPositionX() + dx, _centre.GetPositionY() + dy, _centre.GetPositionZ(), 0.0f };
    }

    EventMap _events;
    Position _centre;
    int8 _square[9] = { };
    ObjectGuid _pawnGUID[9];
    ObjectGuid _lastPawn;
    float _pawnFacing[9] = { };
    bool _ready = false;
};

/* The Sentinel's Game board: statue 0 = S, the placed red statue (the board's master), 1-9 = P1-P9 (the points of 86431,
   86546-86553), 10 = C, the red statue in the far alcove (86430). Statues 0-9 each have three facings, turned clockwise
   (decreasing orientation) by a click: _facing[s] in 0..2.
   The beam: from S along its facing to the nearest statue within +-5 deg and 60 yd (86432), on from there along that statue's
   facing, and so on; it stops on a facing that hits nothing, on a statue already lit, or on C (solved).
   SentinelNext holds that geometry worked out once for every statue and facing (sentinel_check.py / sentinel_cw.py, from the
   same points and facings; the server does no cone test, so float noise cannot change a link): only S has two facings that hit
   a statue (P1, a dead end, at the start; P3), every other statue on the path exactly one, P1 none. Every click turns a statue
   clockwise by 60-165 degrees, the third click back to the first facing included, so the client's shortest turn is always
   clockwise; every wall facing misses the nearest statue by at least 14 degrees outside the cone. 13 clicks solve it. */
uint8 const SentinelStatues = 11;
uint8 const SentinelTurnable = 10;
int8 const SentinelComplete = 10;

Position const SentinelPoints[SentinelStatues] =
{
    { -6895.69f, -3375.16f, 202.281f },     // S  86429
    { -6896.56f, -3395.07f, 202.283f },     // P1 86431
    { -6901.71f, -3402.51f, 202.284f },     // P2 86546
    { -6903.38f, -3377.21f, 202.283f },     // P3 86547
    { -6923.67f, -3386.31f, 202.285f },     // P4 86548
    { -6934.82f, -3399.87f, 202.284f },     // P5 86549
    { -6946.33f, -3376.19f, 202.285f },     // P6 86550
    { -6940.76f, -3377.07f, 202.285f },     // P7 86551
    { -6921.41f, -3404.87f, 202.285f },     // P8 86552
    { -6912.45f, -3405.39f, 202.285f },     // P9 86553
    { -6943.04f, -3372.44f, 202.281f },     // C  86430
};

float const SentinelFacings[SentinelTurnable][3] =
{
    { 4.7116f, 3.4021f, 0.5236f },  // S:  P1 (sniffed start facing), P3, wall
    { 0.0000f, 4.5029f, 2.3038f },  // P1: wall, wall, wall
    { 6.2483f, 3.4036f, 2.0595f },  // P2: wall, P9, wall
    { 1.1170f, 4.7783f, 2.1642f },  // P3: wall, P2, wall
    { 0.8378f, 4.4331f, 2.6459f },  // P4: wall, wall, P7
    { 4.5029f, 3.4208f, 0.8826f },  // P5: wall, wall, P4
    { 4.2586f, 1.9199f, 0.8506f },  // P6: wall, wall, C
    { 0.8029f, 4.2237f, 2.9849f },  // P7: wall, wall, P6
    { 5.6549f, 2.7847f, 1.3265f },  // P8: wall, P5, wall
    { 5.9341f, 3.0836f, 1.6755f },  // P9: wall, P8, wall
};
float const SentinelCompleteFacing = 4.67235f;  // spell_target_position of 86430: faces the same wall as the start (comments)

int8 const SentinelNext[SentinelTurnable][3] =
{
    {  1,  3, -1 },
    { -1, -1, -1 },
    { -1,  9, -1 },
    { -1,  2, -1 },
    { -1, -1,  7 },
    { -1, -1,  4 },
    { -1, -1, 10 },
    { -1, -1,  6 },
    { -1,  5, -1 },
    { -1,  8, -1 },
};

uint32 const SentinelFirstBeamMs = 1000;    // the clients have the statues before the first beam is drawn

struct npc_badlands_sentinels_game_start_pawn : public npc_badlands_titan_board
{
    npc_badlands_sentinels_game_start_pawn(Creature* creature) : npc_badlands_titan_board(creature, SentinelsGame) { }

    void SetupBoard() override
    {
        me->SetUInt32Value(UNIT_FIELD_NPC_FLAGS, UNIT_NPC_FLAG_SPELLCLICK);
        me->SetFacingTo(SentinelFacings[0][0]);
        _statueGUID[0] = me->GetGUID();

        for (uint8 statue = 1; statue < SentinelStatues; ++statue)
        {
            Position pos = SentinelPoints[statue];
            pos.SetOrientation(statue == SentinelComplete ? SentinelCompleteFacing : SentinelFacings[statue][0]);
            uint32 entry = statue == SentinelComplete ? NPC_SENTINELS_COMPLETE_PAWN : NPC_SENTINELS_PAWN;
            if (TempSummon* summon = me->SummonCreature(entry, pos, TEMPSUMMON_TIMED_DESPAWN, Milliseconds(GameDurationMs), 0, me->GetPrivateObjectOwner()))
                _statueGUID[statue] = summon->GetGUID();
        }
        _beamTimer = SentinelFirstBeamMs;
    }

    // The placed statue turns too ("click on the first statue")
    void OnSpellClick(Unit* clicker, bool& /*result*/) override
    {
        if (Player* player = clicker->ToPlayer())
            PieceClicked(me, player);
    }

    void PieceClicked(Creature* piece, Player* clicker) override
    {
        if (!IsPlaying() || !IsOwner(clicker))
            return;

        int8 statue = -1;
        for (uint8 s = 0; s < SentinelTurnable; ++s)
            if (_statueGUID[s] == piece->GetGUID())
                statue = s;
        if (statue < 0)
            return;

        _facing[statue] = (_facing[statue] + 1) % 3;
        piece->SetFacingTo(SentinelFacings[statue][_facing[statue]]);
        if (!_beamTimer)
            UpdateBeam();
    }

    void UpdateAI(uint32 diff) override
    {
        if (_beamTimer && IsPlaying())
        {
            if (_beamTimer > diff)
                _beamTimer -= diff;
            else
            {
                _beamTimer = 0;
                UpdateBeam();
            }
        }

        npc_badlands_titan_board::UpdateAI(diff);
    }

private:
    bool FallsItself() const override { return true; }

    void BeforeFall() override
    {
        for (auto const& link : _links)
            SetLink(link.first, link.second, false);
        _links.clear();
    }

    // Follows the beam from S and redraws only the links that changed
    void UpdateBeam()
    {
        std::vector<std::pair<int8, int8>> links;
        bool lit[SentinelStatues] = { };
        bool solved = false;
        int8 current = 0;
        lit[0] = true;
        while (true)
        {
            int8 next = SentinelNext[current][_facing[current]];
            if (next < 0 || lit[next])
                break;
            links.emplace_back(current, next);
            if (next == SentinelComplete)
            {
                solved = true;
                break;
            }
            lit[next] = true;
            current = next;
        }

        for (auto const& link : _links)
            if (std::find(links.begin(), links.end(), link) == links.end())
                SetLink(link.first, link.second, false);
        for (auto const& link : links)
            if (std::find(_links.begin(), _links.end(), link) == _links.end())
                SetLink(link.first, link.second, true);
        _links = links;

        if (solved)
            Solved();
    }

    // 86432 Sentinel's Game: Beam is a channelled spell (AttributesEx 0x4) whose SpellVisual 18313 has a channel kit: the client
    // draws it from a unit toward UNIT_FIELD_CHANNEL_OBJECT while UNIT_FIELD_CHANNEL_SPELL holds the spell (CGUnit_C::
    // UpdateChannelEffects, run by the mirror handler of both fields). Its cone picks enemies only and the pawns are friendly,
    // so the channel is set by hand on the beaming statue (each beams at one statue at most), object first so that the spell
    // change finds it; the dummy aura on the lit statue gives it the state glow.
    void SetLink(int8 from, int8 to, bool on)
    {
        Creature* source = ObjectAccessor::GetCreature(*me, _statueGUID[from]);
        Creature* target = ObjectAccessor::GetCreature(*me, _statueGUID[to]);
        if (!source || !target)
            return;

        if (on)
        {
            source->SetGuidValue(UNIT_FIELD_CHANNEL_OBJECT, target->GetGUID());
            source->SetUInt32Value(UNIT_FIELD_CHANNEL_SPELL, SPELL_SENTINELS_BEAM);
            source->AddAura(SPELL_SENTINELS_BEAM, target);
        }
        else
        {
            source->SetUInt32Value(UNIT_FIELD_CHANNEL_SPELL, 0);
            source->SetGuidValue(UNIT_FIELD_CHANNEL_OBJECT, ObjectGuid::Empty);
            target->RemoveAurasDueToSpell(SPELL_SENTINELS_BEAM, source->GetGUID());
        }
    }

    ObjectGuid _statueGUID[SentinelStatues];
    uint8 _facing[SentinelTurnable] = { };
    std::vector<std::pair<int8, int8>> _links;
    uint32 _beamTimer = 0;
};

// Lays out a board for the player: the marker spell summons the board's master on the slab (personal summon) and marks him for
// 20 minutes. A board of his that is still out (a restart after a death took the marker) is replaced. Never for a playerbot.
static void StartTitanGame(Player* player, TitanGame const& game)
{
    if (player->GetSession()->IsBot())
        return;

    if (Creature* old = FindBoardOf(player, game.boardEntry))
    {
        if (npc_badlands_titan_board* ai = old->IsAIEnabled ? dynamic_cast<npc_badlands_titan_board*>(old->AI()) : nullptr)
            ai->Abort();
        else
            old->DespawnOrUnsummon();
    }

    player->RemoveAurasDueToSpell(game.markerSpell);
    player->CastSpell(player, game.markerSpell, true);
    if (player->HasAura(game.markerSpell))
        return;

    // The cast failed (its AreaGroup 2778 is the tomb, area 5526): the same board without the spell
    TC_LOG_ERROR("scripts", "Badlands titans: %s could not cast %u at the slab (area %u); board summoned directly", player->GetName().c_str(), game.markerSpell, player->GetAreaId());
    if (player->SummonCreature(game.boardEntry, *game.fallbackPos, TEMPSUMMON_TIMED_DESPAWN, Milliseconds(GameDurationMs), 0, player->GetGUID()))
        if (Aura* marker = player->AddAura(game.markerSpell, player))
            marker->SetDuration(GameDurationMs);
}

// 206335 Stone Slab / 206336 Marble Slab: the Game is accepted here (offered at the Pawn hand-in, or from the slab after an
// abandon); "Place the statue down on the slab." lays the board out again (shown by the conditions only while the Game is in
// the log and the player has no marker, i.e. no board)
struct go_badlands_titan_slab : public GameObjectAI
{
    go_badlands_titan_slab(GameObject* go) : GameObjectAI(go) { }

    TitanGame const& Game() const { return me->GetEntry() == 206336 ? SentinelsGame : WardensGame; }

    bool OnQuestAccept(Player* player, Quest const* quest) override
    {
        TitanGame const& game = Game();
        if (quest->GetQuestId() == game.questA || quest->GetQuestId() == game.questH)
            StartTitanGame(player, game);
        return false;
    }

    // The restart option is shown by the conditions when the player has no marker, so the marker is made to match the board
    // before the gossip and its conditions are built: dropped when no board of his is out (it vanished without its end path:
    // left frozen far away on the same map and unloaded with its grid), put back when his board is still out but the marker
    // went (he walked out of the tomb, whose AreaGroup strips it, or died). A player back at a live board just plays on.
    bool OnGossipHello(Player* player, bool /*isUse*/) override
    {
        TitanGame const& game = Game();
        Creature* board = FindBoardOf(player, game.boardEntry);
        if (!board)
            player->RemoveAurasDueToSpell(game.markerSpell);
        else if (npc_badlands_titan_board* ai = board->IsAIEnabled ? dynamic_cast<npc_badlands_titan_board*>(board->AI()) : nullptr)
            ai->RestoreMarker(player);
        return false;
    }

    bool OnGossipSelect(Player* player, uint32 menuId, uint32 /*gossipListId*/) override
    {
        if (menuId != GOSSIP_MENU_STONE_SLAB && menuId != GOSSIP_MENU_MARBLE_SLAB)
            return false;

        CloseGossipMenuFor(player);
        TitanGame const& game = Game();
        if (HasGameIncomplete(player, game) && !player->HasAura(game.markerSpell))
            StartTitanGame(player, game);
        return true;
    }
};

/* Return to Blam (27794 / 27888): the purification scene at Agmond's End after the hand-in.
   Sourced: the hand-in casts 87203 Summon Eye (RewardSpell, or RewardDisplaySpell, Player::RewardQuest) - the Eye of the
   Watchers 46833 in front of the player, personal (SummonProperties 2993); Blam: "Hey, look! It's flying!" (BroadcastText 47050,
   his creature_text group 2, written by the Blam data commit); the Eye's seven lines 46896-46902 in this order; it hovers over the
   scalding whelp corpse, the wild black dragon egg and Nyxondra's egg (87186 / 87196 / 87197 at their spell_target_position
   points), black smoke rises from each (Summon Corruption 87207-87209, the corruption 46836 with 87206), the three become the
   Purified Black Dragon Egg (87218 at the corpse's point), and the Eye flies away toward the tomb (comments, wiki).
   Ours: the timings, the hover height (3 yd), the flight north-east and the despawns; the player casts 87186 (its marker aura goes
   on him, so the static egg at the camp, hidden while he has it, shows when the scene ends and takes the summoned egg's place);
   no scene for a playerbot. */
enum BadlandsReturnToBlam
{
    NPC_DR_HIERONYMUS_BLAM          = 46664,
    NPC_SCALDING_WHELP_CORPSE       = 46826,
    NPC_WILD_BLACK_DRAGON_EGG       = 46828,
    NPC_NYXONDRAS_EGG               = 46829,
    NPC_BLACK_DRAGON_CORRUPTION     = 46836,

    SPELL_SUMMON_WHELP_CORPSE_AURA  = 87186,
    SPELL_SUMMON_WILD_EGG           = 87196,
    SPELL_SUMMON_NYXONDRAS_EGG      = 87197,
    SPELL_EYE_VISUAL                = 87199,
    SPELL_CORRUPTION_VISUAL         = 87206,
    SPELL_SUMMON_CORRUPTION_1       = 87207,
    SPELL_SUMMON_CORRUPTION_2       = 87208,
    SPELL_SUMMON_CORRUPTION_3       = 87209,
    SPELL_SUMMON_VIABLE_EGG         = 87218,

    SAY_BLAM_IT_IS_FLYING           = 2,    // Blam's group 2 (BroadcastText 47050, personal)
    SAY_EYE_BOOT_UP                 = 0,    // 46896
    SAY_EYE_OBJECTIVE               = 1,    // 46897
    SAY_EYE_ANOMALY                 = 2,    // 46898
    SAY_EYE_EXCISED                 = 3,    // 46899, said twice
    SAY_EYE_REASSEMBLE              = 4,    // 46900
    SAY_EYE_VIABLE                  = 5,    // 46901
    SAY_EYE_COMPLETE                = 6,    // 46902

    EVENT_EYE_BLAM = 1,
    EVENT_EYE_BOOT_UP,
    EVENT_EYE_OBJECTIVE,
    EVENT_EYE_TO_CORPSE,
    EVENT_EYE_CORPSE,
    EVENT_EYE_TO_WILD_EGG,
    EVENT_EYE_WILD_EGG,
    EVENT_EYE_TO_NYXONDRAS_EGG,
    EVENT_EYE_NYXONDRAS_EGG,
    EVENT_EYE_REASSEMBLE,
    EVENT_EYE_VIABLE,
    EVENT_EYE_COMPLETE,
    EVENT_EYE_END,
};

// spell_target_position of 87186 / 87196 / 87197 (the corpse's point is 87218's too)
Position const BlamWhelpCorpsePos   = { -7009.21f, -3344.54f, 241.687f };
Position const BlamWildEggPos       = { -7007.68f, -3341.68f, 241.719f };
Position const BlamNyxondrasEggPos  = { -7008.43f, -3337.17f, 241.738f };
float const EyeHoverHeight          = 3.0f;

// 46833 Eye of the Watchers, summoned by the player at the Return to Blam hand-in; runs the scene
struct npc_badlands_eye_of_the_watchers : public ScriptedAI
{
    npc_badlands_eye_of_the_watchers(Creature* creature) : ScriptedAI(creature) { }

    void IsSummonedBy(Unit* summoner) override
    {
        Player* player = summoner->ToPlayer();
        if (!player || player->GetSession()->IsBot())
        {
            _done = true;
            me->DespawnOrUnsummon();
            return;
        }

        _playerGUID = player->GetGUID();
        me->SetReactState(REACT_PASSIVE);
        me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_IMMUNE_TO_PC | UNIT_FLAG_IMMUNE_TO_NPC);
        me->SetCanFly(true);
        me->SetDisableGravity(true);
        DoCastSelf(SPELL_EYE_VISUAL, true);

        // The marker on the player and the corpse (his summon); the eggs are the Eye's, private to him through it
        player->CastSpell(player, SPELL_SUMMON_WHELP_CORPSE_AURA, true);
        // Duration -1 in the DBC: a scene frozen and unloaded with its grid (the player rode off) never reaches Finish, and the
        // marker would keep the camp's static egg hidden for the session. A minute covers the 52 s scene.
        if (Aura* marker = player->GetAura(SPELL_SUMMON_WHELP_CORPSE_AURA))
        {
            marker->SetMaxDuration(60 * IN_MILLISECONDS);
            marker->SetDuration(60 * IN_MILLISECONDS);
        }
        std::list<TempSummon*> corpses;
        player->GetSummons(corpses, NPC_SCALDING_WHELP_CORPSE);
        for (TempSummon* corpse : corpses)
            _actors.push_back(corpse->GetGUID());
        DoCastSelf(SPELL_SUMMON_WILD_EGG, true);
        DoCastSelf(SPELL_SUMMON_NYXONDRAS_EGG, true);

        me->GetMotionMaster()->MovePoint(0, me->GetPositionX(), me->GetPositionY(), me->GetPositionZ() + 2.0f, false);

        _events.ScheduleEvent(EVENT_EYE_BLAM, 1500);
        _events.ScheduleEvent(EVENT_EYE_BOOT_UP, 4000);
        _events.ScheduleEvent(EVENT_EYE_OBJECTIVE, 8000);
        _events.ScheduleEvent(EVENT_EYE_TO_CORPSE, 11000);
        _events.ScheduleEvent(EVENT_EYE_CORPSE, 14000);
        _events.ScheduleEvent(EVENT_EYE_TO_WILD_EGG, 20000);
        _events.ScheduleEvent(EVENT_EYE_WILD_EGG, 23000);
        _events.ScheduleEvent(EVENT_EYE_TO_NYXONDRAS_EGG, 28000);
        _events.ScheduleEvent(EVENT_EYE_NYXONDRAS_EGG, 31000);
        _events.ScheduleEvent(EVENT_EYE_REASSEMBLE, 36000);
        _events.ScheduleEvent(EVENT_EYE_VIABLE, 40000);
        _events.ScheduleEvent(EVENT_EYE_COMPLETE, 44000);
        _events.ScheduleEvent(EVENT_EYE_END, 52000);
    }

    void JustSummoned(Creature* summon) override
    {
        if (summon->GetEntry() == NPC_BLACK_DRAGON_CORRUPTION)
            ++_corruptions;
        _actors.push_back(summon->GetGUID());
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }

    // The player's logout or map change unsummons the Eye (his summon) without the scene's end
    void Unsummoned() override
    {
        Finish(false);
    }

    void UpdateAI(uint32 diff) override
    {
        if (_done)
            return;

        Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID);
        if (!player || !player->IsInMap(me))
        {
            Finish(true);
            return;
        }

        _events.Update(diff);
        while (uint32 eventId = _events.ExecuteEvent())
        {
            switch (eventId)
            {
                case EVENT_EYE_BLAM:
                    if (Creature* blam = me->FindNearestCreature(NPC_DR_HIERONYMUS_BLAM, 40.0f))
                        sCreatureTextMgr->SendChat(blam, SAY_BLAM_IT_IS_FLYING, player);
                    break;
                case EVENT_EYE_BOOT_UP:
                    Talk(SAY_EYE_BOOT_UP, player);
                    break;
                case EVENT_EYE_OBJECTIVE:
                    Talk(SAY_EYE_OBJECTIVE, player);
                    break;
                case EVENT_EYE_TO_CORPSE:
                    HoverOver(BlamWhelpCorpsePos);
                    break;
                case EVENT_EYE_CORPSE:
                    Talk(SAY_EYE_ANOMALY, player);
                    Corrupt(SPELL_SUMMON_CORRUPTION_1, BlamWhelpCorpsePos);
                    break;
                case EVENT_EYE_TO_WILD_EGG:
                    Talk(SAY_EYE_EXCISED, player);
                    HoverOver(BlamWildEggPos);
                    break;
                case EVENT_EYE_WILD_EGG:
                    Corrupt(SPELL_SUMMON_CORRUPTION_2, BlamWildEggPos);
                    break;
                case EVENT_EYE_TO_NYXONDRAS_EGG:
                    Talk(SAY_EYE_EXCISED, player);
                    HoverOver(BlamNyxondrasEggPos);
                    break;
                case EVENT_EYE_NYXONDRAS_EGG:
                    Corrupt(SPELL_SUMMON_CORRUPTION_3, BlamNyxondrasEggPos);
                    break;
                case EVENT_EYE_REASSEMBLE:
                    Talk(SAY_EYE_REASSEMBLE, player);
                    for (ObjectGuid const& guid : _actors)
                        if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                            if (actor->GetEntry() != NPC_BLACK_DRAGON_CORRUPTION)
                                actor->DespawnOrUnsummon();
                    DoCastSelf(SPELL_SUMMON_VIABLE_EGG, true);
                    break;
                case EVENT_EYE_VIABLE:
                    Talk(SAY_EYE_VIABLE, player);
                    break;
                case EVENT_EYE_COMPLETE:
                    Talk(SAY_EYE_COMPLETE, player);
                    // Off toward the Tomb of the Watchers, north-east of the camp
                    me->GetMotionMaster()->MovePoint(0, me->GetPositionX() + 25.0f, me->GetPositionY() - 25.0f, me->GetPositionZ() + 15.0f, false);
                    break;
                case EVENT_EYE_END:
                    Finish(true);
                    return;
                default:
                    break;
            }
        }
    }

private:
    void HoverOver(Position const& pos)
    {
        me->GetMotionMaster()->MovePoint(0, pos.GetPositionX(), pos.GetPositionY(), pos.GetPositionZ() + EyeHoverHeight, false);
    }

    // DEST_NEARBY_ENTRY picks the actor through the spell's conditions; if it found none, the smoke rises there all the same
    void Corrupt(uint32 spellId, Position const& pos)
    {
        uint32 before = _corruptions;
        DoCastSelf(spellId, true);
        if (_corruptions == before)
            me->SummonCreature(NPC_BLACK_DRAGON_CORRUPTION, pos, TEMPSUMMON_TIMED_DESPAWN, 6s, 0, me->GetPrivateObjectOwner());
    }

    // Everything of the scene goes; the marker goes last, so the camp's static egg shows where the summoned one stood
    void Finish(bool despawnSelf)
    {
        if (_done && despawnSelf)
            return;
        if (!_done)
        {
            _done = true;
            _events.Reset();
            for (ObjectGuid const& guid : _actors)
                if (Creature* actor = ObjectAccessor::GetCreature(*me, guid))
                    actor->DespawnOrUnsummon();
            _actors.clear();

            if (Player* player = ObjectAccessor::GetPlayer(*me, _playerGUID))
                if (player->IsInWorld() && !player->IsDuringRemoveFromWorld())
                    player->RemoveAurasDueToSpell(SPELL_SUMMON_WHELP_CORPSE_AURA);
        }
        if (despawnSelf)
            me->DespawnOrUnsummon();
    }

    EventMap _events;
    ObjectGuid _playerGUID;
    GuidVector _actors;
    uint32 _corruptions = 0;
    bool _done = false;
};

// 46826 Scalding Whelp Corpse, 46828 Wild Black Dragon Egg, 46829 Nyxondra's Egg: props of the scene. Faction 16 with no AI they
// would get AggressorAI and attack the player they belong to; IMMUNE_TO_PC does not stop that in this core.
struct npc_badlands_blam_scene_actor : public ScriptedAI
{
    npc_badlands_blam_scene_actor(Creature* creature) : ScriptedAI(creature)
    {
        me->SetReactState(REACT_PASSIVE);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    void UpdateAI(uint32 /*diff*/) override { }
};

// 46836 Black Dragon Corruption: the black smoke rising from a prop
struct npc_badlands_black_dragon_corruption : public ScriptedAI
{
    npc_badlands_black_dragon_corruption(Creature* creature) : ScriptedAI(creature)
    {
        me->SetReactState(REACT_PASSIVE);
    }

    void IsSummonedBy(Unit* /*summoner*/) override
    {
        DoCastSelf(SPELL_CORRUPTION_VISUAL, true);
        me->DespawnOrUnsummon(6000);
    }

    void AttackStart(Unit* /*who*/) override { }
    void MoveInLineOfSight(Unit* /*who*/) override { }
    void EnterEvadeMode(EvadeReason /*why*/) override { }
    void UpdateAI(uint32 /*diff*/) override { }
};

// 206374 Trove of the Watchers (The Titans' Trove 27912 / 27913 end here, Return to Blam 27794 / 27888 start here). TDB 4.4.2
// gives the chest GO_FLAG_INTERACT_COND, i.e. usable only by a player it has a quest for; this core never sends the
// GO_DYNFLAG_LO_ACTIVATE that lifts the flag for a quest giver object (GameObject::BuildValuesUpdate sets it for chests and
// goobers only), so the flag would close it to everyone. Ours instead: a player with nothing to take or hand in here gets no
// window (the empty gossip box it opened before); the hand cursor still shows.
struct go_badlands_trove_of_the_watchers : public GameObjectAI
{
    go_badlands_trove_of_the_watchers(GameObject* go) : GameObjectAI(go) { }

    bool OnGossipHello(Player* player, bool /*isUse*/) override
    {
        QuestGiverStatus status = player->GetQuestDialogStatus(me);
        return status == QuestGiverStatus::None || status == QuestGiverStatus::Future;
    }
};

void AddSC_badlands_titans()
{
    new creature_script<npc_badlands_wardens_game_controller>("npc_badlands_wardens_game_controller");
    new creature_script<npc_badlands_sentinels_game_start_pawn>("npc_badlands_sentinels_game_start_pawn");
    new creature_script<npc_badlands_titan_game_piece>("npc_badlands_titan_game_piece");
    RegisterGameObjectAI(go_badlands_titan_slab);
    RegisterGameObjectAI(go_badlands_trove_of_the_watchers);
    new creature_script<npc_badlands_eye_of_the_watchers>("npc_badlands_eye_of_the_watchers");
    new creature_script<npc_badlands_blam_scene_actor>("npc_badlands_blam_scene_actor");
    new creature_script<npc_badlands_black_dragon_corruption>("npc_badlands_black_dragon_corruption");
}
