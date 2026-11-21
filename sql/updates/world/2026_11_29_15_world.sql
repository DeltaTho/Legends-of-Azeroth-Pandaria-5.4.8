-- Northern Barrens S1 (_15): Waptor Twapping (14068) - the raptors' trap row fires on the trap run only, the map area, Kala'ma's
-- lines.
-- (plan.md section 1 `_15`; dossier H: H1, H2, H3.)
--
-- SOURCED: the raptors' "arrived at the trap" row is MOVEMENTINFORM type 0 (any) id 1, so the eight Sunscales on waypoint
-- paths fired it at path node 1, found no trap and the linked rows killed and despawned them; the trap run is a MOVE_TO_POS
-- point 1 (POINT_MOTION_TYPE 8); the map area is objective 0's (TDB 4.4.2); Kala'ma's two lines are BroadcastText 35118 /
-- 35119 (Wowhead 2011-03-02).
-- OURS: Kala'ma speaks them on the 14068 reward (trigger inferred).
-- Rows of 3256 are scope G's entry and 3255 / 44164 / 44165 scope I's; plan 0.2 gives these SAI rows to S1. S6 deletes one
-- 3255 double; `_13` G8 moves consorts 263120 / 263121 (no row overlap, ruling R10).

-- H1 (14068 collateral, zone-wide look): the raptors' "arrived at the trap" row is MOVEMENTINFORM type 0 (any) id 1, so the
-- eight Sunscales on waypoint paths fire it at path node 1 (WAYPOINT_MOTION_TYPE), find no trap, and the linked rows kill
-- and despawn them. Restrict it to POINT moves (8), which is what the trap run (MOVE_TO_POS point 1) produces.
-- Target 11 is CREATURE_DISTANCE (entry, dist) in this core: the 30 yd / 2 yd ranges are right and stay.
-- NOTE: rows of 3256 (scope G) and 3255/44164/44165 (scope I).
UPDATE `smart_scripts` SET `event_param1`=8 WHERE `entryorguid` IN (3255,3256,44164,44165) AND `source_type`=0 AND `id`=1 AND `event_type`=34 AND `event_param2`=1 AND `target_type`=11 AND `target_param1`=34831;

-- H2 (14068): map area of the raptor hunt belongs to objective 0 (Wittle Waptor), as TDB 4.4.2.
UPDATE `quest_poi` SET `ObjectiveIndex`=0, `QuestObjectiveId`=264413 WHERE `QuestID`=14068 AND `Idx1`=1;

-- H3 (14068): Kala'ma's lines (broadcast 35118, 35119; Wowhead 2011-03-02). On reward is inferred.
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34828 AND `ScriptName`='';
DELETE FROM `creature_text` WHERE `CreatureID`=34828 AND `GroupID` IN (0,1);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT 34828, 0, 0, `Text`, 12, 0, 100, 0, 0, 0, 0, `ID`, 0, 'Kala''ma - Waptor Twapping rewarded' FROM `broadcast_text` WHERE `ID`=35118;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT 34828, 1, 0, `Text`, 12, 0, 100, 0, 0, 0, 0, `ID`, 0, 'Kala''ma - Waptor Twapping rewarded' FROM `broadcast_text` WHERE `ID`=35119;
DELETE FROM `smart_scripts` WHERE (`entryorguid`=34828 AND `source_type`=0) OR (`entryorguid`=3482800 AND `source_type`=9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34828,0,0,0,20,0,100,0,14068,0,0,0,0,80,3482800,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kala''ma - On Quest ''Waptor Twapping'' Rewarded - Run Script'),
(3482800,9,0,0,0,0,100,0,1000,1000,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kala''ma - On Script - Say Line 0'),
(3482800,9,1,0,0,0,100,0,4000,4000,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kala''ma - On Script - Say Line 1');

-- Coverage 1.2 (ours: neither TDB links her): Kala'ma greets with menu 10590 -> npc_text 14652 = BT 35122 "Be caweful
-- with the waptors..." (comment 2011-01-27 [+37]; the last text of the menu is shown).
UPDATE `creature_template` SET `gossip_menu_id`=10590 WHERE `entry`=34828;

-- Coverage 1.5 (quest text: the trap "will scweech wike a waptor, luwing one into the twap"; the raptor "it'll shwink down";
-- spells 66282 Waptor Twap Scweech and 66284 Shrink -80 % scale, unreferenced until now; timings ours): the placed trap
-- screeches once; a raptor that reaches it turns passive, shrinks, and dies 1.5 s later (despawn 2 s after), instead of
-- dying at once.
DELETE FROM `smart_scripts` WHERE `entryorguid`=34831 AND `source_type`=0 AND `id`=2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34831,0,2,0,54,0,100,0,0,0,0,0,0,11,66282,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Waptor Twap - Just Summoned - Cast Waptor Twap Scweech');
UPDATE `smart_scripts` SET `link`=0, `action_type`=80, `action_param1`=325500, `action_param2`=2, `action_param3`=0, `target_type`=1, `comment`='Sunscale - Linked (at the trap) - Run Script (shrink, die)' WHERE `entryorguid` IN (3255,3256,44164,44165) AND `source_type`=0 AND `id`=2 AND `event_type`=61;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (3255,3256,44164,44165) AND `source_type`=0 AND `id`=3 AND `event_type`=61;
DELETE FROM `smart_scripts` WHERE `entryorguid`=325500 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(325500,9,0,0,0,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunscale at the trap - On Script - Set React Passive'),
(325500,9,1,0,0,0,100,0,0,0,0,0,0,11,66284,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunscale at the trap - On Script - Cast Shrink'),
(325500,9,2,0,0,0,100,0,1500,1500,0,0,0,37,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunscale at the trap - On Script - Die'),
(325500,9,3,0,0,0,100,0,0,0,0,0,0,41,2000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sunscale at the trap - On Script - Despawn in 2 s');
