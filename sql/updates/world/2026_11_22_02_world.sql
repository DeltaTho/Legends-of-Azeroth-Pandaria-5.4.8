-- Burning Steppes A (_02): Done Nothing Wrong hand-in dialogue at Flamestar Post (plan A-10).
--
-- SOURCED: wiki 28172 "On complete" and comment 2011-06-16 [+6]: Keeshan (Alliance) / Ariok (Horde) yells "Flamestar! I can return
-- these dragons to their kind. Let me take care of them." and Mouton answers "As you wish. Just make sure they don't come to no
-- harm."; broadcast_text 48780 / 48781.
-- OURS: the trigger (Mouton's SmartAI on the reward of 28172 / 28417 makes the camp Keeshan / Ariok yell, Mouton answers 4 s
-- later; neither TDB has a script). The speaker is found by spawn guid (318100 / 165205, SMART_TARGET_CREATURE_GUID), which
-- ignores phases: section C puts them in phases 225 / 334 and a closest-creature search from the phaseless Mouton finds nobody and TextRange 5 on the yell: Keeshan 47811 and Ariok 48559 are staged per player (section C),
-- so their line goes only to the player who handed in.
-- Idempotent: DELETE + INSERT, absolute UPDATE.

DELETE FROM `creature_text` WHERE `CreatureID` IN (47811, 48559, 47779) AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(47811, 0, 0, 'Flamestar!  I can return these dragons to their kind.  Let me take care of them.', 14, 0, 100, 0, 0, 0, 0, 48780, 5, 'John J. Keeshan - Done Nothing Wrong turned in'),
(48559, 0, 0, 'Flamestar!  I can return these dragons to their kind.  Let me take care of them.', 14, 0, 100, 0, 0, 0, 0, 48780, 5, 'Ariok - Done Nothing Wrong turned in'),
(47779, 0, 0, 'As you wish.  Just make sure they don''t come to no harm.', 12, 0, 100, 1, 0, 0, 0, 48781, 0, 'Mouton Flamestar - reply');

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 47779 AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE `entryorguid` = 47779 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(47779, 0, 0, 2, 20, 0, 100, 0, 28172, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 10, 318100, 47811, 0, 0, 0, 0, 0, 0, 'Mouton Flamestar - On Done Nothing Wrong (A) rewarded - Keeshan (spawn 318100) yells to the player'),
(47779, 0, 1, 2, 20, 0, 100, 0, 28417, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 10, 165205, 48559, 0, 0, 0, 0, 0, 0, 'Mouton Flamestar - On Done Nothing Wrong (H) rewarded - Ariok (spawn 165205) yells to the player'),
(47779, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 67, 1, 4000, 4000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Mouton Flamestar - Linked - Timed event 1 in 4 s'),
(47779, 0, 3, 0, 59, 0, 100, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Mouton Flamestar - Timed event 1 - Say reply');
