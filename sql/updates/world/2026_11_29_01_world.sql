-- Northern Barrens S1 (_01): the Mor'shan Rampart NPCs - greetings, Kulg's flight, kneeling and idle bodies, arrows,
-- Captain Elendilad's abilities, the spirit of Gorat's lines and flare, the healed defenders.
-- (plan.md section 1 `_01`; dossier A: A-13618-1, A-KADRAK-1, A-13866-3, A-13613-1, A-13612-1, A-13615-1, A-13621-1,
-- A-13621-2, A-13621-3, A-13613-2.)
--
-- SOURCED: Gorat's three texts by state (npc_text 14336-14338; comment 2013-07-19 [+1], "<Gorat expires.>"); Kadrak's busy page
-- = npc_text 14448 / BroadcastText 34046 in both TDBs, shown while Kadrak Gossip Timer 64243 is on him (wiki, comments
-- 2010-12-02 [+28]); Kulg's option = BroadcastText 34373, spell 64789 = SEND_TAXI path 1201 to the Mor'shan landing (DBC);
-- defenders kneel (both TDBs: template addon StandState 8); the five bowmen east of the camp are alive and idle (both TDBs);
-- arrows respawn in 120 s (both TDBs); Elendilad's Bladestorm / Commanding Shout rows are both TDBs' 33302 ids 0-1; the
-- spirit is a personal summon (SummonProperties 719 flag 0x10) and "shoots a flare arrow onto the island" (comments
-- 2010-07-09 [+77], 2011-12-02 [+30]); the healed defenders "return to the ramparts for treatment" (quest text) and
-- Wounded Waypoint Bunnies 33267 stand in the field.
-- OURS: Elendilad's 3-minute out-of-combat despawn (else every use of the blood leaves another captain on the shore);
-- the flare as the spirit's cast of 62792 at the bunny (the bunny no longer casts it itself); the healed defender's line
-- (one of BroadcastText 33420-33422, the id block before Gorat's texts: inferred), run to the nearest 33267 and 8 s life.
-- OURS (coverage 1.1, orchestrator's ruling): Kulg's greeting npc_text 14475 = BroadcastText 34372 "Tread lightly through
-- these woods, $c...". Neither TDB has npc_text 14475; 34372 sits beside his option text 34373 and fits his post on the
-- Ashenvale border (BroadcastText carries no speaker). Gorka's two texts by 13653's state (coverage 2.2; her option and
-- SmartAI are S3's): 14358 "Hurry ... Splintertree must not fall!" while 13653 is incomplete, 14357 "Make it quick" otherwise.

-- A-13618-1: Gorat's text by quest state (Player::GetGossipTextId keeps the last matching row).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup`=10328 AND `SourceEntry` IN (14336,14337,14338);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(14,10328,14336,0,0,47,0,13618,10,0,0,0,0,'','Gorat - Come near while Find Gorat! is in the log'),
(14,10328,14337,0,0,47,0,13618,1,0,0,0,0,'','Gorat - unconscious before Find Gorat!'),
(14,10328,14338,0,0,47,0,13618,64,0,0,0,0,'','Gorat - lifeless after Find Gorat! is handed in');

-- A-KADRAK-1: Kadrak's busy page (today every player reads "Missing npc_text"); shown only while 64243 is on him, which
-- the S3 ride sets. Otherwise he greets with 14344 "What is it, $c?".
UPDATE `npc_text` SET `text0_0`='Brutusk is out watering the bushes right now.$b$bStay close though, $n. He should be ready for our ride to Splintertree very soon.', `BroadcastTextID0`=34046 WHERE `ID`=14448;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup`=10411 AND `SourceEntry`=14448;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(14,10411,14448,0,0,1,1,64243,0,0,0,0,0,'','Kadrak - busy text while Kadrak Gossip Timer is on him');

-- A-13866-3: Kulg flies a player holding To The Ramparts! to the Mor'shan Ramparts (13866 is complete on accept: mask 2).
DELETE FROM `gossip_menu_option` WHERE `MenuID`=10439 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(10439,0,0,'Send me to the Mor''shan Ramparts, Kulg.',34373,1,1,0,0,0,0,'',0,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10439 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10439,0,0,0,47,0,13866,2,0,0,0,0,'','Kulg - flight option while To The Ramparts! is in the log');
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34195 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid`=34195 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34195,0,0,1,62,0,100,0,10439,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,'Kulg Gorespatter - On Gossip Select - Close Gossip'),
(34195,0,1,0,61,0,100,0,0,0,0,0,0,85,64789,2,0,0,0,0,7,0,0,0,0,0,0,0,'Kulg Gorespatter - Linked - Invoker Casts Azshara Entrance to Mor''Shan Ramparts Taxi Spell');

-- A-13613-1: Wounded Mor'shan Defenders kneel (7 of 16 spawns stood; the template addon now kneels them all).
UPDATE `creature_template_addon` SET `StandState`=8 WHERE `entry`=33266;

-- A-13613-2 (ours): the salve credits once, the defender stands, says one line to the player who healed him, runs toward
-- the nearest Wounded Waypoint Bunny and is gone after 8 s (respawn 60 s, kneeling). The 10 s hit cooldown covers his
-- whole life, so one defender gives one credit.
DELETE FROM `creature_text` WHERE `CreatureID`=33266;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(33266,0,0,'For the Horde!',12,0,100,0,0,0,0,33420,0,'Wounded Mor''shan Defender - healed by the salve'),
(33266,0,1,'Death to the Alliance!',12,0,100,0,0,0,0,33421,0,'Wounded Mor''shan Defender - healed by the salve'),
(33266,0,2,'Many thanks, $c!',12,0,100,0,0,0,0,33422,0,'Wounded Mor''shan Defender - healed by the salve');
DELETE FROM `smart_scripts` WHERE `entryorguid`=33266 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33266,0,0,1,8,0,100,0,62644,0,10000,10000,0,33,33266,0,0,0,0,0,7,0,0,0,0,0,0,0,'Wounded Mor''shan Defender - On Spellhit Apply Salve - Quest Credit'),
(33266,0,1,2,61,0,100,0,0,0,0,0,0,91,8,0,0,0,0,0,1,0,0,0,0,0,0,0,'Wounded Mor''shan Defender - Linked - Stand Up'),
(33266,0,2,3,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Wounded Mor''shan Defender - Linked - Say Line 0 (to the healer)'),
(33266,0,3,4,61,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,19,33267,150,0,0,0,0,0,'Wounded Mor''shan Defender - Linked - Move To Closest Wounded Waypoint Bunny'),
(33266,0,4,0,61,0,100,0,0,0,0,0,0,41,8000,0,0,0,0,0,1,0,0,0,0,0,0,0,'Wounded Mor''shan Defender - Linked - Despawn In 8 s');

-- A-13613-3 (walk M-13613-1): the wounded to heal are in the field outside the gate (quest text "still in the field of
-- battle"; comment 2011-10-31 [+6] "the true quest NPCs are OUTSIDE of the barrier"). Both TDBs spawn the three kneeling
-- beside Dinah too (303136 303160 303162 = 238118 238119 238116: 13620's "surrounded by three Wounded Defenders"), so they
-- stay as props and no longer take the salve: the SPELLHIT row needs no Dinah 33263 within 15 yd. 238317 / 238319, by the
-- camp, are in neither TDB: deleted (14 field defenders remain, 12 of them on TDB spots).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=1 AND `SourceEntry`=33266 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,33266,0,0,29,1,33263,15,0,1,0,0,'','Wounded Mor''shan Defender - the three beside Dinah are props, no salve credit');
DELETE FROM `creature_addon` WHERE `guid` IN (238317,238319);
DELETE FROM `creature` WHERE `guid` IN (238317,238319) AND `id`=33266;

-- A-13612-1: the five bowmen east of the camp are alive (no Permanent Feign Death) and all seven zone-17 bowmen stand idle.
UPDATE `creature_addon` SET `auras`=NULL WHERE `guid` IN (238115,238157,238158,238159,238173) AND `auras`='29266';
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=33195 AND `guid` IN (238115,238157,238158,238159,238173,238438,238565);

-- A-13615-1: Serviceable Arrows respawn in 120 s.
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `id`=194263;

-- A-13621-1: Captain Elendilad's Bladestorm and Commanding Shout; he leaves after 3 min out of combat (ours).
DELETE FROM `smart_scripts` WHERE `entryorguid`=33302 AND `source_type`=0 AND `id` IN (2,3,4);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33302,0,2,0,9,0,100,0,0,5,13600,14500,0,11,78828,2,0,0,0,0,1,0,0,0,0,0,0,0,'Captain Elendilad - Within 0-5 Range - Cast Bladestorm'),
(33302,0,3,0,0,0,100,0,8000,9000,120000,120000,0,11,78823,2,0,0,0,0,1,0,0,0,0,0,0,0,'Captain Elendilad - In Combat - Cast Commanding Shout'),
(33302,0,4,0,1,0,100,1,180000,180000,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,'Captain Elendilad - Out of Combat 3 min - Despawn');

-- A-13621-2: the spirit of Gorat speaks to his summoner only.
UPDATE `creature_text` SET `TextRange`=5 WHERE `CreatureID`=33304;

-- A-13621-3: the flare. The spirit shot 32838 Shoot Bow, whose only target condition is another script's creature 16899, so
-- the cast failed; he now shoots 62792 Gorat's Bowshot (nearby entry, 150 yd) at Gorat's Target Bunny 33336 on the island,
-- and the bunny, told by the linked SET_DATA, lights the flame patch and summons Elendilad as before without shooting itself.
UPDATE `smart_scripts` SET `action_param1`=62792, `comment`='Spirit of Gorat - On Text Over 6 - Cast Gorat''s Bowshot at Gorat''s Target Bunny' WHERE `entryorguid`=33304 AND `source_type`=0 AND `id`=6 AND `action_type`=11;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=62792;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,62792,0,0,31,0,3,33336,0,0,0,0,'','Gorat''s Bowshot - target Gorat''s Target Bunny');
DELETE FROM `smart_scripts` WHERE `entryorguid`=33336 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(33336,0,0,1,38,0,100,0,0,1,0,0,0,11,62811,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gorat''s Target Bunny - On Data Set 0 1 - Cast Bowshot Impact Flame Patch'),
(33336,0,1,0,61,0,100,0,0,0,0,0,0,11,62814,0,0,0,0,0,1,0,0,0,0,0,0,0,'Gorat''s Target Bunny - Linked - Cast Summon Elendilad');

-- Coverage 1.1 (ours): Kulg's greeting.
UPDATE `npc_text` n JOIN `broadcast_text` b ON b.`ID`=34372 SET n.`text0_0`=b.`Text`, n.`text0_1`=b.`Text1`, n.`BroadcastTextID0`=34372, n.`Probability0`=1 WHERE n.`ID`=14475;

-- Coverage 2.2: Gorka says "Hurry ..." only while Crisis at Splintertree is incomplete (last matching text wins).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup`=10342 AND `SourceEntry` IN (14357,14358);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(14,10342,14358,0,0,47,0,13653,8,0,0,0,0,'','Gorka - "Hurry ... Splintertree must not fall!" while 13653 is incomplete');
