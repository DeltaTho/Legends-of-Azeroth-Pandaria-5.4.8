-- Northern Barrens nb-fix9 (_93): one Sunscale raptor where the zone had two.
-- Zone-wide check of the Sunscale raptors against TDB 1210 / 4.4.2 (identical): same-entry spawns within 8 yd, plus a second
-- copy of a retail spawn (an unmatched spawn whose nearest TDB spot, within 25 yd, is already held by a matched spawn no more
-- than 16 yd from it; retail Screechers wander 15 yd, Scytheclaws 10). King Reaperclaw and his consorts are left alone.
-- SOURCED (the spawn matched to the TDB spot, nearest first within 20 yd, stays):
--   Lashtail 3254:   keep 265552 (TDB 301778 6.7 yd), delete 265236 (3.3 yd away); keep 265271 (TDB 301772 6.9), delete 265546
--                    (2.6); keep 265550 (TDB 301776 3.0), delete 265334 (7.4); keep 265533 (TDB 301759), delete 265269 (10.4).
--   Screecher 3255:  keep 264410 (TDB 303396 1.5), delete 263516 (5.6); keep 265146 (TDB 302256), delete 263294 (9.4);
--                    keep 264402 (TDB 303400), delete 263499 (12.5); keep 264409 (TDB 303394), delete 263515 (13.8);
--                    keep 265013 (TDB 302573), delete 263765 (14.4); keep 263514 (TDB 303364), delete 264408 (15.0).
--   Scytheclaw 3256: keep 265491 (TDB 302164), delete 262802 (12.6).
--   Sunscale Raptor 44167: keep 262483 (TDB 303347 12.7 yd, the only one in either TDB), delete 264866 (11.2 from it, 22 from
--                    the TDB spot).
-- OURS (no TDB spot of the entry nearby; the lower guid stays):
--   Screecher 3255:  keep 263374, delete 265442 (6.5); keep 265222, delete 265253 (5.7).
--   Scytheclaw 3256 (all stand still here): keep 264644, delete 264775 (6.1); keep 264643, delete 264774 (9.3); keep 264555,
--                    delete 264759 (8.6; the two paced mirror-image 4-node paths over the same spot in the Sludge Fen; its path
--                    goes with it).
-- No other addon, formation, guid SmartAI, pool, event or linked respawn on the deleted guids.
DELETE FROM `waypoint_data` WHERE `id`=264759;
DELETE FROM `creature_addon` WHERE `guid`=264759;
DELETE FROM `creature` WHERE `id`=3254 AND `guid` IN (265236,265269,265334,265546);
DELETE FROM `creature` WHERE `id`=3255 AND `guid` IN (263294,263499,263515,263516,263765,264408,265253,265442);
DELETE FROM `creature` WHERE `id`=3256 AND `guid` IN (262802,264759,264774,264775);
DELETE FROM `creature` WHERE `id`=44167 AND `guid`=264866;
