-- Durotar, Thunder Ridge lake: Thunder Down Under (25236) needs 8 Drowned Thunder Lizards 39464; mop had 13 of the 19 the sniff
-- has (TDB 12.1.0 309908 309911 309912 309913 309918 309926, the same six in 4.4.2; Wowhead MoP Classic pins 19). The six are
-- added at the TDB positions. The nearest existing lizard is 24 yd from any of them, so no two lizards stand within 16 yd of each
-- other (their Lightning Discharge reaches 8 yd).
-- Ours: respawn 60 s as mop's other lizards (TDB 120 s; the less grindy value). Movement idle as every lizard (posed dead).
-- Guids from the Durotar section 4 range 3143100-3143399.

DELETE FROM `creature` WHERE `guid` BETWEEN 3143100 AND 3143105;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`, `equipment_id`,
 `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`, `wander_distance`, `currentwaypoint`,
 `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`, `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3143100, 39464, 1, 14, 369, 1, 1, 0, 0, 0, 0, 758.122, -4104.22, -4.78993, 2.04204, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143101, 39464, 1, 14, 369, 1, 1, 0, 0, 0, 0, 818.233, -4090.59, -8.59201, 5.93412, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143102, 39464, 1, 14, 369, 1, 1, 0, 0, 0, 0, 814.505, -4039.33, -8.04167, 1.58825, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143103, 39464, 1, 14, 369, 1, 1, 0, 0, 0, 0, 821.962, -4062.08, -8.82292, 2.44346, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143104, 39464, 1, 14, 369, 1, 1, 0, 0, 0, 0, 858.227, -4051.76, -5.16146, 1.23918, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0),
(3143105, 39464, 1, 14, 369, 1, 1, 0, 0, 0, 0, 927.391, -4052.13, -13.0347, 1.23918, 60, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);
