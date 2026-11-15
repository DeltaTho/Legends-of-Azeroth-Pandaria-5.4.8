-- Lethlor Ravine: Scorched Guardians 2726 take no fire damage (First Sample: Wild Eggs 27765 area).
--
-- Sourced: Wowhead comments 2010-11-29 [+2] (after the revamp: "still around in 4.X ... completely immune to fire"),
--   2010-03-13 [+2], 2006-12-30 [+7], 2007-07-09 [+7]; TDB 4.4.2 CreatureImmunitiesId -2 (a column this schema lacks).
-- Ours: the means, Immunity: Fire 7942 (school immunity, fire; passive, no duration) as a template addon aura. The addon row
--   exists with auras NULL; its other columns (flying AnimTier 3, visibility) stay.

UPDATE `creature_template_addon` SET `auras` = '7942' WHERE `entry` = 2726;
