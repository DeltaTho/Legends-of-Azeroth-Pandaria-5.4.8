-- Northern Barrens (zone 17), scope I-S: static copies of summons and removed NPCs.
-- 3084 Bluffwatcher x7 (sniffed in flight, template has no flight movement: seven level-90 guards stand about; neither TDB);
-- 51914 Horde Guard x4 / 51815 Mor'shan Defender (4.1 hub-defender summons caught by the sniff, standing inside Thork / Tonga; neither
--   TDB); 3939 Razormane Wolf x3 (summons of spell 6479); 5780 Cloned Ectoplasm x2 (summons of spell 7952); 3476 Isha Awak 265590
--   (wiki: classic only, removed 4.0.3a; neither TDB; the Wowhead MoP Classic pins are Classic Era data, 1659 yd from this spawn).
-- 4021 Counterattack!: 12 Invaders (9524), 5 Defenders (9457), 3 Axe Throwers (9458) are copies of Regthar's actionlist 338900 summons;
--   both TDBs keep one standing skirmish of 3 Defenders + 1 Invader (302662-302665, comment "the mobs are always there"): keep four
--   (265893 265906 265908 265907, moved to the sniffed spots, idle), delete the other 16. Regthar's script is S1's (D-4021).
DELETE FROM `creature_addon` WHERE `guid` IN (262751,262753,263564,263566,264434,264436,264684,354891,354893,354894,354895,265916,372293,372294,372295,264260,264270,265590,265883,265884,265885,265886,265887,265888,265889,265890,265891,265892,265895,265901,265902,265898,265900,265903);
DELETE FROM `waypoint_data` WHERE `id` IN (265890,265891,354894);
DELETE FROM `creature` WHERE `id`=3084 AND `guid` IN (262751,262753,263564,263566,264434,264436,264684);
DELETE FROM `creature` WHERE `id`=3476 AND `guid` IN (265590);
DELETE FROM `creature` WHERE `id`=3939 AND `guid` IN (372293,372294,372295);
DELETE FROM `creature` WHERE `id`=5780 AND `guid` IN (264260,264270);
DELETE FROM `creature` WHERE `id`=9457 AND `guid` IN (265901,265902);
DELETE FROM `creature` WHERE `id`=9458 AND `guid` IN (265898,265900,265903);
DELETE FROM `creature` WHERE `id`=9524 AND `guid` IN (265883,265884,265885,265886,265887,265888,265889,265890,265891,265892,265895);
DELETE FROM `creature` WHERE `id`=51815 AND `guid` IN (265916);
DELETE FROM `creature` WHERE `id`=51914 AND `guid` IN (354891,354893,354894,354895);
UPDATE `creature` SET `position_x`=-231.439, `position_y`=-1936.73, `position_z`=93.9014, `orientation`=0.567259, `MovementType`=0, `wander_distance`=0 WHERE `guid`=265893 AND `id`=9457;
UPDATE `creature` SET `position_x`=-225.495, `position_y`=-1932.48, `position_z`=93.7734, `orientation`=3.81617, `MovementType`=0, `wander_distance`=0 WHERE `guid`=265906 AND `id`=9457;
UPDATE `creature` SET `position_x`=-232.007, `position_y`=-1934.63, `position_z`=93.7749, `orientation`=6.24811, `MovementType`=0, `wander_distance`=0 WHERE `guid`=265908 AND `id`=9457;
UPDATE `creature` SET `position_x`=-228.351, `position_y`=-1934.76, `position_z`=93.9308, `orientation`=4.52211, `MovementType`=0, `wander_distance`=0 WHERE `guid`=265907 AND `id`=9524;
