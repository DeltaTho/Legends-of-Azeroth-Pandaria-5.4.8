-- Crawler Mucus (4888, Cleaning Up the Coastline) drops from about four in five crawlers, as both TDBs (80 %, quest-required) on the
-- four crawler entries; mop had 60 %. Wowhead comments of the period complain of the low rate. The tiny chances on other mobs stay.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -80 WHERE `item` = 4888 AND `entry` IN (3106, 3107, 3108, 3228);
