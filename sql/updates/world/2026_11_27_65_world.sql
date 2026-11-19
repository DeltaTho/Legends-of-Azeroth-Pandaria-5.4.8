-- Durotar: Ignoring the Warnings (25206) follows The Wolf and The Kodo (25205), not Thunder Down Under (25236).
-- Sourced: both TDBs (4.4.2 and 12.1.0) PrevQuestID 25205; Wowhead 25206 comments 2012-01-26 [+2] and reply [+2]
-- ("Thunder Down Under is not a pre-requisite", "25205 is only pre-req").
-- Nothing else names 25206 as its NextQuestID, so its only requirement is 25205 rewarded (Player.cpp
-- SatisfyQuestPreviousQuest / SatisfyQuestDependentPreviousQuests).

UPDATE `quest_template_addon` SET `PrevQuestID` = 25205 WHERE `ID` = 25206;
