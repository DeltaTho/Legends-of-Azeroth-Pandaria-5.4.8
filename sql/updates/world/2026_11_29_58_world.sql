-- Northern Barrens, Read the Manual (14006): Sputtervalve's samophlange scene after the turn-in (dossier H, H10; coverage
-- audit 4.7), and his faction and spot (H11, both TDBs).
-- Sourced: the order, speakers and texts (Wowhead 14006 comment 2010-11-25 [+26]; broadcast 34947 34948 34961 34962 34964
-- 34965 34963); the wiki's staging: "Sputtervalve runs to the center of camp, places the samophlange in front of him and starts
-- hammering away at it with a wrench. Brak Blusterpipe runs up to watch", Nozzlepot comes, "the samophlange explodes (again),
-- knocking back the three goblins"; faction 2160 and his spot (1140.92, -3376.76, 92.54, 5.11) from both TDBs.
-- Ours: the spots (centre of camp between the three, ground z from the 5.4.8 maps), the timings, the 15 s he stays after the
-- reward (the 29094 pop-up needs him within interaction range), the placed object = Samophlange 162024 (same model 2911;
-- summoned for 19 s, so it is gone with the explosion, and with him if he dies), the explosion (Cosmetic - Explosion 60081 +
-- Billowing Smoke Cloud 78608), the knock-back (Knockback Self 5, 66033, cast by each goblin facing the samophlange: pushed
-- back about 10 yd), the walks home (lines only on arrival, facing only on arrival: exact spots).
-- Not used: 79948 Summon Samophlange - it summons GO 204091 "Induction Samophlange", a lootable chest (lock 43, loot 58224 /
-- 64584) whose items are Azshara quest objectives (26361 30174 30359 28593 28595) and which spawns only in Azshara: summoned
-- here it would hand out those items.
-- Re-checked: Sputtervalve's SmartAI ids 0-1 / actionlist 344200 belong to 29024 and 6981; Brak's ids 0-6 / 3467400 to his
-- port; ids 3442 2-4, 344201-344202, 34674 7-12 and Nozzlepot 34698 (no AI before) are free; Brak has text group 0 only.
DELETE FROM `creature_text` WHERE (`CreatureID`=3442 AND `GroupID` IN (2,3,4,5)) OR (`CreatureID`=34674 AND `GroupID`=1) OR (`CreatureID`=34698 AND `GroupID` IN (0,1));
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT CASE `ID` WHEN 34961 THEN 34674 WHEN 34964 THEN 34698 WHEN 34965 THEN 34698 ELSE 3442 END,
       CASE `ID` WHEN 34947 THEN 2 WHEN 34948 THEN 3 WHEN 34962 THEN 4 WHEN 34963 THEN 5 WHEN 34961 THEN 1 WHEN 34964 THEN 0 ELSE 1 END,
       0, `Text`, 12, 0, 100, 0, 0, 0, 0, `ID`, 0, 'Read the Manual rewarded'
FROM `broadcast_text` WHERE `ID` IN (34947,34948,34961,34962,34963,34964,34965);
UPDATE `creature_template` SET `AIName`='SmartAI', `ScriptName`='' WHERE `entry` IN (3442,34698);
DELETE FROM `smart_scripts` WHERE (`entryorguid`=3442 AND `source_type`=0 AND `id` IN (2,3,4)) OR (`entryorguid` IN (344201,344202) AND `source_type`=9)
  OR (`entryorguid`=34674 AND `source_type`=0 AND `id` IN (7,8,9,10,11,12)) OR (`entryorguid`=34698 AND `source_type`=0);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3442,0,2,0,20,0,100,0,14006,0,0,0,0,80,344201,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Quest ''Read the Manual'' Rewarded - Run Script'),
