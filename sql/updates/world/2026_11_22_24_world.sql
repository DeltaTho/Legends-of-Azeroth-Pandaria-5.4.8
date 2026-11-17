-- Burning Steppes: the fettered whelplings of Done Nothing Wrong (28172 / 28417) and the Goblin Flamethrowers at Blackrock
-- Stronghold stand still, as both TDBs.
--
-- Fettered Red / Green / Blue / Bronze Whelpling 47814, 47820, 47821, 47822: chained whelps, three of which (166175, 165974,
-- 166177) walked a 4-point waypoint path; all respawned in 300 s. Both TDBs: idle, 120 s (dossier S1 F-7; plan K1: the doubles
-- were deleted in _20 by S5's guids, this is S1 SQL B's by-entry UPDATE without its deletes). The three paths go with it.
-- Goblin Flamethrower 48153 165489, 165509, 165511, 166326 (the two extra copies were deleted in _20, plan K2): wandered 3 yd;
-- both TDBs idle (S3 28265#4, finding F3).
-- Sourced: movement and respawn (both TDBs). Ours: nothing.

UPDATE `creature` SET `MovementType`=0, `wander_distance`=0, `spawntimesecs`=120 WHERE `id` IN (47814,47820,47821,47822);
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid` IN (166175,165974,166177) AND `path_id`=`guid`;
DELETE FROM `waypoint_data` WHERE `id` IN (166175,165974,166177);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid` IN (165489,165509,165511,166326) AND `id`=48153;
