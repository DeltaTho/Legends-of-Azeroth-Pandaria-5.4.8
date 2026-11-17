-- Splinterspear Junction: a Stonard Grunt on the tower top asks Neeka Bloodscar about Helgrum and she sends him back to his post.
-- Sourced (Wowhead npc 47041 2010-11-26 [+13], Liri): a grunt at the top of the tower asks about Helgrum, Neeka answers, the grunt
-- salutes. The comment quotes three questions (bt 47809-47811) and three answers (bt 47813-47815); the fourth of each (47808 "Is
-- there anything we can do to help?", 47812 "Stand your posts...") is ours, placed by its broadcast id next to them. The rows carry
-- the broadcast texts' emotes (EmotesID 6 question for the grunt, 1 talk for Neeka).
-- Ours: the grunt is the tower-top walker 166822 (no source gives the grunt's path; its own path is kept, section C), every 3-5
-- minutes out of combat, the 4 s before her answer, the salute (emote 66) 2.5 s later; any line of hers answers any line of his.
-- A per-guid script replaces the entry's for that spawn, so the Stonard Grunt's two abilities (entry 866 ids 0-1) are copied.
DELETE FROM `creature_text` WHERE (`CreatureID`=866 AND `GroupID`=0) OR (`CreatureID`=47041 AND `GroupID`=1);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(866,0,0,'Is there anything we can do to help?',12,1,100,6,0,0,0,47808,0,'Stonard Grunt - asks Neeka (Splinterspear tower)'),
(866,0,1,'Is there anything my troops or I can do?',12,1,100,6,0,0,0,47809,0,'Stonard Grunt - asks Neeka (Splinterspear tower)'),
(866,0,2,'Are you sure there is nothing more we can do Neeka?',12,1,100,6,0,0,0,47810,0,'Stonard Grunt - asks Neeka (Splinterspear tower)'),
(866,0,3,'Is there nothing we can do for Helgrum?',12,1,100,6,0,0,0,47811,0,'Stonard Grunt - asks Neeka (Splinterspear tower)'),
(47041,1,0,'Stand your posts and keep any Alliance filth from us.',12,1,100,1,0,0,0,47812,0,'Neeka Bloodscar - answers the grunt'),
(47041,1,1,'Stand your ground and keep alert for any Alliance that may try to attack.',12,1,100,1,0,0,0,47813,0,'Neeka Bloodscar - answers the grunt'),
(47041,1,2,'Watch for any more Alliance.  We will make them suffer should they try to attack again.',12,1,100,1,0,0,0,47814,0,'Neeka Bloodscar - answers the grunt'),
(47041,1,3,'Make sure you are all on guard for any more Alliance attacks.',12,1,100,1,0,0,0,47815,0,'Neeka Bloodscar - answers the grunt');

DELETE FROM `smart_scripts` WHERE (`entryorguid`=-166822 AND `source_type`=0) OR (`entryorguid`=16682200 AND `source_type`=9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-166822,0,0,0,2,0,100,0,0,55,10000,15000,11,12169,2,0,0,0,0,1,0,0,0,0,0,0,0,'Stonard Grunt - Cast Shield Block at 55% HP (as entry 866)'),
(-166822,0,1,0,0,0,100,0,5000,8000,12000,15000,11,12170,0,0,0,0,0,2,0,0,0,0,0,0,0,'Stonard Grunt - Cast Revenge (as entry 866)'),
(-166822,0,2,0,1,0,100,0,120000,180000,180000,300000,80,16682200,0,0,0,0,0,1,0,0,0,0,0,0,0,'Stonard Grunt (Splinterspear tower top) - OOC - Run Script (asks Neeka)'),
(16682200,9,0,0,0,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Stonard Grunt - Script - Say Line 0'),
(16682200,9,1,0,0,0,100,0,4000,4000,0,0,1,1,0,0,0,0,0,19,47041,30,0,0,0,0,0,'Stonard Grunt - Script - Neeka Bloodscar Say Line 1'),
(16682200,9,2,0,0,0,100,0,2500,2500,0,0,5,66,0,0,0,0,0,1,0,0,0,0,0,0,0,'Stonard Grunt - Script - Play Emote Salute');
