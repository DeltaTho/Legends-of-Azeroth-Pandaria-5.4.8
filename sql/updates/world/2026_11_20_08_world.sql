-- Camp of the Deathwing stories: the map areas of The Day that Deathwing Came: The Real Story 27714 and What Really Happened
-- 27715 sit on the right objectives.
--
-- 27714 showed "Clouds searched" at the camp and nothing for growing; the whole-zone cloud polygon (Idx1 2, identical to retail)
--   carried an objective index with no id. 27715's four areas named the wrong objectives (admirer at the pillar, Deathwing at
--   the camp, knife fight at the canyon's end).
-- Sourced: TDB 12.1.0 quest_poi (areas matched by their points, which are the same in mop): 27714 camp = objective 0 (grow),
--   zone = objective 1 (clouds); 27715 camp = objective 0, canyon end = objective 1, pillar = objectives 2 and 3. Points and the
--   turn-in areas (ObjectiveIndex -1) are unchanged.

UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 255437 WHERE `QuestID` = 27714 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 1, `QuestObjectiveId` = 255438 WHERE `QuestID` = 27714 AND `Idx1` = 2;
UPDATE `quest_poi` SET `ObjectiveIndex` = 3, `QuestObjectiveId` = 255422 WHERE `QuestID` = 27715 AND `Idx1` = 0;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 255419 WHERE `QuestID` = 27715 AND `Idx1` = 2;
UPDATE `quest_poi` SET `ObjectiveIndex` = 1, `QuestObjectiveId` = 255420 WHERE `QuestID` = 27715 AND `Idx1` = 3;
UPDATE `quest_poi` SET `ObjectiveIndex` = 2, `QuestObjectiveId` = 255421 WHERE `QuestID` = 27715 AND `Idx1` = 4;
