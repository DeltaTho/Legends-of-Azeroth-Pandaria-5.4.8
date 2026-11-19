-- Valley of Trials: a Spirit Healer at the graveyard.
--
-- game_graveyard_zone sends Horde ghosts of zone 6451 to WorldSafeLocs 709 (-636.5,-4292.5,40.3), where no Spirit Healer
-- stood: a new character who died in the Valley found nobody to resurrect him and had to run back to his corpse.
-- Sourced, both TDBs: Spirit Healer 6491 at -637.971,-4295.86,40.9093 o 1.16937, respawn 300 (PhaseId 169, the phase
-- every player carries; here phaseMask 1 / phaseId 0, as mop's other Spirit Healers). Terrain z there is 40.53
-- (ground.py); the TDB z is kept. Nothing else stands within 10 yd.

DELETE FROM `creature` WHERE `guid` = 3143400;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`,
  `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`,
  `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`,
  `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3143400, 6491, 1, 6451, 363, 1, 1, 0, 0, 0, 0, -637.971, -4295.86, 40.9093, 1.16937, 300, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);
