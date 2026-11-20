-- Northern Barrens, Club Foote (14034): knocking out Chief Engineer Foote in the Broken Keel tavern, Ratchet.
-- Sourced: the options "<Club him unconscious.>" (BT 35012, both TDBs menu 10556) and "<Rifle through his pockets.>" (BT 35020;
-- wiki Notes; item comments 2010-12-31 [+6], 2012-01-12 [+1] "knock him out and then go through his pockets"), the knocked-out
-- text 14616 "<The Engineer slumbers fitfully on the floor.>" (BT 35019, menu 10560 in mop), Sashya's "Hahaha, very nice, $n!"
-- (BT 35013, wiki, comment 2010-12-08 reply [+3]), "the Theramore Deck Hands become hostile" (wiki; beta comment 2010-07-07
-- [+18]); video FKERW1-ygdM (5.4.8, 2014-07-22): the deck hand's name plate is green before the club and red the second after.
-- Ours: the knock-out lasts 60 s; he lies in stand state 3 (sleep, "slumbers") with Cosmetic - Sleep Zzz Breakable 55701 as the
-- marker that switches his options and text; the two tavern deck hands (guids 265488, 265490 only; entry 34707 is shared
-- with 20 deck hands outside) rest at the town's faction 2028 and passive, and turn to 1077 and attack the player who clubbed
-- him; they go back to 2028 on evade and on reset. Their per-guid script repeats the entry's two combat rows (per-guid rows
-- replace the entry's, SmartScript.cpp:3830). The peons do not join (question 16, default).
-- Neither TDB has any SAI for Foote; mop's single row gave the schematics on the first click to anyone.

