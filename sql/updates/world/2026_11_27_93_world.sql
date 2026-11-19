-- Durotar: four townsfolk stand at their posts instead of wandering off.
--
-- Sourced, both TDBs (the same spawns, TDB guids 310258, 310322, 310509, 309589; same position and MovementType 0 in
-- 4.4.2 and 12.1.0):
--   6607 Harroc (250681, Razor Hill outskirts) and 6787 Yelnagi Blackarm (251509, Razor Hill): wandered 3 yd; same spot.
--   40949 Kraka (250729, Dranosh'ar Blockade): wandered 3 yd, about 5 yd off the TDB spot.
--   50004 Jamai (251614, Sen'jin Village trainer): walked a 6-point path that neither TDB has; its spawn point was about 5 yd off the
--   TDB spot.
-- All four get the TDB position and facing, MovementType 0, no wander; Jamai's path (id 251614, used by no other
-- spawn) goes.

UPDATE `creature` SET `position_x` = 587.133, `position_y` = -4892.9, `position_z` = 24.9198, `orientation` = 1.09956,
  `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 250681 AND `id` = 6607;
UPDATE `creature` SET `position_x` = 344.604, `position_y` = -4675.81, `position_z` = 16.5725, `orientation` = 1.01229,
  `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 251509 AND `id` = 6787;
UPDATE `creature` SET `position_x` = 1275.03, `position_y` = -4222.64, `position_z` = 26.7512, `orientation` = 0.476665,
  `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 250729 AND `id` = 40949;
UPDATE `creature` SET `position_x` = -790.064, `position_y` = -4908.5, `position_z` = 19.6062, `orientation` = 0.802851,
  `MovementType` = 0, `wander_distance` = 0, `currentwaypoint` = 0 WHERE `guid` = 251614 AND `id` = 50004;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` = 251614;
DELETE FROM `waypoint_data` WHERE `id` = 251614;
