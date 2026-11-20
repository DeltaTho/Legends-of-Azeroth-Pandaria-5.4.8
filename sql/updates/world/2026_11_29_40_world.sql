-- Northern Barrens, Who's Shroomin' Who? (13999): the hand-in conversation at Sashya in the Broken Keel tavern, Ratchet.
-- Sourced: the seven-line exchange and its order (comments 2010-11-24 [+30] and 2011-03-07 [+20], identical order), broadcast
-- texts 34921-34928 (Hargash 34921 34922 34925 34923 34924, Sashya 34926 34927 and the emote 34928); Hargash 34656 stands at
-- both TDBs' spot (-1040.2,-3656.3), and both TDBs have unit_flags 0 for him (mop added STUNNED: a frozen statue).
-- Hargash "has been lurking in the back of the tavern ... He steps forward" (2011-03-07 [+20]): he walks 3 yd toward Sashya
-- for the scene and back to his spot after it.
-- Ours: the delays between the lines (1-6 s), the place of Sashya's closing emote, the 3 yd, a 35 s cooldown so a second
-- hand-in during the scene does not restart it (that player gets no scene), and Hargash IMMUNE_TO_NPC: without STUNNED this
-- level-25 grunt (faction 714) would join Club Foote's brawl and kill both deck hands; the one beta comment about Horde NPCs
-- helping is question 16, default no. Neither TDB has any script or text for either NPC. Hargash speaks by being the talk target of Sashya's action list, so $C / $r resolve to the player who handed in.
-- Sashya's text groups 0-2 and SmartAI id 0 / action list 3465100 belong to this scene; group 3 and her other rows are Club
-- Foote's (2026_11_29_41), so the deletes here are by group / id.
UPDATE `creature_template` SET `unit_flags` = (`unit_flags` & ~0x40000) | 0x200 WHERE `entry` = 34656;
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 34656 AND `ScriptName` = '';
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 34651 AND `ScriptName` = '';
DELETE FROM `creature_text` WHERE `CreatureID` = 34656 AND `GroupID` IN (0,1,2,3,4);
DELETE FROM `creature_text` WHERE `CreatureID` = 34651 AND `GroupID` IN (0,1,2);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34656,0,0,'Hold it!',12,0,100,0,0,0,0,34921,0,'Hargash - quest 13999'),
(34656,1,0,'What are you two conspiring? Hand me that package.',12,0,100,0,0,0,0,34922,0,'Hargash - quest 13999'),
(34656,2,0,'We''ve seen the results of your ''research'' before. I''ll deliver this package to Orgrimmar for study.',12,0,100,0,0,0,0,34925,0,'Hargash - quest 13999'),
(34656,3,0,'$C, you should know the Warchief doesn''t trust the undead. Have you heard what happened at the Wrathgate?',12,0,100,0,0,0,0,34923,0,'Hargash - quest 13999'),
(34656,4,0,'You should do well to consider where your loyalties lie, $r.',12,0,100,0,0,0,0,34924,0,'Hargash - quest 13999'),
(34651,0,0,'What, this? This is nothing. Just some ... wildlife research.',12,0,100,0,0,0,0,34926,0,'Sashya - quest 13999'),
(34651,1,0,'Nonsense! You''re overreacting. Have you been watching me this whole time?',12,0,100,0,0,0,0,34927,0,'Sashya - quest 13999'),
(34651,2,0,'%s mutters angrily to herself.',16,0,100,0,0,0,0,34928,0,'Sashya - quest 13999');
DELETE FROM `smart_scripts` WHERE `entryorguid` = 34651 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3465100 AND `source_type` = 9;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 34656 AND `source_type` = 0 AND `id` IN (0,1,2,3);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34651,0,0,0,20,0,100,0,13999,35000,35000,0,0,80,3465100,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sashya - On Quest ''Who''s Shroomin'' Who?'' Rewarded - Run Script'),
(3465100,9,0,0,0,0,100,0,0,0,0,0,0,45,1,1,0,0,0,0,19,34656,30,0,0,0,0,0,0,'Sashya - On Script - Hargash steps forward (data 1 1)'),
(3465100,9,1,0,0,0,100,0,1000,1000,0,0,0,1,0,0,0,0,0,0,19,34656,30,0,0,0,0,0,0,'Sashya - On Script - Hargash Says Line 0'),
(3465100,9,2,0,0,0,100,0,3000,3000,0,0,0,1,1,0,0,0,0,0,19,34656,30,0,0,0,0,0,0,'Sashya - On Script - Hargash Says Line 1'),
(3465100,9,3,0,0,0,100,0,4000,4000,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sashya - On Script - Say Line 0'),
(3465100,9,4,0,0,0,100,0,4000,4000,0,0,0,1,2,0,0,0,0,0,19,34656,30,0,0,0,0,0,0,'Sashya - On Script - Hargash Says Line 2'),
(3465100,9,5,0,0,0,100,0,5000,5000,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sashya - On Script - Say Line 1'),
(3465100,9,6,0,0,0,100,0,5000,5000,0,0,0,1,3,0,0,0,0,0,19,34656,30,0,0,0,0,0,0,'Sashya - On Script - Hargash Says Line 3'),
(3465100,9,7,0,0,0,100,0,6000,6000,0,0,0,1,4,0,0,0,0,0,19,34656,30,0,0,0,0,0,0,'Sashya - On Script - Hargash Says Line 4'),
(3465100,9,8,0,0,0,100,0,4000,4000,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sashya - On Script - Emote Line 2'),
(3465100,9,9,0,0,0,100,0,4000,4000,0,0,0,45,1,2,0,0,0,0,19,34656,30,0,0,0,0,0,0,'Sashya - On Script - Hargash goes back (data 1 2)'),
(34656,0,0,0,38,0,100,0,1,1,0,0,0,69,1,0,0,0,0,0,8,0,0,0,0,-1042.9,-3655.0,23.88,0,'Hargash - On data 1 1 - Step 3 yd toward Sashya'),
(34656,0,1,0,34,0,100,0,8,1,0,0,0,66,0,0,0,0,0,0,19,34651,30,0,0,0,0,0,0,'Hargash - On point 1 - Face Sashya'),
(34656,0,2,0,38,0,100,0,1,2,0,0,0,69,2,0,0,0,0,0,8,0,0,0,0,-1040.17,-3656.26,23.88,0,'Hargash - On data 1 2 - Back to his spot'),
(34656,0,3,0,34,0,100,0,8,2,0,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hargash - On point 2 - Face his spawn direction');
