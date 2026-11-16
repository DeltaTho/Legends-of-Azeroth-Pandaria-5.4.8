-- Searing Gorge A-13, A-14, A-18, A-20: Thorium Point quest gates, extra starters removed, Deceit needs all three.
--
-- SOURCED: both TDBs only for the starter deletions (27986 only Hansel, 28035 only Rendan, 27470 only Oilfist); gate G2 / G6, R-2, R-6.
-- OURS (order from the wiki 'previous' fields and the dossier, not from the TDBs, which have no such rows): the link 27965 -> Thorium Point
-- quests; 28028-28030 and 28032 after 27986; 27979 after 27976 by PrevQuestID plus condition QUESTREWARDED 27977; ExclusiveGroup -28028 on 28028-28030 (none is any quest's
-- PrevQuestID, R-1 safe; 28033 has all three as NextQuestID so it needs all three, Player.cpp 17100-17138); 28032 after 27986.
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`) VALUES
(27976,27965),(27977,27965),(27980,27965),(27981,27965),(27982,27965),(28099,27965)
ON DUPLICATE KEY UPDATE `PrevQuestID`=VALUES(`PrevQuestID`);
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`) VALUES (27979,27976)
ON DUPLICATE KEY UPDATE `PrevQuestID`=VALUES(`PrevQuestID`);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceEntry`=27979;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,27979,0,0,8,0,27977,0,0,0,0,0,'','Dark Ministry - requires Recon Essentials rewarded');
-- TP-7 (F11, F11b, G6) starters neither TDB has
DELETE FROM `creature_queststarter` WHERE (`id`,`quest`) IN ((47393,27986),(14625,28035),(10299,27470));
-- TP-12 (F12, R-6) Rendan's and Agnes' quests after 27986; Deceit after ALL of 28028-28030
-- (none of 28028-28030 is any quest's PrevQuestID, so the negative group cannot leak: decisions R-1 rule)
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`,`ExclusiveGroup`) VALUES
(28028,27986,-28028),(28029,27986,-28028),(28030,27986,-28028),(28032,27986,0)
ON DUPLICATE KEY UPDATE `PrevQuestID`=VALUES(`PrevQuestID`), `ExclusiveGroup`=VALUES(`ExclusiveGroup`);
