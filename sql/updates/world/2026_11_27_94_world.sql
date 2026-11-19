-- Razor Hill: Shifty <Battle Pet> beside his trainer Narzak.
--
-- Sourced: TDB 12.1.0 spawns 63063 Shifty (guid 395093) at 352.767,-4751.5,12.6809 o 2.92846, 1.7 yd from Narzak (TDB
-- 395092); mop has the 5.4.8 template (VerifiedBuild 18414) and Narzak (563962, 0.9 yd from the TDB spot) but no Shifty.
-- The TDB spot is 1.3 yd from mop's Narzak, on open ground (terrain z 12.60, ground.py). Respawn 120 is the TDB value.

DELETE FROM `creature` WHERE `guid` = 3143402;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`,
  `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`,
  `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`,
  `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3143402, 63063, 1, 14, 362, 1, 1, 0, 0, 0, 0, 352.767, -4751.5, 12.6809, 2.92846, 120, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);
