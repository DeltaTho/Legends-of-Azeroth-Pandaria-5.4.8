-- Searing Gorge A-1..A-3: breadcrumbs optional and exclusive while held; Dark Iron Memo 100 %; Gravius's aggro yell.
--
-- SOURCED: wiki 27963 (breadcrumbs optional), Wowhead comments 28512 2011-06-19 / 28581 2011-03-12, 2011-12-06; both TDBs (Memo 100 %);
-- comment 47270 2011-01-17 (BroadcastText 50363). OURS: the mechanism (NextQuestID 0 + source-19 conditions instead of the TDB's positive
-- ExclusiveGroup, which is mutually exclusive in this core), the yell type for Gravius's line.
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

-- F-BC-1/2/3: Searing Gorge breadcrumbs are optional and exclusive while held (sourced: wiki 27963, Wowhead comments
-- 28512 2011-06-19, 28581 2011-03-12 / 2011-12-06). TDB's NextQuestID 27963 + ExclusiveGroup 28512 not copied (0.5, C25).
UPDATE `quest_template_addon` SET `NextQuestID`=0, `ExclusiveGroup`=0 WHERE `ID` IN (28512,28581,28582);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceGroup`=0 AND `SourceEntry` IN (28512,28581,28582);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,28512,0,0,14,0,27963,0,0,0,0,0,'','To the Aid of the Thorium Brotherhood - only before A New Master... But Who?'),
(19,0,28512,0,0,28,0,28581,0,0,1,0,0,'','To the Aid of the Thorium Brotherhood - not while Warchief''s Command is held'),
(19,0,28512,0,0,28,0,28582,0,0,1,0,0,'','To the Aid of the Thorium Brotherhood - not while Hero''s Call is held'),
(19,0,28581,0,0,14,0,27963,0,0,0,0,0,'','Warchief''s Command: Searing Gorge! - only before A New Master... But Who?'),
(19,0,28581,0,0,28,0,28512,0,0,1,0,0,'','Warchief''s Command: Searing Gorge! - not while To the Aid of the Thorium Brotherhood is held'),
(19,0,28582,0,0,14,0,27963,0,0,0,0,0,'','Hero''s Call: Searing Gorge! - only before A New Master... But Who?'),
(19,0,28582,0,0,28,0,28512,0,0,1,0,0,'','Hero''s Call: Searing Gorge! - not while To the Aid of the Thorium Brotherhood is held');
UPDATE `quest_offer_reward` SET `Emote1`=1 WHERE `ID` IN (28512,28581,28582);
-- F-27963-1: Dark Iron Memo from Gravius Grimesilt always (both TDBs 100 %).
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100 WHERE `entry`=47270 AND `item`=62807;
-- F-27963-2: Gravius's aggro line (BroadcastText 50363, quoted by the Wowhead comment); enrage emote kept for the 20 % row.
DELETE FROM `creature_text` WHERE `CreatureID`=47270 AND `GroupID`=2;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(47270,2,0,'Wha... who... GET OUT OF MY DIGSITE!',14,0,100,0,0,0,0,50363,0,'Gravius Grimesilt - aggro');
UPDATE `smart_scripts` SET `action_param1`=2, `comment`='Gravius Grimesilt - On Aggro - Say 2' WHERE `entryorguid`=47270 AND `source_type`=0 AND `id`=1;
