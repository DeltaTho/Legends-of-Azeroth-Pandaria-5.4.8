-- Northern Barrens, The Baron's Demands (14046): Baron Longshore's gossip in the Alliance stockade south of Ratchet.
-- Sourced (both TDBs unless said): options 0 / 1 only while 14046 is in the log (conditions 15/10567 type 47 mask 8); "Never,
-- you two-timing dog!" opens menu 10568 "Suit yerself, mate. Me an' the treasure can both be buried." (TDB text = BT 35054;
-- comment 2010-12-01 [+37]; wiki); freeing him says "Har! Pleasure doin' business with ye, $n." to that player (creature_text
-- 3467/0, emote 11, sound 6923, TextRange 5; SAI rows 0-2 of both TDBs).
-- Ours: npc_text 14626 (free id) for the reply; the greeting by quest state (the core shows the LAST text of a menu whose
-- conditions hold, Player.cpp:15897, so mop always showed 14625): 14624 "Do ye trust me?" while 14046 is in the log, 14625
-- once it is complete or rewarded, 14623 otherwise. mop's row that closed the gossip on "Never" (hiding the reply) is gone.
-- Drafted by scope F (F-14046-1); S4 owns 3467 (plan ruling R3). The log turn-in flag ships in S1's Ratchet quest data.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10567 AND `SourceEntry` IN (0,1);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10567,0,0,0,47,0,14046,8,0,0,0,0,'','Baron Longshore - option Never only while The Baron''s Demands is incomplete'),
(15,10567,1,0,0,47,0,14046,8,0,0,0,0,'','Baron Longshore - option Break manacles only while The Baron''s Demands is incomplete');
-- Greeting text by quest state (ours: the core shows the LAST text of the menu whose conditions hold; 14623 stays the default).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup`=10567 AND `SourceEntry` IN (14624,14625);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(14,10567,14624,0,0,47,0,14046,8,0,0,0,0,'','Baron Longshore - "Do ye trust me?" while The Baron''s Demands is incomplete'),
(14,10567,14625,0,0,47,0,14046,66,0,0,0,0,'','Baron Longshore - "heads ta roll" once The Baron''s Demands is complete or rewarded');
UPDATE `gossip_menu_option` SET `ActionMenuID`=10568 WHERE `MenuID`=10567 AND `OptionID`=0;
DELETE FROM `npc_text` WHERE `ID`=14626;
INSERT INTO `npc_text` (`ID`,`text0_0`,`text0_1`,`BroadcastTextID0`,`lang0`,`Probability0`,`Emote0_0`,`VerifiedBuild`) VALUES
(14626,'Suit yerself, mate. Me an'' the treasure can both be buried.','',35054,0,1,1,15595);
DELETE FROM `gossip_menu` WHERE `MenuID`=10568;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (10568,14626,15595);
-- SAI: drop the row that closed the gossip on "Never" (it hid the reply), add Talk 0 to the free branch (TDB both).
DELETE FROM `smart_scripts` WHERE `entryorguid`=3467 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3467,0,0,1,62,0,100,0,10567,1,0,0,0,33,34769,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Baron Longshore - On gossip option 1 - Kill credit Baron Longshore Quest Credit'),
(3467,0,1,2,61,0,100,0,0,0,0,0,0,15,14046,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Baron Longshore - Linked - Event happens The Baron''s Demands'),
(3467,0,2,3,61,0,100,0,0,0,0,0,0,1,0,0,1,0,0,0,7,0,0,0,0,0,0,0,0,'Baron Longshore - Linked - Talk 0 to invoker'),
(3467,0,3,0,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Baron Longshore - Linked - Close gossip');
DELETE FROM `creature_text` WHERE `CreatureID`=3467 AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(3467,0,0,'Har! Pleasure doin'' business with ye, $n.',12,0,100,11,0,6923,0,35052,5,'Baron Longshore to Player (freed)');
