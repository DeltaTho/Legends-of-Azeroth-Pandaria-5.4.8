-- Northern Barrens S1 (_03): Crossroads gossip texts and ambient - Rocco / Balgor / Nagala greetings, the chained wolves
-- of 13878, Kreenig's yell, Dorak's pacing.
-- (plan.md section 1 `_03`; dossier B: B-3, B-6, B-7, 13878-3.)
--
-- SOURCED: the three greetings shown as "Missing npc_text" (wiki: Rocco 52220 = BroadcastText 50941, Balgor 52309 at the peak
-- = 50993, Nagala during 29111 = 51216); the wolves are chained in the stables (quest text, beta comment); Kreenig yells
-- "Come and face me! ..." when a player comes near (Wowhead 2012-02-22 [+4]; BroadcastText 44319, in mop already); Dorak
-- runs back and forth and pauses (comments; TDB 4.4.2 SmartAI 34284: pause 4 s at both ends of his walk, emote 15 at one).
-- OURS: Nagala's text window (17900 only with 29111 in the log, 17901 otherwise: GetGossipTextId keeps the LAST matching
-- row); the Chain Origin bunnies casting Chained to Stables 65072 (mop's row 1 already cast it on the wolf's data 0 2; added:
-- cast flag 32, and one not repeated cast 3 s after spawn, because the first load can miss the wolf's data 0 2); Kreenig's
-- trigger (out-of-combat sight of a hostile player, 40 yd, 2 min cooldown; the TDB fires it on data 1 1 from a setter that
-- is unknown); Dorak's pauses mapped onto mop's own path 262328 (kept): 4 s at its west end (point 2, with the roar, where
-- the TDB path roars at its point 4) and 4 s at its east end (point 6, the TDB's point 2).

-- B-3: the three greetings.
UPDATE `npc_text` n JOIN `broadcast_text` b ON b.`ID`=50941 SET n.`text0_0`=b.`Text`, n.`text0_1`=b.`Text1`, n.`BroadcastTextID0`=50941, n.`Probability0`=1 WHERE n.`ID`=17889;
UPDATE `npc_text` n JOIN `broadcast_text` b ON b.`ID`=50993 SET n.`text0_0`=b.`Text`, n.`text0_1`=b.`Text1`, n.`BroadcastTextID0`=50993, n.`Probability0`=1 WHERE n.`ID`=17898;
UPDATE `npc_text` n JOIN `broadcast_text` b ON b.`ID`=51216 SET n.`text0_0`=b.`Text`, n.`text0_1`=b.`Text1`, n.`BroadcastTextID0`=51216, n.`Probability0`=1 WHERE n.`ID`=17900;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup`=12754 AND `SourceEntry` IN (17900,17901);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(14,12754,17900,0,0,9,0,29111,0,0,0,0,0,'','Nagala Whipshank: ride text while Mor''shan Caravan Delivery is in the log'),
(14,12754,17901,0,0,9,0,29111,0,0,1,0,0,'','Nagala Whipshank: default text otherwise');

-- B-6: the wolves of 13878 are shown chained (flag 32: only when the wolf lacks the aura; no repeating timer, which would
-- re-chain a freed wolf still in reach; id 2 carries
-- NOT_REPEATABLE: a 0 repeat without flag 1 fires every tick in this core, SmartScript.cpp RecalcTimer(e, 0, 0)).
DELETE FROM `smart_scripts` WHERE `entryorguid`=34287 AND `source_type`=0 AND `id` IN (1,2);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34287,0,1,0,38,0,100,0,0,2,0,0,0,11,65072,32,0,0,0,0,19,34285,10,0,0,0,0,0,0,'Chain Origin - On Data Set 0 2 - Cast Chained to Stables on Trapped Wolf'),
(34287,0,2,0,1,0,100,1,3000,3000,0,0,0,11,65072,32,0,0,0,0,19,34285,10,0,0,0,0,0,0,'Chain Origin - OOC once after spawn - Cast Chained to Stables on Trapped Wolf');

-- B-7: Kreenig Snarlsnout yells at an approaching hostile player.
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3438 AND `AIName`='' AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid`=3438 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3438,0,0,0,10,0,100,0,0,40,120000,120000,1,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Kreenig Snarlsnout - OOC LOS hostile player 40 yd - Yell Line 0');

-- 13878-3: Dorak pauses 4 s at each end of his walk and roars at the west end. MovementInform passes the 0-based node
-- index (WaypointMovementGenerator.cpp:243), so point 2 is id 1.
UPDATE `waypoint_data` SET `delay`=4000 WHERE `id`=262328 AND `point` IN (2,6);
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34284 AND `AIName`='' AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid`=34284 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34284,0,0,0,34,0,100,0,2,1,0,0,0,5,15,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Dorak - On Waypoint Path Point 2 (west end) - Play Emote Roar');
