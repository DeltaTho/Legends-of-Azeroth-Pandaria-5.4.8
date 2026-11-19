-- Valley of Trials quest map areas that point at the wrong objective or none.
-- Burning Blade Medallion (25132): the area on Yarrog's ledge (Idx1 2, one point at -77,-4206) carried the Felstalker objective
-- (265588), so it vanished after the 7th Felstalker while the medallion was still needed. Sourced: TDB 1210 puts the medallion
-- objective (265589, quest_objective index 1) on that area; TDB 4.4.2 has a separate medallion blob too.
-- Class training quests 25139 25141 25143 25145 25147 25149: the training-dummy area (Idx1 1) was in the Cataclysm format
-- (QuestObjectiveId 0), which the 5.4.8 client never clears; 25139 and 25145 also drew it on the Durotar map (4) instead of the
-- Valley map 889, where the turn-in area of the same quests already is. Ours: the 5.x pair (the "Practice" objective's id and its
-- quest_objective.index 0), the convention of most mop quest_poi rows that name an objective (14362 of 14665 use ObjectiveIndex =
-- quest_objective.index). Not settled for learn-spell quests: TDB 1210 numbers 25141's area 1 (by Order); test in game that the area
-- clears when Practice completes. The other class-training quests of every starting zone keep the Cataclysm format (left).
UPDATE `quest_poi` SET `ObjectiveIndex` = 1, `QuestObjectiveId` = 265589 WHERE `QuestID` = 25132 AND `Idx1` = 2;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 265174, `WorldMapAreaId` = 889, `Floor` = 0 WHERE `QuestID` = 25139 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 264946 WHERE `QuestID` = 25141 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 267981 WHERE `QuestID` = 25143 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 266412, `WorldMapAreaId` = 889, `Floor` = 0 WHERE `QuestID` = 25145 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 265002 WHERE `QuestID` = 25147 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 264910 WHERE `QuestID` = 25149 AND `Idx1` = 1;
