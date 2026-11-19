-- Dustwind Cave (The Burning Blade 25232): the Burning Blade Thugs (3195), Neophytes (3196) and Cultists (3199) stood in stacks of two or
-- three, 0.2-2.6 yd apart, on each of the 14 spots both TDBs (4.4.2 and 12.1.0, guids 310414-310453) have one of them on; a level-8 player
-- pulled two or three at once on almost every spot. Every mop spawn of the three entries is within 2.1 yd of one of those 14 points, so
-- there is no extra density that is not stacked: one per point stays, the copy nearest the TDB point, except at 867.9,-4753.4 where the
-- nearest (253514) walks a 5-point path of 1-2 yd and the TDBs have the Neophyte idle, so idle 251476 (1.0 yd) stays.
-- Section 4 deletes Neophytes 253509 and 253337 (its file 2026_11_27_70); they are not touched here. 32 -> 14 spawns, as both TDBs.
-- Deleted (entry, partner kept, distance to the partner):
--   Thug 3195:      251343 and 251471 (kept 253500, 0.29 / 1.31 yd); 251475 (kept 251345, 1.92 yd)
--   Neophyte 3196:  251270 (kept 251430, 0.50 yd); 251474 and 253511 (kept 251346, 1.46 / 0.61 yd); 251347 and 253391 (kept 251452,
--                   0.96 / 0.35 yd); 251348 and 253514 (kept 251476, 0.75 / 0.94 yd); 251472 (kept 251349, 0.51 yd)
--   Cultist 3199:   251431 (kept 251271, 1.81 yd); 251332 and 253371 (kept 251445, 1.24 / 0.88 yd); 251334 and 253375 (kept 251447,
--                   1.58 / 0.71 yd); 251333 and 253374 (kept 251446, 0.94 / 1.82 yd)
-- 253514 and 253371 take their creature_addon rows and paths (waypoint_data 253514, 253371: 1-2 yd jiggles, no actions). No pool,
-- formation, game_event, linked_respawn, movement override, vehicle, waypoint script or guid SmartAI rows use any of the 18 guids.
-- Respawn: the 14 kept go from 300 s to 120 s, as both TDBs, so the cave still restocks about as fast as before (14 per 2 min = 7 a minute,
-- against 32 per 5 min = 6.4): one clear yields about 10 Spellscrolls on average (5 x 49.9 % + 5 x 89.1 % + 4 x 80.4 %), about 8 kills
-- per player for 6 scrolls, so the cave serves one player per clear and several at a time with the 2 min respawn. Sourced (positions,
-- counts, respawn); the choice of the kept copy is ours.
DELETE FROM `creature_addon` WHERE `guid` IN (251343,251471,251475,251270,251474,253511,251347,253391,251348,253514,251472,251431,251332,253371,251334,253375,251333,253374);
DELETE FROM `waypoint_data` WHERE `id` IN (253514, 253371);
DELETE FROM `creature` WHERE `id` IN (3195, 3196, 3199) AND `guid` IN (251343,251471,251475,251270,251474,253511,251347,253391,251348,253514,251472,251431,251332,253371,251334,253375,251333,253374);
UPDATE `creature` SET `spawntimesecs` = 120 WHERE `id` IN (3195, 3196, 3199) AND `guid` IN (251341,251342,251344,253500,251345,251430,251346,251452,251476,251349,251271,251445,251447,251446);
