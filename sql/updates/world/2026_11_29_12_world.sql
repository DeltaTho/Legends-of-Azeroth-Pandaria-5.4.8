-- Northern Barrens S1 (_12): the Sludge Fen and the Burning Blade farm - Tool Buckets moved to the farm, nine more Muddy
-- Tracks, the supply-bag Bruisers, Sludge Investigation's log turn-in, tracks clickable only on the quest, one Sludge Beast
-- and its lines, one Boss Copperplug, the Overseer's poison.
-- (plan.md section 1 `_12`; dossier G: G1, G3, G14, G2, G3b, G4, G4b, G13, G15.)
--
-- SOURCED: per block below (both TDBs' spawns and flags, Wowhead comments). Guids: creatures 3145200-3145213, gameobjects
-- 3145214-3145239 (empty in mop_world on 2026-11-20; plan 0.1).
-- OURS: G3b's restriction (no TDB row; the 2011-04-28 [+9] comment is a bug report, not a description of a gate); G4b's aggro line 51018 is inferred
-- from the id block (the death line 51019 is sourced). G1 unblocks 29027, and with it 29015 / 14004 (`_14` G5 / H7).

-- G1 (29027 Nugget Slugs): Tool Buckets stand at the Burning Blade farm SW of Wenikee (quest text "buckets around the Burning
-- Blade farm to the southwest"; POI at (620,-2202); both TDBs: 26 buckets there and none at the Sludge Fen; Wowhead 2011-05-09 x2,
-- 2011-07-16 "no buckets [at the Sludge Fen] anymore"). mop: 29 buckets at the Sludge Fen / Venture camp, none at the farm.
DELETE FROM `gameobject` WHERE `id`=161752 AND `map`=1 AND `guid` BETWEEN 175339 AND 175396;
DELETE FROM `gameobject` WHERE `guid` BETWEEN 3145214 AND 3145239;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) VALUES
(3145214,161752,1,17,17,1,1,0,0,755.769,-2255.24,91.8927,5.06146,0,0,0.573574,-0.819154,120,100,1,'',0),
(3145215,161752,1,17,17,1,1,0,0,566.722,-2016.44,91.6667,1.46608,0,0,0.669132,0.743144,120,100,1,'',0),
(3145216,161752,1,17,17,1,1,0,0,552.316,-2121.06,93.1096,2.58308,0,0,0.961261,0.275641,120,100,1,'',0),
(3145217,161752,1,17,17,1,1,0,0,581.481,-2182.44,91.9152,2.1293,0,0,0.874619,0.48481,120,100,1,'',0),
(3145218,161752,1,17,17,1,1,0,0,591.184,-2190.21,91.6667,3.927,0,0,0.923878,-0.382688,120,100,1,'',0),
(3145219,161752,1,17,17,1,1,0,0,546.795,-2154.22,92.2181,1.46608,0,0,0.669132,0.743144,120,100,1,'',0),
(3145220,161752,1,17,17,1,1,0,0,537.083,-2139.09,92.5611,1.67551,0,0,0.743143,0.669133,120,100,1,'',0),
(3145221,161752,1,17,17,1,1,0,0,531.835,-2138.82,93.6815,1.06465,0,0,0.507538,0.861629,120,100,1,'',0),
(3145222,161752,1,17,17,1,1,0,0,528.068,-2133.8,94.7818,1.39626,0,0,0.642786,0.766046,120,100,1,'',0),
(3145223,161752,1,17,17,1,1,0,0,580.599,-2205.52,91.932,3.14159,0,0,1,0.00000126759,120,100,1,'',0),
(3145224,161752,1,17,17,1,1,0,0,609.109,-2197.77,91.6667,2.32129,0,0,0.91706,0.398748,120,100,1,'',0),
(3145225,161752,1,17,17,1,1,0,0,559.804,-2222.33,91.6705,1.46608,0,0,0.669132,0.743144,120,100,1,'',0),
(3145226,161752,1,17,17,1,1,0,0,572.512,-2215.04,91.6667,4.69494,0,0,0.713249,-0.700911,120,100,1,'',0),
(3145227,161752,1,17,17,1,1,0,0,601.106,-2207.54,91.6667,0.925024,0,0,0.446198,0.894934,120,100,1,'',0),
(3145228,161752,1,17,17,1,1,0,0,573.601,-2221.84,92.8882,0.925024,0,0,0.446198,0.894934,120,100,1,'',0),
(3145229,161752,1,17,17,1,1,0,0,584.32,-2216.4,91.6667,3.9619,0,0,0.91706,-0.39875,120,100,1,'',0),
(3145230,161752,1,17,17,1,1,0,0,575.837,-2221.72,94.4173,5.67232,0,0,0.300706,-0.953717,120,100,1,'',0),
(3145231,161752,1,17,17,1,1,0,0,587.964,-2218.9,93.1974,1.3439,0,0,0.622513,0.782609,120,100,1,'',0),
(3145232,161752,1,17,17,1,1,0,0,564.618,-2242.18,91.6674,5.60251,0,0,0.333805,-0.942642,120,100,1,'',0),
(3145233,161752,1,17,17,1,1,0,0,558.545,-2250.56,92.2807,2.42601,0,0,0.936673,0.350206,120,100,1,'',0),
(3145234,161752,1,17,17,1,1,0,0,578.458,-2233.89,92.9546,0.90757,0,0,0.438371,0.898794,120,100,1,'',0),
(3145235,161752,1,17,17,1,1,0,0,587.538,-2238.96,91.6667,1.97222,0,0,0.833885,0.551938,120,100,1,'',0),
(3145236,161752,1,17,17,1,1,0,0,592.071,-2252.65,91.6667,4.4855,0,0,0.782607,-0.622516,120,100,1,'',0),
(3145237,161752,1,17,17,1,1,0,0,579.767,-2267.86,92.365,1.46608,0,0,0.669132,0.743144,120,100,1,'',0),
(3145238,161752,1,17,17,1,1,0,0,603.896,-2275.88,91.9846,4.62512,0,0,0.737278,-0.675589,120,100,1,'',0),
(3145239,161752,1,17,17,1,1,0,0,626.241,-2271.04,91.8549,1.46608,0,0,0.669132,0.743144,120,100,1,'',0);

