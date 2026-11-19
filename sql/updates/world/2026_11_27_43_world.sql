-- Xar'Ti (7953, Sen'jin riding trainer) and Un'Thuwa (5880, Razor Hill) dance now and then, as both TDBs (4.4.2 and 12.1.0) script them: out of
-- combat, first after 1-60 s and then every 30-300 s, emote state 10 (dance) for 30-120 s. Sourced verbatim; cosmetic (dossier C, S8). Neither
-- has a ScriptName or SmartAI rows today, and no beta update touches them. Their gossip (menus 4022, 64) is unchanged.
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (7953, 5880) AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE (`entryorguid` IN (7953, 5880) AND `source_type` = 0) OR (`entryorguid` IN (795300, 588000) AND `source_type` = 9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7953,0,0,0,1,0,100,0,1000,60000,30000,300000,0,80,795300,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Xar''Ti - Out of Combat - Run Action List'),
(795300,9,0,0,0,0,100,0,0,0,0,0,0,17,10,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Xar''Ti - Action List - Set Emote State 10 (dance)'),
(795300,9,1,0,0,0,100,0,30000,120000,0,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Xar''Ti - Action List - Set Emote State 0'),
(5880,0,0,0,1,0,100,0,1000,60000,30000,300000,0,80,588000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Un''Thuwa - Out of Combat - Run Action List'),
(588000,9,0,0,0,0,100,0,0,0,0,0,0,17,10,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Un''Thuwa - Action List - Set Emote State 10 (dance)'),
(588000,9,1,0,0,0,100,0,30000,120000,0,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Un''Thuwa - Action List - Set Emote State 0');
