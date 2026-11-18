-- Blasted Lands (zone 4): the second Monstrous Crawler of The Forbidding Sea (section F, Part A3).
-- Sourced: TDB 4.4.2 / 12.1.0 guid 301152 (-11250.8,-3915.94,-23.6321), the entry's second TDB spawn in the zone; mop has one.
--   Sea floor: terrain -23.75 at that point (ground.py). Wander 3 / MovementType 1 / 300 s as the entry's other spawns in mop.
-- Ours: guid 3139200 (section F's range 3139200-3139999).

DELETE FROM `creature` WHERE `guid`=3139200;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`VerifiedBuild`) VALUES
(3139200,1088,0,4,5096,1,1,0,0,-11250.8,-3915.94,-23.6321,6.14115,300,3,0,2453,0,1,0); -- TDB 1210 guid 301152 (Monstrous Crawler)
