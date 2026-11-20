-- Northern Barrens, Raging River Ride (26769): Horton Hornblower's riverboat from the dock north-east of Ratchet up the
-- Southfury River (zone_ratchet.cpp: npc_ratchet_riverboat).
-- Sourced: the parked boat's spellclick used Redridge's credit spell 81265 (QUEST_COMPLETE 26616, Keeshan's riverboat); the
-- Barrens spell is 82457 Summon Riverboat (SUMMON 44055 with SummonProperties 161 = vehicle at its spell_target_position, the
-- parked boat's spot, + KILL_CREDIT2 44054 "Board the Riverboat to Nozzlepot"), 5.4.8 DBC; Horton's greeting "You're $n,
-- right? Gazlowe told me to take ya up the river! Hop in when you're ready to go." and "Horton motions to the rickety
-- riverboat nearby." (BT 44368, 45711; comment 2010-11-24 [+17]; wiki) and his five ride lines in the wiki's order (BT
-- 44386-44390; comments 2010-11-24 [+17], 2011-02-23 [+14]); creature_template_movement of 44055 as the parked 44057 and
-- Redridge's riverboat 43450 (Ground 0, Swim 1, Flight 1).
-- Ours: the click while the quest is in the log, complete or not (the click itself completes it: a ride that ended early
-- must be retakable); the greeting's trigger (a player on the quest within 15 yd, once per 30 s,
-- to him alone); the ride (route, timings, drop) is in the script. Drafted in part by scope F (F-26769-1).
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=44057;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES (44057,82457,1,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceGroup`=44057;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,44057,82457,0,0,47,0,26769,10,0,0,0,0,'','Riverboat - click with Raging River Ride in progress or complete, not yet handed in');
DELETE FROM `smart_scripts` WHERE `entryorguid`=44057 AND `source_type`=0;
UPDATE `creature_template` SET `AIName`='' WHERE `entry`=44057;

-- The moving boat
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_ratchet_riverboat' WHERE `entry`=44055;
DELETE FROM `creature_template_movement` WHERE `CreatureId`=44055;
INSERT INTO `creature_template_movement` (`CreatureId`,`Ground`,`Swim`,`Flight`,`Rooted`) VALUES (44055,0,1,1,0);

-- Horton: greeting on the static spawn only (per-guid script; his copies on the boats speak from the boat's script)
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=44058 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid`=-251611 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-251611,0,0,1,10,0,100,0,1,15,30000,30000,1,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Horton Hornblower - OOC LoS player on Raging River Ride within 15 yd - Say greeting to him'),
(-251611,0,1,0,61,0,100,0,0,0,0,0,0,1,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Horton Hornblower - Linked - Emote: motions to the riverboat');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=1 AND `SourceEntry`=-251611 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,-251611,0,0,47,0,26769,8,0,0,0,0,'','Horton Hornblower - greet only players with Raging River Ride in progress');
DELETE FROM `creature_text` WHERE `CreatureID`=44058;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(44058,0,0,'You''re $n, right? Gazlowe told me to take ya up the river! Hop in when you''re ready to go.',12,0,100,0,0,0,0,44368,5,'Horton Hornblower - greeting at the dock'),
(44058,1,0,'Horton motions to the rickety riverboat nearby.',16,0,100,0,0,0,0,45711,5,'Horton Hornblower - emote at the dock'),
(44058,2,0,'Whew, that was a bit of a tight squeeze, but the rest of the trip should be a breeze.',12,0,100,0,0,0,0,44386,0,'Horton Hornblower - ride line 1 (after the narrows)'),
(44058,3,0,'There''s nothing quite like the smell of Durotar on a warm, comfortable boat ride.',12,0,100,0,0,0,0,44387,0,'Horton Hornblower - ride line 2'),
(44058,4,0,'This is where you''d expect something to go wrong on a beautiful trip like this.',12,0,100,0,0,0,0,44388,0,'Horton Hornblower - ride line 3'),
(44058,5,0,'Everyone always says, "Horton, why do you drive a boat up and down the river?" I ask them, "Why don''t you?"  ... that''s usually where I run out of witty retorts.',12,0,100,0,0,0,0,44389,0,'Horton Hornblower - ride line 4'),
(44058,6,0,'We''re pulling up near your stop. Head due west along the road to reach Nozzlepot''s Outpost.',12,0,100,0,0,0,0,44390,0,'Horton Hornblower - ride line 5 (near the stop)');
