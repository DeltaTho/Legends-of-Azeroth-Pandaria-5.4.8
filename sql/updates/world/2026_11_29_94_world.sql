-- Northern Barrens nb-fix10 (_94): one animal where the wild had two.
-- Wildlife across the zone (zhevras, plainstriders, prowlers, vultures, giraffes, Wailing Caverns creatures...): same-entry copies a few yards apart, from doubles.py (zone 17 vs TDB 1210 + 4.4.2, game-event spawns left out,
-- same phase only), each group checked by hand. SOURCED: a stacked copy (within 8 yd) or an offset copy (unmatched, its
-- retail spot held by a matched spawn within 16 yd) goes; the spawn holding the TDB spot stays. OURS: groups with no TDB spot
-- keep the lowest guid; where the local count is not above retail only stacks of 2 yd or less go; no delete takes an entry
-- below retail. No deleted guid has a formation, guid SmartAI, pool, event, linked respawn, condition or C++ reference.
-- entry name: local -> after (retail); deleted guid (reason)
--   34640 Barrens Vulture: 139 -> 120 (86)
--     262375 (stacked 3.0 yd from 262770), 262383 (stacked 6.9 yd from 263621), 262384 (stacked 6.0 yd from 263621)
--     262386 (stacked 5.6 yd from 262770), 262764 (stacked 5.5 yd from 263610), 263239 (stacked 3.0 yd from 262820)
--     263266 (stacked 6.2 yd from 263249), 263518 (stacked 4.7 yd from 262356), 263620 (stacked 6.8 yd from 262381)
--     263622 (stacked 5.6 yd from 262382), 264384 (stacked 3.3 yd from 263435), 264668 (stacked 3.2 yd from 263431)
--     265131 (stacked 6.8 yd from 265046), 265136 (stacked 3.5 yd from 265607), 265141 (stacked 2.8 yd from 265043)
--     265440 (stacked 5.7 yd from 263304), 265599 (stacked 5.0 yd from 265038), 265606 (stacked 4.1 yd from 265129)
--     269121 (stacked 7.3 yd from 263945)
--   3242 Zhevra Runner: 205 -> 188 (147)
--     262431 (stacked 1.8 yd from 265110), 262907 (stacked 2.3 yd from 262890), 263368 (stacked 5.9 yd from 265485)
--     263383 (offset 9.0 yd from 265531, TDB 301894), 263389 (stacked 7.2 yd from 265517)
--     263786 (stacked 1.4 yd from 262852), 263878 (stacked 6.1 yd from 262904)
--     263887 (offset 12.4 yd from 265532, TDB 301757), 264134 (stacked 5.4 yd from 263343)
--     264219 (offset 11.5 yd from 263095, TDB 302423), 265451 (stacked 7.7 yd from 263335)
--     265487 (offset 13.9 yd from 263362, TDB 301908), 265494 (stacked 7.1 yd from 263363)
--     265516 (stacked 5.7 yd from 263392), 265526 (stacked 5.7 yd from 263415), 265551 (stacked 5.9 yd from 263391)
--     265559 (stacked 3.0 yd from 265547)
--   3246 Fleeting Plainstrider: 168 -> 154 (128)
--     262703 (stacked 7.6 yd from 263187), 262710 (stacked 3.8 yd from 263192)
--     262734 (offset 8.6 yd from 263202, TDB 303819), 262738 (offset 14.5 yd from 263203, TDB 303794)
--     263164 (stacked 4.6 yd from 263424), 263183 (stacked 5.2 yd from 263494)
--     263195 (offset 11.2 yd from 263539, TDB 302447), 263198 (stacked 3.8 yd from 263549)
--     263216 (offset 8.2 yd from 263587, TDB 302445), 263218 (stacked 7.3 yd from 263595)
--     263219 (stacked 6.5 yd from 263596), 263496 (offset 8.5 yd from 263184, TDB 302446)
--     263594 (offset 8.5 yd from 263217, TDB 302448), 263598 (stacked 5.0 yd from 263220)
--   3425 Savannah Prowler: 91 -> 79 (72)
--     263297 (offset 9.3 yd from 265425, TDB 302243), 263315 (stacked 0.3 yd from 265425)
--     263320 (stacked 1.0 yd from 265412), 264723 (stacked 1.1 yd from 263756), 264724 (stacked 0.7 yd from 263759)
--     265411 (stacked 0.2 yd from 263317), 265413 (stacked 0.7 yd from 263322), 265415 (stacked 0.7 yd from 263321)
--     265417 (stacked 1.9 yd from 263319), 265418 (stacked 0.5 yd from 263336), 265421 (stacked 0.5 yd from 263318)
--     265424 (stacked 0.2 yd from 263295)
--   3244 Greater Plainstrider: 56 -> 48 (44)
--     251330 (offset 8.4 yd from 264602, TDB 304115), 253187 (stacked 4.8 yd from 262448)
--     262530 (offset 10.6 yd from 262570, TDB 303357), 262601 (offset 13.5 yd from 262505, TDB 304065)
--     262623 (offset 10.1 yd from 262570, TDB 303357), 262630 (offset 13.2 yd from 262570, TDB 303357)
--     264604 (stacked 4.7 yd from 251326), 264608 (offset 14.2 yd from 262552, TDB 304099)
--   3835 Biletoad: 17 -> 11 (11)
--     263230 (stacked 2.6 yd from 263669), 263231 (stacked 2.3 yd from 263683), 263237 (stacked 4.0 yd from 263690)
--     263323 (stacked 2.1 yd from 264061), 263735 (stacked 4.7 yd from 263255), 263781 (stacked 1.7 yd from 264264)
--   3248 Barrens Giraffe: 63 -> 59 (49)
--     263150 (stacked 2.9 yd from 263149), 263152 (stacked 5.6 yd from 263149), 265351 (stacked 5.4 yd from 265566)
--     265587 (stacked 5.9 yd from 265584)
--   620 Chicken: 17 -> 13 (10)
--     262394 (stacked 3.0 yd from 262371), 262761 (stacked 6.3 yd from 262371), 262800 (stacked 1.4 yd from 262371)
--     262864 (stacked 7.8 yd from 263096)
--   3245 Ornery Plainstrider: 71 -> 68 (32)
--     262837 (offset 14.8 yd from 263226, TDB 303949), 263251 (stacked 7.2 yd from 262834)
--     263746 (stacked 3.7 yd from 263743)
--   3641 Deviate Lurker: 11 -> 8 (8)
--     263284 (stacked 2.7 yd from 263916), 263685 (stacked 2.0 yd from 263233), 263686 (stacked 2.4 yd from 263234)
--   18739 Giraffe: 6 -> 4 (4)
--     262458 (stacked 1.5 yd from 262457), 262894 (stacked 3.0 yd from 262893)
--   3415 Savannah Huntress: 98 -> 96 (84)
--     263091 (offset 15.1 yd from 263031, TDB 302424), 265004 (stacked 5.8 yd from 263306)
--   3631 Deviate Stinglash: 14 -> 12 (6)
--     263259 (offset 12.5 yd from 263783, TDB 302480), 264144 (stacked 5.5 yd from 263345)
--   34647 Barrens Boar: 16 -> 14 (9)
--     264354 (offset 13.4 yd from 264347, TDB 303208), 264364 (stacked 6.4 yd from 264312)
--   6020 Slimeshell Makrura: 18 -> 16 (16)
--     265196 (stacked 2.1 yd from 265619), 265605 (stacked 7.3 yd from 265115)
--   4166 Gazelle: 43 -> 42 (50)
--     263384 (stacked 2.0 yd from 263373)
--   3638 Devouring Ectoplasm: 18 -> 17 (9)
--     263351 (stacked 6.4 yd from 263325)
--   3461 Oasis Snapjaw: 38 -> 37 (37)
--     264295 (stacked 5.6 yd from 263914)
--   44166 Grazing Zhevra: 35 -> 34 (25)
--     263798 (offset 9.6 yd from 264739, TDB 303263)
--   3416 Savannah Matriarch: 12 -> 11 (9)
--     263260 (stacked 6.9 yd from 262851)
--   3630 Deviate Coiler: 5 -> 4 (4)
--     264277 (offset 11.2 yd from 264204, TDB 302538)
-- Move (coverage guard): Barrens Giraffe 263151, the fourth of a stack at (-495,-3519) pacing a 4-node 3 yd path, goes to the
-- empty TDB spot 303932 (-536.471,-3516.39,92.0673) with the TDB movement (random, 15 yd); its path goes.
DELETE FROM `waypoint_data` WHERE `id` IN (262375,262458,262703,262764,262894,263150,263151,263152,263239,263518,263620,264384,264668,265136,265559,265587,269121);
DELETE FROM `creature_addon` WHERE `guid` IN (262375,262383,262384,262386,262458,262703,262710,262734,262738,262764,262894,263091,263150,263152,263164,263183,263195,263198,263216,263218,263219,263239,263266,263297,263496,263518,263594,263598,263620,263622,264384,264668,264723,265131,265136,265141,265411,265413,265415,265417,265418,265421,265440,265559,265587,265599,265606,269121);
DELETE FROM `creature` WHERE `id`=34640 AND `guid` IN (262375,262383,262384,262386,262764,263239,263266,263518,263620,263622,264384,264668,265131,265136,265141,265440,265599,265606,269121);
DELETE FROM `creature` WHERE `id`=3242 AND `guid` IN (262431,262907,263368,263383,263389,263786,263878,263887,264134,264219,265451,265487,265494,265516,265526,265551,265559);
DELETE FROM `creature` WHERE `id`=3246 AND `guid` IN (262703,262710,262734,262738,263164,263183,263195,263198,263216,263218,263219,263496,263594,263598);
DELETE FROM `creature` WHERE `id`=3425 AND `guid` IN (263297,263315,263320,264723,264724,265411,265413,265415,265417,265418,265421,265424);
DELETE FROM `creature` WHERE `id`=3244 AND `guid` IN (251330,253187,262530,262601,262623,262630,264604,264608);
DELETE FROM `creature` WHERE `id`=3835 AND `guid` IN (263230,263231,263237,263323,263735,263781);
DELETE FROM `creature` WHERE `id`=3248 AND `guid` IN (263150,263152,265351,265587);
DELETE FROM `creature` WHERE `id`=620 AND `guid` IN (262394,262761,262800,262864);
DELETE FROM `creature` WHERE `id`=3245 AND `guid` IN (262837,263251,263746);
DELETE FROM `creature` WHERE `id`=3641 AND `guid` IN (263284,263685,263686);
DELETE FROM `creature` WHERE `id`=18739 AND `guid` IN (262458,262894);
DELETE FROM `creature` WHERE `id`=3415 AND `guid` IN (263091,265004);
DELETE FROM `creature` WHERE `id`=3631 AND `guid` IN (263259,264144);
DELETE FROM `creature` WHERE `id`=34647 AND `guid` IN (264354,264364);
DELETE FROM `creature` WHERE `id`=6020 AND `guid` IN (265196,265605);
DELETE FROM `creature` WHERE `id`=4166 AND `guid` IN (263384);
DELETE FROM `creature` WHERE `id`=3638 AND `guid` IN (263351);
DELETE FROM `creature` WHERE `id`=3461 AND `guid` IN (264295);
DELETE FROM `creature` WHERE `id`=44166 AND `guid` IN (263798);
DELETE FROM `creature` WHERE `id`=3416 AND `guid` IN (263260);
DELETE FROM `creature` WHERE `id`=3630 AND `guid` IN (264277);
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid`=263151;
UPDATE `creature` SET `position_x`=-536.471, `position_y`=-3516.39, `position_z`=92.0673, `orientation`=0.00585931, `MovementType`=1, `wander_distance`=15, `currentwaypoint`=0 WHERE `guid`=263151 AND `id`=3248;
