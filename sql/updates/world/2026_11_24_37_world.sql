-- Blasted Lands: five Oath-Chained Infernals 41253 at their sniffed spots (The Vile Blood of Demons 25692 / 26165; Jarroc's
-- hillside "protected by Oath-Chained Infernals", Protecting Our Rear 25694 / 26173).
-- Sourced: both TDBs (guids 300442, 300443, 300444, 300446 and 301599, idle) have 19 infernals in the zone, mop 14; these five
-- are the TDB spots with no local spawn within 20 yd (four round the TDB's second Jarroc point, one near 47.7, 40.6).
-- Ours: the respawn time (300 s, as mop's other 41253 spawns). Guids 3138400-3138404 (section C's range).
DELETE FROM `creature` WHERE `guid` BETWEEN 3138400 AND 3138404;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3138400,41253,0,4,4,1,1,0,0,0,0,-11695.2,-2818.36,5.21199,0.828219,300,0,0,0,0,0,0,0,0,0,0,0,'',0,0),
(3138401,41253,0,4,4,1,1,0,0,0,0,-11695.0,-2829.79,2.16959,0.726106,300,0,0,0,0,0,0,0,0,0,0,0,'',0,0),
(3138402,41253,0,4,4,1,1,0,0,0,0,-11686.6,-2826.05,3.16758,5.32855,300,0,0,0,0,0,0,0,0,0,0,0,'',0,0),
(3138403,41253,0,4,4,1,1,0,0,0,0,-11696.2,-2828.97,2.01816,0.54827,300,0,0,0,0,0,0,0,0,0,0,0,'',0,0),
(3138404,41253,0,4,4,1,1,0,0,0,0,-11677.2,-2953.38,8.86107,1.95984,300,0,0,0,0,0,0,0,0,0,0,0,'',0,0);
