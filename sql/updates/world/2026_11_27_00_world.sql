-- Sarkoth (25129) is offered by Hana'zua without the Hana'zua breadcrumb (25128).
-- 25128 had NextQuestID 25129, which this core reads as "Sarkoth requires Hana'zua" (ObjectMgr DependentPreviousQuests), and 25129 had
-- PrevQuestID 25128: a player who walked to Hana'zua without talking to Canaga first was offered nothing.
-- Sourced: both TDBs make 25128 a breadcrumb (BreadcrumbForQuestId 25129) and give 25129 no prerequisite; Wowhead 25129 2013-02-02
-- "available even if you haven't done the previous quest ... available to Horde level 1"; 25128 2010-11-29 and 2011-07-30 [+8] "unlike
-- most breadcrumb quests, completing the subsequent quests still left it available" (so no closing condition is added).
-- Unchanged: RewardNextQuest 25128 -> 25129 (the hand-in still offers Sarkoth), 25130 Back to the Den still needs 25129.
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` = 25128;
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25129;
