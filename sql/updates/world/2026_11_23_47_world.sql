-- Swamp of Sorrows C (_47): Bogpaddle and Splinterspear Junction spawns (plan C-15..C-18; S1 dossier section 9, 27600 #7, H-2;
-- S4 H-3, F5-1; plan K6, K13, K14).
--
-- SOURCED: no TDB spawns Stray Land Mine Explosion Bunny 45842 (the mine's trap summons it); the beach chair 39308 165195 is idle
-- in both TDBs; both TDBs have the Splinterspear tower grunts idle.
-- OURS: the Fortune's Fist frigate (no TDB has its gilblins): four spots hold a Gilblin Tresspasser 45914 and a Gilblin Slasher
-- 45934 on identical coordinates; the Slasher of each pair goes (15 -> 11), and the 11 left stand still, since a 3-yd wander on
-- a three-deck ship walks them through the decks. The tower grunts stop wandering inside the tower (five spawns on four floors);
-- 166822 keeps its path (section D may script it).
-- Idempotent: DELETE, absolute UPDATEs.

-- C-15: static explosion bunnies (two statics, one in the open marsh)
DELETE FROM `creature_addon` WHERE `guid` IN (190470, 190471, 306447, 306452, 306453, 306455);
DELETE FROM `pool_creature` WHERE `guid` IN (190470, 190471, 306447, 306452, 306453, 306455);
DELETE FROM `game_event_creature` WHERE `guid` IN (190470, 190471, 306447, 306452, 306453, 306455);
DELETE FROM `creature_formations` WHERE `memberGUID` IN (190470, 190471, 306447, 306452, 306453, 306455) OR `leaderGUID` IN (190470, 190471, 306447, 306452, 306453, 306455);
DELETE FROM `linked_respawn` WHERE `guid` IN (190470, 190471, 306447, 306452, 306453, 306455) OR `linkedGuid` IN (190470, 190471, 306447, 306452, 306453, 306455);
DELETE FROM `creature_movement_override` WHERE `SpawnId` IN (190470, 190471, 306447, 306452, 306453, 306455);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (-190470, -190471, -306447, -306452, -306453, -306455);
DELETE FROM `creature` WHERE `id` = 45842 AND `guid` IN (190470, 190471);

-- C-16: the beach chair stays where it is
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 165195 AND `id` = 39308;

-- C-17: Fortune's Fist: one gilblin per spot, deck mobs idle
DELETE FROM `creature` WHERE `id` = 45934 AND `guid` IN (306447, 306452, 306453, 306455);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` IN (45914, 45934) AND `guid` IN (306441, 306442, 306443, 306444, 306445, 306446, 306448, 306449, 306450, 306451, 306454);

-- C-18: Splinterspear tower grunts idle (not 166822, the path walker)
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 866 AND `guid` IN (166780, 166823, 190202, 190555, 190877);
