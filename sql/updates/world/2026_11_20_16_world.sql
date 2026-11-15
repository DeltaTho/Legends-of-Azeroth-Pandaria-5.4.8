-- The Dustbowl: Kalaran the Annihilator 46859 (The Wrath of a Dragonflight 27829 / 27894) no longer despawns companions at his
-- death, starts at the sniffed spot and patrols the Dustbowl.
--
-- Death rows: LoA's own SmartAI ids 1-6 set data on every companion entry (46855-46857, 47021, 47022, 47024) within 100 yd when
--   he died, which despawned the trio of every player nearby, while the quest goes on with them (Their Hunt Continues). Removed
--   (ours removed; no source has it). His Flame Breath row 0 stays. The companions' own side of it is section G's (G-2).
-- Spawn: mop had him 46 yd off the sniff on a 4-point path 16 yd long; comments find him "hard to find" patrolling the Dustbowl
--   around 32,43 and Wowhead has 80 pins over 24-31 x 38-49. Sourced: the spawn point and facing (both TDBs, -6732.09 -2707.58
--   241.79, 6.206). Ours: the 8-point loop over the pin cloud (about 580 yd, walking), z from the server's map files, every leg
--   checked against vmap models with ground.py (the dossier's points 3 and 4-5 crossed two doodads / a tree; point 3 moved
--   7.5 yd and a point added between 4 and 5). Respawn 60 s (both TDBs 120: less grindy, kept).

DELETE FROM `smart_scripts` WHERE `entryorguid` = 46859 AND `source_type` = 0 AND `id` BETWEEN 1 AND 6;

UPDATE `creature` SET `position_x` = -6732.09, `position_y` = -2707.58, `position_z` = 241.79, `orientation` = 6.206, `MovementType` = 2, `wander_distance` = 0, `currentwaypoint` = 0 WHERE `guid` = 162493;

DELETE FROM `waypoint_data` WHERE `id` = 162493;
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `move_flag`, `action`, `action_chance`, `wpguid`) VALUES
(162493, 1, -6732.1, -2707.6, 241.7, 0, 0, 0, 0, 100, 0),
(162493, 2, -6672.5, -2761.9, 242.8, 0, 0, 0, 0, 100, 0),
(162493, 3, -6690.0, -2838.7, 242.4, 0, 0, 0, 0, 100, 0),
(162493, 4, -6785.0, -2838.7, 241.9, 0, 0, 0, 0, 100, 0),
(162493, 5, -6780.0, -2790.0, 242.2, 0, 0, 0, 0, 100, 0),
(162493, 6, -6836.2, -2761.9, 241.7, 0, 0, 0, 0, 100, 0),
(162493, 7, -6815.7, -2669.8, 241.9, 0, 0, 0, 0, 100, 0),
(162493, 8, -6754.4, -2654.4, 241.1, 0, 0, 0, 0, 100, 0);
