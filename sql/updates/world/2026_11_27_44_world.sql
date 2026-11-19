-- Watershed Patrol (25188): the map areas of the four people to help carried the wrong objectives (the hut showed Misha's, Raggaran's spot
-- Zen'Taji's, Misha's farm none, Zen'Taji's camp Raggaran's). Sourced: TDB 4.4.2 quest_poi (hut = Tekla 39331, (49,-4220) = Raggaran 39332,
-- (729,-4256) = Misha 39333, (344,-3858) = Zen'Taji 39334) against mop's quest_objective 256506-256509 (index 0-3, same order) and the area
-- points of Idx1 1-4. Area 0 (Thonk's tower, the turn-in) unchanged.
UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 256506 WHERE `QuestID` = 25188 AND `Idx1` = 1;
UPDATE `quest_poi` SET `ObjectiveIndex` = 1, `QuestObjectiveId` = 256507 WHERE `QuestID` = 25188 AND `Idx1` = 2;
UPDATE `quest_poi` SET `ObjectiveIndex` = 2, `QuestObjectiveId` = 256508 WHERE `QuestID` = 25188 AND `Idx1` = 3;
UPDATE `quest_poi` SET `ObjectiveIndex` = 3, `QuestObjectiveId` = 256509 WHERE `QuestID` = 25188 AND `Idx1` = 4;
