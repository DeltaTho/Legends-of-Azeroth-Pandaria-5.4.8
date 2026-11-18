-- Searing Gorge: Dark Ministry (27979) showed no objective markers on the map (reported by the user in play, 2026-11-18).
-- The quest has one objective, the Twilight Tripetricine 62828 (quest_objective id 259811, index 0), which the player makes
-- from the three ministers' spherules. Its three map areas sit on the ministers (Kiyuubi -6739,-708; Finister -6490,-874;
-- Letherio -6646,-657) but carried ObjectiveIndex 27 / 28 / 29 with QuestObjectiveId 0. Retail TDB 12.1.0 has the same
-- values, which is why the Searing Gorge pass left them; the 5.4.8 client draws an area only for an objective it knows
-- (ObjectiveIndex = quest_objective.index, QuestObjectiveId = quest_objective.id) and so drew none of the three.
-- Ours: tying all three areas to the item objective. They clear together once the Tripetricine is in the bags.
-- The turn-in area (Idx1 3, ObjectiveIndex -1) is unchanged. Needs a server restart and a relog (the client caches areas).

UPDATE `quest_poi` SET `ObjectiveIndex` = 0, `QuestObjectiveId` = 259811
 WHERE `QuestID` = 27979 AND `Idx1` IN (0, 1, 2);
