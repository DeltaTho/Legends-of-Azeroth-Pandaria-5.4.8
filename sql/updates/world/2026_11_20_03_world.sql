-- Rhea's Camp: A Strange Request comes from Dolph only, and the two samples follow it.
--
-- A Strange Request 27764: Rhea 46654 was a second starter, so a player who walked up to her without Dolph's package could take
--   it from her. Sourced: both TDBs (creature_queststarter 46652 only); Wowhead "Start: Dolph". Rhea stays its ender.
-- First Sample: Wild Eggs 27765 / Second Sample: Whelps 27766: offered to anyone level 44 who reached Rhea, before the chain's
--   first quests. Sourced: wiki infoboxes (previous = A Strange Request), comments 2012-01-24 [+40], 2011-05-22. Against both
--   TDBs, which have no link (Badlands ruling R2: enforced).
-- Lifting the Veil 27770 still needs one of the two samples (NextQuestID 27770 on both, ExclusiveGroup 0); whether both were
--   required is open (questions.md Q2).

DELETE FROM `creature_queststarter` WHERE `id` = 46654 AND `quest` = 27764;

UPDATE `quest_template_addon` SET `PrevQuestID` = 27764 WHERE `ID` IN (27765, 27766);
