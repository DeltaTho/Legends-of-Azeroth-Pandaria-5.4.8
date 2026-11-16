-- Searing Gorge, Lunk's Task 27956 / Lunk No Kill 27957 (plan B-1): the camp Lunk hides once Lunk No Kill is handed in, and
-- the runaway Lunk 47299 that 88212 Summon Lunk leaves behind says his two lines and runs off instead of standing still.
--
-- Sourced:
-- - 49414 Generic Quest Invisibility 1 (type 7) on the camp Lunk's template and spell_area 88176 See Quest Invis 1 (type 7,
--   amount 1000 >= 1), area 5629, quest_start 27957 status 11 (none / complete / incomplete): both TDBs. Turning in 27957
--   drops 88176 (Player::SendQuestUpdate -> UpdateAreaDependentAuras -> SpellInfo::CheckLocation finds no fitting row), so
--   the camp Lunk vanishes for that player only.
-- - Texts: 47269 group 0 "Why you do that? Why you kill?" on 27956's turn-in (BT 47698; wiki 27956 "On complete");
--   47299 groups 0 / 1 (BT 47424 / 47425) and the run: wiki 27957 notes ("Lunk runs away. On reaching the main path, he turns
--   and yells back at the collected dwarves... continues running down to the southwest"), comment 47429 2011-11-27.
-- Ours:
-- - A second 88176 row (quest_start 27956 not rewarded) for characters that turned in 27957 before 27956 while both were
--   offered together (before 27957 PrevQuestID 27956): without it they could never see the giver / ender of 27956.
-- - TextRange 5 (personal) on 47269 group 0 and 47299 groups 0-1: the camp Lunk is quest-invisible to players past 27957
--   and 47299 is a personal summon (SummonProperties 2841 flags 0x10), so a normal yell would reach players who cannot see
--   the speaker.
-- - The route: two points round the south and west side of the camp, (-6900,-1863,252.4) and (-6904,-1840,246.1), so he
--   passes 4.4 yd or more from Prisanne, Jack, Burrian and the campfire; then the road point (-6900,-1828,242.7) on the flat
--   valley floor below the camp's ledge (the "main path"), facing the camp; then (-6945,-1783,241.8) 63 yd further
--   south-west. Terrain heights from the 5.4.8 maps, no model or liquid on any leg [ground.py], each point on a navmesh
--   polygon (273, 279, 280, 4110). Timings ours. Movement-inform driven, so a slow run never cuts a step.

UPDATE `creature_template_addon` SET `auras`='49414' WHERE `entry`=47269;

DELETE FROM `spell_area` WHERE `spell`=88176 AND `area`=5629;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(88176,5629,27957,0,0,0,2,1,11,0),
(88176,5629,27956,0,0,0,2,1,11,0);

UPDATE `creature_text` SET `TextRange`=5 WHERE `CreatureID`=47269 AND `GroupID`=0;
UPDATE `creature_text` SET `TextRange`=5 WHERE `CreatureID`=47299 AND `GroupID` IN (0,1);

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (47269,47299);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (47269,47299) AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (4729900,4729901) AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47269,0,0,0,20,0,100,0,27956,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Lunk - On Quest ''Lunk''s Task'' Rewarded - Say 0 to the player'),
(47299,0,0,0,54,0,100,0,0,0,0,0,0,80,4729900,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lunk - Just Summoned - Run Script'),
(47299,0,1,0,34,0,100,0,8,1,0,0,0,69,2,0,0,0,0,0,8,0,0,0,0,-6904,-1840,246.1,0,'Lunk - On Camp Corner Reached - Run on round the camp'),
(47299,0,2,0,34,0,100,0,8,2,0,0,0,69,3,0,0,0,0,0,8,0,0,0,0,-6900,-1828,242.7,0,'Lunk - On West Side Reached - Run to the road'),
(47299,0,3,0,34,0,100,0,8,3,0,0,0,80,4729901,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lunk - On Road Reached - Run Script'),
(47299,0,4,0,34,0,100,0,8,4,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lunk - On South-West Point Reached - Despawn'),
(4729900,9,0,0,0,0,100,0,500,500,0,0,0,1,0,0,0,0,0,0,23,0,0,0,0,0,0,0,0,'Lunk - Script - Say 0 to summoner'),
(4729900,9,1,0,0,0,100,0,1500,1500,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lunk - Script - Set Run'),
(4729900,9,2,0,0,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,8,0,0,0,0,-6900,-1863,252.4,0,'Lunk - Script - Run to the camp''s south-west corner'),
(4729901,9,0,0,0,0,100,0,0,0,0,0,0,66,0,0,0,0,0,0,8,0,0,0,0,0,0,0,4.967,'Lunk - Script - Face the camp'),
(4729901,9,1,0,0,0,100,0,500,500,0,0,0,1,1,0,0,0,0,0,23,0,0,0,0,0,0,0,0,'Lunk - Script - Say 1 to summoner'),
(4729901,9,2,0,0,0,100,0,2500,2500,0,0,0,69,4,0,0,0,0,0,8,0,0,0,0,-6945,-1783,241.8,0,'Lunk - Script - Run south-west');
