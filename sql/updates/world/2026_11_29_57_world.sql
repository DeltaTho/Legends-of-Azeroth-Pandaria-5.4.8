-- Northern Barrens, King of Centaur Mountain (13995): Gorgal's banner, the Kolkar waves and Kurak (npc_gorgal_angerscar,
-- zone_the_barrens.cpp), plus Shoe and Gorgal's bicker (851 #8).
-- Sourced: Wowhead 13995 comments (2010-07-07 beta, 2010-12-11, 2011-09-05, 2012-01-19, 2012-08-19) and npc 34634 / 34638
-- comments 2010-11-23; the wiki's lines; broadcast texts 34877-34893; video q1U-6HUmuwg (second-pass.md); both TDBs: Gorgal
-- the only starter, no Kurak or banner spawned (34635 and 195148 are event actors), Kurak's SmartAI row 0 (flee at 15 %).
-- Ours: wave make-up and timing (plan Q12), the bicker interval; Gorgal's groups 0-6 (plan 0.3 gave 0-4; 34634 is S5's alone).

UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_gorgal_angerscar' WHERE `entry` = 34634;

-- Shoe does not start it (both TDBs, Wowhead: Gorgal only; she would hand it out with no event). She still ends it.
DELETE FROM `creature_queststarter` WHERE `id` = 34638 AND `quest` = 13995;

-- The static Kurak (60 s respawn, on his sniffed walk up the hill) and the static banner are sniff copies of event actors
DELETE FROM `waypoint_data` WHERE `id` = 310960;
DELETE FROM `creature_addon` WHERE `guid` = 310960;
DELETE FROM `creature` WHERE `guid` = 310960;
DELETE FROM `gameobject` WHERE `guid` = 183493;

-- Kurak: both TDBs' SmartAI (4.4.2 and 12.1 identical)
UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 34635;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 34635 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34635,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Kurak - Between 0-15% Health - Flee For Assist (No Repeat)');

-- Lines (Gorgal 0-5 the event in the wiki's order, 6 the bicker reply; Shoe 0 the bicker)
DELETE FROM `creature_text` WHERE `CreatureID` = 34634 AND `GroupID` IN (0,1,2,3,4,5,6);
DELETE FROM `creature_text` WHERE `CreatureID` = 34638 AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT CASE `ID` WHEN 34890 THEN 34638 ELSE 34634 END,
       CASE `ID` WHEN 34877 THEN 0 WHEN 34878 THEN 1 WHEN 34879 THEN 2 WHEN 34881 THEN 3 WHEN 34882 THEN 4 WHEN 34893 THEN 5 WHEN 34891 THEN 6 ELSE 0 END,
       0, IF(`Text` = '', `Text1`, `Text`), CASE `ID` WHEN 34878 THEN 14 ELSE 12 END, 0, 100, 0, 0, 0, 0, `ID`, 0,
       CASE `ID` WHEN 34890 THEN 'Shoe - bicker' WHEN 34891 THEN 'Gorgal Angerscar - bicker reply' ELSE 'Gorgal Angerscar - King of Centaur Mountain' END
FROM `broadcast_text` WHERE `ID` IN (34877,34878,34879,34881,34882,34893,34890,34891);
