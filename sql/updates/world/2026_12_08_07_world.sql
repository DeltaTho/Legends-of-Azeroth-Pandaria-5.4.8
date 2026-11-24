-- Proving Pit: the map area at the pit belongs to "Speak to a Darkspear Jailor".
-- Sourced: TDB 12.1.0 quest_poi (tdb-diff.md section 6, 24642 at -1136,-5414): the area is objective index 0 (the jailor) with its
-- objective id. mop's eight copies had index 1 with QuestObjectiveId 0 (old format); its monk copy 31161 already has 0 / 268186.
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 265095 WHERE `QuestID` = 24642 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 254662 WHERE `QuestID` = 24754 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 267219 WHERE `QuestID` = 24762 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 265214 WHERE `QuestID` = 24768 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 265373 WHERE `QuestID` = 24774 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 267586 WHERE `QuestID` = 24780 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 265701 WHERE `QuestID` = 24786 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 266817 WHERE `QuestID` = 26276 AND `Idx1` = 1;
