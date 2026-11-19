-- Lost But Not Forgotten (25193): every Dreadmaw Toothgnasher (39452) drops its 25-40 Crocolisk Teeth (60615); mop had 70 %. Sourced: both TDBs
-- 100 %, count 25-40; comments 2012-08-11 [+2], 2011-02-14 [+2] ("each crocolisk drops around 25-35", "7-8 crocolisks"). The other rows with
-- this item (Wowhead noise at 0.0004-0.03 %, river crocolisks 20.8 % x1) are left: they are not grindier.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100 WHERE `entry` = 39452 AND `item` = 60615;
