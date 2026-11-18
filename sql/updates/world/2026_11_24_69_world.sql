-- Blasted Lands, Demoniac Vessel 26186 (A) / 25719 (H): the three parts drop at both TDBs' rates (4.4.2 and 12.1.0 agree).
-- Sourced: TDB rates; comments call the brains "awful" at mop's 17 % (26186 2011-01-18, 2014-04-20) and report 0-4 or 3-5
-- legs per spider (25719 2010-11-23 [+45], 2014-08-26). User rule: not certain -> the less grindy value.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -75 WHERE `entry` = 42336 AND `item` = 57177;                                -- Tainted Hide, was -36
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100, `mincountOrRef` = 1, `maxcount` = 3 WHERE `entry` = 42337 AND `item` = 57178; -- Nightstalker Leg, was 1 per kill
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -50 WHERE `entry` = 42338 AND `item` = 57179;                                -- Screecher Brain, was -17
