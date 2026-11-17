-- Burning Steppes B (_18, fix round 1): a new Blackrock Disguise from Colonel Troteman / Eitrigg during the deliveries (walk vigil W3).
--
-- SOURCED: the deliveries' own objective text (28317, 28318, 28450-28452 LogDescription: "Speak with Colonel Troteman / Eitrigg if
-- you need a new Blackrock Disguise"); wiki 28326 / 28449 "should something happen to it, talk to Troteman / Eitrigg. He has
-- another."; comment 28317 2011-04-03 [+2].
-- OURS: the mechanism and the option text (no TDB has an option on menus 12434 / 12447 and no broadcast text was found): option 0
-- "I need a new Blackrock Disguise." shown only while a delivery of the player's faction is held (in progress or complete) and he has
-- no Blackrock Disguise 63357 in bags or bank; choosing it puts one in his bags and closes the window. OptionNpcflag 1 (gossip), so
-- Player::PrepareGossipMenu does not skip it (C42). Menu 12434 is also Troteman 48110's at Chiselgrip and 12447 Eitrigg 48568's; those
-- copies are staged away before the deliveries (section C) and have no SmartAI for the option.
-- Idempotent: DELETE + INSERT, absolute UPDATE.

DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (12434, 12447) AND `OptionID` = 0;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcflag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(12434, 0, 0, 'I need a new Blackrock Disguise.', 0, 1, 1, 0, 0, 0, 0, '', 0, 0),
(12447, 0, 0, 'I need a new Blackrock Disguise.', 0, 1, 1, 0, 0, 0, 0, '', 0, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (12434, 12447) AND `SourceEntry` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 12434, 0, 0, 0, 47, 0, 28317, 10, 0, 0, 0, 0, '', 'Troteman - new disguise: A Delivery for Thorg''izog held'),
(15, 12434, 0, 0, 0, 2, 0, 63357, 1, 1, 1, 0, 0, '', 'Troteman - new disguise: no Blackrock Disguise in bags or bank'),
(15, 12434, 0, 0, 1, 47, 0, 28318, 10, 0, 0, 0, 0, '', 'Troteman - new disguise: or A Delivery for Neeralak held'),
(15, 12434, 0, 0, 1, 2, 0, 63357, 1, 1, 1, 0, 0, '', 'Troteman - new disguise: no Blackrock Disguise in bags or bank'),
(15, 12434, 0, 0, 2, 47, 0, 28319, 10, 0, 0, 0, 0, '', 'Troteman - new disguise: or A Delivery for Xi''lun held'),
(15, 12434, 0, 0, 2, 2, 0, 63357, 1, 1, 1, 0, 0, '', 'Troteman - new disguise: no Blackrock Disguise in bags or bank'),
(15, 12447, 0, 0, 0, 47, 0, 28450, 10, 0, 0, 0, 0, '', 'Eitrigg - new disguise: A Delivery for Thorg''izog held'),
(15, 12447, 0, 0, 0, 2, 0, 63357, 1, 1, 1, 0, 0, '', 'Eitrigg - new disguise: no Blackrock Disguise in bags or bank'),
(15, 12447, 0, 0, 1, 47, 0, 28451, 10, 0, 0, 0, 0, '', 'Eitrigg - new disguise: or A Delivery for Neeralak held'),
(15, 12447, 0, 0, 1, 2, 0, 63357, 1, 1, 1, 0, 0, '', 'Eitrigg - new disguise: no Blackrock Disguise in bags or bank'),
(15, 12447, 0, 0, 2, 47, 0, 28452, 10, 0, 0, 0, 0, '', 'Eitrigg - new disguise: or A Delivery for Xi''lun held'),
(15, 12447, 0, 0, 2, 2, 0, 63357, 1, 1, 1, 0, 0, '', 'Eitrigg - new disguise: no Blackrock Disguise in bags or bank');

-- the SmartAI rows of 48307 ids 0-1 and 48569 id 0 are _16's; these add the option's
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (48307, 48569) AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND ((`entryorguid` = 48307 AND `id` IN (2, 3)) OR (`entryorguid` = 48569 AND `id` IN (1, 2)));
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(48307, 0, 2, 3, 62, 0, 100, 0, 12434, 0, 0, 0, 0, 56, 63357, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Colonel Troteman - On Gossip Option 0 - Add Blackrock Disguise'),
(48307, 0, 3, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Colonel Troteman - Linked - Close Gossip'),
(48569, 0, 1, 2, 62, 0, 100, 0, 12447, 0, 0, 0, 0, 56, 63357, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Eitrigg - On Gossip Option 0 - Add Blackrock Disguise'),
(48569, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Eitrigg - Linked - Close Gossip');