(3442,0,3,0,34,0,100,0,8,1,0,0,0,80,344202,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Reached Point 1 (centre of camp) - Run Script'),
(3442,0,4,0,34,0,100,0,8,2,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,5.11381,'Sputtervalve - On Reached Point 2 (home) - Set Orientation'),
(344201,9,0,0,0,0,100,0,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Say Line 2'),
(344201,9,1,0,0,0,100,0,15000,15000,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Set Run On'),
(344201,9,2,0,0,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,8,0,0,0,0,1150.6,-3386.2,91.79,0,'Sputtervalve - On Script - Move To Centre Of Camp (point 1)'),
(344202,9,0,0,0,0,100,0,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,5.64,'Sputtervalve - On Script - Face The Samophlange Spot'),
(344202,9,1,0,0,0,100,0,0,0,0,0,0,50,162024,19,0,0,0,0,8,0,0,0,0,1153.0,-3388.0,91.72,2.5,'Sputtervalve - On Script - Place Samophlange (19 s, gone with the explosion)'),
(344202,9,2,0,0,0,100,0,1000,1000,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Say Line 3'),
(344202,9,3,0,0,0,100,0,0,0,0,0,0,5,173,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Play Emote 173 (work)'),
(344202,9,4,0,0,0,100,0,1000,1000,0,0,0,45,0,1,0,0,0,0,19,34674,40,0,0,0,0,0,0,'Sputtervalve - On Script - Set Data 0 1 (Brak runs up)'),
(344202,9,5,0,0,0,100,0,4000,4000,0,0,0,1,1,0,0,0,0,0,19,34674,40,0,0,0,0,0,0,'Sputtervalve - On Script - Say Line 1 (Brak Blusterpipe)'),
(344202,9,6,0,0,0,100,0,5000,5000,0,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Say Line 4'),
(344202,9,7,0,0,0,100,0,1000,1000,0,0,0,45,0,1,0,0,0,0,19,34698,40,0,0,0,0,0,0,'Sputtervalve - On Script - Set Data 0 1 (Nozzlepot runs up)'),
(344202,9,8,0,0,0,100,0,4000,4000,0,0,0,1,0,0,0,0,0,0,19,34698,40,0,0,0,0,0,0,'Sputtervalve - On Script - Say Line 0 (Nozzlepot)'),
(344202,9,9,0,0,0,100,0,3000,3000,0,0,0,11,60081,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Cast Cosmetic - Explosion'),
(344202,9,10,0,0,0,100,0,0,0,0,0,0,11,78608,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Cast Billowing Smoke Cloud'),
(344202,9,11,0,0,0,100,0,0,0,0,0,0,11,66033,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Cast Knockback Self 5'),
(344202,9,12,0,0,0,100,0,0,0,0,0,0,86,66033,2,19,34674,40,0,19,34674,40,0,0,0,0,0,0,'Sputtervalve - On Script - Cross Cast Knockback Self 5 (Brak Blusterpipe)'),
(344202,9,13,0,0,0,100,0,0,0,0,0,0,86,66033,2,19,34698,40,0,19,34698,40,0,0,0,0,0,0,'Sputtervalve - On Script - Cross Cast Knockback Self 5 (Nozzlepot)'),
(344202,9,14,0,0,0,100,0,3000,3000,0,0,0,1,1,0,0,0,0,0,19,34698,40,0,0,0,0,0,0,'Sputtervalve - On Script - Say Line 1 (Nozzlepot)'),
(344202,9,15,0,0,0,100,0,4000,4000,0,0,0,1,5,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Say Line 5'),
(344202,9,16,0,0,0,100,0,3000,3000,0,0,0,5,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Stop Emote'),
(344202,9,17,0,0,0,100,0,0,0,0,0,0,45,0,2,0,0,0,0,19,34674,40,0,0,0,0,0,0,'Sputtervalve - On Script - Set Data 0 2 (Brak goes back)'),
(344202,9,18,0,0,0,100,0,0,0,0,0,0,45,0,2,0,0,0,0,19,34698,40,0,0,0,0,0,0,'Sputtervalve - On Script - Set Data 0 2 (Nozzlepot goes back)'),
(344202,9,19,0,0,0,100,0,0,0,0,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sputtervalve - On Script - Set Run Off'),
(344202,9,20,0,0,0,100,0,0,0,0,0,0,69,2,0,0,0,0,0,8,0,0,0,0,1140.92,-3376.76,92.5417,0,'Sputtervalve - On Script - Move Home (point 2)'),
(34674,0,7,8,38,0,100,0,0,1,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Brak Blusterpipe - On Data Set 0 1 - Set Run On'),
(34674,0,8,0,61,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,8,0,0,0,0,1155.4,-3390.2,91.68,0,'Brak Blusterpipe - Linked - Move To The Samophlange (point 1)'),
(34674,0,9,0,34,0,100,0,8,1,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,2.4,'Brak Blusterpipe - On Reached Point 1 - Face The Samophlange'),
(34674,0,10,11,38,0,100,0,0,2,0,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Brak Blusterpipe - On Data Set 0 2 - Set Run Off'),
(34674,0,11,0,61,0,100,0,0,0,0,0,0,69,2,0,0,0,0,0,8,0,0,0,0,1160.38,-3398.65,91.7917,0,'Brak Blusterpipe - Linked - Move Home (point 2)'),
(34674,0,12,0,34,0,100,0,8,2,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,2.86234,'Brak Blusterpipe - On Reached Point 2 - Set Orientation'),
(34698,0,0,1,38,0,100,0,0,1,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nozzlepot - On Data Set 0 1 - Set Run On'),
(34698,0,1,0,61,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,8,0,0,0,0,1155.6,-3385.9,91.7,0,'Nozzlepot - Linked - Move To The Samophlange (point 1)'),
(34698,0,2,0,34,0,100,0,8,1,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,3.821,'Nozzlepot - On Reached Point 1 - Face The Samophlange'),
(34698,0,3,4,38,0,100,0,0,2,0,0,0,59,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nozzlepot - On Data Set 0 2 - Set Run Off'),
(34698,0,4,0,61,0,100,0,0,0,0,0,0,69,2,0,0,0,0,0,8,0,0,0,0,1168.59,-3389.09,91.6667,0,'Nozzlepot - Linked - Move Home (point 2)'),
(34698,0,5,0,34,0,100,0,8,2,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,3.89208,'Nozzlepot - On Reached Point 2 - Set Orientation');

-- H11 (all of Sputtervalve's quests): faction and spot as both TDBs (Bilgewater Cartel 2160; Wowhead "hostile to alliance").
UPDATE `creature_template` SET `faction`=2160 WHERE `entry`=3442;
UPDATE `creature` SET `position_x`=1140.92, `position_y`=-3376.76, `position_z`=92.5417, `orientation`=5.11381 WHERE `guid`=264389 AND `id`=3442;

