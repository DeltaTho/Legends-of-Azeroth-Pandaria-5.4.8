-- Young and Vicious map areas; the Lost Bloodtalon Hatchlings' emotes in Saving the Young.
--
-- 1. The polygon round Kijara's island is "Capture Swiftclaw" (objective index 0, 266030) and the point at the pen (-1280,-5456)
--    is "Return Swiftclaw to the Raptor Pens" (index 1, 266031). Sourced: TDB 12.1.0 quest_poi (tdb-diff.md section 6); mop had
--    the two swapped, so the map sent the player to the pen to catch the raptor.
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 266030 WHERE `QuestID` = 24626 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 1, `QuestObjectiveId` = 266031 WHERE `QuestID` = 24626 AND `Idx1` = 2;

-- 2. A whistled hatchling sometimes emotes at the player ("%s yips in appreciation." ...), on or off the quest, and follows for 80 s
--    before it despawns. Sourced: TDB 4.4.2 and 12.1.0 creature_text 39157 group 0 (broadcast 37760-37766, type 16) and
--    smart_scripts 39157 id 3 (spell hit 70874: 30 % chance, 80 s cooldown, Talk 0 to the whistler) and id 2 (despawn after 80 s;
--    mop 60 s); warcraft.wiki.gg Saving the Young notes (the emote list); Wowhead 24623 2010-11-24 ("cute emotes even if you're
--    not on the quest"). mop had neither the texts nor the row.
DELETE FROM `creature_text` WHERE `CreatureID` = 39157 AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(39157, 0, 0, '%s yips in appreciation.', 16, 0, 100, 0, 0, 0, 0, 37760, 0, 'Lost Bloodtalon Hatchling to Player'),
(39157, 0, 1, '%s bounces up and down.', 16, 0, 100, 0, 0, 0, 0, 37761, 0, 'Lost Bloodtalon Hatchling to Player'),
(39157, 0, 2, '%s lets out a little screech.', 16, 0, 100, 0, 0, 0, 0, 37762, 0, 'Lost Bloodtalon Hatchling to Player'),
(39157, 0, 3, '%s waves its horn at you.', 16, 0, 100, 0, 0, 0, 0, 37763, 0, 'Lost Bloodtalon Hatchling to Player'),
(39157, 0, 4, '%s skips after you.', 16, 0, 100, 0, 0, 0, 0, 37764, 0, 'Lost Bloodtalon Hatchling to Player'),
(39157, 0, 5, '%s almost falls on his face in excitement.', 16, 0, 100, 0, 0, 0, 0, 37765, 0, 'Lost Bloodtalon Hatchling to Player'),
(39157, 0, 6, '%s taps his little claws on the ground as he runs to you.', 16, 0, 100, 0, 0, 0, 0, 37766, 0, 'Lost Bloodtalon Hatchling to Player');
DELETE FROM `smart_scripts` WHERE `entryorguid` = 39157 AND `source_type` = 0 AND `id` = 3;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(39157, 0, 3, 0, 8, 0, 30, 0, 70874, 0, 80000, 80000, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 'Lost Bloodtalon Hatchling - On Spellhit ''Bloodtalon Whistle'' - Say Text');
UPDATE `smart_scripts` SET `action_param1` = 80000 WHERE `entryorguid` = 39157 AND `source_type` = 0 AND `id` = 2;
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 39157;
