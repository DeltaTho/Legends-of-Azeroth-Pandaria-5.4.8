-- Badlands, The Day that Deathwing Came (27713 / 27714 / 27715): the common frame of the three stories (plan F-1)
-- Sourced: the retell texts 46593 / 47169 / 47242 and the turn-in lines 46594 / 47178 / 47255 (BroadcastText; the wiki gives who
-- says them and when). Ours: the gossip rows and their option ids (no source has the menu rows), the condition (shown while the
-- quest is in progress), the ScriptNames (zone_badlands_stories.cpp).

-- The tellers start their story on accept (real players only) and on the retell option; they speak up at the turn-ins
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_storyteller' WHERE `entry` IN (2785, 2920, 4618);

-- The stories' actors: passive, never fighting (the flying Deathwings 46484 / 46502, Martek the Awesome 46497, the Cowardly
-- Deathwing 47103, Martek's interrupters Theldurin 47157 and the giant Lucien 47163)
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_tddc_actor' WHERE `entry` IN (46484, 46502, 46497, 47103, 47157, 47163);

-- "Tell me that story again, <name>."
DELETE FROM `gossip_menu_option` WHERE (`MenuID`, `OptionID`) IN ((12131, 0), (12202, 0), (12209, 0));
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcflag`,
  `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(12131, 0, 0, 'Tell me that story again, Theldurin.', 46593, 1, 1, 0, 0, 0, 0, NULL, 0, 0),
(12202, 0, 0, 'Tell me that story again, Lucien.',    47169, 1, 1, 0, 0, 0, 0, NULL, 0, 0),
(12209, 0, 0, 'Tell me that story again, Martek.',    47242, 1, 1, 0, 0, 0, 0, NULL, 0, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (12131, 12202, 12209) AND `SourceEntry` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
  `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 12131, 0, 0, 0, 47, 0, 27713, 8, 0, 0, 0, 0, '', 'Theldurin: retell his story while The Day that Deathwing Came is in progress'),
(15, 12202, 0, 0, 0, 47, 0, 27714, 8, 0, 0, 0, 0, '', 'Lucien: retell his story while The Real Story is in progress'),
(15, 12209, 0, 0, 0, 47, 0, 27715, 8, 0, 0, 0, 0, '', 'Martek: retell his story while What Really Happened is in progress');

-- The next teller speaks up at each turn-in (Martek's groups 0-4, his Classic indurium lines, stay)
DELETE FROM `creature_text` WHERE `CreatureID` IN (2785, 2920);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`,
  `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(2785, 0, 0, 'Wow, Lucien.  You need to stop drinking RIGHT NOW.', 12, 0, 100, 0, 0, 0, 0, 47178, 0, 'Theldurin the Lost - 27714 rewarded'),
(2785, 1, 0, 'Sorry about the interruption, Martek.  You''ve gotta admit though... I made your story about fifty times better.  Next drink''s on me.', 12, 0, 100, 0, 0, 0, 0, 47255, 0, 'Theldurin the Lost - 27715 rewarded'),
(2920, 0, 0, 'No, no, no, Theldurin.  You''re telling the story wrong!', 12, 0, 100, 0, 0, 0, 0, 46594, 0, 'Lucien Tosselwrench - 27713 rewarded');
