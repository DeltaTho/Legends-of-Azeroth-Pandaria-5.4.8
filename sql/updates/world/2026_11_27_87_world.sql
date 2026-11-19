-- Durotar, Brewfest grounds below Orgrimmar: Brewmaster Tao <Pandaran Brews> and his booth, Brewfest only.
--
-- Sourced: TDB 12.1.0 spawns Tao 73914 (guid 850419, 1199.56,-4152.57,21.8075 o 2.48207) beside his booth (tent 209654,
-- six Pandaren Brews 211694, kitchen table 221481, three mugs 221482), all in event 24 = Brewfest (mop event 26);
-- warcraft.wiki.gg calls him a Brewfest vendor. His template (VerifiedBuild 18414), equipment set 1 and 10 vendor items
-- exist in mop, but no spawn; mop's booth (11 objects, the same set) stands about 7 yd west of retail's, with no event,
-- so an empty Pandaren tent with brews stood in the Brewfest field all year.
-- Ours: Tao's position. He is placed at retail's offset from the kitchen table (-1.39, +0.97 yd) applied to mop's table
-- 543324 (1194.04,-4150.72): 1192.65,-4149.75, 1.7 yd from the table and 1.6 yd from mug 543327, open field, terrain
-- z 21.60 (ground.py); retail's facing. Respawn 120 is the TDB value.

DELETE FROM `game_event_creature` WHERE `guid` = 3143401;
DELETE FROM `creature` WHERE `guid` = 3143401;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`,
  `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`,
  `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`,
  `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3143401, 73914, 1, 14, 14, 1, 1, 0, 0, 0, 1, 1192.65, -4149.75, 21.62, 2.48207, 120, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);
INSERT INTO `game_event_creature` (`eventEntry`, `guid`) VALUES (26, 3143401);

DELETE FROM `game_event_gameobject` WHERE `guid` IN (542448,542690,542692,542693,542696,542698,542699,543324,543327,543329,543331);
INSERT INTO `game_event_gameobject` (`eventEntry`, `guid`) VALUES
(26,542448),(26,542690),(26,542692),(26,542693),(26,542696),(26,542698),(26,542699),(26,543324),(26,543327),(26,543329),
(26,543331);
