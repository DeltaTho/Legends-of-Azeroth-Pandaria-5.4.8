-- Searing Gorge, C-4 + C-5 + C-9: doubled and unpooled spawns of unique entries.
-- C-4 rares: every rare had one extra copy outside its pool, so two could be up at once; Rekk'tilac's extra 302959 stood 5 yd from
--   pooled 129747 (deleted), the other copies join their pools (1289 8279, 1290 8281, 152 8282, 1291 8283) or new pools of ours
--   (3133000 Smoldar 8278, 3133001 Shleipnarr 8280). Scald 301975 sits exactly on TDB 359509 where the TDB has it idle: idle.
--   Pool 152 is the old rare-or-placeholder pool: Mastrogonde 17518 / 53455 at chance 6 each and a common Twilight Fire Guard 7350
--   (chance 0, TDB 359471 spawns the same Fire Guard on the spot) as the placeholder, so the added 318106 takes chance 6 as its
--   siblings (Mastrogonde 18 %, Fire Guard 82 % per roll), not 0 (which would leave Mastrogonde absent in 44 % of rolls).
--   Sourced: the layout (TDB for Rekk'tilac/Scald; Wowhead MoP Classic pages for 8278-8283 show all still existed). Ours: the pools.
-- C-5 Enslaved Archaeologists 8402: the TDB has 6 (359533-359538), mop_world had 16, ten of them walkers caught at the dig or a
--   copy of another path (186660 = 186336's path). Ten deleted (and path 186660), three of the six kept stand idle at home.
--   Sourced count; ours: idle instead of the TDB's SmartAI commute to the dig.
-- C-9 ore: Mithril 160546 on the very spot of Truesilver 156229, and Mithril 160457 2.9 yd from pooled spot 8951 (which holds a
--   Mithril): deleted. Ours.
-- Idempotent: DELETE + INSERT, absolute UPDATEs.

DELETE FROM `creature_addon` WHERE `guid`=302959;
DELETE FROM `creature` WHERE `guid`=302959 AND `id`=8277;           -- Rekk'tilac, 5 yd from pooled 129747
DELETE FROM `pool_creature` WHERE `guid` IN (186037,301975,318106,302624,7413,318107,7157,186619);
INSERT INTO `pool_creature` (`guid`,`pool_entry`,`chance`,`description`) VALUES
(186037,1289,0,'Faulty War Golem (8279)'),
(301975,1290,0,'Scald (8281)'),
(318106,152,6,'Highlord Mastrogonde (8282)'),
(302624,1291,0,'Slave Master Blackheart (8283)'),
(7413,3133000,0,'Smoldar (8278)'),
(318107,3133000,0,'Smoldar (8278)'),
(7157,3133001,0,'Shleipnarr (8280)'),
(186619,3133001,0,'Shleipnarr (8280)');
DELETE FROM `pool_template` WHERE `entry` IN (3133000,3133001);
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES
(3133000,1,'Searing Gorge - Smoldar 8278'),
(3133001,1,'Searing Gorge - Shleipnarr 8280');
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid`=301975 AND `id`=8281;   -- TDB 359509 idle

-- S5. Enslaved Archaeologists: TDB has 6 commuting between their posts and the dig at (-6460,-1251); mop has 16, ten of
--     them the same walkers caught at the dig, and two copies of one path (186336 / 186660).
DELETE FROM `creature_addon` WHERE `guid` IN (186660,186334,186335,186343,186533,186541,186543,186546,186547,186669);
DELETE FROM `waypoint_data` WHERE `id`=186660;
DELETE FROM `creature` WHERE `id`=8402 AND `guid` IN (186660,186334,186335,186343,186533,186541,186543,186546,186547,186669);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=8402 AND `guid` IN (186332,186665,186666);

DELETE FROM `gameobject` WHERE `guid` IN (160546,160457) AND `id`=2040;
