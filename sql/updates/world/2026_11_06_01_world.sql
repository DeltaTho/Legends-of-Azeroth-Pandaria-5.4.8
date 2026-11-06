-- Restores creature abilities from our zone audit (Cataclysm, AzerothCore, Wowhead and sniffed spell lists) that playerbot-beta's
-- ports (its 987 and 988 abilities files) left out. 442 creatures: 127 had no SmartAI on beta and get our rows, 312 get our rows in
-- place of the fork-point rows we had replaced, and 3 keep beta's rows with ours added after them. A cast is left out where beta
-- casts the same spell or one of the same name. Left out on purpose: critters (14881, 48873, 63871, 64802), which would lose CritterAI;
-- Scarlet Ballista 29104, which keeps TurretAI; Mining Powder 48284 and Helix's nightmare 49674, which instance_deadmines.cpp drives;
-- Nexus-Prince Razaan 21057, whose script on beta is right. Scavenge-bot 004-A8 25752 keeps beta's phase row for its kill credit (11896).
-- A cast stays if the Cataclysm scripts, Wowhead's MoP Classic list (not on tameable creatures, whose lists hold pet spells), a sniffed TDB spell row
-- or creature_template spell1-8 (only where the WotLK data has no trace of it) supports it, and on content not reworked since WotLK also AzerothCore's
-- and TDB's scripts and lists; TDB's creature_template_spell rows of build 41031 are inherited WotLK lists, so they count only there. Timings aren't checked. Talk rows follow the fork's talk-target rule (2026_10_29_988_abilities_999_talk_target_rerun.sql);
-- VICTIM_CASTING rows use its corrected layout, and cast flag 0x100, which this core lacks, is gone.
-- Generated from a replay of both branches' SQL; each creature's final rows are written whole, so this file is idempotent.

-- Cutpurse (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=94 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=94;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(94,0,0,0,67,0,100,0,3900,6900,0,0,0,11,37685,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cutpurse - On Behind Target - Cast ''Backstab'''),
(94,0,1,0,4,0,35,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cutpurse - On Aggro - Say Line 0 (No Repeat)');

-- Harvest Watcher (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=114 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=114;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(114,0,0,0,0,0,100,0,5000,8000,15000,20000,0,11,7342,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Harvest Watcher - In Combat - Cast ''Wide Slash''');

-- Riverpaw Gnoll (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=117 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=117;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(117,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'When health between 0%-15%% (check once) - Self: Flee for assist'),
(117,0,1,0,0,0,100,0,3500,7200,25000,35000,0,11,80475,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Every 25 - 35 seconds (3.5 - 7.2s initially) - Self: Cast spell Riverpaw Brand (80475) on Victim'),
(117,0,2,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On aggro - Self: Talk 0 to invoker');

-- Riverpaw Mongrel (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=123 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=123;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(123,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Riverpaw Mongrel - Between 0-15% Health - Flee For Assist (No Repeat)'),
(123,0,1,0,0,0,100,0,3500,7200,14500,16500,0,11,80475,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Riverpaw Mongrel - In Combat - Cast ''Riverpaw Brand'''),
(123,0,2,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Riverpaw Mongrel - On Aggro - Say Line 0 (No Repeat)');

-- Riverpaw Brute (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=124 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=124;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(124,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Riverpaw Brute - Between 0-15% Health - Flee For Assist (No Repeat)'),
(124,0,1,0,0,0,100,0,4500,6200,18500,22000,0,11,77558,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Riverpaw Brute - In Combat - Cast ''Bloody Strike'''),
(124,0,2,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Riverpaw Brute - On Aggro - Say Line 0 (No Repeat)');

-- Murloc Tidehunter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=127 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=127;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(127,0,0,0,0,0,100,0,0,0,3400,4700,0,11,32011,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murloc Tidehunter - In Combat - Cast ''Water Bolt'''),
(127,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Murloc Tidehunter - Between 0-15% Health - Flee For Assist (No Repeat)'),
(127,0,2,0,9,0,100,0,0,15,13600,14500,0,11,78542,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murloc Tidehunter - Within 0-15 Range - Cast ''Splash''');

-- Grave Robber (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=218 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=218;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(218,0,0,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Grave Robber - Between 0-15% Health - Flee For Assist (No Repeat)'),
(218,0,1,0,0,0,100,0,2000,3000,9000,12000,0,11,6595,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Grave Robber - In Combat - Cast ''Exploit Weakness''');

-- Zzarc' Vul (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=300 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=300;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(300,0,0,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Zzarc'' Vul - On Aggro - Say Line 0 (No Repeat)'),
(300,0,1,0,0,0,100,0,6000,9000,17000,24000,0,11,78828,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Zzarc'' Vul - In Combat - Cast ''Bladestorm'''),
(300,0,2,0,0,0,100,0,2000,4000,12000,18000,0,11,80182,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Zzarc'' Vul - In Combat - Cast ''Uppercut'''),
(300,0,3,0,9,0,100,0,0,5,22000,22000,0,11,8716,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Zzarc'' Vul - Within 0-5 Range - Cast ''Low Swipe'''),
(300,0,4,0,0,0,100,0,12000,15000,8000,25000,0,11,5164,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Zzarc'' Vul - In Combat - Cast ''Knockdown''');

-- Stalvan Mistmantle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=315 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=315;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(315,0,0,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stalvan Mistmantle - On Aggro - Say Line 0'),
(315,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Stalvan Mistmantle - Between 0-15% Health - Flee For Assist'),
(315,0,2,0,0,0,100,0,4000,7000,16000,18000,0,11,85234,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Stalvan Mistmantle - In Combat - Cast ''Fetid Breath'''),
(315,0,3,0,0,0,100,0,2000,3000,65000,68000,0,11,3105,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Stalvan Mistmantle - In Combat - Cast ''Curse of Stalvan''');

-- Gath'Ilzogg (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=334 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=334;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(334,0,0,0,0,0,100,0,5000,5000,12000,13000,0,11,79901,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Blood Plague'),
(334,0,1,0,0,0,100,0,4000,4000,10000,15000,0,11,79903,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Death Coil'),
(334,0,2,0,0,0,100,0,10000,12000,10000,22000,0,11,79902,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Plague Strike'),
(334,0,3,0,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gath''Ilzogg - On Aggro - Say Line 0');

-- Redridge Mystic (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=430 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=430;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(430,0,0,0,4,0,10,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redridge Mystic - On Aggro - Say Line 0'),
(430,0,1,0,0,0,100,0,0,0,3400,4700,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Lightning Bolt'),
(430,0,2,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP');

-- Shadowhide Slayer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=431 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=431;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(431,0,0,0,12,0,100,1,0,20,0,0,0,11,7160,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Shadowhide Slayer - Target Between 0-20% Health - Cast ''Execute'''),
(431,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Shadowhide Slayer - Between 0-15% Health - Flee For Assist'),
(431,0,2,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Enrage at 30% HP'),
(431,0,3,0,0,0,100,0,5000,5000,6000,6000,0,11,77720,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Execute');

-- Riverpaw Bandit (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=452 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=452;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(452,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Riverpaw Bandit - Between 0-15% Health - Flee For Assist (No Repeat)'),
(452,0,1,0,2,0,100,0,0,40,25000,28000,0,11,80576,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Riverpaw Bandit - Between 0-40% Health - Cast ''Shadowstep'''),
(452,0,2,0,0,0,100,0,7500,12400,21000,22000,0,11,30478,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Riverpaw Bandit - In Combat - Cast ''Hemorrhage'''),
(452,0,3,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Riverpaw Bandit - On Aggro - Say Line 0 (No Repeat)');

-- Murloc Minor Oracle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=456 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=456;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(456,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murloc Minor Oracle - Between 0-15% Health - Flee For Assist (No Repeat)'),
(456,0,1,0,0,0,100,0,5500,7500,25000,35000,0,11,79831,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Every 25 - 35 seconds (5.5 - 7.5s initially) - Self: Cast spell Wave Crash (79831) on Victim'),
(456,0,2,0,1,0,100,0,500,1000,500000,600000,0,11,79892,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Every 500 - 600 seconds (0.5 - 1s initially) - Self: Cast spell Water Shield (79892) on Self'),
(456,0,3,0,16,0,100,0,79892,1,15000,30000,0,11,79892,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'When friendly unit in range 1 yards has not got aura Water Shield (79892) (check every 15000 - 30000 ms) - Self: Cast spell Water Shield (79892) on Self');

-- Vultros (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=462 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=462;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(462,0,0,0,0,0,100,0,4500,9500,17500,22300,0,11,13443,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Vultros - In Combat - Cast ''Rend''');

-- Riverpaw Scout (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=500 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=500;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(500,0,0,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Every 2.3 - 3.9 seconds (0 - 0s initially) - Self: Cast spell Shoot (6660) on Victim (flags: combat move)'),
(500,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'When health between 0%-15%% (check once) - Self: Flee for assist'),
(500,0,2,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On aggro - Self: Talk 0 to invoker'),
(500,0,3,0,0,0,100,0,5000,7000,25000,30000,0,11,78509,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Every 25 - 30 seconds (5 - 7s initially) - Self: Cast spell Torch Toss (78509) on Victim');

-- Riverpaw Herbalist (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=501 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=501;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(501,0,0,0,0,0,100,1,0,0,0,0,0,87,50101,50102,50103,0,0,0,1,0,0,0,0,0,0,0,0,'Riverpaw Herbalist - In Combat - Cast ''Potion Strength II'' (No Repeat)'),
(501,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Riverpaw Herbalist - Between 0-15% Health - Flee For Assist (No Repeat)'),
(501,0,2,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Riverpaw Herbalist - On Aggro - Say Line 0 (No Repeat)');

-- Murloc Netter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=513 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=513;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(513,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Murloc Netter - Between 0-15% Health - Flee For Assist (No Repeat)'),
(513,0,1,0,9,0,100,0,0,20,14000,17000,0,11,6533,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murloc Netter - Within 0-20 Range - Cast ''Net'''),
(513,0,2,0,0,0,100,0,4500,7500,14500,17500,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murloc Netter - In Combat - Cast ''Sunder Armor''');

-- Murloc Raider (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=515 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=515;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(515,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Murloc Raider - Between 0-15% Health - Flee For Assist (No Repeat)'),
(515,0,1,0,0,0,100,0,2000,5000,50000,60000,0,11,6533,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Every 50 - 60 seconds (2 - 5s initially) - Self: Cast spell Net (6533) on Victim'),
(515,0,2,0,0,0,100,0,4000,6000,27500,33500,0,11,80522,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Every 27.5 - 33.5 seconds (4 - 6s initially) - Self: Cast spell Demoralizing Mmmrrrggglll (80522) on Self');

-- Murloc Oracle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=517 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=517;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(517,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9734,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murloc Oracle - In Combat - Cast ''Holy Smite'''),
(517,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Murloc Oracle - Between 0-15% Health - Flee For Assist (No Repeat)'),
(517,0,2,0,2,0,100,1,0,30,0,0,0,11,11835,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murloc Oracle - Between 0-30% Health - Cast ''Power Word: Shield'' (Phase 1) (No Repeat)');

-- Lupos (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=521 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=521;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(521,0,0,0,4,0,100,1,0,0,0,0,0,11,75002,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Lupos - On Aggro - Cast ''Leaping Rush'' (No Repeat)'),
(521,0,1,0,0,0,100,0,3000,6000,22000,26000,0,11,3150,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lupos - In Combat - Cast ''Rabies''');

-- Nightbane Shadow Weaver (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=533 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=533;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(533,0,0,0,25,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On reset (e.g. after reaching home) - Self: Set event phase to 1 // '),
(533,0,1,2,1,1,100,0,1000,10000,21000,24000,0,5,479,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'When out of combat and timer at the begining between 1000 and 10000 ms (and later repeats every 21000 and 24000 ms) - Self: Play emote ONESHOT_SNIFF (479) // '),
(533,0,2,0,61,0,100,0,0,0,0,0,0,67,0,4000,4000,0,0,0,1,0,0,0,0,0,0,0,0,' Linked - Trigger timed event #0 in 4000 - 4000 ms // '),
(533,0,3,0,59,1,100,0,0,0,0,0,0,11,85072,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On timed event 0 triggered - Self: Cast spell Woven Shadows (85072) on Self // '),
(533,0,4,0,0,0,100,0,6000,6000,11000,11000,0,11,77721,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 6000 and 6000 ms (and later repeats every 11000 and 11000 ms) - Self: Cast spell Shadow Weave (77721) on Victim // '),
(533,0,5,0,4,0,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On aggro - Self: Increment phase by 1 and decrement by 0 // ');

-- Murloc Minor Tidecaller (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=548 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=548;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(548,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Frostbolt'),
(548,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP');

-- Redridge Drudger (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=580 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=580;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(580,0,0,0,4,0,10,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Redridge Drudger - On Aggro - Say Line 0 (No Repeat)'),
(580,0,1,0,0,0,100,0,0,0,3500,4100,0,11,80512,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Fling Filth'),
(580,0,2,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP');

-- Grik'nir the Cold (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=808 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=808;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(808,0,0,0,0,0,100,0,2000,4500,12000,15000,0,11,79895,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Grik''nir the Cold - In Combat - Cast ''Frost Strike'''),
(808,0,1,2,4,0,100,1,0,0,0,0,0,11,6957,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Grik''nir the Cold - On Aggro - Cast ''Frostmane Strength'' (No Repeat)'),
(808,0,2,0,61,0,100,0,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Grik''nir the Cold - On Aggro - Say 0 (No Repeat)');

-- Coyote Packleader (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=833 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=833;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(833,0,0,1,1,0,10,0,30000,600000,120000,600000,0,4,1018,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coyote Packleader - Out of Combat - Play Sound 1018'),
(833,0,1,0,61,0,100,0,30000,600000,120000,600000,0,5,393,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coyote Packleader - Out of Combat - Play Emote 393'),
(833,0,2,0,0,0,100,0,7000,12000,24000,32000,0,11,80362,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coyote Packleader - In Combat - Cast ''Crushing Bite''');

-- Kurzen Medicine Man (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=940 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=940;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(940,0,0,0,74,0,100,0,0,30,100,19900,0,11,3359,0,0,0,0,0,9,0,0,0,0,0,0,0,0,'Kurzen Medicine Man - On Friendly Between 0-30% Health - Cast ''Renew'''),
(940,0,1,0,2,0,100,1,0,30,0,0,0,11,588,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kurzen Medicine Man - Between 0-30% Health - Cast ''Inner Fire'''),
(940,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Kurzen Medicine Man - Between 0-15% Health - Flee For Assist');

-- Ana'thek the Cruel (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1059 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1059;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1059,0,0,0,4,0,100,0,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Ana''thek the Cruel - On Aggro - Store Target List'),
(1059,0,1,2,6,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ana''thek the Cruel - On Death - Say Line 0'),
(1059,0,2,3,61,0,100,0,0,0,0,0,0,45,0,1,0,0,0,0,19,2530,30,0,0,0,0,0,0,'Ana''thek the Cruel - Linked To Id 1 - Set Data 0 1'),
(1059,0,3,0,61,0,100,0,0,0,0,0,0,100,1,0,0,0,0,0,19,2530,30,0,0,0,0,0,0,'Ana''thek the Cruel - Linked To Id 2 - Send Target To Target'),
(1059,0,4,0,0,0,100,0,3000,6000,18000,20000,0,11,9791,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ana''thek the Cruel - In Combat - Cast ''Head Crack''');

-- Nezzliok the Dire (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1062 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1062;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1062,0,0,0,0,0,100,0,2000,4000,5000,6000,0,11,421,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nezzliok the Dire - In Combat CMC - Cast ''Chain Lightning'''),
(1062,0,1,0,0,0,100,0,6000,7000,6000,7000,0,11,2610,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nezzliok the Dire - In Combat - Cast ''Shock''');

-- Hammerspine (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1119 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1119;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1119,0,0,0,4,0,70,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hammerspine - On Aggro - Say Line 0 (No Repeat)'),
(1119,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hammerspine - Between 0-15% Health - Flee For Assist (No Repeat)'),
(1119,0,2,3,2,0,100,1,0,30,0,0,0,11,18501,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hammerspine - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(1119,0,3,0,61,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hammerspine - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Great Father Arctikus (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1260 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1260;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1260,0,1,0,4,0,80,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Great Father Arctikus - On Aggro - Say Line 0'),
(1260,0,2,0,2,0,100,1,0,75,0,0,0,11,139,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Great Father Arctikus - Between 0-75% Health - Cast ''Renew'''),
(1260,0,3,4,2,0,100,1,0,30,0,0,0,11,18501,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Great Father Arctikus - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(1260,0,4,0,61,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Great Father Arctikus - Between 0-30% Health - Say Line 0 (No Repeat)'),
(1260,0,5,0,4,0,100,1,0,0,0,0,0,11,77808,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Great Father Arctikus - On Aggro - Cast ''Battle Shout'' (No Repeat)');

-- Mountaineer Veek (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1282 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1282;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1282,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mountaineer Veek - In Combat - Cast ''Shoot''');

-- Boss Galgosh (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1398 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1398;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1398,0,0,0,4,0,100,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Boss Galgosh - On Aggro - Say Line 0 (No Repeat)'),
(1398,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Boss Galgosh - Between 0-15% Health - Flee For Assist'),
(1398,0,2,3,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Boss Galgosh - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(1398,0,3,0,61,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Boss Galgosh - Between 0-30% Health - Say Line 0 (No Repeat)'),
(1398,0,4,0,0,0,100,0,5800,9500,10500,12500,0,11,82625,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Boss Galgosh - In Combat - Cast ''Bone Toss'''),
(1398,0,5,0,4,0,100,1,0,0,0,0,0,11,80983,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Boss Galgosh - On Aggro - Cast ''Commanding Shout'' (No Repeat)');

-- Scarlet Neophyte (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1539 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1539;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1539,0,0,0,1,0,100,0,1000,1000,1800000,1800000,0,11,12544,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Scarlet Neophyte - Out of Combat - Cast ''Frost Armor'''),
(1539,0,1,0,0,0,100,0,0,0,2400,3800,0,11,13322,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Scarlet Neophyte - In Combat CMC - Cast ''Frostbolt'''),
(1539,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Scarlet Neophyte - Between 0-15% Health - Flee For Assist (No Repeat)'),
(1539,0,3,0,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Scarlet Neophyte - On Aggro - Say Line 0');

-- Thrashtail Basilisk (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1550 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1550;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1550,0,0,0,0,0,100,0,5000,8000,15000,19000,0,11,5106,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Crystal Flash'),
(1550,0,1,0,0,0,75,0,5000,5000,18000,18000,0,11,6607,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Thrashtail Basilisk - In Combat - Cast ''Lash'' (No Repeat)');

-- Bloodsail Elder Magus (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1653 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1653;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1653,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodsail Elder Magus - Between 0-15% Health - Flee For Assist (No Repeat)'),
(1653,0,1,0,0,0,100,0,0,0,3400,4700,0,11,9053,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Fireball'),
(1653,0,2,0,0,0,100,0,8000,8000,18000,22000,0,11,11829,2,0,0,0,0,4,0,0,0,0,0,0,0,0,'Cast Flamestrike');

-- Devlin Agamand (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1657 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1657;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1657,0,0,0,9,0,100,0,0,5,35000,40000,0,11,3148,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Devlin Agamand - Within 0-5 Range - Cast ''Head Crack'''),
(1657,0,1,0,0,0,100,0,4000,4000,4000,4000,0,11,34447,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Devlin Agamand - In Combat - Cast ''Arcane Missiles'''),
(1657,0,2,0,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Devlin Agamand - On Aggro - Say Line 0'),
(1657,0,3,0,1,0,100,0,1000,10000,15000,25000,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Devlin Agamand - Out of Combat - Say Line 1');

-- Deathguard Randolph (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1736 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1736;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1736,0,0,0,0,0,100,0,1000,2000,2000,3000,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Deathguard Randolph - In Combat - Cast ''Shoot'''),
(1736,0,1,0,25,0,100,0,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Deathguard Randolph - On Reset - Set Reactstate Aggressive');

-- Vile Fin Tidehunter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1768 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1768;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1768,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Vile Fin Tidehunter - Between 0-15% Health - Flee For Assist (No Repeat)'),
(1768,0,1,0,9,0,100,0,0,10,16000,19000,0,11,78542,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Vile Fin Tidehunter - Within 0-10 Range - Cast ''Splash''');

-- Hungering Wraith (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1802 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1802;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1802,0,0,0,2,0,100,1,0,30,0,0,0,11,8269,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Frenzy at 30% HP'),
(1802,0,1,0,11,0,100,1,0,0,0,0,0,11,85788,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Soul Corruptor on Spawn');

-- Scarlet Executioner (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1841 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1841;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1841,0,0,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Enrage at 30% HP'),
(1841,0,1,0,0,0,100,0,5000,8000,12000,16000,0,11,15284,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Cleave'),
(1841,0,2,0,0,0,100,0,4000,9000,10000,19000,0,11,16856,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Mortal Strike');

-- Araj the Summoner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1852 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1852;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1852,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Frostbolt'),
(1852,0,1,0,9,0,100,0,0,8,15000,25000,0,11,75062,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Frost Nova on Close'),
(1852,0,2,0,0,0,100,0,18000,23000,50000,65000,0,11,83701,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Summon Berserkers'),
(1852,0,3,0,6,0,100,1,0,0,0,0,0,11,18661,3,0,0,0,0,0,1,0,0,0,0,0,0,0,'Cast Araj''s Phylactery on Death');

-- Ambermill Watcher (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1888 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1888;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1888,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Ambermill Watcher - Between 0-15% Health - Flee For Assist (No Repeat)'),
(1888,0,1,0,0,0,100,0,4000,5000,15000,17000,0,11,17140,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ambermill Watcher - In Combat - Cast ''Holy Fire'''),
(1888,0,2,0,2,0,100,0,0,40,15000,21000,0,11,11640,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ambermill Watcher - Between 0-40% Health - Cast ''Renew'''),
(1888,0,3,0,1,0,100,0,500,1000,1800000,1800000,0,11,48168,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ambermill Watcher - Out of Combat - Cast ''Inner Fire''');

-- Ambermill Witchalok (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1889 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1889;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1889,0,0,0,0,0,100,0,0,0,2300,3900,0,11,87222,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ambermill Witchalok - In Combat - Cast ''Throw Witchalok Blade'''),
(1889,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Ambermill Witchalok - Between 0-15% Health - Flee For Assist (No Repeat)'),
(1889,0,2,0,0,0,50,1,8000,8000,0,0,0,11,87225,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ambermill Witchalok - In Combat - Cast ''Summon Doomskull'' (No Repeat)'),
(1889,0,3,0,0,0,50,1,8000,8000,0,0,0,11,87224,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ambermill Witchalok - In Combat - Cast ''Summon Wolfoids'' (No Repeat)');

-- Vile Fin Oracle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1908 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1908;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1908,0,0,0,9,0,100,0,2,20,1,1,0,19,15,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Vile Fin Oracle - Within 2-20 Range - Remove Flags Server Controlled & Not Attackable & Disable Movement & Pvp Attackable (No Repeat)'),
(1908,0,1,0,9,0,100,0,0,2,1,1,0,19,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Vile Fin Oracle - Within 0-2 Range - Remove Flag  (No Repeat)'),
(1908,0,2,0,11,0,100,1,0,0,0,0,0,19,15,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Vile Fin Oracle - On Respawn - Remove Flags Server Controlled & Not Attackable & Disable Movement & Pvp Attackable (No Repeat)'),
(1908,0,3,0,0,0,100,0,0,0,3400,4700,0,11,9734,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Vile Fin Oracle - In Combat - Cast ''Holy Smite'''),
(1908,0,4,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Vile Fin Oracle - Between 0-15% Health - Flee For Assist (No Repeat)');

-- Ambermill Warder (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1913 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1913;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1913,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Ambermill Warder - Between 0-15% Health - Flee For Assist (No Repeat)'),
(1913,0,1,0,0,0,100,0,6000,6000,18000,22000,0,11,3248,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ambermill Warder - In Combat - Cast ''Improved Blocking'''),
(1913,0,2,0,0,0,100,0,12000,15000,30000,32000,0,11,86817,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ambermill Warder - In Combat - Cast ''Spell Ward''');

-- Ambermill Magister (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1914 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1914;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1914,0,0,0,0,0,100,0,0,0,2000,3200,0,11,13878,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ambermill Magister - In Combat - Cast ''Scorch'''),
(1914,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Ambermill Magister - Between 0-15% Health - Flee For Assist (No Repeat)'),
(1914,0,2,0,0,0,100,0,7000,9000,17000,22000,0,11,79856,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ambermill Magister - In Combat - Cast ''Flamestrike''');

-- Webwood Venomfang (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=1999 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=1999;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(1999,0,0,0,0,0,100,0,2000,4000,15000,16000,0,11,11918,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Webwood Venomfang - IC - Cast ┬¿Poison');

-- Webwood Silkspinner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2000 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2000;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2000,0,0,0,9,0,100,0,0,30,17000,20000,0,11,12023,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Webwood Silkspinner - Within 0-30 Range - Cast ''Web'''),
(2000,0,1,0,0,0,100,0,2000,4000,15000,17000,0,11,11918,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Webwood Silkspinner - IC - Cast Poison');

-- Gnarlpine Augur (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2011 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2011;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2011,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Gnarlpine Augur - Between 0-15% Health - Flee For Assist (No Repeat)'),
(2011,0,1,0,0,0,100,0,2000,4000,8000,11000,0,11,17227,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gnarlpine Augur - IC - Cast Curse of Weakness'),
(2011,0,2,0,2,0,100,1,0,20,0,0,0,11,5628,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gnarlpine Augur - IN health pct 20% - Cast Gnarlpine Vengeance');

-- Bloodfeather Matriarch (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2021 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2021;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2021,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bloodfeather Matriarch - In Combat - Cast ''Lightning Bolt'''),
(2021,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Bloodfeather Matriarch - Between 0-15% Health - Flee For Assist (No Repeat)'),
(2021,0,2,0,4,0,100,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodfeather Matriarch - On Aggro - Say Line 1 (No Repeat)');

-- Ancient Protector (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2041 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2041;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2041,0,0,0,9,0,100,0,0,30,21000,25000,0,11,11922,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ancient Protector - Within 0-30 Range - Cast ''Entangling Roots'''),
(2041,0,1,0,9,0,100,0,0,5,12000,18000,0,11,45,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ancient Protector - Within 0-5 Range - Cast ''War Stomp''');

-- Hillsbrad Miner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2269 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2269;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2269,0,0,0,11,0,100,0,0,0,0,0,0,87,226900,226901,226902,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Miner - On Respawn - Random Cast Paralytic Poison'),
(2269,0,1,2,8,0,100,0,88797,0,0,0,0,33,47697,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hillsbrad Miner - On Spellhit - Give Kill Credit'),
(2269,0,2,3,61,0,100,0,0,0,0,0,0,11,88799,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hillsbrad Miner - On Spellhit - Cross Cast Captured Hillsbrad Human'),
(2269,0,3,4,61,0,100,0,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Miner - On Spellhit - Force Despawn'),
(2269,0,4,5,61,0,100,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Miner - On Spellhit - Set Home Pos'),
(2269,0,5,0,61,0,100,0,0,0,0,0,0,24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Miner - On Spellhit - Evade'),
(2269,0,6,0,0,0,100,0,1000,1000,180000,180000,0,11,7164,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Miner - In Combat - Cast ''Defensive Stance'''),
(2269,0,7,0,2,0,100,1,0,30,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Hillsbrad Miner - Between 0-30% Health - Flee For Assist');

-- Hillsbrad Sentry (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2270 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2270;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2270,0,0,0,11,0,100,0,0,0,0,0,0,87,226900,226901,226902,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Sentry - On Respawn - Random Cast Paralytic Poison'),
(2270,0,1,2,8,0,100,0,88797,0,0,0,0,33,47697,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hillsbrad Sentry - On Spellhit - Give Kill Credit'),
(2270,0,2,3,61,0,100,0,0,0,0,0,0,11,88804,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hillsbrad Sentry - On Spellhit - Cross Cast Captured Hillsbrad Human'),
(2270,0,3,4,61,0,100,0,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Sentry - On Spellhit - Force Despawn'),
(2270,0,4,5,61,0,100,0,0,0,0,0,0,101,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Sentry - On Spellhit - Set Home Pos'),
(2270,0,5,0,61,0,100,0,0,0,0,0,0,24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hillsbrad Sentry - On Spellhit - Evade'),
(2270,0,6,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(2270,0,7,0,0,0,100,0,3000,5000,120000,125000,0,11,32064,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Battle Shout'),
(2270,0,8,0,4,0,100,1,0,0,0,0,0,11,22120,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Cast Charge on Aggro');

-- Syndicate Wizard (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2319 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2319;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2319,0,0,0,1,0,100,0,1000,1000,1800000,1800000,0,11,12544,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Syndicate Wizard - Out of Combat - Cast ''Frost Armor'''),
(2319,0,1,0,0,0,100,0,0,0,3400,4700,0,11,20815,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Fireball'),
(2319,0,2,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(2319,0,3,0,0,0,100,0,5000,8000,20000,22000,0,11,13323,0,0,0,0,0,4,0,0,0,0,0,0,0,0,'Cast Polymorph');

-- Dalaran Summoner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2358 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2358;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2358,0,0,0,0,0,100,0,0,0,3400,4700,0,11,79858,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Frostbolt'),
(2358,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(2358,0,2,0,2,0,100,1,0,40,0,0,0,11,87179,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Summon Water Elemental at 40% HP');

-- Daggerspine Siren (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2371 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2371;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2371,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Lightning Bolt'),
(2371,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(2371,0,2,0,0,0,100,0,5000,10000,15000,20000,0,11,6728,0,0,0,0,0,4,0,0,0,0,0,0,0,0,'Cast Enveloping Winds');

-- Mudsnout Shaman (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2373 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2373;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2373,0,0,0,0,0,100,0,0,0,3400,4700,0,11,20805,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Lightning Bolt'),
(2373,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(2373,0,10,0,6,0,100,0,0,0,0,0,0,7,28355,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Mudsnout Shaman - On Death - Add Quest ''Terrible Little Creatures'' to killer');

-- Torn Fin Oracle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2376 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2376;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2376,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Lightning Bolt'),
(2376,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP');

-- Witherbark Shadowcaster (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2553 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2553;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2553,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Witherbark Shadowcaster - Between 0-15% Health - Flee For Assist (No Repeat)'),
(2553,0,1,0,1,0,100,1,3000,5000,0,0,0,11,11939,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Summon Imp on Spawn'),
(2553,0,2,0,0,0,100,0,0,0,3400,4700,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadow Bolt');

-- Syndicate Magus (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2591 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2591;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2591,0,0,0,1,0,100,1,1000,1000,0,0,0,11,12544,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Syndicate Magus - Out of Combat - Cast ''Frost Armor'''),
(2591,0,1,0,0,0,100,0,0,0,3400,4700,0,11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Frostbolt'),
(2591,0,2,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(2591,0,3,0,0,0,100,0,8000,8000,18000,25000,0,11,8364,1,0,0,0,0,4,0,0,0,0,0,0,0,0,'Cast Blizzard');

-- Daggerspine Sorceress (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2596 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2596;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2596,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Lightning Bolt'),
(2596,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP');

-- Ruul Onestone (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2602 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2602;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2602,0,0,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text on Aggro'),
(2602,0,1,0,0,0,100,0,0,0,3400,4700,0,11,20822,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Frostbolt'),
(2602,0,2,0,2,0,100,1,0,25,0,0,0,11,6742,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Bloodlust at 25% HP');

-- Shadowforge Darkweaver (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2740 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2740;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2740,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadow Bolt'),
(2740,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(2740,0,2,0,1,0,100,0,500,1000,600000,600000,0,11,79934,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Demon Armor on Spawn');

-- Cresting Exile (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=2761 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=2761;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(2761,0,0,0,1,0,100,1,1000,1000,1800000,1800000,0,11,12544,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cresting Exile - Out Of Combat - Cast Frost Armor'),
(2761,0,1,0,0,0,100,0,1400,7300,25600,32300,0,11,11831,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cresting Exile - In Combat - Cast Frost Nova'),
(2761,0,2,0,8,0,100,0,4131,0,0,0,0,41,500,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cresting Exile - on spellhit - Despawn');

-- Razormane Dustrunner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3113 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3113;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3113,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9739,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razormane Dustrunner - In Combat - Cast ''Wrath'''),
(3113,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Razormane Dustrunner - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3113,0,2,0,1,0,100,0,500,1000,300000,300000,0,11,5280,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razormane Dustrunner - Out of Combat - Cast ''Razor Mane'''),
(3113,0,3,0,0,0,100,0,6000,8000,27000,33000,0,11,6950,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razormane Dustrunner - In Combat - Cast ''Faerie Fire''');

-- Razormane Battleguard (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3114 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3114;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3114,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Razormane Battleguard - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3114,0,1,0,4,0,100,1,0,0,0,0,0,11,32064,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razormane Battleguard - On Aggro - Cast ''Battle Shout'' (No Repeat)'),
(3114,0,2,0,1,0,100,0,500,1000,300000,300000,0,11,5280,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razormane Battleguard - Out of Combat - Cast ''Razor Mane'''),
(3114,0,3,0,0,0,100,0,4000,6000,25000,31000,0,11,77558,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razormane Battleguard - In Combat - Cast ''Bloody Strike'''),
(3114,0,4,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razormane Battleguard - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3114,0,5,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razormane Battleguard - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Burning Blade Neophyte (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3196 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3196;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3196,0,0,0,0,0,100,0,0,0,3400,4700,0,11,79932,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Neophyte - In Combat - Cast ''Shadow Bolt'''),
(3196,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Burning Blade Neophyte - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3196,0,2,0,1,0,100,0,500,1000,600000,600000,0,11,79954,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Neophyte - Out of Combat - Cast ''Fel Armor'''),
(3196,0,3,0,0,0,100,0,6000,8000,60000,65000,0,11,80174,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Neophyte - In Combat - Cast ''Felblood''');

-- Burning Blade Apprentice (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3198 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3198;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3198,0,0,0,0,0,100,0,0,0,3400,4700,0,11,77721,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Apprentice - In Combat - Cast ''Shadow Weave'''),
(3198,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Burning Blade Apprentice - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3198,0,2,0,1,0,100,1,3000,5000,0,0,0,11,12746,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Apprentice - Out of Combat - Cast ''Summon Voidwalker'' (No Repeat)'),
(3198,0,3,0,0,0,100,0,6000,8000,60000,65000,0,11,80174,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Apprentice - In Combat - Cast ''Felblood''');

-- Burning Blade Cultist (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3199 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3199;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3199,0,0,0,0,0,100,0,0,0,3400,4700,0,11,79938,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Cultist - In Combat - Cast ''Incinerate'''),
(3199,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Burning Blade Cultist - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3199,0,2,0,1,0,100,1,3000,5000,0,0,0,11,11939,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Cultist - Out of Combat - Cast ''Summon Imp'' (No Repeat)'),
(3199,0,3,0,0,0,100,0,6000,8000,60000,65000,0,11,80174,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Cultist - In Combat - Cast ''Felblood''');

-- Brave Proudsnout (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3210 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3210;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3210,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Brave Proudsnout - In Combat - Cast ''Shoot''');

-- Brave Lightninghorn (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3211 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3211;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3211,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Brave Lightninghorn - In Combat - Cast ''Shoot''');

-- Brave Running Wolf (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3213 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3213;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3213,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Brave Running Wolf - In Combat - Cast ''Shoot''');

-- Brave Greathoof (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3214 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3214;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3214,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Brave Greathoof - In Combat - Cast ''Shoot''');

-- Brave Dawneagle (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3217 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3217;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3217,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Brave Dawneagle - In Combat - Cast ''Shoot''');

-- Brave Darksky (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3220 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3220;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3220,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Brave Darksky - In Combat - Cast ''Shoot''');

-- Brave Rockhorn (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3221 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3221;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3221,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Brave Rockhorn - In Combat - Cast ''Shoot''');

-- Brave Rainchaser (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3223 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3223;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3223,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Brave Rainchaser - In Combat - Cast ''Shoot''');

-- Stormsnout (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3240 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3240;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3240,0,0,0,0,0,100,0,3000,4500,12000,13000,0,11,15611,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Stormsnout - In Combat - Cast ''Lizard Bolt''');

-- Bristleback Thornweaver (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3261 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3261;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3261,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9739,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bristleback Thornweaver - In Combat - Cast ''Wrath'''),
(3261,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Bristleback Thornweaver - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3261,0,2,0,9,0,100,0,0,20,9000,12000,0,11,12747,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bristleback Thornweaver - Within 0-20 Range - Cast ''Entangling Roots''');

-- Razormane Mystic (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3271 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3271;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3271,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razormane Mystic - In Combat - Cast ''Shadow Bolt'''),
(3271,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Razormane Mystic - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3271,0,2,0,1,0,100,0,500,1000,600000,600000,0,11,12550,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razormane Mystic - Out of Combat - Cast ''Lightning Shield'''),
(3271,0,3,0,16,0,100,0,12550,1,15000,30000,0,11,12550,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razormane Mystic - On Friendly Unit Missing Buff ''Lightning Shield'' - Cast ''Lightning Shield''');

-- Sen'jin Watcher (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3297 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3297;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3297,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sen''jin Watcher - In Combat - Cast ''Shoot''');

-- Bael'dun Excavator (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3374 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3374;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3374,0,0,0,0,0,100,0,2000,4500,12000,14000,0,11,57846,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bael''dun Excavator - In Combat - Cast ''Heroic Strike'''),
(3374,0,1,0,0,0,100,0,6000,8000,22000,26000,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bael''dun Excavator - In Combat - Cast ''Sunder Armor'''),
(3374,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Bael''dun Excavator - Between 0-15% Health - Flee For Assist (No Repeat)');

-- Bael'dun Foreman (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3375 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3375;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3375,0,0,0,4,0,100,1,0,0,0,0,0,11,32064,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bael''dun Foreman - On Aggro - Cast ''Battle Shout'' (No Repeat)'),
(3375,0,1,0,0,0,100,0,2000,4000,21000,24000,0,11,6257,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bael''dun Foreman - In Combat - Cast ''Torch Toss'''),
(3375,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Bael''dun Foreman - Between 0-15% Health - Flee For Assist (No Repeat)');

-- Bael'dun Officer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3378 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3378;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3378,0,0,0,0,0,100,1,0,0,1000,1000,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bael''dun Officer - In Combat - Cast ''Thrash'' (No Repeat)'),
(3378,0,1,0,0,0,60,0,5000,5000,23000,23000,0,11,6264,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bael''dun Officer - In Combat - Cast ''Nimble Reflexes'' (No Repeat)');

-- Burning Blade Acolyte (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3380 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3380;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3380,0,0,0,2,0,100,0,0,40,14000,21000,0,11,689,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Acolyte - Between 0-40% Health - Cast ''Drain Life'''),
(3380,0,1,0,0,0,100,0,3000,4500,34000,38000,0,11,980,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Acolyte - In Combat - Cast ''Bane of Agony'''),
(3380,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Burning Blade Acolyte - Between 0-15% Health - Flee For Assist (No Repeat)');

-- Hezrul Bloodmark (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3396 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3396;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3396,0,0,1,11,0,100,0,0,0,0,0,0,12,44170,5,30000,2,0,0,8,0,0,0,0,-1062.04,-2278.94,90.0085,0,'Hezrul Bloodmark - On Respawn - Summon Creature Hezrul''s Bloodguard'),
(3396,0,1,0,61,0,100,0,0,0,0,0,0,12,44170,5,30000,2,0,0,8,0,0,0,0,-1060.2,-2281.08,90.6286,0,'Hezrul Bloodmark - Linked To Id 0 - Summon Creature Hezrul''s Bloodguard'),
(3396,0,2,0,0,0,100,0,8000,9000,21000,22000,0,11,6958,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Hezrul Bloodmark - In Combat - Cast ''Blood Leech'''),
(3396,0,3,0,1,0,100,0,5000,10000,25000,35000,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hezrul Bloodmark - Out of Combat - Say Line 0');

-- Ambermill Brewmaster (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3577 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3577;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3577,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Ambermill Brewmaster - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3577,0,1,0,0,0,100,0,2000,4500,15000,20000,0,11,37591,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ambermill Brewmaster - In Combat - Cast ''Drunken Haze''');

-- Ambermill Miner (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3578 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3578;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3578,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Ambermill Miner - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3578,0,1,0,0,0,100,0,2000,3000,12000,14500,0,11,39214,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ambermill Miner - In Combat - Cast ''Pierce Armor''');

-- Raene Wolfrunner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3691 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3691;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3691,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Raene Wolfrunner - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3691,0,1,0,0,0,100,0,0,0,2300,3900,0,11,16100,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Raene Wolfrunner - In Combat - Cast ''Shoot'''),
(3691,0,2,0,9,0,100,0,0,20,8000,9000,0,11,6533,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Raene Wolfrunner - Within 0-20 Range - Cast ''Net'''),
(3691,0,3,0,9,0,100,0,5,30,12000,19000,0,11,15495,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Raene Wolfrunner - Within 5-30 Range - Cast ''Explosive Shot'''),
(3691,0,4,0,9,0,100,0,5,30,22000,27000,0,11,22908,2,0,0,0,0,4,0,0,0,0,0,0,0,0,'Raene Wolfrunner - Within 5-30 Range - Cast ''Volley''');

-- Ran Bloodtooth (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3696 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3696;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3696,0,0,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ran Bloodtooth - In Combat - Cast ''Shoot'''),
(3696,0,1,2,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Ran Bloodtooth - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3696,0,2,0,61,0,100,1,0,15,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ran Bloodtooth - Between 0-15% Health - Say Line 0 (No Repeat)'),
(3696,0,3,0,9,0,100,0,0,5,15000,25000,0,11,78842,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ran Bloodtooth - Within 0-5 Range - Cast ''Carnivorous Bite'''),
(3696,0,4,0,9,0,100,0,5,30,9000,22000,0,11,78841,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ran Bloodtooth - Within 5-30 Range - Cast ''Aimed Shot'''),
(3696,0,5,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ran Bloodtooth - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3696,0,6,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ran Bloodtooth - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Wrathtail Sorceress (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3717 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3717;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3717,0,0,0,0,0,100,0,0,0,3400,4700,0,11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wrathtail Sorceress - In Combat - Cast ''Frostbolt'''),
(3717,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Wrathtail Sorceress - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3717,0,2,0,9,0,100,0,0,8,12000,13000,0,11,11831,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wrathtail Sorceress - Within 0-8 Range - Cast ''Frost Nova'''),
(3717,0,3,0,1,0,100,0,500,1000,600000,600000,0,11,34827,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wrathtail Sorceress - Out of Combat - Cast ''Water Shield''');

-- Forsaken Herbalist (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3733 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3733;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3733,0,0,0,4,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Forsaken Herbalist - On Aggro - Say Line 0 (No Repeat)'),
(3733,0,1,0,0,0,100,0,5000,5500,21000,25000,0,11,78705,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Herbalist - In Combat - Cast ''Poison Bottle''');

-- Orc Overseer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3734 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3734;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3734,0,0,0,0,0,100,0,3000,4000,34000,35000,0,11,78710,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Orc Overseer - In Combat - Cast ''Threatening Shout'''),
(3734,0,1,0,4,0,100,1,0,0,0,0,0,43,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Orc Overseer - On Aggro - Dismount (No Repeat)'),
(3734,0,2,0,1,0,30,0,1000,1000,25000,35000,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Orc Overseer - Out of Combat - Say Line 0'),
(3734,0,3,0,4,0,30,1,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Orc Overseer - On Aggro - Say Line 1 (No Repeat)');

-- Foulweald Warrior (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3743 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3743;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3743,0,0,0,11,0,100,1,0,0,0,0,0,11,6821,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foulweald Warrior - On Respawn - Cast ''Corrupted Strength Passive'' (No Repeat)'),
(3743,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Foulweald Warrior - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3743,0,2,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foulweald Warrior - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3743,0,3,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foulweald Warrior - Between 0-30% Health - Say Line 0 (No Repeat)'),
(3743,0,4,0,1,0,100,0,2000,2000,20000,20000,0,69,1,0,0,0,0,0,20,178205,100,0,0,0,0,0,0,'Foulweald Warrior - Out of Combat - Move To Closest Gameobject ''Karang''s Banner'' (Phase 1)'),
(3743,0,5,0,34,0,100,0,8,1,0,0,0,11,20786,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foulweald Warrior - On Reached Point 1 - Cast ''Destroy Karang''s Banner''');

-- Foulweald Totemic (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3750 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3750;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3750,0,0,0,11,0,100,1,0,0,0,0,0,11,6823,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foulweald Totemic - On Respawn - Cast ''Corrupted Intellect Passive'' (No Repeat)'),
(3750,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Foulweald Totemic - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3750,0,2,0,9,0,100,0,0,8,18000,21000,0,11,6817,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foulweald Totemic - Within 0-8 Range - Cast ''Corrupted Agility'''),
(3750,0,3,0,0,0,100,0,5000,7000,24000,26000,0,11,39591,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foulweald Totemic - In Combat - Cast ''Searing Totem'''),
(3750,0,4,0,1,0,100,0,2000,2000,20000,20000,0,69,1,0,0,0,0,0,20,178205,100,0,0,0,0,0,0,'Foulweald Totemic - Out of Combat - Move To Closest Gameobject ''Karang''s Banner'' (Phase 1)'),
(3750,0,5,0,34,0,100,0,8,1,0,0,0,11,20786,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foulweald Totemic - On Reached Point 1 - Cast ''Destroy Karang''s Banner''');

-- Felmusk Satyr (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3758 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3758;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3758,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Felmusk Satyr - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3758,0,1,0,0,0,100,0,4000,5000,12000,19500,0,11,31279,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Felmusk Satyr - In Combat - Cast ''Swipe'''),
(3758,0,2,0,0,0,100,0,10000,12000,600000,600000,0,11,6942,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Satyr - In Combat - Cast ''Overwhelming Stench'''),
(3758,0,3,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Satyr - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3758,0,4,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Satyr - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Felmusk Felsworn (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3762 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3762;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3762,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Felmusk Felsworn - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3762,0,1,0,0,0,100,0,0,0,3400,4700,0,11,32707,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Felmusk Felsworn - In Combat - Cast ''Incinerate'''),
(3762,0,2,0,0,0,100,0,7000,8000,22000,26000,0,11,11962,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Felmusk Felsworn - In Combat - Cast ''Immolate'''),
(3762,0,3,0,0,0,100,0,10000,12000,600000,600000,0,11,6942,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Felsworn - In Combat - Cast ''Overwhelming Stench'''),
(3762,0,4,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Felsworn - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3762,0,5,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Felsworn - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Felmusk Shadowstalker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3763 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3763;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3763,0,0,0,11,0,100,1,0,0,0,0,0,11,22766,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Shadowstalker - On Respawn - Cast ''Sneak'' (No Repeat)'),
(3763,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Felmusk Shadowstalker - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3763,0,2,0,0,0,100,0,0,0,2300,3900,0,11,10277,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Felmusk Shadowstalker - In Combat - Cast ''Throw'''),
(3763,0,3,0,11,0,100,1,0,0,0,0,0,11,77806,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Shadowstalker - On Respawn - Cast ''Stealth'' (No Repeat)'),
(3763,0,4,0,7,0,100,1,0,0,0,0,0,11,77806,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Shadowstalker - On Evade - Cast ''Stealth'' (No Repeat)'),
(3763,0,5,0,0,0,100,0,10000,12000,600000,600000,0,11,6942,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Shadowstalker - In Combat - Cast ''Overwhelming Stench'''),
(3763,0,6,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Shadowstalker - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3763,0,7,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felmusk Shadowstalker - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Bleakheart Satyr (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3765 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3765;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3765,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bleakheart Satyr - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3765,0,1,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Satyr - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3765,0,2,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Satyr - Between 0-30% Health - Say Line 0 (No Repeat)'),
(3765,0,3,0,0,0,100,0,5000,5500,12000,16000,0,11,31279,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bleakheart Satyr - In Combat - Cast ''Swipe''');

-- Bleakheart Trickster (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3767 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3767;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3767,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bleakheart Trickster - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3767,0,1,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Trickster - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3767,0,2,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Trickster - Between 0-30% Health - Say Line 0 (No Repeat)'),
(3767,0,3,0,4,0,100,1,0,0,0,0,0,11,77457,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Trickster - On Aggro - Cast ''Dazzling Lights'' (No Repeat)');

-- Bleakheart Shadowstalker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3770 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3770;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3770,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bleakheart Shadowstalker - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3770,0,1,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Shadowstalker - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3770,0,2,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Shadowstalker - Between 0-30% Health - Say Line 0 (No Repeat)'),
(3770,0,3,0,2,0,100,0,0,50,35000,40000,0,11,77471,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Shadowstalker - Between 0-50% Health - Cast ''Shadow Shield'''),
(3770,0,4,0,16,0,100,0,77471,40,35000,42000,0,11,77471,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bleakheart Shadowstalker - On Friendly Unit Missing Buff ''Shadow Shield'' - Cast ''Shadow Shield'''),
(3770,0,5,0,11,0,100,1,0,0,0,0,0,11,77806,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Shadowstalker - On Respawn - Cast ''Stealth'' (No Repeat)'),
(3770,0,6,0,7,0,100,1,0,0,0,0,0,11,77806,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleakheart Shadowstalker - On Evade - Cast ''Stealth'' (No Repeat)');

-- Lesser Felguard (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3772 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3772;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3772,0,0,0,9,0,100,0,0,5,14000,19000,0,11,18812,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lesser Felguard - Within 0-5 Range - Cast ''Knockdown'''),
(3772,0,1,0,0,0,100,0,2000,4500,66000,77000,0,11,184,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lesser Felguard - In Combat - Cast ''Fire Shield'''),
(3772,0,2,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lesser Felguard - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3772,0,3,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lesser Felguard - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Felslayer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3774 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3774;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3774,0,0,0,0,0,100,0,3500,5000,12000,14000,0,11,13321,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Felslayer - In Combat - Cast ''Mana Burn''');

-- Shadethicket Raincaller (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3783 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3783;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3783,0,0,0,0,0,100,0,2000,4000,12000,17000,0,11,9532,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadethicket Raincaller - In Combat - Cast ''Lightning Bolt'''),
(3783,0,1,0,0,0,100,0,8000,9000,24000,35000,0,11,32193,0,0,0,0,0,4,0,0,0,0,0,0,0,0,'Shadethicket Raincaller - In Combat - Cast ''Lightning Cloud''');

-- Cenarion Protector (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3797 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3797;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3797,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Cenarion Protector - Between 0-15% Health - Flee For Assist'),
(3797,0,1,0,1,0,100,0,500,1000,300000,300000,0,11,7090,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cenarion Protector - Out of Combat - Cast ''Bear Form'''),
(3797,0,2,0,0,0,100,0,9000,20000,19000,24000,0,11,15727,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cenarion Protector - In Combat - Cast ''Demoralizing Roar'''),
(3797,0,3,4,2,0,100,0,0,50,14000,21000,0,28,7090,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cenarion Protector - Between 0-50% Health - Remove Aura ''Bear Form'''),
(3797,0,4,0,61,0,100,0,0,50,14000,21000,0,11,12160,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cenarion Protector - Between 0-50% Health - Cast ''Rejuvenation'''),
(3797,0,5,0,3,0,100,0,60,100,100,100,0,11,7090,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cenarion Protector - Between 60-100% Mana - Cast ''Bear Form''');

-- Ghostpaw Runner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3823 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3823;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3823,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Ghostpaw Runner - Between 0-15% Health - Flee For Assist'),
(3823,0,1,0,4,0,100,1,0,0,0,0,0,11,78703,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ghostpaw Runner - On Aggro - Cast ''Ghostform'' (No Repeat)'),
(3823,0,2,0,0,0,100,0,4000,5000,15000,21000,0,11,78702,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ghostpaw Runner - In Combat - Cast ''Arcane Explosion'''),
(3823,0,3,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ghostpaw Runner - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3823,0,4,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ghostpaw Runner - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Relara Whitemoon (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3892 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3892;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3892,0,0,0,1,0,100,1,0,0,0,0,0,11,6606,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Relara Whitemoon - Out of Combat - Cast ''Self Visual - Sleep Until Cancelled  (DND)'''),
(3892,0,1,0,1,0,100,1,0,0,0,0,0,11,46765,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Relara Whitemoon - Out of Combat - Cast ''Self Visual - Sleep Until Cancelled  (DND)'''),
(3892,0,2,0,38,0,100,0,0,1,0,0,0,1,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Relara Whitemoon - On Data Set - Say Line 0');

-- Thistlefur Ursa (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3921 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3921;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3921,0,0,0,1,0,100,1,3000,3000,0,0,0,11,7165,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Thistlefur Ursa - Out of Combat - Cast ''Battle Stance'''),
(3921,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Thistlefur Ursa - Between 0-15% Health - Flee For Assist'),
(3921,0,2,0,11,0,100,1,0,0,0,0,0,11,6813,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Thistlefur Ursa - On Respawn - Cast ''Coat of Thistlefur'' (No Repeat)'),
(3921,0,3,0,0,0,100,0,5000,6000,24000,32000,0,11,8078,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Thistlefur Ursa - In Combat - Cast ''Thunderclap'''),
(3921,0,4,0,2,0,100,1,0,30,0,0,0,11,3490,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Thistlefur Ursa - Between 0-30% Health - Cast ''Frenzied Rage'' (No Repeat)'),
(3921,0,5,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Thistlefur Ursa - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Thistlefur Pathfinder (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3926 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3926;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3926,0,0,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Thistlefur Pathfinder - In Combat - Cast ''Shoot'''),
(3926,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Thistlefur Pathfinder - Between 0-15% Health - Flee For Assist (No Repeat)'),
(3926,0,2,0,11,0,100,1,0,0,0,0,0,11,6813,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Thistlefur Pathfinder - On Respawn - Cast ''Coat of Thistlefur'' (No Repeat)'),
(3926,0,3,0,9,0,100,0,5,30,14000,19000,0,11,78754,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Thistlefur Pathfinder - Within 5-30 Range - Cast ''Arcane Shot''');

-- Uthil Mooncall (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3941 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3941;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3941,0,0,0,4,0,100,1,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Uthil Mooncall - On Aggro - Set Event Phase 1 (No Repeat)'),
(3941,0,1,0,4,1,100,1,0,0,0,0,0,11,7090,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Uthil Mooncall - On Aggro - Cast ''Bear Form'' (Phase 1) (No Repeat)'),
(3941,0,2,0,0,1,100,0,2000,4500,12000,15000,0,11,12161,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Uthil Mooncall - In Combat - Cast ''Maul'' (Phase 1)');

-- Mavoris Cloudsbreak (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3942 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3942;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3942,0,0,0,0,0,100,0,2000,4500,12000,15000,0,11,12058,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mavoris Cloudsbreak - In Combat - Cast ''Chain Lightning'''),
(3942,0,1,0,0,0,100,0,7000,8000,25000,29000,0,11,6535,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mavoris Cloudsbreak - In Combat - Cast ''Lightning Cloud''');

-- Dal Bloodclaw (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3987 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=3987;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3987,0,0,0,2,0,100,1,0,50,0,0,0,39,50,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dal Bloodclaw - Between 0-50% Health - Call For Help'),
(3987,0,1,0,11,0,100,1,0,0,0,0,0,11,6813,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dal Bloodclaw - On Respawn - Cast ''Coat of Thistlefur'' (No Repeat)'),
(3987,0,2,0,9,0,100,1,0,5,14000,17000,0,11,77558,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dal Bloodclaw - Within 0-5 Range - Cast ''Bloody Strike'''),
(3987,0,3,0,2,0,100,1,0,50,0,0,0,11,21049,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dal Bloodclaw - Between 0-50% Health - Cast ''Bloodlust'' (No Repeat)'),
(3987,0,4,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dal Bloodclaw - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(3987,0,5,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dal Bloodclaw - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Cloud Serpent (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4117 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4117;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4117,0,0,0,0,0,100,0,0,0,3400,4700,0,11,57780,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cloud Serpent - In Combat - Cast ''Lightning Bolt''');

-- Venomous Cloud Serpent (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4118 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4118;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4118,0,0,0,11,0,100,1,0,0,0,0,0,11,10022,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Venomous Cloud Serpent - On Respawn - Cast ''Deadly Poison'' (Phase 1) (No Repeat)'),
(4118,0,1,0,0,0,100,0,3000,3200,16000,18000,0,11,3583,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Venomous Cloud Serpent - In Combat - Cast ''Deadly Poison''');

-- Keeper Ordanus (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4273 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4273;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4273,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Keeper Ordanus - Between 0-15% Health - Flee For Assist (No Repeat)'),
(4273,0,1,0,0,0,100,0,0,0,3400,4700,0,11,9739,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Keeper Ordanus - In Combat - Cast ''Wrath'''),
(4273,0,2,0,9,0,100,0,0,30,9000,11000,0,11,12747,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Keeper Ordanus - Within 0-30 Range - Cast ''Entangling Roots'''),
(4273,0,3,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Keeper Ordanus - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(4273,0,4,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Keeper Ordanus - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Darkmist Spider (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4376 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4376;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4376,0,0,0,0,0,100,0,2000,3000,18000,22000,0,11,69964,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darkmist Spider - In Combat - Cast ''Poison''');

-- Charlga Razorflank (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4421 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4421;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4421,0,0,0,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Charlga Razorflank - On Aggro - Yell Line 0'),
(4421,0,1,0,5,0,100,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Charlga Razorflank - On Killed Unit - Yell Line 1'),
(4421,0,2,0,2,0,100,1,0,75,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Charlga Razorflank - Between 0-75% Health  - Yell Line 2''(No Repeat)'),
(4421,0,3,0,2,0,100,1,0,50,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Charlga Razorflank - Between 0-50% Health  - Yell Line 3''(No Repeat)'),
(4421,0,4,0,2,0,100,1,0,25,0,0,0,1,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Charlga Razorflank - Between 0-25% Health  - Yell Line 4''(No Repeat)'),
(4421,0,5,0,0,0,100,2,9000,13000,9000,13000,0,11,8361,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Charlga Razorflank - In Combat - Cast Purity'),
(4421,0,6,0,2,0,100,0,0,80,15000,18000,0,11,56332,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Charlga Razorflank - Between 0-80% Health - Cast ''Renew'''),
(4421,0,7,0,0,0,100,2,0,0,3400,4800,0,11,8292,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Charlga Razorflank - In Combat - Cast Chain Bolt'),
(4421,0,8,0,3,0,100,1,0,5,0,0,0,11,8358,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Charlga Razorflank - Between 0-5% Mana - Cast ''Mana Spike''');

-- Agathelos the Raging (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4422 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4422;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4422,0,0,0,2,0,100,3,0,40,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text at 40% HP'),
(4422,0,1,0,2,0,100,3,0,60,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text at 60% HP'),
(4422,0,2,0,0,0,100,0,5000,5000,14000,14000,0,11,8285,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Agathelos the Raging - In Combat - Cast Rampage'),
(4422,0,3,0,0,0,100,0,2000,8000,7000,9000,0,11,8555,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Agathelos the Raging - In Combat - Cast Left For Dead'),
(4422,0,4,0,2,0,100,1,0,25,0,0,0,11,30485,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Agathelos the Raging - Between 0-25% Health - Cast Enrage'),
(4422,0,5,6,4,0,100,3,0,0,0,0,0,11,8260,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Rushing Charge on Aggro'),
(4422,0,6,0,61,0,100,3,0,0,0,0,0,39,15,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Call for Help on Aggro'),
(4422,0,7,0,2,0,100,3,0,40,0,0,0,11,8269,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Frenzy at 40% HP'),
(4422,0,8,0,2,0,100,3,0,60,0,0,0,11,8269,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Frenzy at 60% HP');

-- Aggem Thorncurse (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4424 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4424;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4424,0,0,0,0,0,100,1,0,0,0,0,0,11,9128,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Aggem Thorncurse - In Combat - Cast ''Battle Shout'''),
(4424,0,1,0,0,0,100,0,10000,10000,26000,26000,0,11,8286,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Aggem Thorncurse - In Combat - Cast ''Summon Boar Spirit'''),
(4424,0,2,0,2,0,100,0,0,75,13000,18000,0,11,14900,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razorfen Handler - Between 0-75% Health - Cast Chain Heal');

-- Death Speaker Jargba (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4428 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4428;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4428,0,0,0,4,0,100,3,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 on Aggro'),
(4428,0,1,0,4,1,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving on Aggro'),
(4428,0,2,0,9,1,100,2,40,100,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving when not in bolt Range'),
(4428,0,3,0,9,1,100,2,10,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving at 15 Yards'),
(4428,0,4,0,9,1,100,2,0,40,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving when in bolt Range'),
(4428,0,5,0,3,1,100,2,0,15,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 2 at 15% Mana'),
(4428,0,6,0,3,2,100,2,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving at 15% Mana'),
(4428,0,7,0,3,2,100,2,30,100,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 When Mana is above 30%'),
(4428,0,8,0,0,0,100,0,0,0,3000,3500,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Death Speaker Jargba - In Combat - Cast Shadow Bolt'),
(4428,0,9,0,0,0,100,0,5000,12000,30000,30000,0,11,14515,0,0,0,0,0,6,20,0,0,0,0,0,0,0,'Death Speaker Jargba - In Combat - Cast Dominate Mind');

-- Murkgill Forager (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4457 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4457;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4457,0,0,1,6,0,100,0,0,0,0,0,0,12,40350,3,10000,0,0,0,1,0,0,0,0,0,0,0,0,'Murkgill Forager - On Death - Summon Creature Generic Trigger Lab'),
(4457,0,1,0,61,0,100,0,0,0,0,0,0,41,7000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murkgill Forager- Linked To Id 0 - Despawn after 7 sec'),
(4457,0,2,0,0,0,100,0,1000,2000,19900,30000,0,11,13443,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murkgill Forager - In Combat - Cast ''Rend'''),
(4457,0,3,0,0,0,100,0,2600,2600,3700,9100,0,11,744,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murkgill Forager - In Combat - Cast ''Poison'''),
(4457,0,4,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Murkgill Forager - Between 0-15% Health - Flee For Assist');

-- Murkgill Hunter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4458 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4458;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4458,0,0,1,6,0,100,0,0,0,0,0,0,12,40350,3,10000,0,0,0,1,0,0,0,0,0,0,0,0,'Murkgill Hunter - On Death - Summon Creature Generic Trigger Lab'),
(4458,0,1,0,61,0,100,0,0,0,0,0,0,41,7000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murkgill Hunter- Linked To Id 0 - Despawn after 7 sec'),
(4458,0,2,0,0,0,100,0,0,0,2600,4800,0,11,10277,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murkgill Hunter - In Combat CMC - Cast ''Throw'''),
(4458,0,3,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Murkgill Hunter - Between 0-15% Health - Flee For Assist');

-- Murkgill Oracle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4459 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4459;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4459,0,0,1,6,0,100,0,0,0,0,0,0,12,40350,3,10000,0,0,0,1,0,0,0,0,0,0,0,0,'Murkgill Oracle - On Death - Summon Creature Generic Trigger Lab'),
(4459,0,1,0,61,0,100,0,0,0,0,0,0,41,7000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murkgill Oracle- Linked To Id 0 - Despawn after 7 sec'),
(4459,0,2,0,0,0,100,0,0,0,2400,3800,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murkgill Oracle - In Combat CMC - Cast ''Lightning Bolt'''),
(4459,0,3,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Murkgill Oracle - Between 0-15% Health - Flee For Assist');

-- Razorfen Geomancer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4520 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4520;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4520,0,0,0,4,0,100,3,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 on Aggro'),
(4520,0,1,0,4,1,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving on Aggro'),
(4520,0,2,0,9,1,100,2,40,100,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving when not in bolt Range'),
(4520,0,3,0,9,1,100,2,10,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving at 15 Yards'),
(4520,0,4,0,9,1,100,2,0,40,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving when in bolt Range'),
(4520,0,5,0,3,1,100,2,0,15,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 2 at 15% Mana'),
(4520,0,6,0,3,2,100,2,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving at 15% Mana'),
(4520,0,7,0,3,2,100,2,30,100,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 When Mana is above 30%'),
(4520,0,8,0,2,2,100,3,0,15,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 3 at 15% HP'),
(4520,0,9,0,2,3,100,3,0,15,0,0,0,25,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(4520,0,10,0,7,3,100,3,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Reset on Evade'),
(4520,0,11,0,2,3,100,3,0,15,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text at 15% HP'),
(4520,0,12,0,1,0,100,1,1000,1000,0,0,0,11,8270,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razorfen Geomancer - Out of Combat - Cast Summon Earth Rumbler'),
(4520,0,13,0,0,0,100,0,1000,1000,3000,3500,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razorfen Geomancer - In Combat - Cast Lightning Bolt');

-- Burning Blade Felsworn (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4666 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4666;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4666,0,0,0,0,0,100,0,4000,5000,60000,65000,0,11,77645,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Felsworn - In Combat - Cast ''Felblood'''),
(4666,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Burning Blade Felsworn - Between 0-15% Health - Flee For Assist (No Repeat)');

-- Burning Blade Summoner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4668 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4668;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4668,0,0,0,1,0,100,1,1000,1000,0,0,0,11,688,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Summoner - Out of Combat - Cast ''Summon Imp'''),
(4668,0,1,0,0,0,100,0,0,0,3400,4700,0,11,20825,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Summoner - In Combat - Cast ''Shadow Bolt'''),
(4668,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Burning Blade Summoner - Between 0-15% Health - Flee For Assist (No Repeat)'),
(4668,0,3,0,1,0,100,1,3000,5000,0,0,0,11,11939,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Summoner - Out of Combat - Cast ''Summon Imp'' (No Repeat)'),
(4668,0,4,0,0,0,100,0,4000,5000,60000,65000,0,11,77645,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Burning Blade Summoner - In Combat - Cast ''Felblood''');

-- Earthcaller Halmgar (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4842 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4842;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4842,0,0,0,4,0,100,3,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 on Aggro'),
(4842,0,1,0,4,1,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving on Aggro'),
(4842,0,2,0,9,1,100,2,40,100,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving when not in bolt Range'),
(4842,0,3,0,9,1,100,2,10,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving at 15 Yards'),
(4842,0,4,0,9,1,100,2,0,40,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving when in bolt Range'),
(4842,0,5,0,3,1,100,2,0,15,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 2 at 15% Mana'),
(4842,0,6,0,3,2,100,2,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving at 15% Mana'),
(4842,0,7,0,3,2,100,2,30,100,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 When Mana is above 30%'),
(4842,0,8,0,1,0,100,1,1000,1000,0,0,0,11,8270,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Earthcaller Halmgar - Out of Combat - Cast Summon Earth Rumbler'),
(4842,0,9,0,0,0,100,0,0,0,3000,3500,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Earthcaller Halmgar - In Combat - Cast Lightning Bolt'),
(4842,0,10,0,0,0,100,0,0,2000,50000,60000,0,11,2484,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Earthcaller Halmgar - In Combat - Cast Earthbind Totem');

-- Stonevault Brawler (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=4855 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=4855;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(4855,0,0,0,25,0,100,0,0,0,0,0,0,11,3417,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonevault Brawler - On Reset - Cast Thrash'),
(4855,0,1,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonevault Brawler - Between 0-30% Health - Cast Frenzy');

-- Woodpaw Mystic (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5254 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5254;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5254,0,0,0,4,0,100,1,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - On Aggro - Set Event Phase 1 (No Repeat)'),
(5254,0,1,0,4,1,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - On Aggro - Disable Combat Movement (Phase 1) (No Repeat)'),
(5254,0,2,0,4,1,100,1,0,0,0,0,0,11,9739,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Woodpaw Mystic - On Aggro - Cast ''Wrath'' (Phase 1) (No Repeat)'),
(5254,0,3,0,9,1,100,0,0,40,3400,4700,0,11,9739,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Within 0-40 Range - Cast ''Wrath'' (Phase 1)'),
(5254,0,4,0,9,1,100,0,40,100,2000,2000,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Within 40-100 Range - Enable Combat Movement (Phase 1)'),
(5254,0,5,0,9,1,100,0,10,15,2000,2000,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Within 10-15 Range - Disable Combat Movement (Phase 1)'),
(5254,0,6,0,9,1,100,0,0,40,2000,2000,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Within 0-40 Range - Disable Combat Movement (Phase 1)'),
(5254,0,7,0,3,1,100,1,0,15,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Between 0-15% Mana - Set Event Phase 2 (Phase 1)'),
(5254,0,8,0,3,2,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Between 0-15% Mana - Enable Combat Movement (Phase 2)'),
(5254,0,9,0,3,2,100,0,30,100,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Between 30-100% Mana - Set Event Phase 1 (Phase 2)'),
(5254,0,10,0,2,2,100,1,0,15,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Between 0-15% Health - Set Event Phase 3 (Phase 2) (No Repeat)'),
(5254,0,11,0,2,3,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Between 0-15% Health - Flee For Assist (Phases 1 & 2) (No Repeat)'),
(5254,0,12,0,7,3,100,1,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - On Evade - Set Event Phase 0 (Phases 1 & 2) (No Repeat)'),
(5254,0,13,0,2,1,100,1,0,30,0,0,0,11,81211,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - Between 0-30% Health - Cast ''Woodpaw Brand'' (Phase 1) (No Repeat)'),
(5254,0,14,0,0,1,100,0,5000,5000,19000,22000,0,11,39591,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Woodpaw Mystic - In Combat - Cast ''Searing Totem'' (Phase 1)');

-- Nightmare Wyrmkin (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5280 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5280;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5280,0,0,0,0,0,100,0,0,1000,3000,4000,0,11,15653,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nightmare Wyrmkin - In Combat - Cast Acid Spit'),
(5280,0,1,0,0,0,100,0,4000,12000,12000,18000,0,11,12098,0,0,0,0,0,6,30,0,0,0,0,0,0,0,'Nightmare Wyrmkin - In Combat - Cast Sleep');

-- Longtooth Runner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5286 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5286;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5286,0,0,0,8,0,100,0,11886,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Longtooth Runner - On SpellHit Capture Beast - Despawn'),
(5286,0,1,2,1,0,20,0,30000,600000,120000,600000,0,4,1018,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Longtooth Runner - Out of Combat - Play Sound 1018'),
(5286,0,2,0,61,0,20,0,30000,600000,120000,600000,0,5,393,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Longtooth Runner - Out of Combat - Play Emote 393'),
(5286,0,3,0,0,0,100,0,4000,5000,17000,20000,0,11,3149,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Longtooth Runner - In Combat - Cast ''Furious Howl''');

-- Coral Shark (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5434 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5434;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5434,0,0,0,11,0,100,1,0,0,0,0,0,11,3391,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Thrash on Spawn'),
(5434,0,1,0,25,0,100,1,0,0,0,0,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Thrash on Spawn');

-- Hazzali Swarmer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5451 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5451;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5451,0,0,0,1,0,100,1,0,0,1000,1000,0,11,6589,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hazzali Swarmer - Out of Combat - Cast ''Silithid Swarm'''),
(5451,0,2,3,38,0,100,1,1,0,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hazzali Swarmer'),
(5451,0,3,4,61,0,100,0,0,0,0,0,0,3,38739,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hazzali Swarmer'),
(5451,0,4,0,61,0,100,0,0,0,0,0,0,29,0,0,38706,38742,0,0,12,1,0,0,0,0,0,0,0,'Hazzali Swarmer'),
(5451,0,5,0,75,0,100,1,0,38706,10,0,0,33,38742,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Hazzali Swarmer'),
(5451,0,6,0,4,0,100,1,0,0,0,0,0,11,10722,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hazzali Swarmer - On Aggro - Cast ''Silithid Swarm'' (No Repeat)'),
(5451,0,7,0,0,0,100,0,6000,7000,25000,27000,0,11,81224,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Hazzali Swarmer - In Combat - Cast ''Silithid Toxin''');

-- Dunemaul Warlock (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5475 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5475;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5475,0,2,3,8,0,100,0,73068,0,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - On SpellHit Throw Morsel - Set Faction 35'),
(5475,0,3,4,61,0,100,0,0,0,0,0,0,33,39073,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 2 - Quest Credit'),
(5475,0,4,5,61,0,100,0,0,0,0,0,0,203,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 3 - Combat Stop'),
(5475,0,5,6,61,0,100,0,0,0,0,0,0,5,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 4 - Play Emote 7'),
(5475,0,6,0,61,0,100,0,0,0,0,0,0,67,5475,3000,3000,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 5 - Create Timed Event'),
(5475,0,7,8,59,0,100,0,5475,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - On Timed Event Triggered - Say Line 1'),
(5475,0,8,0,61,0,100,0,0,0,0,0,0,41,3000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 7 - Despawn after 3 sec'),
(5475,0,9,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Between 0-30% Health - Say Line 0'),
(5475,0,10,11,62,0,100,0,11093,0,0,0,0,33,38848,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Dunemaul Warlock - On Gossip Select - Quest Credit'),
(5475,0,11,12,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 10 - Close Gossip'),
(5475,0,12,13,61,0,100,0,0,0,0,0,0,83,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 11 - Remove NpcFlag 1'),
(5475,0,13,14,61,0,100,0,0,0,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 12 - Set Orientation'),
(5475,0,14,15,61,0,100,0,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 13 - Say Line Random'),
(5475,0,15,0,61,0,100,0,0,0,0,0,0,41,5000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - Linked To Id 14 - Despawn after 5 sec'),
(5475,0,16,0,0,0,100,0,0,0,3400,4700,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dunemaul Warlock - In Combat - Cast ''Shadow Bolt'''),
(5475,0,17,0,4,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dunemaul Warlock - On Aggro - Say Line 0 (No Repeat)'),
(5475,0,18,0,0,0,100,0,5000,9000,15000,17800,0,11,6909,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dunemaul Warlock - In Combat - Cast ''Curse of Thorns''');

-- Sandfury Hideskinner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5645 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5645;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5645,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Sandfury Hideskinner - Between 0-15% Health - Flee For Assist (No Repeat)'),
(5645,0,1,0,0,0,100,0,2000,4500,15000,18000,0,11,81705,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sandfury Hideskinner - In Combat - Cast ''Scalp Slash''');

-- Sandfury Axe Thrower (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5646 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5646;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5646,0,0,0,0,0,100,0,0,0,2300,3900,0,11,10277,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sandfury Axe Thrower - In Combat - Cast ''Throw'''),
(5646,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Sandfury Axe Thrower - Between 0-15% Health - Flee For Assist (No Repeat)'),
(5646,0,2,0,2,0,100,1,0,30,0,0,0,11,81173,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sandfury Axe Thrower - Between 0-30% Health - Cast ''Frenzy'' (No Repeat)'),
(5646,0,3,0,2,0,100,1,0,30,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sandfury Axe Thrower - Between 0-30% Health - Say Line 1 (No Repeat)');

-- Captain Flat Tusk (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5824 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5824;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5824,0,0,0,11,0,100,1,0,0,0,0,0,11,7165,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Flat Tusk - On Respawn - Cast ''Battle Stance'' (No Repeat)'),
(5824,0,1,0,11,0,100,1,0,0,0,0,0,11,5280,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Flat Tusk - On Respawn - Cast ''Razor Mane'' (No Repeat)'),
(5824,0,2,0,9,0,100,0,0,5,7000,12000,0,11,77558,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Captain Flat Tusk - Within 0-5 Range - Cast ''Bloody Strike'''),
(5824,0,3,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Captain Flat Tusk - Between 0-15% Health - Flee For Assist (No Repeat)'),
(5824,0,4,0,4,0,100,1,0,0,0,0,0,11,79733,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captain Flat Tusk - On Aggro - Cast ''Commanding Shout'' (No Repeat)');

-- Dark Iron Geologist (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5839 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5839;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5839,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dark Iron Geologist - Between 0-15% Health - Flee For Assist (No Repeat)'),
(5839,0,1,0,0,0,100,0,2000,4500,9000,12000,0,11,9053,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dark Iron Geologist - In Combat - Cast ''Fireball'''),
(5839,0,2,0,9,0,100,0,5,30,13000,14500,0,11,8858,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dark Iron Geologist - Within 5-30 Range - Cast ''Bomb''');

-- Razor Hill Grunt (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5953 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5953;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5953,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razor Hill Grunt - In Combat - Cast ''Shoot'''),
(5953,0,1,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razor Hill Grunt - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(5953,0,2,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razor Hill Grunt - Between 0-30% Health - Say Line 0 (No Repeat)'),
(5953,0,3,0,9,0,100,0,0,5,14000,19000,0,11,40505,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razor Hill Grunt - Within 0-5 Range - Cast ''Cleave''');

-- Dreadmaul Ogre Mage (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5975 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5975;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5975,0,0,0,0,0,100,0,0,0,3400,4700,0,11,79858,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Ogre Mage - In Combat - Cast ''Frostbolt'''),
(5975,0,1,0,9,0,100,0,0,8,13600,14500,0,11,79850,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dreadmaul Ogre Mage - Within 0-8 Range - Cast ''Frost Nova'''),
(5975,0,2,0,0,0,100,0,8000,9000,15000,16000,0,11,79859,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Ogre Mage - In Combat - Cast ''Ice Lance'''),
(5975,0,3,0,0,0,100,0,9000,14000,25000,28000,0,11,84333,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Ogre Mage - In Combat - Cast ''Summon Dreadmaul'''),
(5975,0,4,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dreadmaul Ogre Mage - On Aggro - Say Line 0 (No Repeat)');

-- Dreadmaul Mauler (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5977 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5977;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5977,0,0,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dreadmaul Mauler - On Aggro - Say Line 0 (No Repeat)'),
(5977,0,1,0,0,0,100,0,6000,9000,20000,22000,0,11,81140,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dreadmaul Mauler - In Combat - Cast ''Thunderclap'''),
(5977,0,2,0,0,0,100,0,2000,5000,35000,41000,0,11,11960,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Mauler - In Combat - Cast ''Curse of the Dreadmaul'''),
(5977,0,3,0,0,0,100,0,9000,14000,25000,28000,0,11,84333,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Mauler - In Combat - Cast ''Summon Dreadmaul'''),
(5977,0,4,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dreadmaul Mauler - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(5977,0,5,0,2,0,100,1,0,30,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dreadmaul Mauler - Between 0-30% Health - Say Line 1 (No Repeat)'),
(5977,0,6,0,9,0,100,0,0,5,17000,18000,0,11,80182,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Mauler - Within 0-5 Range - Cast ''Uppercut''');

-- Dreadmaul Warlock (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5978 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5978;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5978,0,0,0,0,0,100,0,0,0,3400,4700,0,11,79938,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Warlock - In Combat - Cast ''Incinerate'''),
(5978,0,1,0,1,0,100,0,500,1000,600000,600000,0,11,44977,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dreadmaul Warlock - Out of Combat - Cast ''Fel Armor'''),
(5978,0,2,0,0,0,100,0,8000,9000,17000,17500,0,11,79937,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Warlock - In Combat - Cast ''Immolate'''),
(5978,0,3,0,0,0,100,0,9000,14000,25000,28000,0,11,84333,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadmaul Warlock - In Combat - Cast ''Summon Dreadmaul'''),
(5978,0,4,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dreadmaul Warlock - On Aggro - Say Line 0 (No Repeat)');

-- Nethergarde Miner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=5996 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=5996;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5996,0,0,0,0,0,100,0,0,0,2300,3900,0,11,38557,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nethergarde Miner - In Combat - Cast ''Throw'''),
(5996,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Nethergarde Miner - Between 0-15% Health - Flee For Assist (No Repeat)'),
(5996,0,2,0,0,0,100,0,6000,9000,21000,26000,0,11,80382,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nethergarde Miner - In Combat - Cast ''Dirt Toss'''),
(5996,0,3,0,9,0,100,0,0,5,12000,13000,0,11,6016,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nethergarde Miner - Within 0-5 Range - Cast ''Pierce Armor''');

-- Searing Infernal (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=6073 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=6073;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(6073,0,0,0,1,0,100,0,1000,1000,600000,600000,0,11,18968,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Searing Infernal - Out of Combat - Cast ''Fire Shield'''),
(6073,0,1,0,0,0,100,0,6000,8000,18000,22000,0,11,36247,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Searing Infernal - In Combat - Cast ''Fel Fireball'''),
(6073,0,2,0,0,0,100,0,2000,3000,15000,15000,0,11,32749,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Searing Infernal - In Combat - Cast ''Fire Shield''');

-- Roaming Felguard (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=6115 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=6115;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(6115,0,0,0,0,0,100,0,2000,3000,12000,19000,0,11,22859,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Roaming Felguard - In Combat - Cast ''Mortal Cleave'''),
(6115,0,1,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Roaming Felguard - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(6115,0,2,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Roaming Felguard - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Dark Iron Spy (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=6123 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=6123;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(6123,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Dark Iron Spy - Between 0-15% Health - Flee For Assist (No Repeat)'),
(6123,0,1,0,0,0,100,0,3000,4500,11500,17500,0,11,14873,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dark Iron Spy - In Combat - Cast ''Sinister Strike'''),
(6123,0,2,0,0,0,100,0,8000,11000,27000,32000,0,11,3583,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dark Iron Spy - In Combat - Cast ''Deadly Poison''');

-- Leprous Technician (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=6222 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=6222;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(6222,0,0,0,4,0,100,0,0,0,0,0,0,11,12024,64,0,0,0,0,7,0,0,0,0,0,0,0,0,'Leprous Technician - On Aggro CMC - Cast ''Net'''),
(6222,0,1,0,0,0,100,0,2000,6000,8000,9000,0,11,1604,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Leprous Technician - In Combat - Cast ''Dazed'''),
(6222,0,2,0,0,0,100,0,2000,5000,6000,8000,0,11,13398,64,0,0,0,0,21,30,0,0,0,0,0,0,0,'Leprous Technician - In Combat CMC - Cast ''Throw Wrench'''),
(6222,0,3,0,1,0,100,0,10000,45000,30000,70000,0,11,10348,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Leprous Technician - Out of Combat - Cast ''Tune Up'''),
(6222,0,4,0,8,0,100,0,9798,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Leprous Technician - On Spellhit ''Radiation'' - Say Line 0'),
(6222,0,5,0,4,0,20,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Leprous Technician - On Aggro - Say Line 1');

-- Peacekeeper Security Suit (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=6230 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=6230;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(6230,0,0,0,0,0,100,0,5000,6000,6000,8000,0,11,6533,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Peacekeeper Security Suit - In Combat CMC - Cast ''Net'''),
(6230,0,1,0,0,0,50,0,5000,6000,14000,16000,0,11,10730,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Peacekeeper Security Suit - In Combat - Cast ''Pacify''');

-- Electrocutioner 6000 (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=6235 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=6235;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(6235,0,0,0,0,0,80,2,25000,25000,5000,5000,0,11,11082,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Electrocutioner 6000 - In Combat - Cast ''Megavolt'''),
(6235,0,1,0,0,0,80,2,15000,15000,8000,8000,0,11,15605,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Electrocutioner 6000 - In Combat - Cast ''Shock'''),
(6235,0,2,0,0,0,80,2,31000,31000,11000,11000,0,11,11085,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Electrocutioner 6000 - In Combat - Cast ''Chain Bolt'''),
(6235,0,3,0,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Electrocutioner 6000 - On Aggro - Say Line 0');

-- Jaedenar Warlock (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7120 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7120;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7120,0,0,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Jaedenar Warlock - Between 0-15% Health - Flee For Assist (No Repeat)'),
(7120,0,1,0,0,0,100,0,0,0,3400,4700,0,11,20825,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Jaedenar Warlock - In Combat - Cast ''Shadow Bolt'''),
(7120,0,2,0,1,0,100,1,3000,5000,0,0,0,11,11939,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Jaedenar Warlock - Out of Combat - Cast ''Summon Imp'' (No Repeat)'),
(7120,0,3,0,2,0,100,1,0,30,0,0,0,11,8699,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Jaedenar Warlock - Between 0-30% Health - Cast ''Unholy Frenzy'' (No Repeat)');

-- Stonevault Ambusher (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7175 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7175;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7175,0,0,0,2,0,100,2,0,30,120000,120000,0,11,8599,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonevault Ambusher - Between 0-30% Health - Cast ''Enrage'' (Normal Dungeon)'),
(7175,0,1,0,2,0,100,3,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonevault Ambusher - Between 0-30% Health - Say Line 0 (Normal Dungeon)'),
(7175,0,2,0,2,0,100,3,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Stonevault Ambusher - Between 0-15% Health - Flee For Assist (Normal Dungeon)');

-- Ferocitas the Dream Eater (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7234 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7234;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7234,0,0,0,0,0,70,0,2000,2000,5000,5000,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ferocitas the Dream Eater - In Combat - Cast ''Thrash'''),
(7234,0,1,0,0,0,100,0,2000,4000,5000,7000,0,11,78921,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ferocitas the Dream Eater - IC - Cast Dream Lash');

-- Sandfury Guardian (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7268 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7268;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7268,0,0,0,0,0,85,2,2000,2000,6000,6000,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sandfury Guardian - In Combat - Cast ''Thrash'' (Phase 2) (No Repeat) (Normal Dungeon)');

-- Stonevault Mauler (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7320 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7320;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7320,0,0,0,25,0,100,0,0,0,0,0,0,11,3417,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonevault Mauler - On Reset - Cast Thrash'),
(7320,0,1,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonevault Mauler - Between 0-30% Health - Cast Frenzy'),
(7320,0,2,3,2,0,100,2,0,30,120000,120000,0,11,8269,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonevault Mauler - Between 0-30% Health - Cast ''Frenzy'' (Normal Dungeon)'),
(7320,0,3,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonevault Mauler - Between 0-30% Health - Say Line 0 (Normal Dungeon)');

-- Deadwind Ogre Mage (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7379 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7379;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7379,0,0,0,0,0,100,0,0,0,3400,4700,0,11,20824,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast bolt'),
(7379,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Deadwind Ogre Mage - Between 0-15% Health - Flee For Assist (No Repeat)'),
(7379,0,2,0,1,0,100,0,500,1000,600000,600000,0,11,12550,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Deadwind Ogre Mage - Ooc - Cast Lightning Shield'),
(7379,0,3,0,0,0,100,0,4700,8800,10500,13800,0,11,15039,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Deadwind Mauler - In Combat - Cast ''Flame Shock'''),
(7379,0,4,0,2,0,100,1,0,45,0,0,0,11,6742,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Deadwind Ogre Mage - Between 0-45% Health - Cast ''Bloodlust'' (No Repeat)'),
(7379,0,5,0,16,0,100,0,6742,30,20000,40000,0,11,6742,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Deadwind Ogre Mage - At 30% Health Less - Cast ''Bloodlust'' on Friendlies (Repeat)');

-- Murta Grimgut (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7608 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7608;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7608,0,0,0,0,0,100,0,1000,2000,3000,6000,0,11,9734,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murta Grimgut - In Combat - Cast Holy Smite'),
(7608,0,1,0,2,0,85,2,0,50,10000,12000,0,11,11642,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murta Grimgut - Between 0-50% Health - Cast ''Heal'' (No Repeat) (Normal Dungeon)');

-- Nekrum Gutchewer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7796 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7796;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7796,0,0,0,4,0,100,0,0,0,0,0,0,11,19471,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Nekrum Gutchewer - On Aggro - Cast Berserker Charge'),
(7796,0,1,0,0,0,100,0,0,20000,30000,60000,0,11,8600,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Nekrum Gutchewer - In Combat - Cast Fevered Plague'),
(7796,0,2,0,0,0,100,0,0,16000,12000,20000,0,11,26141,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nekrum Gutchewer - In Combat - Cast Hamstring');

-- Southsea Pirate (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7855 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7855;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7855,0,0,0,4,0,100,1,0,0,0,0,0,11,83622,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Southsea Pirate - On Aggro - Cast ''Leaping Cleave'' (No Repeat)'),
(7855,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Southsea Pirate - Between 0-15% Health - Flee For Assist (No Repeat)');

-- Deathguard Elite (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=7980 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=7980;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7980,0,0,0,0,0,100,0,5000,7000,7000,10000,0,11,14516,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Deathguard Elite - In Combat - Cast ''Strike'''),
(7980,0,1,0,9,0,100,0,0,5,12000,16000,0,11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Deathguard Elite - Within 0-5 Range - Cast ''Hamstring''');

-- Sul'lithuz Broodling (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8138 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8138;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8138,0,0,0,25,0,100,0,0,0,0,0,0,11,8876,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sul''lithuz Broodling - In Combat - Cast ''Thrash''');

-- Nijel's Point Guard (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8151 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8151;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8151,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nijel''s Point Guard - In Combat - Cast ''Shoot'''),
(8151,0,1,0,9,0,100,0,0,5,11000,17000,0,11,12170,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nijel''s Point Guard - Within 0-5 Range - Cast ''Revenge'''),
(8151,0,2,0,9,0,100,0,0,4,19000,22000,0,11,12169,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nijel''s Point Guard - Within 0-4 Range - Cast ''Shield Block''');

-- Mojo the Twisted (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8296 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8296;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8296,0,0,0,0,0,100,0,0,0,3400,4700,0,11,20298,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mojo the Twisted - In Combat - Cast ''Shadow Bolt'''),
(8296,0,1,0,1,0,100,0,500,1000,600000,600000,0,11,79954,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mojo the Twisted - Out of Combat - Cast ''Fel Armor'''),
(8296,0,2,0,2,0,100,1,0,30,0,0,0,11,31976,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mojo the Twisted - Between 0-30% Health - Cast ''Shadow Shield'' (No Repeat)');

-- Magronos the Unyielding (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8297 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8297;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8297,0,0,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Magronos the Unyielding - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(8297,0,1,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Magronos the Unyielding - Between 0-30% Health - Say Line 0 (No Repeat)'),
(8297,0,2,0,9,0,100,0,0,5,17000,18000,0,11,10966,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Magronos the Unyielding - Within 0-5 Range - Cast ''Uppercut'''),
(8297,0,3,0,0,0,100,0,6000,14000,19000,22500,0,11,22859,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Magronos the Unyielding - In Combat - Cast ''Mortal Cleave'''),
(8297,0,4,0,0,0,100,0,14000,18000,35000,36000,0,11,78827,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Magronos the Unyielding - In Combat - Cast ''Bladestorm''');

-- Akubar the Seer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8298 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8298;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8298,0,0,0,0,0,100,0,0,0,3400,4700,0,11,79884,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Akubar the Seer - In Combat - Cast ''Lightning Bolt'''),
(8298,0,1,0,1,0,100,0,500,1000,600000,600000,0,11,79892,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Akubar the Seer - Out of Combat - Cast ''Water Shield'''),
(8298,0,2,0,16,0,100,0,79892,1,15000,30000,0,11,79892,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Akubar the Seer - On Friendly Unit Missing Buff ''Water Shield'' - Cast ''Water Shield'''),
(8298,0,3,0,9,0,100,0,0,8,14000,14500,0,11,79890,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Akubar the Seer - Within 0-8 Range - Cast ''Flame Shock'''),
(8298,0,4,0,0,0,100,0,5000,7000,19000,22000,0,11,39591,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Akubar the Seer - In Combat - Cast ''Searing Totem'''),
(8298,0,5,0,0,0,100,0,12000,15000,25000,31000,0,11,79886,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Akubar the Seer - In Combat - Cast ''Lava Burst''');

-- Grunter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8303 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8303;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8303,0,0,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Grunter - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(8303,0,1,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Grunter - Between 0-30% Health - Say Line 0 (No Repeat)'),
(8303,0,2,0,0,0,100,0,3000,4000,12000,13000,0,11,3604,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Grunter - In Combat - Cast ''Tendon Rip'''),
(8303,0,3,0,0,0,100,0,2000,9000,9000,25000,0,11,79581,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Grunter - In Combat - Cast ''Angry Snort'''),
(8303,0,4,0,4,0,100,1,0,0,0,0,0,11,6268,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Grunter - On Aggro - Cast ''Rushing Charge'' (No Repeat)');

-- Vile Tutor (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8548 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8548;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8548,0,0,0,0,0,100,0,5000,8000,30000,35000,0,11,12040,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Shadow Shield'),
(8548,0,1,0,4,0,100,1,0,0,0,0,0,11,16587,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Dark Whispers on Aggro'),
(8548,0,2,0,16,0,100,0,16587,40,22000,25000,0,11,16587,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Cast Dark Whispers on Friendlies Missing Buff'),
(8548,0,3,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP');

-- Mosshoof Courser (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8761 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8761;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8761,0,0,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mosshoof Courser - Between 0-30% Health - Say Line 0 (Phase 1) (No Repeat) (Normal Dungeon)'),
(8761,0,1,2,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mosshoof Courser - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(8761,0,2,0,61,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mosshoof Courser - Between 0-30% Health - Say Line 0 (No Repeat)'),
(8761,0,3,0,4,0,100,1,0,0,0,0,0,11,22120,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Mosshoof Courser - On Aggro - Cast ''Charge'' (No Repeat)'),
(8761,0,4,0,0,0,100,0,4000,7000,15000,18000,0,11,31274,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mosshoof Courser - In Combat - Cast ''Knockdown''');

-- Anvilrage Footman (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8892 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8892;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8892,0,0,0,0,0,100,0,5000,8000,7000,10000,0,11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Anvilrage Footman - In Combat - Cast Strike'),
(8892,0,1,0,13,0,100,0,13000,15000,0,0,0,11,11978,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Anvilrage Footman - Target Casting - Cast Kick');

-- Shadowforge Peasant (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8896 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8896;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8896,0,0,0,4,0,100,3,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 on Aggro'),
(8896,0,1,0,4,1,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving on Aggro'),
(8896,0,2,0,9,1,100,2,40,100,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving when not in bolt Range'),
(8896,0,3,0,9,1,100,2,10,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving at 15 Yards'),
(8896,0,4,0,9,1,100,2,0,40,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving when in bolt Range'),
(8896,0,5,0,3,1,100,2,0,15,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 2 at 15% Mana'),
(8896,0,6,0,3,2,100,2,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving at 15% Mana'),
(8896,0,7,0,3,2,100,2,30,100,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 When Mana is above 30%'),
(8896,0,8,0,2,2,100,3,0,15,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 3 at 15% HP'),
(8896,0,9,0,2,3,100,3,0,15,0,0,0,25,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(8896,0,10,0,7,3,100,3,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Reset on Evade'),
(8896,0,11,0,2,3,100,3,0,15,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text at 15% HP'),
(8896,0,12,0,4,0,100,0,0,0,0,0,0,31,1,5,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shadowforge Peasant - On Aggro - Set Phase Random Between 1-5'),
(8896,0,13,0,0,1,100,0,7000,9000,12000,17000,0,11,6713,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Peasant - In Combat - Cast Disarm (Phase 1)'),
(8896,0,14,0,0,1,100,0,5000,7000,7000,10000,0,11,13446,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Peasant - In Combat - Cast Strike (Phase 1)'),
(8896,0,15,0,0,2,100,0,0,0,2000,4000,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Peasant - In Combat - Cast Shoot (Phase 2)'),
(8896,0,16,0,9,2,100,0,0,5,18000,21000,0,11,3604,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Peasant - Within 0-5 Range - Cast Tendon Rip (Phase 2)'),
(8896,0,17,0,0,4,100,0,0,0,2000,4000,0,11,7978,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Peasant - In Combat - Cast Throw Dynamite (Phase 3)'),
(8896,0,18,0,0,16,100,0,0,0,3000,5000,0,11,9053,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Citizen - In Combat - Cast Fireball (Phase 5)'),
(8896,0,19,0,2,1,100,3,0,30,0,0,0,11,11642,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Heal at 30% HP');

-- Shadowforge Senator (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8904 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8904;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8904,0,0,0,4,0,100,3,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 on Aggro'),
(8904,0,1,0,4,1,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving on Aggro'),
(8904,0,2,0,9,1,100,2,40,100,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving when not in bolt Range'),
(8904,0,3,0,9,1,100,2,10,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving at 15 Yards'),
(8904,0,4,0,9,1,100,2,0,40,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving when in bolt Range'),
(8904,0,5,0,3,1,100,2,0,15,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 2 at 15% Mana'),
(8904,0,6,0,3,2,100,2,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving at 15% Mana'),
(8904,0,7,0,3,2,100,2,30,100,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 When Mana is above 30%'),
(8904,0,8,0,2,2,100,3,0,15,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 3 at 15% HP'),
(8904,0,9,0,2,3,100,3,0,15,0,0,0,25,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(8904,0,10,0,7,3,100,3,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Reset on Evade'),
(8904,0,11,0,2,3,100,3,0,15,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text at 15% HP'),
(8904,0,12,0,4,0,100,0,0,0,0,0,0,31,1,5,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shadowforge Senator - On Aggro - Set Phase Random Between 1-5'),
(8904,0,13,0,0,1,100,0,0,0,3000,5000,0,11,14034,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Senator - In Combat - Cast Fireball (Phase 1)'),
(8904,0,14,0,16,1,100,0,2601,1,15000,19000,0,11,2601,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Shadowforge Senator - On Friendly Unit Missing Buff Fire Shield III - Cast Fire Shield III (Phase 1)'),
(8904,0,15,0,0,2,100,0,0,0,3000,5000,0,11,12471,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Senator - In Combat - Cast Shadow Bolt (Phase 2)'),
(8904,0,16,0,0,2,100,0,3000,6000,13000,19000,0,11,14868,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Shadowforge Senator - In Combat - Cast Curse of Agony (Phase 2)'),
(8904,0,17,0,9,4,100,0,0,10,15000,18000,0,11,11831,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shadowforge Senator - In Combat - Cast Frost Nova (Phase 3)'),
(8904,0,18,0,0,8,100,0,3000,8000,14000,25000,0,11,11436,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Shadowforge Senator - In Combat - Cast Slow (Phase 4)'),
(8904,0,19,0,0,16,100,0,1000,2000,3000,5000,0,11,15498,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowforge Senator - In Combat - Cast Holy Smite (Phase 5)');

-- Molten War Golem (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8908 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8908;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8908,0,0,0,25,0,100,0,0,0,0,0,0,11,15506,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Molten War Golem - On Reset - Cast Immolate');

-- Twilight Emissary (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8913 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8913;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8913,0,0,0,4,0,100,3,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 on Aggro'),
(8913,0,1,0,4,1,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving on Aggro'),
(8913,0,2,0,9,1,100,2,40,100,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving when not in bolt Range'),
(8913,0,3,0,9,1,100,2,10,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving at 15 Yards'),
(8913,0,4,0,9,1,100,2,0,40,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving when in bolt Range'),
(8913,0,5,0,3,1,100,2,0,15,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 2 at 15% Mana'),
(8913,0,6,0,3,2,100,2,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Start Moving at 15% Mana'),
(8913,0,7,0,3,2,100,2,30,100,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 1 When Mana is above 30%'),
(8913,0,8,0,2,2,100,3,0,15,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Set Phase 3 at 15% HP'),
(8913,0,9,0,2,3,100,3,0,15,0,0,0,25,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(8913,0,10,0,7,3,100,3,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Reset on Evade'),
(8913,0,11,0,2,3,100,3,0,15,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text at 15% HP'),
(8913,0,12,0,4,0,100,0,0,0,0,0,0,31,1,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Emissary - On Aggro - Set Phase Random Between 1-3'),
(8913,0,13,0,16,1,100,0,15288,1,8000,11000,0,11,15288,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Twilight Emissary - On Friendly Unit Missing Buff Fury of Ragnaros - Cast Fury of Ragnaros (Phase 1)'),
(8913,0,14,0,0,1,100,0,0,0,3000,5000,0,11,12466,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Emissary - In Combat - Cast Fireball (Phase 1)'),
(8913,0,15,0,0,2,100,0,0,0,3000,5000,0,11,15043,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Emissary - In Combat - Cast Frostbolt (Phase 2)'),
(8913,0,16,0,0,2,100,0,15000,25000,20000,25000,0,11,8364,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilight Emissary - In Combat - Cast Blizzard (Phase 2)'),
(8913,0,17,0,9,2,100,0,0,8,20000,22000,0,11,15063,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Emissary - Within 0-8 Range - Cast Frost Nova (Phase 2)'),
(8913,0,18,0,16,2,100,0,12544,1,1000,1000,0,11,12544,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Emissary - On Friendly Unit Missing Buff Frost Armor - Cast Frost Armor (Phase 2)'),
(8913,0,19,0,0,4,100,0,0,0,2000,4000,0,11,13748,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Emissary - In Combat - Cast Arcane Bolt (Phase 3)'),
(8913,0,20,0,9,5,100,0,0,8,16000,20000,0,11,13745,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Emissary - Within 0-8 Range - Cast Arcane Explosion (Phase 3)');

-- Twilight's Hammer Ambassador (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8915 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8915;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8915,0,0,0,1,0,100,2,500,1000,600000,600000,0,11,12544,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Frost Armor on Spawn'),
(8915,0,1,0,4,0,100,0,0,0,0,0,0,31,1,4,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilights Hammer Ambassador - On Aggro - Set Phase Random Between 1-4'),
(8915,0,2,0,0,1,100,0,6000,10000,7000,14000,0,11,12248,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilights Hammer Ambassador - In Combat - Cast Amplify Damage (Phase 1)'),
(8915,0,3,0,0,1,100,0,2000,4000,12000,16000,0,11,11980,32,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilights Hammer Ambassador - In Combat - Cast Curse of Weakness (Phase 1)'),
(8915,0,4,0,0,2,100,0,3000,5000,7000,9000,0,11,15499,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilights Hammer Ambassador - In Combat - Cast Frost Shock (Phase 2)'),
(8915,0,5,0,0,4,100,0,3000,5000,7000,9000,0,11,15096,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilights Hammer Ambassador - In Combat - Cast Flame Shock (Phase 3)'),
(8915,0,6,0,0,8,100,0,3000,5000,7000,9000,0,11,15500,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilights Hammer Ambassador - In Combat - Cast Shock (Phase 4)'),
(8915,0,7,0,0,0,100,2,4000,5000,12000,13000,0,11,15501,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Earth Shock'),
(8915,0,8,0,2,0,100,3,0,50,0,0,0,11,6742,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Bloodlust at 50% HP');

-- Cave Creeper (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8933 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8933;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8933,0,0,0,54,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,21,100,0,0,0,0,0,0,0,'@DredgeWorm - Just summoned - Start Attack'),
(8933,0,1,0,0,0,100,0,2000,2000,20000,20000,0,11,14532,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Cave Creeper - In Combat - Cast Creeper Venom'),
(8933,0,2,0,0,0,100,0,4000,4000,8000,8000,0,11,745,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cave Creeper - In Combat - Cast Web'),
(8933,0,3,0,0,0,100,0,5000,6000,4000,8000,0,11,15656,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Cave Creeper - In Combat - Cast Poisonous Stab');

-- Angerclaw Bear (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=8956 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=8956;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8956,0,0,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Angerclaw Bear - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(8956,0,1,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Angerclaw Bear - Between 0-30% Health - Say Line 0 (No Repeat)'),
(8956,0,2,0,9,0,100,0,0,5,22000,25000,0,11,84867,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Angerclaw Bear - Within 0-5 Range - Cast ''Sundering Swipe''');

-- Eviscerator (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=9029 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=9029;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9029,0,0,0,54,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,21,100,0,0,0,0,0,0,0,'@DredgeWorm - Just summoned - Start Attack'),
(9029,0,1,0,0,0,100,0,2000,3000,14000,15000,0,11,14331,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Eviscerator - In Combat - Cast Vicious Rend'),
(9029,0,2,0,0,0,100,0,4000,5000,4000,5000,0,11,15245,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Eviscerator - In Combat - Cast Shadow Bolt Volley'),
(9029,0,4,0,0,0,100,2,7000,12000,18000,24000,0,11,7121,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Anti-Magic Shield');

-- Rage Talon Dragonspawn (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=9096 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=9096;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9096,0,0,0,0,0,100,2,4000,13200,6600,14400,0,11,15580,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Rage Talon Dragonspawn - In Combat - Cast ''Strike'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(9096,0,1,0,0,0,100,2,7700,17100,20300,34200,0,11,12021,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Rage Talon Dragonspawn - In Combat - Cast ''Fixate'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(9096,0,2,0,0,0,100,2,1400,12300,7100,11700,0,11,15572,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Rage Talon Dragonspawn - In Combat - Cast ''Sunder Armor'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(9096,0,3,0,25,0,100,0,0,0,0,0,0,11,8876,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Rage Talon Dragonspawn - In Combat - Cast ''Thrash'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(9096,0,4,0,2,0,100,2,0,30,120000,120000,0,11,8269,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Rage Talon Dragonspawn - Between 0-30% Health - Cast ''Frenzy'' (Normal Dungeon)');

-- Diemetradon (merge)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=9163 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=9163;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9163,0,0,0,0,0,100,0,5000,8000,32000,44000,0,11,83367,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Diemetradon Howl'),
(9163,0,1,2,8,0,100,1,71775,0,0,0,0,33,38355,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Get Credit'),
(9163,0,2,0,61,0,100,0,0,0,0,0,0,41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Disapear'),
(9163,0,3,0,0,0,100,0,8000,8000,15000,15000,0,11,13692,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Diemetradon - In Combat - Cast ''Dire Growl'' (Normal Dungeon)');

-- Gorlop (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=9176 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=9176;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9176,0,0,0,0,0,100,0,10100,12000,18900,23400,0,11,12734,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gor''tesh - In Combat - Cast ''Ground Smash'' (Normal Dungeon)'),
(9176,0,1,0,0,0,100,0,17300,20800,38600,44300,0,11,10101,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gor''tesh - In Combat - Cast ''Knock Away'' (Normal Dungeon)'),
(9176,0,2,0,0,0,100,0,4800,18800,7300,12100,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gor''tesh - In Combat - Cast ''Thrash'' (Normal Dungeon)');

-- Smolderthorn Axe Thrower (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=9267 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=9267;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9267,0,0,0,0,0,100,2,0,0,2300,3900,0,11,15795,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Smolderthorn Axe Thrower - In Combat CMC - Cast ''Throw'' (Normal Dungeon)'),
(9267,0,1,0,0,0,100,2,6000,9000,9000,12000,0,11,12787,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Smolderthorn Axe Thrower - In Combat - Cast ''Thrash'' (Normal Dungeon)'),
(9267,0,2,0,0,0,100,2,9000,14000,11000,15000,0,11,11428,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Smolderthorn Axe Thrower - In Combat - Cast ''Knockdown'' (Normal Dungeon)'),
(9267,0,3,0,2,0,100,3,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Smolderthorn Axe Thrower - Between 0-15% Health - Flee For Assist (No Repeat) (Normal Dungeon)');

-- Scarlet Praetorian (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=9448 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=9448;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9448,0,0,0,9,0,100,0,0,5,14000,17000,0,11,17143,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Holy Strike on Close'),
(9448,0,1,0,0,0,100,0,5000,7000,12000,19000,0,11,79964,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Exorcism');

-- Blackhand Dreadweaver (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=9817 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=9817;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9817,0,1,0,4,0,100,2,0,0,0,0,0,39,10,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - On Aggro - Call For Help (Normal Dungeon)'),
(9817,0,4,0,2,0,100,3,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - Between 0-15% Health - Flee For Assist (Normal Dungeon)'),
(9817,0,5,6,1,0,100,2,0,8000,12000,14000,0,92,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - Out of Combat - Interrupt Spell (Normal Dungeon)'),
(9817,0,6,0,61,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - Out of Combat - Set Event Phase 1 (Normal Dungeon)'),
(9817,0,7,0,1,1,100,2,0,0,0,0,0,5,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - Out of Combat - Play Emote 1 (Normal Dungeon)'),
(9817,0,8,0,25,0,100,0,0,0,0,0,0,11,12380,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - On Reset - Cast ''Shadow Channeling'' (Normal Dungeon)'),
(9817,0,9,0,0,0,100,2,0,0,3600,6300,0,11,12739,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - In Combat - Cast ''Shadow Bolt'' (Normal Dungeon)'),
(9817,0,10,0,0,0,100,2,9400,21400,22000,28800,0,11,7068,3,0,0,0,0,2,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - In Combat - Cast ''Veil of Shadow'' (Normal Dungeon)'),
(9817,0,11,12,1,1,100,2,4000,4000,4000,4000,0,11,12380,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - Out of Combat - Cast ''Shadow Channeling'' (Phase 1) (Normal Dungeon)'),
(9817,0,12,0,61,1,100,0,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - Out of Combat - Set Event Phase 0 (Phase 1) (Normal Dungeon)'),
(9817,0,13,0,0,0,100,0,2000,4000,12000,24000,0,11,6909,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Blackhand Dreadweaver - In Combat - Cast Curse of Thorns (timer not verified)');

-- Crystal Fang (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10376 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10376;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10376,0,0,0,6,0,100,2,0,0,0,0,0,11,16103,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crystal Fang - On Death - Cast Spell Summon Spire Spiderling (16103)');

-- Mangled Cadaver (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10382 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10382;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10382,0,0,0,25,0,100,0,0,0,0,0,0,11,16142,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mangled Cadaver - On Reset - Cast Cadaver Worms');

-- Skeletal Guardian (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10390 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10390;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10390,0,0,0,1,0,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - Out of Combat - Disable Combat Movement'),
(10390,0,5,6,3,0,100,0,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - Between 0-15% Mana - Enable Combat Movement'),
(10390,0,6,0,61,0,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - Between 0-15% Mana - Increment Phase By 1'),
(10390,0,7,0,9,0,100,3,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - Within 35-80 Range - Enable Combat Movement'),
(10390,0,8,0,9,0,100,3,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - Within 5-15 Range - Disable Combat Movement'),
(10390,0,9,0,9,0,100,3,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - Within 0-5 Range - Enable Combat Movement'),
(10390,0,10,0,3,0,100,2,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - Between 30-100% Mana - Decrement Phase By 1'),
(10390,0,11,0,60,0,100,65537,0,0,0,0,0,31,1,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - On Update - Set Phase Random Between 1-3 (No Repeat)'),
(10390,0,12,0,1,1,100,0,1000,5000,600000,600000,0,11,13787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - Out of Combat - Cast ''Demon Armor'' (Phase 1)'),
(10390,0,13,0,0,1,100,0,0,1000,3000,4500,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Skeletal Guardian - In Combat - Cast ''Shadow Bolt'' (Phase 1)'),
(10390,0,14,0,0,2,100,0,5000,11000,17000,24500,0,11,8364,64,0,0,0,0,5,20,0,0,0,0,0,0,0,'Skeletal Guardian - In Combat - Cast ''Blizzard'' (Phase 2)'),
(10390,0,15,0,0,2,100,0,0,1000,3000,4500,0,11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Skeletal Guardian - In Combat - Cast ''Frostbolt'' (Phase 2)'),
(10390,0,16,0,0,4,100,0,4000,11000,13000,24500,0,11,11975,64,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skeletal Guardian - In Combat - Cast ''Arcane Explosion'' (Phase 3)'),
(10390,0,17,0,0,4,100,0,0,1000,2000,3500,0,11,37361,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Skeletal Guardian - In Combat - Cast ''Arcane Bolt'' (Phase 3)');

-- Fleshflayer Ghoul (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10407 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10407;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10407,0,0,0,0,0,75,2,5000,5000,6000,6000,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fleshflayer Ghoul - In Combat - Cast ''Thrash'' (No Repeat) (Normal Dungeon)'),
(10407,0,1,0,0,0,100,2,3000,3000,20000,20000,0,11,13738,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Fleshflayer Ghoul - In Combat - Cast ''Rend'' (No Repeat) (Normal Dungeon)'),
(10407,0,2,0,1,0,100,0,3000,5000,8000,12000,0,5,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fleshflayer Ghoul - Out of Combat - Play Emote 1');

-- Patchwork Horror (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10414 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10414;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10414,0,0,0,25,0,100,0,0,0,0,0,0,11,16345,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Patchwork Horror - On Reset - Cast Disease Cloud'),
(10414,0,1,0,0,0,100,0,5000,10000,12000,20000,0,11,10101,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Patchwork Horror - In Combat - Cast Knock Away'),
(10414,0,2,0,0,0,100,2,5000,5000,5000,5000,0,11,3391,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Patchwork Horror - In Combat - Cast ''Thrash'' (No Repeat) (Normal Dungeon)');

-- Bile Spewer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10416 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10416;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10416,0,0,0,6,0,100,3,0,0,0,0,0,34,5,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bile Spewer - On Just Died - Set Instance Data 5 to 1 (No Repeat) (Normal Dungeon)'),
(10416,0,1,0,0,0,100,0,7000,18000,30000,40000,0,11,16809,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bile Spewer - In Combat - Cast Spawn Bile Slime'),
(10416,0,2,0,6,0,100,0,0,0,0,0,0,11,16865,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bile Spewer - On Death - Cast Spawn Bile Slimes'),
(10416,0,3,0,0,0,85,2,3000,3000,5000,5000,0,11,3391,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bile Spewer - In Combat - Cast ''Thrash'' (No Repeat) (Normal Dungeon)');

-- Venom Belcher (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10417 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10417;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10417,0,0,0,6,0,100,3,0,0,0,0,0,34,5,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Venom Belcher - On Just Died - Set Instance Data 5 to 1 (No Repeat) (Normal Dungeon)'),
(10417,0,1,0,25,0,100,0,0,0,0,0,0,11,8601,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Venom Belcher - On Reset - Cast Slowing Poison'),
(10417,0,2,0,0,0,100,0,3000,11000,12000,19500,0,11,16866,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Venom Belcher - In Combat - Cast Venom Pit');

-- Risen Sorcerer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10422 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10422;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10422,0,0,0,0,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Sorcerer - In Combat - Disable Combat Movement'),
(10422,0,6,7,3,1,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Sorcerer - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat)'),
(10422,0,7,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Sorcerer - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat)'),
(10422,0,8,0,9,1,100,1,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Sorcerer - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(10422,0,9,0,9,1,100,1,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Sorcerer - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat)'),
(10422,0,10,0,9,1,100,1,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Sorcerer - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(10422,0,11,0,3,0,100,0,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Sorcerer - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat)'),
(10422,0,12,0,60,0,100,65537,0,0,0,0,0,31,1,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crimson Sorcerer - On Update - Set Event Phase'),
(10422,0,13,0,1,1,100,0,1000,5000,600000,600000,0,11,17150,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crimson Sorcerer - Out of Combat - Cast Arcane Might'),
(10422,0,14,0,0,1,100,0,0,1000,3000,4500,0,11,15230,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Crimson Sorcerer - In Combat - Cast Arcane Bolt'),
(10422,0,15,0,0,1,100,0,4000,11000,15000,24500,0,11,13323,0,0,0,0,0,6,20,0,0,0,0,0,0,0,'Crimson Sorcerer - In Combat - Cast Polymorph'),
(10422,0,16,0,1,2,100,0,0,5000,600000,600000,0,11,12544,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crimson Sorcerer - Out of Combat - Cast Frost Armor'),
(10422,0,17,0,0,2,100,0,0,1000,3000,4500,0,11,9672,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Crimson Sorcerer - In Combat - Cast Frost Bolt'),
(10422,0,18,0,0,0,100,2,5000,6000,8500,10000,0,11,14145,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Crimson Sorcerer - In Combat - Cast ''Fire Blast'' (Phase 1) (No Repeat)');

-- Hearthsinger Forresten (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10558 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10558;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10558,0,0,0,0,0,100,2,5,30,2300,3900,0,11,16100,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Hearthsinger Forresten - In Combat CMC - Cast ''Shoot'' (Normal Dungeon)'),
(10558,0,1,0,0,0,100,2,3000,5000,12000,19000,0,11,16244,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hearthsinger Forresten - In Combat - Cast ''Demoralizing Shout'' (Normal Dungeon)'),
(10558,0,2,0,0,0,100,2,7000,9000,20000,25000,0,11,16798,1,0,0,0,0,6,0,0,0,0,0,0,0,0,'Hearthsinger Forresten - In Combat - Cast ''Enchanting Lullaby'' (Normal Dungeon)'),
(10558,0,3,0,2,0,100,3,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Hearthsinger Forresten - Between 0-15% Health - Flee For Assist (No Repeat) (Normal Dungeon)'),
(10558,0,13,14,0,0,100,2,9000,14000,9000,14000,0,11,14443,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Hearthsinger Forresten - In Combat - Cast ''Multi-Shot'' (Normal Dungeon)'),
(10558,0,14,0,61,0,100,0,0,0,0,0,0,40,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hearthsinger Forresten - In Combat - Set Sheath Ranged (Normal Dungeon)');

-- Rorgish Jowl (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10639 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10639;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10639,0,0,0,11,0,100,1,0,0,0,0,0,11,6813,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Rorgish Jowl - On Respawn - Cast ''Coat of Thistlefur'' (No Repeat)'),
(10639,0,1,0,0,0,100,0,4000,6000,19000,27000,0,11,8078,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Rorgish Jowl - In Combat - Cast ''Thunderclap'''),
(10639,0,2,0,2,0,100,1,0,30,0,0,0,11,3490,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Rorgish Jowl - Between 0-30% Health - Cast ''Frenzied Rage'' (No Repeat)'),
(10639,0,3,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Rorgish Jowl - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Raider Jhash (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10676 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10676;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10676,0,0,1,62,0,100,0,11189,0,0,0,0,85,73678,16,0,0,0,0,7,0,0,0,0,0,0,0,0,'Raider Jhash - On Gossip Select - Invoker Cast Summon Durotar Riding Wolf'),
(10676,0,1,2,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Raider Jhash - Linked To Id 0 - Close Gossip'),
(10676,0,2,0,61,0,100,0,0,0,0,0,0,86,46598,0,7,0,0,0,19,39239,5,0,0,0,0,0,0,'Raider Jhash - Linked To Id 1 - Cross Cast Ride Vehicle Hardcoded'),
(10676,0,3,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Raider Jhash - Between 0-15% Health - Flee For Assist (No Repeat)'),
(10676,0,4,0,9,0,100,0,0,20,7000,9000,0,11,6533,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Raider Jhash - Within 0-20 Range - Cast ''Net''');

-- Blackhand Dragon Handler (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10742 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10742;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10742,0,0,0,0,0,100,0,10000,20000,15000,30000,0,11,16637,0,0,0,0,0,26,0,0,0,0,0,0,0,0,'Blackhand Dragon Handler - In Combat - Cast ''Mend Dragon'' (timers not verified)');

-- Deathspeaker Selendre (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=10827 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=10827;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(10827,0,0,0,0,0,100,0,0,0,3400,4700,0,11,12471,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadow Bolt'),
(10827,0,1,0,0,0,100,0,5000,8000,22000,25000,0,11,13338,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Curse of Tongues'),
(10827,0,2,0,2,0,100,0,0,40,22000,25000,0,11,17173,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Drain Life at 40% HP');

-- Risen Monk (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11043 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11043;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11043,0,0,0,25,0,100,65537,0,0,0,0,0,11,674,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crimson Monk - On Reset - Cast Dual Wield'),
(11043,0,1,0,25,0,100,0,0,0,0,0,0,11,8876,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crimson Monk - On Reset - Cast Thrash'),
(11043,0,2,0,13,0,100,0,8000,13000,0,0,0,11,11978,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Crimson Monk - Victim Casting - Cast Kick');

-- Gordok Warlock (merge)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11448 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11448;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11448,0,0,0,1,0,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Out of Combat - Disable Combat Movement (No Repeat) (Normal Dungeon)'),
(11448,0,1,0,1,0,100,2,1000,1000,1800000,1800000,0,11,13787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Out of Combat - Cast ''Demon Armor'' (No Repeat) (Normal Dungeon)'),
(11448,0,2,0,1,0,100,3,3000,3000,0,0,0,11,22865,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Out of Combat - Cast ''Summon Doomguard'' (No Repeat) (Normal Dungeon)'),
(11448,0,3,4,4,0,10,3,0,0,0,0,0,1,0,0,1,0,0,0,7,0,0,0,0,0,0,0,0,'Gordok Warlock - On Aggro - Say Line 0 (No Repeat) (Normal Dungeon)'),
(11448,0,4,5,61,0,100,0,0,0,0,0,0,11,15232,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gordok Warlock - On Aggro - Cast ''Shadow Bolt'' (No Repeat) (Normal Dungeon)'),
(11448,0,5,0,61,0,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - On Aggro - Increment Phase By 1 (No Repeat) (Normal Dungeon)'),
(11448,0,7,8,3,2,100,3,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Between 0-15% Mana - Enable Combat Movement (Phase 2) (No Repeat) (Normal Dungeon)'),
(11448,0,8,0,61,2,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Between 0-15% Mana - Increment Phase By 1 (Phase 2) (No Repeat) (Normal Dungeon)'),
(11448,0,9,0,9,2,100,3,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Within 35-80 Range - Enable Combat Movement (Phase 2) (No Repeat) (Normal Dungeon)'),
(11448,0,10,0,9,2,100,3,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Within 5-15 Range - Disable Combat Movement (Phase 2) (No Repeat) (Normal Dungeon)'),
(11448,0,11,0,9,2,100,3,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Within 0-5 Range - Enable Combat Movement (Phase 2) (No Repeat) (Normal Dungeon)'),
(11448,0,12,0,3,0,100,2,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Between 30-100% Mana - Decrement Phase By 1 (Phase 2) (No Repeat) (Normal Dungeon)'),
(11448,0,14,0,0,0,100,2,5000,9000,20000,25000,0,11,13338,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Gordok Warlock - In Combat - Cast ''Curse of Tongues'' (Phase 2) (No Repeat) (Normal Dungeon)'),
(11448,0,15,0,0,0,100,2,7000,15000,20000,26000,0,11,8994,1,0,0,0,0,6,0,0,0,0,0,0,0,0,'Gordok Warlock - In Combat - Cast ''Banish'' (Phase 2) (No Repeat) (Normal Dungeon)'),
(11448,0,16,0,1,0,100,1,10000,10000,0,0,0,11,21157,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gordok Warlock - Out of Combat - Cast Dark Channeling'),
(11448,0,17,0,0,0,100,0,2000,11000,19000,25000,0,11,12742,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Gordok Warlock - In Combat - Cast Immolate');

-- Wildspawn Felsworn (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11455 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11455;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11455,0,0,0,1,0,100,1,1000,1000,1800000,1800000,0,11,12542,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - Out of Combat - Cast ''Fear'''),
(11455,0,1,0,4,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - On Aggro - Disable Combat Movement'),
(11455,0,5,6,3,1,100,0,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - Between 0-15% Mana - Enable Combat Movement (Phase 1)'),
(11455,0,6,0,61,1,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - On Evade - Set Event Phase 1'),
(11455,0,7,0,9,1,100,0,35,80,0,0,0,21,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - Within 35-80 Range - Enable Combat Movement'),
(11455,0,8,0,9,1,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - Within 5-15 Range - Disable Combat Movement'),
(11455,0,9,0,9,1,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - Within 0-5 Range - Enable Combat Movement'),
(11455,0,10,0,3,2,100,0,0,30,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - Between 0-30% Mana - Set Event Phase 1'),
(11455,0,11,0,0,2,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - In Combat - Set Event Phase 1'),
(11455,0,15,0,7,0,100,0,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - On Evade - Set Event Phase 0'),
(11455,0,16,0,0,0,100,0,0,2000,3000,4000,0,11,12471,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - In Combat - Cast Shadow Bolt'),
(11455,0,17,0,0,0,100,0,3000,7000,8000,14000,0,11,15654,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Wildspawn Felsworn - In Combat - Cast Shadow Word: Pain'),
(11455,0,18,0,0,0,100,0,8000,9000,18000,24000,0,11,22417,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - In Combat - Cast Shadow Shield'),
(11455,0,19,0,0,0,100,0,0,2000,120000,120000,0,11,22418,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Felsworn - In Combat - Cast Chaotic Focus');

-- Wildspawn Shadowstalker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11456 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11456;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11456,0,0,0,25,0,100,0,0,0,0,0,0,11,22766,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Shadowstalker - On Reset - Cast Sneak'),
(11456,0,1,0,25,0,100,0,0,0,0,0,0,11,8601,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Shadowstalker - On Reset - Cast Slowing Poison'),
(11456,0,2,0,67,0,100,0,6000,8000,0,0,0,11,15582,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wildspawn Shadowstalker - Behind Target - Cast Backstab');

-- Wildspawn Hellcaller (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11457 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11457;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11457,0,0,0,4,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - On Aggro - Disable Combat Movement'),
(11457,0,4,5,3,1,100,0,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - Between 0-15% Mana - Enable Combat Movement (Phase 1)'),
(11457,0,5,0,61,1,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - On Aggro - Set Event Phase 1'),
(11457,0,6,0,9,1,100,0,35,80,0,0,0,21,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - Within 35-80 Range - Enable Combat Movement'),
(11457,0,7,0,9,1,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - Within 5-15 Range - Disable Combat Movement'),
(11457,0,8,0,9,1,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - Within 0-5 Range - Enable Combat Movement'),
(11457,0,9,0,3,2,100,0,0,30,100,100,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - Between 0-30% Mana - Set Event Phase 1'),
(11457,0,10,0,0,2,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - In Combat - Set Event Phase 1'),
(11457,0,12,0,2,0,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - Between 0-15% Health - Enable Combat Movement'),
(11457,0,13,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - Between 0-15% Health - Flee For Assist'),
(11457,0,14,0,7,0,100,0,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - On Evade - Set Event Phase 0'),
(11457,0,15,0,0,0,100,0,0,1000,3000,4000,0,11,15228,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wildspawn Hellcaller - In Combat - Cast Fireball'),
(11457,0,16,0,0,0,100,0,6000,11000,20000,34000,0,11,31598,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Wildspawn Hellcaller - In Combat - Cast Rain of Fire');

-- Highborne Summoner (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11466 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11466;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11466,0,0,0,1,0,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Highborne Summoner - Out of Combat - Disable Combat Movement'),
(11466,0,4,5,3,1,100,3,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Highborne Summoner - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(11466,0,5,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Highborne Summoner - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Normal Dungeon)'),
(11466,0,6,0,9,1,100,3,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Highborne Summoner - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(11466,0,7,0,9,1,100,3,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Highborne Summoner - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(11466,0,8,0,9,1,100,3,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Highborne Summoner - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(11466,0,9,0,3,0,100,2,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Highborne Summoner - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Normal Dungeon)'),
(11466,0,10,0,0,0,100,0,0,2000,3000,5000,0,11,9053,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Highborne Summoner - In Combat - Cast Fireball'),
(11466,0,11,0,0,0,100,0,4000,9000,9000,19000,0,11,13339,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Highborne Summoner - In Combat - Cast Fire Blast'),
(11466,0,12,0,9,0,50,0,0,9,10000,19000,0,11,15063,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Highborne Summoner - Within Range 0-9yd - Cast Frost Nova');

-- Eldreth Sorcerer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11470 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11470;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11470,0,0,0,0,0,100,0,1000,4000,5000,8000,0,11,20831,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Eldreth Sorcerer - In Combat - Cast Chain Lightning'),
(11470,0,1,0,0,0,100,0,4000,11000,15000,22000,0,11,13323,32,0,0,0,0,6,30,0,0,0,0,0,0,0,'Eldreth Sorcerer - In Combat - Cast Polymorph'),
(11470,0,2,0,0,0,100,0,4000,16000,16000,25000,0,11,22823,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Eldreth Sorcerer - In Combat - Cast Starshards');

-- Eldreth Spectre (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11473 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11473;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11473,0,0,0,1,0,100,3,500,500,0,0,0,11,32811,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eldreth Spectre - Out of Combat - Cast ''Greater Invisibility'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(11473,0,1,0,0,0,100,3,2000,2000,0,0,0,28,32811,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eldreth Spectre - In Combat - Remove Aura ''Greater Invisibility'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(11473,0,2,0,14,0,100,3,2000,10,0,0,0,11,7154,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Eldreth Spectre - Friendly At 2000 Health - Cast ''Dark Offering'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(11473,0,3,0,14,0,100,3,4000,10,0,0,0,11,7154,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Eldreth Spectre - Friendly At 4000 Health - Cast ''Dark Offering'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(11473,0,4,0,14,0,100,3,6000,10,0,0,0,11,7154,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Eldreth Spectre - Friendly At 6000 Health - Cast ''Dark Offering'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(11473,0,5,0,1,0,100,0,10000,10000,40000,40000,0,11,16380,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eldreth Spectre - Out of Combat - Cast Greater Invisibility'),
(11473,0,6,0,0,0,100,0,4000,11000,14000,25000,0,11,17831,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Eldreth Spectre - In Combat - Cast Call of the Graves'),
(11473,0,7,0,0,0,100,2,9000,12000,22000,26000,0,11,17201,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eldreth Spectre - In Combat - Cast ''Dispel Magic'' (Phase 1) (No Repeat) (Normal Dungeon)');

-- Skeletal Highborne (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11476 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11476;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11476,0,0,0,0,0,100,0,2000,10000,10000,20000,0,11,13444,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Skeletal Highborne - In Combat - Cast Sunder Armor');

-- Residual Monstrosity (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11484 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11484;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11484,0,0,0,0,0,100,0,1000,1000,2000,3000,0,11,13748,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Residual Monstrosity - In Combat - Cast Arcane Bolt'),
(11484,0,1,0,9,0,100,0,0,9,9000,13000,0,11,22940,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Residual Monstrosity - Within Range 0-9yd - Cast Arcane Blast'),
(11484,0,2,0,6,0,100,0,0,0,0,0,0,11,22939,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Residual Monstrosity - On Death - Cast Summon Mana Bursts');

-- Prince Tortheldrin (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11486 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11486;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11486,0,0,0,4,0,100,3,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Prince Tortheldrin - On Aggro - Say Line 0 (Phase 1) (No Repeat) (Normal Dungeon)'),
(11486,0,1,0,25,0,100,65537,0,0,0,0,0,11,674,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Prince Tortheldrin - On Reset - Cast Dual Wield'),
(11486,0,2,0,25,0,100,0,0,0,0,0,0,11,3417,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Prince Tortheldrin - On Reset - Cast Thrash'),
(11486,0,3,0,0,0,100,0,3000,5000,10000,20000,0,11,22920,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Prince Tortheldrin - In Combat - Cast Arcane Blast'),
(11486,0,4,0,0,0,100,0,8000,11000,10000,15000,0,11,13736,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Prince Tortheldrin - In Combat - Cast Whirlwind'),
(11486,0,5,0,13,0,100,0,9000,12000,0,0,0,11,20537,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Prince Tortheldrin - Victim Casting - Cast Counterspell'),
(11486,0,6,0,0,0,100,2,12000,15000,15000,20000,0,11,22995,1,0,0,0,0,6,0,0,0,0,0,0,0,0,'Prince Tortheldrin - In Combat - Cast ''Summon'' (Phase 1) (No Repeat) (Normal Dungeon)');

-- Magister Kalendris (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11487 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11487;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11487,0,0,0,2,0,100,3,0,30,0,0,0,28,22917,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Magister Kalendris - Between 0-30% Health - Remove Aura ''Shadowform'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(11487,0,1,0,0,0,100,0,3000,5000,120000,120000,0,11,22917,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Magister Kalendris - In Combat - Cast Shadowform'),
(11487,0,2,0,0,0,100,0,1000,2000,12000,20000,0,11,15587,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tendris Warpwood - In Combat - Cast Mind Blast'),
(11487,0,3,0,0,0,100,0,5000,5000,5000,7000,0,11,22919,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tendris Warpwood - In Combat - Cast Mind Flay'),
(11487,0,4,0,0,0,100,0,8000,8000,10000,10000,0,11,15654,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Tendris Warpwood - In Combat - Cast Shadow Word: Pain'),
(11487,0,5,0,0,0,100,0,14000,20000,30000,30000,0,11,7645,0,0,0,0,0,6,20,0,0,0,0,0,0,0,'Tendris Warpwood - In Combat - Cast Dominate Mind'),
(11487,0,6,0,1,0,100,1,10000,10000,0,0,0,11,21157,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tendris Warpwood - Out of Combat - Cast Dark Channeling');

-- Ambershard Destroyer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11782 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11782;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11782,0,0,0,0,0,85,0,15000,15000,5000,5000,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ambershard Destroyer - In Combat - Cast ''Thrash'' (No Repeat)'),
(11782,0,1,0,0,0,80,0,20000,20000,15000,15000,0,11,19701,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Ambershard Destroyer - In Combat - Cast ''Boulder'' (No Repeat)'),
(11782,0,2,0,0,0,75,0,23000,23000,9000,9000,0,11,13728,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ambershard Destroyer - In Combat - Cast ''Earth Shock'' (No Repeat)');

-- Deep Borer (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11789 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11789;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11789,0,0,0,0,0,100,0,0,0,2300,3900,0,11,31378,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Deep Borer - In Combat - Cast ''Worm Blast''');

-- Duskwing (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11897 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11897;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11897,0,1,2,8,0,100,0,85431,0,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Duskwing - On Spellhit - Set Run'),
(11897,0,2,0,61,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Duskwing - On Spellhit - Move to Pos'),
(11897,0,3,0,0,0,100,0,5000,8000,12000,15000,0,11,77522,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Swoop'),
(11897,0,4,0,9,0,100,0,0,8,15000,25000,0,11,8281,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Sonic Burst on Close');

-- Boulderslide Rock Keeper (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11915 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11915;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11915,0,0,0,8,0,100,0,78315,0,5000,5000,0,87,1191501,1191502,0,0,0,0,1,0,0,0,0,0,0,0,0,'Boulderslide Rock Keeper - On SpellHit Whip ''Em - Run Random Script'),
(11915,0,1,0,9,0,100,0,0,30,13600,14500,0,11,81305,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Boulderslide Rock Keeper - Within 0-30 Range - Cast ''Rock Barrage''');

-- Boulderslide Geomancer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=11917 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=11917;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(11917,0,0,0,8,0,100,0,78315,0,5000,5000,0,87,1191701,1191702,0,0,0,0,1,0,0,0,0,0,0,0,0,'Boulderslide Geomancer - On SpellHit Whip ''Em - Run Random Script'),
(11917,0,1,0,0,0,100,0,0,0,3400,4700,0,11,20793,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Boulderslide Geomancer - In Combat - Cast ''Fireball'''),
(11917,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Boulderslide Geomancer - Between 0-15% Health - Flee For Assist (No Repeat)'),
(11917,0,3,0,0,0,100,0,5000,9000,25000,27000,0,11,81309,2,0,0,0,0,4,0,0,0,0,0,0,0,0,'Boulderslide Geomancer - In Combat - Cast ''Cave-in''');

-- Razorlash (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=12258 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=12258;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(12258,0,0,0,0,0,70,2,4000,4000,6500,6500,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razorlash - In Combat - Cast ''Thrash'''),
(12258,0,1,0,0,0,85,2,6000,6000,8000,8000,0,11,40504,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razorlash - In Combat - Cast ''Cleave'''),
(12258,0,2,0,0,0,85,2,12000,12000,12000,12000,0,11,15976,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razorlash - In Combat - Cast ''Puncture''');

-- Shadowprey Guardian (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=12338 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=12338;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(12338,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shadowprey Guardian - In Combat - Cast ''Shoot''');

-- Emeraldon Boughguard (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=12474 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=12474;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(12474,0,0,0,4,0,100,1,0,0,0,0,0,11,6268,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Emeraldon Boughguard - On Aggro - Cast ''Rushing Charge'' (No Repeat)'),
(12474,0,1,0,0,0,100,0,2000,4500,12000,13000,0,11,32736,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Emeraldon Boughguard - In Combat - Cast ''Mortal Strike''');

-- Emeraldon Oracle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=12476 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=12476;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(12476,0,0,0,0,0,100,0,2000,4500,9000,18000,0,11,9591,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Emeraldon Oracle - In Combat - Cast ''Acid Spit'''),
(12476,0,1,0,2,0,100,0,0,50,20000,21000,0,11,12160,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Emeraldon Oracle - Between 0-50% Health - Cast ''Rejuvenation''');

-- Vorsha the Lasher (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=12940 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=12940;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(12940,0,0,0,6,0,100,0,0,0,0,0,0,15,6641,0,0,0,0,0,17,0,50,0,0,0,0,0,0,'Vorsha the Lasher - Quest Complete'),
(12940,0,1,0,0,0,100,0,2000,4500,9000,12000,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Vorsha the Lasher - In Combat - Cast ''Thrash'''),
(12940,0,2,0,0,0,100,0,7000,9000,24000,32000,0,11,6607,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Vorsha the Lasher - In Combat - Cast ''Lash'''),
(12940,0,3,0,0,0,100,0,2000,4000,18000,28000,0,11,33126,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Vorsha the Lasher - In Combat - Cast ''Dropped Weapon''');

-- Dun Morogh Mountaineer (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=13076 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=13076;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(13076,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dun Morogh Mountaineer - In Combat - Cast ''Shoot''');

-- Emogg the Crusher (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=14267 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=14267;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(14267,0,0,0,4,0,80,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Emogg the Crusher - On Aggro - Say Line 0'),
(14267,0,1,2,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Emogg the Crusher - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(14267,0,2,0,61,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Emogg the Crusher - Between 0-30% Health - Say Line 0 (No Repeat)'),
(14267,0,3,0,0,0,100,0,8000,11000,22000,28000,0,11,84709,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Emogg the Crusher - In Combat - Cast ''Stomp''');

-- Cho'Rush the Observer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=14324 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=14324;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(14324,0,0,0,1,0,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Out of Combat - Disable Combat Movement (Normal Dungeon)'),
(14324,0,1,0,0,0,100,3,0,0,0,0,0,30,1,4,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Set Random Phase(1, 4) (Normal Dungeon)'),
(14324,0,4,5,3,1,100,3,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(14324,0,5,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Normal Dungeon)'),
(14324,0,6,0,9,1,100,3,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(14324,0,7,0,9,1,100,3,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(14324,0,8,0,9,1,100,3,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(14324,0,11,0,2,1,100,2,0,50,15000,22000,0,11,15982,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Between 0-50% Health - Cast ''Healing Wave'' (Phase 1) (No Repeat) (Normal Dungeon)'),
(14324,0,12,0,3,2,100,2,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Normal Dungeon)'),
(14324,0,15,16,3,4,100,3,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Between 0-15% Mana - Enable Combat Movement (Phase 4) (No Repeat) (Normal Dungeon)'),
(14324,0,16,0,61,4,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Between 0-15% Mana - Increment Phase By 1 (Phase 4) (No Repeat) (Normal Dungeon)'),
(14324,0,17,0,9,4,100,3,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Within 35-80 Range - Enable Combat Movement (Phase 4) (No Repeat) (Normal Dungeon)'),
(14324,0,18,0,9,4,100,3,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Within 5-15 Range - Disable Combat Movement (Phase 4) (No Repeat) (Normal Dungeon)'),
(14324,0,19,0,9,4,100,3,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Within 0-5 Range - Enable Combat Movement (Phase 4) (No Repeat) (Normal Dungeon)'),
(14324,0,22,0,3,8,100,2,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Between 30-100% Mana - Decrement Phase By 1 (Phase 4) (No Repeat) (Normal Dungeon)'),
(14324,0,23,0,1,0,100,2,0,0,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Out of Combat - Enable Combat Movement (Phase 4) (No Repeat) (Normal Dungeon)'),
(14324,0,24,0,25,0,100,0,0,0,0,0,0,31,1,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - On Reset - Set Random Phase (1-3)'),
(14324,0,25,0,0,1,100,0,1000,3000,3000,4500,0,11,12466,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Cast Fireball'),
(14324,0,26,0,9,1,100,0,0,8,10000,15000,0,11,15531,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Within Range 0-8yd - Cast Frost Nova'),
(14324,0,27,0,0,1,100,0,6000,9000,11000,14000,0,11,13745,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Cast Arcane Explosion'),
(14324,0,28,0,0,1,100,0,5000,9000,15000,22000,0,11,16170,0,0,0,0,0,19,11501,50,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Cast Bloodlust'),
(14324,0,29,0,0,2,100,0,5000,9000,8000,11000,0,11,15587,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Cast Mind Blast'),
(14324,0,30,0,9,2,100,0,0,6,13000,19000,0,11,22884,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - Within Range 0-6yd - Cast Psychic Scream'),
(14324,0,31,0,0,4,100,0,5000,9000,22000,22000,0,11,8376,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Cast Earthgrab Totem'),
(14324,0,32,0,0,4,100,0,1000,3000,3000,4500,0,11,15801,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Cast Lightning Bolt'),
(14324,0,33,0,0,4,100,0,6000,9000,11000,14500,0,11,16006,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Cast Chain Lightning'),
(14324,0,34,0,0,0,100,2,12000,15000,40000,50000,0,11,17139,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cho''Rush the Observer - In Combat - Cast ''Power Word: Shield'' (Phase 4) (No Repeat) (Normal Dungeon)');

-- Lethtendris (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=14327 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=14327;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(14327,0,0,0,1,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - Out of Combat - Disable Combat Movement (Normal Dungeon)'),
(14327,0,4,5,3,1,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat)'),
(14327,0,5,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat)'),
(14327,0,6,0,9,1,100,1,45,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - Within 45-80 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(14327,0,7,0,9,1,100,1,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat)'),
(14327,0,8,0,9,1,100,1,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(14327,0,9,0,3,0,100,0,20,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - Between 20-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat)'),
(14327,0,10,0,0,0,100,0,0,2000,5000,6000,0,11,22709,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lethtendris - In Combat - Cast Void Bolt'),
(14327,0,11,0,0,0,100,0,3000,7000,11000,16000,0,11,14887,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - In Combat - Cast Shadow Bolt Volley'),
(14327,0,12,0,0,0,100,0,5000,11000,15000,24000,0,11,20787,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Lethtendris - In Combat - Cast Immolate'),
(14327,0,13,0,0,0,100,0,11000,11000,30000,30000,0,11,22710,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - In Combat - Cast Enlarge'),
(14327,0,14,0,0,0,100,0,11000,22000,22000,33000,0,11,16247,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lethtendris - In Combat - Cast Curse of Thorns'),
(14327,0,15,0,0,0,100,0,11000,22000,22000,33000,0,11,13338,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Lethtendris - In Combat - Cast Curse of Tongues');

-- Pimgib (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=14349 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=14349;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(14349,0,0,0,1,0,100,3,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pimgib - Out of Combat - Disable Combat Movement'),
(14349,0,4,5,3,1,100,3,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pimgib - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(14349,0,5,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pimgib - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Normal Dungeon)'),
(14349,0,6,0,9,1,100,3,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pimgib - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(14349,0,7,0,9,1,100,3,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pimgib - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(14349,0,8,0,9,1,100,3,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pimgib - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Normal Dungeon)'),
(14349,0,9,0,3,0,100,2,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pimgib - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Normal Dungeon)'),
(14349,0,10,0,0,0,100,0,0,2000,3000,3500,0,11,14034,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lethtendris - In Combat - Cast Fireball'),
(14349,0,11,0,0,0,100,0,3000,7000,11000,16000,0,11,22713,0,0,0,0,0,5,20,0,0,0,0,0,0,0,'Lethtendris - In Combat - Cast Flame Buffet'),
(14349,0,12,0,9,0,100,0,0,8,10000,15000,0,11,15744,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lethtendris - Within Range 0-8yd - Cast Blast Wave'),
(14349,0,13,0,2,0,100,2,0,50,30000,30000,0,11,22710,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pimgib - Between 0-50% Health - Cast ''Enlarge'' (Phase 1) (No Repeat) (Normal Dungeon)');

-- Eldreth Darter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=14398 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=14398;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(14398,0,0,0,0,0,100,0,2000,6000,8000,11000,0,11,14033,0,0,0,0,0,5,30,0,1,0,0,0,0,0,'Eldreth Darter - In Combat - Cast Mana Burn'),
(14398,0,1,0,0,0,100,2,10000,10000,30000,40000,0,11,17139,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eldreth Darter - In Combat - Cast ''Power Word: Shield''');

-- Arcane Feedback (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=14400 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=14400;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(14400,0,0,0,1,0,100,3,1000,1000,0,0,0,11,15507,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Arcane Feedback - Out of Combat - Cast ''Lightning Shield'''),
(14400,0,1,0,1,0,100,0,3000,8000,300000,300000,0,11,12550,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Arcane Feedback - Out of Combat - Cast Lightning Shield'),
(14400,0,2,0,0,0,100,0,10000,10000,20000,20000,0,11,12550,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Arcane Feedback - In Combat - Cast Lightning Shield');

-- Fingat (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=14446 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=14446;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(14446,0,0,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text at 30% HP'),
(14446,0,1,0,11,0,100,1,0,0,0,0,0,11,3391,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Thrash on Spawn'),
(14446,0,2,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Enrage at 30% HP'),
(14446,0,3,0,25,0,100,1,0,0,0,0,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Thrash on Spawn');

-- Illiyana Moonblaze (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=14753 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=14753;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(14753,0,0,0,0,0,100,0,0,0,2300,3900,0,11,22907,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Illiyana Moonblaze - In Combat - Cast ''Shoot'''),
(14753,0,1,2,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Illiyana Moonblaze - Between 0-15% Health - Flee For Assist (No Repeat)'),
(14753,0,2,0,61,0,100,1,0,15,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Illiyana Moonblaze - Between 0-15% Health - Say Line 0 (No Repeat)'),
(14753,0,3,0,9,0,100,0,5,30,22000,27000,0,11,21390,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Illiyana Moonblaze - Within 5-30 Range - Cast ''Multi-Shot'''),
(14753,0,4,0,9,0,100,0,0,20,5000,9000,0,11,6533,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Illiyana Moonblaze - Within 0-20 Range - Cast ''Net'''),
(14753,0,5,0,2,0,100,1,0,30,0,0,0,11,3019,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Illiyana Moonblaze - Between 0-30% Health - Cast ''Frenzy'' (No Repeat)'),
(14753,0,6,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Illiyana Moonblaze - Between 0-30% Health - Say Line 0 (No Repeat)');

-- Defiler Elite (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=15128 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=15128;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(15128,0,0,0,0,0,100,0,3000,5000,5000,7000,0,11,15284,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Defiler Elite - In Combat - Cast ''Cleave'''),
(15128,0,1,0,0,0,100,0,6000,11000,19000,25000,0,11,11972,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Defiler Elite - In Combat - Cast ''Shield Bash'''),
(15128,0,2,0,0,0,100,0,5000,8000,12000,15000,0,11,15496,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Cleave');

-- League of Arathor Elite (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=15130 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=15130;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(15130,0,0,0,0,0,100,0,3000,5000,5000,7000,0,11,15284,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'League of Arathor Elite - In Combat - Cast ''Cleave'''),
(15130,0,1,0,0,0,100,0,6000,11000,19000,25000,0,11,11972,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'League of Arathor Elite - In Combat - Cast ''Shield Bash'''),
(15130,0,2,0,0,0,100,0,5000,8000,12000,15000,0,11,15496,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Cleave');

-- Theldren (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=16059 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=16059;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16059,0,0,0,25,0,100,0,0,0,0,0,0,11,27578,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On Reset - Cast Spell'),
(16059,0,1,0,9,0,100,0,8,25,7000,7000,0,11,27577,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'On Range - Cast Spell'),
(16059,0,2,0,0,0,100,0,12000,14000,25000,27000,0,11,27584,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'IC Update - Cast spell'),
(16059,0,3,0,0,0,100,0,5000,7000,8000,10000,0,11,27580,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'IC Update - Cast spell'),
(16059,0,4,0,0,0,100,0,9000,9000,17000,17000,0,11,19134,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'IC Update - Cast spell'),
(16059,0,5,0,0,0,100,0,6000,6000,37000,37000,0,11,27579,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'IC Update - Cast spell');

-- Deatholme Darkmage (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=16318 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=16318;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16318,0,0,0,0,0,100,0,1000,1000,1700,2000,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Deatholme Darkmage - IC - Cast ''Shadow Bolt'''),
(16318,0,1,0,0,0,100,0,7000,11000,32000,36000,0,11,18267,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Deatholme Darkmage - IC - Cast ''Curse of Weakness'''),
(16318,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Deatholme Darkmage - Between 0-15% Health - Flee For Assist (No Repeat)'),
(16318,0,3,0,25,0,100,0,0,0,0,0,0,11,28729,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Deatholme Darkmage - On reset - Cast Ribbon of Souls');

-- Argent Sentry (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=16378 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=16378;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16378,0,0,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shoot'),
(16378,0,1,0,13,0,100,0,20000,30000,0,0,0,11,15618,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Snap Kick on Player Spell Cast'),
(16378,0,2,0,9,0,100,0,0,5,15000,25000,0,11,19643,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Mortal Strike on Close'),
(16378,0,3,0,4,0,100,1,0,0,0,0,0,11,25821,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Argent Sentry - On Aggro - Cast ''Charge'''),
(16378,0,4,0,0,0,100,0,1000,3000,9000,12000,0,11,18328,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Sentry - In Combat - Cast ''Incapacitating Shout''');

-- Shattered Hand Brawler (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=16593 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=16593;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16593,0,0,1,0,0,100,0,1500,1500,7000,10000,0,11,36020,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Shattered Hand Brawler - In Combat - Cast ''Curse of the Shattered Hand'''),
(16593,0,1,0,61,0,100,0,0,0,0,0,0,13,100,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shattered Hand Brawler - In Combat - Set Single Threat 100-0'),
(16593,0,2,0,0,0,100,6,500,500,9500,9500,0,11,36033,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shattered Hand Brawler - In Combat - Cast ''Kick'''),
(16593,0,3,0,0,0,100,6,4000,4000,5500,12500,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shattered Hand Brawler - In Combat - Cast ''Thrash''');

-- Hulking Helboar (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=16880 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=16880;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16880,0,0,0,8,0,100,1,34665,0,0,0,0,33,16992,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hulking Helboar - On Spellhit ''Administer Antidote'' - Quest Credit ''Testing the Antidote'' (No Repeat)'),
(16880,0,1,0,25,0,100,0,0,0,0,0,0,11,33908,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hulking Helboar - On Reset - Cast ''Burning Spikes'''),
(16880,0,2,0,2,0,100,1,34,66,0,0,0,11,33909,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hulking Helboar - Between 34-66% Health - Cast ''Hulk'' (No Repeat)'),
(16880,0,3,0,2,0,100,1,1,66,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hulking Helboar - Between 1-66% Health - Say Line 0 (No Repeat)'),
(16880,0,4,0,2,0,100,1,1,33,0,0,0,11,33909,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hulking Helboar - Between 1-33% Health - Cast ''Hulk'' (No Repeat)');

-- Foreman Razelcraz (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=16915 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=16915;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(16915,0,0,0,20,0,100,0,10629,0,0,0,0,45,0,2,0,0,0,0,19,21847,5,0,0,0,0,0,0,'Foreman Razelcraz - On Rewarded Quest - Set Data 0 2'),
(16915,0,1,0,1,0,100,0,30000,60000,30000,60000,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foreman Razelcraz - OOC - Say Line 0'),
(16915,0,2,0,1,0,100,0,45000,90000,45000,90000,0,11,34396,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foreman Razelcraz - OOC - Cast Zap'),
(16915,0,3,0,1,0,100,0,20000,40000,20000,40000,0,5,60,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Foreman Razelcraz - OOC - Play emote oneshotkick');

-- Bleeding Hollow Darkcaster (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17269 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17269;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17269,0,0,1,1,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - Out of Combat - Disable Combat Movement'),
(17269,0,1,0,61,0,100,0,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - Out of Combat - Set Event Phase 0'),
(17269,0,8,9,3,0,100,0,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - Between 0-15% Mana - Enable Combat Movement'),
(17269,0,9,0,61,0,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - Between 0-15% Mana - Increment Phase By 1'),
(17269,0,10,0,9,0,100,7,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - Within 25-80 Range - Enable Combat Movement'),
(17269,0,11,0,9,0,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - Within 5-15 Range - Disable Combat Movement'),
(17269,0,12,0,9,0,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - Within 0-5 Range - Enable Combat Movement'),
(17269,0,13,0,3,0,100,6,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - Between 30-100% Mana - Decrement Phase By 1'),
(17269,0,14,0,0,0,100,2,0,2050,1750,2050,0,11,15241,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - In Combat - Cast ''Scorch'' (Normal Dungeon)'),
(17269,0,15,0,0,0,100,4,0,2050,1750,2050,0,11,36807,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - In Combat - Cast ''Scorch'' (Heroic Dungeon)'),
(17269,0,16,0,0,0,100,2,15650,23000,20650,31600,0,11,20754,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - In Combat - Cast ''Rain of Fire'' (Normal Dungeon)'),
(17269,0,17,0,0,0,100,4,15650,23000,20650,31600,0,11,36808,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Bleeding Hollow Darkcaster - In Combat - Cast ''Rain of Fire'' (Heroic Dungeon)');

-- Gorgannon (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17300 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17300;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17300,0,2,3,2,0,100,1,0,50,0,0,0,39,15,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gorgannon - Between 0-50% Health - Call For Help (No Repeat)'),
(17300,0,3,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gorgannon - Between 0-50% Health - Say Line 0 (No Repeat)'),
(17300,0,4,0,9,0,100,0,0,40,15000,32000,0,11,9613,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gorgannon - Within 0-40 Range - Cast ''Shadow Bolt'''),
(17300,0,5,0,9,0,100,0,0,5,12000,24000,0,11,11428,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gorgannon - Within 0-5 Range - Cast ''Knockdown'''),
(17300,0,6,7,2,0,100,1,0,50,0,0,0,39,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Gorgannon - Between 0-50% Health - Call For Help (No Repeat)'),
(17300,0,7,0,61,0,100,1,0,50,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gorgannon - Between 0-50% Health - Say Line 0 (No Repeat)'),
(17300,0,8,0,0,0,100,0,8000,9000,24000,32000,0,11,37624,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Gorgannon - In Combat - Cast ''Carrion Swarm''');

-- Felguard Annihilator (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17400 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17400;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17400,0,0,0,9,0,100,4,8,25,8700,14700,0,11,27577,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Felguard Annihilator - Within 8-25 Range - Cast ''Intercept'' (Heroic Dungeon)'),
(17400,0,1,0,0,0,100,0,3000,10950,8500,20650,0,11,18072,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Felguard Annihilator - In Combat - Cast ''Uppercut'''),
(17400,0,2,0,13,0,100,0,6900,9500,0,0,0,11,15615,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Felguard Annihilator - On Victim Casting - Cast ''Pummel''');

-- Shattered Hand Centurion (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17465 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17465;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17465,0,0,0,0,0,100,2,1500,2500,4000,6000,0,11,15572,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shattered Hand Centurion - In Combat - Cast ''Sunder Armor'' (Normal Dungeon)'),
(17465,0,1,0,0,0,100,4,1500,2500,4000,6000,0,11,16145,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shattered Hand Centurion - In Combat - Cast ''Sunder Armor'' (Heroic Dungeon)'),
(17465,0,2,0,0,0,100,2,3000,7000,17000,21000,0,11,30931,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shattered Hand Centurion - In Combat - Cast ''Battle Shout'' (Normal Dungeon)'),
(17465,0,3,0,0,0,100,4,3000,7000,17000,21000,0,11,31403,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shattered Hand Centurion - In Combat - Cast ''Battle Shout'' (Heroic Dungeon)'),
(17465,0,4,0,25,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shattered Hand Centurion - On Reset - Set Event Phase 1 (Allow Sparring Match'),
(17465,0,5,0,4,0,100,0,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shattered Hand Centurion - On Aggro - Set Event Phase 0'),
(17465,0,6,0,0,0,100,6,2000,2000,8000,14500,0,11,42246,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shattered Hand Centurion - In Combat - Cast ''Propagandized!'' (No Repeat) (Dungeon)');

-- Bleeding Hollow Scryer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17478 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17478;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17478,0,0,0,11,0,100,7,0,0,0,0,0,11,31059,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Scryer - On Respawn - Cast Hellfire Channeling'),
(17478,0,1,0,21,0,100,7,0,0,0,0,0,11,31059,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Scryer - On Reached Home - Cast Hellfire Channeling'),
(17478,0,2,0,0,0,100,2,800,1700,3600,4700,0,11,12471,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bleeding Hollow Scryer - In Combat - Cast ''Shadow Bolt'' (Normal Dungeon)'),
(17478,0,3,0,0,0,100,4,800,1700,3600,4700,0,11,15232,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bleeding Hollow Scryer - In Combat - Cast ''Shadow Bolt'' (Heroic Dungeon)'),
(17478,0,4,0,0,0,100,0,4850,23500,15450,23800,0,11,30615,1,0,0,0,0,6,0,0,0,0,0,0,0,0,'Bleeding Hollow Scryer - In Combat - Cast ''Fear'''),
(17478,0,5,0,6,0,100,0,0,0,0,0,0,11,30659,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Scryer - On Death - Cast Fel Infusion');

-- Blood Elf Bandit (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17591 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17591;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17591,0,0,0,4,0,75,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blood Elf Bandit - On Aggro - Say Line 0'),
(17591,0,1,0,11,0,100,0,0,0,0,0,0,3,0,17115,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blood Elf Bandit - On Respawn - Sen ModelId 17115 (TEMP HACK!, 17116 can cause crashes!)'),
(17591,0,2,0,25,0,100,1,0,0,0,0,0,75,5916,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blood Elf Bandit - On Reset - Add Aura ''Shadowstalker Stealth'' (No Repeat)'),
(17591,0,3,0,9,0,100,0,0,5,5000,8000,0,11,14873,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Blood Elf Bandit - Within 0-5 Range - Cast ''Sinister Strike'''),
(17591,0,4,0,67,0,100,0,9000,14000,0,0,0,11,7159,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Blood Elf Bandit - On Behind Target - Cast ''Backstab'''),
(17591,0,5,0,0,0,100,0,9000,14000,16000,21000,0,11,15691,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Blood Elf Bandit - In Combat - Cast ''Eviscerate'''),
(17591,0,7,0,0,0,100,0,9000,14000,16000,21000,0,11,25710,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Blood Elf Bandit - In Combat - Cast ''Heroic Strike''');

-- Sharpshooter Guard (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17622 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17622;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17622,0,0,1,1,0,100,7,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Out of Combat - Disable Combat Movement (No Repeat) (Dungeon)'),
(17622,0,1,0,61,0,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Out of Combat - Stop Attacking (No Repeat) (Dungeon)'),
(17622,0,10,11,9,0,100,7,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 25-80 Range - Enable Combat Movement (No Repeat) (Dungeon)'),
(17622,0,11,0,61,0,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 25-80 Range - Start Attacking (No Repeat) (Dungeon)'),
(17622,0,12,13,9,0,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 0-5 Range - Enable Combat Movement (No Repeat) (Dungeon)'),
(17622,0,13,14,61,0,100,0,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 0-5 Range - Set Sheath Melee (No Repeat) (Dungeon)'),
(17622,0,14,0,61,0,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 0-5 Range - Start Attacking (No Repeat) (Dungeon)'),
(17622,0,15,16,9,0,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 5-15 Range - Disable Combat Movement (No Repeat) (Dungeon)'),
(17622,0,16,0,61,0,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 5-15 Range - Stop Attacking (No Repeat) (Dungeon)'),
(17622,0,21,22,9,0,100,6,5,30,10000,14000,0,11,37551,1,0,0,0,0,5,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 5-30 Range - Cast ''Viper Sting'' (Dungeon)'),
(17622,0,22,0,61,0,100,0,0,0,0,0,0,40,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - Within 5-30 Range - Set Sheath Ranged (Dungeon)'),
(17622,0,23,0,7,0,100,7,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sharpshooter Guard - On Evade - Set Sheath Melee (Dungeon)'),
(17622,0,24,0,0,0,100,2,1200,6100,3100,5600,0,11,15620,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sharpshooter Guard - In Combat - Cast ''Shoot'' (Normal Dungeon)'),
(17622,0,25,0,0,0,100,4,1200,6100,3100,5600,0,11,22907,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sharpshooter Guard - In Combat - Cast ''Shoot'' (Heroic Dungeon)'),
(17622,0,26,0,0,0,100,0,12150,30400,12150,30400,0,11,30481,64,0,0,0,0,5,0,0,0,0,0,0,0,0,'Sharpshooter Guard - In Combat - Cast ''Incendiary Shot'''),
(17622,0,27,0,0,0,100,0,13350,21000,20700,39250,0,11,23601,64,0,0,0,0,5,0,0,0,0,0,0,0,0,'Sharpshooter Guard - In Combat - Cast ''Scatter Shot''');

-- Shattered Hand Assassin (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17695 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17695;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17695,0,0,0,1,0,100,7,1000,1000,0,0,0,11,30991,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Shattered Hand Assassin - Out of Combat - Cast ''Stealth'' (No Repeat)'),
(17695,0,1,0,67,0,100,0,4500,6500,0,0,0,11,30992,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shattered Hand Assassin - On Behind Target - Cast ''Backstab'''),
(17695,0,2,0,0,0,100,0,8000,11000,22000,25000,0,11,36974,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shattered Hand Assassin - In Combat - Cast ''Wound Poison'''),
(17695,0,3,0,0,0,100,0,2000,4500,12000,20000,0,11,30981,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shattered Hand Assassin - In Combat - Cast ''Crippling Poison'''),
(17695,0,4,0,10,0,100,0,0,15,12000,15000,0,11,30980,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Shattered Hand Assassin - Within 0-15 Range Out of Combat LoS - Cast ''Sap'''),
(17695,0,5,0,10,0,100,0,0,8,4000,8000,0,11,30986,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Shattered Hand Assassin - Within 0-8 Range Out of Combat LoS - Cast ''Cheap Shot'''),
(17695,0,6,0,9,0,100,0,0,8,4000,8000,0,11,30986,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Shattered Hand Assassin - Within 0-8 Range - Cast ''Cheap Shot''');

-- Time Keeper (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17918 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17918;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17918,0,0,0,0,0,100,0,5000,5000,15000,15000,0,11,31478,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time Keeper - In Combat - Cast Spell Sand Breath');

-- Coilfang Slavehandler (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17959 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17959;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17959,0,0,0,1,0,90,6,60000,120000,360000,420000,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Slavehandler - Out of Combat - Say Line 0 (Phase 8) (No Repeat) (Dungeon)'),
(17959,0,1,0,1,0,90,6,180000,240000,540000,680000,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Slavehandler - Out of Combat - Say Line 1 (Phase 8) (No Repeat) (Dungeon)'),
(17959,0,2,0,4,0,20,7,0,0,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Slavehandler - On Aggro - Say Line 2 (Phase 8) (No Repeat) (Dungeon)'),
(17959,0,3,0,0,0,100,0,6150,15800,19400,25500,0,11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Slavehandler - In Combat - Cast Hamstring'),
(17959,0,4,0,0,0,100,0,12150,24250,24250,27900,0,11,16172,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Slavehandler - In Combat - Cast Head Crack'),
(17959,0,5,0,1,0,50,0,5000,25000,20000,40000,0,11,6754,0,0,0,0,0,19,17964,5,0,0,0,0,0,0,'Coilfang Slavehandler - Out Of Combat - Cast Slap!');

-- Coilfang Soothsayer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=17960 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=17960;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(17960,0,0,0,1,0,100,7,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - Out of Combat - Disable Combat Movement (Phase 8) (No Repeat) (Dungeon)'),
(17960,0,4,5,3,1,100,7,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(17960,0,5,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(17960,0,6,0,9,1,100,7,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - Within 25-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(17960,0,7,0,9,1,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(17960,0,8,0,9,1,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(17960,0,9,0,3,0,100,6,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(17960,0,10,0,0,0,100,0,9950,12150,23100,24300,0,11,15790,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - In Combat - Cast ''Arcane Missiles'''),
(17960,0,11,0,0,0,100,0,19400,27600,26500,42300,0,11,31555,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - In Combat - Cast ''Decayed Intellect'''),
(17960,0,12,0,0,0,100,0,20650,25500,23100,24300,0,11,30923,0,0,0,0,0,6,0,0,0,0,0,0,0,0,'Coilfang Soothsayer - In Combat - Cast ''Domination''');

-- Feralfen Hunter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18113 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18113;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18113,0,0,1,1,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Out of Combat - Disable Combat Movement (No Repeat)'),
(18113,0,1,0,61,0,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Out of Combat - Stop Attacking (No Repeat)'),
(18113,0,7,8,9,1,100,0,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Within 25-80 Range - Enable Combat Movement (Phase 1)'),
(18113,0,8,0,61,1,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Within 25-80 Range - Start Attacking (Phase 1)'),
(18113,0,9,10,9,1,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Within 0-5 Range - Enable Combat Movement (Phase 1)'),
(18113,0,10,11,61,1,100,0,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Within 0-5 Range - Set Sheath Melee (Phase 1)'),
(18113,0,11,0,61,1,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Within 0-5 Range - Start Attacking (Phase 1)'),
(18113,0,12,13,9,1,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Within 5-15 Range - Disable Combat Movement (Phase 1)'),
(18113,0,13,0,61,1,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Within 5-15 Range - Stop Attacking (Phase 1)'),
(18113,0,18,0,7,0,100,1,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - On Evade - Set Sheath Melee (No Repeat)'),
(18113,0,19,0,1,0,100,1,1000,1000,0,0,0,11,32060,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Out of Combat - Cast ''Summon Sporebat'' (No Repeat)'),
(18113,0,20,21,4,0,100,1,0,0,0,0,0,11,6660,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Feralfen Hunter - On Aggro - Cast ''Shoot'' (No Repeat)'),
(18113,0,21,0,61,0,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - On Aggro - Increment Phase By 1 (No Repeat)'),
(18113,0,22,0,9,1,100,0,5,30,2300,3900,0,11,6660,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Feralfen Hunter - Within 5-30 Range - Cast ''Shoot'' (Phase 1)'),
(18113,0,23,0,0,0,100,0,4000,8000,18000,24000,0,11,31975,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Feralfen Hunter - In Combat - Cast ''Serpent Sting'' (Phase 1)'),
(18113,0,24,0,2,0,100,1,0,15,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Feralfen Hunter - Between 0-15% Health - Increment Phase By 1 (No Repeat)'),
(18113,0,25,0,0,1,100,0,7000,9000,14000,18000,0,11,12024,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Feralfen Hunter - In Combat - Cast ''Net'' (Phase 1)');

-- Ethereal Sorcerer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18313 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18313;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18313,0,0,0,1,0,100,7,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - Out of Combat - Disable Combat Movement (No Repeat) (Dungeon)'),
(18313,0,7,8,3,1,100,7,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18313,0,8,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(18313,0,9,0,9,1,100,7,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - Within 25-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18313,0,10,0,9,1,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18313,0,11,0,9,1,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18313,0,12,0,3,0,100,6,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(18313,0,13,0,0,0,100,2,0,0,10500,10500,0,11,15790,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - In Combat - Cast Fireball'),
(18313,0,14,0,0,0,100,4,0,0,10500,10500,0,11,22272,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - In Combat - Cast Fireball'),
(18313,0,15,0,0,0,100,0,5000,8000,10000,15000,0,11,25603,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Ethereal Sorcerer - In Combat - Cast Slow'),
(18313,0,16,0,0,0,100,2,14000,22700,22300,22300,0,11,32349,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - In Combat - Cast ''Summon Arcane Fiend'' (Phase 1) (No Repeat) (Dungeon)'),
(18313,0,17,0,0,0,100,4,14000,22700,22300,22300,0,11,32353,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereal Sorcerer - In Combat - Cast ''Summon Arcane Fiend'' (Phase 1) (No Repeat) (Dungeon)');

-- Time-Lost Scryer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18319 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18319;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18319,0,0,0,1,0,100,7,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Out of Combat - Disable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,8,9,3,1,100,7,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,9,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,10,0,9,1,100,7,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Within 25-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,11,0,9,1,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,12,0,9,1,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,13,0,3,0,100,6,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,14,0,14,0,100,2,5000,20,7000,10000,0,11,17843,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Friendly At 5000 Health - Cast ''Flash Heal'' (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,15,0,14,0,100,4,8000,20,7000,10000,0,11,17138,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Friendly At 8000 Health - Cast ''Flash Heal'' (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,16,0,14,0,100,2,2000,20,8000,10000,0,11,12160,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Friendly At 2000 Health - Cast ''Rejuvenation'' (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,17,0,14,0,100,4,3500,20,8000,10000,0,11,15981,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Friendly At 3500 Health - Cast ''Rejuvenation'' (Phase 1) (No Repeat) (Dungeon)'),
(18319,0,18,0,1,0,100,0,1000,1000,30000,30000,0,11,32689,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - Out of Combat - Cast ''Arcane Destruction'''),
(18319,0,19,0,0,0,100,0,3100,5300,3100,5300,0,11,32689,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Scryer - In Combat - Cast ''Arcane Destruction'''),
(18319,0,20,0,0,0,100,2,7800,13300,10400,17700,0,11,22272,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time-Lost Scryer - In Combat - Cast ''Arcane Missiles'' (Normal Dungeon)'),
(18319,0,21,0,0,0,100,4,7800,13300,10400,17700,0,11,33988,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time-Lost Scryer - In Combat - Cast ''Arcane Missiles'' (Heroic Dungeon)'),
(18319,0,22,0,74,0,100,2,0,75,9600,15700,0,11,17843,0,0,0,0,0,9,0,0,40,0,0,0,0,0,'Time-Lost Scryer - On Friendly Between 0-75% Health - Cast ''Flash Heal'' (Normal Dungeon)'),
(18319,0,23,0,74,0,100,4,0,75,9600,15700,0,11,17138,0,0,0,0,0,9,0,0,40,0,0,0,0,0,'Time-Lost Scryer - On Friendly Between 0-75% Health - Cast ''Flash Heal'' (Heroic Dungeon)'),
(18319,0,24,0,74,0,100,2,0,40,13200,21700,0,11,12160,0,0,0,0,0,9,0,0,40,0,0,0,0,0,'Time-Lost Scryer - On Friendly Between 0-40% Health - Cast ''Rejuvenation'' (Normal Dungeon)'),
(18319,0,25,0,74,0,100,4,0,40,13200,21700,0,11,15981,0,0,0,0,0,9,0,0,40,0,0,0,0,0,'Time-Lost Scryer - On Friendly Between 0-40% Health - Cast ''Rejuvenation'' (Heroic Dungeon)');

-- Time-Lost Shadowmage (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18320 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18320;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18320,0,0,0,0,0,100,2,6600,18600,9300,21800,0,11,32675,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time-Lost Shadowmage - In Combat - Cast ''Shadow Missiles'' (Normal Dungeon)'),
(18320,0,1,0,0,0,100,4,6600,18600,9300,21800,0,11,38148,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time-Lost Shadowmage - In Combat - Cast ''Shadow Missiles'' (Heroic Dungeon)'),
(18320,0,2,0,0,0,100,2,4800,9600,21700,33800,0,11,32682,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time-Lost Shadowmage - In Combat - Cast ''Curse of the Dark Talon'' (Normal Dungeon)'),
(18320,0,3,0,0,0,100,4,4800,9600,21700,33800,0,11,38149,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time-Lost Shadowmage - In Combat - Cast ''Curse of the Dark Talon'' (Heroic Dungeon)');

-- Murkblood Twin (merge)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18399 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18399;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18399,0,0,0,4,0,100,0,0,0,0,0,0,1,0,0,1,0,0,0,7,0,0,0,0,0,0,0,0,'Murkblood Twin - On Aggro - Say Line 0 (No Repeat)'),
(18399,0,1,0,0,0,100,0,1000,1000,2000,2000,0,11,14873,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murkblood Twin - In Combat - Cast ''Sinister Strike'' (No Repeat)'),
(18399,0,3,0,0,0,100,0,8000,9000,15000,16000,0,11,32319,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murkblood Twin - In Combat - Cast ''Mutilate'' (No Repeat)'),
(18399,0,4,5,6,1,100,1,0,0,0,0,0,15,9967,0,0,0,0,0,16,0,0,0,0,0,0,0,0,'Murkblood Twin - On Just Died - Quest Credit ''The Ring of Blood: The Blue Brothers'' (No Repeat)'),
(18399,0,5,0,61,1,100,1,0,0,0,0,0,45,11,11,0,0,0,0,19,18471,0,0,0,0,0,0,0,'Murkblood Twin - On Just Died - Set Data 11 11 (No Repeat)'),
(18399,0,6,7,25,0,100,0,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murkblood Twin - On Reset - Set Event Phase 0'),
(18399,0,7,0,61,0,100,0,0,0,0,0,0,70,0,0,0,0,0,0,9,18399,0,100,0,0,0,0,0,'Murkblood Twin - On Reset - Respawn '),
(18399,0,8,0,6,0,100,0,0,0,0,0,0,45,1,1,0,0,0,0,9,18399,0,100,0,0,0,0,0,'Murkblood Twin - On Just Died - Set Data 1 1'),
(18399,0,9,10,38,0,100,0,1,1,0,0,0,45,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murkblood Twin - On Data Set 1 1 - Set Data 1 0'),
(18399,0,10,0,61,0,100,0,1,1,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Murkblood Twin - Linked with Previous Event - Increment Phase'),
(18399,0,12,0,0,0,100,0,5000,6000,11000,12000,0,11,15692,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Murkblood Twin - In Combat - Cast ''Eviscerate''');

-- Sunseeker Botanist (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18422 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18422;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18422,0,0,0,74,0,100,0,0,60,13300,35100,0,11,34361,0,0,0,0,0,9,0,0,40,0,0,0,0,0,'Sunseeker Botanist - On Friendly Between 0-60% Health - Cast ''Regrowth'''),
(18422,0,1,0,0,0,100,0,8500,20600,15800,20600,0,11,34350,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunseeker Botanist - In Combat - Cast ''Nature`s Rage''');

-- Cabal Cultist (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18631 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18631;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18631,0,0,0,13,0,100,6,8000,10000,0,0,0,11,15614,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Cultist - Target Casting - Cast ''Kick'' (No Repeat)'),
(18631,0,1,0,0,0,100,6,3000,8000,10000,12000,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Cultist - In Combat - Cast ''Thrash'' (No Repeat)');

-- Cabal Zealot (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18638 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18638;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18638,0,0,0,1,0,100,7,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Out of Combat - Disable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18638,0,7,8,3,1,100,7,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18638,0,8,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(18638,0,9,0,9,1,100,7,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18638,0,10,0,9,1,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18638,0,11,0,9,1,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18638,0,12,0,3,2,100,6,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(18638,0,13,0,2,0,100,7,0,20,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Between 0-20% Health - Set Event Phase 3 (No Repeat) (Dungeon)'),
(18638,0,14,0,0,0,100,2,0,0,3400,4500,0,11,12471,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Zealot - In Combat CMC - Cast ''Shadow Bolt'' (Normal Dungeon)'),
(18638,0,15,0,0,0,100,4,0,0,3400,4500,0,11,15472,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Zealot - In Combat CMC - Cast ''Shadow Bolt'' (Heroic Dungeon)'),
(18638,0,16,17,2,0,100,1,0,50,0,0,0,11,33949,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - Between 0-50% Health - Cast ''Shape of the Beast'' (No Repeat)'),
(18638,0,17,0,61,0,100,0,0,0,0,0,0,11,33499,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Zealot - On Link - Cast ''Shape of the Beast''');

-- Auchenai Necromancer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18702 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18702;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18702,0,0,0,14,0,100,2,4000,15,6000,8000,0,11,33325,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Auchenai Necromancer - Friendly At 4000 Health - Cast ''Shadow Mend'' (Phase 1) (No Repeat) (Dungeon)'),
(18702,0,1,0,14,0,100,4,7000,15,6000,8000,0,11,37367,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Auchenai Necromancer - Friendly At 7000 Health - Cast ''Shadow Mend'' (Phase 1) (No Repeat) (Dungeon)'),
(18702,0,2,0,0,0,100,0,1000,15200,4800,15700,0,11,35839,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Auchenai Necromancer - In Combat - Cast ''Drain Soul'''),
(18702,0,3,0,0,0,100,2,12100,29000,22900,35000,0,11,32863,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Auchenai Necromancer - In Combat - Cast ''Seed of Corruption'' (Normal Dungeon)'),
(18702,0,4,0,0,0,100,4,12100,17500,4800,9600,0,11,38252,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Auchenai Necromancer - In Combat - Cast ''Seed of Corruption'' (Heroic Dungeon)'),
(18702,0,5,0,74,0,100,2,0,70,15700,26500,0,11,33325,0,0,0,0,0,9,0,0,15,0,0,0,0,0,'Auchenai Necromancer - On Friendly Between 0-70% Health - Cast ''Shadow Mend'' (Normal Dungeon)'),
(18702,0,6,0,74,0,100,4,0,70,6100,8400,0,11,37367,0,0,0,0,0,9,0,0,15,0,0,0,0,0,'Auchenai Necromancer - On Friendly Between 0-70% Health - Cast ''Shadow Mend'' (Heroic Dungeon)');

-- Cabal Ritualist (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18794 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18794;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18794,0,0,1,1,0,100,7,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Out of Combat - Disable Combat Movement (No Repeat) (Dungeon)'),
(18794,0,1,0,61,0,100,0,0,0,0,0,0,30,1,4,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Out of Combat - Set Random Phase(1, 4) (No Repeat) (Dungeon)'),
(18794,0,7,8,3,1,100,7,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18794,0,8,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(18794,0,9,0,9,1,100,7,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18794,0,10,0,9,1,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18794,0,11,0,9,1,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(18794,0,15,0,3,2,100,6,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(18794,0,21,22,3,4,100,7,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Between 0-15% Mana - Enable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(18794,0,22,0,61,4,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Between 0-15% Mana - Increment Phase By 1 (Phase 4) (No Repeat) (Dungeon)'),
(18794,0,23,0,9,4,100,7,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Within 35-80 Range - Enable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(18794,0,24,0,9,4,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Within 5-15 Range - Disable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(18794,0,25,0,9,4,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Within 0-5 Range - Enable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(18794,0,28,0,3,8,100,6,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - Between 30-100% Mana - Decrement Phase By 1 (Phase 4) (No Repeat) (Dungeon)'),
(18794,0,29,0,4,0,100,7,0,0,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - On Aggro - Enable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(18794,0,30,0,25,0,100,0,0,0,0,0,0,11,32958,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - On Reset - Cast ''Crystal Channel'''),
(18794,0,31,0,0,0,100,2,0,0,3400,4500,0,11,15497,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat CMC - Cast ''Frostbolt'' (Normal Dungeon) (Phase 1)'),
(18794,0,32,0,0,0,100,4,0,0,3400,4500,0,11,12675,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat CMC - Cast ''Frostbolt'' (Heroic Dungeon) (Phase 1)'),
(18794,0,33,0,9,0,100,2,0,10,12100,16900,0,11,15532,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat - Cast ''Frost Nova'' (Normal Dungeon) (Phase 1)'),
(18794,0,34,0,9,0,100,4,0,10,12100,16900,0,11,15063,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat - Cast ''Frost Nova'' (Normal Dungeon) (Phase 1)'),
(18794,0,35,0,0,0,100,2,0,0,5000,5000,0,11,33832,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat CMC - Cast ''Arcane Missiles'' (Normal Dungeon) (Phase 2)'),
(18794,0,36,0,0,0,100,4,0,0,5000,5000,0,11,38263,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat CMC - Cast ''Arcane Missiles'' (Heroic Dungeon) (Phase 2)'),
(18794,0,37,0,0,0,100,0,2400,14300,5200,21700,0,11,33487,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat - Cast ''Addle Humanoid'' (Phase 2)'),
(18794,0,38,0,0,0,100,0,3600,6200,4800,11200,0,11,9574,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat - Cast ''Flame Buffet'' (Phase 3)'),
(18794,0,39,0,0,0,100,2,6100,20200,8400,22900,0,11,20795,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat - Cast ''Fire Blast'' (Normal Dungeon) (Phase 3)'),
(18794,0,40,0,0,0,100,4,6100,20200,8400,22900,0,11,14145,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat - Cast ''Fire Blast'' (Heroic Dungeon) (Phase 3)'),
(18794,0,41,0,0,0,100,0,10000,15000,12100,19300,0,11,12540,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cabal Ritualist - In Combat - Cast ''Gouge'' (Phase 4)'),
(18794,0,42,0,15,0,100,4,15,15000,20000,0,0,11,17201,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Cabal Ritualist - Friendly Crowd Controlled - Cast ''Dispel Magic'' (Heroic Dungeon)');

-- Sunfury Magister (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18855 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18855;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18855,0,0,0,1,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Out of Combat - Disable Combat Movement (No Repeat)'),
(18855,0,4,5,3,1,100,1,0,7,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Between 0-7% Mana - Enable Combat Movement (Phase 1) (No Repeat)'),
(18855,0,5,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Between 0-7% Mana - Increment Phase By 1 (Phase 1) (No Repeat)'),
(18855,0,6,0,9,1,100,1,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(18855,0,7,0,9,1,100,1,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat)'),
(18855,0,8,0,9,1,100,1,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(18855,0,9,0,3,2,100,0,15,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Between 15-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat)'),
(18855,0,11,12,2,0,100,1,0,15,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Between 0-15% Health - Set Event Phase 3 (No Repeat)'),
(18855,0,12,13,61,0,100,0,0,0,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Between 0-15% Health - Enable Combat Movement (No Repeat)'),
(18855,0,13,0,61,0,100,0,0,0,0,0,0,25,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - Between 0-15% Health - Flee For Assist (No Repeat)'),
(18855,0,14,0,0,0,100,0,3000,6000,3000,4000,0,11,9053,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sunfury Magister - In Combat - Cast ''Fireball'''),
(18855,0,15,0,0,0,100,0,8000,12000,26000,31000,0,11,35778,33,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunfury Magister - In Combat - Cast ''Bloodcrystal Surge'''),
(18855,0,16,0,1,0,50,0,10000,20000,15000,30000,0,11,34397,0,0,0,0,0,19,19421,30,0,0,0,0,0,0,'Sunfury Magister - Out of Combat - Cast ''Red Beam''');

-- Voidshrieker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=18870 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=18870;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(18870,0,1,0,0,0,100,7,0,0,0,0,0,30,1,2,3,4,5,6,1,0,0,0,0,0,0,0,0,'Voidshrieker - In Combat - Set Random Phase(1, 2, 3, 4, 5, 6) (No Repeat)'),
(18870,0,2,3,8,0,100,1,0,2,0,0,0,11,34336,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Cast ''Damage Reduction: Holy'' (No Repeat)'),
(18870,0,3,4,61,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Disable Combat Movement (No Repeat)'),
(18870,0,4,0,61,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Set Event Phase 1 (No Repeat)'),
(18870,0,5,6,8,0,100,1,0,4,0,0,0,11,34333,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Cast ''Damage Reduction: Fire'' (No Repeat)'),
(18870,0,6,7,61,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Disable Combat Movement (No Repeat)'),
(18870,0,7,0,61,0,100,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Set Event Phase 2 (No Repeat)'),
(18870,0,8,9,8,0,100,1,0,8,0,0,0,11,34335,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Cast ''Damage Reduction: Nature'' (No Repeat)'),
(18870,0,9,10,61,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Disable Combat Movement (No Repeat)'),
(18870,0,10,0,61,0,100,0,0,0,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Set Event Phase 3 (No Repeat)'),
(18870,0,11,12,8,0,100,1,0,16,0,0,0,11,34334,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Cast ''Damage Reduction: Frost'' (No Repeat)'),
(18870,0,12,13,61,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Disable Combat Movement (No Repeat)'),
(18870,0,13,0,61,0,100,0,0,0,0,0,0,22,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Set Event Phase 4 (No Repeat)'),
(18870,0,14,15,8,0,100,1,0,32,0,0,0,11,34338,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Cast ''Damage Reduction: Shadow'' (No Repeat)'),
(18870,0,15,16,61,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Disable Combat Movement (No Repeat)'),
(18870,0,16,0,61,0,100,0,0,0,0,0,0,22,5,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Set Event Phase 5 (No Repeat)'),
(18870,0,17,18,8,0,100,1,0,64,0,0,0,11,34331,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Cast ''Damage Reduction: Arcane'' (No Repeat)'),
(18870,0,18,19,61,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Disable Combat Movement (No Repeat)'),
(18870,0,19,0,61,0,100,0,0,0,0,0,0,22,6,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Spellhit - Set Event Phase 6 (No Repeat)'),
(18870,0,20,0,9,2,100,0,0,40,2000,3000,0,11,34346,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Voidshrieker - Within 0-40 Range - Cast ''Holy Bolt'' (No Repeat)'),
(18870,0,21,22,3,1,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat)'),
(18870,0,22,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat)'),
(18870,0,23,0,9,1,100,0,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(18870,0,24,0,9,1,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat)'),
(18870,0,25,0,9,1,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(18870,0,27,28,3,2,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Enable Combat Movement (Phase 2) (No Repeat)'),
(18870,0,28,0,61,2,100,1,0,15,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Increment Phase By 1 (Phase 2) (No Repeat)'),
(18870,0,29,0,9,2,100,0,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 35-80 Range - Enable Combat Movement (Phase 2) (No Repeat)'),
(18870,0,30,0,9,2,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 5-15 Range - Disable Combat Movement (Phase 2) (No Repeat)'),
(18870,0,31,0,9,2,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 0-5 Range - Enable Combat Movement (Phase 2) (No Repeat)'),
(18870,0,33,34,3,4,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Enable Combat Movement (Phase 4) (No Repeat)'),
(18870,0,34,0,61,4,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Increment Phase By 1 (Phase 4) (No Repeat)'),
(18870,0,35,0,9,4,100,0,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 35-80 Range - Enable Combat Movement (Phase 4) (No Repeat)'),
(18870,0,36,0,9,4,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 5-15 Range - Disable Combat Movement (Phase 4) (No Repeat)'),
(18870,0,37,0,9,4,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 0-5 Range - Enable Combat Movement (Phase 4) (No Repeat)'),
(18870,0,39,40,3,8,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Enable Combat Movement (Phase 8) (No Repeat)'),
(18870,0,40,0,61,8,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Increment Phase By 1 (Phase 8) (No Repeat)'),
(18870,0,41,0,9,8,100,0,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 35-80 Range - Enable Combat Movement (Phase 8) (No Repeat)'),
(18870,0,42,0,9,8,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 5-15 Range - Disable Combat Movement (Phase 8) (No Repeat)'),
(18870,0,43,0,9,8,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 0-5 Range - Enable Combat Movement (Phase 8) (No Repeat)'),
(18870,0,45,46,3,16,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Enable Combat Movement (Phase 16) (No Repeat)'),
(18870,0,46,0,61,16,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Increment Phase By 1 (Phase 16) (No Repeat)'),
(18870,0,47,0,9,16,100,0,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 35-80 Range - Enable Combat Movement (Phase 16) (No Repeat)'),
(18870,0,48,0,9,16,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 5-15 Range - Disable Combat Movement (Phase 16) (No Repeat)'),
(18870,0,49,0,9,16,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 0-5 Range - Enable Combat Movement (Phase 16) (No Repeat)'),
(18870,0,50,0,9,32,100,0,0,30,2400,3800,0,11,34447,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Voidshrieker - Within 0-30 Range - Cast ''Arcane Missiles'' (Phase 16) (No Repeat)'),
(18870,0,51,52,3,32,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Enable Combat Movement (Phase 32) (No Repeat)'),
(18870,0,52,0,61,32,100,1,0,15,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Between 0-15% Mana - Increment Phase By 1 (Phase 32) (No Repeat)'),
(18870,0,53,0,9,32,100,0,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 25-80 Range - Enable Combat Movement (Phase 32) (No Repeat)'),
(18870,0,54,0,9,32,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 5-15 Range - Disable Combat Movement (Phase 32) (No Repeat)'),
(18870,0,55,0,9,32,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - Within 0-5 Range - Enable Combat Movement (Phase 32) (No Repeat)'),
(18870,0,56,0,25,0,100,0,0,0,0,0,0,22,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Reset - Set Event Phase 0'),
(18870,0,57,0,11,0,100,0,0,0,0,0,0,11,34302,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Respawn - Cast ''Coalesce'''),
(18870,0,58,0,4,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Aggro - Set Event Phase 1'),
(18870,0,59,0,9,0,100,0,0,8,14000,18000,0,11,22884,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Voidshrieker - On Hostile in Range - Cast ''Psychic Scream'''),
(18870,0,60,0,0,1,100,0,0,1000,3000,3500,0,11,12471,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Voidshrieker - In Combat - Cast ''Shadow Bolt'' (Phase 1)'),
(18870,0,61,0,0,2,100,0,0,1000,2500,3000,0,11,15498,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Voidshrieker - In Combat - Cast ''Holy Smite'' (Phase 2)'),
(18870,0,62,0,0,4,100,0,0,1000,3000,3500,0,11,14034,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Voidshrieker - In Combat - Cast ''Fireball'' (Phase 3)'),
(18870,0,63,0,0,8,100,0,0,1000,3000,3500,0,11,12167,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Voidshrieker - In Combat - Cast ''Lightning Bolt'' (Phase 4)'),
(18870,0,64,0,0,16,100,0,0,1000,3000,3500,0,11,15497,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Voidshrieker - In Combat - Cast ''Frostbolt'' (Phase 5)'),
(18870,0,65,0,0,32,100,0,0,1000,5000,6000,0,11,38204,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Voidshrieker - In Combat - Cast ''Arcane Bolt'' (Phase 6)');

-- Flame Wave (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=19381 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=19381;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(19381,0,0,0,11,0,100,0,0,0,0,0,0,11,33800,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Flame Wave - On Respawn - Cast ''Flame Wave''');

-- Bleeding Hollow Tormentor (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=19424 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=19424;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(19424,0,0,0,0,0,100,0,5000,5000,10000,10000,0,11,12542,1,0,0,0,0,3,0,0,0,0,0,0,0,0,'Bleeding Hollow Tormentor - In Combat - Cast ''Fear'' (No Repeat)'),
(19424,0,1,0,0,0,100,1,0,0,3000,3000,0,11,34368,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bleeding Hollow Tormentor - In Combat - Cast ''Summon Riding Worg'' (No Repeat)'),
(19424,0,2,0,2,0,100,1,0,15,0,0,0,11,31553,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bleeding Hollow Tormentor - Between 0-15% Health - Cast ''Hamstring'' (No Repeat)');

-- Sunseeker Channeler (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=19505 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=19505;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(19505,0,0,0,1,0,100,6,1000,1000,30000,30000,0,11,34173,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunseeker Channeler - Out of Combat - Cast ''Sunseeker Blessing'''),
(19505,0,1,0,0,0,100,0,7000,10000,20000,24000,0,11,34222,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunseeker Channeler - In Combat - Cast ''Sunseeker Blessing'''),
(19505,0,2,0,0,0,100,0,7300,15350,18200,25700,0,11,34634,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunseeker Channeler - In Combat - Cast ''Sunseeker Aura'''),
(19505,0,3,0,0,0,100,0,2000,10000,15000,24000,0,11,34637,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sunseeker Channeler - In Combat - Cast ''Soul Channel'''),
(19505,0,4,0,38,0,100,0,1,1,0,0,0,11,34156,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunseeker Channeler - On Data Set 1 1 - Cast ''Crystal Channel''');

-- Nethervine Inciter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=19511 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=19511;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(19511,0,0,0,0,0,100,0,6100,19900,20000,24000,0,11,34616,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nethervine Inciter - In Combat - Cast ''Deadly Poison'''),
(19511,0,1,0,0,0,100,0,4300,9700,21700,38600,0,11,34615,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nethervine Inciter - In Combat - Cast ''Mind-numbing Poison'''),
(19511,0,2,0,0,0,100,0,13400,20600,20600,29000,0,11,30621,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nethervine Inciter - In Combat - Cast ''Kidney Shot'''),
(19511,0,3,0,8,0,100,0,34222,0,1200,1200,0,11,34173,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethervine Inciter - On Spellhit ''Sunseeker Blessing'' - Cast ''Sunseeker Blessing'''),
(19511,0,4,0,8,0,100,0,34200,0,1200,1200,0,11,34173,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nethervine Inciter - On Spellhit ''Crystal Channel'' - Cast ''Sunseeker Blessing''');

-- Socrethar (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20132 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20132;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20132,0,0,0,38,0,100,0,2,2,0,0,0,11,35596,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Socrethar - On Data Set 2 2 - Cast ''Power of the Legion'''),
(20132,0,1,0,23,0,100,0,37539,0,3600,3600,0,11,37539,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Socrethar - On Missing Aura ''Nether Protection'' - Cast ''Nether Protection'''),
(20132,0,2,0,0,0,100,0,2500,7500,15000,25000,0,11,15496,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Socrethar - In Combat - Cast ''Cleave'''),
(20132,0,3,0,0,0,100,0,10000,15000,40000,60000,0,11,37538,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Socrethar - In Combat - Cast ''Anti-Magic Shield'''),
(20132,0,4,0,0,0,100,0,17000,24000,10000,35000,0,11,28448,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Socrethar - In Combat - Cast ''Shadow Bolt Volley'''),
(20132,0,5,0,0,0,100,0,30000,40000,30000,40000,0,11,37540,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Socrethar - In Combat - Cast ''Fireball Barrage'''),
(20132,0,6,0,0,0,100,0,30000,45000,35000,50000,0,11,37537,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Socrethar - In Combat - Cast ''Backlash''');

-- Ethereum Overlord (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20459 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20459;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20459,0,0,0,4,0,100,1,0,0,0,0,0,11,36509,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ethereum Overlord - On Aggro - Cast ''Charge'' (No Repeat)'),
(20459,0,1,0,2,0,100,1,70,95,0,0,0,11,32064,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ethereum Overlord - Between 70-95% Health - Cast ''Battle Shout'' (No Repeat)');

-- Underbog Frenzy (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20465 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20465;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20465,0,0,0,0,0,100,0,1200,9600,15350,17000,0,11,12097,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Underbog Frenzy - In Combat - Cast ''Pierce Armor''');

-- Arcane Servant (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20478 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20478;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20478,0,0,0,54,0,100,0,0,0,0,0,0,11,35259,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Arcane Servant - On Just Summoned - Cast ''Spotlight'''),
(20478,0,1,0,0,0,100,0,3600,10800,16900,26500,0,11,35255,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Arcane Servant - In Combat - Cast ''Arcane Volley'''),
(20478,0,2,0,54,0,100,0,0,0,0,0,0,11,22271,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Arcane Servant - On Just Summoned - Cast ''Arcane Explosion''');

-- Naberius (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20483 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20483;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20483,0,0,0,11,0,100,1,0,0,0,0,0,11,28126,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Naberius - On Respawn - Cast ''Spirit Particles (purple)'' (Phase 1) (No Repeat)'),
(20483,0,1,0,0,0,100,0,10000,15000,25000,30000,0,11,36146,128,0,0,0,0,2,0,0,0,0,0,0,0,0,'Naberius - In Combat - Cast ''Chains of Naberius'' (threatlist > 1)'),
(20483,0,2,0,0,0,100,0,1000,4000,4000,4000,0,11,15497,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Naberius - In Combat - Cast ''Frostbolt'''),
(20483,0,3,0,0,0,100,0,2000,5000,10000,12000,0,11,36148,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Naberius - In Combat - Cast ''Chill Nova'''),
(20483,0,4,0,0,0,100,0,5000,10000,15000,30000,0,11,36147,0,0,0,0,0,5,60,1,0,0,0,0,0,0,'Naberius - In Combat - Cast ''Lesser Shadow Fissure''');

-- Area 52 Big Bruiser (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20484 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20484;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20484,0,0,0,0,0,100,0,3000,6000,18000,24000,0,11,38661,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Area 52 Big Bruiser - In Combat - Cast ''Net''');

-- Area 52 Bruiser (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20485 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20485;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20485,0,0,0,0,0,100,0,3000,6000,18000,24000,0,11,38661,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Area 52 Bruiser - In Combat - Cast ''Net''');

-- Razaani Nexus Stalker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20609 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20609;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20609,0,0,0,0,0,100,0,0,0,8000,11000,0,85,36513,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Razaani Nexus Stalker - IC - Cast Intangible Presence'),
(20609,0,1,0,6,0,25,0,0,0,0,0,0,45,1,1,0,0,0,0,10,86749,21057,0,0,0,0,0,0,'Razaani Nexus Stalker - On Death - Set Data on Nexus-Prince Razaan'),
(20609,0,2,0,0,0,100,0,4000,11000,12000,28000,0,11,36513,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razaani Nexus Stalker - In Combat - Cast Intangible Presence'),
(20609,0,3,0,0,0,100,0,3000,11000,11000,25000,0,11,11975,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Razaani Nexus Stalker - In Combat - Cast Arcane Explosion');

-- Salaadin's Energy Ball (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20769 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20769;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20769,0,0,0,11,0,100,1,0,0,0,0,0,11,32566,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Salaadin''s Energy Ball - On Respawn - Cast ''Purple Banish State'' (No Repeat)'),
(20769,0,1,0,1,0,100,1,5000,5000,0,0,0,11,35515,0,0,0,0,0,9,20454,0,200,0,0,0,0,0,'Salaadin''s Energy Ball - Out of Combat - Cast ''Salaadin''s Tesla'''),
(20769,0,2,0,38,0,100,0,1,1,0,0,0,41,100,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Salaadin''s Energy Ball - On Data Set 1 1 - Despawn In 100 ms');

-- Eredar Soul-Eater (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20879 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20879;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20879,0,0,0,1,0,100,0,0,0,0,0,0,11,36784,0,0,0,0,0,17,0,100,0,0,0,0,0,0,'Eredar Soul-Eater - At Range - Cast Entropic Aura'),
(20879,0,1,0,0,0,100,0,6000,15000,15000,22000,0,11,36786,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eredar Soul-Eater - In Combat - Cast ''Soul Chill'''),
(20879,0,2,0,0,0,100,0,15000,17000,14000,21000,0,11,36778,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Eredar Soul-Eater - In Combat - Cast ''Soul Steal'''),
(20879,0,3,0,31,0,100,0,36778,0,0,0,0,11,36782,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eredar Soul-Eater - On Target Spellhit ''Soul Steal'' - Cast ''Soul Steal''');

-- Unbound Devastator (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20881 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20881;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20881,0,0,0,0,0,100,0,6000,10000,13000,22000,0,11,36887,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Unbound Devastator - In Combat - Cast ''Deafening Roar'''),
(20881,0,1,0,9,0,100,0,0,8,14000,21000,0,11,36891,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Unbound Devastator - Within 0-8 Range - Cast ''Devastate'''),
(20881,0,2,0,0,0,100,2,2000,4000,20000,22000,0,11,36897,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Unbound Devastator - In Combat - Cast ''Transporter Malfunction'' (Phase 1) (No Repeat)');

-- Ironspine Forgelord (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=20928 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=20928;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(20928,0,0,0,8,0,100,0,38915,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Ironspine Forgelord - On SpellHit Mental Interference - Store Target List'),
(20928,0,1,0,38,0,100,0,0,1,0,0,0,33,22348,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Ironspine Forgelord - On Data Set 0 1 - Quest Credit'),
(20928,0,2,0,38,0,100,0,0,2,0,0,0,33,22350,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Ironspine Forgelord - On Data Set 0 2 - Quest Credit'),
(20928,0,3,0,38,0,100,0,0,3,0,0,0,33,22351,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Ironspine Forgelord - On Data Set 0 1 - Quest Credit'),
(20928,0,4,0,0,0,100,0,1000,1000,7000,9000,0,11,37179,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ironspine Forgelord - In Combat - Cast ''Hammer Slam'''),
(20928,0,5,0,0,0,100,0,4000,4000,5000,5000,0,11,36251,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ironspine Forgelord - In Combat - Cast ''Hammer Slam'''),
(20928,0,6,0,4,0,100,1,0,0,0,0,0,11,33962,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ironspine Forgelord - On Aggro - Cast ''Toughen'' (No Repeat)');

-- Enraged Watery Soul (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=21109 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=21109;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(21109,0,0,0,1,0,100,0,1000,2000,30000,30000,0,11,35923,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Watery Soul - Out of Combat - Cast ''Water Bubble Head''');

-- Coilfang Leper (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=21338 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=21338;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(21338,0,0,0,1,0,100,7,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Out of Combat - Disable Combat Movement (Phase 1)'),
(21338,0,1,0,0,0,100,7,0,0,0,0,0,30,1,3,5,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Set Random Phase(1, 3, 5) (Phase 1)'),
(21338,0,7,8,3,1,100,7,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(21338,0,8,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(21338,0,9,0,9,1,100,7,35,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 35-80 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(21338,0,10,0,9,1,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(21338,0,11,0,9,1,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat) (Dungeon)'),
(21338,0,12,0,0,4,85,2,9000,12000,9000,12000,0,11,11831,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Frost Nova'' (Phase 1) (No Repeat) (Dungeon)'),
(21338,0,13,0,0,4,100,4,9000,12000,9000,12000,0,11,15063,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Frost Nova'' (Phase 1) (No Repeat) (Dungeon)'),
(21338,0,14,0,3,2,100,6,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat) (Dungeon)'),
(21338,0,15,0,9,2,100,2,5,30,2300,3800,0,11,15547,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 5-30 Range - Cast ''Shoot'' (Phase 4) (Normal Dungeon)'),
(21338,0,17,0,9,2,100,4,5,30,2300,3800,0,11,16100,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 5-30 Range - Cast ''Shoot'' (Phase 4) (Heroic Dungeon)'),
(21338,0,19,20,9,4,100,7,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 25-80 Range - Enable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(21338,0,20,0,61,4,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 25-80 Range - Start Attacking (Phase 4) (No Repeat) (Dungeon)'),
(21338,0,21,22,9,4,100,7,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 0-5 Range - Enable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(21338,0,22,23,61,4,100,0,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 0-5 Range - Set Sheath Melee (Phase 4) (No Repeat) (Dungeon)'),
(21338,0,23,0,61,4,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 0-5 Range - Start Attacking (Phase 4) (No Repeat) (Dungeon)'),
(21338,0,24,25,9,4,100,7,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 5-15 Range - Disable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(21338,0,25,0,61,4,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Within 5-15 Range - Stop Attacking (Phase 4) (No Repeat) (Dungeon)'),
(21338,0,28,0,0,8,100,1,1000,1000,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Enable Combat Movement (Phase 4) (No Repeat) (Dungeon)'),
(21338,0,33,34,2,0,100,7,0,15,0,0,0,22,6,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Between 0-15% Health - Set Event Phase 6 (No Repeat) (Dungeon)'),
(21338,0,34,35,61,0,100,0,0,0,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Between 0-15% Health - Enable Combat Movement (No Repeat) (Dungeon)'),
(21338,0,35,0,61,0,100,0,0,0,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - Between 0-15% Health - Flee For Assist (No Repeat) (Dungeon)'),
(21338,0,36,0,7,0,100,7,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - On Evade - Set Sheath Melee (No Repeat) (Dungeon)'),
(21338,0,37,0,4,0,100,0,0,0,0,0,0,31,1,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'Coilfang Leper - On Aggro - Set Phase Random Between 1-3'),
(21338,0,38,0,74,1,100,2,0,40,10000,11000,0,11,11642,0,0,0,0,0,9,0,0,40,0,0,0,0,0,'Coilfang Leper - Friendly Below 40% HP - Cast ''Heal'' (Phase 1) (Normal Dungeon)'),
(21338,0,39,0,74,1,100,4,0,40,10000,11000,0,11,15586,0,0,0,0,0,9,0,0,40,0,0,0,0,0,'Coilfang Leper - Friendly Below 40% HP - Cast ''Heal'' (Phase 1) (Heroic Dungeon)'),
(21338,0,40,0,0,2,100,0,4000,6000,7000,8000,0,11,13446,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Strike'' (Phase 2)'),
(21338,0,41,0,0,2,100,0,3000,7000,10000,15000,0,11,13444,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Sunder Armor'' (Phase 2)'),
(21338,0,42,0,0,2,100,0,9000,14000,12000,15000,0,11,40505,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Cleave'' (Phase 2)'),
(21338,0,43,0,0,4,100,2,4000,6000,9000,10000,0,11,13339,0,0,0,0,0,5,20,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Fire Blast'' (Phase 3) (Normal Dungeon)'),
(21338,0,44,0,0,4,100,4,4000,6000,9000,10000,0,11,14145,0,0,0,0,0,5,20,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Fire Blast'' (Phase 3) (Heroic Dungeon)'),
(21338,0,45,0,0,4,100,2,0,0,3000,3000,0,11,9613,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Shadow Bolt'' (Phase 3) (Normal Dungeon)'),
(21338,0,46,0,0,4,100,4,0,0,3000,3000,0,11,12739,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Coilfang Leper - In Combat - Cast ''Shadow Bolt'' (Phase 3) (Heroic Dungeon)');

-- Bog Overlord (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=21694 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=21694;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(21694,0,0,0,1,0,100,3,1000,1000,0,0,0,11,37266,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bog Overlord - Out of Combat - Cast ''Disease Cloud'' (No Repeat)'),
(21694,0,1,0,1,0,100,5,1000,1000,0,0,0,11,37863,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bog Overlord - Out of Combat - Cast ''Disease Cloud'' (No Repeat)'),
(21694,0,2,0,1,0,100,0,2000,5000,12000,19000,0,11,34158,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bog Overlord - Out of Combat - Cast ''Fungal Decay'''),
(21694,0,3,0,0,0,100,0,3000,4000,5000,7000,0,11,37272,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Bog Overlord - In Combat - Cast ''Poison Bolt'''),
(21694,0,4,0,0,0,100,0,7000,9500,12000,15000,0,11,40340,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bog Overlord - In Combat - Cast ''Trample'''),
(21694,0,5,0,2,0,100,1,0,20,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bog Overlord - Between 0-20% Health - Cast ''Enrage'' (No Repeat)');

-- Time-Lost Skettis High Priest (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=21787 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=21787;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(21787,0,0,0,11,0,100,1,0,0,0,0,0,11,37411,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Time-Lost Skettis High Priest - On Respawn - Cast ''Skettis Corrupted Ghosts'''),
(21787,0,1,0,0,0,100,0,4000,8000,7000,16000,0,11,11639,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time-Lost Skettis High Priest - In Combat - Cast ''Shadow Word: Pain'''),
(21787,0,2,0,0,0,100,0,2300,3000,8000,12000,0,11,9734,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Time-Lost Skettis High Priest - In Combat - Cast ''Holy Smite'''),
(21787,0,3,0,74,0,100,0,0,40,10000,15000,0,11,42420,1,0,0,0,0,9,0,0,40,0,0,0,0,0,'Time-Lost Skettis High Priest - On Friendly Below 40% Health - Cast ''Flash Heal''');

-- Eclipsion Spellbinder (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=22017 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=22017;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(22017,0,0,0,1,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Out of Combat - Disable Combat Movement (No Repeat)'),
(22017,0,4,5,3,1,100,1,0,15,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Between 0-15% Mana - Enable Combat Movement (Phase 1) (No Repeat)'),
(22017,0,5,0,61,1,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Between 0-15% Mana - Increment Phase By 1 (Phase 1) (No Repeat)'),
(22017,0,6,0,9,1,100,1,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Within 25-80 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(22017,0,7,0,9,1,100,1,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Within 5-15 Range - Disable Combat Movement (Phase 1) (No Repeat)'),
(22017,0,8,0,9,1,100,1,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Within 0-5 Range - Enable Combat Movement (Phase 1) (No Repeat)'),
(22017,0,9,0,3,2,100,0,30,100,100,100,0,23,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Between 30-100% Mana - Decrement Phase By 1 (Phase 1) (No Repeat)'),
(22017,0,12,13,2,0,100,1,0,15,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Between 0-15% Health - Set Event Phase 3 (No Repeat)'),
(22017,0,13,14,61,0,100,0,0,0,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Between 0-15% Health - Enable Combat Movement (No Repeat)'),
(22017,0,14,0,61,0,100,0,0,0,0,0,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Between 0-15% Health - Flee For Assist (No Repeat)'),
(22017,0,15,0,0,0,100,0,0,0,2400,3800,0,11,34446,64,0,0,0,0,5,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - In Combat - Cast ''Arcane Missiles'''),
(22017,0,16,0,0,0,100,0,8000,12000,18000,24000,0,11,18972,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - In Combat - Cast ''Slow'''),
(22017,0,17,0,2,0,100,0,0,40,0,0,0,11,38171,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eclipsion Spellbinder - Between 0-40% Health - Cast ''Summon Arcane Bursts'''),
(22017,0,18,0,25,0,100,0,0,0,0,0,0,11,35190,0,0,0,0,0,19,20431,20,0,0,0,0,0,0,'Eclipsion Spellbinder - On Reset - Cast ''Crystal Channel''');

-- Void Hound (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=22500 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=22500;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(22500,0,0,0,0,0,100,0,3000,6000,15000,20000,0,11,36406,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Void Hound - In Combat - Cast ''Double Breath''');

-- Fel Imp Defender (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23078 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23078;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23078,0,0,0,0,0,100,0,0,0,3400,4700,0,11,40554,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Fel Imp Defender - In Combat - Cast ''Fireball''');

-- Felhound Defender (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23173 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23173;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23173,0,0,0,2,0,100,0,0,40,15000,20000,0,11,40671,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Felhound Defender - Between 0-40% Health - Cast ''Health Funnel''');

-- Tarren Mill Guardsman (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23175 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23175;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23175,0,0,0,0,0,100,0,0,5000,8500,10500,0,11,16856,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Infinite Slayer - In Combat - Cast Mortal Strike');

-- Tarren Mill Guardsman (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23176 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23176;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23176,0,0,0,9,0,100,0,8,25,15000,20000,0,11,15749,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tarren Mill Guardsman - Within 8-25 Range - Cast ''Shield Charge''');

-- Tarren Mill Lookout (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23177 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23177;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23177,0,0,0,0,0,100,2,0,1000,3500,3500,0,11,15232,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Infinite Defiler - In Combat - Cast Shadow Bolt'),
(23177,0,1,0,0,0,100,4,0,1000,3500,3500,0,11,38386,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Infinite Defiler - In Combat - Cast Shadow Bolt'),
(23177,0,2,0,0,0,100,0,5000,6000,13000,15000,0,11,21068,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Infinite Defiler - In Combat - Cast Corruption'),
(23177,0,3,0,0,0,100,2,0,10000,25000,35000,0,11,31977,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Infinite Defiler - In Combat - Cast Curse of Infinity'),
(23177,0,4,0,0,0,100,4,0,10000,25000,35000,0,11,38387,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Infinite Defiler - In Combat - Cast Bane of Infinity');

-- Tarren Mill Lookout (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23178 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23178;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23178,0,0,0,0,0,100,0,0,0,2300,3900,0,11,17174,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tarren Mill Lookout - In Combat - Cast ''Concussive Shot'''),
(23178,0,1,0,0,0,100,0,4000,7000,12000,16000,0,11,35511,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tarren Mill Lookout - In Combat - Cast ''Serpent Sting'''),
(23178,0,2,0,0,0,100,0,4000,7000,12000,16000,0,11,15620,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tarren Mill Lookout - In Combat - Cast ''Shoot''');

-- Tarren Mill Protector (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23179 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23179;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23179,0,0,0,0,0,100,0,0,5000,8500,10500,0,11,15496,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Infinite Saboteur - In Combat - Cast Cleave'),
(23179,0,1,0,0,0,100,0,6000,10000,20000,30000,0,11,31976,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infinite Saboteur - In Combat - Cast Shadow Shield'),
(23179,0,2,0,0,0,100,0,5000,6000,13000,15000,0,11,17234,0,0,0,0,0,5,20,0,0,0,0,0,0,0,'Infinite Saboteur - In Combat - Cast Shadow Shock');

-- Gan'arg Underling (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23199 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23199;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23199,0,0,0,2,0,100,0,0,40,15000,20000,0,11,40671,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gan''arg Underling - Between 0-40% Health - Cast ''Health Funnel''');

-- Mo'arg Tormenter (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23212 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23212;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23212,0,0,0,0,0,100,0,6000,9000,15000,20000,0,11,40630,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mo''arg Tormenter - In Combat - Cast ''Acid Geyser''');

-- Bergrisst (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23619 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23619;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23619,0,0,0,1,0,100,1,213000,213000,0,0,0,28,34126,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Remove ''Spotlight'''),
(23619,0,1,0,1,0,100,1,27990,27990,0,0,0,28,16380,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Remove Greater Invisibility'),
(23619,0,2,0,1,0,100,1,28000,28000,0,0,0,11,42505,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Cast ''L70ETC Flare Effect'''),
(23619,0,3,0,1,0,100,1,36500,36500,0,0,0,5,402,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 402'),
(23619,0,4,0,1,0,100,1,42505,42505,0,0,0,5,403,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 403'),
(23619,0,5,0,1,0,100,1,80500,80500,0,0,0,5,404,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 404'),
(23619,0,6,0,1,0,100,1,94000,94000,0,0,0,5,405,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 405'),
(23619,0,7,0,1,0,100,1,113500,113500,0,0,0,5,402,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 402'),
(23619,0,8,0,1,0,100,1,137100,137100,0,0,0,5,403,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 403'),
(23619,0,9,0,1,0,100,1,149000,149000,0,0,0,11,34126,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Cast ''Spotlight'''),
(23619,0,10,0,1,0,100,1,158300,158300,0,0,0,5,404,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 404'),
(23619,0,11,0,1,0,100,1,172700,172700,0,0,0,5,405,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 405'),
(23619,0,12,0,1,0,100,1,197500,197500,0,0,0,5,402,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 402'),
(23619,0,13,0,1,0,100,1,213000,213000,0,0,0,11,41347,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Cast ''Spotlight'''),
(23619,0,14,0,1,0,100,1,220500,220500,0,0,0,5,403,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 403'),
(23619,0,15,0,1,0,100,1,240500,240500,0,0,0,5,404,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 404'),
(23619,0,16,0,1,0,100,1,256500,256500,0,0,0,5,405,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 405'),
(23619,0,17,0,1,0,100,1,275500,275500,0,0,0,5,402,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Play Emote 402'),
(23619,0,18,0,1,0,100,1,280000,280000,0,0,0,11,42505,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Cast ''L70ETC Flare Effect'''),
(23619,0,19,0,1,0,100,1,280800,280800,0,0,0,11,16380,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bergrisst - Out of Combat - Cast ''Greater Invisibility''');

-- Plagued Proto-Dragon (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=23680 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=23680;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(23680,0,0,0,23,0,100,0,21862,0,2000,2000,0,11,21862,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Plagued Proto-Dragon - On Has Aura ''Radiation'' - Cast ''Radiation'' (Phase 2)'),
(23680,0,1,0,0,0,100,0,5000,7000,10000,15000,0,11,9573,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Plagued Proto-Dragon - In Combat - Cast ''Flame Breath'' (Phase 2)'),
(23680,0,2,0,25,0,100,0,0,0,0,0,0,11,8876,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Plagued Proto-Dragon - In Combat - Cast ''Thrash'' (Phase 2)');

-- Necro Overlord Mezhen (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=24018 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=24018;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(24018,0,0,0,1,0,100,1,1000,1000,0,0,0,11,43151,2,0,0,0,0,11,24021,30,0,0,0,0,0,0,'Necro Overlord Mezhen - Out of Combat - Cast ''Necrolord: Purple Beam''(No Repeat)'),
(24018,0,1,0,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Necro Overlord Mezhen - Out aggro - say text'),
(24018,0,2,0,0,0,100,0,2000,4000,3000,5000,0,11,32862,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Necro Overlord Mezhen - IC - cast Drain soul'),
(24018,0,3,4,0,0,100,0,8000,11000,15000,20000,0,11,43559,2,0,0,0,0,19,24014,15,1,0,0,0,0,0,'Necro Overlord Mezhen - IC - cast RAISE DEAD'),
(24018,0,4,0,61,0,100,0,0,0,0,0,0,41,0,0,0,0,0,0,19,24014,15,1,0,0,0,0,0,'Necro Overlord Mezhen - IC - Despawn corpse');

-- Rodin Lightning Enabler (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=24883 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=24883;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(24883,0,0,0,1,0,70,0,0,5000,6000,10000,0,11,44788,0,0,0,0,0,19,24876,20,0,0,0,0,0,0,'Rodin Lightning Enabler - Ooc - Cast Rodin''s Lightning Bolt'),
(24883,0,1,0,1,0,70,0,0,5000,6000,10000,0,11,44787,0,0,0,0,0,19,24876,20,0,0,0,0,0,0,'Rodin Lightning Enabler - Ooc - Cast Rodin''s Lightning Bolt'),
(24883,0,2,0,1,0,70,0,0,5000,6000,10000,0,11,44789,0,0,0,0,0,19,24876,20,0,0,0,0,0,0,'Rodin Lightning Enabler - Ooc - Cast Rodin''s Lightning Bolt'),
(24883,0,3,0,1,0,70,0,0,5000,6000,10000,0,11,44791,0,0,0,0,0,19,24876,20,0,0,0,0,0,0,'Rodin Lightning Enabler - Ooc - Cast Rodin''s Lightning Bolt'),
(24883,0,4,0,1,0,70,0,0,5000,6000,10000,0,11,44790,0,0,0,0,0,19,24876,20,0,0,0,0,0,0,'Rodin Lightning Enabler - Ooc - Cast Rodin''s Lightning Bolt');

-- Unleashed Hellion (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=25002 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=25002;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(25002,0,0,0,0,0,100,0,4000,5000,18000,35000,0,11,11876,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Unleashed Hellion - In Combat - Cast ''War Stomp'''),
(25002,0,1,0,0,0,100,0,5000,10000,0,0,0,11,31598,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Unleashed Hellion - In Combat - Cast Rain of Fire');

-- Infected Kodo Beast (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=25596 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=25596;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(25596,0,0,0,25,0,100,0,0,0,0,0,0,11,32423,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On Reset - Cast ''Blue Radiation'''),
(25596,0,1,0,31,0,100,0,45877,0,0,0,0,41,0,0,0,0,0,0,22,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On Target Spellhit ''Deliver Kodo'' - Despawn Instant'),
(25596,0,2,0,0,0,100,0,10000,12000,20000,22000,0,11,45876,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Infected Kodo Beast - In Combat - Cast ''Stampede'''),
(25596,0,3,0,4,0,100,0,0,0,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On Aggro - Remove Flag Standstate Dead'),
(25596,0,4,5,27,0,100,0,0,0,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On Passenger Boarded - Remove Flag Standstate Dead'),
(25596,0,5,6,61,0,100,1,0,0,0,0,0,28,45771,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On Link - Remove Aura ''Scourge Infection'' (No Repeat)'),
(25596,0,6,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On Link - Remove Aura ''Scourge Infection'' (No Repeat)'),
(25596,0,7,8,31,0,100,0,45877,0,0,0,0,11,50630,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On Target Spell Hit ''Deliver Kodo'' - Eject passenger'),
(25596,0,8,9,61,0,100,0,0,0,0,0,0,45,0,1,0,0,0,0,19,25607,20,0,0,0,0,0,0,'Infected Kodo Beast - On Target Spell Hit ''Deliver Kodo'' - Set data'),
(25596,0,9,0,61,0,100,0,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On Target Spell Hit ''Deliver Kodo'' - Despawn Instant'),
(25596,0,10,0,27,0,100,0,0,0,0,0,0,19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On passenger boarded - remove immune to npc'),
(25596,0,11,0,28,0,100,0,0,0,0,0,0,18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Infected Kodo Beast - On passenger removed - Set immune to npc');

-- Steam Burst (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26043 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26043;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26043,0,0,0,1,0,100,0,2000,8000,8000,15000,0,11,46400,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Steam Burst - OOC - Cast Steam Weapon');

-- Leviroth (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26452 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26452;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26452,0,0,0,6,0,100,0,0,0,0,0,0,33,26452,0,0,0,0,0,7,0,0,0,0,0,0,0,0,''),
(26452,0,1,2,8,0,100,0,47170,0,0,0,0,19,768,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Leviroth - On Spellhit (Impale Leviroth) - Remove Unit flags (Immune to PC)'),
(26452,0,2,3,61,0,100,0,0,0,0,0,0,11,46767,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Leviroth - On Spellhit (Impale Leviroth) - Cast Cosmetic - Underwater Blood'),
(26452,0,3,0,61,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Leviroth - On Spellhit (Impale Leviroth) - Start Attack'),
(26452,0,4,0,25,0,100,0,0,0,0,0,0,18,768,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Leviroth - On Reset - Add Unit flags (Immune to NPC and PC)'),
(26452,0,5,0,0,0,100,0,5000,10000,7000,9000,0,11,19643,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Leviroth - In Combat - Cast ''Mortal Strike''');

-- Scourge Hulk (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26555 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26555;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26555,0,0,0,0,0,100,0,5000,7000,15000,17000,0,11,48697,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Scourge Hulk - In Combat - Cast ''Mighty Blow'''),
(26555,0,1,0,0,0,100,0,10000,10000,20000,20000,0,11,59228,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Scourge Hulk - In Combat - Cast ''Volatile Infection''');

-- Drakkari Guardian (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26620 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26620;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26620,0,0,0,25,0,100,6,0,0,0,0,0,2,1965,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Drakkari Guardian - On Reset - Set Faction 1965'),
(26620,0,1,0,1,0,100,6,500,500,1000,1000,0,49,0,0,0,0,0,0,25,20,0,0,0,0,0,0,0,'Drakkari Guardian - Out Of Combat - Start Attacking'),
(26620,0,2,0,2,0,100,6,0,40,5000,10000,0,11,47668,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Drakkari Guardian - Between 0-40% Health - Cast "Heal"'),
(26620,0,3,0,1,0,100,6,1000,1000,1000,1000,0,28,49852,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Drakkari Guardian - Out Of Combat - Remove Aura "Bloody Explosion"'),
(26620,0,4,0,0,0,100,6,1000,1000,1000,1000,0,13,0,100,0,0,0,0,11,26623,30,0,0,0,0,0,0,'Drakkari Guardian - In Combat - Reduce Threat'),
(26620,0,5,0,0,0,100,6,1000,1000,1000,1000,0,13,0,100,0,0,0,0,11,26635,30,0,0,0,0,0,0,'Drakkari Guardian - In Combat - Reduce Threat'),
(26620,0,6,0,0,0,100,6,1000,1000,1000,1000,0,13,0,100,0,0,0,0,11,26636,30,0,0,0,0,0,0,'Drakkari Guardian - In Combat - Reduce Threat'),
(26620,0,7,0,0,0,100,0,1000,6000,7000,12000,0,11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Drakkari Guardian - In Combat - Cast Hamstring'),
(26620,0,8,0,13,0,100,0,8000,9000,0,0,0,11,11972,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Drakkari Guardian - Victim Casting - Cast Shield Bash');

-- Ghoul Tormentor (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26621 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26621;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26621,0,0,0,0,0,100,6,3000,6000,6000,9000,0,11,51917,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ghoul Tormentor - In Combat - Cast Cleave'),
(26621,0,1,0,0,0,100,2,6000,9000,9000,12000,0,11,51917,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ghoul Tormentor - In Combat - Cast Cleave'),
(26621,0,2,0,0,0,100,4,6000,9000,9000,12000,0,11,59007,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ghoul Tormentor - In Combat - Cast Flesh Rot'),
(26621,0,3,0,1,0,100,6,2000,2000,2000,2000,0,86,49852,34,19,26620,5,0,19,26620,5,0,0,0,0,0,0,'Ghoul Tormentor - Out Of Combat - Cast "Bloody Explosion"'),
(26621,0,4,0,0,0,100,2,6000,9000,9000,12000,0,11,49678,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Ghoul Tormentor - In Combat - Cast Flesh Rot');

-- Risen Drakkari Warrior (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26635 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26635;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26635,0,0,0,25,0,100,0,0,0,0,0,0,2,1814,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Drakkari Warrior - On Reset - Set Faction 1814'),
(26635,0,1,0,1,0,100,6,500,500,1000,1000,0,49,0,0,0,0,0,0,25,20,0,0,0,0,0,0,0,'Risen Drakkari Warrior - Out Of Combat - Start Attacking'),
(26635,0,2,0,2,0,100,0,0,40,5000,10000,0,11,47668,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Drakkari Warrior - Between 0-40% Health - Cast "Heal"'),
(26635,0,3,0,0,0,100,6,1000,1000,1000,1000,0,13,0,100,0,0,0,0,11,26620,30,0,0,0,0,0,0,'Risen Drakkari Warrior - In Combat - Reduce Threat'),
(26635,0,4,0,0,0,100,6,1000,1000,1000,1000,0,13,0,100,0,0,0,0,11,26639,30,0,0,0,0,0,0,'Risen Drakkari Warrior - In Combat - Reduce Threat'),
(26635,0,5,0,0,0,100,0,1000,3000,5000,9500,0,11,36093,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Risen Drakkari Warrior - In Combat - Cast Ghost Strike'),
(26635,0,6,0,0,0,100,0,1000,3000,7250,10000,0,11,33661,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Risen Drakkari Warrior - In Combat - Cast Crush Armor'),
(26635,0,7,0,54,0,100,0,0,0,0,0,0,11,48624,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Drakkari Warrior - In Summoned By - Cast Birth Dead Visual');

-- Risen Drakkari Soulmage (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26636 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26636;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26636,0,0,0,25,0,100,0,0,0,0,0,0,2,1814,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - On Reset - Set Faction 1814'),
(26636,0,1,0,1,0,100,6,500,500,1000,1000,0,49,0,0,0,0,0,0,25,20,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - Out Of Combat - Start Attacking'),
(26636,0,2,0,2,0,100,0,0,40,5000,10000,0,11,47668,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - Between 0-40% Health - Cast "Heal"'),
(26636,0,3,0,0,0,100,6,1000,1000,1000,1000,0,13,0,100,0,0,0,0,11,26620,30,0,0,0,0,0,0,'Risen Drakkari Soulmage - In Combat - Reduce Threat'),
(26636,0,4,0,0,0,100,6,1000,1000,1000,1000,0,13,0,100,0,0,0,0,11,26639,30,0,0,0,0,0,0,'Risen Drakkari Soulmage - In Combat - Reduce Threat'),
(26636,0,5,0,0,0,100,2,1000,6000,7000,12000,0,11,49696,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - In Combat - Cast Shadow Blast'),
(26636,0,6,0,0,0,100,4,1000,5000,7000,12000,0,11,59013,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - In Combat - Cast Shadow Blast'),
(26636,0,7,0,0,0,100,0,3000,6000,8900,13500,0,11,35011,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - In Combat - Cast Knockdown'),
(26636,0,8,0,0,0,50,2,2900,6600,10000,12000,0,11,55847,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - In Combat - Cast Shadow Void'),
(26636,0,9,0,0,0,50,4,2900,6600,10000,12000,0,11,59014,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - In Combat - Cast Shadow Void'),
(26636,0,10,0,2,0,100,2,0,75,4000,9000,0,11,49701,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - Between 0-75% Health - Cast Blood Siphon'),
(26636,0,11,0,2,0,100,4,0,75,4000,9000,0,11,59015,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Risen Drakkari Soulmage - Between 0-75% Health - Cast Blood Siphon');

-- Mage Hunter Ascendant (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26727 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26727;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26727,0,0,0,25,0,100,0,0,0,0,0,0,30,1,2,3,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - On Reset - Set Random Event Phase'),
(26727,0,1,0,0,1,100,2,5000,10000,60000,60000,0,11,50182,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Aura of Arcane Haste'),
(26727,0,2,0,0,1,100,4,5000,10000,60000,60000,0,11,56827,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Aura of Arcane Haste'),
(26727,0,3,0,0,1,100,1,0,0,0,0,0,11,35191,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Arcane Explosion Proc'),
(26727,0,4,0,0,1,100,0,3000,6000,30000,40000,0,11,47789,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Arcane Trap'),
(26727,0,5,0,0,1,100,0,3000,6000,5000,10000,0,11,13323,0,0,0,0,0,6,30,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Polymorph'),
(26727,0,6,0,0,2,100,2,0,1000,3000,3500,0,11,12737,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Frostbolt'),
(26727,0,7,0,0,2,100,4,0,1000,3000,3500,0,11,56837,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Frostbolt'),
(26727,0,8,0,0,2,100,2,4000,9000,12000,12500,0,11,15244,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Cone of Cold'),
(26727,0,9,0,0,2,100,4,4000,9000,12000,12500,0,11,38384,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Cone of Cold'),
(26727,0,10,0,0,2,100,0,3000,6000,30000,40000,0,11,55040,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Freezing Trap'),
(26727,0,11,0,0,4,100,2,0,1000,3000,3500,0,11,12466,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Fireball'),
(26727,0,12,0,0,4,100,4,0,1000,3000,3500,0,11,17290,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Fireball'),
(26727,0,13,0,0,4,100,2,4000,9000,22000,25500,0,11,36808,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Rain of Fire'),
(26727,0,14,0,0,4,100,4,4000,9000,22000,25500,0,11,39376,0,0,0,0,0,5,30,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Rain of Fire'),
(26727,0,15,0,0,4,100,0,3000,6000,30000,40000,0,11,47784,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast Immolation Trap'),
(26727,0,31,0,0,1,100,2,4000,6000,8000,11000,0,11,34933,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast ''Arcane Explosion'' (Phase 4) (No Repeat) (Dungeon)'),
(26727,0,32,0,0,1,100,4,4000,6000,8000,11000,0,11,56825,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mage Hunter Ascendant - In Combat - Cast ''Arcane Explosion'' (Phase 4) (No Repeat) (Dungeon)');

-- Crazed Mana-Wraith (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=26746 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=26746;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(26746,0,0,0,0,0,100,6,3000,4000,1000,1500,0,11,33833,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Crazed Mana-Wraith - In Combat - Cast Arcane Missiles'),
(26746,0,1,0,0,0,100,0,0,5000,10000,10000,0,11,33832,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Crazed Mana-Wraith - In Combat - Cast Arcane Missiles'),
(26746,0,2,0,54,0,100,0,0,0,0,0,0,11,51347,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crazed Mana-Wraith - Is Summoned By - Cast Teleport Visual');

-- Bor'gorok Battleguard (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=27073 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=27073;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27073,0,0,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bor''gorok Battleguard - Between 0-30% Health - Cast ''Enrage'' (No Repeat)');

-- High General Abbendis (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=27210 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=27210;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27210,0,3,0,6,0,100,0,0,0,0,0,0,45,1,1,0,0,0,0,19,27951,0,0,0,0,0,0,0,'High General Abbendis - On Death - Set Data 1 1 on Admiral Barean Westwind '),
(27210,0,4,0,7,0,100,0,0,0,0,0,0,45,2,2,0,0,0,0,19,27951,0,0,0,0,0,0,0,'High General Abbendis - On Evade - Set Data 2 2 on Admiral Barean Westwind '),
(27210,0,5,6,4,0,100,0,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'High General Abbendis - On Agro - Store Targetlist'),
(27210,0,6,7,61,0,100,0,0,0,0,0,0,100,1,0,0,0,0,0,19,27951,0,0,0,0,0,0,0,'High General Abbendis - On Agro - Send Target Targetlist to Admiral Barean Westwind'),
(27210,0,7,0,61,0,100,0,0,0,0,0,0,45,3,3,0,0,0,0,19,27951,0,0,0,0,0,0,0,'High General Abbendis - On Agro - Set Data 3 3 on Admiral Barean Westwind'),
(27210,0,8,0,11,0,100,1,0,0,0,0,0,70,0,0,0,0,0,0,10,85322,27951,0,0,0,0,0,0,'High General Abbendis - On Respawn - Respawn Admiral Barean Westwind '),
(27210,0,9,0,4,0,100,1,0,0,0,0,0,11,50908,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'High General Abbendis - On aggro - Cast spell  Seal of Onslaught (50908) on Self'),
(27210,0,10,0,0,0,100,0,4000,7000,19000,23000,0,11,50915,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'High General Abbendis - Cast spell - Raging Consecration (50915) on Victim'),
(27210,0,11,0,0,0,100,0,9000,12000,20000,23000,0,11,50905,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'High General Abbendis-  Cast spell - Judgement of Onslaught  (50905) on Victim'),
(27210,0,12,0,2,0,100,1,0,20,0,0,0,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'When health between 0%-20%% (once) - Set event phase to phase 1'),
(27210,0,13,0,0,1,100,0,0,0,6000,6000,0,11,50921,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'High General Abbendis - Cast spell - Reckless Onslaught (50921) on Self');

-- Argent Crusade Rifleman (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=27351 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=27351;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27351,0,0,1,1,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Out of Combat - Disable Combat Movement (No Repeat)'),
(27351,0,1,0,61,0,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Out of Combat - Stop Attacking (No Repeat)'),
(27351,0,2,3,4,0,100,1,0,0,0,0,0,11,15547,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - On Aggro - Cast ''Shoot'' (No Repeat)'),
(27351,0,3,0,61,0,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - On Aggro - Increment Phase By 1 (No Repeat)'),
(27351,0,4,5,9,1,100,0,5,30,2300,3900,0,11,15547,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 5-30 Range - Cast ''Shoot'' (Phase 1)'),
(27351,0,5,0,61,1,100,0,0,0,0,0,0,40,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 5-30 Range - Set Sheath Ranged (Phase 1)'),
(27351,0,6,7,9,1,100,0,25,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 25-80 Range - Enable Combat Movement (Phase 1)'),
(27351,0,7,0,61,1,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 25-80 Range - Start Attacking (Phase 1)'),
(27351,0,8,9,9,1,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 0-5 Range - Enable Combat Movement (Phase 1)'),
(27351,0,9,10,61,1,100,0,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 0-5 Range - Set Sheath Melee (Phase 1)'),
(27351,0,10,0,61,1,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 0-5 Range - Start Attacking (Phase 1)'),
(27351,0,11,12,9,1,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 5-15 Range - Disable Combat Movement (Phase 1)'),
(27351,0,12,0,61,1,100,0,0,15,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Within 5-15 Range - Stop Attacking (Phase 1)'),
(27351,0,13,0,7,0,100,1,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - On Evade - Set Sheath Melee (Phase 1)'),
(27351,0,14,0,1,0,100,0,1000,15000,15000,22000,0,11,48425,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Argent Crusade Rifleman - Out of Combat - Cast Shoot');

-- Onslaught Footman (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=27405 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=27405;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27405,0,0,1,54,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Onslaught Footman - On Summoned - Set React State Passive'),
(27405,0,1,0,61,0,100,0,0,0,0,0,0,1,0,4000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Onslaught Footman - Linked To Id 0 - Say Line 0'),
(27405,0,2,3,52,0,100,0,0,0,0,0,0,8,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Onslaught Footman - On Text Over 0 - Set React State Defensive'),
(27405,0,3,0,61,0,100,0,0,27405,0,0,0,49,0,0,0,0,0,0,19,27202,10,0,0,0,0,0,0,'Onslaught Footman - Linked To id 2 - Attack Start'),
(27405,0,4,0,38,0,100,0,0,1,0,0,0,41,2000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Onslaught Footman - On Data Set 0 1 - Despawn after 2 sec'),
(27405,0,5,0,0,0,100,0,2000,2000,28000,28000,0,11,50713,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Onslaught Footman - IC - Unrelenting Onslaught');

-- Darkspear Spear Thrower (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=27560 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=27560;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27560,0,0,1,1,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Out of Combat - Disable Combat Movement (No Repeat)'),
(27560,0,1,0,61,0,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Out of Combat - Stop Attacking (No Repeat)'),
(27560,0,2,3,4,0,100,1,0,0,0,0,0,11,6660,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - On Aggro - Cast ''Shoot'' (No Repeat)'),
(27560,0,3,0,61,0,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - On Aggro - Increment Phase By 1 (No Repeat)'),
(27560,0,4,5,9,1,100,0,5,35,2300,3900,0,11,6660,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 5-35 Range - Cast ''Shoot'' (Phase 1)'),
(27560,0,5,0,61,1,100,0,0,0,0,0,0,40,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 5-35 Range - Set Sheath Ranged (Phase 1)'),
(27560,0,6,7,9,1,100,0,30,80,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 30-80 Range - Enable Combat Movement (Phase 1)'),
(27560,0,7,0,61,1,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 30-80 Range - Start Attacking (Phase 1)'),
(27560,0,8,9,9,1,100,0,0,5,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 0-5 Range - Enable Combat Movement (Phase 1)'),
(27560,0,9,10,61,1,100,0,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 0-5 Range - Set Sheath Melee (Phase 1)'),
(27560,0,10,0,61,1,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 0-5 Range - Start Attacking (Phase 1)'),
(27560,0,11,12,9,1,100,0,5,15,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 5-15 Range - Disable Combat Movement (Phase 1)'),
(27560,0,12,0,61,1,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 5-15 Range - Stop Attacking (Phase 1)'),
(27560,0,13,0,9,0,100,0,0,20,9000,14000,0,11,12024,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 0-20 Range - Cast ''Net'' (Phase 1)'),
(27560,0,14,0,7,0,100,1,0,0,0,0,0,40,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - On Evade - Set Sheath Melee (Phase 1)'),
(27560,0,15,16,4,0,100,1,0,0,0,0,0,11,38556,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - On Aggro - Cast ''Throw'' (No Repeat)'),
(27560,0,16,0,61,0,100,0,0,0,0,0,0,23,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - On Aggro - Increment Phase By 1 (No Repeat)'),
(27560,0,17,0,9,1,100,0,5,35,2300,3900,0,11,38556,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darkspear Spear Thrower - Within 5-35 Range - Cast ''Throw'' (Phase 1)');

-- Centrifuge Construct (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=27641 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=27641;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27641,0,0,0,1,0,100,1,0,0,0,0,0,11,50088,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Centrifuge Core - Out of Combat - Cast Energy Link');

-- Darkweb Victim (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=27909 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=27909;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(27909,0,0,0,11,0,100,0,0,0,0,0,0,42,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkweb Victim - On Spawn - Set Invincibility Hp'),
(27909,0,1,0,2,0,100,1,0,1,0,0,0,87,2790900,2790901,2790902,0,0,0,1,0,0,0,0,0,0,0,0,'Darkweb Victim - On 1% HP - Set Random script'),
(27909,0,2,0,6,0,100,0,0,0,0,0,0,11,49960,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkweb Victim - On Death - Cast Summon Random Drakkari');

-- Sparktouched Warrior (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=28111 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=28111;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(28111,0,0,0,0,0,100,0,4000,11000,7000,11000,0,11,54429,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sparktouched Warrior - In Combat - Cast Lightning Whirl'),
(28111,0,1,0,0,0,100,0,8000,20000,15000,31000,0,11,18501,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sparktouched Warrior - In Combat - Cast Enrage');

-- Don Carlos (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=28132 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=28132;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(28132,0,0,0,1,0,100,1,1000,1000,0,0,0,11,50736,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Don Carlos - Out of Combat - Cast Summon Guerrero'),
(28132,0,1,0,0,0,100,2,0,0,2500,2500,0,11,16100,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Don Carlos - In Combat - Cast Shoot'),
(28132,0,2,0,0,0,100,4,0,0,2500,2500,0,11,16496,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Don Carlos - In Combat - Cast Shoot'),
(28132,0,3,0,9,0,100,2,0,20,15000,17000,0,11,12024,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Don Carlos - In Combat - Cast Net'),
(28132,0,4,0,9,0,100,4,0,30,15000,17000,0,11,50762,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Don Carlos - In Combat - Cast Net'),
(28132,0,5,0,9,0,100,2,0,10,20000,20000,0,11,50733,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Don Carlos - In Combat - Cast Scatter Shot'),
(28132,0,6,0,9,0,100,4,0,10,20000,20000,0,11,46681,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Don Carlos - In Combat - Cast Scatter Shot');

-- Greater Ley-Whelp (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=28276 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=28276;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(28276,0,0,0,9,0,100,2,0,20,7000,11000,0,11,51243,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Greater Ley-Whelp - Within 0-20 Range - Cast ''Arcane Bolt'''),
(28276,0,1,0,9,0,100,4,0,20,7000,11000,0,11,59215,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Greater Ley-Whelp - Within 0-20 Range - Cast ''Arcane Bolt'''),
(28276,0,2,0,0,0,100,2,6000,10000,6000,10000,0,11,62249,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Greater Lay-Whelp (Normal) - Cast Arcane Bolt'),
(28276,0,3,0,0,0,100,4,6000,10000,6000,10000,0,11,62250,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Greater Lay-Whelp (Heroic) - Cast Arcane Bolt');

-- Hardened Steel Skycaller (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=28580 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=28580;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(28580,0,0,0,0,0,100,2,0,0,2300,5000,0,11,16100,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Hardened Steel Skycaller - Combat CMC - Cast ''Shoot'' (Normal Dungeon)'),
(28580,0,1,0,0,0,100,4,0,0,2300,5000,0,11,61515,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Hardened Steel Skycaller - Combat CMC - Cast ''Shoot'' (Heroic Dungeon)'),
(28580,0,2,0,0,0,100,2,9000,12000,15000,20000,0,11,52754,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Hardened Steel Skycaller - Combat - Cast ''Impact Shot'' (Normal Dungeon)'),
(28580,0,3,0,0,0,100,2,7000,12000,12000,18000,0,11,52775,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Hardened Steel Skycaller - Combat - Cast ''Impact Multi-Shot'' (Normal Dungeon)'),
(28580,0,4,0,0,0,100,4,9000,12000,15000,20000,0,11,59148,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Hardened Steel Skycaller - Combat - Cast ''Impact Shot'' (Heroic Dungeon)'),
(28580,0,5,0,0,0,100,4,7000,12000,12000,18000,0,11,59147,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Hardened Steel Skycaller - Combat - Cast ''Impact Multi-Shot'' (Heroic Dungeon)'),
(28580,0,6,0,9,0,100,6,0,5,6000,9000,0,11,61507,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hardened Steel Skycaller - 0-5 Range - Cast ''Disengage'' (Dungeon)'),
(28580,0,7,0,0,0,100,2,7000,12000,12000,18000,0,11,52755,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Hardened Steel Skycaller - In Combat - Cast ''Impact Multi-Shot'' (Normal Dungeon)');

-- Blightguard (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=28603 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=28603;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(28603,0,0,0,0,0,100,0,6000,6000,10000,10000,0,11,33914,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Blightguard - In Combat - Cast ''Shadowstrike''');

-- Spirit of Atha (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=29033 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=29033;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(29033,0,0,0,0,0,100,0,8000,13000,12000,16000,0,11,21790,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Spirit of Atha - In Combat - Cast ''Aqua Jet'' (Phase 4)'),
(29033,0,1,0,25,0,100,0,0,0,0,0,0,11,8876,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Spirit of Atha - In Combat - Cast ''Thrash'' (Phase 4)');

-- Ravenous Jaws (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=29392 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=29392;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(29392,0,2,3,8,0,100,0,6509,0,0,0,0,28,47172,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ravenous Jaws - On Spellhit ''Gore Bladder'' - Remove Aura ''Cosmetic - Underwater Blood (no sound)'''),
(29392,0,3,0,61,0,100,0,0,0,0,0,0,33,29391,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Ravenous Jaws - On Spellhit ''Gore Bladder'' - Quest Credit ''Blood in the Water'''),
(29392,0,4,0,0,0,100,0,5000,8000,11000,13500,0,11,12787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ravenous Jaws - In Combat - Cast ''Thrash'''),
(29392,0,5,0,6,0,100,0,0,0,0,0,0,11,47172,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Cosmetic');

-- Ticking Bomb (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=29684 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=29684;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(29684,0,0,0,11,0,100,1,0,0,0,0,0,11,54955,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ticking Bomb - On Respawn - Cast ''Ticking Bomb'' (Phase 1)'),
(29684,0,1,0,0,0,100,1,5500,5500,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ticking Bomb - In Combat - Despawn Instant (Phase 1)'),
(29684,0,2,3,11,0,100,1,0,0,0,0,0,11,54954,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ticking Bomb - On Respawn - Cast ''Explosion'' (No Repeat)'),
(29684,0,3,0,61,0,100,1,0,0,0,0,0,41,2000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ticking Bomb - On Respawn - Despawn In 2000 ms (No Repeat)');

-- Twilight Worshipper (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=30111 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=30111;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30111,0,0,0,0,0,100,2,0,0,3400,4800,0,11,17290,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Worshipper - Combat CMC - Cast ''Fireball'' (Normal Dungeon)'),
(30111,0,1,0,0,0,100,4,0,0,5000,8000,0,11,61567,64,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilight Worshipper - Combat CMC - Cast ''Fireball'' (Heroic Dungeon)'),
(30111,0,2,0,0,0,100,2,9000,12000,14000,17000,0,11,56858,1,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilight Worshipper - Combat - Cast ''Flamestrike'' (Normal Dungeon)'),
(30111,0,3,0,0,0,100,4,9000,12000,14000,17000,0,11,61568,1,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilight Worshipper - Combat - Cast ''Flamestrike'' (Heroic Dungeon)'),
(30111,0,4,0,1,0,100,1,1000,1000,0,0,0,11,56711,32,0,0,0,0,19,30413,5,0,0,0,0,0,0,'Twilight Worshipper - Out of Combat - Cast ''Image Channel'' (No Repeat)'),
(30111,0,5,0,1,0,100,1,1000,1000,0,0,0,11,56713,32,0,0,0,0,19,30413,5,0,0,0,0,0,0,'Twilight Worshipper - Out of Combat - Cast ''Image Channel'' (No Repeat)');

-- Twilight Apostle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=30179 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=30179;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30179,0,0,0,11,0,100,2,0,0,0,0,0,11,12550,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Apostle - On Respawn - Cast ''Lightning Shield'' (No Repeat)'),
(30179,0,1,0,11,0,100,4,0,0,0,0,0,11,61570,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Apostle - On Respawn - Cast ''Lightning Shield'' (No Repeat)'),
(30179,0,2,0,14,0,100,6,10000,40,14000,17000,0,11,11986,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Twilight Apostle - Friendly At 10000 Health - Cast ''Healing Wave'' (No Repeat)'),
(30179,0,3,0,2,0,100,6,0,30,12000,15000,0,11,28902,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Apostle - Between 0-30% Health - Cast ''Bloodlust'' (No Repeat)'),
(30179,0,4,0,1,0,100,1,1000,1000,0,0,0,11,56711,32,0,0,0,0,19,30413,5,0,0,0,0,0,0,'Twilight Apostle - Out of Combat - Cast ''Image Channel'' (No Repeat)'),
(30179,0,5,0,1,0,100,1,1000,1000,0,0,0,11,56713,32,0,0,0,0,19,30413,5,0,0,0,0,0,0,'Twilight Apostle - Out of Combat - Cast ''Image Channel'' (No Repeat)');

-- Twilight Darkcaster (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=30319 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=30319;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(30319,0,0,0,0,0,100,2,0,0,4000,5000,0,11,12739,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Darkcaster - In Combat - Cast ''Shadow Bolt'''),
(30319,0,1,0,0,0,100,4,0,0,5000,7000,0,11,61562,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Darkcaster - In Combat - Cast ''Shadow Bolt'''),
(30319,0,2,0,0,0,100,2,4000,7000,17000,20000,0,11,56898,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilight Darkcaster - In Combat - Cast ''Corruption'''),
(30319,0,3,0,0,0,100,4,4000,7000,17000,20000,0,11,61563,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Twilight Darkcaster - In Combat - Cast ''Corruption'''),
(30319,0,4,0,0,0,100,6,12000,15000,19000,23000,0,11,13338,1,0,0,0,0,6,0,0,0,0,0,0,0,0,'Twilight Darkcaster - In Combat - Cast ''Curse of Tongues'''),
(30319,0,5,0,1,0,100,1,1000,1000,0,0,0,11,56711,32,0,0,0,0,19,30413,5,0,0,0,0,0,0,'Twilight Darkcaster - Out of Combat - Cast ''Image Channel'' (No Repeat)'),
(30319,0,6,0,1,0,100,1,1000,1000,0,0,0,11,56713,32,0,0,0,0,19,30413,5,0,0,0,0,0,0,'Twilight Darkcaster - Out of Combat - Cast ''Image Channel'' (No Repeat)');

-- Scourge Necromancer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=31096 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=31096;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(31096,0,0,0,0,0,100,0,0,0,3400,4700,0,11,20298,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadow Bolt'),
(31096,0,1,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(31096,0,2,0,0,0,100,0,7000,8000,20000,25000,0,11,51337,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadowflame'),
(31096,0,3,0,0,0,100,0,4000,4000,12000,16000,0,11,51338,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadowflame');

-- Wyrm Reanimator (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=31731 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=31731;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(31731,0,0,0,0,0,100,0,5000,9000,15000,15000,0,11,32063,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wyrm Reanimator - In Combat - Cast ''Corruption'''),
(31731,0,1,0,0,0,100,0,1000,1000,3000,4000,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wyrm Reanimator - In Combat - Cast ''Shadow Bolt'''),
(31731,0,2,0,0,0,100,0,4000,7000,16000,22000,0,11,11443,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wyrm Reanimator - In Combat - Cast ''Cripple'''),
(31731,0,3,0,1,1,100,0,0,0,30000,30000,0,11,59661,0,0,0,0,0,19,27047,0,0,0,0,0,0,0,'Wyrm Reanimator - Out of Combat - Cast ''Icecrown Purple Beam'' (Phase 1)'),
(31731,0,5,0,11,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wyrm Reanimator - On Respawn - Set Event Phase 1');

-- Corrupted Blackwood (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=33044 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=33044;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33044,0,0,1,8,0,100,0,62092,0,0,0,0,64,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Blackwood - On SpellHit Blessed Herb Bundle - Store Target List'),
(33044,0,1,2,61,0,100,0,0,0,0,0,0,42,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Blackwood - Linked To Id 0 - Set Invincibility Hp 1'),
(33044,0,2,3,61,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Blackwood - Linked To Id 1 - Set Event Phase 1'),
(33044,0,3,0,61,0,100,0,0,0,0,0,0,100,1,0,0,0,0,0,19,33000,25,0,0,0,0,0,0,'Corrupted Blackwood - Linked To Id 2 - Send Target To Target'),
(33044,0,4,5,38,0,100,0,0,1,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Blackwood - On Data Set 0 1 - Set Faction 35'),
(33044,0,5,6,61,0,100,0,0,0,0,0,0,203,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Blackwood - Linked To Id 4 - Combat Stop'),
(33044,0,6,0,61,0,100,0,0,0,0,0,0,67,33044,3000,3000,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Blackwood - Linked To Id 5 - Create Timed Event'),
(33044,0,7,8,59,0,100,0,33044,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Blackwood - On Timed Event Triggered - Say Line 0'),
(33044,0,8,0,61,0,100,0,0,0,0,0,0,41,5000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Blackwood - Linked To Id 7 - Despawn after 5 sec'),
(33044,0,9,0,0,0,100,0,0,0,3400,4700,0,11,9739,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Corrupted Blackwood - In Combat - Cast ''Wrath'''),
(33044,0,10,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Corrupted Blackwood - Between 0-15% Health - Flee For Assist (No Repeat)'),
(33044,0,11,0,0,0,100,0,4000,5800,12000,14700,0,11,15039,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Corrupted Blackwood - In Combat - Cast ''Flame Shock''');

-- Greymist Tidehunter (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=33262 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=33262;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33262,0,0,0,11,0,100,0,0,0,0,0,0,117,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greymist Tidehunter - On Respawn - Disable Evade'),
(33262,0,1,2,4,0,100,0,0,0,0,0,0,29,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Greymist Tidehunter - On Aggro - Follow Target'),
(33262,0,2,0,61,0,100,0,0,0,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Greymist Tidehunter - Linked To Id 0 - Set Run 1'),
(33262,0,3,0,6,0,100,0,0,0,0,0,0,33,32852,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Greymist Tidehunter - On Death - Quest Credit'),
(33262,0,4,0,0,0,100,0,0,0,2300,3900,0,11,86249,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Greymist Tidehunter - In Combat - Cast ''Throw'''),
(33262,0,5,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Greymist Tidehunter - Between 0-15% Health - Flee For Assist (No Repeat)');

-- Tendril from Below (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=33419 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=33419;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33419,0,0,0,4,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Tendril from Below - On Aggro - Disable Combat Movement (No Repeat)'),
(33419,0,1,0,0,0,100,0,2000,3000,12000,19000,0,11,62975,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tendril from Below - In Combat - Cast ''Shadow Bolt'''),
(33419,0,2,0,0,0,100,0,7000,8000,28000,35000,0,11,78751,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tendril from Below - In Combat - Cast ''Mind Flay''');

-- Twilight Rider (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34282 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=34282;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34282,0,0,0,0,0,100,0,0,0,3400,4700,0,11,65060,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Rider - In Combat - Cast ''Twilight Bolt''');

-- Lord Magmathar (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34295 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=34295;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34295,0,0,0,11,0,100,0,0,0,0,0,0,8,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lord Magmathar - On Respawn - Set React State Defensive'),
(34295,0,1,2,4,0,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lord Magmathar - On Aggro - Auto Attak 0'),
(34295,0,2,0,61,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lord Magmathar - Linked To Id 1 - Allow Combat Movement'),
(34295,0,5,0,6,0,100,0,0,0,0,0,0,45,0,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Lord Magmathar - On Death - Set Data 0 1'),
(34295,0,6,0,8,0,100,0,65214,0,0,0,0,28,65214,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lord Magmathar - On SpellHit Lordly Immolate - Remove Aura Lordly Immolate'),
(34295,0,7,0,1,0,100,0,1000,1000,10000,20000,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lord Magmathar - Out of Combat - Say Line 0'),
(34295,0,8,0,4,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lord Magmathar - On Aggro - Disable Combat Movement (No Repeat)'),
(34295,0,9,0,0,0,100,0,2000,2000,15000,18000,0,11,65214,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lord Magmathar - In Combat - Cast ''Lordly Immolate'''),
(34295,0,10,0,0,0,100,0,4000,5000,17000,20000,0,11,65215,2,0,0,0,0,4,0,0,0,0,0,0,0,0,'Lord Magmathar - In Combat - Cast ''Infernal Conflagration''');

-- Darkscale Priestess (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34415 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=34415;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34415,0,0,0,6,0,100,0,0,0,0,0,0,45,0,3,0,0,0,0,10,245970,24042,0,0,0,0,0,0,'Darkscale Priestess - On Death - Set Data 0 3'),
(34415,0,1,0,0,0,100,0,0,0,3400,4700,0,11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darkscale Priestess - In Combat - Cast ''Frostbolt'''),
(34415,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Darkscale Priestess - Between 0-15% Health - Flee For Assist (No Repeat)'),
(34415,0,3,0,9,0,100,0,0,8,11000,16000,0,11,75062,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkscale Priestess - Within 0-8 Range - Cast ''Frost Nova''');

-- Wyneth (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34846 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=34846;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34846,0,0,1,6,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Wyneth - On Death - Say Line 0'),
(34846,0,1,0,61,0,100,0,0,0,0,0,0,12,3395,6,30000,0,0,0,8,0,0,0,0,-1158.47,-2809.09,92.4256,2.84086,'Wyneth - Linked To Id 0 - Summon Creature Verog the Dervish'),
(34846,0,2,0,0,0,100,0,0,0,3400,4700,0,11,9532,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Wyneth - In Combat - Cast ''Lightning Bolt'''),
(34846,0,3,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Wyneth - Between 0-15% Health - Flee For Assist (No Repeat)'),
(34846,0,4,0,0,0,100,0,5000,7000,18000,26000,0,11,6535,1,0,0,0,0,4,0,0,0,0,0,0,0,0,'Wyneth - In Combat - Cast ''Lightning Cloud''');

-- Invading Tendril (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34917 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=34917;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34917,0,0,0,4,0,100,1,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Invading Tendril - On Aggro - Set Event Phase 1 (No Repeat)'),
(34917,0,1,0,4,1,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Invading Tendril - On Aggro - Disable Combat Movement (Phase 1) (No Repeat)'),
(34917,0,2,0,4,1,100,1,0,0,0,0,0,11,62975,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Invading Tendril - On Aggro - Cast ''Shadow Bolt'' (Phase 1) (No Repeat)'),
(34917,0,3,0,9,1,100,0,5,30,3500,4100,0,11,62975,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Invading Tendril - Within 5-30 Range - Cast ''Shadow Bolt'' (Phase 1)');

-- Invading Crusher (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34961 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=34961;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34961,0,0,0,4,0,100,1,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Invading Crusher - On Aggro - Set Event Phase 1 (No Repeat)'),
(34961,0,1,0,4,1,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Invading Crusher - On Aggro - Disable Combat Movement (Phase 1) (No Repeat)'),
(34961,0,2,0,4,1,100,1,0,0,0,0,0,11,62975,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Invading Crusher - On Aggro - Cast ''Shadow Bolt'' (Phase 1) (No Repeat)'),
(34961,0,3,0,9,1,100,0,5,30,3500,4100,0,11,62975,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Invading Crusher - Within 5-30 Range - Cast ''Shadow Bolt'' (Phase 1)');

-- Servant of Neptulon (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=35842 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=35842;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(35842,0,0,0,6,0,100,0,0,0,0,0,0,33,35843,0,0,0,0,0,16,0,0,0,0,0,0,0,0,'Kill Credit'),
(35842,0,1,0,11,0,100,1,0,0,0,0,0,75,68174,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Neptulon''s Blessing on Spawn'),
(35842,0,2,0,11,0,100,1,0,0,0,0,0,11,68174,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Servant of Neptulon - On Respawn - Cast ''Neptulon''s Blessing'' (No Repeat)'),
(35842,0,3,0,9,0,100,0,0,10,17000,19000,0,11,79571,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Servant of Neptulon - Within 0-10 Range - Cast ''Cone of Cold'''),
(35842,0,4,0,0,0,100,0,2000,4500,21000,25000,0,11,49906,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Servant of Neptulon - In Combat - Cast ''Ice Lance'''),
(35842,0,5,0,0,0,100,0,5000,8000,20000,29000,0,11,78542,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Servant of Neptulon - In Combat - Cast ''Splash''');

-- Lady Silisthra (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=35880 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=35880;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(35880,0,0,1,11,0,100,0,0,0,0,0,0,45,0,1,0,0,0,0,19,35892,30,0,0,0,0,0,0,'Lady Silisthra - On Respawn - Set Data 0 1'),
(35880,0,1,0,61,0,100,0,0,0,0,0,0,11,46933,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Silisthra - Linked To Id 0 - Cast Cosmetic - Arcane Force Shield (Blue)'),
(35880,0,2,3,38,0,100,0,0,1,0,0,0,28,46933,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Silisthra - On Data Set 0 1 - Remove Aura Cast Cosmetic - Arcane Force Shield (Blue)'),
(35880,0,3,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Silisthra - Linked To Id 2 - Say Line 0'),
(35880,0,4,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lady Silisthra - In Combat - Cast ''Shoot'''),
(35880,0,5,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Lady Silisthra - Between 0-15% Health - Flee For Assist (No Repeat)'),
(35880,0,6,0,9,0,100,0,5,30,12000,18000,0,11,15495,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lady Silisthra - Within 5-30 Range - Cast ''Explosive Shot'''),
(35880,0,7,0,0,0,100,0,4000,7000,15000,22000,0,11,20299,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lady Silisthra - In Combat - Cast ''Forked Lightning'''),
(35880,0,8,0,9,0,100,0,5,30,9000,26000,0,11,12551,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lady Silisthra - Within 5-30 Range - Cast ''Frost Shot'''),
(35880,0,9,0,1,0,100,0,500,1000,600000,600000,0,11,15507,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Silisthra - Out of Combat - Cast ''Lightning Shield'''),
(35880,0,10,0,16,0,100,0,15507,1,15000,30000,0,11,15507,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Silisthra - On Friendly Unit Missing Buff ''Lightning Shield'' - Cast ''Lightning Shield''');

-- Lady Vesthra (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=35881 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=35881;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(35881,0,0,1,11,0,100,0,0,0,0,0,0,45,0,1,0,0,0,0,19,35968,30,0,0,0,0,0,0,'Lady Vesthra - On Respawn - Set Data 0 1'),
(35881,0,1,0,61,0,100,0,0,0,0,0,0,11,68268,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Vesthra - Linked To Id 0 - Cast Cosmetic - Arcane Force Shield (Blue)'),
(35881,0,2,3,38,0,100,0,0,1,0,0,0,28,68268,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Vesthra - On Data Set 0 1 - Remove Aura Cast Cosmetic - Arcane Force Shield (Blue)'),
(35881,0,3,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Vesthra - Linked To Id 2 - Say Line 0'),
(35881,0,4,0,0,0,100,0,0,0,3400,4700,0,11,9672,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lady Vesthra - In Combat - Cast ''Frostbolt'''),
(35881,0,5,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Lady Vesthra - Between 0-15% Health - Flee For Assist (No Repeat)'),
(35881,0,6,0,9,0,100,0,0,8,13600,14500,0,11,11831,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Vesthra - Within 0-8 Range - Cast ''Frost Nova'''),
(35881,0,7,0,9,0,100,0,0,25,15000,18000,0,11,21067,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lady Vesthra - Within 0-25 Range - Cast ''Poison Bolt'''),
(35881,0,8,0,0,0,100,0,4000,5000,14500,15800,0,11,38663,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Lady Vesthra - In Combat - Cast ''Slow'''),
(35881,0,9,0,9,0,100,0,0,15,25000,28000,0,11,81039,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Lady Vesthra - Within 0-15 Range - Cast ''Toxic Nova''');

-- Enraged Kodo (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=36094 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=36094;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(36094,0,0,1,75,0,100,1,0,36079,20,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Kodo'),
(36094,0,1,0,61,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,11,36079,20,0,0,0,0,0,0,'Enraged Kodo'),
(36094,0,2,3,34,0,100,0,0,1,0,0,0,45,1,0,0,0,0,0,11,36079,2,0,0,0,0,0,0,'Enraged Kodo'),
(36094,0,3,0,61,0,100,0,0,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Kodo'),
(36094,0,4,0,0,0,100,0,4000,5000,18000,22000,0,11,5568,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Kodo - In Combat - Cast ''Trample'''),
(36094,0,5,0,2,0,100,1,0,30,0,0,0,11,18501,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Kodo - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(36094,0,6,8,38,0,100,0,1,0,0,0,0,29,1,0,36079,1,1,0,19,36079,30,0,0,0,0,0,0,'Enraged Kodo - On Data Set 1 0 - Start Follow Closest Creature ''Enraged Kodo KC Bunny'''),
(36094,0,7,9,65,0,100,0,0,0,0,0,0,86,68331,0,18,35,0,0,1,20,0,0,0,0,0,0,0,'Enraged Kodo - On Follow Complete - Cross Cast ''Kill Credit'''),
(36094,0,8,0,61,0,100,0,1,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Kodo - On Data Set 1 0 - Set Reactstate Passive'),
(36094,0,9,10,61,0,100,0,0,0,0,0,0,5,33,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Kodo - On Follow Complete - Play Emote 33'),
(36094,0,10,11,61,0,100,0,0,0,0,0,0,12,36113,3,120000,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Kodo - On Follow Complete - Summon Creature ''Pacified Kodo'''),
(36094,0,11,0,61,0,100,0,0,0,0,0,0,41,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Enraged Kodo - On Follow Complete - Despawn In 1 ms');

-- Bingham Gadgetspring (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=36407 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=36407;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(36407,0,0,0,0,0,100,0,5000,8000,28000,37000,0,11,8209,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bingham Gadgetspring - In Combat - Cast ''Explosive Sheep'''),
(36407,0,1,0,4,0,100,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bingham Gadgetspring - On Aggro - Say Line 0 (No Repeat)');

-- Ymirjar Wrathbringer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=36840 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=36840;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(36840,0,0,0,60,0,100,65537,0,0,0,0,0,11,50142,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On Update - Cast Emerge'),
(36840,0,1,0,0,0,100,0,2000,7000,8000,15000,0,11,69603,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Blight');

-- High Priestess Silthera (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=36873 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=36873;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(36873,0,0,0,11,0,100,0,0,0,0,0,0,11,69456,0,0,0,0,0,19,36868,10,0,0,0,0,0,0,'High Priestess Silthera - On Respawn - Cast Subjugation'),
(36873,0,1,0,0,0,100,0,0,0,3400,4700,0,11,9734,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'High Priestess Silthera - In Combat - Cast ''Holy Smite'''),
(36873,0,2,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'High Priestess Silthera - Between 0-15% Health - Flee For Assist (No Repeat)'),
(36873,0,3,0,0,0,100,0,5000,7000,25000,28000,0,11,11639,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'High Priestess Silthera - In Combat - Cast ''Shadow Word: Pain''');

-- Talrendis Glaive Thrower (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=36890 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=36890;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(36890,0,0,0,4,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Talrendis Glaive Thrower - On Aggro - Disable Combat Movement (No Repeat)'),
(36890,0,1,0,0,0,100,0,2000,3000,5000,5000,0,11,69517,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Talrendis Glaive Thrower - In Combat - Cast ''Throw Glaive''');

-- Grit (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=36972 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=36972;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(36972,0,0,0,9,0,100,0,8,40,4000,6000,0,11,69375,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Grit - Within 8-40 Range - Cast ''Lob Fire'''),
(36972,0,1,0,0,0,100,0,5000,7000,15000,22000,0,11,69359,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Grit - In Combat - Cast ''Flamethrower''');

-- Crucible of Souls (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=37094 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=37094;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(37094,0,0,1,8,0,0,0,69922,0,0,0,0,11,70663,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Crucible of Souls - On Spellhit ''Temper Quel''Delar'' - Cast ''Shadow Nova'''),
(37094,0,1,0,61,0,0,0,69922,0,0,0,0,11,69956,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Crucible of Souls - On Spellhit ''Temper Quel''Delar'' - Cast ''Return Tempered Quel''Delar'''),
(37094,0,2,0,25,0,100,0,0,0,0,0,0,11,69859,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On Reset - Aura self');

-- Covert Ops Pounder (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=38649 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=38649;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(38649,0,0,0,0,0,100,0,7000,8500,18500,21600,0,11,35049,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Covert Ops Pounder - In Combat - Cast ''Pound''');

-- Twilight Flamecaller (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=38926 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=38926;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(38926,0,0,0,0,0,100,0,0,0,3400,4700,0,11,15536,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 0 and 0 ms (and later repeats every 3400 and 4700 ms) - Self: Cast spell 15536 on Victim // Twilight Flamecaller - In Combat - Cast ''Fireball'''),
(38926,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'When health between 0% and 15% (check every 0 - 0 ms) - Self: Flee for assist // Twilight Flamecaller - Between 0-15% Health - Flee For Assist (No Repeat)'),
(38926,0,2,0,0,0,100,0,3000,6000,11000,12000,0,11,20794,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 3000 and 6000 ms (and later repeats every 11000 and 12000 ms) - Self: Cast spell 20794 on Victim // Twilight Flamecaller - In Combat - Cast ''Flamestrike'''),
(38926,0,3,0,0,0,100,0,9000,9000,21000,22000,0,11,11990,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 9000 and 9000 ms (and later repeats every 21000 and 22000 ms) - Self: Cast spell 11990 on Victim // Twilight Flamecaller - In Combat - Cast ''Rain of Fire'''),
(38926,0,4,0,1,0,100,0,1000,1000,5000,5000,0,49,0,0,0,0,0,0,11,38915,10,0,0,0,0,0,0,'When out of combat and timer at the begining between 1000 and 1000 ms (and later repeats every 5000 and 5000 ms) - Self: Attack Creature Hyjal Warden (38915) in 10 yd // ');

-- Northwatch Scout (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=39317 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=39317;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39317,0,0,0,11,0,100,0,0,0,0,0,0,75,58506,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Northwatch Scout - On respawn - Add Aura Stealth'),
(39317,0,1,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Northwatch Scout - In Combat - Cast ''Shoot'''),
(39317,0,2,0,7,0,100,1,0,0,0,0,0,11,58506,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Northwatch Scout - On Evade - Cast ''Stealth'' (No Repeat)'),
(39317,0,3,0,9,0,100,0,0,10,15000,22000,0,11,79584,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Northwatch Scout - Within 0-10 Range - Cast ''Fan of Knives''');

-- Venomous Skitterer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=39440 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=39440;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39440,0,0,0,0,0,100,0,2400,2400,15000,16000,0,11,75158,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Update (In Combat) 2400 min and 2400 max ms (repeat 15000 min 16000 max ms) - Self: Cast spell Surge (75158) on Random hostile // '),
(39440,0,1,0,0,0,100,0,4000,5000,17000,19000,0,11,74121,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Update (In Combat) 4000 min and 5000 max ms (repeat 17000 min 19000 max ms) - Self: Cast spell Debilitating Venom (74121) on Victim // '),
(39440,0,2,0,0,0,100,0,9000,10000,30000,31000,0,11,73963,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Update (In Combat) 9000 min and 10000 max ms (repeat 30000 min 31000 max ms) - Self: Cast spell Blinding Toxin (73963) on Victim // ');

-- Runty (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40015 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40015;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40015,0,0,0,0,0,100,0,6000,9000,15000,20000,0,11,76628,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Runty - In Combat - Cast ''Lava Drool'''),
(40015,0,1,0,0,0,100,0,0,0,2300,3900,0,11,76665,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Runty - In Combat - Cast ''Little Big Flame Breath''');

-- Twilight Element Warden (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40017 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40017;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40017,0,0,0,0,0,100,6,4000,5000,12000,13000,0,11,76680,0,0,0,0,0,4,0,0,0,0,0,0,0,0,'Twilight Element Warden - In Combat - Cast Chain Lightning'),
(40017,0,1,0,9,0,100,6,0,20,9000,10000,0,11,76677,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Element Warden - On Close - Cast Fire Blast'),
(40017,0,2,0,0,0,100,6,3000,4000,10000,15000,0,11,58025,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Element Warden - In Combat - Cast Frost Buffet'),
(40017,0,3,0,9,0,100,6,0,40,15000,18000,0,11,76682,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Element Warden - On Close - Cast Frostbomb'),
(40017,0,4,0,1,0,100,0,200,300,4000,5000,0,11,75205,0,0,0,0,0,19,40343,200,0,0,0,0,0,0,'Twilight Element Warden - Out of Combat - Cast ''Bore''');

-- Defiled Earth Rager (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40023 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40023;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40023,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,76716,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Defiled Earth Rager - In Combat - Cast ''Bludgeoning Strike'''),
(40023,0,1,0,0,0,100,0,6000,9000,15000,20000,0,11,76717,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Defiled Earth Rager - In Combat - Cast ''Meteor''');

-- Blistering Scarab (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40310 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40310;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40310,0,0,0,0,0,100,0,4000,4000,3500,4000,0,11,74122,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Update (In Combat) 4000 min and 4000 max ms (repeat 3500 min 4000 max ms) - Self: Cast spell Corrosive Spray (74122) on Self // '),
(40310,0,1,0,0,0,100,0,7000,8000,10000,11000,0,11,74542,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Update (In Combat) 7000 min and 8000 max ms (repeat 10000 min 11000 max ms) - Self: Cast spell Serrated Slash (74542) on Victim // ');

-- Dustbone Tormentor (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40311 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40311;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40311,0,0,0,0,0,100,0,6000,6000,43000,45000,0,11,77357,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Update (In Combat) 6000 min and 6000 max ms (repeat 43000 min 45000 max ms) - Self: Cast spell Curse of Exhaustion (77357) on Random hostile // '),
(40311,0,1,0,0,0,100,0,7000,7000,2400,2400,0,11,77570,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Update (In Combat) 7000 min and 7000 max ms (repeat 2400 min 2400 max ms) - Self: Cast spell Shadow Bolt (77570) on Victim // ');

-- Twilight Stormwaker (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40573 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40573;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40573,0,0,0,0,0,100,0,0,0,3400,4700,0,11,65060,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Stormwaker - In Combat - Cast ''Twilight Bolt''');

-- Krom'gar Peon (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40904 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40904;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40904,0,0,1,4,0,100,1,0,0,0,0,0,11,76565,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Krom''gar Peon - On Aggro - Cast ''Throw Iron Ore'' (No Repeat)'),
(40904,0,1,0,61,0,100,1,0,0,0,0,0,11,76576,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Krom''gar Peon - On Aggro - Cast ''Clear Summoned Ore'' (No Repeat)');

-- Snapjaw Grouper (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40912 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40912;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40912,0,0,0,0,0,100,0,5000,8000,12000,15000,0,11,79442,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Snapjaw');

-- Den Whomper (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=40959 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=40959;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(40959,0,0,1,8,0,100,0,76488,0,0,0,0,2,35,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Den Whomper - On SpellHit Fake Treasure - Set Faction 35'),
(40959,0,1,2,61,0,100,0,0,0,0,0,0,203,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Den Whomper - Linked To Id 0 - Combat Stop'),
(40959,0,2,3,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Den Whomper - Linked To Id 1 - Say Line Random'),
(40959,0,3,0,61,0,100,0,0,0,0,0,0,41,5000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Den Whomper - Linked To Id 2 - Despawn after 5 sec'),
(40959,0,4,0,4,0,25,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Den Whomper - On Aggro - Say Line 0 (No Repeat)'),
(40959,0,5,0,9,0,100,0,0,5,15000,17000,0,11,80182,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Den Whomper - Within 0-5 Range - Cast ''Uppercut'''),
(40959,0,6,0,2,0,100,0,0,60,14000,16000,0,11,4955,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Den Whomper - Between 0-60% Health - Cast ''Fist of Stone'''),
(40959,0,7,0,2,0,100,0,0,30,32000,35000,0,11,21049,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Den Whomper - Between 0-30% Health - Cast ''Bloodlust''');

-- Naz'jar Spiritmender (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=41139 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=41139;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(41139,0,0,0,2,0,100,0,0,40,15000,20000,0,11,76813,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Naz''jar Spiritmender - Between 0-40% Health - Cast ''Healing Wave'''),
(41139,0,1,0,0,0,100,0,3000,6000,18000,24000,0,11,76820,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Naz''jar Spiritmender - In Combat - Cast ''Hex''');

-- Azsh'ir Infantry (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=41227 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=41227;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(41227,0,0,0,0,0,100,0,0,0,3500,4100,0,11,61168,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Throw'),
(41227,0,1,0,9,0,100,0,0,30,15000,20000,0,11,79449,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Body Slam on Close');

-- Frostmane Builder (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=41251 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=41251;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(41251,0,0,0,11,0,100,0,0,0,0,0,0,17,173,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Frostmane Builder - on spawn - set emote state (173)'),
(41251,0,1,0,8,0,100,1,93773,0,0,0,0,80,4125100,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Frostmane Builder - on spell hit (93773) - run actionlist'),
(41251,0,2,0,0,0,100,0,0,0,2300,3900,0,11,38557,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Frostmane Builder - In Combat - Cast ''Throw'''),
(41251,0,3,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Frostmane Builder - Between 0-15% Health - Flee For Assist (No Repeat)'),
(41251,0,4,0,9,0,100,0,0,5,18000,19000,0,11,58461,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Frostmane Builder - Within 0-5 Range - Cast ''Sunder Armor''');

-- Tentacle Horror (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=41641 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=41641;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(41641,0,0,0,4,0,100,1,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stop Moving on Aggro'),
(41641,0,1,0,0,0,100,0,2000,3000,12000,19000,0,11,78331,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadow Bolt');

-- Taken Gilblin (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=41729 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=41729;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(41729,0,0,0,0,0,100,0,5000,8000,12000,15000,0,11,79544,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Psionic Overload');

-- Luxscale Grouper (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=41923 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=41923;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(41923,0,0,0,0,0,100,0,3000,4500,20000,22000,0,11,79559,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Luxscale Light');

-- Revantusk Stalker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=42536 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=42536;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(42536,0,0,1,8,0,100,0,79402,0,0,0,0,33,42597,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Revantusk Stalker - On SpellHit Revantusk Drums - Quest Credit'),
(42536,0,1,2,61,0,100,0,0,0,0,0,0,11,95966,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Revantusk Stalker - Linked To Id 0 - Cast Recently Enraged'),
(42536,0,2,0,61,0,100,0,0,0,0,0,0,11,56646,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Revantusk Stalker - Linked To Id 1 - Cast Enrage'),
(42536,0,3,0,2,0,100,1,0,30,0,0,0,11,56646,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Revantusk Stalker - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(42536,0,4,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Revantusk Stalker - Between 0-30% Health - Say Line 0 (No Repeat)'),
(42536,0,5,0,0,0,100,0,5000,7000,16000,18000,0,11,80182,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Revantusk Stalker - In Combat - Cast ''Uppercut''');

-- Revantusk Hexxer (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=42555 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=42555;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(42555,0,0,1,8,0,100,0,79402,0,0,0,0,33,42597,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Revantusk Hexxer - On SpellHit Revantusk Drums - Quest Credit'),
(42555,0,1,2,61,0,100,0,0,0,0,0,0,11,95966,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Revantusk Hexxer - Linked To Id 0 - Cast Recently Enraged'),
(42555,0,2,0,61,0,100,0,0,0,0,0,0,11,56646,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Revantusk Hexxer - Linked To Id 1 - Cast Enrage'),
(42555,0,3,0,0,0,100,0,0,0,3400,4700,0,11,9613,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Revantusk Hexxer - In Combat - Cast ''Shadow Bolt'''),
(42555,0,4,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Revantusk Hexxer - Between 0-15% Health - Flee For Assist (No Repeat)'),
(42555,0,5,0,0,0,100,0,7000,8000,30000,33000,0,11,18267,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Revantusk Hexxer - In Combat - Cast ''Curse of Weakness'''),
(42555,0,6,0,0,0,100,0,11000,12000,18000,20000,0,11,16568,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Revantusk Hexxer - In Combat - Cast ''Mind Flay''');

-- Bilgewater Foreman (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=42777 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=42777;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(42777,0,0,0,64,0,100,0,0,0,0,0,0,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On player opened gossip - Self: Set faction to 14'),
(42777,0,1,0,6,0,100,0,0,0,0,0,0,33,42798,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On death - Loot recipient: Give kill credit Bilgewater Foreman (42798)'),
(42777,0,2,0,6,0,100,0,0,0,0,0,0,70,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Respawn on death'),
(42777,0,3,0,0,0,100,0,5000,7000,17000,22000,0,11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bilgewater Foreman - In Combat - Cast ''Strike'''),
(42777,0,4,0,9,0,100,0,0,5,15000,19000,0,11,15284,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bilgewater Foreman - Within 0-5 Range - Cast ''Cleave''');

-- Plague Ghoul (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=42975 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=42975;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(42975,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,40505,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Plague Ghoul - In Combat - Cast ''Cleave'''),
(42975,0,1,0,2,0,100,1,0,30,0,0,0,11,8599,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Plague Ghoul - Between 0-30% Health - Cast ''Enrage'' (No Repeat)'),
(42975,0,2,0,0,0,100,0,6000,8000,12000,16000,0,11,16458,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Plague Ghoul - In Combat - Cast ''Ghoul Plague''');

-- Freewheelin' Juntz Fitztittle (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=43376 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=43376;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(43376,0,0,0,11,0,100,0,0,0,0,0,0,17,173,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - On Respawn - Set Emote State'),
(43376,0,1,2,62,0,100,0,11735,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - On Gossip Select - Store Target List'),
(43376,0,2,3,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 1 - Close Gossip'),
(43376,0,3,4,61,0,100,0,0,0,0,0,0,2,72,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 2 - Set Faction 72'),
(43376,0,4,5,61,0,100,0,0,0,0,0,0,83,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 3 - Remove NpcFlag 1'),
(43376,0,5,6,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 4 - Say Line 0'),
(43376,0,6,7,61,0,100,0,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 5 - Set React Aggressive'),
(43376,0,7,8,61,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 6 - Attack Start'),
(43376,0,8,0,61,0,100,0,0,0,0,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 7 - Set Emote State'),
(43376,0,9,10,7,0,100,0,0,0,0,0,0,17,173,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - On Evade - Set Emote State'),
(43376,0,10,11,61,0,100,0,0,0,0,0,0,2,2159,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 9 - Set Faction 2159'),
(43376,0,11,0,61,0,100,0,0,0,0,0,0,81,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Freewheelin'' Juntz Fitztittle - Linked To Id 10 - Set NpcFlag 1'),
(43376,0,12,0,0,0,100,0,0,0,3500,4100,0,11,38558,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Throw'),
(43376,0,13,0,2,0,100,1,0,15,0,0,0,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Flee at 15% HP'),
(43376,0,14,0,0,0,100,0,5000,5000,12000,13000,0,11,54962,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Ticking Bomb');

-- Stonecore Berserker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=43430 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=43430;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(43430,0,0,0,0,0,100,0,0,0,10000,10000,0,11,81574,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'Stonecore Warbringer - In Combat - Cast ''Charge'''),
(43430,0,1,0,0,0,100,0,10000,15000,10000,20000,0,11,81568,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Warbringer - In Combat - Cast ''Spinning Slash''');

-- Stonecore Earthshaper (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=43537 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=43537;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(43537,0,0,1,25,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - On Reset - Set Phase 1'),
(43537,0,1,0,61,0,100,0,0,0,0,0,0,3,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - Linked - Demorph'),
(43537,0,2,0,0,1,100,0,3000,3000,10000,15000,0,11,81576,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - In Combat (Phase 1) - Cast ''Lava Burst'''),
(43537,0,3,4,0,1,100,0,9000,9000,12000,12000,0,11,81459,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - In Combat (Phase 1) - Cast ''Force of Earth'''),
(43537,0,4,0,61,1,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - Linked - Say Text 0'),
(43537,0,5,0,0,1,100,0,15000,15000,10000,15000,0,11,81530,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - In Combat (Phase 1) - Cast ''Ground Shock'''),
(43537,0,6,7,8,1,100,1,81459,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - Hit by ''Force of Earth'' (Phase 1) - Set Phase 2'),
(43537,0,7,0,61,1,100,1,81459,0,0,0,0,3,26693,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - Linked - Morph'),
(43537,0,8,0,0,2,100,0,5000,5000,15000,15000,0,11,81463,64,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - In Combat (Phase 2) - Cast ''Dust Storm'''),
(43537,0,9,0,6,0,100,0,0,0,0,0,0,3,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stonecore Earthshaper - On Death - Demorph');

-- Bloodsail Corsair (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=43636 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=43636;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(43636,0,0,1,62,0,100,0,11755,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bloodsail Corsair - On Gossip Select - Store Target List'),
(43636,0,1,2,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bloodsail Corsair - Linked To Id 0 - Close Gossip'),
(43636,0,2,3,61,0,100,0,0,0,0,0,0,1,0,1000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodsail Corsair - Linked To Id 1 - Say Line Random'),
(43636,0,3,0,61,0,100,0,0,0,0,0,0,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodsail Corsair -Linked To Id 2 - Set Faction 14'),
(43636,0,4,0,52,0,100,0,0,43636,0,0,0,49,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Bloodsail Corsair - On Text Over 0 - Attack Start'),
(43636,0,5,0,0,0,100,0,9000,9000,18000,25000,0,11,6713,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Disarm'),
(43636,0,6,0,13,0,100,0,20000,30000,0,0,0,11,11978,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Kick on Player Spell Cast');

-- Stitches (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=43862 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=43862;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(43862,0,0,0,11,0,100,1,0,0,0,0,0,11,3106,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stitches - On Respawn - Cast ''Aura of Rot'' (No Repeat)');

-- Dark Ranger (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=44632 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=44632;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(44632,0,0,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dark Ranger - In Combat - Cast ''Shoot'''),
(44632,0,1,0,0,0,100,0,6000,9000,18000,22000,0,11,80009,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dark Ranger - In Combat - Cast ''Serpent Sting'''),
(44632,0,2,0,9,0,100,0,0,5,66000,67000,0,11,22910,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dark Ranger - Within 0-5 Range - Cast ''Immolation Trap''');

-- Fronkle the Disturbed (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=44714 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=44714;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(44714,0,0,0,9,0,100,0,0,8,14500,15200,0,11,22938,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Fronkle the Disturbed - Within 0-8 Range - Cast ''Arcane Explosion'''),
(44714,0,1,0,0,0,100,0,6000,8000,15000,18000,0,11,34447,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Fronkle the Disturbed - In Combat - Cast ''Arcane Missiles'''),
(44714,0,2,0,0,0,100,0,4000,4800,13000,14000,0,11,79880,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Fronkle the Disturbed - In Combat - Cast ''Slow''');

-- Dreadguard (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=44911 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=44911;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(44911,0,0,0,0,0,100,0,0,0,2300,3900,0,11,95826,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dreadguard - In Combat - Cast ''Shoot''');

-- Maziel (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=44967 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=44967;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(44967,0,0,0,0,0,100,0,5000,8000,12000,16000,0,11,30451,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Maziel - In Combat - Cast ''Arcane Blast'''),
(44967,0,1,0,0,0,100,0,10000,13000,15000,19000,0,11,421,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Maziel - In Combat - Cast ''Chain Lightning''');

-- Bonesnapper Scorpid (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45063 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45063;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45063,0,0,0,0,0,100,0,0,0,2300,3900,0,11,84125,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bonesnapper Scorpid - In Combat - Cast ''Paralytic Venom''');

-- Opengut Behemoth (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45098 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45098;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45098,0,0,0,0,0,100,0,5000,8000,12000,15000,0,11,40504,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Cleave'),
(45098,0,1,0,9,0,100,0,8,40,10000,12000,0,11,50335,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Scourge Hook on Close');

-- Magus Bisp (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45152 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45152;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45152,0,0,1,62,0,100,0,11942,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'q27154'),
(45152,0,1,2,61,0,100,0,0,0,0,0,0,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Magus Bisp - make agressive'),
(45152,0,2,0,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Magus Bisp - close gossip menu'),
(45152,0,3,0,0,0,100,0,5000,8000,12000,15000,0,11,79880,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Slow'),
(45152,0,4,0,0,0,100,0,0,0,3400,4700,0,11,79868,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Arcane Blast'),
(45152,0,5,0,9,0,100,0,0,8,15000,25000,0,11,22938,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Arcane Explosion on Close');

-- Withdrawn Soul (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45166 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45166;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45166,0,0,1,8,0,100,1,84375,0,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Withdrawn Soul - spellhit -despawn'),
(45166,0,1,0,61,0,100,1,0,0,0,0,0,33,45166,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Withdrawn Soul - at despawn - credit'),
(45166,0,2,0,0,0,100,0,5000,8000,12000,15000,0,11,85424,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Spirit Burst');

-- Diamond-Blade Shredder (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45185 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45185;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45185,0,0,0,0,0,100,0,5000,8000,12000,16000,0,11,32735,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Diamond-Blade Shredder - In Combat - Cast ''Saw Blade''');

-- Mangy Hyena (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45202 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45202;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45202,0,0,0,0,0,100,0,5000,8000,12000,12000,0,11,85415,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 5000 and 8000 ms (and later repeats every 12000 and 12000 ms) - Self: Cast spell Mangle (85415) on Victim // Mangy Hyena - In Combat - Cast ''Mangle'''),
(45202,0,1,0,6,0,100,0,0,0,0,0,0,11,84437,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'On death - Self: Cast spell Launch Quest (84437) on Self // ');

-- Skarf (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45204 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45204;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45204,0,0,0,0,0,100,0,5000,5000,12000,13500,0,11,85835,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Skarf - In Combat - Cast ''Maul'''),
(45204,0,1,0,9,0,100,0,5,15,15800,18300,0,11,44531,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Skarf - Within 5-15 Range - Cast ''Dash''');

-- Sultan Oogah (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45205 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45205;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45205,0,0,0,0,0,100,0,0,0,2300,3900,0,11,87341,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Sultan Oogah - In Combat - Cast ''Blow Dart'''),
(45205,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Sultan Oogah - Between 0-15% Health - Flee For Assist (No Repeat)'),
(45205,0,2,0,0,0,100,0,8000,8000,22500,23800,0,11,87322,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sultan Oogah - In Combat - Cast ''Veil of Shimmering Sand''');

-- Caretaker Smithers (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45219 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45219;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45219,0,0,0,2,0,100,1,0,30,0,0,0,11,81173,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Caretaker Smithers - Between 0-30% Health - Cast ''Frenzy'' (No Repeat)'),
(45219,0,1,0,2,0,100,1,0,30,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Caretaker Smithers - Between 0-30% Health - Say Line 0 (No Repeat)'),
(45219,0,2,0,4,0,100,1,0,0,0,0,0,11,81764,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Caretaker Smithers - On Aggro - Cast ''Throw Lantern'' (No Repeat)'),
(45219,0,3,0,0,0,100,0,4000,8000,15000,17500,0,11,81767,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Caretaker Smithers - In Combat - Cast ''Lantern Blaze''');

-- Darkmist Broodqueen (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45227 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45227;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45227,0,0,0,0,0,100,0,3000,3500,14000,15000,0,11,69964,32,0,0,0,0,2,0,0,0,0,0,0,0,0,'Darkmist Broodqueen - In Combat - Cast ''Poison''');

-- Forsaken Vanguard (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45280 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45280;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45280,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,9080,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Vanguard - In Combat - Cast ''Hamstring'''),
(45280,0,1,0,0,0,100,0,6000,8000,12000,16000,0,11,32736,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Vanguard - In Combat - Cast ''Mortal Strike''');

-- Worgen Rebel (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45292 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45292;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45292,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,79878,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Worgen Rebel - In Combat - Cast ''Bloodthirst'''),
(45292,0,1,0,0,0,100,0,5000,7000,12000,15000,0,11,79881,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Worgen Rebel - In Combat - Cast ''Slam''');

-- Worgen Rusher (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45375 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45375;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45375,0,0,0,9,0,100,0,8,25,15000,20000,0,11,75002,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Worgen Rusher - Within 8-25 Range - Cast ''Leaping Rush''');

-- Forsaken Sharpshooter (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45376 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45376;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45376,0,0,0,0,0,100,0,5000,8000,10000,14000,0,11,80012,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Sharpshooter - In Combat - Cast ''Chimera Shot'''),
(45376,0,1,0,0,0,100,0,6000,9000,15000,20000,0,11,79721,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Sharpshooter - In Combat - Cast ''Explosive Shot'''),
(45376,0,2,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Sharpshooter - In Combat - Cast ''Shoot''');

-- Tentacle of Iso'rath (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45394 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45394;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45394,0,0,0,0,0,100,0,6000,9000,15000,20000,0,11,89918,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Tentacle of Iso''rath - In Combat - Cast ''Thwomp''');

-- Master Sergeant Pietro Zaren (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45405 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45405;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45405,0,0,0,9,0,100,0,0,8,12000,18000,0,11,79970,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Master Sergeant Pietro Zaren - Within 0-8 Range - Cast ''Divine Storm'''),
(45405,0,1,0,0,0,100,0,4000,6000,12000,15000,0,11,79971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Master Sergeant Pietro Zaren - In Combat - Cast ''Hammer of Wrath'''),
(45405,0,2,0,1,0,100,0,1000,2000,30000,30000,0,11,79976,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Master Sergeant Pietro Zaren - Out of Combat - Cast ''Retribution Aura'''),
(45405,0,3,0,4,0,100,0,0,0,0,0,0,85,84870,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Master Sergeant Pietro Zaren - On Aggro - Invoker Cast Start Quest: Master Sergeant Zaren');

-- Worgen Rusher (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45535 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45535;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45535,0,0,0,9,0,100,0,8,25,15000,20000,0,11,75002,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Worgen Rusher - Within 8-25 Range - Cast ''Leaping Rush''');

-- Watcher Eva (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45740 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45740;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45740,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,57846,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Watcher Eva - In Combat - Cast ''Heroic Strike'''),
(45740,0,1,0,9,0,100,0,0,8,12000,18000,0,11,34322,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Watcher Eva - Within 0-8 Range - Cast ''Psychic Scream'''),
(45740,0,2,0,0,0,100,0,4000,7000,12000,16000,0,11,81764,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Watcher Eva - In Combat - Cast ''Throw Lantern''');

-- Nerubian Sycophant (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45743 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45743;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45743,0,0,0,2,0,100,0,0,40,22000,25000,0,11,17169,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Summon Carrion Scarab at 55% HP');

-- Ix'lar the Underlord (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45744 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45744;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45744,0,0,0,0,0,100,0,5000,8000,18000,25000,0,11,50284,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Blinding Swarm'),
(45744,0,1,0,0,0,100,0,10000,10000,18000,18000,0,11,90908,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Mandible Crush'),
(45744,0,2,0,2,0,100,0,0,40,22000,25000,0,11,17169,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Summon Carrion Scarab at 55% HP');

-- Inconspicuous Bear (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=45750 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=45750;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(45750,0,0,0,11,0,100,0,0,0,0,0,0,42,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Inconspicuous Bear - On Respawn - Set Invincibility Hp 1'),
(45750,0,1,0,4,0,100,0,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Inconspicuous Bear - On Aggro - Store Target List'),
(45750,0,2,3,2,0,100,1,0,1,0,0,0,33,45750,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Inconspicuous Bear - Between 0-1% Health - Quest Credit'),
(45750,0,3,4,61,0,100,0,0,0,0,0,0,36,45751,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Inconspicuous Bear - Linked To Id 2 - Update Template On Worgen Druid'),
(45750,0,4,5,61,0,100,0,0,0,0,0,0,37,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Inconspicuous Bear - Linked To Id 3 - Die'),
(45750,0,5,0,61,0,100,0,0,0,0,0,0,41,60000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Inconspicuous Bear - Linked To Id 4 - Despawn after 60 sec'),
(45750,0,6,0,9,0,100,0,8,25,15000,18000,0,11,87187,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Inconspicuous Bear - Within 8-25 Range - Cast ''Feral Charge'''),
(45750,0,7,0,0,0,100,0,6000,8000,25000,27500,0,11,87185,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Inconspicuous Bear - In Combat - Cast ''Demoralizing Roar'''),
(45750,0,8,0,0,0,100,0,2000,4500,12000,15000,0,11,31279,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Inconspicuous Bear - In Combat - Cast ''Swipe''');

-- Forsaken Mage (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46048 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=46048;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46048,0,0,0,0,0,100,0,0,0,3400,4700,0,11,79858,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Mage - In Combat - Cast ''Frostbolt'''),
(46048,0,1,0,1,0,100,0,500,1000,1800000,1800000,0,11,79865,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Forsaken Mage - Out of Combat - Cast ''Frost Armor'''),
(46048,0,2,0,9,0,100,0,0,8,13600,14500,0,11,79850,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Forsaken Mage - Within 0-8 Range - Cast ''Frost Nova'''),
(46048,0,3,0,0,0,100,0,6000,9000,25000,28000,0,11,79860,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Mage - In Combat - Cast ''Blizzard'''),
(46048,0,4,0,0,0,100,0,11000,11000,22000,23000,0,11,79859,1,0,0,0,0,2,0,0,0,0,0,0,0,0,'Forsaken Mage - In Combat - Cast ''Ice Lance''');

-- Abomination (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46058 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=46058;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46058,0,0,0,9,0,100,0,8,40,17000,19000,0,11,50335,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Abomination - Within 8-40 Range - Cast ''Scourge Hook'''),
(46058,0,1,0,0,0,100,0,4000,5000,12000,15000,0,11,40504,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Abomination - In Combat - Cast ''Cleave''');

-- Twilight Pillager (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46144 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=46144;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46144,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,14873,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Pillager - In Combat - Cast ''Sinister Strike''');

-- Dark Assassin (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46202 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=46202;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46202,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,37685,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dark Assassin - In Combat - Cast ''Backstab'''),
(46202,0,1,0,0,0,100,0,4000,7000,12000,16000,0,11,32418,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dark Assassin - In Combat - Cast ''Curse of Agony''');

-- Twilight Vindicator (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46203 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=46203;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46203,0,0,0,9,0,100,0,0,8,12000,18000,0,11,79970,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Vindicator - Within 0-8 Range - Cast ''Divine Storm'''),
(46203,0,1,0,0,0,100,0,0,0,3400,4700,0,11,79971,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Twilight Vindicator - In Combat - Cast ''Hammer of Wrath'''),
(46203,0,2,0,1,0,100,0,1000,2000,30000,30000,0,11,79976,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight Vindicator - Out of Combat - Cast ''Retribution Aura''');

-- Corrupted Elementalist (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46204 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=46204;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46204,0,0,0,0,0,100,0,0,0,2300,3900,0,11,79855,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Corrupted Elementalist - In Combat - Cast ''Fire Blast'''),
(46204,0,1,0,0,0,100,0,4000,7000,12000,16000,0,11,79925,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Corrupted Elementalist - In Combat - Cast ''Frost Shock'''),
(46204,0,2,0,1,0,100,0,1000,2000,30000,30000,0,11,79849,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Corrupted Elementalist - Out of Combat - Cast ''Molten Armor''');

-- Citadel Veteran (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46205 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=46205;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46205,0,0,0,9,0,100,0,0,8,12000,18000,0,11,13730,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Citadel Veteran - Within 0-8 Range - Cast ''Demoralizing Shout'''),
(46205,0,1,0,0,0,100,0,2000,4000,8000,12000,0,11,57846,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Citadel Veteran - In Combat - Cast ''Heroic Strike'''),
(46205,0,2,0,0,0,100,0,6000,8000,12000,16000,0,11,32736,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Citadel Veteran - In Combat - Cast ''Mortal Strike''');

-- Titanic Guardian (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47032 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=47032;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47032,0,0,0,0,0,100,0,8000,8000,16000,19000,0,11,87753,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Titanic Guardian - In Combat - Cast ''Blazing Eruption'''),
(47032,0,1,0,0,0,100,0,3000,3000,13000,13000,0,11,87656,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Titanic Guardian - In Combat - Cast ''Decrepit Ruin'''),
(47032,0,2,0,0,0,100,0,12000,12000,29000,35000,0,11,87698,0,0,0,0,0,1,1,0,0,0,0,0,0,0,'Titanic Guardian - In Combat - Cast ''Summon Meteor''');

-- Dreadguard (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47214 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=47214;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47214,0,0,0,0,0,100,0,5000,8000,12000,15000,0,11,12170,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Revenge'),
(47214,0,1,0,2,0,100,0,0,70,15000,15000,0,11,12169,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Shield Block at 70% HP');

-- Codemaster Deethuk (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47602 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=47602;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47602,0,0,1,62,0,100,0,12296,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Codemaster Deethuk - On Gossip Select - Store Target List'),
(47602,0,1,2,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Codemaster Deethuk - Linked To Id 0 - Close Gossip'),
(47602,0,2,3,61,0,100,0,0,0,0,0,0,1,0,2000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Codemaster Deethuk - Linked To Id 1 - Say Line 0'),
(47602,0,3,4,61,0,100,0,0,0,0,0,0,66,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Codemaster Deethuk - Linked To Id 2 - Set Orientation'),
(47602,0,4,0,61,0,100,0,0,0,0,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Codemaster Deethuk - Linked To Id 3 - Set Emote State 0'),
(47602,0,5,0,52,0,100,0,0,47602,0,0,0,86,88812,0,12,1,0,0,1,0,0,0,0,0,0,0,0,'Codemaster Deethuk - On Text Over 0 - Cross Cast Assassination'),
(47602,0,6,0,67,0,100,0,9000,12000,0,0,0,11,79862,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Codemaster Deethuk - On Behind Target - Cast ''Backstab'''),
(47602,0,7,0,9,0,100,0,5,30,5000,6000,0,11,79866,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Codemaster Deethuk - Within 5-30 Range - Cast ''Deadly Throw'''),
(47602,0,8,0,2,0,100,1,0,30,0,0,0,11,79864,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Codemaster Deethuk - Between 0-30% Health - Cast ''Shadowstep'' (No Repeat)'),
(47602,0,9,0,0,0,100,0,8000,11000,23000,26500,0,11,79863,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Codemaster Deethuk - In Combat - Cast ''Hemorrhage''');

-- Apprehensive Worker (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47659 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=47659;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47659,0,0,0,0,0,100,1,100,100,0,0,0,11,78894,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 100 and 100 ms (and later repeats every 0 and 0 ms) - Self: Cast spell 78894 on Victim // ');

-- Torth (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47669 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=47669;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47669,0,0,0,9,0,100,0,0,5,10000,14000,0,11,37638,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Torth - Within 0-5 Range - Cast ''Flame Breath''');

-- Baradin Fox (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47676 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=47676;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47676,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,17253,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Baradin Fox - In Combat - Cast ''Bite'''),
(47676,0,1,0,0,0,100,0,3000,6000,21000,26000,0,11,61684,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Baradin Fox - In Combat - Cast ''Dash'''),
(47676,0,2,0,2,0,100,0,0,40,30000,35000,0,11,79853,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Baradin Fox - Between 0-40% Health - Cast ''Evasion''');

-- Winna Hazzard (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47679 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=47679;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47679,0,0,0,0,0,100,0,0,0,3400,4700,0,11,81109,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Winna Hazzard - In Combat - Cast ''Poison Bolt'''),
(47679,0,1,0,9,0,100,0,0,8,15000,19000,0,11,40818,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Winna Hazzard - Within 0-8 Range - Cast ''Toxic Slime'''),
(47679,0,2,0,4,0,100,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Winna Hazzard - On Aggro - Say Line 0 (No Repeat)');

-- Whisperwind Lasher (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47747 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=47747;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47747,0,0,1,73,0,100,0,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Whisperwind Lasher - On Spellclick - Store Target List'),
(47747,0,1,2,61,0,100,0,0,0,0,0,0,11,37752,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Whisperwind Lasher - Linked To Id 0 - Cast Stand'),
(47747,0,2,0,61,0,100,0,0,0,0,0,0,87,4774701,4774702,0,0,0,0,1,0,0,0,0,0,0,0,0,'Whisperwind Lasher - Linked To Id 1 - Run Random Script'),
(47747,0,3,0,4,0,100,1,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Whisperwind Lasher - On Aggro - Set Event Phase 1 (No Repeat)'),
(47747,0,4,0,4,1,100,1,0,0,0,0,0,11,48195,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Whisperwind Lasher - On Aggro - Cast ''Emerald Lasher Emerge'' (Phase 1) (No Repeat)'),
(47747,0,5,0,4,1,100,1,0,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Whisperwind Lasher - On Aggro - Remove Flag Standstate Submerged (Phase 1) (No Repeat)'),
(47747,0,6,0,0,1,100,0,4000,7000,9000,13000,0,11,82803,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Whisperwind Lasher - In Combat - Cast ''Lashing Flurry'' (Phase 1)'),
(47747,0,7,0,7,1,100,1,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Whisperwind Lasher - On Evade - Set Event Phase 2 (Phase 1) (No Repeat)'),
(47747,0,8,0,7,2,100,1,0,0,0,0,0,91,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Whisperwind Lasher - On Evade - Remove Flag Standstate Submerged (Phase 2) (No Repeat)'),
(47747,0,9,0,21,2,100,1,0,0,0,0,0,90,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Whisperwind Lasher - On Reached Home - Set Flag Standstate Submerged (Phase 2) (No Repeat)');

-- Pygmy Oaf (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48040 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48040;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48040,0,0,0,9,0,100,0,0,8,15000,18000,0,11,86695,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pygmy Oaf - Within 0-8 Range - Cast ''Whirlwind'''),
(48040,0,1,0,0,0,100,0,5000,5000,12500,13600,0,11,86699,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Pygmy Oaf - In Combat - Cast ''Shockwave''');

-- Pygmy Scout (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48041 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48041;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48041,0,0,0,0,0,100,0,0,0,2300,3900,0,11,79444,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Pygmy Scout - In Combat - Cast ''Impale'''),
(48041,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Pygmy Scout - Between 0-15% Health - Flee For Assist (No Repeat)'),
(48041,0,2,0,9,0,100,0,0,8,15000,15000,0,11,73864,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Pygmy Scout - Within 0-8 Range - Cast ''Sand Trap''');

-- Sludge Guard (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48083 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48083;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48083,0,0,0,0,0,100,0,0,0,2300,3900,0,11,6660,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shoot'),
(48083,0,1,2,38,0,100,0,1,1,0,0,0,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sludge Guard - On Data Set 1 1 - Set Faction Hostile'),
(48083,0,2,0,61,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,21,40,0,0,0,0,0,0,0,'Sludge Guard - Linked - Attack Closest Player'),
(48083,0,3,0,7,0,100,0,0,0,0,0,0,2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sludge Guard - On Evade - Restore Faction'),
(48083,0,5,0,11,0,100,0,0,0,0,0,0,2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sludge Guard - On Respawn - Restore Faction (a kill does not evade)');

-- Smolderthorn Assassin (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48119 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48119;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48119,0,0,1,8,0,100,0,89562,0,30000,30000,0,11,89568,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Smolderthorn Assassin - On Spellhit - Cast Disciplined'),
(48119,0,1,2,61,0,100,0,0,0,0,0,0,33,48195,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Smolderthorn Assassin - On Spellhit - Killcredit'),
(48119,0,2,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Smolderthorn Assassin - On Spellhit - Say Line 0'),
(48119,0,3,0,67,0,100,0,3900,6900,0,0,0,11,15582,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Casts Backstab'),
(48119,0,4,0,9,0,100,0,0,100,15000,25000,0,11,89596,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Unmask on Close');

-- Firegut Flamespeaker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48121 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48121;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48121,0,0,1,8,0,100,0,89562,0,30000,30000,0,11,89568,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Firegut Flamespeaker - On Spellhit - Cast Disciplined'),
(48121,0,1,2,61,0,100,0,0,0,0,0,0,33,48195,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Firegut Flamespeaker - On Spellhit - Killcredit'),
(48121,0,2,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Firegut Flamespeaker - On Spellhit - Say Line 0'),
(48121,0,3,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Say Text on Aggro'),
(48121,0,4,0,0,0,100,0,7000,8000,17000,22000,0,11,79846,0,0,0,0,0,4,0,0,0,0,0,0,0,0,'Cast Flamestrike'),
(48121,0,5,0,9,0,100,0,0,100,15000,25000,0,11,89596,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Unmask on Close'),
(48121,0,6,0,0,0,100,0,0,0,3400,4700,0,11,9053,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Fireball');

-- Blight Slime (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48136 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48136;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48136,0,0,0,0,0,100,0,5000,8000,15000,16000,0,11,9459,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Corrosive Ooze'),
(48136,0,1,0,8,0,100,0,89756,0,0,0,0,11,88769,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Blight Slime - On Spellhit ''Depleted'' - Cast ''Specimen Collected'' on Invoker');

-- Temple Swiftstalker (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48139 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48139;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48139,0,0,0,0,0,100,0,1000,1000,2400,2400,0,11,83877,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 1000 and 1000 ms (and later repeats every 2400 and 2400 ms) - Self: Cast spell Shoot (83877) on Victim // '),
(48139,0,1,2,0,0,100,0,6000,6000,26000,26000,0,64,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 6000 and 6000 ms (and later repeats every 26000 and 26000 ms) - Self: Target_0 = Random hostile // '),
(48139,0,2,3,61,0,100,0,0,0,0,0,0,11,89574,0,0,0,0,0,12,0,0,0,0,0,0,0,0,' Linked - Self: Cast spell Charged Shot (89574) on storedTarget[0] // '),
(48139,0,3,4,61,0,100,0,0,0,0,0,0,11,89571,0,0,0,0,0,12,0,0,0,0,0,0,0,0,' Linked - Self: Cast spell Charged Shot (89571) on storedTarget[0] // '),
(48139,0,4,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,12,0,0,0,0,0,0,0,0,' Linked - storedTarget[0]: Talk 0 // '),
(48139,0,5,0,9,0,100,6,5,30,16000,19000,0,11,84836,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Temple Swiftstalker - Shot on Close - Cast Multi');

-- Temple Runecaster (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48140 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48140;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48140,0,0,0,9,0,100,6,0,5,9000,11000,0,11,89554,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Temple Runecaster - On Close - Cast Runic Cleave'),
(48140,0,1,0,0,0,100,6,5000,7500,14500,18000,0,11,89551,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Temple Runecaster - In Combat - Cast Curse of the Runecaster'),
(48140,0,2,0,0,0,100,0,13000,13000,33000,35000,0,11,89549,0,0,0,0,0,26,30,0,0,0,0,0,0,0,'When in combat and timer at the begining between 13000 and 13000 ms (and later repeats every 33000 and 35000 ms) - Self: Cast spell Rune of Healing (89549) on Closest friendly creature in 30 yards // ');

-- Temple Fireshaper (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48143 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48143;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48143,0,0,0,2,0,100,7,0,35,0,0,0,11,86542,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'Temple Fireshaper - At 35% HP - Cast Molten Barrier'),
(48143,0,1,0,0,0,100,6,8000,8000,25000,25000,0,11,89547,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Temple Fireshaper - In Combat - Cast Blazing Eruption'),
(48143,0,2,0,0,0,100,6,4000,6000,17500,18500,0,11,84032,0,0,0,0,0,4,0,0,0,0,0,0,0,0,'Temple Fireshaper - In Combat - Cast Meteor'),
(48143,0,3,0,0,0,100,6,0,0,3400,4700,0,11,89538,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Temple Fireshaper - In Combat - Cast Fireball'),
(48143,0,4,0,0,0,100,0,9000,9000,30000,31000,0,11,89542,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 9000 and 9000 ms (and later repeats every 30000 and 31000 ms) - Self: Cast spell Molten Barrier (89542) on Self // ');

-- Bloodfang Forsaken Hunter (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48260 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48260;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48260,0,0,0,11,0,100,1,0,0,0,0,0,11,86237,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Stalking on Spawn'),
(48260,0,1,0,7,0,100,1,0,0,0,0,0,11,86237,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Stalking on Evade'),
(48260,0,2,0,2,0,100,0,0,55,15000,15000,0,11,79864,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadowstep at 55% HP');

-- Bloodfang Forsaken Hunter (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48272 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48272;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48272,0,0,0,11,0,100,1,0,0,0,0,0,11,86237,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Stalking on Spawn'),
(48272,0,1,0,7,0,100,1,0,0,0,0,0,11,86237,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Stalking on Evade'),
(48272,0,2,0,4,0,100,1,0,0,0,0,0,11,89712,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Cast Leaping Rake on Aggro');

-- Talonbranch Prowler (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48311 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48311;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48311,0,0,0,11,0,100,1,0,0,0,0,0,11,89812,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Talonbranch Prowler - On Respawn - Cast ''Extreme Prowling'' (No Repeat)');

-- High Warlock Xi'lun (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48312 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48312;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48312,0,0,0,1,0,100,0,500,1000,600000,600000,0,11,13787,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Demon Armor on Spawn'),
(48312,0,1,0,1,0,100,1,3000,5000,0,0,0,11,30842,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Summon Felhunter on Spawn'),
(48312,0,2,0,2,0,100,0,0,40,22000,25000,0,11,17173,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Drain Life at 40% HP'),
(48312,0,3,0,0,0,100,0,5000,8000,12000,15000,0,11,15245,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Shadow Bolt Volley');

-- Dragon-Lord Neeralak (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48314 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48314;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48314,0,0,0,0,0,100,0,8000,8000,18000,22000,0,11,11977,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Rend'),
(48314,0,1,0,0,0,100,0,4000,4000,12000,17000,0,11,79881,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Slam'),
(48314,0,2,0,2,0,100,0,0,60,22000,25000,0,11,79877,2,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Bloodthirst at 60% HP'),
(48314,0,3,0,4,0,100,1,0,0,0,0,0,11,32064,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Battle Shout on Aggro');

-- Angry Blight Slime (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48319 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48319;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48319,0,0,0,0,0,100,0,5000,8000,15000,16000,0,11,9459,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Corrosive Ooze'),
(48319,0,10,0,6,0,100,0,0,0,0,0,0,7,28329,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Angry Blight Slime - On Death - Add Quest ''Angry Scrubbing Bubbles'' to killer');

-- Telarius Voidstrider (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48764 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48764;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48764,0,0,0,0,0,100,0,0,0,3400,4700,0,11,79937,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Telarius Voidstrider - In Combat - Cast ''Immolate'''),
(48764,0,1,0,1,0,100,0,1000,2000,30000,30000,0,11,36298,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Telarius Voidstrider - Out of Combat - Cast ''Metamorphosis'''),
(48764,0,2,0,0,0,100,0,2000,4000,8000,12000,0,11,35871,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Telarius Voidstrider - In Combat - Cast ''Spellbreaker''');

-- Rimepelt (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48765 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48765;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48765,0,0,0,4,0,100,1,0,0,0,0,0,11,87187,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Rimepelt - On Aggro - Cast ''Feral Charge'' (No Repeat)'),
(48765,0,1,0,0,0,100,0,4000,6000,25000,27000,0,11,15727,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Rimepelt - In Combat - Cast ''Demoralizing Roar''');

-- Dragonmaw Skirmisher (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48799 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48799;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48799,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,90075,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dragonmaw Skirmisher - In Combat - Cast ''Black Cleave'''),
(48799,0,1,0,0,0,100,0,6000,8000,12000,16000,0,11,11976,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dragonmaw Skirmisher - In Combat - Cast ''Strike''');

-- Stormpike Trainee (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48912 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=48912;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48912,0,0,0,9,0,100,0,0,8,12000,18000,0,11,13730,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stormpike Trainee - Within 0-8 Range - Cast ''Demoralizing Shout'''),
(48912,0,1,0,0,0,100,0,3000,6000,20000,25000,0,11,79871,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stormpike Trainee - In Combat - Cast ''Recklessness'''),
(48912,0,2,0,8,0,100,1,91399,0,0,0,0,80,4891200,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Stormpike Trainee - On Spellhit ''Water!'' - Run Script');

-- Vicious Black Bear (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=49249 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=49249;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(49249,0,0,0,0,0,100,0,8000,8000,18000,25000,0,11,15727,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Cast Demoralizing Roar'),
(49249,0,1,0,4,0,100,1,0,0,0,0,0,11,87187,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Cast Feral Charge on Aggro');

-- Nijel's Point Guard (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=51839 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=51839;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(51839,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,12170,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nijel''s Point Guard - In Combat - Cast ''Revenge'''),
(51839,0,1,0,0,0,100,0,3000,6000,15000,20000,0,11,12169,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Nijel''s Point Guard - In Combat - Cast ''Shield Block'''),
(51839,0,2,0,0,0,100,0,4000,7000,12000,16000,0,11,95826,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Nijel''s Point Guard - In Combat - Cast ''Shoot''');

-- Hakkari Witch Doctor (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=52086 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=52086;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(52086,0,0,0,1,0,100,5,1000,1000,1000,1000,0,11,74919,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hakkari Witch Doctor - On Spawn - Cast Dark Aura'),
(52086,0,1,0,25,0,100,0,0,0,0,0,0,11,45104,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On reset (e.g. after reaching home) - Self: Cast spell 45104 on Self // '),
(52086,0,2,0,0,0,100,0,400,400,2500,2500,0,11,96416,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 400 and 400 ms (and later repeats every 2500 and 2500 ms) - Self: Cast spell 96416 on Victim // '),
(52086,0,3,4,0,0,100,0,18000,19000,30000,31000,0,11,97398,1,0,0,0,0,1,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 18000 and 19000 ms (and later repeats every 30000 and 31000 ms) - Self: Cast spell 97398 on Self // '),
(52086,0,4,0,61,0,100,0,0,0,0,0,0,67,0,4000,4000,0,0,0,1,0,0,0,0,0,0,0,0,' Linked - Trigger timed event #0 in 4000 - 4000 ms // '),
(52086,0,5,0,6,0,100,0,0,0,0,0,0,11,96418,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'On death - Self: Cast spell 96418 on Self // '),
(52086,0,6,0,59,0,100,1,0,0,0,0,0,11,24065,3,0,0,0,0,1,0,0,0,0,0,0,0,0,'On timed event 0 triggered - Self: Cast spell 24065 on Self // '),
(52086,0,7,0,0,0,100,0,28000,30000,30000,32000,0,11,97397,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 28000 and 30000 ms (and later repeats every 30000 and 32000 ms) - Self: Cast spell 97397 on Random hostile // ');

-- Pride of Bethekk (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=52345 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=52345;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(52345,0,0,0,0,0,100,0,8000,10000,8000,10000,0,11,97355,0,0,0,0,0,5,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 8000 and 10000 ms (and later repeats every 8000 and 10000 ms) - Self: Cast spell 97355 on Random hostile // ');

-- Venomancer T'Kulu (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=52381 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=52381;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(52381,0,0,1,25,0,100,0,0,0,0,0,0,86,96937,0,10,295004,0,0,1,0,0,0,0,0,0,0,0,'On reset (e.g. after reaching home) - SMART_TARGET_CREATURE_GUID: Cast spell 96937 at Self // '),
(52381,0,1,2,61,0,100,0,0,0,0,0,0,86,96936,0,10,295002,0,0,1,0,0,0,0,0,0,0,0,' Linked - SMART_TARGET_CREATURE_GUID: Cast spell 96936 at Self // '),
(52381,0,2,3,61,0,100,0,0,0,0,0,0,18,33554432,0,0,0,0,0,10,295003,0,0,0,0,0,0,0,' Linked - Creature Zanzil''s Cauldron of Toxic Torment 52529 (295003): Set UNIT_FLAGS to UNIT_FLAG_NOT_SELECTABLE // '),
(52381,0,3,0,61,0,100,0,0,0,0,0,0,86,97122,0,10,295003,0,0,1,0,0,0,0,0,0,0,0,' Linked - SMART_TARGET_CREATURE_GUID: Cast spell 97122 at Self // '),
(52381,0,4,5,6,0,100,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On death - Self: Talk 1 // '),
(52381,0,5,6,61,0,100,0,0,0,0,0,0,19,33554432,0,0,0,0,0,10,295003,0,0,0,0,0,0,0,' Linked - Creature Zanzil''s Cauldron of Toxic Torment 52529 (295003): Remove UNIT_FLAGS to UNIT_FLAG_NOT_SELECTABLE // '),
(52381,0,6,0,61,0,100,0,0,0,0,0,0,28,97122,0,0,0,0,0,10,295003,0,0,0,0,0,0,0,' Linked - Creature Zanzil''s Cauldron of Toxic Torment 52529 (295003): Remove aura due to spell 97122 // '),
(52381,0,7,8,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'On aggro - Self: Talk 0 // '),
(52381,0,8,9,61,0,100,0,0,0,0,0,0,28,96936,0,0,0,0,0,1,0,0,0,0,0,0,0,0,' Linked - Self: Remove aura due to spell 96936 // '),
(52381,0,9,0,61,0,100,0,0,0,0,0,0,28,96937,0,0,0,0,0,1,0,0,0,0,0,0,0,0,' Linked - Self: Remove aura due to spell 96937 // '),
(52381,0,10,0,0,0,100,0,4000,4000,6000,6000,0,11,96918,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 4000 and 4000 ms (and later repeats every 6000 and 6000 ms) - Self: Cast spell 96918 on Victim // '),
(52381,0,11,0,0,0,100,0,7000,7000,14000,14000,0,11,96475,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'When in combat and timer at the begining between 7000 and 7000 ms (and later repeats every 14000 and 14000 ms) - Self: Cast spell 96475 on Self // ');

-- Riverpaw Herbalist (replace)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=54373 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=54373;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(54373,0,0,0,0,0,100,1,0,0,0,0,0,87,50101,50102,50103,0,0,0,1,0,0,0,0,0,0,0,0,'Riverpaw Herbalist - Enter combat - Call random action list'),
(54373,0,1,0,2,0,100,1,0,15,0,0,0,25,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,'Riverpaw Herbalist - Between 0-15% Health - Flee For Assist (No Repeat)'),
(54373,0,2,0,4,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Riverpaw Herbalist - On Aggro - Say Line 0 (No Repeat)');

-- Undying Flame (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=54550 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=54550;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(54550,0,0,0,0,0,100,0,0,0,2300,3900,0,11,102057,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Undying Flame - In Combat - Cast ''Scorched'''),
(54550,0,1,0,9,0,100,0,0,8,12000,18000,0,11,105238,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Undying Flame - Within 0-8 Range - Cast ''Undying Flame''');

-- Expired Test Subject (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=59100 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=59100;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(59100,0,0,0,0,0,100,0,3000,6000,15000,20000,0,11,130260,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Expired Test Subject - In Combat - Cast ''Shadow Blink''');

-- Shado-Pan Guardian (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=59741 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=59741;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(59741,0,0,0,0,0,100,0,5000,8000,12000,16000,0,11,106421,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shado-Pan Guardian - In Combat - Cast ''Palm Strike'''),
(59741,0,1,0,9,0,100,0,0,5,10000,14000,0,11,128304,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Shado-Pan Guardian - Within 0-5 Range - Cast ''Roundhouse Kick''');

-- Angry Monkey Totem (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=60370 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=60370;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(60370,0,0,0,0,0,100,0,0,0,2300,3900,0,11,116472,64,0,0,0,0,2,0,0,0,0,0,0,0,0,'Angry Monkey Totem - In Combat - Cast ''Eyes of the Idol''');

-- Bloodthirsty Prowler (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=62945 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=62945;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(62945,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,31289,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bloodthirsty Prowler - In Combat - Cast ''Claw'''),
(62945,0,1,0,0,0,100,0,6000,9000,15000,20000,0,11,129325,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bloodthirsty Prowler - In Combat - Cast ''Pounce'''),
(62945,0,2,0,0,0,100,0,6000,8000,12000,16000,0,11,24331,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Bloodthirsty Prowler - In Combat - Cast ''Rake''');

-- Dawnseeker Guardian (add)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=70253 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid`=70253;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(70253,0,0,0,0,0,100,0,2000,4000,8000,12000,0,11,40505,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dawnseeker Guardian - In Combat - Cast ''Cleave'''),
(70253,0,1,0,0,0,100,0,4000,7000,12000,16000,0,11,95826,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Dawnseeker Guardian - In Combat - Cast ''Shoot''');
