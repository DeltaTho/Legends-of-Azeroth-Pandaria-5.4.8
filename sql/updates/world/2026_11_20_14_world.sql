-- Camp of the Deathwing stories: the three tellers' stories are offered in order, 27713 -> 27714 -> 27715.
--
-- All three were offered at once, so Martek's story could come first. Sourced: wiki infoboxes (27714 previous = 27713, 27715
-- previous = 27714), comment 2012-01-15 [+21] "You MUST do the other 2 quests in the chain first"; the quest texts refer to the
-- previous tellers' stories. Against both TDBs (no link; Badlands ruling R2: enforced). None of the three is completable
-- before section F's stories ship, so this changes nothing playable on its own.
-- No addon rows exist for 27714 / 27715: INSERT IGNORE creates them, the absolute UPDATEs set the links; a row another section
-- adds keeps its other columns.

INSERT IGNORE INTO `quest_template_addon` (`ID`) VALUES (27714), (27715);
UPDATE `quest_template_addon` SET `PrevQuestID` = 27713 WHERE `ID` = 27714;
UPDATE `quest_template_addon` SET `PrevQuestID` = 27714 WHERE `ID` = 27715;
