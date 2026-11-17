-- Burning Steppes A (_03): map areas of Warlocks Have the Neatest Stuff 28181 and Done Nothing Wrong 28417 (plan A-11, A-19).
--
-- SOURCED: comments 28181 2010-11-26 [+5] / 2010-12-06 [+3] ("ignore the two blue areas on the east side; nothing to do with the
-- quest") and 28417 2011-06-27 [+13] (an area far from any whelp). Verified: 28181 Idx1 1-3 lie 1,800 yd from any warlock, sand or
-- cider; Idx1 4 / 5 are the Slumber Sand 206881 / Fel Slider Cider 206882 spots but were marked objective 0 (the orb); 28417 Idx1 6
-- (-7402,-2723) has no whelp within 900 yd. The Horde 28423 already has the layout made here for 28181.
-- OURS: the encoding (retail 12.x kept the bug; the 2010 comments are the source).
-- Idempotent: DELETE, absolute UPDATEs. Idx1 gaps are allowed (ObjectMgr::LoadQuestPOI keys points by quest and Idx1).

DELETE FROM `quest_poi_points` WHERE `QuestID` = 28181 AND `Idx1` IN (1, 2, 3);
DELETE FROM `quest_poi` WHERE `QuestID` = 28181 AND `Idx1` IN (1, 2, 3);
UPDATE `quest_poi` SET `ObjectiveIndex` = 1, `QuestObjectiveId` = 252836 WHERE `QuestID` = 28181 AND `Idx1` = 4; -- Slumber Sand 63132
UPDATE `quest_poi` SET `ObjectiveIndex` = 2, `QuestObjectiveId` = 252837 WHERE `QuestID` = 28181 AND `Idx1` = 5; -- Fel Slider Cider 63133

DELETE FROM `quest_poi_points` WHERE `QuestID` = 28417 AND `Idx1` = 6;
DELETE FROM `quest_poi` WHERE `QuestID` = 28417 AND `Idx1` = 6;
