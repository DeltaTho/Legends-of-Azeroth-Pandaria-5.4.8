-- Durotar, Kolkar's blockade road: remove the Corrupted Bloodtalon Scythemaw 3227 (guid 39322), a pre-Cataclysm rare.
--
-- Sourced: warcraft.wiki.gg "Corrupted Bloodtalon Scythemaw": removed in patch 4.0.3a; neither TDB (4.4.2, 12.1.0)
-- spawns 3227 (research\durotar\dossiers\F-spawns.md S3). Applied by the same reasoning as the user's ruling on Warlord
-- Kolkanis (2026-11-23: old rares "shouldn't exist in post-cataclysm"); the user named only Kolkanis, so this is its own
-- commit and can be dropped. Overturns ruling R4 for the Scythemaw.
-- Nothing live needs it: no quest objective, SmartAI or condition names entry 3227, its loot table holds no quest item.
-- The spawn's only dependent is game_event_creature (-26: hidden during Brewfest); no addon, pool, formation, linked
-- respawn, movement override or guid SmartAI uses guid 39322 (deleted anyway for idempotence). The template is kept.

DELETE FROM `creature_addon` WHERE `guid` = 39322;
DELETE FROM `game_event_creature` WHERE `guid` = 39322;
DELETE FROM `game_event_model_equip` WHERE `guid` = 39322;
DELETE FROM `game_event_npcflag` WHERE `guid` = 39322;
DELETE FROM `pool_creature` WHERE `guid` = 39322;
DELETE FROM `creature_formations` WHERE `leaderGUID` = 39322 OR `memberGUID` = 39322;
DELETE FROM `linked_respawn` WHERE `guid` = 39322 OR `linkedGuid` = 39322;
DELETE FROM `creature_movement_override` WHERE `SpawnId` = 39322;
DELETE FROM `smart_scripts` WHERE `entryorguid` = -39322 AND `source_type` = 0;
DELETE FROM `creature` WHERE `guid` = 39322 AND `id` = 3227;
