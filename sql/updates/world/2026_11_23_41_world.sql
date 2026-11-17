-- Swamp of Sorrows C (_41): eight TDB spawn points that no local spawn of the entry matched (plan C-04; S5 dossier 3 Part A3;
-- the greedy nearest-first match up to 40 yd: three of them have a local spawn of the entry 11-31 yd away, which matched another
-- TDB spot).
--
-- SOURCED: positions and orientations from TDB 12.1.0 (guids in the comments); ground checked by S5 with ground.py (crawlers and
-- striders within 0.2 yd of the terrain; the two Sawfin Frenzies swim 5-12 yd above the sea floor as the fish do).
-- OURS: spawntimesecs / wander / MovementType copied from the entry's most common local row (TDB 120 s is not a retail timer).
-- Guids 3137200-3137207 (section C's block).
-- Idempotent: DELETE + INSERT.

DELETE FROM `creature` WHERE `guid` BETWEEN 3137200 AND 3137207;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`VerifiedBuild`) VALUES
(3137200,922,0,8,300,1,1,0,0,-9964.3,-4300.48,-1.86305,1.10711,300,3,0,1,0,1,0), -- TDB 1210 guid 293524 (Silt Crawler)
(3137201,1088,0,8,300,1,1,0,0,-10712.6,-4453.73,-19.1026,5.53953,300,3,0,1,0,1,0), -- TDB 1210 guid 292621 (Monstrous Crawler)
(3137202,1088,0,8,300,1,1,0,0,-10859.2,-4259.97,-8.71814,0.412075,300,3,0,1,0,1,0), -- TDB 1210 guid 292628 (Monstrous Crawler)
(3137203,1088,0,8,300,1,1,0,0,-10860.3,-4402.05,-27.5466,3.34119,300,3,0,1,0,1,0), -- TDB 1210 guid 292634 (Monstrous Crawler)
(3137204,14356,0,8,300,1,1,0,0,-9722.28,-4077.51,-6.8886,0.00971238,300,3,0,1,0,1,0), -- TDB 1210 guid 293573 (Sawfin Frenzy)
(3137205,14356,0,8,300,1,1,0,0,-9652.85,-3950.83,-7.80483,1.54507,300,3,0,1,0,1,0), -- TDB 1210 guid 293612 (Sawfin Frenzy)
(3137206,45825,0,8,300,1,1,0,0,-9960.98,-4182.23,23.1776,6.19053,300,3,0,1,0,1,0), -- TDB 1210 guid 293534 (Swampstrider)
(3137207,45825,0,8,8,1,1,0,0,-9944.77,-4138.18,23.2586,1.15514,300,3,0,1,0,1,0); -- TDB 1210 guid 293538 (Swampstrider)
