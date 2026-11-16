-- Searing Gorge, Lunk 47429 (plan B-2): the Iron Summit Lunk is seen only while Deceit 28033 needs him or Rendan's Weakness
-- 28034 is still to be taken from him, and a second Lunk stands at Thorium Point once the zone's finale and Spider Rider are
-- done, with Lunk Like Your Style 28053.
--
-- Sourced:
-- - 80852 Generic Quest Invisibility 10 (type 18) is the zone's own pair to See Quest Invis 10 88475 (castable only in area
--   5628, the Iron Summit) and 88582 (castable only in area 1446, Thorium Point) [DBC: SpellCastingRequirements 6434 / 6447 ->
--   AreaGroup 2812 / 2818].
-- - Lunk at Thorium Point after the finale and only for players who did Spider Rider: comment 28053 2011-03-27 [+22] and its
--   reply, wiki 28053 notes; Wowhead pin 47429 (38.8,26.0).
-- Ours:
-- - The spell_area rows (neither TDB has them): 88475 in area 5628 while 28033 is held (it has no objectives: COMPLETE), or
--   while 28034 is not taken and 28033 is rewarded (so Lunk is there to offer 28034 again after an abandon); 88582 in area
--   1446 once 28062 and 27959 are rewarded. The rows' areas keep the two type-18 detections apart: the spots are ~630 yd
--   apart and each detection is removed on leaving its area (UpdateAreaDependentAuras -> CheckLocation, AreaGroup).
-- - Spawn 3132000: the pin falls on the stairs from the lower to the upper deck (vmap 323.8, no navmesh polygon there), so
--   the spawn stands 6 yd north at the top of the stairs on the upper deck: vmap floor 325.7, navmesh polygon 7342 (326.0),
--   connected to Overseer Oilfist's polygon 7035 [mmtile 0000_44_34]. No sniffed spawn stands on that deck within 20 yd.
--   He keeps the template's dance emote (orchestrator ruling 4).
-- - Rows keyed on 28053 held (status 10) in both areas: mop offered 28053 at the Iron Summit Lunk with no prerequisite, and
--   one character (mop_characters, 2026-11-16) holds it; without them it would have no visible ender.
-- The 28034 dance follower (88450) is section D's; 28053 PrevQuestID 28062 is section A's (A-12).

UPDATE `creature_template_addon` SET `auras`='80852' WHERE `entry`=47429;

DELETE FROM `creature` WHERE `guid`=3132000;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3132000,47429,0,51,1446,1,1,0,0,0,0,-6481.0,-1189.0,325.7,2.3,300,0,0,0,0,0,0,0,0,0,0,0,'',0,0);

DELETE FROM `spell_area` WHERE `spell`=88475 AND `area`=5628;
DELETE FROM `spell_area` WHERE `spell`=88582 AND `area`=1446;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(88475,5628,28033,0,0,0,2,1,10,0),
(88475,5628,28034,28033,0,0,2,1,1,64),
(88475,5628,28053,0,0,0,2,1,10,0),
(88582,1446,28062,27959,0,0,2,1,64,64),
(88582,1446,28053,0,0,0,2,1,10,0);
