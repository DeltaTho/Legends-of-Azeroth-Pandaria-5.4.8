-- Agmond's End: Dr. Hieronymus Blam 46664 gets his one SmartAI script and text set (Badlands ruling R6).
--
-- At the Troggish Troubles 27789 hand-in he says "I suppose we'll just have to throw these away... WAIT!  I think I'm having
-- an idea." and 5 s later "Yes, definitely an idea." (said, normal range). Group 2 "Hey, look!  It's flying!" is spoken by the
-- Return to Blam scene (section E, SendChat to the player, TextRange 5 = personal); no row here triggers it.
-- Sourced: the texts (wiki 27789 "On complete"; BroadcastText 46805, 46806, 47050).
-- Ours: the 5 s gap, the trigger on reward. mop had no creature_text and no AI for him. No ScriptName; the cave copy of Blam
--   (section B) uses the same entry and so these rows (it never sees 27789 handed in). Other sections never add rows for 46664;
--   groups 3-9 are free for later scenes.

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 46664;

DELETE FROM `creature_text` WHERE `CreatureID` = 46664;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(46664, 0, 0, 'I suppose we''ll just have to throw these away... WAIT!  I think I''m having an idea.', 12, 0, 100, 0, 0, 0, 0, 46805, 0, 'Dr. Hieronymus Blam - Troggish Troubles rewarded'),
(46664, 1, 0, 'Yes, definitely an idea.', 12, 0, 100, 0, 0, 0, 0, 46806, 0, 'Dr. Hieronymus Blam - Troggish Troubles rewarded, 5 s later'),
(46664, 2, 0, 'Hey, look!  It''s flying!', 12, 0, 100, 0, 0, 0, 0, 47050, 5, 'Dr. Hieronymus Blam - Return to Blam (said by the Eye scene)');

DELETE FROM `smart_scripts` WHERE (`entryorguid` = 46664 AND `source_type` = 0) OR (`entryorguid` = 4666400 AND `source_type` = 9);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(46664, 0, 0, 0, 20, 0, 100, 0, 27789, 0, 0, 0, 0, 80, 4666400, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Dr. Hieronymus Blam - On Troggish Troubles rewarded - Run Script'),
(4666400, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Dr. Hieronymus Blam - Script - Say Line 0'),
(4666400, 9, 1, 0, 0, 0, 100, 0, 5000, 5000, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Dr. Hieronymus Blam - Script - Say Line 1');
