-- Burning Steppes B (_14): Morgan's Vigil / Flame Crest chain order; Assault on Dreadmaul Rock after Locked and Loaded; the bosses
-- do not give the Alliance deliveries (plan B-17, B-18, B-19; S4-F3, S4-F2, S4-F6).
--
-- SOURCED: wiki "previous=" on every quest page: Blackened Ashes / Latent Demons of the Land / A Heap of Delicious Worg (28311-28313,
-- 28443-28445) after Morgan's Vigil 28310 / Flame Crest 28442; Blood Tour, Draconic Vanguard and A Deal With a Dragon after all three;
-- Assault on Dreadmaul Rock 28320 / 28454 after Locked and Loaded 28327 / 28453 (mop: Alliance after Placing the Pawns, so it was
-- offered during the deliveries; Horde with no prerequisite at all). Both TDBs: Troteman gives all three deliveries, not the bosses.
-- OURS: the encoding (negative ExclusiveGroup + NextQuestID = every member needed; 28315 / 28316 / 28447 / 28448 with a positive
-- PrevQuestID that is a member of the group need the whole group, Player::SatisfyQuestDependentPreviousQuests).
-- Idempotent: INSERT .. ON DUPLICATE KEY UPDATE with absolute values (28311, 28312, 28443, 28444 had no addon row; other columns of
-- the existing rows are left alone, e.g. section F's SourceSpellID on 28320 / 28454), absolute UPDATEs, DELETE.

INSERT INTO `quest_template_addon` (`ID`, `MaxLevel`, `AllowableClasses`, `SourceSpellID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`, `RewardMailTemplateID`, `RewardMailDelay`, `RequiredSkillID`, `RequiredSkillPoints`, `RequiredMinRepFaction`, `RequiredMaxRepFaction`, `RequiredMinRepValue`, `RequiredMaxRepValue`, `ProvidedItemCount`, `SpecialFlags`, `ScriptName`) VALUES
(28311, 0, 0, 0, 28310, 28314, -28311, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ''),
(28312, 0, 0, 0, 28310, 28314, -28311, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ''),
(28443, 0, 0, 0, 28442, 28446, -28443, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ''),
(28444, 0, 0, 0, 28442, 28446, -28443, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '')
ON DUPLICATE KEY UPDATE `PrevQuestID` = VALUES(`PrevQuestID`), `NextQuestID` = VALUES(`NextQuestID`), `ExclusiveGroup` = VALUES(`ExclusiveGroup`);
UPDATE `quest_template_addon` SET `PrevQuestID` = 28310, `NextQuestID` = 28314, `ExclusiveGroup` = -28311 WHERE `ID` = 28313;
UPDATE `quest_template_addon` SET `PrevQuestID` = 28442, `NextQuestID` = 28446, `ExclusiveGroup` = -28443 WHERE `ID` = 28445;
UPDATE `quest_template_addon` SET `PrevQuestID` = 28311 WHERE `ID` IN (28315, 28316);
UPDATE `quest_template_addon` SET `PrevQuestID` = 28443 WHERE `ID` IN (28447, 28448);

-- Assault after Locked and Loaded (plan K12: ships alone, before section F's event)
UPDATE `quest_template_addon` SET `PrevQuestID` = 28327 WHERE `ID` = 28320;
UPDATE `quest_template_addon` SET `PrevQuestID` = 28453 WHERE `ID` = 28454;

DELETE FROM `creature_queststarter` WHERE (`id`, `quest`) IN ((48316, 28317), (48314, 28318), (48312, 28319));
