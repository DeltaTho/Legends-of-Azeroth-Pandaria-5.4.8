-- Conscript of the Horde (840, Takrin Pathseeker at Razor Hill) is one of three breadcrumbs to Kargal Battlescar at Far Watch, with Preserving the
-- Barrens (26642) and Warchief's Command: Northern Barrens! (28494). 840 pointed at Crossroads Conscription (842), a quest with no starter and no
-- ender, so its hand-in at Kargal offered nothing: In Defense of Far Watch (871) depends on 26642 or 28494 (their NextQuestID 871), and a player
-- who came with 840 alone was never offered it. All three could also be taken and handed in for three times the XP.
-- Sourced: TDB 4.4.2 (840, 26642, 28494 all NextQuestID 871 and ExclusiveGroup 840); Wowhead MoP Series lists the three as alternatives.
-- After this: 871 needs any one of the three rewarded (unchanged for 26642/28494, added for 840); taking one closes the other two (positive
-- ExclusiveGroup: none of the others may be in the log or rewarded). 26642 and 28494 are Barrens/Orgrimmar quests (plan ruling R7); their
-- other columns are unchanged (PrevQuestID 0, NextQuestID 871). 842 keeps PrevQuestID 840 (dead quest, nothing offers it).
UPDATE `quest_template_addon` SET `NextQuestID` = 871, `ExclusiveGroup` = 840 WHERE `ID` = 840;
UPDATE `quest_template_addon` SET `ExclusiveGroup` = 840 WHERE `ID` IN (26642, 28494);
