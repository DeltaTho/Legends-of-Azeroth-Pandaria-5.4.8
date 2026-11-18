-- Blasted Lands, Blood Ritual (25686 Horde at Bloodmage Lynnore 7506, 26160 Alliance at Kasim Sharim 42298): the ritual is
-- started from the giver's gossip, as the objective says ("Speak with Lynnore / Kasim to begin the blood ritual"); until now both
-- quests were complete on accept and the menus had no Blood Ritual option. Also Kasim's yell when Time is Short (26163) is taken.
--
-- Sourced: both TDBs have the Blood Ritual on OptionID 0 of menus 11473 / 11613 (the Amulet Ritual on 11613 option 1); the
-- option texts (broadcast 41149 / 42213); the wiki 26160 notes: "Very well. Stand back... this may get messy.", Kasim casts a
-- spell (77573 Blood Ritual, 3 s, the only unreferenced spell of the block), "The blood ritual is complete... and I can now see
-- where three amulets await you." (broadcast 42214 / 42215 Kasim, 41381 / 41380 Lynnore, Text1 = female); comment 26160
-- 2013-01-05 [+4]: choosing the option completes the quest; progress texts "The ritual is not yet complete." (both TDBs) /
-- "The blood ritual is not yet complete." (wiki 26160); wiki 26163 notes: Kasim yells broadcast 42287 on accept. Languages as
-- the broadcast texts (Orcish 1 / Common 7).
-- Ours: credit at the option rather than after the cast (a second player's click restarts the scene but cannot lose a
-- credit); the second line 4 s after the first; the credit goes to every player within 15 yd who has the quest in the log, as
-- section D's Amulet Ritual on the same menu (playerbots never choose gossip, so a group's bots are credited with the leader).
-- Quest map area: the objective area of 25686 / 26160 (Idx1 1, at the giver) keeps ObjectiveIndex 16. Both TDBs have 30, but
-- they are a later client's data: this database uses 16 for 490 such rows and 30 for none, and these quests have no objective
-- rows, so 30 may show nothing in the 5.4.8 client.
--
-- Shared rows (ruling K5): option 0, SmartAI ids 0-9, creature_text groups 2+ of 7506 / 42298 are this file's; option 1
-- (Amulet Ritual), ids 10-14 and groups 0 / 1 are section D's and are never deleted here. The two UPDATEs below are D's own
-- move of the Amulet Ritual from option 0 to option 1 (with mop's old condition row): a no-op once D's file has run, so both
-- orders of application end in the same rows. mop's old amulet SmartAI rows 0-3 are deleted here and by D.

UPDATE `quest_template_addon` SET `SpecialFlags` = `SpecialFlags` | 2 WHERE `ID` IN (25686, 26160);

-- Amulet Ritual off option 0 (D's rows; skipped once D ran)
UPDATE `gossip_menu_option` SET `OptionID` = 1 WHERE `MenuID` = 11473 AND `OptionID` = 0 AND `OptionBroadcastTextID` = 41390;
UPDATE `gossip_menu_option` SET `OptionID` = 1 WHERE `MenuID` = 11613 AND `OptionID` = 0 AND `OptionBroadcastTextID` = 42216;
UPDATE `conditions` SET `SourceEntry` = 1 WHERE `SourceTypeOrReferenceId` = 15 AND `SourceEntry` = 0
  AND ((`SourceGroup` = 11473 AND `ConditionValue1` = 25700) OR (`SourceGroup` = 11613 AND `ConditionValue1` = 26170));

-- Blood Ritual on option 0
DELETE FROM `gossip_menu_option` WHERE (`MenuID` = 11473 AND (`OptionID` = 0 OR `OptionBroadcastTextID` = 41149))
  OR (`MenuID` = 11613 AND (`OptionID` = 0 OR `OptionBroadcastTextID` = 42213));
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(11473,0,0,'I would like to start the Blood Ritual, Lynnore.',41149,1,1,0,0,0,0,NULL,0,0),
(11613,0,0,'I would like to start the Blood Ritual, Kasim.',42213,1,1,0,0,0,0,NULL,0,0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (11473, 11613)
  AND (`SourceEntry` = 0 OR `ConditionValue1` IN (25686, 26160));
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,11473,0,0,0,9,0,25686,0,0,0,0,0,'','Bloodmage Lynnore - Blood Ritual option while Blood Ritual (H) is incomplete'),
(15,11613,0,0,0,9,0,26160,0,0,0,0,0,'','Kasim Sharim - Blood Ritual option while Blood Ritual (A) is incomplete');

DELETE FROM `creature_text` WHERE (`CreatureID` = 7506 AND `GroupID` IN (2,3)) OR (`CreatureID` = 42298 AND `GroupID` IN (2,3,4));
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(7506,2,0,'Very well.  Stand back... this may get messy.',12,1,100,0,0,0,0,41381,0,'Bloodmage Lynnore - Blood Ritual start'),
(7506,3,0,'The blood ritual is complete... and I can now see where Loramus Thalipedes awaits you.',12,1,100,0,0,0,0,41380,0,'Bloodmage Lynnore - Blood Ritual done'),
(42298,2,0,'Very well.  Stand back... this may get messy.',12,7,100,0,0,0,0,42214,0,'Kasim Sharim - Blood Ritual start'),
(42298,3,0,'The blood ritual is complete... and I can now see where three amulets await you.',12,7,100,0,0,0,0,42215,0,'Kasim Sharim - Blood Ritual done'),
(42298,4,0,'Quickly, $n!  We haven''t much time before Razelikh makes his return.',14,7,100,0,0,0,0,42287,0,'Kasim Sharim - Time is Short accepted');

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (7506, 42298);
DELETE FROM `smart_scripts` WHERE (`entryorguid` IN (7506, 42298) AND `source_type` = 0 AND `id` BETWEEN 0 AND 9)
  OR (`entryorguid` IN (750600, 4229800) AND `source_type` = 9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7506,0,0,1,62,0,100,0,11473,0,0,0,0,15,25686,0,0,0,0,0,17,0,15,0,0,0,0,0,0,'Bloodmage Lynnore - On Blood Ritual option - Credit Blood Ritual to players within 15 yd'),
(7506,0,1,2,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - Linked - Close Gossip'),
(7506,0,2,0,61,0,100,0,0,0,0,0,0,80,750600,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - Linked - Run Blood Ritual Script'),
(750600,9,0,0,0,0,100,0,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - Blood Ritual Script - Say Line 2'),
(750600,9,1,0,0,0,100,0,0,0,0,0,0,11,77573,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - Blood Ritual Script - Cast Blood Ritual'),
(750600,9,2,0,0,0,100,0,4000,4000,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - Blood Ritual Script - Say Line 3'),
(42298,0,0,1,62,0,100,0,11613,0,0,0,0,15,26160,0,0,0,0,0,17,0,15,0,0,0,0,0,0,'Kasim Sharim - On Blood Ritual option - Credit Blood Ritual to players within 15 yd'),
(42298,0,1,2,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Kasim Sharim - Linked - Close Gossip'),
(42298,0,2,0,61,0,100,0,0,0,0,0,0,80,4229800,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kasim Sharim - Linked - Run Blood Ritual Script'),
(42298,0,3,0,19,0,100,0,26163,0,0,0,0,1,4,0,1,0,0,0,7,0,0,0,0,0,0,0,0,'Kasim Sharim - On Time is Short accepted - Yell Line 4'),
(4229800,9,0,0,0,0,100,0,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kasim Sharim - Blood Ritual Script - Say Line 2'),
(4229800,9,1,0,0,0,100,0,0,0,0,0,0,11,77573,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kasim Sharim - Blood Ritual Script - Cast Blood Ritual'),
(4229800,9,2,0,0,0,100,0,4000,4000,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kasim Sharim - Blood Ritual Script - Say Line 3');

-- Progress texts (shown while the ritual is not done; SpecialFlags 2 keeps the quest incomplete until then)
DELETE FROM `quest_request_items` WHERE `ID` IN (25686, 26160);
INSERT INTO `quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`CompletionText`,`VerifiedBuild`) VALUES
(25686,0,0,'The ritual is not yet complete.',0),
(26160,0,0,'The blood ritual is not yet complete.',0);
