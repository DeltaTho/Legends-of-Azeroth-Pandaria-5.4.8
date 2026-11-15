-- Badlands: quest objects and mobs respawn as both TDBs have them, and the missing sniffed spawns are added (plan items C-10, C-11, C-18).
--
-- C-10 (27825 / 27879 Survival of the Fattest): the Dustbelch Grotto's hanging meat (206420, 206498) and chests (206499) respawned
--   in 300 s; both TDBs (4.4.2, 12.1.0): 120 s on every one of them. All 17 mop spawns of the three entries stand in the grotto
--   (area 347). Both TDBs also have three spawns mop lacks (more than 3 yd from any mop spawn of the three entries): one chest
--   and two meat. The TDBs stack a 206420 and a 206498 on several spots; one is enough, so -7484.66 -2276.06 gets one (206420),
--   as the dossier chose. Positions and rotations from TDB 1210 (equal in 4.4.2). The loot of the three is item A-19. Ground
--   re-measured with ground.py (vmaps): the chest 3130800 stands on a surface (z 241.19), the two meat hang 3.7 / 2.1 yd above
--   the floor (234.87 / 233.64) and 7-11 yd under the ceiling, as meat on chains does; none is buried.
-- C-11 (27833 / 27880 Half-Ton Holdouts): the 11 Dustbelcher Shamans 2718 (all in zone 3) respawned in 300 s, both TDBs have 120 s.
-- C-18 (27765 First Sample: Wild Eggs): the wild Black Dragon Eggs 206320 respawned in 300 s (both TDBs 120 s: all 14 mop spawns) and
--   the TDBs have seven spawns along the ravine that mop lacks (14 -> 21 eggs; mop's other 14 stand on 10 TDB spots and four
--   spots of their own, which stay). Guids 3130210-3130216, positions and rotations from the TDBs (equal in both), ground checked.
--   Nyxondra's eggs 206321 are not touched. The shorter respawns are the less grindy value, as the user's rule says.
-- Sourced: both TDBs. Ours: nothing but the guids. Spawn points of ours: none (all sniffed).

-- C-10
UPDATE `gameobject` SET `spawntimesecs` = 120 WHERE `id` IN (206420, 206498, 206499);
DELETE FROM `gameobject` WHERE `guid` BETWEEN 3130800 AND 3130802;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) VALUES
(3130800,206499,0,3,347,1,1,0,0,-7329.48,-2271.13,241.192,1.93731,0,0,0.824125,0.566409,120,100,1,'',0),
(3130801,206420,0,3,347,1,1,0,0,-7378.63,-2271.3,238.568,5.02655,0,0,0.587785,-0.809017,120,100,1,'',0),
(3130802,206420,0,3,347,1,1,0,0,-7484.66,-2276.06,235.771,3.61284,0,0,0.972369,-0.233449,120,100,1,'',0);

-- C-11
UPDATE `creature` SET `spawntimesecs` = 120 WHERE `id` = 2718;

-- C-18
DELETE FROM `gameobject` WHERE `guid` BETWEEN 3130210 AND 3130216;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) VALUES
(3130210,206320,0,3,339,1,1,0,0,-6660.87,-4134.09,266.638,0.575957,0,0,0.284015,0.95882,120,255,1,'',0),
(3130211,206320,0,3,339,1,1,0,0,-6951.61,-4083.64,264.03,0.575957,0,0,0.284015,0.95882,120,255,1,'',0),
(3130212,206320,0,3,339,1,1,0,0,-6946.85,-4025.74,264.474,0.575957,0,0,0.284015,0.95882,120,255,1,'',0),
(3130213,206320,0,3,339,1,1,0,0,-6727.05,-4020.61,264.007,0.575957,0,0,0.284015,0.95882,120,255,1,'',0),
(3130214,206320,0,3,339,1,1,0,0,-6766.35,-3987.41,265.711,0.575957,0,0,0.284015,0.95882,120,255,1,'',0),
(3130215,206320,0,3,339,1,1,0,0,-6858.3,-3885.4,263.891,0.575957,0,0,0.284015,0.95882,120,255,1,'',0),
(3130216,206320,0,3,339,1,1,0,0,-6853.07,-4165.91,269.86,0.575957,0,0,0.284015,0.95882,120,255,1,'',0);
UPDATE `gameobject` SET `spawntimesecs` = 120 WHERE `id` = 206320;
