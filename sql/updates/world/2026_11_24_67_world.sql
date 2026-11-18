-- Blasted Lands, the Rockpool march (Atrocities 25703 and the zone's story; ruling K4): enslaved Rockpool murlocs drag crates of
-- tadpoles from Rockpool Village along the beach to Bloodwash Cavern (and some to Bloodwash Shrine), without end.
-- Sourced: "long line stretching to the horizon, mostly little helpless tadpoles" (25703 2010-12-04 [+16]); "an endless line of
-- enslaved murlocs, dragging their babies across the desert" (25707 2013-03-01 [+8]); "as these murloc despawn, you are watching
-- an entire people vanish" (25706 2012-06-23 [+4]); the spawner 41359 (both TDBs, idle) and its three summon spells 77476
-- crate 41362 / 77481 murloc 41357 / 77480 tadpole 41358 (DBC); the crate's riders, a puller 41384 in front and three tadpoles
-- 41385 on top (TDB 4.4.2 = 12.1.0: 30 pullers each with a tadpole triplet 2.5 yd behind at +1.55); the
-- route (2518 points of mop's sniffed walker paths, exported to research/blasted-lands/tmp/S5/rockpool_waypoints_export.tsv
-- and rockpool_spawns_export.tsv before this delete): one trunk south-west along the beach, a fork, Bloodwash Cavern (705 yd)
-- or Bloodwash Shrine (580 yd); the drag pace (speed_walk 0.8 on 41384 / 41385 in both TDBs).
-- mop-only data, design ours: the crate's vehicle 822 (neither TDB spawns 41362; its seat geometry matches the TDB's pullers and
-- triplets exactly) and the riders seated on it as accessories.
-- Ours: the rates (a crate every 13 s, a murloc or tadpole on foot every 5 s; one in seven to the shrine), the line already
-- walking when a player arrives, and the march running only while a player stands in its areas 5078-5082, stopping 3 minutes
-- after the last one leaves (npc_bloodwash_crate_spawner, player_rockpool_march_watch).
-- The 467 static copies of the walkers and riders go with every row that refers to them (their 2518 waypoint rows and 331
-- addon rows; no pool, event, formation, linked-respawn, movement-override or guid SmartAI rows exist, deleted for safety).
DELETE FROM `waypoint_data` WHERE `id` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454));
DELETE FROM `waypoint_data` WHERE `id` IN (SELECT `path_id` FROM `creature_addon` WHERE `path_id` <> 0 AND `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454)));
DELETE FROM `creature_addon` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454));
DELETE FROM `pool_creature` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454));
DELETE FROM `game_event_creature` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454));
DELETE FROM `creature_formations` WHERE `memberGUID` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454))
                                     OR `leaderGUID` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454));
DELETE FROM `linked_respawn` WHERE `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454))
                                OR `linkedGuid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454));
DELETE FROM `creature_movement_override` WHERE `SpawnId` IN (SELECT `guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454));
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (SELECT -`guid` FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454));
DELETE FROM `creature` WHERE `id` IN (41357, 41358, 41362, 41384, 41385, 41454);   -- 142 + 138 + 50 + 49 + 87 + 1 (the copy of 41454 adrift)

-- the spawner idle (both TDBs) and the march's scripts
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 41359;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_bloodwash_crate_spawner' WHERE `entry` = 41359;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_rockpool_marcher' WHERE `entry` IN (41357, 41358, 41362);
UPDATE `creature_template` SET `speed_walk` = 0.8, `speed_run` = 0.285714 WHERE `entry` IN (41357, 41358, 41362);   -- the drag pace (mop already so)

-- the march crate's riders: the puller in seat 0, three tadpoles on top; the ride rows seat them and only them
DELETE FROM `vehicle_template_accessory` WHERE `entry` = 41362;
INSERT INTO `vehicle_template_accessory` (`entry`, `accessory_entry`, `seat_id`, `minion`, `description`, `summontype`, `summontimer`) VALUES
(41362, 41384, 0, 1, 'Bloodwash Crate - Rockpool Murloc pulling', 6, 30000),
(41362, 41385, 1, 1, 'Bloodwash Crate - Rockpool Tadpole', 6, 30000),
(41362, 41385, 2, 1, 'Bloodwash Crate - Rockpool Tadpole', 6, 30000),
(41362, 41385, 3, 1, 'Bloodwash Crate - Rockpool Tadpole', 6, 30000);
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 41362 AND `spell_id` = 46598;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES (41362, 46598, 1, 0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` = 41362 AND `SourceEntry` = 46598;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(18, 41362, 46598, 0, 0, 31, 0, 3, 41384, 0, 0, 0, 0, '', 'Bloodwash Crate - its murloc rides by click'),
(18, 41362, 46598, 0, 1, 31, 0, 3, 41385, 0, 0, 0, 0, '', 'Bloodwash Crate - its tadpoles ride by click');
