-- Northern Barrens S1 (_17): the two zone-17 stable masters heal and revive battle pets.
-- (coverage audit row 3.5.)
--
-- SOURCED: both TDBs give stable menu 9821 "I'd like to heal and revive my battle pets." (BroadcastText 64115, fee box
-- 66369, 1000 copper); mop's menu 9821 lacked it.
-- OURS: the mechanism copies mop's own battle-pet healers Oriana 72005 / Cowardly Zue 73632 (menus 15753 / 15949: option
-- type 1, npcflag 1, box 1000 / 66369; SmartAI: on select the player casts 125801 Heal Battle Pets, close). As there, the
-- fee is shown by the client but not taken. Menu 9821 is shared by 150 stable masters realm-wide, so the option is gated
-- to Sikwa 9981 and Reggifuz 10063 (source-15 conditions on the creature's entry); the others are unchanged. TDB's busy
-- page (menu 15145, cooldown) is not built.

DELETE FROM `gossip_menu_option` WHERE `MenuID`=9821 AND `OptionID`=3;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(9821,3,0,'I''d like to heal and revive my battle pets.',64115,1,1,0,0,0,1000,'A small fee for supplies is required.',66369,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=9821 AND `SourceEntry`=3;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,9821,3,0,0,31,1,3,9981,0,0,0,0,'','Battle-pet healing only at Sikwa (Northern Barrens)'),
(15,9821,3,0,1,31,1,3,10063,0,0,0,0,'','... or at Reggifuz (Ratchet)');
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (9981,10063) AND `AIName`='' AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (9981,10063) AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(9981,0,0,1,62,0,100,0,9821,3,0,0,0,11,125801,16,0,0,0,0,7,0,0,0,0,0,0,0,0,'Sikwa - On Gossip Option 3 - Invoker Casts Heal Battle Pets'),
(9981,0,1,0,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Sikwa - Linked - Close Gossip'),
(10063,0,0,1,62,0,100,0,9821,3,0,0,0,11,125801,16,0,0,0,0,7,0,0,0,0,0,0,0,0,'Reggifuz - On Gossip Option 3 - Invoker Casts Heal Battle Pets'),
(10063,0,1,0,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Reggifuz - Linked - Close Gossip');
