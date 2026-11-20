-- Northern Barrens, A Most Unusual Map (14049): Gazlowe has the first mate's head shaved when it is handed in, Ratchet.
-- Sourced: the three lines, broadcast texts 35056 "Gagsprocket! Shave this for me - pronto!", 35058 "Sure thing, boss." and
-- 35057 "Thanks." (in the id block between the Baron's 35052 / 35054 and the treasure's 35059 / 35060); Gagsprocket 3495
-- stands 5 yd from Gazlowe (spawn 265164). The quest text that follows (14050 "Sink me, you were right! There's a map tattooed
-- on the skull") needs the head shaved.
-- Ours: the trigger (on the reward of 14049), who says which line (by their content: the order request - "Sure thing, boss." -
-- "Thanks."; the dossier's guess had 35057 and 35058 the other way round), the delays and the say range.
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3391 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid`=3391 AND `source_type`=0 AND `id`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=339100 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3391,0,0,0,20,0,100,0,14049,0,0,0,0,80,339100,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gazlowe - On Quest A Most Unusual Map Rewarded - Run Script (the shave)'),
(339100,9,0,0,0,0,100,0,1000,1000,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gazlowe - On Script - Say Line 0 (Gagsprocket! Shave this)'),
(339100,9,1,0,0,0,100,0,3000,3000,0,0,0,1,0,0,0,0,0,0,19,3495,15,0,0,0,0,0,0,'Gazlowe - On Script - Gagsprocket Says Line 0 (Sure thing, boss.)'),
(339100,9,2,0,0,0,100,0,4000,4000,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gazlowe - On Script - Say Line 1 (Thanks.)');
DELETE FROM `creature_text` WHERE `CreatureID`=3391 AND `GroupID` IN (0,1);
DELETE FROM `creature_text` WHERE `CreatureID`=3495 AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(3391,0,0,'Gagsprocket! Shave this for me - pronto!',12,0,100,0,0,0,0,35056,0,'Gazlowe - A Most Unusual Map, the head handed in'),
(3391,1,0,'Thanks.',12,0,100,0,0,0,0,35057,0,'Gazlowe - A Most Unusual Map, the head shaved'),
(3495,0,0,'Sure thing, boss.',12,0,100,0,0,0,0,35058,0,'Gagsprocket - A Most Unusual Map, shaving the head');
