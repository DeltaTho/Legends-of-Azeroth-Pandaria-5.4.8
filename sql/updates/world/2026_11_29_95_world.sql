-- Northern Barrens nb-fix10 (_95): one Razormane, Kolkar, harpy or Burning Blade where the camps had two.
-- Razormane, Kolkar, Witchwing and Burning Blade camps and the Mor'shan Ashenvale Skirmishers: same-entry copies a few yards apart, from doubles.py (zone 17 vs TDB 1210 + 4.4.2, game-event spawns left out,
-- same phase only), each group checked by hand. SOURCED: a stacked copy (within 8 yd) or an offset copy (unmatched, its
-- retail spot held by a matched spawn within 16 yd) goes; the spawn holding the TDB spot stays. OURS: groups with no TDB spot
-- keep the lowest guid; where the local count is not above retail only stacks of 2 yd or less go; no delete takes an entry
-- below retail. No deleted guid has a formation, guid SmartAI, pool, event, linked respawn, condition or C++ reference.
-- entry name: local -> after (retail); deleted guid (reason)
--   34503 Razormane Pillager: 48 -> 36 (13)
--     262639 (stacked 7.1 yd from 262638), 263077 (stacked 6.2 yd from 262638)
--     263084 (offset 8.1 yd from 263100, TDB 303727), 263103 (stacked 3.4 yd from 263014)
--     263144 (stacked 6.1 yd from 262638), 263145 (offset 10.0 yd from 262642, TDB 303736)
--     263153 (stacked 6.4 yd from 263146), 264261 (stacked 5.0 yd from 263013), 264262 (stacked 6.1 yd from 263017)
--     264267 (stacked 3.2 yd from 263012), 264269 (stacked 8.0 yd from 263019), 264377 (stacked 4.0 yd from 264268)
--   3272 Kolkar Wrangler: 51 -> 42 (42)
--     263788 (offset 11.6 yd from 264309, TDB 302656), 264057 (stacked 4.9 yd from 264058)
--     264077 (stacked 5.9 yd from 264046), 264310 (stacked 1.6 yd from 263789), 264313 (stacked 4.7 yd from 264186)
--     264317 (stacked 1.4 yd from 264075), 264320 (stacked 1.1 yd from 264076), 264329 (stacked 4.6 yd from 264082)
--     265214 (stacked 4.5 yd from 265083)
--   3267 Razormane Plunderer: 33 -> 25 (14)
--     253261 (stacked 2.6 yd from 262516), 262557 (stacked 2.5 yd from 262614), 262575 (stacked 6.3 yd from 262560)
--     262579 (stacked 3.6 yd from 262561), 262580 (stacked 2.8 yd from 262614), 262584 (stacked 6.6 yd from 262556)
--     262598 (offset 10.6 yd from 262517, TDB 304019), 262599 (offset 9.1 yd from 262489, TDB 304013)
--   3273 Kolkar Stormer: 37 -> 32 (32)
--     264043 (stacked 7.2 yd from 264327), 264044 (stacked 2.0 yd from 264328)
--     264177 (offset 14.5 yd from 264125, TDB 302793), 264179 (stacked 0.9 yd from 264314)
--     264319 (stacked 1.6 yd from 264126)
--   33193 Ashenvale Skirmisher: 27 -> 24 (37)
--     238572 (stacked 1.6 yd from 238162), 264366 (stacked 0.9 yd from 264362), 264368 (stacked 0.5 yd from 238571)
--   3275 Kolkar Marauder: 19 -> 16 (16)
--     263840 (stacked 1.3 yd from 265359), 263842 (stacked 2.8 yd from 265377), 265352 (stacked 0.7 yd from 263839)
--   34545 Razormane Frenzy: 28 -> 25 (23)
--     262399 (stacked 6.1 yd from 262805), 262902 (stacked 2.9 yd from 262459), 262957 (stacked 3.5 yd from 262905)
--   3276 Witchwing Harpy: 24 -> 22 (19)
--     264232 (offset 13.5 yd from 263986, TDB 303039), 264343 (stacked 2.6 yd from 264231)
--   4316 Kolkar Packhound: 12 -> 10 (6)
--     265008 (stacked 4.1 yd from 265007), 265455 (stacked 5.3 yd from 265314)
--   3379 Burning Blade Bruiser: 23 -> 22 (28)
--     264376 (stacked 0.5 yd from 263860)
--   3277 Witchwing Roguefeather: 22 -> 21 (19)
--     263635 (offset 14.8 yd from 264239, TDB 303064)
--   3265 Razormane Hunter: 27 -> 26 (16)
--     262617 (stacked 6.6 yd from 262581)
--   3268 Razormane Thornweaver: 9 -> 8 (5)
--     262632 (stacked 4.0 yd from 263056)
--   9523 Kolkar Stormseer: 14 -> 13 (13)
--     264007 (stacked 2.6 yd from 264296)
DELETE FROM `waypoint_data` WHERE `id` IN (263145,263153,263635,264179,264319,264366,264368,264376,265455);
DELETE FROM `creature_addon` WHERE `guid` IN (262399,262617,262902,262957,263145,263153,263635,263788,263840,263842,264043,264044,264057,264077,264177,264179,264232,264310,264313,264317,264319,264320,264329,264343,264366,264368,264376,265214,265352,265455);
DELETE FROM `creature` WHERE `id`=34503 AND `guid` IN (262639,263077,263084,263103,263144,263145,263153,264261,264262,264267,264269,264377);
DELETE FROM `creature` WHERE `id`=3272 AND `guid` IN (263788,264057,264077,264310,264313,264317,264320,264329,265214);
DELETE FROM `creature` WHERE `id`=3267 AND `guid` IN (253261,262557,262575,262579,262580,262584,262598,262599);
DELETE FROM `creature` WHERE `id`=3273 AND `guid` IN (264043,264044,264177,264179,264319);
DELETE FROM `creature` WHERE `id`=33193 AND `guid` IN (238572,264366,264368);
DELETE FROM `creature` WHERE `id`=3275 AND `guid` IN (263840,263842,265352);
DELETE FROM `creature` WHERE `id`=34545 AND `guid` IN (262399,262902,262957);
DELETE FROM `creature` WHERE `id`=3276 AND `guid` IN (264232,264343);
DELETE FROM `creature` WHERE `id`=4316 AND `guid` IN (265008,265455);
DELETE FROM `creature` WHERE `id`=3379 AND `guid` IN (264376);
DELETE FROM `creature` WHERE `id`=3277 AND `guid` IN (263635);
DELETE FROM `creature` WHERE `id`=3265 AND `guid` IN (262617);
DELETE FROM `creature` WHERE `id`=3268 AND `guid` IN (262632);
DELETE FROM `creature` WHERE `id`=9523 AND `guid` IN (264007);
