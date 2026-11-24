-- Echo Isles spawns: a Spirit Healer at the graveyard, and four posed-dead naga at Spitescale Cove no longer attackable.
--
-- 1. Spirit Healer 6491 at the Echo Isles graveyard. Sourced: both TDBs (259325, and a second copy 452540 on the same spot in
--    12.1.0) at -1039.63,-5416.73,13.3721 o 3.14159, respawn 300; game_graveyard_zone 1700 -> ghost zone 6453; WorldSafeLocs 1700
--    at -1044.98,-5417.07. mop had none, so a ghost who died on the isles found no one to resurrect him there. Columns as the
--    Durotar Spirit Healer 371370 (phase 0; TDB phase 169 is retail's generic phase).
DELETE FROM `creature` WHERE `guid` = 3164500;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`, `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3164500, 6491, 1, 6453, 4875, 1, 65535, 0, 0, 0, 0, -1039.63, -5416.73, 13.3721, 3.14159, 300, 0, 0, 0, 4120, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);

-- 2. Four Spitescale Wavethrashers posed dead (Permanent Feign Death 29266 on their spawn addon, idle) beside Tortunga and a Watcher
--    at Spitescale Cove had spawn unit_flags 0 (template 0x8000): hostile, attackable corpses, and targets for the Tribesmen's
--    "attack the closest naga" rows. They get IMMUNE_TO_PC | IMMUNE_TO_NPC (33536) as their two neighbours 251632 / 251634 already
--    have. Sourced: the six TDB corpse spots (29266); the lesson of Badlands (2026-11-15) and Swamp of Sorrows (2026-11-22).
--    All six are MovementType 0 and no other spawn in the zone carries 29266 or stand state 7 (checked), so no walking corpses.
UPDATE `creature` SET `unit_flags` = 33536 WHERE `guid` IN (251623, 251624, 251626, 251737);
