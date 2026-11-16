-- Searing Gorge, Rise, Obsidion 28056 (plan E-6; dossier cauldron-finale 28056 rows 1-9, F7, F8; ruling R-8).
--
-- Blocking: the Altar of Suntara's option (menu 1282, BroadcastText 4401) was conditioned on the retired 3566 "Rise, Obsidion!"
-- and never showed. Also wrong: Obsidion 8400 lay on the floor attackable; a static Lathoric 8391 patrolled and could be killed
-- without the altar; the altar started the pre-Cataclysm Dorius chain, whose first row (an OOC no-repeat timer aimed at a
-- Dorius who does not exist) fired once at server start, so Lathoric was never summoned; and after one evade Obsidion stayed
-- IMMUNE_TO_PC for good (SmartAI's evade keeps unit flags; only that broken chain cleared it).
--
-- Now (the Cataclysm sequence, without the TDB's Dorius prelude, R-8): Obsidion lies on the floor, immune to players and
-- passive. With 28056 in progress the altar shows its option; picking it summons Lathoric beside the altar (TDB summon point,
-- 300 s out of combat), who says "You are here to stop the Archduke?" (47647), turns hostile, attacks the player, says "Fools.
-- Obsidion!  Rise, and destroy the interlopers!" (47805) and wakes Obsidion, who stands up and attacks the same player. Both
-- kills count. After a wipe Lathoric despawns and Obsidion lies down again, immune and passive (on every reset: evade and
-- respawn); the altar works again once no Lathoric is within 100 yd (TDB conditions 22/1/148498).
-- Sourced: the condition's quest (TDB quest 28056 in progress), the yells and their order, Obsidion lying immune (TDB
-- unit_flags 256, comments 2011-01-20 [+8], 2012-07-04 [+3]), Lathoric's faction 14 (TDB 839100), the summon point and 300 s
-- (TDB 842100), the one-at-a-time condition. Ours: the delays (1 s, 1.5 s), "passive" next to IMMUNE_TO_PC (IMMUNE_TO_PC alone
-- does not stop a creature attacking players in this core). Abilities: unchanged (the 2026_10_29 abilities rows, renumbered).
-- Nothing here relies on an evade clearing an aura (SmartAI keeps self-cast auras through an evade): Obsidion's immunity is a
-- unit flag set again by the reset rows.

-- the option while the quest is in progress
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 1282 AND `SourceEntry` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,1282,0,0,0,47,0,28056,8,0,0,0,0,'','Altar of Suntara - show option while Rise, Obsidion is in progress');

-- Obsidion lies immune to players (both TDBs)
UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 256 WHERE `entry` = 8400;

-- the static Lathoric and his path (both TDBs: summoned only)
DELETE FROM `waypoint_data` WHERE `id` = 313221;
DELETE FROM `creature_addon` WHERE `guid` = 313221;
DELETE FROM `creature` WHERE `guid` = 313221 AND `id` = 8391;

UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI', `ScriptName` = '' WHERE `entry` = 148498;
UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (8391, 8400);
DELETE FROM `smart_scripts` WHERE `entryorguid` = 148498 AND `source_type` = 1;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (8391, 8400) AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 839100 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(148498,1,0,0,62,0,100,0,1282,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Altar of Suntara - On Gossip Option 0 Selected - Close Gossip (always)'),
(148498,1,1,2,62,0,100,0,1282,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Altar of Suntara - On Gossip Option 0 Selected - Store Invoker (no Lathoric near)'),
(148498,1,2,3,61,0,100,0,0,0,0,0,0,12,8391,4,300000,0,0,0,8,0,0,0,0,-6474.70,-1245.67,180.246,0,'Altar of Suntara - Summon Lathoric the Black (TDB point, 300 s out of combat)'),
(148498,1,3,0,61,0,100,0,0,0,0,0,0,100,1,0,0,0,0,0,19,8391,30,0,0,0,0,0,0,'Altar of Suntara - Send Stored Target to Lathoric'),
(8391,0,0,0,63,0,100,0,0,0,0,0,0,80,839100,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lathoric the Black - On Just Created - Run Script'),
(8391,0,1,0,7,0,100,0,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lathoric the Black - On Evade - Despawn'),
(8391,0,2,0,0,0,100,0,0,0,3400,4700,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lathoric the Black - In Combat - Cast Shadow Bolt'),
(8391,0,3,0,0,0,100,0,6000,9000,15000,17000,0,11,32063,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lathoric the Black - In Combat - Cast Corruption'),
(839100,9,0,0,0,0,100,0,1000,1000,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lathoric the Black - Script - Say 0 (47647)'),
(839100,9,1,0,0,0,100,0,1500,1500,0,0,0,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lathoric the Black - Script - Set Faction 14'),
(839100,9,2,0,0,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Lathoric the Black - Script - Attack Stored Target'),
(839100,9,3,0,0,0,100,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lathoric the Black - Script - Say 1 (47805)'),
(839100,9,4,0,0,0,100,0,0,0,0,0,0,100,1,0,0,0,0,0,19,8400,60,0,0,0,0,0,0,'Lathoric the Black - Script - Send Target to Obsidion'),
(839100,9,5,0,0,0,100,0,0,0,0,0,0,45,0,1,0,0,0,0,19,8400,60,0,0,0,0,0,0,'Lathoric the Black - Script - Wake Obsidion (data 0 1)'),
(8400,0,0,1,25,0,100,0,0,0,0,0,0,90,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Obsidion - On Reset - Lie Down'),
(8400,0,1,2,61,0,100,0,0,0,0,0,0,18,256,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Obsidion - On Reset - Immune to Players'),
(8400,0,2,0,61,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Obsidion - On Reset - Passive'),
(8400,0,3,4,38,0,100,0,0,1,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Obsidion - On Data 0 1 - Stand Up'),
(8400,0,4,5,61,0,100,0,0,0,0,0,0,19,256,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Obsidion - On Data 0 1 - Attackable'),
(8400,0,5,6,61,0,100,0,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Obsidion - On Data 0 1 - Aggressive'),
(8400,0,6,0,61,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Obsidion - On Data 0 1 - Attack Stored Target'),
(8400,0,7,0,9,0,100,0,0,10,20000,30000,0,11,12734,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Obsidion - Within 0-10 Range - Cast Ground Smash'),
(8400,0,8,0,9,0,100,0,0,5,15000,30000,0,11,10101,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Obsidion - Within 0-5 Range - Cast Knock Away'),
(8400,0,9,0,0,0,100,0,5000,8000,18000,20000,0,11,84165,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Obsidion - In Combat - Cast Flame Blast');

-- one Lathoric at a time (TDB 22/1/148498, here on row 1: SourceGroup = id + 1). The gossip always closes (row 0, its own
-- event): conditions are checked only on a row's own event, never on its linked rows, so a blocked row 1 stops its chain
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceGroup` IN (1,2) AND `SourceEntry` = 148498;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,2,148498,1,0,29,0,8391,100,0,1,0,0,'','Altar of Suntara - summon only if Lathoric the Black is not near');
