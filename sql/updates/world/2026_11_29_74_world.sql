-- Northern Barrens (zone 17), scope I-M: movement. Sourced: both TDBs (idle) and TDB 1210 waypoint_path_node for the Grunt paths.
-- A hand-off: Fallen Horde Assassin corpses 33295, Gorat's Target Bunny 33336 and Wounded Waypoint Bunnies 33267 stand still. By entry:
--   their spawns are map 1, zone 17 and 331 (the Ashenvale side of the border). 238110 (bunny 33336) STAYS where it is: it is the
--   target of Gorat's SET_DATA / S1's flare cast.
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id` IN (33295,33336,33267);
-- H hand-off: Tinkerer Sniggles stays in his hut.
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid`=264763 AND `id`=3471;
-- B hand-off: Halga Bloodeye 34258 stands at her sniffed spot (TDB 304092) instead of pacing a 5-point path. Her template and AI
--   are S2's; only the spawn row is here.
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid`=262339;
DELETE FROM `waypoint_data` WHERE `id`=262339;
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0, `position_x`=326.792, `position_y`=-3678.96, `position_z`=27.2174, `orientation`=4.90458 WHERE `guid`=262339 AND `id`=34258;
-- B hand-off (via E): Kranal Fiss 262817 on the sniffed spot (both TDBs 268.899,-3055.15 o 5.4895; mop 10 yd off).
UPDATE `creature` SET `position_x`=268.899, `position_y`=-3055.15, `position_z`=97.1642, `orientation`=5.48952 WHERE `guid`=262817 AND `id`=5907;
-- E hand-off: Grol'dom Grunts as TDB 1210: two stand (303767/303774), two pace their sniffed paths (24301280 / 24301760).
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid` IN (262323,262325) AND `id`=34504;
UPDATE `creature` SET `MovementType`=2, `wander_distance`=0 WHERE `guid` IN (262322,262348) AND `id`=34504;
INSERT INTO `creature_addon` (`guid`,`path_id`) VALUES (262322,262322),(262348,262348) ON DUPLICATE KEY UPDATE `path_id`=VALUES(`path_id`);
DELETE FROM `waypoint_data` WHERE `id` IN (262322,262348);
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(262322,1,205.273,-3050.23,91.9519,0,0,0,0,100,0),
(262322,2,202.491,-3040.96,91.7917,0,0,0,0,100,0),
(262348,1,164.17,-3050.72,91.8863,0,0,0,0,100,0),
(262348,2,164.17,-3051.72,91.8863,0,0,0,0,100,0),
(262348,3,164.17,-3052.97,91.8863,0,0,0,0,100,0),
(262348,4,162.42,-3053.47,91.8863,0,0,0,0,100,0),
(262348,5,161.42,-3053.47,91.8863,0,0,0,0,100,0),
(262348,6,160.42,-3053.47,91.8863,0,0,0,0,100,0),
(262348,7,159.42,-3051.72,91.8863,0,0,0,0,100,0),
(262348,8,159.42,-3049.72,91.8863,0,0,0,0,100,0),
(262348,9,158.67,-3048.72,91.8863,0,0,0,0,100,0),
(262348,10,156.42,-3045.47,91.8863,0,0,0,0,100,0),
(262348,11,154.17,-3041.72,92.6363,0,0,0,0,100,0),
(262348,12,153.92,-3040.22,91.8863,0,0,0,0,100,0),
(262348,13,153.42,-3037.47,91.8863,0,0,0,0,100,0),
(262348,14,155.15,-3043.82,92.082,0,0,0,0,100,0),
(262348,15,155.15,-3043.82,92.082,1.4993,5000,0,0,100,0),
(262348,16,156.443,-3045.95,91.9369,0,0,0,0,100,0),
(262348,17,158.693,-3048.7,91.9369,0,0,0,0,100,0),
(262348,18,159.693,-3049.7,91.9369,0,0,0,0,100,0),
(262348,19,159.693,-3051.95,91.9369,0,0,0,0,100,0),
(262348,20,160.443,-3053.45,91.9369,0,0,0,0,100,0),
(262348,21,161.443,-3053.45,91.9369,0,0,0,0,100,0),
(262348,22,162.443,-3053.45,91.9369,0,0,0,0,100,0),
(262348,23,163.443,-3053.45,91.9369,0,0,0,0,100,0),
(262348,24,163.943,-3051.95,91.9369,0,0,0,0,100,0),
(262348,25,163.943,-3050.7,91.9369,0,0,0,0,100,0),
(262348,26,163.943,-3049.7,91.9369,0,0,0,0,100,0),
(262348,27,165.73,-3057.62,92.7138,0,0,0,0,100,0),
(262348,28,165.98,-3059.62,93.2138,0,0,0,0,100,0),
(262348,29,165.98,-3058.87,92.7138,0,0,0,0,100,0),
(262348,30,165.48,-3055.87,92.4638,0,0,0,0,100,0),
(262348,31,165.681,-3047.9,92.0417,0,0,0,0,100,0),
(262348,32,164.931,-3049.15,92.0417,0,0,0,0,100,0),
(262348,33,167.29,-3047.93,91.7917,0,0,0,0,100,0),
(262348,34,169.482,-3054.18,91.939,0,0,0,0,100,0),
(262348,35,164.237,-3049.08,91.7917,2.72604,5000,0,0,100,0);
-- G hand-off: Mad Magglish 264192 and Lieutenant Buckland 265640 on their sniffed spots (both TDBs; mop 140 yd / 51 yd off, wandering).
UPDATE `creature` SET `position_x`=-783.69, `position_y`=-2086.97, `position_z`=75.2252, `orientation`=3.1446, `MovementType`=0, `wander_distance`=0 WHERE `guid`=264192 AND `id`=3655;
UPDATE `creature` SET `position_x`=-1436.18, `position_y`=-3870.82, `position_z`=14.4014, `orientation`=4.50295, `MovementType`=0, `wander_distance`=0 WHERE `guid`=265640 AND `id`=34753;
-- C hand-off H-4 and the other wandering bunnies (34280 barn fires, 34346/34527 ILM bunnies, 34641 stalkers, 26355 bonfire bunny).
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `zoneId`=17 AND `MovementType`=1 AND `id` IN (34280,34346,34527,34641,26355);
