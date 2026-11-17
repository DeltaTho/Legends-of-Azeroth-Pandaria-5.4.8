-- Burning Steppes (zone 46), spawn layout 2/4: the 94 retail spawns that had no local partner, and 231 kept spawns moved onto
-- their retail partner's spot (more than 5 yd away; spreads the Fields of Honor crowds, Othana 166157 into the kennel: plan K3).
--
-- Sourced: positions and facing from the TDB 1210.26091 rows named per line; no TDB creature_addon row exists for any of the 94,
-- so they get none (plan C-12: the 20 new Black Tooth Hovel orcs stand plain, as retail). Ours: spawntimesecs, wander distance and
-- MovementType copied from the entry's most common kept local spawn (the TDB has 120 s / idle for every sniffed row; mop's zone uses
-- 60-300 s and 3 yd wander), so the new rows behave as their neighbours. Moved spawns have no path, formation or own SmartAI.
-- equipment_id 0 as every kept spawn of these entries (0 loads equipment set 1 where the entry has one). Guids 3135200-3135293
-- (section C range 3135200-3135599).

DELETE FROM `creature_addon` WHERE `guid` BETWEEN 3135200 AND 3135599;
DELETE FROM `creature` WHERE `guid` BETWEEN 3135200 AND 3135599;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`VerifiedBuild`) VALUES
(3135200,7025,0,46,5653,1,1,0,0,-7694.44,-1721.35,132.211,4.86895,60,0,0,1,0,0,0), -- TDB 1210 guid 289392
(3135201,7025,0,46,5653,1,1,0,0,-7731.18,-1647.26,132.132,2.64562,60,0,0,1,0,0,0), -- TDB 1210 guid 289399
(3135202,7025,0,46,5653,1,1,0,0,-7808.06,-1543.74,133.511,1.28384,60,0,0,1,0,0,0), -- TDB 1210 guid 289429
(3135203,7025,0,46,5653,1,1,0,0,-7812.22,-1603.94,132.924,0.891657,60,0,0,1,0,0,0), -- TDB 1210 guid 289436
(3135204,7025,0,46,5653,1,1,0,0,-7741.98,-1511.51,131.898,2.0851,60,0,0,1,0,0,0), -- TDB 1210 guid 289502
(3135205,7025,0,46,5653,1,1,0,0,-7825.45,-1523.64,134.607,3.70235,60,0,0,1,0,0,0), -- TDB 1210 guid 289543
(3135206,7026,0,46,5652,1,1,0,0,-8068.69,-1754.7,132.134,3.29867,300,3,0,1,0,1,0), -- TDB 1210 guid 289412
(3135207,7026,0,46,5652,1,1,0,0,-8076.14,-1760.38,132.061,4.72984,300,3,0,1,0,1,0), -- TDB 1210 guid 289413
(3135208,7026,0,46,5652,1,1,0,0,-8056.11,-1599.22,138.387,0.751568,300,3,0,1,0,1,0), -- TDB 1210 guid 289546
(3135209,7026,0,46,5652,1,1,0,0,-8079.13,-1695.11,131.614,1.25078,300,3,0,1,0,1,0), -- TDB 1210 guid 289552
(3135210,7026,0,46,5652,1,1,0,0,-8112.71,-1683.21,131.782,3.84133,300,3,0,1,0,1,0), -- TDB 1210 guid 289556
(3135211,7026,0,46,5652,1,1,0,0,-8101.96,-1399.52,131.013,6.17846,300,3,0,1,0,1,0), -- TDB 1210 guid 289611
(3135212,7026,0,46,5652,1,1,0,0,-8098.04,-1397.9,131.014,3.9619,300,3,0,1,0,1,0), -- TDB 1210 guid 289612
(3135213,7027,0,46,5652,1,1,0,0,-8141.56,-1922.9,132.962,6.08332,300,3,0,1,0,1,0), -- TDB 1210 guid 289286
(3135214,7027,0,46,5652,1,1,0,0,-8117.05,-1622.49,133.264,5.10613,300,3,0,1,0,1,0), -- TDB 1210 guid 289578
(3135215,7027,0,46,5652,1,1,0,0,-8138.63,-1642.84,133.134,5.1508,300,3,0,1,0,1,0), -- TDB 1210 guid 289579
(3135216,7027,0,46,5652,1,1,0,0,-8216.72,-1582.82,142.626,4.54174,300,3,0,1,0,1,0), -- TDB 1210 guid 289586
(3135217,7027,0,46,5652,1,1,0,0,-8166.74,-1562.09,133.418,4.86947,300,3,0,1,0,1,0), -- TDB 1210 guid 289591
(3135218,7031,0,46,254,1,1,0,0,-7889.21,-916.925,132.023,0.785334,300,3,0,1,0,1,0), -- TDB 1210 guid 289695
(3135219,7031,0,46,254,1,1,0,0,-7890.99,-920.883,131.606,1.07659,300,3,0,1,0,1,0), -- TDB 1210 guid 289696
(3135220,7034,0,46,249,1,1,0,0,-7847.01,-2593.85,211.304,5.20207,60,3,0,1,0,1,0), -- TDB 1210 guid 288975
(3135221,7034,0,46,249,1,1,0,0,-7709.21,-2558.77,150.46,1.00392,60,3,0,1,0,1,0), -- TDB 1210 guid 288979
(3135222,7034,0,46,249,1,1,0,0,-7716.65,-2573.98,157.334,3.38302,60,3,0,1,0,1,0), -- TDB 1210 guid 288980
(3135223,7035,0,46,249,1,1,0,0,-7994.65,-2737.68,164.487,1.79395,60,3,0,1,0,1,0), -- TDB 1210 guid 288830
(3135224,7035,0,46,249,1,1,0,0,-7944.26,-2744.4,158.425,0.747239,60,3,0,1,0,1,0), -- TDB 1210 guid 288831
(3135225,7035,0,46,249,1,1,0,0,-8048.99,-2722.13,152.43,3.2434,60,3,0,1,0,1,0), -- TDB 1210 guid 288834
(3135226,7036,0,46,250,1,1,0,0,-7775.73,-2326.94,134.045,3.88553,300,3,0,1,0,1,0), -- TDB 1210 guid 289096
(3135227,7036,0,46,250,1,1,0,0,-7846.71,-2178.66,133.439,2.91993,300,3,0,1,0,1,0), -- TDB 1210 guid 289217
(3135228,7036,0,46,250,1,1,0,0,-7811.29,-2182.5,133.482,5.25777,300,3,0,1,0,1,0), -- TDB 1210 guid 289218
(3135229,7036,0,46,250,1,1,0,0,-7855.01,-2055.41,135.23,4.66574,300,3,0,1,0,1,0), -- TDB 1210 guid 289268
(3135230,7036,0,46,250,1,1,0,0,-7708.04,-1941.67,136.529,2.74153,300,3,0,1,0,1,0), -- TDB 1210 guid 289309
(3135231,7036,0,46,250,1,1,0,0,-7792.76,-1940.39,133.78,3.26946,300,3,0,1,0,1,0), -- TDB 1210 guid 289312
(3135232,7036,0,46,250,1,1,0,0,-7817.86,-1829.91,133.528,6.03799,300,3,0,1,0,1,0), -- TDB 1210 guid 289357
(3135233,7037,0,46,250,1,1,0,0,-7736.49,-2355.46,136.35,4.33286,300,3,0,1,0,1,0), -- TDB 1210 guid 289068
(3135234,7037,0,46,250,1,1,0,0,-7808.63,-2107.88,133.523,5.49549,300,3,0,1,0,1,0), -- TDB 1210 guid 289247
(3135235,7037,0,46,250,1,1,0,0,-7785.79,-2117.26,133.473,3.89261,300,3,0,1,0,1,0), -- TDB 1210 guid 289248
(3135236,7037,0,46,250,1,1,0,0,-7828.61,-2087.86,133.466,5.60682,300,3,0,1,0,1,0), -- TDB 1210 guid 289249
(3135237,7037,0,46,250,1,1,0,0,-7757.46,-2065.04,133.564,3.61313,300,3,0,1,0,1,0), -- TDB 1210 guid 289263
(3135238,7038,0,46,250,1,1,0,0,-7726.82,-2151.22,128.973,5.62772,60,3,0,1,0,1,0), -- TDB 1210 guid 289235
(3135239,7038,0,46,250,1,1,0,0,-7743.79,-1910.28,133.564,2.56789,60,3,0,1,0,1,0), -- TDB 1210 guid 289310
(3135240,7038,0,46,250,1,1,0,0,-7757.73,-1891.57,133.564,3.298,60,3,0,1,0,1,0), -- TDB 1210 guid 289330
(3135241,7038,0,46,250,1,1,0,0,-7741.49,-1842.94,133.696,5.07664,60,3,0,1,0,1,0), -- TDB 1210 guid 289339
(3135242,7039,0,46,250,1,1,0,0,-7889.22,-2234.11,133.531,0.0139926,300,3,0,1,0,1,0), -- TDB 1210 guid 289097
(3135243,7039,0,46,250,1,1,0,0,-7767.26,-2292.66,133.706,5.06375,300,3,0,1,0,1,0), -- TDB 1210 guid 289200
(3135244,7039,0,46,250,1,1,0,0,-7733.52,-2200.76,133.454,1.27459,300,3,0,1,0,1,0), -- TDB 1210 guid 289223
(3135245,7039,0,46,250,1,1,0,0,-7860.31,-2035.59,136.197,0.848588,300,3,0,1,0,1,0), -- TDB 1210 guid 289266
(3135246,7040,0,46,2420,1,1,0,0,-8072.32,-2871.47,139.372,3.19087,60,3,0,1,0,1,0), -- TDB 1210 guid 288730
(3135247,7040,0,46,5677,1,1,0,0,-8192.04,-2670.39,135.122,4.95353,60,3,0,1,0,1,0), -- TDB 1210 guid 288738
(3135248,7040,0,46,2420,1,1,0,0,-7835.91,-2868.84,133.555,1.6775,60,3,0,1,0,1,0), -- TDB 1210 guid 288752
(3135249,7040,0,46,2420,1,1,0,0,-7670.22,-2908.57,133.628,1.18935,60,3,0,1,0,1,0), -- TDB 1210 guid 288760
(3135250,7040,0,46,2420,1,1,0,0,-7715.92,-2912.14,133.553,2.58802,60,3,0,1,0,1,0), -- TDB 1210 guid 288762
(3135251,7040,0,46,2420,1,1,0,0,-7844.69,-2844.5,133.564,3.96527,60,3,0,1,0,1,0), -- TDB 1210 guid 288776
(3135252,7040,0,46,5677,1,1,0,0,-8215.3,-2481.83,135.482,5.27927,60,3,0,1,0,1,0), -- TDB 1210 guid 288993
(3135253,7040,0,46,5677,1,1,0,0,-8193.24,-2460.37,131.783,0.149668,60,3,0,1,0,1,0), -- TDB 1210 guid 288995
(3135254,7040,0,46,5677,1,1,0,0,-8170.04,-2490.77,142.567,0.548457,60,3,0,1,0,1,0), -- TDB 1210 guid 288997
(3135255,7041,0,46,2420,1,1,0,0,-7612.35,-2924.75,133.072,5.75689,60,3,0,1,0,1,0), -- TDB 1210 guid 288770
(3135256,7041,0,46,5677,1,1,0,0,-8246.25,-2575.88,136.317,2.09609,60,3,0,1,0,1,0), -- TDB 1210 guid 288808
(3135257,7041,0,46,2420,1,1,0,0,-7640.04,-2756.94,132.927,1.35219,60,3,0,1,0,1,0), -- TDB 1210 guid 288841
(3135258,7041,0,46,2420,1,1,0,0,-7638.01,-2817.71,133.346,1.31089,60,3,0,1,0,1,0), -- TDB 1210 guid 288842
(3135259,7041,0,46,2420,1,1,0,0,-7563.52,-2798.99,141.622,3.43668,60,3,0,1,0,1,0), -- TDB 1210 guid 288846
(3135260,7041,0,46,2420,1,1,0,0,-7613.81,-2686.73,133.557,1.15248,60,3,0,1,0,1,0), -- TDB 1210 guid 288956
(3135261,9690,0,46,46,1,1,0,0,-7810.56,-615.61,205.863,0.140826,300,3,0,1,0,1,0), -- TDB 1210 guid 289779
(3135262,9697,0,46,2417,1,1,0,0,-8308.52,-2595.74,141.112,5.23807,300,3,0,1,0,1,0), -- TDB 1210 guid 288872
(3135263,9697,0,46,249,1,1,0,0,-7596.78,-2512.74,133.471,0.245264,300,3,0,1,0,1,0), -- TDB 1210 guid 289020
(3135264,9778,0,46,250,1,1,0,0,-7723.65,-2153.66,129.134,2.48613,300,3,0,1,0,1,0), -- TDB 1210 guid 289236
(3135265,47782,0,46,5650,1,1,0,0,-8373.48,-910.108,214.113,1.89338,60,3,0,1,0,1,0), -- TDB 1210 guid 289710
(3135266,47782,0,46,5650,1,1,0,0,-8226.28,-990.837,142.708,2.77449,60,3,0,1,0,1,0), -- TDB 1210 guid 289738
(3135267,48118,0,46,5652,1,1,0,0,-8077.5,-1855.87,140.355,5.31012,300,3,0,1,0,1,0), -- TDB 1210 guid 289342
(3135268,48118,0,46,5652,1,1,0,0,-8188.86,-1802.58,136.02,0.00585931,300,3,0,1,0,1,0), -- TDB 1210 guid 289348
(3135269,48118,0,46,5652,1,1,0,0,-8094.71,-1745.61,133.342,4.28306,300,3,0,1,0,1,0), -- TDB 1210 guid 289418
(3135270,48118,0,46,5652,1,1,0,0,-8072.76,-1716.08,132.032,2.9924,300,3,0,1,0,1,0), -- TDB 1210 guid 289553
(3135271,48118,0,46,5652,1,1,0,0,-8140.26,-1584.27,133.968,4.10563,300,3,0,1,0,1,0), -- TDB 1210 guid 289588
(3135272,48118,0,46,5652,1,1,0,0,-8109.87,-1516.27,133.295,0.361331,300,3,0,1,0,1,0), -- TDB 1210 guid 289598
(3135273,48119,0,46,5653,1,1,0,0,-7759.58,-1765.38,132.297,3.56367,300,0,0,1,0,0,0), -- TDB 1210 guid 289365
(3135274,48119,0,46,5653,1,1,0,0,-7681.25,-1605.5,133.273,3.71985,300,0,0,1,0,0,0), -- TDB 1210 guid 289439
(3135275,48119,0,46,5653,1,1,0,0,-7713.11,-1599.16,131.445,0.872665,300,0,0,1,0,0,0), -- TDB 1210 guid 289448
(3135276,48119,0,46,5653,1,1,0,0,-7752.96,-1558.45,132.014,2.05949,300,0,0,1,0,0,0), -- TDB 1210 guid 289485
(3135277,48119,0,46,5653,1,1,0,0,-7758.46,-1550.43,132.642,2.05949,300,0,0,1,0,0,0), -- TDB 1210 guid 289488
(3135278,48119,0,46,5653,1,1,0,0,-7754.68,-1555.6,132.319,2.05949,300,0,0,1,0,0,0), -- TDB 1210 guid 289489
(3135279,48120,0,46,5652,1,1,0,0,-8139.56,-1714.19,137.784,3.37615,300,3,0,1,0,1,0), -- TDB 1210 guid 289560
(3135280,48120,0,46,5652,1,1,0,0,-8193.01,-1527.91,139.361,3.79526,300,3,0,1,0,1,0), -- TDB 1210 guid 289602
(3135281,48121,0,46,5653,1,1,0,0,-7718.58,-1587.3,132.906,0.872665,300,3,0,1,0,1,0), -- TDB 1210 guid 289475
(3135282,48121,0,46,5653,1,1,0,0,-7761.86,-1552.46,132.444,2.05949,300,3,0,1,0,1,0), -- TDB 1210 guid 289478
(3135283,48121,0,46,5653,1,1,0,0,-7718.27,-1528.89,134.439,1.55334,300,3,0,1,0,1,0), -- TDB 1210 guid 289524
(3135284,48121,0,46,5653,1,1,0,0,-7725.2,-1528.75,134.387,1.55334,300,3,0,1,0,1,0), -- TDB 1210 guid 289525
(3135285,48201,0,46,5653,1,1,0,0,-7734.75,-1674.75,130.645,4.68175,300,0,0,1,0,0,0), -- TDB 1210 guid 289395
(3135286,48201,0,46,5653,1,1,0,0,-7703.88,-1589.79,132.093,0.988656,300,0,0,1,0,0,0), -- TDB 1210 guid 289482
(3135287,48201,0,46,252,1,1,0,0,-7711.24,-1415.17,140.68,0.48085,300,0,0,1,0,0,0), -- TDB 1210 guid 289536
(3135288,48201,0,46,5653,1,1,0,0,-7734.71,-1500.78,132.615,4.41568,300,0,0,1,0,0,0), -- TDB 1210 guid 289538
(3135289,48413,0,46,2420,1,1,0,0,-7886.75,-2771.95,164.972,2.30155,300,3,0,1,0,1,0), -- TDB 1210 guid 288825
(3135290,48413,0,46,5656,1,1,0,0,-7934.04,-2668.81,158.382,6.2583,300,3,0,1,0,1,0), -- TDB 1210 guid 288920
(3135291,48413,0,46,5656,1,1,0,0,-7800.52,-2654.07,173.645,6.14076,300,3,0,1,0,1,0), -- TDB 1210 guid 288946
(3135292,48413,0,46,249,1,1,0,0,-7820.22,-2559.08,187.371,0.453158,300,3,0,1,0,1,0), -- TDB 1210 guid 288984
(3135293,48413,0,46,249,1,1,0,0,-7778.44,-2480.23,155.191,5.79938,300,3,0,1,0,1,0); -- TDB 1210 guid 289030

