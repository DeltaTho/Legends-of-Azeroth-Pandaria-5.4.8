-- Swamp of Sorrows, Marshtide Watch and Stonard: the battle quests in their stages, Neeka Bloodscar from Ruag only, and the
-- faction breadcrumbs closed once the hub's first quests are taken.
--
-- Sourced: Joanna Blueheart / Ruag first offer Orcs and Humans and Lumbering Oafs; the three stage-II quests need both
-- (wiki previous; 27795 comment 2013-02-18 [+6], 27854 2012-01-05 [+13]); Assault on Stonard and Cutting Supply need the
-- three Alliance stage-II quests (wiki; 27849 2012-01-18 [+5] "MUST do the other 5"), We're Under Attack! the three Horde
-- ones (wiki); Neeka Bloodscar comes from Ruag after We're Under Attack! and is not offered once Prayerblossom or Secrets of
-- the Mire is taken (27906 comment 2011-12-09 [+3]; wiki previous); neither TDB has Neeka as its starter. To Marshtide Watch /
-- To Stonard do not appear once Joanna's / Ruag's quests are known ("This quest does not appear if you have already found
-- Marshtide Watch. I had all three quests from Joanna", 27870 comment 2014-01-18 [+1]; S2 F12).
-- Ours: the encoding. A negative ExclusiveGroup makes every member of the group needed (Player.cpp
-- SatisfyQuestDependentPreviousQuests), so PrevQuestID = the first member reads "all of the group rewarded"; neither TDB has
-- these links. The breadcrumbs close when either first quest has been taken (mask 1 = never taken, on both). A breadcrumb
-- already in the log keeps its hand-in at Joanna / Ruag (it loses its "?" there once the condition fails, ConditionMgr C16;
-- the hand-in still works from the quest list), and Neeka Bloodscar likewise at Neeka.

INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`,`ExclusiveGroup`) VALUES
(27821,0,-27821),(27822,0,-27821),
(27795,27821,-27795),(27843,27821,-27795),(27845,27821,-27795),
(27849,27795,0),(27851,27795,0),
(27852,0,-27852),(27853,0,-27852),
(27854,27852,-27854),(27855,27852,-27854),(27856,27852,-27854),
(27857,27854,0),
(27906,27857,0)
ON DUPLICATE KEY UPDATE `PrevQuestID`=VALUES(`PrevQuestID`),`ExclusiveGroup`=VALUES(`ExclusiveGroup`);

-- Neeka Bloodscar (27906): Ruag starts it, Neeka ends it
DELETE FROM `creature_queststarter` WHERE `id`=47041 AND `quest`=27906;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceEntry` IN (27906,27870,27871);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,27906,0,0,47,0,27907,74,0,1,0,0,'','Neeka Bloodscar (breadcrumb) - Prayerblossom not taken'),
(19,0,27906,0,0,47,0,27908,74,0,1,0,0,'','Neeka Bloodscar (breadcrumb) - Secrets of the Mire not taken'),
(19,0,27870,0,0,47,0,27821,1,0,0,0,0,'','To Marshtide Watch (breadcrumb) - Orcs and Humans never taken'),
(19,0,27870,0,0,47,0,27822,1,0,0,0,0,'','To Marshtide Watch (breadcrumb) - Lumbering Oafs never taken'),
(19,0,27871,0,0,47,0,27852,1,0,0,0,0,'','To Stonard (breadcrumb) - Orcs and Humans never taken'),
(19,0,27871,0,0,47,0,27853,1,0,0,0,0,'','To Stonard (breadcrumb) - Lumbering Oafs never taken');
