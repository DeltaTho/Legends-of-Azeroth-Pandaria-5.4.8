-- Badlands: Dr. Hieronymus Blam stands at the mouth of the Hidden Clutch cave once Devastation is handed in, to give and take
-- The Egg Lives On. Before this the only Blam was at Agmond's End.
--
-- Sourced: "Upon completing the quest, Dr. Hieronymus Blam appears at the mouth of the cave" (wiki, Devastation notes); Wowhead
--   pins of 46664 at (17.8,30.6) / (18,30.4); Generic Quest Invisibility 12 (83323, type 20, amount 100) and the cave's own "See
--   Quest Invis 12" 87428 (type 20, amount 1000, AreaGroup The Hidden Clutch 5592) from the 5.4.8 DBC, otherwise unused.
-- Ours: the spot (3 yd from the sniffed point of 87433 RG: Summon Rhea, z on the floor of the cave-mouth model Md_Warmden.wmo,
--   whose WMO area here is 5592; facing ours: to be checked with .gps) and the bound (from Devastation rewarded, for good).
-- The copy is a second spawn of the same entry 46664, so it carries Blam's quest rows and AI; The Egg Lives On is gated on
-- Devastation by another commit. The Agmond's End Blam also offers it from then on (accepted in the plan).

DELETE FROM `creature` WHERE `guid` = 3130203;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`)
SELECT 3130203,`id`,`map`,3,5592,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,-6480.0,-2449.5,306.54,2.39,`spawntimesecs`,`spawntimesecs_max`,0,0,`curhealth`,`curmana`,0,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,0 FROM `creature` WHERE `guid` = 162109;

-- the template addon's values (sheathed weapons) plus the invisibility
DELETE FROM `creature_addon` WHERE `guid` = 3130203;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(3130203, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, '83323');

DELETE FROM `spell_area` WHERE `spell` = 87428;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(87428, 5592, 27930, 0, 0, 0, 2, 1, 64, 0);  -- Devastation rewarded
