-- Blasted Lands A (_10): Intact Shadowsworn Spell Focus (57134, Cultists at our Doorstep 25716) drops from every Spellblade and
-- Occultist, one or two at a time (dossier S2 F-FOCI).
--
-- Today: -87.1 % / -87.7 %, always one.
-- SOURCED: both TDBs 100 %, 1-2; comments 2010-11-28 [+4] "often 2", 2010-12-20 [+2] "every single one dropped 2",
-- 2012-07-25 [+1] "completed in 3 kills", 57134 2010-11-28 [+3]. User rule: the less grindy sourced value.

UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100, `mincountOrRef` = 1, `maxcount` = 2 WHERE `entry` IN (42296, 42297) AND `item` = 57134;
