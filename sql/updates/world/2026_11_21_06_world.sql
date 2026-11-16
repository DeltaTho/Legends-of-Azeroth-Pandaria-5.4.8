-- Searing Gorge A-21, A-22: Slag Pit quests 28054-28056 after 28052, 28061 after 28060, Scrange only ends 28057.
--
-- SOURCED: both TDBs (Rendan starts 28054-28056, Evonice ends them; Scrange only ends 28057), gate G5 / R-4, Wowhead 28062 2010-12-01.
-- OURS: PrevQuestID 28052 on 28054-28056. 28061 has no quest_template_addon row, so it is inserted, not updated.
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

-- 28054/28055/28056 only after Operation: Stir the Cauldron (retail: only the Slag Pit Rendan, visible after 28052, gives them)
UPDATE `quest_template_addon` SET `PrevQuestID` = 28052 WHERE `ID` IN (28054, 28055, 28056);
-- Evonice ends them; Rendan alone starts them (both TDBs)
DELETE FROM `creature_queststarter` WHERE `id` = 14628 AND `quest` IN (28054, 28055, 28056);
DELETE FROM `creature_queststarter` WHERE `id` = 14626 AND `quest` = 28057;
-- 28061 after 28060 (R-4): unconditional (sourced: "Talk to the questgiver again to grab Minions", 28062 2010-12-01 [+10])
-- A-fix: 28061 has no quest_template_addon row, so the draft's UPDATE is a no-op; insert-or-update instead
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`) VALUES (28061,28060) ON DUPLICATE KEY UPDATE `PrevQuestID`=VALUES(`PrevQuestID`);
