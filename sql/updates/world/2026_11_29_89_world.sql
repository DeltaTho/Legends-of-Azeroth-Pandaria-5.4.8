-- Northern Barrens nb-fix8 (_89): one Venture Co. Drudger / Mercenary where the Sludge Fen had two or three.
-- The Sludge Fen (area 382) held three stacked spawn layers of Venture Co. Drudgers 3284 and Mercenaries 3282 (guids
-- 26455x-26466x, 26468x-26476x, 26477x-26486x): 68 Drudgers and 30 Mercenaries where TDB 1210 and 4.4.2 (identical here) have
-- 28 and 11. _73 already took a fourth copy off four spots (0.1-0.4 yd). Same-entry spawns within 8 yd of each other are
-- grouped (widest group 8.1 yd, most under 4 yd); the later Venture Co. Drudgers 52356 / Mercenaries 52357 are single and stay.
-- SOURCED: in a group with a spawn matched to a TDB spot (nearest first, same entry, 15 yd or less), that spawn stays and the
-- others go:
--   3284 keep 264478 (TDB 303547 4.2 yd); delete 264691
--   3284 keep 264484 (TDB 303541 1.5 yd); delete 264692,264697
--   3282 keep 264563 (TDB 303578 2.4 yd); delete 264645,264779
--   3284 keep 264647 (TDB 303572 1.1 yd); delete 264565,264781
--   3282 keep 264566 (TDB 303574 3.4 yd); delete 264648,264782
--   3284 keep 264569 (TDB 303573 3.6 yd); delete 264650,264784
--   3284 keep 264573 (TDB 303561 1.1 yd); delete 264653,264855
--   3284 keep 264789 (TDB 303564 11.5 yd); delete 264574,264654
--   3284 keep 264790 (TDB 303549 1.7 yd); delete 264575*
--   3282 keep 264577 (TDB 303550 0.5 yd); delete 264792*
--   3284 keep 264793 (TDB 303548 0.4 yd); delete 264578*
--   3284 keep 264794 (TDB 303577 1.0 yd); delete 264580,264655
--   3284 keep 264795 (TDB 303571 1.4 yd); delete 264581,264656
--   3282 keep 264811 (TDB 303540 2.2 yd); delete 264589
--   3284 keep 264746 (TDB 303552 2.0 yd); delete 264636
--   3282 keep 264749 (TDB 303555 10.5 yd); delete 264637
--   3284 keep 264638 (TDB 303511 1.7 yd); delete 264750
--   3284 keep 264639 (TDB 303507 1.9 yd); delete 264756
--   3284 keep 264765 (TDB 303510 0.3 yd); delete 264640
--   3284 keep 264641 (TDB 303570 2.1 yd); delete 264836
--   3284 keep 264861 (TDB 303531 1.2 yd); delete 264810
--   3284 keep 264858 (TDB 303521 2.0 yd); delete 264812
-- OURS: groups with no TDB spot within 15 yd keep the lowest guid:
--   3282 keep 264557; delete 264642,264771,264837
--   3284 keep 264564; delete 264646,264780,264838
--   3284 keep 264567; delete 264649
--   3282 keep 264572; delete 264652,264787
--   3282 keep 264598; delete 264658,264825,264857*
--   3284 keep 264635; delete 264744
--   3284 keep 264651; delete 264786
--   3282 keep 264660; delete 264827
--   3284 keep 264661; delete 264828
--   3284 keep 264662; delete 264829 (264829 was the copy _73 kept over 264862)
--   3282 keep 264698; delete 264699
-- * = had its own waypoint path (path_id = guid), removed with it. No deleted guid has a formation, guid SmartAI, pool, event,
-- linked respawn or another spawn using its path. Left: 49 deleted, 55 Venture Co. spawns against 45 in the TDBs.
DELETE FROM `waypoint_data` WHERE `id` IN (264575,264578,264792,264857);
DELETE FROM `creature_addon` WHERE `guid` IN (264565,264574,264575,264578,264580,264581,264636,264640,264646,264649,264650,264653,
  264654,264655,264656,264691,264692,264697,264744,264750,264756,264780,264781,264784,264786,264792,264810,264812,264828,264829,
  264836,264838,264855,264857,264589,264637,264642,264645,264648,264652,264658,264699,264771,264779,264782,264787,264825,264827,
  264837);
DELETE FROM `creature` WHERE `id`=3282 AND `guid` IN (264589,264637,264642,264645,264648,264652,264658,264699,264771,264779,264782,
  264787,264792,264825,264827,264837,264857);
DELETE FROM `creature` WHERE `id`=3284 AND `guid` IN (264565,264574,264575,264578,264580,264581,264636,264640,264646,264649,264650,
  264653,264654,264655,264656,264691,264692,264697,264744,264750,264756,264780,264781,264784,264786,264810,264812,264828,264829,
  264836,264838,264855);
