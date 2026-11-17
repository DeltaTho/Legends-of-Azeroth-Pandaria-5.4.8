-- Step Three: Prophet 27773 - Jammal'an the Prophet 46656 escapes at a quarter health instead of dying.
-- Sourced: at about 25 % health he says "Ya not be gettin' me dat easy! Atal'ai gonna rise up..." (BroadcastText 46720) and
-- teleports away; defeating him completes the quest (wiki quest_27773 Notes and Jammal'an_the_Prophet Quotes; Wowhead 27773
-- 2011-01-17 reply [+6]; Itharius's reward text "He has escaped!").
-- Ours: the teleport visual (87459 Teleport Visual Only), that he vanishes rather than blinks to another spot, and how he goes:
-- at the threshold he stops attacking and moving, loses every aura (so no damage over time can kill him), turns immune, silenced
-- and passive, drops combat (evade disabled, so that does not reset him), and SmartAI's forced despawn makes him invisible 1.5 s
-- later and removes him 5 s after that (SmartAI::UpdateDespawn, a fixed stage; nothing fights then). He is back about 66.5 s after
-- the threshold (spawntimesecs 60): SmartAI::JustAppeared makes him visible again and clears the despawn state, the template addon
-- gives his auras back, and the reset rows undo every flag and setting the escape made (a respawn keeps unit_flags).
-- Ours too: a health floor of 1 hp from spawn (invincibility), so a blow from above 25 % straight to dead leaves him at 1 hp and
-- the escape runs instead of an ordinary death and corpse.
-- The credit, measured from Jammal'an's side: every player on his threat list (everyone who fought him, whoever tagged him) is
-- credited (SMART_TARGET_THREAT_LIST, SmartScript.cpp:2962-2972 and 912-920), and the loot recipient's group within the group
-- reward distance of the loot recipient as well (target self, SmartScript.cpp:894-905). The second alone was not enough: an
-- offline or released tagger gave nobody credit, and with the 1 hp floor the escape is the only way to finish 27773. Players
-- without the quest are not affected (KilledMonsterCredit needs the objective). Rows 0-2 (his abilities) stay.
DELETE FROM `creature_text` WHERE `CreatureID`=46656;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(46656,0,0,'Ya not be gettin'' me dat easy! Atal''ai gonna rise up...',12,0,100,0,0,0,0,46720,0,'Jammal''an the Prophet - escape at 25%');

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46656;
DELETE FROM `smart_scripts` WHERE `entryorguid`=46656 AND `source_type`=0 AND `id` BETWEEN 3 AND 21;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46656,0,3,4,2,0,100,1,0,25,0,0,33,46656,0,0,0,0,0,24,0,0,0,0,0,0,0,'Jammal''an the Prophet - Between 0-25% Health - Kill Credit (everyone on his threat list) (No Repeat)'),
(46656,0,4,5,61,0,100,0,0,0,0,0,33,46656,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Kill Credit (loot recipient and group)'),
(46656,0,5,6,61,0,100,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Say Line 0'),
(46656,0,6,7,61,0,100,0,0,0,0,0,92,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Interrupt Spellcast'),
(46656,0,7,8,61,0,100,0,0,0,0,0,117,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Disable Evade'),
(46656,0,8,9,61,0,100,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Stop Auto Attack'),
(46656,0,9,10,61,0,100,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Stop Combat Movement'),
(46656,0,10,11,61,0,100,0,0,0,0,0,28,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Remove All Auras'),
(46656,0,11,12,61,0,100,0,0,0,0,0,11,87459,2,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Cast Teleport Visual Only'),
(46656,0,12,13,61,0,100,0,0,0,0,0,18,8960,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Set Immune To PC and NPC, Silenced'),
(46656,0,13,14,61,0,100,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Set Passive'),
(46656,0,14,15,61,0,100,0,0,0,0,0,203,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Combat Stop'),
(46656,0,15,0,61,0,100,0,0,0,0,0,41,1500,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Despawn in 1.5 s (respawns after spawntimesecs)'),
(46656,0,16,17,25,0,100,0,0,0,0,0,19,8960,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - On Reset - Remove Immune To PC and NPC, Silenced'),
(46656,0,17,18,61,0,100,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Set Aggressive'),
(46656,0,18,19,61,0,100,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Allow Auto Attack'),
(46656,0,19,20,61,0,100,0,0,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Allow Combat Movement'),
(46656,0,20,21,61,0,100,0,0,0,0,0,117,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Enable Evade'),
(46656,0,21,0,61,0,100,0,0,0,0,0,42,1,0,0,0,0,0,1,0,0,0,0,0,0,0,'Jammal''an the Prophet - Linked - Set Invincibility 1 HP (the escape at 25 % always runs)');
