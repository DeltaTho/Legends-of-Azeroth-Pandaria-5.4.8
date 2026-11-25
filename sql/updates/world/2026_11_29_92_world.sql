-- Northern Barrens nb-fix9 (_92): one Deviate raptor where the Wailing Caverns hollow had two.
-- The deviate raptors around the Wailing Caverns entrance (area 6511) stood in two layers 2.6-7.3 yd apart: Deviate Slayers
-- 3633 23 (guids 263xxx + 264xxx, 12 each) and Deviate Creepers 3632 17, where TDB 1210 and 4.4.2 (identical) have 12 and 10.
-- _73 had removed a few copies under 1.6 yd. Groups: same-entry spawns within 8 yd.
-- SOURCED (the spawn matched to the TDB spot, nearest first, stays):
--   3633 keep 263311 (TDB 302482 2.9 yd); delete 264056    3633 keep 263330 (TDB 302487 2.3 yd); delete 264091
--   3633 keep 263331 (TDB 302489 3.1 yd); delete 264092    3633 keep 264143 (TDB 302496 0.4 yd); delete 263344
--   3633 keep 263346 (TDB 302513 3.1 yd); delete 264145    3633 keep 263348 (TDB 302517 3.2 yd); delete 264147
--   3633 keep 264149 (TDB 302508 4.2 yd); delete 263349    3633 keep 263355 (TDB 302503 1.8 yd); delete 264157
--   3632 keep 264282 (TDB 302535 2.2 yd); delete 264080    3632 keep 264285 (TDB 302534 1.7 yd); delete 264133
--   3632 keep 264280 (TDB 302531 2.3 yd); delete 264135
-- OURS (no TDB spot within 15 yd; the lower guid stays): 3633 keep 263350, delete 264150; 3632 keep 264160, delete 264276;
--   3632 keep 264208, delete 264274.
-- After: Slayers 14 (TDB 12), Creepers 12 (TDB 10). No addon, path, formation, guid SmartAI, pool, event or linked respawn.
DELETE FROM `creature` WHERE `id`=3633 AND `guid` IN (263344,263349,264056,264091,264092,264145,264147,264150,264157);
DELETE FROM `creature` WHERE `id`=3632 AND `guid` IN (264080,264133,264135,264274,264276);
