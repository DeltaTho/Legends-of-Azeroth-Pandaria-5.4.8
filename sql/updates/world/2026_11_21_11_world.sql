-- Searing Gorge A-25 (coder B's lead): Welcome to the Brotherhood 28064 gets a giver row.
--
-- 28064 is offered only through 28062's RewardNextQuest; an abandoned 28064 could never be taken again. OURS: Overseer Oilfist
-- (14625) starts it, as he ends it. PrevQuestID 28062 (rewarded) keeps it from being offered early; the Slag Pit copy of Oilfist
-- (same entry) cannot offer it inside the window because 28062 is not rewarded until the window closes.
-- SHIP ORDER (R-15, coder B's lead): only in the same build as section E's 28062 AUTO_COMPLETE (E-10) and E-11, never before it.
DELETE FROM `creature_queststarter` WHERE `id`=14625 AND `quest`=28064;
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (14625,28064);
