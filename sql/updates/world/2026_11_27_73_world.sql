-- Durotar: Ignoring the Warnings (25206) needs 12 Warring Elementals; both TDBs have 28 Furious Earthguards 39595 and 28 Teeming
-- Waterguards 39596, mop 25 + 25. Three of mop's pairs (250973/250974, 250975/250976, 251048/251049) are the TDB pairs
-- 309981/309982, 309988/309989 and 309992/309993 displaced by 9-35 yd (two with the identical orientations), so those are not
-- added again. The other three of each are missing (TDB 12.1.0 and 4.4.2 304179 304184 304193 / 304191 304192 304194, north of
-- Thunder Ridge; no mop elemental within 8 yd of any) and are added at the TDB positions, idle as every TDB elemental.
-- Ours: respawn 60 s (TDB 120 s; mop's Waterguards have 60 s; the less grindy value). Overturned from the draft: its other six
-- spawns (3143106-3143108, 3143112-3143114) would have doubled the three displaced pairs.
-- Guids from the Durotar section 4 range.

DELETE FROM `creature` WHERE `guid` BETWEEN 3143106 AND 3143117;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`, `equipment_id`,
 `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`, `wander_distance`, `currentwaypoint`,
 `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`, `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3143109, 39595, 1, 14, 14, 1, 1, 0, 0, 0, 0, 914.909, -3866.09, 19.706, 4.37829, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143110, 39595, 1, 14, 14, 1, 1, 0, 0, 0, 0, 939.156, -3869.25, 18.7395, 3.32826, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143111, 39595, 1, 14, 14, 1, 1, 0, 0, 0, 0, 895.887, -3894.8, 21.7408, 2.98593, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143115, 39596, 1, 14, 14, 1, 1, 0, 0, 0, 0, 927.984, -3870.43, 19.0804, 3.40622, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143116, 39596, 1, 14, 14, 1, 1, 0, 0, 0, 0, 904.432, -3879.84, 21.4116, 3.03783, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143117, 39596, 1, 14, 14, 1, 1, 0, 0, 0, 0, 903.344, -3904.5, 20.9366, 2.20292, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);
