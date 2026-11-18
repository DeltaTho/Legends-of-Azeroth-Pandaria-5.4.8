-- Blasted Lands, You Are Rakh'likh, Demon (25701 H / 26171 A): the quest's second map area belongs to its second objective
-- ("Razelikh's soul imprisoned", Loramus the Defiled 41292), not to the first, so it stays until the soul is sealed.
-- Sourced: both TDBs tie this area to the 41292 objective (12.1.0: ObjectiveIndex 1, objective 255815 / 265582; 4.4.2: the
-- 41292 objective). Loaded at startup.
UPDATE `quest_poi` SET `ObjectiveIndex`=1, `QuestObjectiveId`=255815 WHERE `QuestID`=25701 AND `Idx1`=2;
UPDATE `quest_poi` SET `ObjectiveIndex`=1, `QuestObjectiveId`=265582 WHERE `QuestID`=26171 AND `Idx1`=2;
