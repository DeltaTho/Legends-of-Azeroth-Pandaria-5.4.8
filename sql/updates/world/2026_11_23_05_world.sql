-- Swamp of Sorrows A (_05): Harborage and Splinterspear drops, respawns, Mireglob faction (plan A-23..A-27; S4 dossier S4-D,
-- gate decision D6, plan K3, K19).
--
-- SOURCED: Invigorated Silt, Purespring Mote, Smoky Crystal and Duskfang's Hide drop every time (both TDBs 100; comment 27876
-- 2011-02-23 "they all appear to have 100 % drop rates"; mop 19.8 / 82.0 / 66.0 / 74.7 %). Duskfang respawns fast (comments
-- 27910 2010-11-24 [+23], 2010-11-25 [+4]; both TDBs 120 s). Prayerbloom respawns "much quicker than the spiders" (27875
-- 2013-07-13 [+3]; both TDBs 120 s). Shifting Mireglob faction 14 (both TDBs; comments 27876 2012-08-29 [+10] and reply "as of
-- 5.0.4 they are now aggressive"; Wowhead MoP Classic hostile).
-- OURS: Misty Grell respawn 60 s (comments "extremely fast, sometimes instantly", no sourced number; 60 s is what this zone's
-- other fast quest mobs use; mop and the TDBs 300 s).
-- Idempotent: absolute UPDATEs.

-- A-23: drops to 100 %
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100 WHERE (`entry` = 46997 AND `item` = 62593) OR (`entry` = 46953 AND `item` = 62609)
  OR (`entry` = 46950 AND `item` = 62749) OR (`entry` = 47053 AND `item` = 62714);

-- A-24: Duskfang (one spawn)
UPDATE `creature` SET `spawntimesecs` = 120 WHERE `id` = 47053;

-- A-25: Prayerbloom
UPDATE `gameobject` SET `spawntimesecs` = 120 WHERE `id` = 206503;

-- A-26: Misty Grell
UPDATE `creature` SET `spawntimesecs` = 60 WHERE `id` = 46950;

-- A-27: Shifting Mireglob aggressive (mop 7)
UPDATE `creature_template` SET `faction` = 14 WHERE `entry` = 46997;
