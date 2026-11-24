-- Durotar: Rezlak offers Securing the Lines (835) alongside Winds in the Desert (834).
--
-- The user, play-testing 2026-11-23, asked whether 835 should come with the supply quest. mop chained them (834 NextQuestID 835,
-- 835 PrevQuestID 834): the vanilla order, with no source after the 4.0.3 revamp.
-- Sourced: TDB 4.4.2 and 12.1.0 have no quest_template_addon row for 834 or 835 (no PrevQuestID, NextQuestID or ExclusiveGroup)
-- and no conditions 19/20 on either; the post-revamp comment on 834 "Best done in pair with quest 835" (2011-02-20 [+2]).
-- The comments calling 834 "the previous one" are all from before the revamp (2007-2008).
UPDATE `quest_template_addon` SET `NextQuestID`=0 WHERE `ID`=834 AND `NextQuestID`=835;
UPDATE `quest_template_addon` SET `PrevQuestID`=0 WHERE `ID`=835 AND `PrevQuestID`=834;
