-- A new orc in the Valley of Trials is created facing Kaltunk, who stands 3 yd east of the start point, instead of the cliff to the
-- south. Sourced: both TDBs playercreateinfo orientation 0 for the Valley start (Kaltunk comments: "the first NPC they meet").
-- The seven orc classes that start here (1 3 4 7 8 9 10); the death knight row (Ebon Hold) is not touched.
UPDATE `playercreateinfo` SET `orientation` = 0 WHERE `race` = 2 AND `map` = 1 AND `zone` = 14 AND `class` IN (1, 3, 4, 7, 8, 9, 10);