UPDATE `creature` SET `position_x`=-7810.86,`position_y`=-2822.21,`position_z`=133.564,`orientation`=4.73937 WHERE `guid`=166272 AND `id`=7040; -- TDB 288824, 11.7 yd
UPDATE `creature` SET `position_x`=-8286.7,`position_y`=-2511.68,`position_z`=138.629,`orientation`=4.77396 WHERE `guid`=166344 AND `id`=7040; -- TDB 289000, 5.5 yd
UPDATE `creature` SET `position_x`=-7544.77,`position_y`=-2816.22,`position_z`=153.668,`orientation`=4.75533 WHERE `guid`=166348 AND `id`=7040; -- TDB 288854, 13.3 yd
UPDATE `creature` SET `position_x`=-7630.91,`position_y`=-2791.04,`position_z`=135.333,`orientation`=1.21761 WHERE `guid`=166368 AND `id`=7040; -- TDB 288839, 17.6 yd
UPDATE `creature` SET `position_x`=-7717.86,`position_y`=-2820.17,`position_z`=144.989,`orientation`=2.80658 WHERE `guid`=166371 AND `id`=7040; -- TDB 288836, 8.3 yd
UPDATE `creature` SET `position_x`=-7607.29,`position_y`=-2779.69,`position_z`=133.458,`orientation`=0.774078 WHERE `guid`=166408 AND `id`=7040; -- TDB 288853, 35.6 yd
UPDATE `creature` SET `position_x`=-7624.2,`position_y`=-2892.61,`position_z`=131.732,`orientation`=4.30816 WHERE `guid`=166415 AND `id`=7040; -- TDB 288771, 17.4 yd
UPDATE `creature` SET `position_x`=-8161.08,`position_y`=-2989.66,`position_z`=135.958,`orientation`=2.92245 WHERE `guid`=166458 AND `id`=7040; -- TDB 288711, 6.4 yd
UPDATE `creature` SET `position_x`=-8005.12,`position_y`=-2854.22,`position_z`=134.259,`orientation`=0.0850394 WHERE `guid`=166471 AND `id`=7040; -- TDB 288742, 5.7 yd
UPDATE `creature` SET `position_x`=-7591.67,`position_y`=-2843.45,`position_z`=136.739,`orientation`=1.20082 WHERE `guid`=166495 AND `id`=7040; -- TDB 288774, 26.9 yd
UPDATE `creature` SET `position_x`=-7818.75,`position_y`=-2939.58,`position_z`=131.134,`orientation`=3.40251 WHERE `guid`=166689 AND `id`=7040; -- TDB 288759, 36.8 yd
UPDATE `creature` SET `position_x`=-7893.52,`position_y`=-2823.81,`position_z`=140.658,`orientation`=5.80353 WHERE `guid`=166761 AND `id`=7040; -- TDB 288779, 5.0 yd
UPDATE `creature` SET `position_x`=-8076.79,`position_y`=-2050.02,`position_z`=130.415,`orientation`=0.35328 WHERE `guid`=165721 AND `id`=7032; -- TDB 289243, 9.1 yd
UPDATE `creature` SET `position_x`=-7894.05,`position_y`=-2325.74,`position_z`=132.268,`orientation`=5.14665 WHERE `guid`=165932 AND `id`=7032; -- TDB 289059, 16.7 yd
UPDATE `creature` SET `position_x`=-8177.02,`position_y`=-2441.96,`position_z`=132.723,`orientation`=0.248605 WHERE `guid`=166018 AND `id`=7032; -- TDB 289043, 10.0 yd
UPDATE `creature` SET `position_x`=-7970.46,`position_y`=-2199.43,`position_z`=129.35,`orientation`=2.24561 WHERE `guid`=166034 AND `id`=7032; -- TDB 289211, 25.8 yd
UPDATE `creature` SET `position_x`=-7756.63,`position_y`=-2423.53,`position_z`=140.107,`orientation`=6.20289 WHERE `guid`=166225 AND `id`=7032; -- TDB 289066, 9.4 yd
UPDATE `creature` SET `position_x`=-7818.76,`position_y`=-2406.69,`position_z`=141.323,`orientation`=1.44441 WHERE `guid`=166233 AND `id`=7032; -- TDB 289065, 11.7 yd
UPDATE `creature` SET `position_x`=-7777.2,`position_y`=-2373.57,`position_z`=136.507,`orientation`=1.41591 WHERE `guid`=166237 AND `id`=7032; -- TDB 289069, 15.6 yd
UPDATE `creature` SET `position_x`=-8055.22,`position_y`=-2519.82,`position_z`=135.554,`orientation`=3.07748 WHERE `guid`=166250 AND `id`=7032; -- TDB 288990, 5.6 yd
UPDATE `creature` SET `position_x`=-7976.98,`position_y`=-2364.72,`position_z`=124.219,`orientation`=5.79045 WHERE `guid`=166263 AND `id`=7032; -- TDB 289058, 15.6 yd
UPDATE `creature` SET `position_x`=-8208.08,`position_y`=-2391.05,`position_z`=141.498,`orientation`=0.515959 WHERE `guid`=166320 AND `id`=7032; -- TDB 289099, 10.8 yd
UPDATE `creature` SET `position_x`=-7945.38,`position_y`=-2410.16,`position_z`=127.037,`orientation`=5.70344 WHERE `guid`=166324 AND `id`=7032; -- TDB 289064, 6.8 yd
UPDATE `creature` SET `position_x`=-8163.93,`position_y`=-2050.91,`position_z`=139.771,`orientation`=3.92423 WHERE `guid`=166449 AND `id`=7032; -- TDB 289157, 26.8 yd
UPDATE `creature` SET `position_x`=-8134.22,`position_y`=-2438.65,`position_z`=133.296,`orientation`=3.11584 WHERE `guid`=166614 AND `id`=7032; -- TDB 289042, 11.3 yd
UPDATE `creature` SET `position_x`=-8094.17,`position_y`=-2408.99,`position_z`=128.708,`orientation`=1.75317 WHERE `guid`=166616 AND `id`=7032; -- TDB 289041, 6.7 yd
UPDATE `creature` SET `position_x`=-7935.66,`position_y`=-2279.83,`position_z`=127.9,`orientation`=0.0517259 WHERE `guid`=166658 AND `id`=7032; -- TDB 289212, 15.2 yd
UPDATE `creature` SET `position_x`=-7847.86,`position_y`=-2452.54,`position_z`=136.442,`orientation`=0.668059 WHERE `guid`=166672 AND `id`=7032; -- TDB 289033, 8.9 yd
UPDATE `creature` SET `position_x`=-7912.4,`position_y`=-2450.97,`position_z`=135.336,`orientation`=5.80552 WHERE `guid`=166674 AND `id`=7032; -- TDB 289034, 8.1 yd
UPDATE `creature` SET `position_x`=-7946.11,`position_y`=-2343.88,`position_z`=124.471,`orientation`=3.52137 WHERE `guid`=166679 AND `id`=7032; -- TDB 289061, 12.2 yd
UPDATE `creature` SET `position_x`=-7923.4,`position_y`=-2389.4,`position_z`=122.773,`orientation`=3.64273 WHERE `guid`=166682 AND `id`=7032; -- TDB 289055, 10.8 yd
UPDATE `creature` SET `position_x`=-7878.04,`position_y`=-2404.87,`position_z`=134.051,`orientation`=0.457529 WHERE `guid`=166683 AND `id`=7032; -- TDB 289063, 5.3 yd
UPDATE `creature` SET `position_x`=-8120.4,`position_y`=-2070.13,`position_z`=130.028,`orientation`=3.89198 WHERE `guid`=166695 AND `id`=7032; -- TDB 289155, 9.9 yd
UPDATE `creature` SET `position_x`=-8013.12,`position_y`=-2421.41,`position_z`=126.137,`orientation`=2.62424 WHERE `guid`=166722 AND `id`=7032; -- TDB 289037, 10.2 yd
UPDATE `creature` SET `position_x`=-7558.55,`position_y`=-2198.25,`position_z`=132.789,`orientation`=5.38551 WHERE `guid`=166429 AND `id`=48671; -- TDB 289179, 5.1 yd
UPDATE `creature` SET `position_x`=-8141.85,`position_y`=-708.145,`position_z`=134.451,`orientation`=4.47806 WHERE `guid`=165731 AND `id`=9690; -- TDB 289758, 10.5 yd
UPDATE `creature` SET `position_x`=-8162.83,`position_y`=-724.801,`position_z`=134.615,`orientation`=0.741141 WHERE `guid`=165732 AND `id`=9690; -- TDB 289759, 5.6 yd
UPDATE `creature` SET `position_x`=-8113.19,`position_y`=-1115.26,`position_z`=132.402,`orientation`=0.729287 WHERE `guid`=165829 AND `id`=9690; -- TDB 289703, 5.7 yd
UPDATE `creature` SET `position_x`=-7886.19,`position_y`=-1021.04,`position_z`=136.238,`orientation`=5.01081 WHERE `guid`=165832 AND `id`=9690; -- TDB 289694, 30.5 yd
UPDATE `creature` SET `position_x`=-8185.65,`position_y`=-994.48,`position_z`=137.377,`orientation`=3.56198 WHERE `guid`=165841 AND `id`=9690; -- TDB 289737, 19.8 yd
UPDATE `creature` SET `position_x`=-8151.77,`position_y`=-1207.15,`position_z`=133.941,`orientation`=2.10519 WHERE `guid`=165850 AND `id`=9690; -- TDB 289671, 8.8 yd
UPDATE `creature` SET `position_x`=-8156.14,`position_y`=-1366.75,`position_z`=133.807,`orientation`=4.43493 WHERE `guid`=165851 AND `id`=9690; -- TDB 289616, 5.9 yd
UPDATE `creature` SET `position_x`=-8015.09,`position_y`=-823.878,`position_z`=134.156,`orientation`=2.97498 WHERE `guid`=166020 AND `id`=9690; -- TDB 289772, 8.9 yd
UPDATE `creature` SET `position_x`=-8061.25,`position_y`=-743.951,`position_z`=136.801,`orientation`=4.62923 WHERE `guid`=166032 AND `id`=9690; -- TDB 289765, 6.2 yd
UPDATE `creature` SET `position_x`=-8087.4,`position_y`=-753.208,`position_z`=134.385,`orientation`=4.51789 WHERE `guid`=166033 AND `id`=9690; -- TDB 289767, 9.5 yd
UPDATE `creature` SET `position_x`=-8121.25,`position_y`=-754.6,`position_z`=134.26,`orientation`=3.30642 WHERE `guid`=166038 AND `id`=9690; -- TDB 289762, 8.7 yd
UPDATE `creature` SET `position_x`=-8093.26,`position_y`=-1145.77,`position_z`=130.969,`orientation`=2.62614 WHERE `guid`=186587 AND `id`=9690; -- TDB 289688, 8.5 yd
UPDATE `creature` SET `position_x`=-7764.11,`position_y`=-2850.15,`position_z`=133.522,`orientation`=0 WHERE `guid`=166470 AND `id`=48291; -- TDB 288823, 8.5 yd
UPDATE `creature` SET `position_x`=-8185.9,`position_y`=-1544.31,`position_z`=133.548,`orientation`=0.0142644 WHERE `guid`=165527 AND `id`=7026; -- TDB 289590, 26.1 yd
UPDATE `creature` SET `position_x`=-8116.52,`position_y`=-1819.7,`position_z`=133.587,`orientation`=2.3483 WHERE `guid`=165558 AND `id`=7026; -- TDB 289346, 5.0 yd
UPDATE `creature` SET `position_x`=-8220.49,`position_y`=-1571.39,`position_z`=142.66,`orientation`=4.72354 WHERE `guid`=165704 AND `id`=7026; -- TDB 289585, 5.4 yd
UPDATE `creature` SET `position_x`=-8116.54,`position_y`=-1513.81,`position_z`=133.436,`orientation`=0.98824 WHERE `guid`=165892 AND `id`=7026; -- TDB 289599, 18.9 yd
UPDATE `creature` SET `position_x`=-8412.9,`position_y`=-953.981,`position_z`=204.061,`orientation`=2.80934 WHERE `guid`=165673 AND `id`=47782; -- TDB 289717, 6.2 yd
UPDATE `creature` SET `position_x`=-8338,`position_y`=-1004.54,`position_z`=185.923,`orientation`=3.34912 WHERE `guid`=165761 AND `id`=47782; -- TDB 289724, 6.6 yd
UPDATE `creature` SET `position_x`=-8255.03,`position_y`=-1270.76,`position_z`=151.945,`orientation`=2.79715 WHERE `guid`=165816 AND `id`=47782; -- TDB 289676, 8.5 yd
UPDATE `creature` SET `position_x`=-8212.97,`position_y`=-1174.94,`position_z`=142.674,`orientation`=2.05199 WHERE `guid`=165817 AND `id`=47782; -- TDB 289686, 7.9 yd
UPDATE `creature` SET `position_x`=-8247.72,`position_y`=-1086.47,`position_z`=142.852,`orientation`=4.55746 WHERE `guid`=165998 AND `id`=47782; -- TDB 289749, 5.8 yd
UPDATE `creature` SET `position_x`=-8253.71,`position_y`=-1221.35,`position_z`=142.947,`orientation`=3.33613 WHERE `guid`=166009 AND `id`=47782; -- TDB 289679, 6.7 yd
UPDATE `creature` SET `position_x`=-8252.25,`position_y`=-1009.9,`position_z`=145.313,`orientation`=1.68357 WHERE `guid`=166022 AND `id`=47782; -- TDB 289739, 7.1 yd
UPDATE `creature` SET `position_x`=-8235,`position_y`=-1634.63,`position_z`=146.803,`orientation`=1.8656 WHERE `guid`=165707 AND `id`=48120; -- TDB 289584, 22.6 yd
UPDATE `creature` SET `position_x`=-8097.36,`position_y`=-1744.96,`position_z`=134.311,`orientation`=4.35097 WHERE `guid`=165769 AND `id`=48120; -- TDB 289420, 21.5 yd
UPDATE `creature` SET `position_x`=-8210.83,`position_y`=-1787.7,`position_z`=148.513,`orientation`=1.84743 WHERE `guid`=165895 AND `id`=48120; -- TDB 289422, 12.9 yd
UPDATE `creature` SET `position_x`=-8117.6,`position_y`=-1481.24,`position_z`=135.033,`orientation`=1.24975 WHERE `guid`=166150 AND `id`=48120; -- TDB 289600, 27.2 yd
UPDATE `creature` SET `position_x`=-8091.42,`position_y`=-1577.45,`position_z`=137.128,`orientation`=2.5059 WHERE `guid`=166159 AND `id`=48120; -- TDB 289587, 11.5 yd
UPDATE `creature` SET `position_x`=-8089.1,`position_y`=-1653.22,`position_z`=132.398,`orientation`=2.4178 WHERE `guid`=166188 AND `id`=48120; -- TDB 289554, 14.7 yd
UPDATE `creature` SET `position_x`=-8150.88,`position_y`=-1779.17,`position_z`=133.537,`orientation`=0.113283 WHERE `guid`=166274 AND `id`=48120; -- TDB 289417, 8.2 yd
UPDATE `creature` SET `position_x`=-8191.18,`position_y`=-1526.28,`position_z`=138.621,`orientation`=3.78705 WHERE `guid`=165703 AND `id`=48118; -- TDB 289601, 11.5 yd
UPDATE `creature` SET `position_x`=-8149.81,`position_y`=-1450.64,`position_z`=134.645,`orientation`=5.2976 WHERE `guid`=165709 AND `id`=48118; -- TDB 289615, 11.9 yd
UPDATE `creature` SET `position_x`=-8203.08,`position_y`=-1707.48,`position_z`=141.822,`orientation`=0.792757 WHERE `guid`=165896 AND `id`=48118; -- TDB 289561, 18.1 yd
UPDATE `creature` SET `position_x`=-8128.77,`position_y`=-1549.36,`position_z`=134.712,`orientation`=3.61834 WHERE `guid`=166145 AND `id`=48118; -- TDB 289595, 6.1 yd
UPDATE `creature` SET `position_x`=-8123.05,`position_y`=-1747.11,`position_z`=132.729,`orientation`=1.89069 WHERE `guid`=166259 AND `id`=48118; -- TDB 289419, 15.2 yd
UPDATE `creature` SET `position_x`=-7748.96,`position_y`=-1614.46,`position_z`=131.909,`orientation`=1.57772 WHERE `guid`=165534 AND `id`=48119; -- TDB 289400, 7.2 yd
UPDATE `creature` SET `position_x`=-7759.64,`position_y`=-1562.84,`position_z`=131.994,`orientation`=2.05949 WHERE `guid`=165585 AND `id`=48119; -- TDB 289461, 8.5 yd
UPDATE `creature` SET `position_x`=-7766.25,`position_y`=-1551.2,`position_z`=132.755,`orientation`=2.05949 WHERE `guid`=165588 AND `id`=48119; -- TDB 289469, 8.3 yd
UPDATE `creature` SET `position_x`=-7721.99,`position_y`=-1531.99,`position_z`=134.357,`orientation`=1.55334 WHERE `guid`=165645 AND `id`=48119; -- TDB 289515, 20.0 yd
UPDATE `creature` SET `position_x`=-7725.57,`position_y`=-1532.05,`position_z`=134.324,`orientation`=1.55334 WHERE `guid`=165649 AND `id`=48119; -- TDB 289514, 21.1 yd
UPDATE `creature` SET `position_x`=-7729.1,`position_y`=-1535.63,`position_z`=134.186,`orientation`=1.55334 WHERE `guid`=165650 AND `id`=48119; -- TDB 289506, 18.5 yd
UPDATE `creature` SET `position_x`=-7732.58,`position_y`=-1542.7,`position_z`=134.079,`orientation`=1.55334 WHERE `guid`=165653 AND `id`=48119; -- TDB 289495, 15.0 yd
UPDATE `creature` SET `position_x`=-7725.14,`position_y`=-1542.13,`position_z`=134.152,`orientation`=1.55334 WHERE `guid`=165658 AND `id`=48119; -- TDB 289504, 8.2 yd
UPDATE `creature` SET `position_x`=-7721.55,`position_y`=-1538.57,`position_z`=134.144,`orientation`=1.55334 WHERE `guid`=165659 AND `id`=48119; -- TDB 289512, 12.1 yd
UPDATE `creature` SET `position_x`=-7728.89,`position_y`=-1542.32,`position_z`=134.215,`orientation`=1.55334 WHERE `guid`=165660 AND `id`=48119; -- TDB 289498, 11.9 yd
UPDATE `creature` SET `position_x`=-7696.39,`position_y`=-1558.54,`position_z`=131.306,`orientation`=1.44497 WHERE `guid`=165666 AND `id`=48119; -- TDB 289500, 25.5 yd
UPDATE `creature` SET `position_x`=-7721.71,`position_y`=-1535.19,`position_z`=134.263,`orientation`=1.55334 WHERE `guid`=165667 AND `id`=48119; -- TDB 289516, 15.8 yd
UPDATE `creature` SET `position_x`=-7717.77,`position_y`=-1534.77,`position_z`=134.178,`orientation`=1.55334 WHERE `guid`=165750 AND `id`=48119; -- TDB 289521, 16.4 yd
UPDATE `creature` SET `position_x`=-7782.09,`position_y`=-1727.22,`position_z`=132.882,`orientation`=2.05949 WHERE `guid`=165788 AND `id`=48119; -- TDB 289374, 7.9 yd
UPDATE `creature` SET `position_x`=-7775.8,`position_y`=-1731.17,`position_z`=133.279,`orientation`=2.05949 WHERE `guid`=166588 AND `id`=48119; -- TDB 289375, 8.3 yd
UPDATE `creature` SET `position_x`=-8297.49,`position_y`=-1999.51,`position_z`=151.137,`orientation`=1.83373 WHERE `guid`=165958 AND `id`=48111; -- TDB 289154, 9.9 yd
UPDATE `creature` SET `position_x`=-8309.04,`position_y`=-1874.94,`position_z`=146.27,`orientation`=2.78217 WHERE `guid`=165963 AND `id`=48111; -- TDB 289322, 5.9 yd
UPDATE `creature` SET `position_x`=-8283.98,`position_y`=-1893.84,`position_z`=141.453,`orientation`=1.15865 WHERE `guid`=165968 AND `id`=48111; -- TDB 289323, 9.6 yd
UPDATE `creature` SET `position_x`=-8216.08,`position_y`=-1958.55,`position_z`=142.58,`orientation`=2.40059 WHERE `guid`=165980 AND `id`=48111; -- TDB 289276, 10.4 yd
UPDATE `creature` SET `position_x`=-8184.5,`position_y`=-1961.8,`position_z`=141.544,`orientation`=6.12875 WHERE `guid`=165989 AND `id`=48111; -- TDB 289274, 6.9 yd
UPDATE `creature` SET `position_x`=-8287.42,`position_y`=-1929.43,`position_z`=142.083,`orientation`=1.0075 WHERE `guid`=165991 AND `id`=48111; -- TDB 289282, 6.6 yd
UPDATE `creature` SET `position_x`=-7723.26,`position_y`=-1580.4,`position_z`=132.303,`orientation`=5.66708 WHERE `guid`=165844 AND `id`=48201; -- TDB 289490, 15.8 yd
UPDATE `creature` SET `position_x`=-7726.43,`position_y`=-1545.46,`position_z`=133.814,`orientation`=0.0312264 WHERE `guid`=165901 AND `id`=48201; -- TDB 289497, 5.5 yd
UPDATE `creature` SET `position_x`=-7758.36,`position_y`=-1543.13,`position_z`=132.492,`orientation`=2.08931 WHERE `guid`=165905 AND `id`=48201; -- TDB 289492, 20.1 yd
UPDATE `creature` SET `position_x`=-7689.26,`position_y`=-1578.31,`position_z`=131.231,`orientation`=3.1765 WHERE `guid`=166008 AND `id`=48201; -- TDB 289493, 23.7 yd
UPDATE `creature` SET `position_x`=-7741.86,`position_y`=-1517.89,`position_z`=132.398,`orientation`=3.84834 WHERE `guid`=166050 AND `id`=48201; -- TDB 289499, 33.9 yd
UPDATE `creature` SET `position_x`=-7947.06,`position_y`=-2633.21,`position_z`=218.294,`orientation`=2.30383 WHERE `guid`=165550 AND `id`=48413; -- TDB 288914, 9.0 yd
UPDATE `creature` SET `position_x`=-7892.39,`position_y`=-2755.1,`position_z`=165.036,`orientation`=4.37771 WHERE `guid`=166172 AND `id`=48413; -- TDB 288828, 5.3 yd
UPDATE `creature` SET `position_x`=-7974.64,`position_y`=-2637.29,`position_z`=171.538,`orientation`=4.87798 WHERE `guid`=166207 AND `id`=48413; -- TDB 288909, 34.9 yd
UPDATE `creature` SET `position_x`=-7880.77,`position_y`=-2691.87,`position_z`=171.249,`orientation`=5.40122 WHERE `guid`=166249 AND `id`=48413; -- TDB 288862, 35.3 yd
UPDATE `creature` SET `position_x`=-7732.33,`position_y`=-1528.44,`position_z`=133.893,`orientation`=1.55334 WHERE `guid`=165651 AND `id`=48121; -- TDB 289508, 10.9 yd
UPDATE `creature` SET `position_x`=-7774.48,`position_y`=-1719.13,`position_z`=132.659,`orientation`=2.05949 WHERE `guid`=165792 AND `id`=48121; -- TDB 289389, 7.2 yd
UPDATE `creature` SET `position_x`=-7825.7,`position_y`=-2887.71,`position_z`=133.517,`orientation`=3.04374 WHERE `guid`=166370 AND `id`=7041; -- TDB 288753, 5.9 yd
UPDATE `creature` SET `position_x`=-7575.26,`position_y`=-2690.38,`position_z`=134.346,`orientation`=5.32717 WHERE `guid`=166378 AND `id`=7041; -- TDB 288955, 8.8 yd
UPDATE `creature` SET `position_x`=-8252.98,`position_y`=-2551.51,`position_z`=138.411,`orientation`=4.50836 WHERE `guid`=166393 AND `id`=7041; -- TDB 288965, 7.5 yd
UPDATE `creature` SET `position_x`=-7618.29,`position_y`=-2845.87,`position_z`=133.624,`orientation`=0.685764 WHERE `guid`=166404 AND `id`=7041; -- TDB 288775, 23.7 yd
UPDATE `creature` SET `position_x`=-7606.81,`position_y`=-2819.48,`position_z`=133.458,`orientation`=4.65035 WHERE `guid`=166486 AND `id`=7041; -- TDB 288843, 38.1 yd
UPDATE `creature` SET `position_x`=-7622.45,`position_y`=-2804.35,`position_z`=134.256,`orientation`=1.55058 WHERE `guid`=166494 AND `id`=7041; -- TDB 288845, 13.8 yd
UPDATE `creature` SET `position_x`=-7582.63,`position_y`=-2755.35,`position_z`=133.459,`orientation`=4.85129 WHERE `guid`=166499 AND `id`=7041; -- TDB 288847, 11.4 yd
UPDATE `creature` SET `position_x`=-8151.55,`position_y`=-3022.18,`position_z`=134.451,`orientation`=5.03619 WHERE `guid`=166548 AND `id`=7041; -- TDB 288705, 7.5 yd
UPDATE `creature` SET `position_x`=-8112.24,`position_y`=-2884.82,`position_z`=135.372,`orientation`=4.84637 WHERE `guid`=166728 AND `id`=7041; -- TDB 288731, 7.0 yd
UPDATE `creature` SET `position_x`=-8123.47,`position_y`=-2946.57,`position_z`=133.521,`orientation`=3.86553 WHERE `guid`=166730 AND `id`=7041; -- TDB 288735, 5.2 yd
UPDATE `creature` SET `position_x`=-8010.14,`position_y`=-2889.64,`position_z`=136.007,`orientation`=1.45045 WHERE `guid`=166747 AND `id`=7041; -- TDB 288725, 37.0 yd
UPDATE `creature` SET `position_x`=-7893.19,`position_y`=-2884.03,`position_z`=136.124,`orientation`=0.656766 WHERE `guid`=166754 AND `id`=7041; -- TDB 288743, 17.5 yd
UPDATE `creature` SET `position_x`=-7760.14,`position_y`=-1547.93,`position_z`=132.849,`orientation`=2.05949 WHERE `guid`=165575 AND `id`=7025; -- TDB 289486, 12.3 yd
UPDATE `creature` SET `position_x`=-7779.25,`position_y`=-1520.14,`position_z`=132.438,`orientation`=6.17134 WHERE `guid`=165576 AND `id`=7025; -- TDB 289539, 37.9 yd
UPDATE `creature` SET `position_x`=-7765.84,`position_y`=-1566.99,`position_z`=132.89,`orientation`=2.05949 WHERE `guid`=165582 AND `id`=7025; -- TDB 289441, 5.8 yd
UPDATE `creature` SET `position_x`=-7775.93,`position_y`=-1591.37,`position_z`=133.391,`orientation`=5.79243 WHERE `guid`=165596 AND `id`=7025; -- TDB 289430, 31.0 yd
UPDATE `creature` SET `position_x`=-7756.82,`position_y`=-1552.81,`position_z`=132.484,`orientation`=2.05949 WHERE `guid`=165598 AND `id`=7025; -- TDB 289487, 10.1 yd
UPDATE `creature` SET `position_x`=-7717.17,`position_y`=-1541.58,`position_z`=133.804,`orientation`=1.55334 WHERE `guid`=165644 AND `id`=7025; -- TDB 289513, 10.2 yd
UPDATE `creature` SET `position_x`=-7728.52,`position_y`=-1528.65,`position_z`=134.251,`orientation`=1.55334 WHERE `guid`=165646 AND `id`=7025; -- TDB 289518, 27.0 yd
UPDATE `creature` SET `position_x`=-7732.48,`position_y`=-1539.3,`position_z`=133.983,`orientation`=1.55334 WHERE `guid`=165647 AND `id`=7025; -- TDB 289496, 17.6 yd
UPDATE `creature` SET `position_x`=-7721.7,`position_y`=-1528.84,`position_z`=134.461,`orientation`=1.55334 WHERE `guid`=165648 AND `id`=7025; -- TDB 289519, 24.9 yd
UPDATE `creature` SET `position_x`=-7732.59,`position_y`=-1532.5,`position_z`=134.004,`orientation`=1.55334 WHERE `guid`=165654 AND `id`=7025; -- TDB 289505, 24.4 yd
UPDATE `creature` SET `position_x`=-7717.28,`position_y`=-1538.25,`position_z`=133.981,`orientation`=1.55334 WHERE `guid`=165657 AND `id`=7025; -- TDB 289520, 13.7 yd
UPDATE `creature` SET `position_x`=-7721.29,`position_y`=-1541.73,`position_z`=134.001,`orientation`=1.55334 WHERE `guid`=165663 AND `id`=7025; -- TDB 289509, 8.5 yd
UPDATE `creature` SET `position_x`=-7732.53,`position_y`=-1535.6,`position_z`=133.986,`orientation`=1.55334 WHERE `guid`=165664 AND `id`=7025; -- TDB 289501, 20.8 yd
UPDATE `creature` SET `position_x`=-7728.86,`position_y`=-1532.21,`position_z`=134.211,`orientation`=1.55334 WHERE `guid`=165665 AND `id`=7025; -- TDB 289510, 22.8 yd
UPDATE `creature` SET `position_x`=-7758.6,`position_y`=-1693.7,`position_z`=131.645,`orientation`=0.437714 WHERE `guid`=165773 AND `id`=7025; -- TDB 289393, 37.9 yd
UPDATE `creature` SET `position_x`=-7728.99,`position_y`=-1538.99,`position_z`=134.194,`orientation`=1.55334 WHERE `guid`=165804 AND `id`=7025; -- TDB 289503, 12.3 yd
UPDATE `creature` SET `position_x`=-7760.04,`position_y`=-1555.11,`position_z`=132.194,`orientation`=2.05949 WHERE `guid`=165806 AND `id`=7025; -- TDB 289477, 5.3 yd
UPDATE `creature` SET `position_x`=-7798.56,`position_y`=-1722.54,`position_z`=133.286,`orientation`=2.60452 WHERE `guid`=165860 AND `id`=7025; -- TDB 289390, 11.1 yd
UPDATE `creature` SET `position_x`=-7756.48,`position_y`=-1560.6,`position_z`=131.798,`orientation`=2.05949 WHERE `guid`=165902 AND `id`=7025; -- TDB 289474, 8.6 yd
UPDATE `creature` SET `position_x`=-7780.48,`position_y`=-618.912,`position_z`=205.863,`orientation`=0.503631 WHERE `guid`=165349 AND `id`=9691; -- TDB 289782, 8.4 yd
UPDATE `creature` SET `position_x`=-7814.55,`position_y`=-652.596,`position_z`=206.594,`orientation`=2.95597 WHERE `guid`=165408 AND `id`=9691; -- TDB 289783, 7.0 yd
UPDATE `creature` SET `position_x`=-7780.36,`position_y`=-662.173,`position_z`=205.498,`orientation`=6.05688 WHERE `guid`=165496 AND `id`=9691; -- TDB 289780, 8.5 yd
UPDATE `creature` SET `position_x`=-8112.31,`position_y`=-728.935,`position_z`=134.831,`orientation`=5.52834 WHERE `guid`=165723 AND `id`=9691; -- TDB 289768, 12.7 yd
UPDATE `creature` SET `position_x`=-8149.36,`position_y`=-758.174,`position_z`=133.398,`orientation`=4.06328 WHERE `guid`=165801 AND `id`=9691; -- TDB 289757, 12.4 yd
UPDATE `creature` SET `position_x`=-8154.03,`position_y`=-1070.95,`position_z`=133.099,`orientation`=1.53715 WHERE `guid`=165827 AND `id`=9691; -- TDB 289748, 9.9 yd
UPDATE `creature` SET `position_x`=-8081.88,`position_y`=-1289.05,`position_z`=139.363,`orientation`=5.09339 WHERE `guid`=165838 AND `id`=9691; -- TDB 289665, 10.9 yd
UPDATE `creature` SET `position_x`=-7971.23,`position_y`=-1412.56,`position_z`=135.466,`orientation`=0.161322 WHERE `guid`=165845 AND `id`=9691; -- TDB 289605, 14.3 yd
UPDATE `creature` SET `position_x`=-8187.85,`position_y`=-781.76,`position_z`=125.792,`orientation`=0.437592 WHERE `guid`=165877 AND `id`=9691; -- TDB 289760, 6.9 yd
UPDATE `creature` SET `position_x`=-7780.85,`position_y`=-702.425,`position_z`=184.875,`orientation`=5.01266 WHERE `guid`=165953 AND `id`=9691; -- TDB 289785, 12.0 yd
UPDATE `creature` SET `position_x`=-7920.96,`position_y`=-989.781,`position_z`=132.901,`orientation`=6.01278 WHERE `guid`=165976 AND `id`=9691; -- TDB 289700, 10.9 yd
UPDATE `creature` SET `position_x`=-8049.47,`position_y`=-775.354,`position_z`=130.915,`orientation`=1.46645 WHERE `guid`=166019 AND `id`=9691; -- TDB 289766, 14.4 yd
UPDATE `creature` SET `position_x`=-7990.6,`position_y`=-777.296,`position_z`=125.234,`orientation`=5.14112 WHERE `guid`=166023 AND `id`=9691; -- TDB 289773, 7.8 yd
UPDATE `creature` SET `position_x`=-8019.79,`position_y`=-756.955,`position_z`=130.783,`orientation`=0.413425 WHERE `guid`=166025 AND `id`=9691; -- TDB 289771, 6.1 yd
UPDATE `creature` SET `position_x`=-8106.4,`position_y`=-787.667,`position_z`=135.171,`orientation`=5.15914 WHERE `guid`=166037 AND `id`=9691; -- TDB 289764, 6.8 yd
UPDATE `creature` SET `position_x`=-8040.59,`position_y`=-1279.39,`position_z`=135.542,`orientation`=5.07623 WHERE `guid`=166189 AND `id`=9691; -- TDB 289662, 5.7 yd
UPDATE `creature` SET `position_x`=-8106.63,`position_y`=-1346.98,`position_z`=133.389,`orientation`=6.2048 WHERE `guid`=166497 AND `id`=9691; -- TDB 289645, 10.8 yd
UPDATE `creature` SET `position_x`=-8053.87,`position_y`=-1104.35,`position_z`=132.276,`orientation`=6.25302 WHERE `guid`=166513 AND `id`=9691; -- TDB 289708, 7.2 yd
UPDATE `creature` SET `position_x`=-7792.82,`position_y`=-1889.81,`position_z`=136.439,`orientation`=3.32862 WHERE `guid`=165898 AND `id`=7037; -- TDB 289331, 38.4 yd
UPDATE `creature` SET `position_x`=-7785.28,`position_y`=-2299.62,`position_z`=133.564,`orientation`=4.55311 WHERE `guid`=166539 AND `id`=7037; -- TDB 289203, 6.5 yd
UPDATE `creature` SET `position_x`=-7826.16,`position_y`=-2207.35,`position_z`=133.564,`orientation`=4.6583 WHERE `guid`=166716 AND `id`=7037; -- TDB 289215, 7.3 yd
UPDATE `creature` SET `position_x`=-7680.46,`position_y`=-1902.57,`position_z`=137.719,`orientation`=1.37225 WHERE `guid`=165904 AND `id`=7039; -- TDB 289335, 5.6 yd
UPDATE `creature` SET `position_x`=-7713.56,`position_y`=-1860.19,`position_z`=134.86,`orientation`=1.91356 WHERE `guid`=165907 AND `id`=7039; -- TDB 289338, 9.5 yd
UPDATE `creature` SET `position_x`=-7714.63,`position_y`=-2109.61,`position_z`=133.442,`orientation`=4.91636 WHERE `guid`=165925 AND `id`=7039; -- TDB 289253, 7.7 yd
UPDATE `creature` SET `position_x`=-7739.65,`position_y`=-1973.01,`position_z`=133.564,`orientation`=0.768062 WHERE `guid`=165926 AND `id`=7039; -- TDB 289311, 11.3 yd
UPDATE `creature` SET `position_x`=-7785.95,`position_y`=-1835.27,`position_z`=133.619,`orientation`=6.21902 WHERE `guid`=166322 AND `id`=7039; -- TDB 289356, 11.5 yd
UPDATE `creature` SET `position_x`=-7787.11,`position_y`=-2254.89,`position_z`=134.138,`orientation`=3.15331 WHERE `guid`=166531 AND `id`=7039; -- TDB 289199, 6.8 yd
UPDATE `creature` SET `position_x`=-7756.46,`position_y`=-2210.73,`position_z`=133.731,`orientation`=5.51092 WHERE `guid`=166534 AND `id`=7039; -- TDB 289224, 33.0 yd
UPDATE `creature` SET `position_x`=-7837.26,`position_y`=-2231.84,`position_z`=133.523,`orientation`=3.82722 WHERE `guid`=166535 AND `id`=7039; -- TDB 289205, 10.4 yd
UPDATE `creature` SET `position_x`=-7767.41,`position_y`=-2278.09,`position_z`=133.564,`orientation`=3.70411 WHERE `guid`=166541 AND `id`=7039; -- TDB 289201, 26.9 yd
UPDATE `creature` SET `position_x`=-7854.17,`position_y`=-1856.86,`position_z`=133.631,`orientation`=4.62241 WHERE `guid`=166577 AND `id`=7039; -- TDB 289329, 16.1 yd
UPDATE `creature` SET `position_x`=-7720.03,`position_y`=-2036.27,`position_z`=133.439,`orientation`=2.18483 WHERE `guid`=166581 AND `id`=7039; -- TDB 289262, 12.8 yd
UPDATE `creature` SET `position_x`=-7784.93,`position_y`=-1980.28,`position_z`=136.692,`orientation`=1.49657 WHERE `guid`=166583 AND `id`=7039; -- TDB 289292, 5.5 yd
UPDATE `creature` SET `position_x`=-7714.75,`position_y`=-2107.59,`position_z`=133.448,`orientation`=5.17457 WHERE `guid`=166586 AND `id`=7039; -- TDB 289147, 6.7 yd
UPDATE `creature` SET `position_x`=-7796.94,`position_y`=-1820.27,`position_z`=132.587,`orientation`=1.91876 WHERE `guid`=166589 AND `id`=7039; -- TDB 289354, 6.4 yd
UPDATE `creature` SET `position_x`=-7748.52,`position_y`=-2214.95,`position_z`=133.503,`orientation`=4.68117 WHERE `guid`=166613 AND `id`=7039; -- TDB 289095, 5.2 yd
UPDATE `creature` SET `position_x`=-7843.85,`position_y`=-2655.82,`position_z`=221.17,`orientation`=5.04517 WHERE `guid`=165619 AND `id`=7035; -- TDB 288934, 34.0 yd
UPDATE `creature` SET `position_x`=-7889.38,`position_y`=-2599.55,`position_z`=221.265,`orientation`=4.66952 WHERE `guid`=166075 AND `id`=7035; -- TDB 288929, 39.7 yd
UPDATE `creature` SET `position_x`=-7890.92,`position_y`=-2579.59,`position_z`=122.581,`orientation`=2.40705 WHERE `guid`=166077 AND `id`=7035; -- TDB 288932, 20.6 yd
UPDATE `creature` SET `position_x`=-7735.26,`position_y`=-2610.66,`position_z`=165.656,`orientation`=0.389881 WHERE `guid`=166234 AND `id`=7035; -- TDB 288948, 19.1 yd
UPDATE `creature` SET `position_x`=-7881.93,`position_y`=-2559.5,`position_z`=126.468,`orientation`=1.61918 WHERE `guid`=166663 AND `id`=7035; -- TDB 288977, 34.6 yd
UPDATE `creature` SET `position_x`=-8348.6,`position_y`=-910.164,`position_z`=207.314,`orientation`=1.03039 WHERE `guid`=165626 AND `id`=7049; -- TDB 289711, 10.5 yd
UPDATE `creature` SET `position_x`=-8386.84,`position_y`=-1018.29,`position_z`=194.47,`orientation`=3.3069 WHERE `guid`=165672 AND `id`=7049; -- TDB 289725, 9.3 yd
UPDATE `creature` SET `position_x`=-8346.98,`position_y`=-1217.41,`position_z`=184.658,`orientation`=5.29606 WHERE `guid`=165754 AND `id`=7049; -- TDB 289681, 5.9 yd
UPDATE `creature` SET `position_x`=-8385.31,`position_y`=-1253.72,`position_z`=203.029,`orientation`=5.25214 WHERE `guid`=165755 AND `id`=7049; -- TDB 289636, 7.2 yd
UPDATE `creature` SET `position_x`=-8361.9,`position_y`=-1279.41,`position_z`=212.774,`orientation`=5.17094 WHERE `guid`=165756 AND `id`=7049; -- TDB 289637, 5.8 yd
UPDATE `creature` SET `position_x`=-8420.99,`position_y`=-1276.78,`position_z`=220.649,`orientation`=4.924 WHERE `guid`=165757 AND `id`=7049; -- TDB 289629, 9.9 yd
UPDATE `creature` SET `position_x`=-8440.72,`position_y`=-1251.55,`position_z`=216.667,`orientation`=5.41287 WHERE `guid`=165759 AND `id`=7049; -- TDB 289635, 6.0 yd
UPDATE `creature` SET `position_x`=-8381.67,`position_y`=-948.36,`position_z`=199.236,`orientation`=5.01167 WHERE `guid`=165763 AND `id`=7049; -- TDB 289715, 6.2 yd
UPDATE `creature` SET `position_x`=-8420.45,`position_y`=-922.253,`position_z`=220.316,`orientation`=1.55408 WHERE `guid`=165765 AND `id`=7049; -- TDB 289714, 7.4 yd
UPDATE `creature` SET `position_x`=-8195.72,`position_y`=-1079.29,`position_z`=148.919,`orientation`=1.90587 WHERE `guid`=166021 AND `id`=7049; -- TDB 289745, 9.7 yd
UPDATE `creature` SET `position_x`=-8307.25,`position_y`=-994.395,`position_z`=175.417,`orientation`=1.72161 WHERE `guid`=166028 AND `id`=7049; -- TDB 289728, 9.2 yd
UPDATE `creature` SET `position_x`=-8173.66,`position_y`=-1702.74,`position_z`=140.247,`orientation`=2.98056 WHERE `guid`=166157 AND `id`=48099; -- TDB 289557, 35.0 yd
UPDATE `creature` SET `position_x`=-7650.67,`position_y`=-2726.45,`position_z`=131.147,`orientation`=2.194 WHERE `guid`=165508 AND `id`=9697; -- TDB 288859, 26.3 yd
UPDATE `creature` SET `position_x`=-7850.33,`position_y`=-2933.12,`position_z`=131.065,`orientation`=0.844859 WHERE `guid`=165616 AND `id`=9697; -- TDB 288724, 15.7 yd
UPDATE `creature` SET `position_x`=-7556.71,`position_y`=-2518.09,`position_z`=136.06,`orientation`=4.37972 WHERE `guid`=165622 AND `id`=9697; -- TDB 289022, 9.7 yd
UPDATE `creature` SET `position_x`=-7878.79,`position_y`=-2848.95,`position_z`=137.911,`orientation`=3.33512 WHERE `guid`=165737 AND `id`=9697; -- TDB 288777, 5.1 yd
UPDATE `creature` SET `position_x`=-8029.24,`position_y`=-2108.63,`position_z`=122.932,`orientation`=5.21361 WHERE `guid`=165822 AND `id`=9697; -- TDB 289160, 10.4 yd
UPDATE `creature` SET `position_x`=-7681.24,`position_y`=-2988.33,`position_z`=132.031,`orientation`=0.540199 WHERE `guid`=165948 AND `id`=9697; -- TDB 288722, 8.4 yd
UPDATE `creature` SET `position_x`=-8179.43,`position_y`=-2166.06,`position_z`=136.178,`orientation`=4.40053 WHERE `guid`=166012 AND `id`=9697; -- TDB 289148, 9.8 yd
UPDATE `creature` SET `position_x`=-7723.98,`position_y`=-2970.71,`position_z`=132.65,`orientation`=4.67043 WHERE `guid`=166087 AND `id`=9697; -- TDB 288766, 26.5 yd
UPDATE `creature` SET `position_x`=-7583.99,`position_y`=-2606.75,`position_z`=137.561,`orientation`=0.384131 WHERE `guid`=166190 AND `id`=9697; -- TDB 288982, 31.3 yd
UPDATE `creature` SET `position_x`=-7586.82,`position_y`=-2536.45,`position_z`=133.551,`orientation`=5.27927 WHERE `guid`=166193 AND `id`=9697; -- TDB 289024, 15.1 yd
UPDATE `creature` SET `position_x`=-7567.34,`position_y`=-2596.68,`position_z`=138.926,`orientation`=0.68298 WHERE `guid`=166198 AND `id`=9697; -- TDB 289019, 8.5 yd
UPDATE `creature` SET `position_x`=-7611.57,`position_y`=-2586.68,`position_z`=133.321,`orientation`=1.91973 WHERE `guid`=166199 AND `id`=9697; -- TDB 289017, 10.1 yd
UPDATE `creature` SET `position_x`=-7627.12,`position_y`=-2647.49,`position_z`=131.982,`orientation`=5.24342 WHERE `guid`=166213 AND `id`=9697; -- TDB 288951, 6.4 yd
UPDATE `creature` SET `position_x`=-7681.22,`position_y`=-2507.49,`position_z`=139.238,`orientation`=4.53184 WHERE `guid`=166219 AND `id`=9697; -- TDB 289025, 5.8 yd
UPDATE `creature` SET `position_x`=-8088.64,`position_y`=-2749.89,`position_z`=136.883,`orientation`=1.69779 WHERE `guid`=166377 AND `id`=9697; -- TDB 288785, 6.0 yd
UPDATE `creature` SET `position_x`=-8181.7,`position_y`=-2812.65,`position_z`=137.038,`orientation`=4.82003 WHERE `guid`=166382 AND `id`=9697; -- TDB 288790, 15.2 yd
UPDATE `creature` SET `position_x`=-8098.63,`position_y`=-2738.14,`position_z`=136.072,`orientation`=4.27234 WHERE `guid`=166395 AND `id`=9697; -- TDB 288784, 11.4 yd
UPDATE `creature` SET `position_x`=-8062.29,`position_y`=-2778.52,`position_z`=135.694,`orientation`=5.75379 WHERE `guid`=166396 AND `id`=9697; -- TDB 288783, 20.1 yd
UPDATE `creature` SET `position_x`=-8216.08,`position_y`=-2716.49,`position_z`=134.19,`orientation`=5.17035 WHERE `guid`=166402 AND `id`=9697; -- TDB 288810, 10.3 yd
UPDATE `creature` SET `position_x`=-8238.35,`position_y`=-2784.11,`position_z`=136.97,`orientation`=2.17148 WHERE `guid`=166405 AND `id`=9697; -- TDB 288789, 11.4 yd
UPDATE `creature` SET `position_x`=-8144.27,`position_y`=-2749.02,`position_z`=137.404,`orientation`=1.34754 WHERE `guid`=166409 AND `id`=9697; -- TDB 288786, 10.0 yd
UPDATE `creature` SET `position_x`=-7649.55,`position_y`=-2947.04,`position_z`=132.204,`orientation`=6.27432 WHERE `guid`=166418 AND `id`=9697; -- TDB 288768, 8.7 yd
UPDATE `creature` SET `position_x`=-8241.32,`position_y`=-2756.52,`position_z`=136.725,`orientation`=2.67164 WHERE `guid`=166424 AND `id`=9697; -- TDB 288803, 9.1 yd
UPDATE `creature` SET `position_x`=-8152.69,`position_y`=-2619.01,`position_z`=134.72,`orientation`=2.9928 WHERE `guid`=166425 AND `id`=9697; -- TDB 288871, 11.7 yd
UPDATE `creature` SET `position_x`=-8179.59,`position_y`=-2643.19,`position_z`=134.23,`orientation`=0.805373 WHERE `guid`=166427 AND `id`=9697; -- TDB 288870, 10.7 yd
UPDATE `creature` SET `position_x`=-8113.99,`position_y`=-2614.57,`position_z`=133.573,`orientation`=5.78512 WHERE `guid`=166428 AND `id`=9697; -- TDB 288905, 8.3 yd
UPDATE `creature` SET `position_x`=-8180.43,`position_y`=-2712.16,`position_z`=136.251,`orientation`=2.32425 WHERE `guid`=166440 AND `id`=9697; -- TDB 288809, 11.6 yd
UPDATE `creature` SET `position_x`=-7663.51,`position_y`=-2798.99,`position_z`=132.931,`orientation`=1.4474 WHERE `guid`=166594 AND `id`=9697; -- TDB 288840, 11.4 yd
UPDATE `creature` SET `position_x`=-8214.8,`position_y`=-2146.62,`position_z`=139.197,`orientation`=0.872555 WHERE `guid`=166602 AND `id`=9697; -- TDB 289149, 6.9 yd
UPDATE `creature` SET `position_x`=-8227,`position_y`=-2234.39,`position_z`=137.908,`orientation`=6.26034 WHERE `guid`=166603 AND `id`=9697; -- TDB 289133, 19.5 yd
UPDATE `creature` SET `position_x`=-8202.42,`position_y`=-2886.96,`position_z`=138.947,`orientation`=4.44134 WHERE `guid`=166692 AND `id`=9697; -- TDB 288737, 8.1 yd
UPDATE `creature` SET `position_x`=-8125.71,`position_y`=-2820.15,`position_z`=133.557,`orientation`=0.645454 WHERE `guid`=166744 AND `id`=9697; -- TDB 288787, 11.4 yd
UPDATE `creature` SET `position_x`=-8103.06,`position_y`=-2687.21,`position_z`=133.805,`orientation`=5.16475 WHERE `guid`=166756 AND `id`=9697; -- TDB 288869, 8.1 yd
UPDATE `creature` SET `position_x`=-7648.27,`position_y`=-2285.81,`position_z`=131.285,`orientation`=0.772165 WHERE `guid`=165950 AND `id`=9776; -- TDB 289138, 5.2 yd
UPDATE `creature` SET `position_x`=-8162.66,`position_y`=-2345.62,`position_z`=131.061,`orientation`=1.7812 WHERE `guid`=166300 AND `id`=9776; -- TDB 289106, 6.1 yd
UPDATE `creature` SET `position_x`=-8080.01,`position_y`=-1785.57,`position_z`=133.501,`orientation`=4.92296 WHERE `guid`=165400 AND `id`=7027; -- TDB 289406, 22.9 yd
UPDATE `creature` SET `position_x`=-8186.35,`position_y`=-1749.06,`position_z`=144.063,`orientation`=0.312362 WHERE `guid`=165894 AND `id`=7027; -- TDB 289572, 12.3 yd
UPDATE `creature` SET `position_x`=-7744.05,`position_y`=-2119.73,`position_z`=133.473,`orientation`=0.130311 WHERE `guid`=166128 AND `id`=7036; -- TDB 289246, 24.0 yd
UPDATE `creature` SET `position_x`=-7820.36,`position_y`=-2120.32,`position_z`=132.96,`orientation`=1.73241 WHERE `guid`=166498 AND `id`=7036; -- TDB 289245, 33.7 yd
UPDATE `creature` SET `position_x`=-7882.77,`position_y`=-2184.9,`position_z`=133.516,`orientation`=6.03856 WHERE `guid`=166700 AND `id`=7038; -- TDB 289209, 23.5 yd
UPDATE `creature` SET `position_x`=-7858.51,`position_y`=-2625.18,`position_z`=221.246,`orientation`=5.71043 WHERE `guid`=165433 AND `id`=7034; -- TDB 288936, 33.7 yd
UPDATE `creature` SET `position_x`=-7883.72,`position_y`=-2524.75,`position_z`=128.052,`orientation`=1.45291 WHERE `guid`=166046 AND `id`=7034; -- TDB 288988, 34.2 yd
UPDATE `creature` SET `position_x`=-7875.59,`position_y`=-2585.32,`position_z`=123.403,`orientation`=5.91567 WHERE `guid`=166055 AND `id`=7034; -- TDB 288935, 15.9 yd
UPDATE `creature` SET `position_x`=-7854.16,`position_y`=-2614.21,`position_z`=119.905,`orientation`=2.72656 WHERE `guid`=166102 AND `id`=7034; -- TDB 288942, 38.4 yd
UPDATE `creature` SET `position_x`=-7725.5,`position_y`=-1535.32,`position_z`=134.279,`orientation`=1.55334 WHERE `guid`=165652 AND `id`=48121; -- TDB 289511, 4.6 yd: off the Blackrock Soldier spot (TDB 289510) that 165665 takes above