-- Options: club only with the quest in progress, no schematics and Foote awake; rifle only while he is down
DELETE FROM `gossip_menu_option` WHERE `MenuID`=10556 AND `OptionID`=1;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(10556,1,0,'<Rifle through his pockets.>',35020,1,1,0,0,0,0,NULL,0,0);
DELETE FROM `gossip_menu` WHERE `MenuID`=10556 AND `TextID`=14616;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (10556,14616,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10556 AND `SourceEntry` IN (0,1);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup`=10556 AND `SourceEntry`=14616;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10556,0,0,0,47,0,14034,8,0,0,0,0,'','Chief Engineer Foote - club only while Club Foote is in progress'),
(15,10556,0,0,0,2,0,46827,1,0,1,0,0,'','Chief Engineer Foote - club only without Foote''s Schematics'),
(15,10556,0,0,0,1,1,55701,0,0,1,0,0,'','Chief Engineer Foote - club only while he is awake (no sleep marker)'),
(15,10556,1,0,0,47,0,14034,8,0,0,0,0,'','Chief Engineer Foote - rifle only while Club Foote is in progress'),
(15,10556,1,0,0,2,0,46827,1,0,1,0,0,'','Chief Engineer Foote - rifle only without Foote''s Schematics'),
(15,10556,1,0,0,1,1,55701,0,0,0,0,0,'','Chief Engineer Foote - rifle only while he is knocked out (sleep marker)'),
(14,10556,14616,0,0,1,1,55701,0,0,0,0,0,'','Chief Engineer Foote - "slumbers fitfully on the floor" while knocked out');

-- Foote
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34754;
DELETE FROM `smart_scripts` WHERE `entryorguid`=34754 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34754,0,0,1,62,0,100,0,10556,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Chief Engineer Foote - On gossip option 0 (club) - Close gossip'),
(34754,0,1,2,61,0,100,0,0,0,0,0,0,11,55701,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Cast Cosmetic - Sleep Zzz Breakable on self (knock-out marker)'),
(34754,0,2,3,61,0,100,0,0,0,0,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Emote state none'),
(34754,0,3,4,61,0,100,0,0,0,0,0,0,90,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Stand state sleep'),
(34754,0,4,5,61,0,100,0,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Store the clubber'),
(34754,0,5,6,61,0,100,0,0,0,0,0,0,100,1,0,0,0,0,0,10,265488,34707,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Send the clubber to tavern Deck Hand 265488'),
(34754,0,6,7,61,0,100,0,0,0,0,0,0,100,1,0,0,0,0,0,10,265490,34707,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Send the clubber to tavern Deck Hand 265490'),
(34754,0,7,8,61,0,100,0,0,0,0,0,0,45,1,1,0,0,0,0,10,265488,34707,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Set data 1 1 on tavern Deck Hand 265488 (attack)'),
(34754,0,8,9,61,0,100,0,0,0,0,0,0,45,1,1,0,0,0,0,10,265490,34707,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Set data 1 1 on tavern Deck Hand 265490 (attack)'),
(34754,0,9,10,61,0,100,0,0,0,0,0,0,1,3,0,0,0,0,0,10,265063,34651,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Sashya says "Hahaha, very nice" to the clubber'),
(34754,0,10,0,61,0,100,0,0,0,0,0,0,67,1,60000,60000,0,0,100,1,0,0,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Wake up in 60 s'),
(34754,0,11,12,62,0,100,0,10556,1,0,0,0,56,46827,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Chief Engineer Foote - On gossip option 1 (rifle) - Add Foote''s Schematics'),
(34754,0,12,0,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Close gossip'),
(34754,0,13,14,59,0,100,0,1,0,0,0,0,91,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Engineer Foote - On timed event 1 - Stand up'),
(34754,0,14,15,61,0,100,0,0,0,0,0,0,28,55701,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Remove the knock-out marker'),
(34754,0,15,0,61,0,100,0,0,0,0,0,0,17,415,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Chief Engineer Foote - Linked - Emote state back (template addon 415)');

-- Sashya's line (she is the talker of Foote's row 9; group 3 is this quest's, groups 0-2 are Who's Shroomin' Who?'s)
DELETE FROM `creature_text` WHERE `CreatureID`=34651 AND `GroupID`=3;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34651,3,0,'Hahaha, very nice, $n!',12,0,100,0,0,0,0,35013,5,'Sashya - Club Foote, to the player who clubbed Foote');

-- The two tavern Deck Hands: calm at rest, the clubber's enemies after the club
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (-265488,-265490) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-265488,0,0,0,4,0,100,1,0,0,0,0,0,11,66076,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - On Aggro - Cast Throw (No Repeat) (as entry 34707 row 0)'),
(-265488,0,1,0,0,0,100,0,2000,4500,12000,16000,0,11,75361,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - In Combat - Cast Swashbuckling Slice (as entry 34707 row 1)'),
(-265488,0,2,3,25,0,100,0,0,0,0,0,0,2,2028,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - On Reset - Faction 2028 (friendly, as the tavern)'),
(-265488,0,3,0,61,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - Linked - Passive'),
(-265488,0,4,5,7,0,100,0,0,0,0,0,0,2,2028,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - On Evade - Faction 2028'),
(-265488,0,5,0,61,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - Linked - Passive'),
(-265488,0,6,7,38,0,100,0,1,1,0,0,0,2,1077,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - On Data 1 1 (Foote clubbed) - Faction 1077'),
(-265488,0,7,8,61,0,100,0,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - Linked - Aggressive'),
(-265488,0,8,0,61,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - Linked - Attack the clubber'),
(-265490,0,0,0,4,0,100,1,0,0,0,0,0,11,66076,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - On Aggro - Cast Throw (No Repeat) (as entry 34707 row 0)'),
(-265490,0,1,0,0,0,100,0,2000,4500,12000,16000,0,11,75361,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - In Combat - Cast Swashbuckling Slice (as entry 34707 row 1)'),
(-265490,0,2,3,25,0,100,0,0,0,0,0,0,2,2028,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - On Reset - Faction 2028 (friendly, as the tavern)'),
(-265490,0,3,0,61,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - Linked - Passive'),
(-265490,0,4,5,7,0,100,0,0,0,0,0,0,2,2028,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - On Evade - Faction 2028'),
(-265490,0,5,0,61,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - Linked - Passive'),
(-265490,0,6,7,38,0,100,0,1,1,0,0,0,2,1077,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - On Data 1 1 (Foote clubbed) - Faction 1077'),
(-265490,0,7,8,61,0,100,0,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - Linked - Aggressive'),
(-265490,0,8,0,61,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Theramore Deck Hand (tavern) - Linked - Attack the clubber');
