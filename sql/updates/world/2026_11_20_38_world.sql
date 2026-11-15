-- Badlands: Zormus, the 5.1 rare in the crypt behind Dustwind Dig (plan item C-17).
--
-- What the player sees: a level 47 rare (hostile, 4 hours to respawn) standing in the crypt on the hill at Dustwind Dig, who drops a
-- green item.
-- Sourced: comments "one of the newly added rares to Badlands" (2012-12-24 [+17]), "a crypt on a hill at Dustwind Dig" (2012-12-01
--   [+14]), "the entrance to the crypt is exactly at 51.5, 35.0", respawn "exactly 4 hours" (2013-01-29 [+2]); Wowhead MoP: level 47,
--   rare, hostile to both sides, health 5,970, drops Seeping Gizzard 61/72 (85 %), Shed Lizard Skin 11/72 (15 %) and one green per
--   kill (Gossamer Tunic / Pants, Champion's Greaves, Warmonger's Belt, Duskwoven Cape, Gothic Plate Leggings, Overlord's Vambraces:
--   72 of 72). TDB 4.4.2 and 12.1.0: template level 47, faction 14, unit_flags 64, rank 4; neither has a spawn (an underground spot
--   no sniff caught). mop had a stub template (level 1, faction 35, no loot) and no spawn.
-- Ours: the spawn point (from the Wowhead pins through WorldMapArea 17: -6553.8..-6562.0 / -3449.8..-3492.8, on the crypt floor of
--   Md_CryptSimpleEnt.wmo, 4.5 yd from the crypt's Campfire 144180; ground z 292.68 re-measured with ground.py: the floor, not a
--   wall), facing the campfire; Health_mod 3 (5,970 = basehp0 1990 at level 47 x 3); the 85 / 15 / one-green loot split (the two greys are one group: exactly one per kill, as 61/72 + 11/72 = 72/72). No pool
--   (one spot), idle. Not built: a sitting pose; the template's damage and speed fields stay as the stub had them. A spawn point of
--   ours: to be checked in game with a .gps.
-- The seven other 5.1 rares the comments list (Kalixx 50726, Deathstrike 50728, Needlefang 50731, Tabbs 50838, Blackshell 51000,
--   Serkett 51007, Vorticus 51021) are stubs too and not built here (lead for a later pass).

UPDATE `creature_template` SET `minlevel`=47, `maxlevel`=47, `faction`=14, `unit_flags`=64, `Health_mod`=3, `lootid`=51018 WHERE `entry`=51018;
DELETE FROM `creature_loot_template` WHERE `entry`=51018;
INSERT INTO `creature_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES
(51018,5133,85,'REGULAR',2,1,1),
(51018,5128,15,'REGULAR',2,1,1),
(51018,7517,0,'REGULAR',1,1,1),
(51018,7519,0,'REGULAR',1,1,1),
(51018,7542,0,'REGULAR',1,1,1),
(51018,9961,0,'REGULAR',1,1,1),
(51018,10060,0,'REGULAR',1,1,1),
(51018,10091,0,'REGULAR',1,1,1),
(51018,10202,0,'REGULAR',1,1,1);
DELETE FROM `creature` WHERE `guid`=3131000;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3131000,51018,0,3,5525,1,1,0,0,0,0,-6557.9,-3492.8,292.8,0.71,14400,0,0,0,5970,0,0,0,0,0,0,0,'',0,0);
