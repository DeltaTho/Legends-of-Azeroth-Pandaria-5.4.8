-- Swamp of Sorrows C (_46): the five Scattered Crates of a retired quest (plan C-14; S4 dossier F1423-1, S4-E).
--
-- SOURCED: neither TDB spawns Scattered Crate 28604; each crate drops Lost Supplies 6172 at 100 %, which starts The Lost
-- Supplies 1423, marked obsolete (Wowhead: "cannot be obtained or completed") and without an ender here, so a player could pick
-- up a quest that can never be handed in. No pool, event or addon row references them.
-- Idempotent: DELETE.

DELETE FROM `gameobject_addon` WHERE `guid` IN (13276, 25726, 25727, 25728, 25729);
DELETE FROM `pool_gameobject` WHERE `guid` IN (13276, 25726, 25727, 25728, 25729);
DELETE FROM `game_event_gameobject` WHERE `guid` IN (13276, 25726, 25727, 25728, 25729);
DELETE FROM `gameobject` WHERE `id` = 28604 AND `guid` IN (13276, 25726, 25727, 25728, 25729);
