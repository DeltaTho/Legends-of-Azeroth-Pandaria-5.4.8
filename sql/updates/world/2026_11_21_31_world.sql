-- Searing Gorge, C-2 + C-10: two spawns of the retail sniff that mop_world lacks.
-- C-2: Spirit Healer 6491 at the Dustfire graveyard (game_graveyard_zone 1847, WorldSafeLocs 1847); TDB spawn 359507, same
--      spot and orientation, phaseMask 1 like every other healer of the zone. Sourced.
-- C-10: Sitting Skeleton 01 (185434, displayId 7308 is in GameObjectDisplayInfo.dbc) at the Iron Summit; TDB 12.1.0 / 4.4.2
--      guid 3802927, same spot and rotation. Sourced.
-- Guids 3133000 (creature) and 3133500 (gameobject) are ours (plan range). Idempotent: DELETE + INSERT.

DELETE FROM `creature` WHERE `guid`=3133000;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3133000,6491,0,51,1959,1,1,0,0,0,0,-6558.31,-1959.74,247.225,1.0472,120,0,0,0,1,0,0,0,0,0,0,0,'',0,0);

DELETE FROM `gameobject` WHERE `guid`=3133500;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) VALUES
(3133500,185434,0,51,5628,1,1,0,0,-7122.82,-1188.2,308.281,4.46804,0,0,-0.788011,0.615662,120,255,1,'',0);