-- G3 (29087): the 9 Muddy Tracks both TDBs have and mop lacks (mop 18, TDBs 27); 120 s respawn as the TDBs.
DELETE FROM `creature` WHERE `guid` BETWEEN 3145200 AND 3145208;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3145200,52171,1,17,382,1,1,0,0,0,0,1027.64,-3172.22,82.6079,0,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0),
(3145201,52171,1,17,382,1,1,0,0,0,0,1059.36,-3193.32,81.7595,0,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0),
(3145202,52171,1,17,382,1,1,0,0,0,0,1085.83,-3191.57,82.1912,4.01426,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0),
(3145203,52171,1,17,382,1,1,0,0,0,0,1105.94,-3167.6,81.8762,0,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0),
(3145204,52171,1,17,382,1,1,0,0,0,0,1089.21,-3056.02,81.5036,0,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0),
(3145205,52171,1,17,382,1,1,0,0,0,0,1079.09,-3036.09,81.9584,0,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0),
(3145206,52171,1,17,382,1,1,0,0,0,0,1054.2,-3036,81.7926,1.25664,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0),
(3145207,52171,1,17,382,1,1,0,0,0,0,1123.17,-3029.96,91.8793,0,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0),
(3145208,52171,1,17,382,1,1,0,0,0,0,1129.84,-3068.02,94.7648,4.4855,120,0,0,0,42,0,0,0,0,0,0,0,'',0,0);
UPDATE `creature` SET `spawntimesecs`=120 WHERE `id`=52171 AND `guid` BETWEEN 303127 AND 303151;

