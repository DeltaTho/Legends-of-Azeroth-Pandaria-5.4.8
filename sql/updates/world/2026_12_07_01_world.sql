-- Durotar, Northwatch Foothold: remove Warlord Kolkanis 5808 (guid 34064), a pre-Cataclysm rare.
--
-- Sourced: warcraft.wiki.gg "Warlord Kolkanis": removed in patch 4.0.3a; neither TDB (4.4.2 cata_classic, retail 12.1.0)
-- spawns 5808 (research\durotar\dossiers\F-spawns.md S3). The user, play-testing 2026-11-23: "Warlord Kolkanis shouldn't
-- exist in post-cataclysm either in that area." This overturns ruling R4 (keep the old rares) for Kolkanis.
-- Nothing live needs him: no quest objective or SmartAI/condition names entry 5808 (quest 1134's objective 5808 is the
-- item Pridewing Venom Sac), and his quest drop 4870 (Carry Your Weight, 791) also drops at 70 % from six other entries
-- (Kul Tiras Sailor/Marine, Kolkar Drudge/Outrunner, Lieutenant Benedict, Sergeant Curtis). No addon, event, pool, formation, linked respawn, movement override or guid SmartAI uses guid 34064;
-- the deletes below cover them anyway so the file stays correct if one is added. The template is kept.

DELETE FROM `creature_addon` WHERE `guid` = 34064;
DELETE FROM `game_event_creature` WHERE `guid` = 34064;
DELETE FROM `game_event_model_equip` WHERE `guid` = 34064;
DELETE FROM `game_event_npcflag` WHERE `guid` = 34064;
DELETE FROM `pool_creature` WHERE `guid` = 34064;
DELETE FROM `creature_formations` WHERE `leaderGUID` = 34064 OR `memberGUID` = 34064;
DELETE FROM `linked_respawn` WHERE `guid` = 34064 OR `linkedGuid` = 34064;
DELETE FROM `creature_movement_override` WHERE `SpawnId` = 34064;
DELETE FROM `smart_scripts` WHERE `entryorguid` = -34064 AND `source_type` = 0;
DELETE FROM `creature` WHERE `guid` = 34064 AND `id` = 5808;
