-- Swamp of Sorrows A (_04): Harborage and Splinterspear chain order (plan A-18..A-22; S4 dossier S4-C, F24913-3, 2.6, 2.7,
-- 3.3, 3.4, 27911#1).
--
-- SOURCED: wiki "previous" fields: The Purespring (A) after Secrets of the Mire; Breath of Mist after Prayerblossom; Remember the
-- Light after The Purespring; The Purespring (H) and Last Regrets after Secrets of the Mire and Prayerblossom (both); With Dying
-- Breath after The Purespring and Last Regrets (both); comment 27911 2011-01-01 [+4] (offered only at the
-- end of Neeka's chain).
-- OURS: Remember the Light needs The Purespring only, not Breath of Mist as well (user question 7: the wiki lists both, the
-- one first-hand account, 27904 2011-03-06, did the scene before Breath of Mist; the less grindy reading). The encoding:
-- negative ExclusiveGroups = every member rewarded (Player::SatisfyQuestDependentPreviousQuests).
-- 24913's SourceSpellID belongs to section D and is not touched here (only PrevQuestID / ExclusiveGroup are updated).
-- 27911's NextQuestID 27916 is kept.
-- Idempotent: INSERT ... ON DUPLICATE KEY UPDATE of the two columns only.

-- A-18 .. A-22
INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`, `ExclusiveGroup`) VALUES
(27902, 27876, 0),       -- The Purespring (A) after Secrets of the Mire
(27904, 27875, 0),       -- Breath of Mist after Prayerblossom
(24913, 27902, 0),       -- Remember the Light after The Purespring
(27907, 0, -27907),      -- Prayerblossom (H) \ both needed for
(27908, 0, -27907),      -- Secrets of the Mire (H) / 27909 and 27910
(27909, 27907, -27909),  -- The Purespring (H)  \ both needed for
(27910, 27907, -27909),  -- Last Regrets         / 27911
(27911, 27909, 0)        -- With Dying Breath
ON DUPLICATE KEY UPDATE `PrevQuestID` = VALUES(`PrevQuestID`), `ExclusiveGroup` = VALUES(`ExclusiveGroup`);
