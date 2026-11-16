-- Searing Gorge, the Thorium Brotherhood leaders' Slag Pit staging (plan B-4, B-5, B-6; gate ruling R-5, Option R).
-- From accepting Operation: Stir the Cauldron 28052 until From Whence He Came 28062 is rewarded, Oilfist, Hansel and Evonice
-- leave Thorium Point and Rendan the Iron Summit, and copies of the five stand in the Slag Pit; Scrange stays at Thorium Point
-- (walking his sniffed beat) and has a copy on Maltorius' balcony. Oilfist's and Scrange's greetings fit where they stand.
--
-- Sourced:
-- - 82343 Generic Quest Invisibility 4 (type 12) on the template of Oilfist 14625, Scrange 14626, Hansel 14627, Evonice 14628
--   and Rendan 47393, and Scrange's Thorium Point spawn with a spawn addon of no aura (so he alone stays visible): both TDBs
--   (TDB 359697). Scrange's beat: TDB path 28775760 (10 nodes, the same in both TDBs).
-- - Detections: 88516 See Quest Invis 4 (type 12) and 88514 See Quest Invis 3 (type 9, the spell Maltorius 14621 and Arkkus
--   47460 carry), both AreaGroup 2804 = zone 51 [DBC]; 60921 Generic Quest Invisibility 3 (type 9) on the Slag Pit copies.
-- - The window: Oilfist leaves Thorium Point after 28052 is accepted (comment 28052 2010-12-02 [+7]); the leaders are back
--   at Thorium Point after the finale (28064 handed in at Thorium Point, 2014-07-09); Evonice "you CANNOT turn this quest in
--   at Thorium" during the Slag Pit (2010-12-24 [+4]).
-- - Positions (x, y): Wowhead MoP Classic pins 14625 (49.8,39.2), 14626 (42.4,34.4), 14627 (42.2,34.6), 14628 (43.6,28.4)
--   converted with WorldMapArea 28; Rendan's copy 401000 is LoA's existing row at the Slag Pit entrance (pin 40.8,51.8,
--   3 yd). Four Lookouts with Oilfist (wiki 28060 notes); "her guards" with Evonice (28054 2010-12-03 reply).
-- - Gossip texts per place: Oilfist 12293 (17268 "Welcome to Thorium Point", 17269 "We've made it this far into the Slag
--   Pit", 17270 "You're welcome among us anytime"), Scrange 5966 (7120 Thorium Point, 17267 Slag Pit): TDB gossip_menu rows.
-- Ours:
-- - The spell_area rows (neither TDB has them): 88516 while 28052 is not taken or once 28062 is rewarded; 88514 from 28052
--   taken until 28062 is rewarded. The two windows are exact complements, so every leader's entry has a visible copy in
--   every quest state (the copies share the entry's starter and ender rows).
-- - Heights of the copies (vmap floor with a navmesh polygon under each, mmtile 0000_44_34); three Lookouts with Evonice;
--   the Lookouts' places and every facing; one window for all five (user question Q2 default).
-- - The gossip text conditions (source 14, ConditionTarget 1 = the creature, made mutually exclusive since the last
--   matching text wins in Player::GetGossipTextId).
-- Hansel's copy 3132202 carries section E's 28060 event (per-guid SmartAI, gossip option): do not move or renumber it.

-- B-4 (TP-16): Scrange's Thorium Point spawn walks his sniffed beat; its spawn addon (no aura) keeps him visible under B-5.
UPDATE `creature` SET `position_x`=-6530.74, `position_y`=-1157.38, `position_z`=310.341, `orientation`=4.42393, `MovementType`=2, `wander_distance`=0, `currentwaypoint`=0 WHERE `guid`=185719;
DELETE FROM `creature_addon` WHERE `guid`=185719;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(185719,1857190,0,0,0,0,1,1,0,0,0,0,0,0,'');
DELETE FROM `waypoint_data` WHERE `id`=1857190;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(1857190,1,-6530.74,-1157.38,310.341,0,0,0,0,100,0),
(1857190,2,-6525.14,-1152.18,310.716,0,0,0,0,100,0),
(1857190,3,-6520.41,-1145.16,311.402,0,0,0,0,100,0),
(1857190,4,-6517.87,-1136.6,311.201,0,0,0,0,100,0),
(1857190,5,-6521.16,-1127.48,310.482,0,0,0,0,100,0),
(1857190,6,-6527.23,-1120.95,310.645,0,0,0,0,100,0),
(1857190,7,-6521.16,-1127.48,310.482,0,0,0,0,100,0),
(1857190,8,-6517.87,-1136.6,311.201,0,0,0,0,100,0),
(1857190,9,-6520.41,-1145.16,311.402,0,0,0,0,100,0),
(1857190,10,-6525.14,-1152.18,310.716,0,0,0,0,100,0);

-- B-5 (a): the leaders' template aura (type 12). The Slag Pit copies' spawn addons (60921, type 9) replace it
-- (Creature::GetCreatureAddon takes the spawn addon first).
UPDATE `creature_template_addon` SET `auras`='82343' WHERE `entry` IN (14625,14626,14627,14628,47393);

-- B-5 (b): Slag Pit copies of Oilfist 3132200, Scrange 3132201, Hansel 3132202, Evonice 3132203, Oilfist's four Lookouts
-- 3132204-3132207 and Evonice's three 3132208-3132210 (model, equipment and flags from their Thorium Point rows); Rendan's
-- copy 401000 gets its zone and area.
DELETE FROM `creature` WHERE `guid` BETWEEN 3132200 AND 3132210;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`)
SELECT 3132200,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6683.1,-1434.1,169.0,5.40,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185729
UNION ALL SELECT 3132201,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6611.7,-1269.0,208.74,2.11,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185719
UNION ALL SELECT 3132202,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6614.7,-1264.5,208.74,2.11,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185728
UNION ALL SELECT 3132203,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6522.4,-1295.7,200.95,0.60,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185721
UNION ALL SELECT 3132204,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6686.1,-1435.2,169.72,5.40,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185722
UNION ALL SELECT 3132205,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6681.4,-1431.4,168.33,5.40,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185722
UNION ALL SELECT 3132206,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6681.1,-1428.6,167.71,5.40,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185722
UNION ALL SELECT 3132207,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6679.0,-1433.5,167.24,5.40,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185722
UNION ALL SELECT 3132208,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6521.5,-1298.7,200.95,0.60,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185722
UNION ALL SELECT 3132209,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6524.9,-1293.8,200.95,0.60,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185722
UNION ALL SELECT 3132210,`id`,`map`,51,1443,`spawnMask`,`phaseMask`,0,0,`modelid`,`equipment_id`,-6525.3,-1297.7,200.94,0.60,300,0,0,0,0,0,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid`=185722;
UPDATE `creature` SET `zoneId`=51, `areaId`=246, `curhealth`=0 WHERE `guid`=401000 AND `id`=47393;
DELETE FROM `creature_addon` WHERE `guid` IN (3132200,3132201,3132202,3132203,3132204,3132205,3132206,3132207,3132208,3132209,3132210,401000);
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(3132200,0,0,0,0,0,1,1,0,0,0,0,0,0,'60921'),
(3132201,0,0,0,0,0,1,1,0,0,0,0,0,0,'60921'),
(3132202,0,0,0,0,0,1,1,0,0,0,0,0,0,'60921'),
(3132203,0,0,0,0,0,1,1,0,0,0,0,0,0,'60921'),
(3132204,0,0,0,0,0,0,1,0,0,0,0,0,0,'60921'),
(3132205,0,0,0,0,0,0,1,0,0,0,0,0,0,'60921'),
(3132206,0,0,0,0,0,0,1,0,0,0,0,0,0,'60921'),
(3132207,0,0,0,0,0,0,1,0,0,0,0,0,0,'60921'),
(3132208,0,0,0,0,0,0,1,0,0,0,0,0,0,'60921'),
(3132209,0,0,0,0,0,0,1,0,0,0,0,0,0,'60921'),
(3132210,0,0,0,0,0,0,1,0,0,0,0,0,0,'60921'),
(401000,0,0,0,0,0,1,1,0,0,0,0,0,0,'60921');

-- B-5 (c): the players' detections, zone 51: Thorium Point copies (type 12) outside the window, Slag Pit copies (type 9)
-- inside it.
DELETE FROM `spell_area` WHERE `spell` IN (88516,88514) AND `area`=51;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(88516,51,28052,0,0,0,2,1,1,0),
(88516,51,28062,0,0,0,2,1,64,0),
(88514,51,28052,28062,0,0,2,1,74,11);

-- B-6: each copy greets with its own text.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=14 AND `SourceGroup` IN (12293,5966);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(14,12293,17268,0,0,31,1,3,14625,185729,0,0,0,'','Overseer Oilfist - welcome text on the Thorium Point copy'),
(14,12293,17268,0,0,8,0,28064,0,0,1,0,0,'','Overseer Oilfist - welcome text until Welcome to the Brotherhood is rewarded'),
(14,12293,17269,0,0,31,1,3,14625,3132200,0,0,0,'','Overseer Oilfist - Slag Pit text on the Slag Pit copy'),
(14,12293,17270,0,0,31,1,3,14625,185729,0,0,0,'','Overseer Oilfist - after-chain text on the Thorium Point copy'),
(14,12293,17270,0,0,8,0,28064,0,0,0,0,0,'','Overseer Oilfist - after-chain text once Welcome to the Brotherhood is rewarded'),
(14,5966,7120,0,0,31,1,3,14626,185719,0,0,0,'','Taskmaster Scrange - Thorium Point text on the Thorium Point copy'),
(14,5966,17267,0,0,31,1,3,14626,3132201,0,0,0,'','Taskmaster Scrange - Slag Pit text on the Slag Pit copy');
