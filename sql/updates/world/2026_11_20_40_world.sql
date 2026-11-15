-- Badlands, Troggish Troubles 27789: the Blam Turret's buttons in the order the quest names them.
--
-- Sourced: the quest text and the comments (2010-11-27 [+6], 2014-02-19 [+6], 2011-03-18 [+4] and others; dossier fuselight
--   27789 claim 4): button 1 is the shot ahead (87030 Shoot, 60 yd cone, 1 s cooldown), button 2 the electrical overload
--   (87034 Power Burst, everything within 30 yd, 30 s cooldown). The template had them the other way round.

UPDATE `creature_template` SET `spell1` = 87030, `spell2` = 87034 WHERE `entry` = 46707;
