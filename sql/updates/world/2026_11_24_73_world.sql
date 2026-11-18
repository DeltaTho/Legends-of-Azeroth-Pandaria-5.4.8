-- HELLFIRE PENINSULA ROWS (QuestSortID 3483), shipped by the Blasted Lands pass (ruling K7): Warchief's Command: Outland!
-- 28705 / Hero's Call: Outland! 28708 (the Outland board quests) lead to Arrival in Outland 10120 / 10288, which in mop needed
-- Through the Dark Portal 9407 / 10119 rewarded (PrevQuestID), so a player who took the board quest could never take it.
-- Sourced: PrevQuestID 0 in both TDBs; with 0 the next quest still needs one of its breadcrumbs (their NextQuestIDs,
-- Player::SatisfyQuestDependentPreviousQuests). The two breadcrumbs of a faction exclude each other (both TDBs: positive
-- ExclusiveGroup 9407 / 10119; 28705 comment 2011-03-12 [+8]), written here as conditions, the zone's form: each offered only
-- while Arrival in Outland was never taken and its sibling is neither held nor rewarded (mask 74 negated).
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 10120;   -- was 9407
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 10288;   -- was 10119
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` IN (9407, 28705, 10119, 28708) AND `ConditionTypeOrReference` = 47;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 28705, 0, 0, 47, 0, 10120,  1, 0, 0, 0, 0, '', 'Warchief''s Command: Outland! - only while Arrival in Outland was never taken'),
(19, 0, 28705, 0, 0, 47, 0,  9407, 74, 0, 1, 0, 0, '', 'Warchief''s Command: Outland! - not while Through the Dark Portal is held or rewarded'),
(19, 0,  9407, 0, 0, 47, 0, 10120,  1, 0, 0, 0, 0, '', 'Through the Dark Portal (H) - only while Arrival in Outland was never taken'),
(19, 0,  9407, 0, 0, 47, 0, 28705, 74, 0, 1, 0, 0, '', 'Through the Dark Portal (H) - not while the board quest is held or rewarded'),
(19, 0, 28708, 0, 0, 47, 0, 10288,  1, 0, 0, 0, 0, '', 'Hero''s Call: Outland! - only while Arrival in Outland was never taken'),
(19, 0, 28708, 0, 0, 47, 0, 10119, 74, 0, 1, 0, 0, '', 'Hero''s Call: Outland! - not while Through the Dark Portal is held or rewarded'),
(19, 0, 10119, 0, 0, 47, 0, 10288,  1, 0, 0, 0, 0, '', 'Through the Dark Portal (A) - only while Arrival in Outland was never taken'),
(19, 0, 10119, 0, 0, 47, 0, 28708, 74, 0, 1, 0, 0, '', 'Through the Dark Portal (A) - not while the board quest is held or rewarded');
