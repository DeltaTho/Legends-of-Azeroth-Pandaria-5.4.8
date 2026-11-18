-- Blasted Lands, the bloodstone ritual chain (Horde 25684-25695 at Bloodmages Drazial / Lynnore, Alliance 26158-26174 at Kasim
-- Sharim): the quests come in their order, and Time is Short / Enhancing the Stone only from their own givers.
--
-- Sourced (wiki Template_Dreadmaul_Hold_quest_chain / Template_Nethergarde_Keep_quest_chain and each quest page's previous / next;
-- quest texts; Wowhead start lists; comment 25690 2012-02-17 [+6] "You must complete Attune the Bloodstone to make this quest
-- available"; comment 26158 2014-02-27 "Click the teleporter ... Then you get two quests A Bloodmage's Gotta Eat Too and The
-- First Step"; 25693's "That's all that Loramus asked of us"). Both TDBs leave these prerequisites empty (silent, not contrary).
-- - A Bloodmage's Gotta Eat Too (25690 / 26172) and The First Step (26159) after Attune the Bloodstone (25684 / 26158).
-- - The Charred Granite of the Dark Portal (25691 / 26164) and The Vile Blood of Demons (25692 / 26165) after Time is Short
--   (25689 / 26163); Enhancing the Stone (25693 / 26166) after both: in this core a quest's NextQuestID makes the next quest
--   require it, and a negative ExclusiveGroup makes every quest of the group required (Player::SatisfyQuestDependentPreviousQuests).
--   No other quest has PrevQuestID 25691 / 25692 / 26164 / 26165, so the group reaches nothing else.
-- - 26163 Time is Short keeps PrevQuestID 0: section D's amulet rows (26167-26169 NextQuestID 26163, ExclusiveGroup -26167) make
--   it need all three amulets ("With these three amulets, we have the method to summon him").
-- - Extra quest starters that neither TDB nor Wowhead has (each let a quest be taken and handed in at the same NPC):
--   Loramus 7783 for 25688 and 25693, Wazzik 41159 for 25689, Grimeo 42299 for 26163 (ruling K2: Loramus is hidden until the
--   Altar of Storms is complete, so his 25688 row would be unreachable anyway). Kept: Lynnore 7506 starts 25688, Loramus 7783
--   starts 25689, Wazzik starts 25693, Kasim 42298 starts 26163.
-- Ours: nothing.

-- Attune the Bloodstone first
INSERT IGNORE INTO `quest_template_addon` (`ID`) VALUES (25690),(26172),(26159);
UPDATE `quest_template_addon` SET `PrevQuestID` = 25684 WHERE `ID` = 25690;
UPDATE `quest_template_addon` SET `PrevQuestID` = 26158 WHERE `ID` IN (26172, 26159);

-- The two portal quests after Time is Short, Enhancing the Stone after both
INSERT IGNORE INTO `quest_template_addon` (`ID`) VALUES (25691),(25692),(26164),(26165);
UPDATE `quest_template_addon` SET `PrevQuestID` = 25689, `NextQuestID` = 25693, `ExclusiveGroup` = -25691 WHERE `ID` IN (25691, 25692);
UPDATE `quest_template_addon` SET `PrevQuestID` = 26163, `NextQuestID` = 26166, `ExclusiveGroup` = -26164 WHERE `ID` IN (26164, 26165);

-- Extra starters
DELETE FROM `creature_queststarter` WHERE (`id` = 7783 AND `quest` IN (25688, 25693)) OR (`id` = 41159 AND `quest` = 25689)
  OR (`id` = 42299 AND `quest` = 26163);
