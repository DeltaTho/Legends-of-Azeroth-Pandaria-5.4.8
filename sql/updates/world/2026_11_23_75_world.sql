-- Swamp of Sorrows, Maliciously Delicious 27587: the Silversnap Swim Tonic (62795) works, and Trade Baron Silversnap gives more.
-- Sourced: the tonic's effects and zone limit (comments 2010-12-01 [+8], 2010-11-27 [+5], 2011-03-23 [+7]; spells 88026 / 88416 /
--   88008, AreaGroup 2801 = zone 8); "Gimme some more of that swim tonic!" (menu 12103, BT 47576, both TDBs: two identical rows, one
--   kept), given again and again, also after the quest (comments 2012-04-29 [+2], 62795 2010-11-28 reply, 2011-02-10 [+6]);
--   88417 'Create Silversnap Swim Tonic' (CREATE_ITEM 62795 on its target, 30 yd).
-- Ours: the mechanism (spell_bogpaddle_silversnap_swim_tonic on the item's marker aura 88026 puts 88416 on the player while he
--   swims or is under water, takes it in shallows, and starts it again when its linked 88008 has run out; no spell_area row: it
--   would give 88416 once per drink, and the core strips 88416 on every move out of the water); the option's condition (27587 in the log or rewarded, mask 74); OptionNpcflag 1; Silversnap casts
--   88417 on the player (triggered) and closes the window.

DELETE FROM `spell_script_names` WHERE `spell_id` = 88026 AND `ScriptName` = 'spell_bogpaddle_silversnap_swim_tonic';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(88026, 'spell_bogpaddle_silversnap_swim_tonic');

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 12103;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcflag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(12103, 0, 0, 'Gimme some more of that swim tonic!', 47576, 1, 1, 0, 0, 0, 0, '', 0, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 12103;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 12103, 0, 0, 0, 47, 0, 27587, 74, 0, 0, 0, 0, '', 'Trade Baron Silversnap - swim tonic option while Maliciously Delicious is in the log or rewarded');

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 45786;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 45786 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(45786, 0, 0, 1, 62, 0, 100, 0, 12103, 0, 0, 0, 0, 11, 88417, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Trade Baron Silversnap - On Gossip Option 0 Selected - Cast Create Silversnap Swim Tonic on Invoker (triggered)'),
(45786, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Trade Baron Silversnap - Linked - Close Gossip');
