-- Darkspear Hold: the quest-invisibility layers of the attack on Spitescale Cove, as both TDBs have them.
-- Sourced: TDB 4.4.2 spell_area 73205 See Quest Invis 3 (type 9) in areas 4865/4866/4875 from 24622 A Troll's Truest Companion
-- rewarded until 25035 Breaking the Line rewarded, and 73206 See Quest Invis 4 (type 4) in the same three areas while the player
-- lacks 73205; TDB spawn auras: Tortunga by Jornun 60921 (type 9), Tortunga by Vol'jin 65017 (type 4), Jornun twice on one spot
-- (251565 60921 / 309041 65017). mop instead had 65497 (type 9) in 4866 from 24626 complete only, and nothing gave type 4.
-- What changes for the player:
-- * Vanira 39027 and the Hold's Morakki 251557 (65017) now stand at the Hold before 24622 and after 25035 (mop: never).
-- * Jornun, Zuni 38931 and the 14 bat-riding Watchers 39028 (60921) show from 24622 rewarded (mop: from 24626 complete).
-- * One Tortunga at a time at the Hold: the 25035 giver by Jornun inside the window, the one by Vol'jin outside it (mop showed both
--   from More Than Expected until 24626 was handed in). The third Tortunga at Spitescale Cove is unchanged.
-- * The Hold's Morakki stays hidden while 25035 is in the log, so it is still handed in at Spitescale Cove, not at the Hold.
-- Ours: racemask 0 on the two new spells, where the TDB has 128 (troll). The class line and this chain are open to every Horde
-- race (AllowableRaces 33555378). With 128 an orc or a tauren would lose the Hold's half of the chain: Tortunga by Jornun (the
-- Hold's 25035 giver, visible to everyone in mop), Jornun and his ride, Zuni and the riders. 25035 itself would still be takeable
-- from the third Tortunga, 251625 at Spitescale Cove (no aura), and handed in beside him, skipping the ride.
-- Sourced (both TDBs): a second Vanira inside the window, walking between two spots by the Hold's entrance (TDB 251568, aura 60921,
-- path 2013768 of four points with a 30 s pause), so Vanira stands at the Hold in every state: this one from 24622 rewarded to
-- 25035 rewarded, 251702 (65017) outside it. New guid 3164502, path 31645020 (the TDB's points).
-- Ours: Jornun's ride option ("Do you have a raptor that can take me there?") only while 25035 is in the log; with Jornun now
-- standing there in every state, it would otherwise hand anyone a raptor ride to Spitescale at any time.
-- Ours: Tortunga's "On Accepted Quest" rows send the player to Jornun guid 251556 instead of the closest Jornun, so the hidden
-- copy on the same spot never says "Just let me know when ya ready, mon." (creature text reaches players who cannot see him).
-- Checked in the core: a spell_area aura that depends on another (aura_spell -73205) is re-evaluated row by row when 73205 lands or
-- goes (Aura::HandleAuraSpecificMods); the rows for the other two areas then strip 73206, but every change of 73205 comes from
-- Player::UpdateAreaDependentAuras (quest update, area change, login, resurrection), whose cast pass right after puts 73206 back.
DELETE FROM `spell_area` WHERE `spell` = 65497 AND `area` = 4866 AND `quest_start` = 24626 AND `quest_end` = 25035;
DELETE FROM `spell_area` WHERE `spell` IN (73205, 73206) AND `area` IN (4865, 4866, 4875);
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_status`, `quest_end_status`) VALUES
(73205, 4865, 24622, 25035, 0, 0, 2, 1, 64, 11),
(73205, 4866, 24622, 25035, 0, 0, 2, 1, 64, 11),
(73205, 4875, 24622, 25035, 0, 0, 2, 1, 64, 11),
(73206, 4865, 0, 0, -73205, 0, 2, 1, 0, 0),
(73206, 4866, 0, 0, -73205, 0, 2, 1, 0, 0),
(73206, 4875, 0, 0, -73205, 0, 2, 1, 0, 0);

-- Tortunga by Jornun (25035 giver, guid 251587): inside the window. Other columns as his template addon (sheathed, emote 375).
DELETE FROM `creature_addon` WHERE `guid` = 251587;
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `MountCreatureID`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvPFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(251587, 0, 0, 0, 0, 0, 0, 1, 0, 375, 0, 0, 0, 0, '60921');
-- Tortunga by Vol'jin (guid 251701): outside the window (was 49414, type 7, More Than Expected -> 24626 rewarded).
UPDATE `creature_addon` SET `auras` = '65017' WHERE `guid` = 251701;
-- Jornun: the existing spawn takes the window, a second spawn on the same spot the rest. Other columns as his template addon.
DELETE FROM `creature_addon` WHERE `guid` IN (251556, 3164501);
DELETE FROM `creature` WHERE `guid` = 3164501;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`, `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3164501, 38989, 1, 6453, 4866, 1, 1, 0, 0, 30939, 0, -1330.82, -5558.85, 21.4903, 0.244346, 300, 0, 0, 0, 102, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `MountCreatureID`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvPFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(251556, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '60921'),
(3164501, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '65017');
-- Jornun's ride: only with Breaking the Line in the log. 25035 has no objectives, so it is complete on accept: CONDITION_QUESTSTATE
-- with mask 10 (incomplete or complete), not QUESTTAKEN (incomplete only). A Horde quest, positive condition.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 11131 AND `SourceEntry` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 11131, 0, 0, 0, 47, 0, 25035, 10, 0, 0, 0, 0, '', 'Jornun - raptor ride only with Breaking the Line in the log (incomplete or complete)');
-- Tortunga (25035 accepted): store the player, hand him to Jornun 251556 and set data 0 1 on that Jornun only.
UPDATE `smart_scripts` SET `target_type` = 10, `target_param1` = 251556, `target_param2` = 38989 WHERE `entryorguid` = 38440 AND `source_type` = 0 AND `id` IN (1, 2);
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 38440;
-- Walking Vanira (inside the window): spawn, addon (template columns, 60921, path) and the TDB path.
DELETE FROM `creature_addon` WHERE `guid` = 3164502;
DELETE FROM `creature` WHERE `guid` = 3164502;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`, `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3164502, 39027, 1, 6453, 4866, 1, 1, 0, 0, 30945, 0, -1333.31, -5545.3, 21.0493, 1.79769, 300, 0, 0, 0, 746050, 89080, 2, 0, 0, 0, 0, 0, '', 0, 0);
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `MountCreatureID`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`, `PvPFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(3164502, 31645020, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, '60921');
DELETE FROM `waypoint_data` WHERE `id` = 31645020;
INSERT INTO `waypoint_data` (`id`, `point`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `move_flag`, `action`, `action_chance`, `wpguid`) VALUES
(31645020, 1, -1333.31, -5545.3, 21.0493, 0, 0, 0, 0, 100, 0),
(31645020, 2, -1333.31, -5545.3, 21.0493, 1.79769, 30000, 0, 0, 100, 0),
(31645020, 3, -1317.9, -5539.2, 21.0698, 0, 0, 0, 0, 100, 0),
(31645020, 4, -1317.9, -5539.2, 21.0698, 2.19912, 0, 0, 0, 100, 0);
