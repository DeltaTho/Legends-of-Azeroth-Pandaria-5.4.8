-- Blasted Lands (zone 4): Teremus the Devourer 7846 imported three times on one spot (section F, Part B).
-- Sourced: the rows themselves: 1343, 83337 and 87296 stand at (-11685.9,-2955.42,7.736), each with its own copy of one 86-point
--   path, all in pool 326 (chances 0 / 40 / 0). Keep 1343 and its path; delete the two copies and their paths. Wowhead MoP Classic
--   pins Teremus along that path. Pool 326 is rebuilt by 2026_11_24_88.

DELETE FROM `waypoint_data` WHERE `id` IN (83337,87296);
DELETE FROM `creature_addon` WHERE `guid` IN (83337,87296);
DELETE FROM `pool_creature` WHERE `guid` IN (83337,87296);
DELETE FROM `game_event_creature` WHERE `guid` IN (83337,87296);
DELETE FROM `game_event_model_equip` WHERE `guid` IN (83337,87296);
DELETE FROM `game_event_npc_vendor` WHERE `guid` IN (83337,87296);
DELETE FROM `game_event_npcflag` WHERE `guid` IN (83337,87296);
DELETE FROM `vehicle_accessory` WHERE `guid` IN (83337,87296);
DELETE FROM `creature_movement_override` WHERE `SpawnId` IN (83337,87296);
DELETE FROM `creature_formations` WHERE `memberGUID` IN (83337,87296) OR `leaderGUID` IN (83337,87296);
DELETE FROM `linked_respawn` WHERE `guid` IN (83337,87296) OR `linkedGuid` IN (83337,87296);
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-83337,-87296);
DELETE FROM `creature` WHERE `id`=7846 AND `guid` IN (83337,87296); -- Teremus the Devourer x2