-- G14 (29090 / the farm): the supply-bag Bruisers 52196. mop has two stacked 0.2 yd apart (310974, 310975) and none of the
-- TDBs' five farm spots; delete the pair, add the five (the template addon carries 4133 + 96510). The patroller 310977 stays.
DELETE FROM `creature_addon` WHERE `guid` IN (310974,310975);
DELETE FROM `creature` WHERE `guid` IN (310974,310975) AND `id`=52196;
DELETE FROM `creature` WHERE `guid` BETWEEN 3145209 AND 3145213;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3145209,52196,1,17,17,1,1,0,0,0,0,555.045,-2170.54,91.7917,3.17867,300,0,0,0,386,0,0,0,0,0,0,0,'',0,0),
(3145210,52196,1,17,17,1,1,0,0,0,0,544.792,-2171.96,91.7917,3.28626,300,0,0,0,386,0,0,0,0,0,0,0,'',0,0),
(3145211,52196,1,17,17,1,1,0,0,0,0,499.121,-2147.16,112.288,2.27046,300,0,0,0,386,0,0,0,0,0,0,0,'',0,0),
(3145212,52196,1,17,17,1,1,0,0,0,0,456.139,-2110.66,144.597,4.49729,300,0,0,0,386,0,0,0,0,0,0,0,'',0,0),
(3145213,52196,1,17,17,1,1,0,0,0,0,459.842,-2096.12,140.999,3.95369,300,0,0,0,386,0,0,0,0,0,0,0,'',0,0);

-- G2 (29087 Sludge Investigation): handed in from the log (both TDBs have 0x10000; the reward text is the player's own
-- observation and the quest has no completion log line; 29089, its RewardNextQuest, is AUTO_ACCEPT and its text "You decide to
-- follow the tracks down to the bottom of the lake" is offered in the field). Player::GetNextQuest offers it on a log turn-in.
UPDATE `quest_template` SET `Flags`=`Flags`|0x10000 WHERE `ID`=29087;

-- G3b (ours, low): only players on 29087 can examine (and so despawn) a track (cf. Wowhead 2011-04-28 [+9]: tracks not
-- interactable outside the right quest state). Unconditional in mop: anyone can click them away.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceGroup`=52171 AND `SourceEntry`=96479;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,52171,96479,0,0,9,0,29087,0,0,0,0,0,'','Muddy Tracks - spellclick only with Sludge Investigation in the log');

-- G4 (29089 Sludge Beast!): the beast is summoned by the Sludge Pile 208343 (goober, spell 96474, wild summon, 120 s);
-- neither TDB spawns it. mop's static copy (60 s respawn) stands beside the pile and doubles it.
DELETE FROM `creature_addon` WHERE `guid`=310973;
DELETE FROM `creature` WHERE `guid`=310973 AND `id`=52165;
-- G4b: its lines. 51019 on death (Wowhead 2011-10-12 [+55], 2013-11-22 [+28] "he yells"); 51018 on aggro (same id block, inferred).
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=52165 AND `ScriptName`='';
DELETE FROM `creature_text` WHERE `CreatureID`=52165;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT 52165, CASE `ID` WHEN 51018 THEN 0 ELSE 1 END, 0, `Text`, 14, 0, 100, 0, 0, 0, 0, `ID`, 0, 'Sludge Beast' FROM `broadcast_text` WHERE `ID` IN (51018,51019);
DELETE FROM `smart_scripts` WHERE `entryorguid`=52165 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(52165,0,0,0,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sludge Beast - On Aggro - Yell Line 0'),
(52165,0,1,0,6,0,100,0,0,0,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Sludge Beast - On Death - Yell Line 1');

-- G13 (29015 / 14006's manual cover): Boss Copperplug is one NPC (both TDBs: 1 spawn); mop has three within 10 yd. Keep 264460.
DELETE FROM `creature_addon` WHERE `guid` IN (264886,264902);
DELETE FROM `creature` WHERE `guid` IN (264886,264902) AND `id`=9336;

-- G15 (cosmetic): Venture Co. Overseer casts Overseer's Poison 6531 on its timers as both TDBs, not the generic Poison 744.
UPDATE `smart_scripts` SET `action_param1`=6531, `action_param2`=32, `event_param1`=3000, `event_param2`=4500, `event_param3`=15000, `event_param4`=19000,
  `comment`='Venture Co. Overseer - In Combat - Cast ''Overseer''s Poison''' WHERE `entryorguid`=3286 AND `source_type`=0 AND `id`=0 AND `action_param1`=744;
