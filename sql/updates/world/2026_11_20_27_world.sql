-- Badlands: the three storyteller vehicles of "The Day that Deathwing Came" (Theldurin the Lost 46466, Lucien Tosselwrench
-- 47080, Martek's Hog 46501) get the level-47 default of the Cataclysm data instead of level 1. The story script sets each
-- vehicle to its summoner's level when it is summoned; this is only the template default.
--
-- Sourced: TDB 4.4.2 creature_template_difficulty (level 47 for the three). 47084 (in the same TDB list) is a transform
-- display, never spawned or summoned as a vehicle, and is left as it is.

UPDATE `creature_template` SET `minlevel` = 47, `maxlevel` = 47 WHERE `entry` IN (46466, 46501, 47080);
