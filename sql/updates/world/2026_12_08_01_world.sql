-- Echo Isles class line: More Than Expected opens once Proving Pit is handed in, as both TDBs have it.
-- Sourced: quest_template_addon PrevQuestID of the nine More Than Expected quests = that class's Proving Pit in TDB 4.4.2 and
-- TDB 12.1.0 (31163 = 31161 in TDB 12.1.0, the monk set is not in 4.4.2); the Arts quests' NextQuestID = 0 in both TDBs.
-- mop had PrevQuestID = the Arts quest, and the Arts quest's NextQuestID also put it in More Than Expected's dependent list
-- (ObjectMgr::LoadQuests, Player::SatisfyQuestDependentPreviousQuests), so a player whose practice spell never registered (an
-- Enhancement shaman with Stormstrike, a Beast Mastery hunter with Cobra Shot: Wowhead 24760 2012-09-23, 24778 2012-09-07)
-- never reached Vol'jin, Moraya and the rest of the Echo Isles. Both columns change together: one alone leaves the gate.
-- Unchanged: RewardNextQuest Proving Pit -> Arts -> More Than Expected (= TDB 4.4.2), so the Arts quest is still offered next.
UPDATE `quest_template_addon` SET `PrevQuestID` = 24642 WHERE `ID` = 24643;
UPDATE `quest_template_addon` SET `PrevQuestID` = 24754 WHERE `ID` = 24755;
UPDATE `quest_template_addon` SET `PrevQuestID` = 24762 WHERE `ID` = 24763;
UPDATE `quest_template_addon` SET `PrevQuestID` = 24768 WHERE `ID` = 24769;
UPDATE `quest_template_addon` SET `PrevQuestID` = 24774 WHERE `ID` = 24775;
UPDATE `quest_template_addon` SET `PrevQuestID` = 24780 WHERE `ID` = 24781;
UPDATE `quest_template_addon` SET `PrevQuestID` = 24786 WHERE `ID` = 24787;
UPDATE `quest_template_addon` SET `PrevQuestID` = 26276 WHERE `ID` = 26277;
UPDATE `quest_template_addon` SET `PrevQuestID` = 31161 WHERE `ID` = 31163;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (24640, 24752, 24760, 24766, 24772, 24778, 24784, 26274, 31162);
