-- Searing Gorge, Lunthistle's Tale 27984: Zamael Lunthistle 8436 tells his whole story again.
--
-- His gossip 1285 (npc_text 1920) has one option, "I wish to hear your tale." -> 1287 (1921) "Please continue, Zamael." -> 1286
-- (1922) "Let me think about it, Zamael.". Two leftovers of the retired Prayer to Elune 3377 (no giver, no ender) broke it:
-- - condition 15/1285/0 "quest 3377 in the log": the option never showed, so the story could not be opened at all;
-- - SmartAI 8436 id 0/1: choosing that option gave 3377 credit and closed the window, so pages 1287 and 1286 never showed.
-- Both serve only 3377: delete them and the AIName. The option then shows to everyone who sees Zamael (B-3 makes him visible from
-- Dark Ministry 27979 on) and leads through the two pages, as the comment 2012-12-10 [+8] quotes them. 27984 itself has no
-- objectives and completes on accept (as both TDBs).
-- "Let me think about it, Zamael." on 1286 had ActionMenuID 0 and did nothing (the page stayed open); both TDBs send it back to the
-- greeting 1285.
-- Sourced: the pages and their order (comment 2012-12-10; gossip_menu_option ActionMenuIDs as both TDBs, 1286 -> 1285 included). Ours: none (the option
-- unconditioned is how the comment saw it in Cataclysm; both TDBs keep the 3377 condition).

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=1285 AND `SourceEntry`=0 AND `ConditionTypeOrReference`=9 AND `ConditionValue1`=3377;
DELETE FROM `smart_scripts` WHERE `entryorguid`=8436 AND `source_type`=0;
UPDATE `creature_template` SET `AIName`='' WHERE `entry`=8436;
UPDATE `gossip_menu_option` SET `ActionMenuID`=1285 WHERE `MenuID`=1286 AND `OptionID`=0;
