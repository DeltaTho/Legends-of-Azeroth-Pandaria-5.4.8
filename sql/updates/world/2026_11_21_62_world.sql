-- Searing Gorge, Rasha'krak 28099: one Rasha'krak 47553, patrolling between the lava pools south of Thorium Point.
--
-- mop had two static spawns, 186485 (-6666.4, -1269.1) and 186637 (-6729.4, -1151.7), each wandering 3 yd. Both TDBs have one,
-- 359795 at (-6716.52, -1181.18, 241.089) on path 28783600: 20 nodes, out and back between (-6654, -1275) and (-6748, -1011).
-- Delete 186637; move 186485 to the TDB point (a patrol starts where the sniff has the creature) and give it the TDB path as
-- 1864850 (TDB 4.4.2 nodes are already 1-based; every node within 1.3 yd of the terrain, ground.py). Neither guid has a pool,
-- game event, linked respawn, formation or SmartAI of its own; 47553's SmartAI is in-combat casts only.
-- Sourced: one Rasha'krak on a patrol (47553 2011-04-01 [+8] "he cycles the way between the pools"; 28099 2011-07-15 [+10],
-- 2014-03-18 "his patrol brought him near me five times"), spawn point, path and the 120 s respawn (TDB 359795 / 28783600; mop
-- had 300 s, too long for the only one). Ours: none.

DELETE FROM `creature` WHERE `guid`=186637;
DELETE FROM `creature_addon` WHERE `guid` IN (186637,186485);
UPDATE `creature` SET `position_x`=-6716.52, `position_y`=-1181.18, `position_z`=241.089, `orientation`=5.35671, `spawntimesecs`=120, `MovementType`=2, `wander_distance`=0, `currentwaypoint`=0 WHERE `guid`=186485;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(186485,1864850,0,0,0,0,0,1,0,0,0,0,0,0,'');
DELETE FROM `waypoint_data` WHERE `id`=1864850;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(1864850,1,-6716.52,-1181.18,241.089,0,0,0,0,100,0),(1864850,2,-6708.34,-1203.88,241.384,0,0,0,0,100,0),
(1864850,3,-6683.96,-1240.97,243.005,0,0,0,0,100,0),(1864850,4,-6666.49,-1268.94,244.606,0,0,0,0,100,0),
(1864850,5,-6654.02,-1275.29,249.731,0,0,0,0,100,0),(1864850,6,-6666.38,-1269.14,243.949,0,0,0,0,100,0),
(1864850,7,-6683.96,-1240.97,243.005,0,0,0,0,100,0),(1864850,8,-6708.34,-1203.88,241.384,0,0,0,0,100,0),
(1864850,9,-6716.52,-1181.18,241.089,0,0,0,0,100,0),(1864850,10,-6733.22,-1137.64,249.745,0,0,0,0,100,0),
(1864850,11,-6745.31,-1119.27,245.825,0,0,0,0,100,0),(1864850,12,-6752.15,-1089.18,244.589,0,0,0,0,100,0),
(1864850,13,-6755.38,-1055.65,240.103,0,0,0,0,100,0),(1864850,14,-6755.26,-1024.71,237.896,0,0,0,0,100,0),
(1864850,15,-6747.73,-1010.96,237.8,0,0,0,0,100,0),(1864850,16,-6755.26,-1024.71,237.896,0,0,0,0,100,0),
(1864850,17,-6755.38,-1055.65,240.103,0,0,0,0,100,0),(1864850,18,-6752.14,-1089.16,244.724,0,0,0,0,100,0),
(1864850,19,-6745.31,-1118.75,245.825,0,0,0,0,100,0),(1864850,20,-6733.22,-1137.64,249.745,0,0,0,0,100,0);
