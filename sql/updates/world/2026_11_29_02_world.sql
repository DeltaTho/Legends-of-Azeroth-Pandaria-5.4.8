-- Northern Barrens S1 (_02): the Far Watch / Crossroads caravan chain - stray givers and enders, the chain order, map areas,
-- Crossroads Supply Crate respawn.
-- (plan.md section 1 `_02`; dossier B: B-1, B-2, B-4, B-5.)
--
-- SOURCED: the starter / ender rows removed are in neither TDB nor on Wowhead or the wiki (dossier B findings 871-1, 5041-1,
-- 872-2, 13975-3, 29095-1, 29109-3, 29110-1, 29111-3); Thork keeps 872 as starter (both TDBs). 5041 and 872 follow 871 (both
-- TDBs, wiki); 13949 needs 872 and 5041 (wiki 13949 "previous = Supplies for the Crossroads / The Far Watch Offensive";
-- Wowhead 2010-11-24 [+9] and reply [+3]); 13975 follows 13949 (Rocco's gossip 34790 and texts; Wowhead comment 2011 [+1]).
-- The map areas at Rocco / Nagala are the "speak to" objective (index 0); 13975's is its item objective 269006 (index
-- 0, the id retail uses) (tdb-diff section 6 / poi.md). Crates 120 s (both TDBs).
-- After this file every quest touched keeps a giver and an ender: 871 Gar'dul 3337 / 3337; 872 Thork 3429 / 3337;
-- 5041 Halga 34258 / 34258; 13975 Rocco 34578 / Thork; 29095 3449 / Thork; 29109 Thork / Nagala 52207;
-- 29110 Nagala / Balgor 52309; 29111 Nagala / Kadrak 8582.
-- Note: 13975 after 13949 only plays with the S2 caravan rides (same deploy).

-- B-1: givers and enders no source has.
DELETE FROM `creature_queststarter` WHERE (`id`,`quest`) IN ((3429,871),(3429,5041),(3429,13975),(3429,29095),(52207,29109),(52309,29110),(8582,29111));
DELETE FROM `creature_questender` WHERE (`id`,`quest`) IN ((3429,871),(3429,872),(3429,5041));

-- B-2: 5041 and 872 follow 871; 13975 follows 13949; 13949 needs both 872 and 5041.
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`) VALUES (5041,871) ON DUPLICATE KEY UPDATE `PrevQuestID`=871;
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`) VALUES (872,871) ON DUPLICATE KEY UPDATE `PrevQuestID`=871;
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`) VALUES (13975,13949) ON DUPLICATE KEY UPDATE `PrevQuestID`=13949;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceEntry`=13949;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,13949,0,0,8,0,872,0,0,0,0,0,'','Crossroads Caravan Pickup: after The Far Watch Offensive'),
(19,0,13949,0,0,8,0,5041,0,0,0,0,0,'','Crossroads Caravan Pickup: after Supplies for the Crossroads');

-- B-4: map areas on the objective retail uses (29109 / 29111 "speak to", 13975 its item objective).
UPDATE `quest_poi` SET `ObjectiveIndex`=0, `QuestObjectiveId`=252623 WHERE `QuestID`=29109 AND `Idx1`=1;
UPDATE `quest_poi` SET `ObjectiveIndex`=0, `QuestObjectiveId`=252932 WHERE `QuestID`=29111 AND `Idx1`=1;
UPDATE `quest_poi` SET `ObjectiveIndex`=0, `QuestObjectiveId`=269006 WHERE `QuestID`=13975 AND `Idx1`=1;

-- B-5: Crossroads Supply Crates respawn in 120 s (mop 300 s).
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `id`=175708;

-- Coverage 2.3: The Demon Seed (29112) is used up when looted and back after 120 s (both TDBs: Data3 consumable 1,
-- spawn 216730 120 s; mop 0 / 300 s). Its only spawn is 175238 (zone 17).
UPDATE `gameobject_template` SET `Data3`=1 WHERE `entry`=3524 AND `type`=3;
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `guid`=175238 AND `id`=3524;
