-- Badlands: one copy of each rare at a time (plan item C-4).
--
-- Seven rares (War Golem 2751, Rumbler 2752, Barnabus 2753, Broken Tooth 2850, Zaricotl 2931, 7:XT 14224, Anathemus 2754)
-- have a pool of classic spots (max_limit 1) AND one more spawn in no pool, which respawns on its own after
-- 28800 s, so a second copy could stand beside the first. The two Shadowforge Commanders 2744 in Angor Fortress (7596 upstairs,
-- 162765 on Infernus' floor) are both unpooled. The extra spawns join their rare's pool; the Commanders get a new pool.
--
-- Pools 1257 (War Golem) and 1258 (Rumbler) were the only two children of mother pool 1045169 (max_limit 1, a split of the old
-- pool 5646; nothing else hangs on it: no pool_creature, pool_gameobject or other pool_pool row), which made the zone hold a War
-- Golem OR a Rumbler. Retail has them independent, so the two pool_pool rows and the then-empty mother pool go (review round 1);
-- each rare is now limited by its own pool and its added standalone spawn only.
-- Sourced: the rows are mop's own (nothing is deleted: which spots were the 5.4.8 ones is not known). 318935 (Rumbler, the
-- Hidden Clutch) is the spot both TDBs have (TDB guid 294868). The Commander comment "rogues can sap the rare, but you have to
-- fight the other two" (27878, 2014-04-17) supports 162765 as a 5.4.8 spot.
-- Ours: the pooling itself, new pool 3131000 (max_limit 1), and the equal chance (0) of each added member.
-- Effect on the odds, for the test sheet: pool 228 (Zaricotl 3 spots at 4 % each + Parched Buzzard 7141) and pool 103 (Anathemus
-- 12 % + Feral Crag Coyote 7102) fill the rest of the roll from members with chance 0 shared equally, so the added spawn
-- (301942, 186066) now takes an equal share with the Buzzard / Coyote of the roll that no explicit spot wins, instead of
-- standing every time on top of the pool's result.

DELETE FROM `pool_pool` WHERE `pool_id` IN (1257,1258) AND `mother_pool` = 1045169;
DELETE FROM `pool_template` WHERE `entry` = 1045169;

DELETE FROM `pool_creature` WHERE `guid` IN (313151,318935,316795,302479,301942,312990,186066,7596,162765);
INSERT INTO `pool_creature` (`guid`,`pool_entry`,`chance`,`description`) VALUES
(313151,1257,0,'War Golem (Badlands)'),
(318935,1258,0,'Rumbler (Badlands, the Hidden Clutch: TDB spot)'),
(316795,1259,0,'Barnabus (Badlands)'),
(302479,1260,0,'Broken Tooth (Badlands)'),
(301942,228,0,'Zaricotl (Badlands)'),
(312990,1318,0,'7:XT (Badlands)'),
(186066,103,0,'Anathemus (Badlands)');

DELETE FROM `pool_creature` WHERE `pool_entry` = 3131000;
DELETE FROM `pool_template` WHERE `entry` = 3131000;
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES (3131000,1,'Badlands - Shadowforge Commander 2744');
INSERT INTO `pool_creature` (`guid`,`pool_entry`,`chance`,`description`) VALUES
(7596,3131000,0,'Shadowforge Commander (Angor Fortress)'),
(162765,3131000,0,'Shadowforge Commander (Angor Fortress)');
