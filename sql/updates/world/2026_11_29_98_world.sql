-- Northern Barrens nb-fix10 (_98): one Karu.
-- Town NPCs: same-entry copies a few yards apart, from doubles.py (zone 17 vs TDB 1210 + 4.4.2, game-event spawns left out,
-- same phase only), each group checked by hand. SOURCED: a stacked copy (within 8 yd) or an offset copy (unmatched, its
-- retail spot held by a matched spawn within 16 yd) goes; the spawn holding the TDB spot stays. OURS: groups with no TDB spot
-- keep the lowest guid; where the local count is not above retail only stacks of 2 yd or less go; no delete takes an entry
-- below retail. No deleted guid has a formation, guid SmartAI, pool, event, linked respawn, condition or C++ reference.
-- entry name: local -> after (retail); deleted guid (reason)
--   14874 Karu: 2 -> 1 (1)
--     262723 (offset 8.7 yd from 262364, TDB 303750)
DELETE FROM `creature` WHERE `id`=14874 AND `guid` IN (262723);
