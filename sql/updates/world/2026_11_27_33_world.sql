-- Injured Razor Hill Grunts (39270, Loss Reduction 25179): two spawns that no TDB has, and three TDB spots that mop lacked.
-- Out: 253292 (116.1,-4998.8) walked a 6-point loop for ever (path 253292) and 253297 (99.7,-4981.6) stood with a ready emote: neither TDB
-- has a grunt within 25 yd of either; they read as sniffs of rescued grunts walking away. Both were still quest givers and credit targets.
-- No formation, pool, event, linked respawn or guid SmartAI rows use them.
-- In: the three spots both TDBs (4.4.2 and 12.1.0) have and mop did not (103.444,-5063.67 / 51.0382,-5117.56 / 123.257,-5103.76), lying like
-- the other grunts (creature_addon StandState 7, aura 76143 Low Health, as mop's grunts; the TDBs pose them with 75511). Respawn 60 s, model
-- from the template and no equipment, as mop's other grunts; areaId from the nearest grunt (informational). 15 -> 16 grunts, as the TDBs.
DELETE FROM `creature_addon` WHERE `guid` IN (253292, 253297);
DELETE FROM `waypoint_data` WHERE `id` = 253292;
DELETE FROM `creature` WHERE `guid` IN (253292, 253297) AND `id` = 39270;
DELETE FROM `creature_addon` WHERE `guid` IN (3142600, 3142601, 3142602);
DELETE FROM `creature` WHERE `guid` IN (3142600, 3142601, 3142602);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3142600,39270,1,14,14,1,1,0,0,0,0,103.444,-5063.67,4.62673,0,60,0,0,0,156,0,0,0,0,0,0,0,'',0,0),
(3142601,39270,1,14,372,1,1,0,0,0,0,51.0382,-5117.56,1.1851,0,60,0,0,0,156,0,0,0,0,0,0,0,'',0,0),
(3142602,39270,1,14,14,1,1,0,0,0,0,123.257,-5103.76,2.80786,0,60,0,0,0,156,0,0,0,0,0,0,0,'',0,0);
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(3142600,0,0,0,7,0,0,1,0,0,0,0,0,0,'76143'),
(3142601,0,0,0,7,0,0,1,0,0,0,0,0,0,'76143'),
(3142602,0,0,0,7,0,0,1,0,0,0,0,0,0,'76143');
