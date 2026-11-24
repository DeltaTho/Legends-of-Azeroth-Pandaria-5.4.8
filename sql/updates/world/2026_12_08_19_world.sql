-- Darkspear Hold: Vol'jin's vision brazier and its smoke in two layers, before and after An Ancient Enemy, as both TDBs have them.
-- Sourced: TDB spell_area 73147 See Quest Invis 1 (type 7) in 4865/4866/4875 while 24814 is not taken, and 73148 See Quest Invis 2
-- (type 8) there from 24814 complete or rewarded; the vision bunny 38003 twice on one spot (TDB 309030 aura 49414, type 7, and
-- 397120 aura 49415, type 8); the Vision Brazier objects 202434 (gameobject_addon invisibility type 7, value 1) and 202444 (type 8,
-- value 100) on one spot.
-- mop had the bunny (with Vol'jin's Vision Smoke 73158) only through 49416 from More Than Expected until 24626 was rewarded, so the
-- Thrall vision after 24814 and every Garrosh replay after 24626 played without smoke, and both braziers stood visible on one spot.
-- mop's 49416 / 49417 rows in area 4866 are replaced: nothing else in 4865/4866/4875 has type 7 or 8 invisibility (Tortunga 251701
-- moved to type 4 in 2026_12_08_12); 49417's rows in 4863 (Swiftclaw) stay.
-- What the player sees: until he takes An Ancient Enemy, one brazier (202434) with the smoking bunny; from its completion on, the
-- other brazier (202444) with the second smoking bunny; while 24814 is in progress, neither (as the TDBs).
-- Ours: racemask 0 (TDB: 128), as for 73205 / 73206, so non-trolls on the chain see the brazier and the smoke too; the bunny keeps
-- mop's smoke aura 73158 on both copies (the TDB copies carry only the invisibility, and no source says when the smoke shows).
-- Vol'jin's Garrosh-vision rows (38966 ids 3 and 7, list 3896600 id 1) activate / face 202434 instead of 202444, so the brazier
-- that lights is the one a player sees before 24814; the Thrall-vision rows (ids 27, 28, 34) keep 202444. A Garrosh replay after
-- 24814 lights 202434, which that player no longer sees (smoke and vision still play).
DELETE FROM `spell_area` WHERE `spell` IN (49416, 49417) AND `area` = 4866;
DELETE FROM `spell_area` WHERE `spell` IN (73147, 73148) AND `area` IN (4865, 4866, 4875);
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_status`, `quest_end_status`) VALUES
(73147, 4865, 0, 24814, 0, 0, 2, 1, 0, 1),
(73147, 4866, 0, 24814, 0, 0, 2, 1, 0, 1),
(73147, 4875, 0, 24814, 0, 0, 2, 1, 0, 1),
(73148, 4865, 24814, 0, 0, 0, 2, 1, 66, 0),
(73148, 4866, 24814, 0, 0, 0, 2, 1, 66, 0),
(73148, 4875, 24814, 0, 0, 0, 2, 1, 66, 0);

-- The second vision bunny (after 24814), on the first one's spot, columns and addon as 251568 with 49415 for 49414.
DELETE FROM `creature_addon` WHERE `guid` = 3164503;
DELETE FROM `creature` WHERE `guid` = 3164503;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`, `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3164503, 38003, 1, 6453, 4866, 1, 1, 0, 0, 27823, 0, -1322.48, -5608.93, 25.0355, 3.97935, 300, 0, 0, 0, 42, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `MountCreatureID`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvPFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(3164503, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '49415 73158');

-- The two braziers, one per layer.
DELETE FROM `gameobject_addon` WHERE `guid` IN (172914, 181859);
INSERT INTO `gameobject_addon` (`guid`, `invisibilityType`, `invisibilityValue`) VALUES
(172914, 7, 1),
(181859, 8, 100);

-- Vol'jin's Garrosh vision lights the pre-24814 brazier.
UPDATE `smart_scripts` SET `target_param1` = 202434 WHERE `entryorguid` = 38966 AND `source_type` = 0 AND `id` IN (3, 7) AND `target_type` = 20;
UPDATE `smart_scripts` SET `target_param1` = 202434 WHERE `entryorguid` = 3896600 AND `source_type` = 9 AND `id` = 1 AND `target_type` = 20;
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 38966;
