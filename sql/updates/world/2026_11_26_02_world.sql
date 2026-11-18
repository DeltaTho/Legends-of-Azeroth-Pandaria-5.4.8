-- Searing Gorge: Dark Ministry (27979): point the map marker at a minister whose spherule is still missing.
-- After 2026_11_26_01 the user saw a marker on Finister that stayed there after his spherule was looted: the 5.4.8 client
-- draws one area per objective and keeps it until the objective is done, and the quest has one objective (the Twilight
-- Tripetricine made from the three spherules) for three ministers.
-- Ours: each minister's area is sent only while the player lacks that minister's spherule (quest POI blob conditions,
-- source type 31: SourceGroup = quest, SourceEntry = quest_poi.Idx1).
-- Limit, confirmed in play: the client keeps a quest's areas for the whole session and ignores a resend, so the marker
-- moves on at the next login, not at the moment of looting. Moving it live would need one objective per minister.
--   Idx1 0 (-6739,-708) Minister Kiyuubi 47309  -> Kiyuubi's Spherule 62825
--   Idx1 1 (-6490,-874) Minister Finister 47311 -> Finister's Spherule 62824
--   Idx1 2 (-6646,-657) Minister Letherio 47310 -> Letherio's Spherule 62823
-- Once the Tripetricine is made the spherules are gone, but the objective is complete and the client hides its areas.

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 31 AND `SourceGroup` = 27979 AND `SourceEntry` IN (0, 1, 2);
INSERT INTO `conditions`
(`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`,
 `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(31, 27979, 0, 0, 0, 2, 0, 62825, 1, 1, 1, 0, 0, '', 'Dark Ministry - map area on Minister Kiyuubi while the player lacks Kiyuubi''s Spherule'),
(31, 27979, 1, 0, 0, 2, 0, 62824, 1, 1, 1, 0, 0, '', 'Dark Ministry - map area on Minister Finister while the player lacks Finister''s Spherule'),
(31, 27979, 2, 0, 0, 2, 0, 62823, 1, 1, 1, 0, 0, '', 'Dark Ministry - map area on Minister Letherio while the player lacks Letherio''s Spherule');
