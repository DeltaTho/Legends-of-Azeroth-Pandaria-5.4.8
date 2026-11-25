-- Northern Barrens, Crossroads Caravan Delivery (13975): the map showed no marker on Rocco Whipshank 34578, who starts the ride
-- (play test 2026-11-24). The quest's one objective POI was tied to objective 269006 (index 0, the cleaned-up gun 46714), which
-- Rocco hands over on accept, so the client counted it done and hid the marker. The retail POI (poi.md) sits on the escort
-- objective; ours now does too: index 1 / 264970 "Crossroads Caravan Escorted", at Rocco by the Grol'dom kodo pen
-- (retail point 202,-2983 is the ride start 50 yd south-west of him; ours is on Rocco himself, as 29109's is on him).
UPDATE `quest_poi` SET `ObjectiveIndex`=1, `QuestObjectiveId`=264970 WHERE `QuestID`=13975 AND `Idx1`=1;
UPDATE `quest_poi_points` SET `X`=222, `Y`=-2936 WHERE `QuestID`=13975 AND `Idx1`=1 AND `Idx2`=0;
