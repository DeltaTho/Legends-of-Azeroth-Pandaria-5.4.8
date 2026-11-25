-- Northern Barrens nb-fix10 (_96): one Venture Co. where the goblin camps had two.
-- Venture Co. camps outside the Sludge Fen pass: same-entry copies a few yards apart, from doubles.py (zone 17 vs TDB 1210 + 4.4.2, game-event spawns left out,
-- same phase only), each group checked by hand. SOURCED: a stacked copy (within 8 yd) or an offset copy (unmatched, its
-- retail spot held by a matched spawn within 16 yd) goes; the spawn holding the TDB spot stays. OURS: groups with no TDB spot
-- keep the lowest guid; where the local count is not above retail only stacks of 2 yd or less go; no delete takes an entry
-- below retail. No deleted guid has a formation, guid SmartAI, pool, event, linked respawn, condition or C++ reference.
-- entry name: local -> after (retail); deleted guid (reason)
--   3283 Venture Co. Enforcer: 41 -> 26 (24)
--     264454 (stacked 1.7 yd from 264950), 264458 (stacked 0.9 yd from 264887), 264464 (stacked 0.8 yd from 264954)
--     264467 (stacked 0.6 yd from 264955), 264469 (stacked 0.7 yd from 264926), 264471 (stacked 1.9 yd from 264889)
--     264863 (offset 14.4 yd from 264948, TDB 303441), 264879 (stacked 2.8 yd from 264473)
--     264881 (stacked 1.9 yd from 264457), 264883 (stacked 2.9 yd from 264482), 264891 (stacked 0.7 yd from 264926)
--     264892 (stacked 1.4 yd from 264461), 264901 (stacked 1.4 yd from 264463), 264927 (stacked 0.6 yd from 264955)
--     264953 (offset 13.0 yd from 264945, TDB 303450)
--   3286 Venture Co. Overseer: 28 -> 23 (15)
--     264459 (stacked 1.0 yd from 264880), 264462 (stacked 2.2 yd from 264888), 264476 (stacked 3.3 yd from 264882)
--     264870 (stacked 4.1 yd from 264958), 264878 (offset 8.3 yd from 264470, TDB 303471)
--   3284 Venture Co. Drudger: 40 -> 37 (32)
--     264564 (offset 14.0 yd from 264573, TDB 303561), 264791 (offset 10.9 yd from 264793, TDB 303548)
--     264856 (offset 13.9 yd from 264790, TDB 303549)
--   7307 Venture Co. Lookout: 6 -> 4 (3)
--     264546 (stacked 2.4 yd from 264547), 264621 (offset 9.7 yd from 264445, TDB 303587)
--   7067 Venture Co. Drone: 4 -> 2 (2)
--     264525 (offset 10.9 yd from 264666, TDB 303596), 264625 (stacked 2.0 yd from 264624)
--   7308 Venture Co. Patroller: 4 -> 3 (2)
--     264631 (stacked 3.8 yd from 264527)
--   7310 Mutated Venture Co. Drone: 4 -> 3 (2)
--     264542 (stacked 2.7 yd from 264543)
--   7287 Foreman Silixiz: 2 -> 1 (1)
--     264634 (stacked 4.0 yd from 264548)
--   7233 Taskmaster Fizzule: 2 -> 1 (1)
--     264615 (stacked 7.5 yd from 264664)
DELETE FROM `waypoint_data` WHERE `id` IN (264621,264927);
DELETE FROM `creature_addon` WHERE `guid` IN (264564,264621,264631,264791,264856,264927);
DELETE FROM `creature` WHERE `id`=3283 AND `guid` IN (264454,264458,264464,264467,264469,264471,264863,264879,264881,264883,264891,264892,264901,264927,264953);
DELETE FROM `creature` WHERE `id`=3286 AND `guid` IN (264459,264462,264476,264870,264878);
DELETE FROM `creature` WHERE `id`=3284 AND `guid` IN (264564,264791,264856);
DELETE FROM `creature` WHERE `id`=7307 AND `guid` IN (264546,264621);
DELETE FROM `creature` WHERE `id`=7067 AND `guid` IN (264525,264625);
DELETE FROM `creature` WHERE `id`=7308 AND `guid` IN (264631);
DELETE FROM `creature` WHERE `id`=7310 AND `guid` IN (264542);
DELETE FROM `creature` WHERE `id`=7287 AND `guid` IN (264634);
DELETE FROM `creature` WHERE `id`=7233 AND `guid` IN (264615);
