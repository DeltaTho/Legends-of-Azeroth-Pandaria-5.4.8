-- Swamp of Sorrows A (_01): Bogpaddle drop, mine respawn, Swampstrider faction (plan A-05..A-07; S1 dossier 4, 6, F-FACTION).
--
-- SOURCED: Intact Swampshore Tail 75 % (both TDBs; comments "around 40-50 %", Wowhead 54.8 %: not certain, so the less grindy
-- sourced value, the user's rule). Stray Land Mine respawn 120 s (both TDBs; a late comment says one minute). Swampstrider
-- faction 14 (both TDBs; comment 45825 2012-09-07 [+5] "As of 5.0.4 ... aggressive to both sides"; Wowhead MoP Classic).
-- Silt Crawler 922 stays faction 7 (plan K2: Wowhead MoP Classic shows it neutral, no comment calls it hostile).
-- Idempotent: absolute UPDATEs.

-- A-05: Maliciously Delicious 27587
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -75 WHERE `entry` = 45809 AND `item` = 61633;

-- A-06: Mostly Harmless 27536 (19 Stray Land Mines)
UPDATE `gameobject` SET `spawntimesecs` = 120 WHERE `id` = 205545 AND `map` = 0 AND `zoneId` = 8;

-- A-07: Tastes Like Strider 27663
UPDATE `creature_template` SET `faction` = 14 WHERE `entry` = 45825;
