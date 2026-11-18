-- Blasted Lands A (_02): Nethergarde Keep quest order and givers (dossier S2 F-CHAIN-2, F-CHAIN-3, F-CHAIN-4).
--
-- SOURCED: wiki 25708 / 25709 previous = A Closer Look; 25715 2011-01-20 [+6] "Completion of this quest unlocks Our Fallen
-- Friends and Curtail the Darktail"; 25709 2010-11-28 [+11]; wiki 25712 / 25713 previous = Minor Distractions; 25713 quest text
-- ("I couldn't help but overhear your conversation with the quartermaster") and 2010-11-30 edit. Watcher Mahar Ba after Our
-- Fallen Friends and Curtail the Darktail (wiki) and Lungertz's chain (25714 2011-02-10 replies [+4], [+0]). Kasim Sharim is
-- given by Watcher Mahar Ba only (both TDBs; Kasim is its ender).
-- OURS: Mahar Ba needs 25708 + 25709 + 25711, not 25712 / 25713 (ruling K8, the less grindy reading of "all the quests both
-- have to offer"); conditions rather than a negative group (no NextQuestID side effects). ConditionValue3 1 = plain reward
-- check (archetype "conditions on a faction-only quest"; all four quests are Alliance-only anyway).
-- Neither TDB links these (no addon rows for 25708 / 25712; 25709 / 25713 PrevQuestID 0).

INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`) VALUES
(25708, 25715),   -- Our Fallen Friends after A Closer Look
(25709, 25715),   -- Curtail the Darktail after A Closer Look
(25712, 25710),   -- Nethergarde Reigns after Minor Distractions
(25713, 25710)    -- Remove Their Arms after Minor Distractions
ON DUPLICATE KEY UPDATE `PrevQuestID` = VALUES(`PrevQuestID`);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` = 25714 AND `ConditionTypeOrReference` = 8;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 25714, 0, 0, 8, 0, 25708, 0, 1, 0, 0, 0, '', 'Watcher Mahar Ba - requires Our Fallen Friends rewarded'),
(19, 0, 25714, 0, 0, 8, 0, 25709, 0, 1, 0, 0, 0, '', 'Watcher Mahar Ba - requires Curtail the Darktail rewarded'),
(19, 0, 25714, 0, 0, 8, 0, 25711, 0, 1, 0, 0, 0, '', 'Watcher Mahar Ba - requires Eliminate the Okril''lon rewarded');

DELETE FROM `creature_queststarter` WHERE `id` = 42298 AND `quest` = 26157;
