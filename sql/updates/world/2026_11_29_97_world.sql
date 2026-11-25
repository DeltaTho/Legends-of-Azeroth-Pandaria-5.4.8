-- Northern Barrens nb-fix10 (_97): one Theramore or Southsea where the coast had two.
-- Theramore and Southsea on the coast and at the Merchant Coast: same-entry copies a few yards apart, from doubles.py (zone 17 vs TDB 1210 + 4.4.2, game-event spawns left out,
-- same phase only), each group checked by hand. SOURCED: a stacked copy (within 8 yd) or an offset copy (unmatched, its
-- retail spot held by a matched spawn within 16 yd) goes; the spawn holding the TDB spot stays. OURS: groups with no TDB spot
-- keep the lowest guid; where the local count is not above retail only stacks of 2 yd or less go; no delete takes an entry
-- below retail. No deleted guid has a formation, guid SmartAI, pool, event, linked respawn, condition or C++ reference.
-- entry name: local -> after (retail); deleted guid (reason)
--   3383 Southsea Cutthroat: 25 -> 21 (21)
--     265655 (stacked 1.0 yd from 265696), 265656 (stacked 4.1 yd from 265696), 265693 (stacked 1.0 yd from 265680)
--     265694 (offset 11.9 yd from 265686, TDB 302074)
--   34707 Theramore Deck Hand: 22 -> 18 (16)
--     265508 (stacked 3.0 yd from 265644), 265570 (stacked 5.2 yd from 265523)
--     265641 (offset 9.8 yd from 265644, TDB 302144), 265642 (stacked 4.4 yd from 265505)
--   3385 Theramore Marine: 30 -> 27 (22)
--     265639 (stacked 1.2 yd from 265486), 265643 (stacked 3.8 yd from 265507), 265689 (stacked 7.2 yd from 265432)
--   34706 Theramore Sharpshooter: 7 -> 6 (6)
--     265208 (stacked 3.7 yd from 265066)
--   3386 Theramore Preserver: 12 -> 11 (7)
--     265612 (offset 15.8 yd from 265210, TDB 302086)
--   3384 Southsea Privateer: 12 -> 11 (10)
--     265677 (stacked 4.4 yd from 265695)
DELETE FROM `waypoint_data` WHERE `id` IN (265612,265639);
DELETE FROM `creature_addon` WHERE `guid` IN (265612,265639);
DELETE FROM `creature` WHERE `id`=3383 AND `guid` IN (265655,265656,265693,265694);
DELETE FROM `creature` WHERE `id`=34707 AND `guid` IN (265508,265570,265641,265642);
DELETE FROM `creature` WHERE `id`=3385 AND `guid` IN (265639,265643,265689);
DELETE FROM `creature` WHERE `id`=34706 AND `guid` IN (265208);
DELETE FROM `creature` WHERE `id`=3386 AND `guid` IN (265612);
DELETE FROM `creature` WHERE `id`=3384 AND `guid` IN (265677);
