-- Northern Barrens S1 (_04): the Lushwater / Forgotten Pools druid chain - 870 unlocked, order, Jerrik, Tonga's and
-- Helbrim's turn-in scripts, mushroom respawn.
-- (plan.md section 1 `_04`; dossier C: C-870-1, C-877-1, C-13988-2, C-880-1, C-848-1, C-848-2.)
--
-- SOURCED: 870 needs nothing and 886 is its breadcrumb (both TDBs: 870 PrevQuestID 0; 886 BreadcrumbForQuestId 870,
-- NextQuestID 0); today 870 requires 886, which has no giver or ender in mop or either TDB, so 870 / 13988 / 877 / 880
-- cannot be taken. 877 follows 13988 (both TDBs; comments 2010-12-28, 2011-11-22). Tonga is the only starter of 13988 (both
-- TDBs, Wowhead). Tonga's four turn-in lines one after another (both TDBs: action list 344800; mop fired all four in one
-- tick); Helbrim's turn-in script (both TDBs: 3390 / 339000, texts already in mop); Laden Mushroom 120 s (both TDBs).
-- OURS: nothing.
-- Note: 13988 itself needs the S5 eagle scene to complete (same deploy); this file only makes it reachable.

-- C-870-1: The Forgotten Pools is open; The Barrens Oases is only its breadcrumb.
UPDATE `quest_template_addon` SET `PrevQuestID`=0 WHERE `ID`=870;
UPDATE `quest_template_addon` SET `NextQuestID`=0, `BreadcrumbForQuestId`=870 WHERE `ID`=886;

-- C-877-1: The Stagnant Oasis follows A Growing Problem.
UPDATE `quest_template_addon` SET `PrevQuestID`=13988 WHERE `ID`=877;

-- C-13988-2: Jerrik does not start A Growing Problem.
DELETE FROM `creature_queststarter` WHERE `id`=34626 AND `quest`=13988;

-- C-880-1: Tonga's four lines on the Altered Beings turn-in, 5 / 4 / 4 s apart.
DELETE FROM `smart_scripts` WHERE `entryorguid`=3448 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=344800 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3448,0,0,0,20,0,100,0,880,0,0,0,0,80,344800,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tonga Runetotem - On Quest ''Altered Beings'' Finished - Run Script'),
(344800,9,0,0,0,0,100,0,0,0,0,0,0,1,0,5000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tonga Runetotem - On Script - Say Line 0'),
(344800,9,1,0,0,0,100,0,5000,5000,0,0,0,1,1,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tonga Runetotem - On Script - Say Line 1'),
(344800,9,2,0,0,0,100,0,4000,4000,0,0,0,1,2,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tonga Runetotem - On Script - Say Line 2'),
(344800,9,3,0,0,0,100,0,4000,4000,0,0,0,1,3,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tonga Runetotem - On Script - Say Line 3');

-- C-848-1: Laden Mushrooms respawn in 120 s (16 spawns, 5 needed).
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `id`=3640;

-- C-848-2: Helbrim processes the spores and thanks the player on the Fungal Spores turn-in.
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3390 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid`=3390 AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=339000 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3390,0,0,1,20,0,100,0,848,0,0,0,0,80,339000,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Apothecary Helbrim - On Quest ''Fungal Spores'' Finished - Run Script'),
(3390,0,1,0,61,0,100,0,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Apothecary Helbrim - On Quest ''Fungal Spores'' Finished - Store Targetlist'),
(339000,9,0,0,0,0,100,0,0,0,0,0,0,83,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Apothecary Helbrim - On Script - Remove Npc Flag Questgiver'),
(339000,9,1,0,0,0,100,0,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,4.72937,'Apothecary Helbrim - On Script - Set Orientation 4.72937'),
(339000,9,2,0,0,0,100,0,2000,2000,0,0,0,1,0,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Apothecary Helbrim - On Script - Say Line 0'),
(339000,9,3,0,0,0,100,0,4000,4000,0,0,0,66,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Apothecary Helbrim - On Script - Set Orientation Stored Target'),
(339000,9,4,0,0,0,100,0,0,0,0,0,0,1,1,6000,0,0,0,0,12,1,0,0,0,0,0,0,0,'Apothecary Helbrim - On Script - Say Line 1'),
(339000,9,5,0,0,0,100,0,0,0,0,0,0,82,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Apothecary Helbrim - On Script - Add Npc Flag Questgiver'),
(339000,9,6,0,0,0,100,0,3000,3000,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,6.23082,'Apothecary Helbrim - On Script - Set Orientation 6.23082');
