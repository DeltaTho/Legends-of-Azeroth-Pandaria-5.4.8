-- Badlands: the two board quests and To Fuselight Proper become breadcrumbs, not prerequisites.
--
-- In this core NextQuestID makes the target require the quest (ObjectMgr DependentPreviousQuests): Hero's Call / Warchief's
-- Command: Badlands! (28579 / 28580, NextQuestID 27762) made Fuselight, Ho! 27762 unobtainable for a player who came from
-- Eastern Plaguelands without a board quest, and To Fuselight Proper 27763 (NextQuestID 27774, and 27774 PrevQuestID 27763)
-- locked Easily Swayed 27774, the start of the zone's main chain, behind 27762.
--
-- Sourced: wiki 27762 "previous = Hero's Call or Warchief's Command (both optional)"; Wowhead comments 2011-03-12 [+5],
--   2013-10-21 [+1] (27762 taken without a board quest), 2011-12-09 [+15] and its repeats on 28579 / 28580 ("you can jump
--   directly to Easily Swayed without any prereqs"); a breadcrumb closes once its target was taken: 2011-03-12 [+5],
--   2012-09-04 [+6], 2010-11-26 [+20] (27763). The TDBs' NextQuestID / PrevQuestID rows (curated, not sniffed) are overridden.
-- Ours: the mechanism (CONDITION_QUESTSTATE 47 mask 1 = QUEST_STATUS_NONE, on the quest-accept source 19): the breadcrumb is
--   hidden while its target is in the log or rewarded; an abandoned target counts as NONE again and brings the breadcrumb back.
-- Not copied: the TDBs' positive ExclusiveGroup 28579 on the board quests (a positive group is mutually exclusive here and the
--   race masks already keep the pair apart).
-- RewardNextQuest stays: a board quest handed in at Gek still offers 27762, 27762 still offers 27763, 27763 still offers 27774.
-- No zone-139 row is touched (Gek's starter / ender rows stay as they are).

UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28579, 28580, 27763);
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27774;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` IN (28579, 28580, 27763) AND `ConditionTypeOrReference` = 47;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 28579, 0, 0, 47, 0, 27762, 1, 0, 0, 0, 0, '', 'Hero''s Call: Badlands! - only while Fuselight, Ho! is neither in the log nor rewarded'),
(19, 0, 28580, 0, 0, 47, 0, 27762, 1, 0, 0, 0, 0, '', 'Warchief''s Command: Badlands! - only while Fuselight, Ho! is neither in the log nor rewarded'),
(19, 0, 27763, 0, 0, 47, 0, 27774, 1, 0, 0, 0, 0, '', 'To Fuselight Proper - only while Easily Swayed is neither in the log nor rewarded');
