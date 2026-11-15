-- Badlands: Rhea is seen only where her quests send you. At her camp in Lethlor Ravine from A Strange Request until she
-- reveals herself (Rhea Revealed credited); at Dragon's Mouth (Alliance) / New Kargath (Horde) from the egg delivery until you
-- take The Hidden Clutch; on the Hidden Clutch hill from then until you take Rheastrasza's Gift (again after an abandoned Gift).
-- Before this every Rhea quest of both factions was given and ended at the camp, 1,300 yd from where the texts send you, and
-- she stood there for everyone from the first visit.
--
-- Sourced: Generic Quest Invisibility 10 (80852, type 18, amount 100) on Rhea 46654 as the template aura in both TDBs; the
--   per-area detections are the 5.4.8 DBC's own "See Quest Invis 10" spells (type 18, amount 1000), each castable only where
--   its AreaGroup says: 87006 Lethlor Ravine 339 + Rhea's Camp 5519, 87468 Dragon's Mouth 5564, 87690 New Kargath 5565, 87424
--   The Hidden Clutch 5592. The places: Wowhead pins of 46654, the quest POIs of 27826 / 27889 / 27832 / 27897, comment on
--   27826 "21.2, 57.7"; the camp copy appears with A Strange Request ("Ahh... you've found me", comment 2011-05-22) and the
--   Clutch copy is gone after the Gift (comment 2011-05-08).
-- Ours: the exact quest bounds (status masks below); the three spawn points (near the pins, heights from the server map
--   files, facing ours: to be checked with .gps); showing the Clutch copy again after an abandoned Gift; the 339 rows (she is
--   seen from the ravine around the camp, 25 yd from her, as the AreaGroup of 87006 allows); the "sample still in the log"
--   rows, so a First / Second Sample taken but not finished before Rhea Revealed can still be handed in at the camp after The
--   Venerable Doctor Blam, until the egg delivery is taken (then she stands at Dragon's Mouth / New Kargath and is never shown
--   in two places). Rhea's quest rows are on the entry, so every visible copy also ends a held sample and offers one not yet
--   taken: the Dragon's Mouth / New Kargath and Clutch copies do so later in the chain; only after the Gift is taken (no copy
--   visible) does a held sample have no ender. These rows are camp-only (no 339 row): from the ravine she would show as Rhea
--   while Rheastrasza stands in the camp.
--
-- The rows (status bits: 1 none, 2 complete, 8 incomplete, 64 rewarded):
--   camp       87006 in 5519 and 339: 27764 taken/complete/rewarded (74) and 27769 none/incomplete (9);
--              in 5519 also while 27765 or 27766 is in the log (10) and 27826 (Alliance) / 27889 (Horde) not taken (1)
--   Dragon's Mouth 87468 in 5564: 27826 (74) and 27832 none (1)
--   New Kargath    87690 in 5565: 27889 (74) and 27897 none (1)
--   Clutch     87424 in 5592: 27832 complete/rewarded (66) and 27858 none (1); 27897 (66) and 27898 none (1)
-- Rheastrasza 46655 keeps her phasemask-2 window (spell_area 59073, area 5519, unchanged). Every copy is the same entry and runs
-- the same AI and quest rows (Rhea's quest rows and AI belong to other commits). Ships whole: the camp window alone would hide
-- every later ender. Cave Blam is a separate commit.

UPDATE `creature_template_addon` SET `auras` = '80852' WHERE `entry` = 46654;

DELETE FROM `creature` WHERE `guid` BETWEEN 3130200 AND 3130202;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`)
SELECT 3130200,`id`,`map`,3,5564,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,-7034.0,-2553.0,252.26,0.0,`spawntimesecs`,`spawntimesecs_max`,0,0,`curhealth`,`curmana`,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid` = 161536
UNION ALL
SELECT 3130201,`id`,`map`,3,5565,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,-6719.0,-2452.5,272.86,0.0,`spawntimesecs`,`spawntimesecs_max`,0,0,`curhealth`,`curmana`,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid` = 161536
UNION ALL
SELECT 3130202,`id`,`map`,3,5592,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,-6540.0,-2393.4,291.81,5.36,`spawntimesecs`,`spawntimesecs_max`,0,0,`curhealth`,`curmana`,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid` = 161536;

DELETE FROM `spell_area` WHERE `spell` IN (87006, 87468, 87690, 87424);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(87006, 5519, 27764, 27769, 0, 0, 2, 1, 74, 9),  -- camp: A Strange Request taken .. Rhea Revealed credited
(87006,  339, 27764, 27769, 0, 0, 2, 1, 74, 9),  -- the same, seen from Lethlor Ravine around the camp
(87006, 5519, 27765, 27826, 0, 18875469, 2, 1, 10, 1),  -- First Sample still in the log, until Into the Dragon's Mouth is taken
(87006, 5519, 27765, 27889, 0, 33555378, 2, 1, 10, 1),  -- ... until New Kargath is taken
(87006, 5519, 27766, 27826, 0, 18875469, 2, 1, 10, 1),  -- Second Sample still in the log
(87006, 5519, 27766, 27889, 0, 33555378, 2, 1, 10, 1),
(87468, 5564, 27826, 27832, 0, 0, 2, 1, 74, 1),  -- Dragon's Mouth: Into the Dragon's Mouth taken .. The Hidden Clutch taken
(87690, 5565, 27889, 27897, 0, 0, 2, 1, 74, 1),  -- New Kargath: New Kargath taken .. The Hidden Clutch taken
(87424, 5592, 27832, 27858, 0, 0, 2, 1, 66, 1),  -- Hidden Clutch (Alliance): The Hidden Clutch taken .. the Gift taken
(87424, 5592, 27897, 27898, 0, 0, 2, 1, 66, 1);  -- Hidden Clutch (Horde)
