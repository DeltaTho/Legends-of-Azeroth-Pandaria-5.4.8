-- Northern Barrens S1 (_14): the Nozzlepot chain - Wenikee's and Sputtervalve's stray starters, the chain order, Read the
-- Manual's two breadcrumbs to Harpy Raiders, Wenikee's yell and her port back, blueprint drops.
-- (plan.md section 1 `_14`; dossier G: G5, G16, G17, G18; dossier H: H5, H7, H12. H6 dropped by ruling R1: G16 decides
-- 28877 / 29094.)
--
-- SOURCED: per block below. 28877 / 29094 follow Read the Manual 14006 in both TDBs; 14004 after 29027 (Wowhead 2010-12-31
-- thread, +4/+10/+5); the starters removed are in neither TDB; blueprints 75 % (both TDBs).
-- OURS: 29026 after 14003 and 29015 after 29027 (Wowhead comments only; neither TDB); Wenikee's yell trigger (a player under
-- People-Ported 66002 in sight within 40 yd); the port back's landing point 70 yd above Brak's forge; the option text is
-- BroadcastText 50935 (the id block of Wenikee's texts; in neither TDB).
-- CHOICE POINT: 29094 (and 29086) do not wait for Competition Schmompetition 29086 (questions.md Q2 default no, as both TDBs);
-- yes = H's optional SQL in dossiers\H.md.
-- After this file: 863 starts at the shredder 3439, 29024 at the object 4141, 14003 at Sputtervalve 3442, 29026 at Brak 34674.

-- G5 (29026 / 29015): Wenikee is not a starter of 29026 (both TDBs: Brak only; mop lets anyone take it from her and skip
-- Brak and the Samophlange chain). 29026 follows Samophlange Repair 14003 (Wowhead 2011-08-11 [+9] "Unlocks 29026"); Miner's
-- Fortune follows Nugget Slugs (2011-08-12 [+5] "Unlocks quest 14004 and quest 29015"; 2011-03-10 [+14]). Neither TDB carries
-- these two prerequisites: ours, from Wowhead.
DELETE FROM `creature_queststarter` WHERE `id`=9316 AND `quest`=29026;
UPDATE `quest_template_addon` SET `PrevQuestID`=14003 WHERE `ID`=29026;
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`) SELECT 29015, 29027 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `quest_template_addon` WHERE `ID`=29015);
UPDATE `quest_template_addon` SET `PrevQuestID`=29027 WHERE `ID`=29015;


-- G16 (28877 and 29094; the combined disposition of H's H6 and D's H-D1 - apply this instead of both for these two rows):
-- breadcrumbs to Harpy Raiders, offered after Read the Manual (both TDBs PrevQuestID 14006). NextQuestID 867 goes (in this core
-- it makes 867 require one of them, ObjectMgr.cpp ~5000; the loader also flags it once BreadcrumbForQuestId is set). No
-- ExclusiveGroup: the loader logs an error for a breadcrumb in a group, and the breadcrumb rule (offered only while 867 can be
-- taken) already closes the other once 867 is taken. RewardNextQuest 867 keeps the pop-up at Darsok.
UPDATE `quest_template_addon` SET `PrevQuestID`=14006, `NextQuestID`=0, `ExclusiveGroup`=0, `BreadcrumbForQuestId`=867 WHERE `ID` IN (28877,29094);

-- G17 (29026, cosmetic, sourced line): Wenikee yells when a ported player drops beside her (broadcast 34942; Wowhead 2010-11-26,
-- 2013-08-27 "ran circles ... yelling 'It's raining blood elf!'"). The trigger is ours: a player in sight within 40 yd carrying
-- People-Ported 66002 (10 s safe fall, cast by Brak's 3467400 one second before the teleport).
DELETE FROM `creature_text` WHERE `CreatureID`=9316 AND `GroupID`=2;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT 9316, 2, 0, `Text1`, 14, 0, 100, 0, 0, 0, 0, `ID`, 0, 'Wenikee Boltbucket - a ported player falls' FROM `broadcast_text` WHERE `ID`=34942;
DELETE FROM `smart_scripts` WHERE `entryorguid`=9316 AND `source_type`=0 AND `id`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9316,0,1,0,10,0,100,0,1,40,10000,10000,0,1,2,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Wenikee Boltbucket - OOC LOS ported player - Yell Line 2');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=2 AND `SourceEntry`=9316 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,2,9316,0,0,1,0,66002,0,0,0,0,0,'','Wenikee yells only at a player under People-Ported'),
(22,2,9316,0,0,35,0,1,10,1,0,0,0,'','... more than 10 yd from her (not the player she is porting away)');

-- G18 (14004, hand-off from H; Wenikee is G's): the port back. Option text broadcast 50935 "Send me back to Nozzlepot's
-- Outpost." (id block of Wenikee's own texts 50933/50934; in neither TDB), shown while 14004 is in the log. Same mechanism as
-- Brak's 3467400; the drop point 70 yd above Brak's forge is ours (14004's log text and a 2013 comment: you arrive in the air).
DELETE FROM `gossip_menu_option` WHERE `MenuID`=12743 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`)
SELECT 12743, 0, 0, `Text`, `ID`, 1, 1, 0, 0, 0, 0, '', 0, 0 FROM `broadcast_text` WHERE `ID`=50935;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=12743 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,12743,0,0,0,47,0,14004,10,0,0,0,0,'','Wenikee port-back option while Return to Samophlanger is in the log (complete or incomplete)');
DELETE FROM `smart_scripts` WHERE (`entryorguid`=9316 AND `source_type`=0 AND `id` IN (2,3,4)) OR (`entryorguid`=931601 AND `source_type`=9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9316,0,2,3,62,0,100,0,12743,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Wenikee Boltbucket - On Gossip Select - Store Target'),
(9316,0,3,4,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Wenikee Boltbucket - Linked - Close Gossip'),
(9316,0,4,0,61,0,100,0,0,0,0,0,0,80,931601,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wenikee Boltbucket - Linked - Run Script'),
(931601,9,0,0,0,0,100,0,0,0,0,0,0,11,66002,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Wenikee Boltbucket - On Script - Cast People-Ported'),
(931601,9,1,0,0,0,100,0,1000,1000,0,0,0,62,1,0,0,0,0,0,12,1,0,0,0,1160.4,-3398.7,161.8,2.86,'Wenikee Boltbucket - On Script - Teleport Player above Nozzlepot''s Outpost');

-- H5 (863, 29024, 14003): starters neither TDB has.
DELETE FROM `creature_queststarter` WHERE (`id`=3442 AND `quest` IN (863,29024)) OR (`id`=34674 AND `quest`=14003);

-- H7 (14004): offered after Nugget Slugs (Wowhead 2010-12-31 thread, +4/+10/+5).
UPDATE `quest_template_addon` SET `PrevQuestID`=29027 WHERE `ID`=14004;

-- H12 (29086): the two named blueprint carriers drop it at 75 % as both TDBs (less grindy than mop's 33 / 36 %).
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-75 WHERE `entry` IN (52356,52357) AND `item`=68820;
