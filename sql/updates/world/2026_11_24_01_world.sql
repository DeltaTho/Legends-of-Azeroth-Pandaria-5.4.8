-- Blasted Lands A (_01): Dreadmaul Hold quest order and givers (dossier S1 F-CHAIN-1, F-CHAIN-2).
--
-- SOURCED: wiki Template_Dreadmaul_Hold_quest_chain and quest "previous" fields; Ogre Combat after Futile Pride (quest text "I
-- saw your handiwork down there", comment 2014-07-09 [+2]); It's All Mine and Pick Your Fate after Heartstrike (41133 [+5],
-- 25677 2014-03-01 [+3]); Into the Mountain after both (25679 [+16], text "The next phase of operations"). One giver per quest
-- as both TDBs and Wowhead: Heartstrike from Okrilla only, Into the Mountain from Rofilian Dane only, Mission Complete from
-- Tak'arili only, The Dreadmaul Furnace from Okrilla only.
-- Encoding: a negative ExclusiveGroup with NextQuestID = every member rewarded before 25679 (Player::SatisfyQuestDependent-
-- PreviousQuests). No quest has PrevQuestID 25677 / 25678.
-- Idempotent: ON DUPLICATE KEY UPDATE of the named columns, absolute values.

INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`, `NextQuestID`, `ExclusiveGroup`) VALUES
(25675, 25674,     0,      0),   -- Ogre Combat after Futile Pride
(25677, 25676, 25679, -25677),   -- It's All Mine   \ after Heartstrike; both needed
(25678, 25676, 25679, -25677)    -- Pick Your Fate  / for Into the Mountain
ON DUPLICATE KEY UPDATE `PrevQuestID` = VALUES(`PrevQuestID`), `NextQuestID` = VALUES(`NextQuestID`), `ExclusiveGroup` = VALUES(`ExclusiveGroup`);

DELETE FROM `creature_queststarter` WHERE (`id`, `quest`) IN ((41133, 25676), (41134, 25679), (41124, 25682), (7506, 25683));
