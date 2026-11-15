-- Badlands: the Purified Black Dragon Egg still sits at Dr. Blam's camp at Agmond's End after Return to Blam, for good.
--
-- Sourced: comment on The Egg Lives On (2012-07-14 [+1]): "at 46.96, 56.97 ... you still see the Purified Black Dragon Egg
--   from when you turned in the Eye of the Watchers"; Wowhead pins 46.8,56.4 / 47.0,56.6; the spot is the scene's own DEST_DB
--   point of 87218 (-7009.21,-3344.54,241.687).
-- Ours: one static spawn of 46843 there (facing Blam's), hidden per spawn (not on the template: the Return to Blam scene
--   summons the same entry) by Generic Quest Invisibility 11 (83305, type 19, amount 100) and shown in Agmond's End 345 once
--   Return to Blam is rewarded, except while the scene's marker aura 87186 is on the player (the scene shows its own egg then).
--   Detections (type 19, no AreaGroup, used by no other row, creature or script): Generic Quest Invisibility Detection 11
--   105362 (1000) for the Alliance's 27794, Detect Quest Invis 11 102369 (1200) for the Horde's 27888.
-- Why two spells and not the plan's one (81742 with a row per faction): both rows depend on 87186, and when 87186 lands or goes
-- the core walks every row that depends on it and removes the row's spell when that row does not fit
-- (Aura::HandleAuraSpecificMods, SpellAuras.cpp:1560-1577). The other faction's row never fits, so with one shared spell the
-- egg stayed hidden after the scene for whichever faction's row comes first. No second type-22 detection is usable here
-- (84363 lasts 45 s, 84501 targets a vehicle passenger), hence type 19, which elsewhere in the zone only Nyxondra uses, 600 yd
-- away in Rhea's Camp with a detection limited to that ravine. Without the scene's 87186 the egg simply shows from the
-- hand-in on.

DELETE FROM `creature` WHERE `guid` = 3130400;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3130400, 46843, 0, 3, 345, 1, 1, 0, 0, 0, 0, -7009.21, -3344.54, 241.687, 3.29, 300, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);

DELETE FROM `creature_addon` WHERE `guid` = 3130400;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(3130400, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '83305');

DELETE FROM `spell_area` WHERE `spell` IN (105362, 102369);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(105362, 345, 27794, 0, -87186, 0, 2, 1, 64, 0),  -- Return to Blam (Alliance) rewarded, scene not running
(102369, 345, 27888, 0, -87186, 0, 2, 1, 64, 0);  -- Return to Blam (Horde)
