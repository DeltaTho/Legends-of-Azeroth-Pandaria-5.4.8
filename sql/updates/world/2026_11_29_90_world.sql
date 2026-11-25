-- Northern Barrens nb-fix8 (_90): one Overseer Glibby in the Sludge Fen.
-- Overseer Glibby 6606 (named, rank 0, no quest) had three spawns 68-83 yd apart (264599, 264659, 264826), none pooled, so up
-- to three Glibbys were up at once. Both TDBs have one, 303551 at (1103.6,-3171.5), standing.
-- SOURCED: one Glibby; 264826 stays, its spawn and path (6 nodes, (1114.7,-3157.2) to (1115.8,-3140.3)) being nearest the TDB
-- spot (19.1 yd; the others 82.0 and 154.3 yd). OURS: his short path is left as it is (TDB: standing).
-- 264659's own path goes with it. No formation, guid SmartAI, pool, event or linked respawn on either deleted guid.
DELETE FROM `waypoint_data` WHERE `id`=264659;
DELETE FROM `creature_addon` WHERE `guid` IN (264599,264659);
DELETE FROM `creature` WHERE `id`=6606 AND `guid` IN (264599,264659);
