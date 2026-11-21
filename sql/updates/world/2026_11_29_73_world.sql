-- Northern Barrens (zone 17), scope I-D / I-E1: same-entry doubles and Midsummer doubles.
-- I-D: 30 doubles less than 1.6 yd apart, plus four Venture Co. Drudgers 3284 (264783 on 264567, 264788 on 264573, 264830 on
--   264663, 264862 on 264829, 0.1-0.4 yd apart; the first of each pair goes, as in layers.md; review round 2026-11-21), (the copy farther from the nearest sniffed spot goes; list in tmp\I\dupdel.txt), plus
--   Gargok 19910 (Warsong Gulch battlemaster, Mor'shan): 71836 stands 2.9 yd from 263429, which is the spot both TDBs have
--   (303146 at 1034.16,-2092.87); both are linked to event 19 (Call to Arms: Warsong Gulch), so two battlemasters appeared. Ours:
--   found by the paired-service check, not by the 1.6 yd scan. (35216, also a double, goes with the rares in _71.)
-- I-E1: Midsummer copies 369887-369890 (16781), 369804 (16592), 369805 (26355), 369826 (25994) sit 0.0 yd on 352xxx spawns, both
--   linked to event 1, so every Midsummer showed bonfire and celebrants twice. Zone-only here; the DB-wide delete of backport D3
--   should skip them.
DELETE FROM `game_event_creature` WHERE `guid` IN (369887,369888,369889,369890,369804,369805,369826,71836);
DELETE FROM `waypoint_data` WHERE `id` IN (263731,264051,264673);
DELETE FROM `creature_addon` WHERE `guid` IN (262833,263376,265120,265295,262461,262830,262831,262841,262854,262855,263116,264283,264161,263736,264051,264055,263357,263235,263731,263324,264526,264665,263800,262424,238268,263624,264673,265143,265182,265657,71836,264783,264788,264830,264862,369887,369888,369889,369890,369804,369805,369826);
DELETE FROM `creature` WHERE `id`=3241 AND `guid` IN (262833,263376);
DELETE FROM `creature` WHERE `id`=3254 AND `guid` IN (265120);
DELETE FROM `creature` WHERE `id`=3255 AND `guid` IN (265295);
DELETE FROM `creature` WHERE `id`=3269 AND `guid` IN (262461);
DELETE FROM `creature` WHERE `id`=3284 AND `guid` IN (264783,264788,264830,264862);
DELETE FROM `creature` WHERE `id`=3416 AND `guid` IN (262830,262831,262841,262854,262855,263116);
DELETE FROM `creature` WHERE `id`=3630 AND `guid` IN (264283);
DELETE FROM `creature` WHERE `id`=3632 AND `guid` IN (264161);
DELETE FROM `creature` WHERE `id`=3633 AND `guid` IN (263736,264051,264055,263357);
DELETE FROM `creature` WHERE `id`=3641 AND `guid` IN (263235);
DELETE FROM `creature` WHERE `id`=3835 AND `guid` IN (263731,263324);
DELETE FROM `creature` WHERE `id`=7067 AND `guid` IN (264526,264665);
DELETE FROM `creature` WHERE `id`=9523 AND `guid` IN (263800);
DELETE FROM `creature` WHERE `id`=10685 AND `guid` IN (262424);
DELETE FROM `creature` WHERE `id`=16592 AND `guid` IN (369804);
DELETE FROM `creature` WHERE `id`=16781 AND `guid` IN (369887,369888,369889,369890);
DELETE FROM `creature` WHERE `id`=19910 AND `guid` IN (71836);
DELETE FROM `creature` WHERE `id`=25994 AND `guid` IN (369826);
DELETE FROM `creature` WHERE `id`=26355 AND `guid` IN (369805);
DELETE FROM `creature` WHERE `id`=33201 AND `guid` IN (238268);
DELETE FROM `creature` WHERE `id`=34640 AND `guid` IN (263624,264673,265143,265182);
DELETE FROM `creature` WHERE `id`=44168 AND `guid` IN (265657);
