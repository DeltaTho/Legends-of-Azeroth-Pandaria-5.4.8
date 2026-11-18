-- Blasted Lands leftovers (dossier S5 section 4, ruling K6).
-- Kum'isha's repeatables 25771 / 25772: every rare of the zone drops one of the two items, about half and half. Sourced:
-- 10593 comments 2012-02-22 [+8], 2012-04-22 [+3]; 25772 2011-01-22 reply [+19] ("a 50/50 chance of dropping either"). As
-- Teremus 7846 has it already: one loot group, equal chance (group 1 is unused on these rares).
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = 0, `groupid` = 1
 WHERE `entry` IN (8296, 8297, 8298, 8299, 8300, 8301, 8302, 8303, 8304) AND `item` IN (8244, 10593);
-- Infallible Mind 2602: classic Bloodmage Lynnore repeatable, retired (no starter anywhere; TDB 4.4.2 has no ender row)
DELETE FROM `creature_questender` WHERE `id` = 7506 AND `quest` = 2602;
-- Darkwood Treant 45118 (Tainted Forest wildlife): faction 14 as both TDBs (mop 7)
UPDATE `creature_template` SET `faction` = 14 WHERE `entry` = 45118;
