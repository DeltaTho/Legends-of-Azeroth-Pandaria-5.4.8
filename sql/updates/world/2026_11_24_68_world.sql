-- Blasted Lands: Surwich 26175, The Sunveil Excursion 25696 and Home... Gone... Naga... 25702 no longer gate the quests they
-- lead to (ruling K1, entry open zone-wide). Sourced: "you can take Wormthorn's Dream without Surwich; once taken, Surwich is
-- no longer offered" (26175 comment 2011-04-10 [+3]); "You do not need to do The Sunveil Excursion to get this quest" (25717
-- 2012-09-24); Atrocities could be taken without Salt-Flop's quest, which then closed (25702 2011-09-25 [+3] and reply).
-- In this core a quest's NextQuestID makes the next quest require it; the entry quests also had PrevQuestID = the breadcrumb.
-- Ours: the form (each breadcrumb offered only while its quest was never taken: QUESTSTATE mask 1); the breadcrumbs have no
-- sibling breadcrumb. A breadcrumb already in the log stays hand-in-able (nothing gates its ender).
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (26175, 25696, 25702);
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` IN (26184, 25717, 25703);
DELETE FROM `creature_queststarter` WHERE `id` = 41354 AND `quest` = 25702;   -- Neptool offering his own breadcrumb: neither TDB (he stays its ender)
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` IN (26175, 25696, 25702) AND `ConditionTypeOrReference` = 47;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 26175, 0, 0, 47, 0, 26184, 1, 0, 0, 0, 0, '', 'Surwich - only while Wormthorn''s Dream was never taken'),
(19, 0, 25696, 0, 0, 47, 0, 25717, 1, 0, 0, 0, 0, '', 'The Sunveil Excursion - only while The Demons and the Druid was never taken'),
(19, 0, 25702, 0, 0, 47, 0, 25703, 1, 0, 0, 0, 0, '', 'Home... Gone... Naga... - only while Atrocities was never taken');
