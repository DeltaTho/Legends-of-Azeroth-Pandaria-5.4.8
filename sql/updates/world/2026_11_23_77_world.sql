-- Swamp of Sorrows, Mostly Harmless 27536: the Stray Land Mines explode when a player runs onto one, not when he loots it carefully.
-- Sourced: the wiki note of 27536 ("Do not carelessly run over the landmines! They will explode. Carefully walk up to them and
--   right-click as soon as the cog lights up."); comments 2012-08-16 [+4], 2010-12-24 reply [+2], 2012-03-19 [+4], 2011-01-23 [+2],
--   2011-07-07 [+2], 2011-09-23 [+2]; the trap 205547 'Stray Land Mine (Armed)' (85452 -> Explosion Bunny 45842 -> 85445 Detonation,
--   both TDBs and the DBC). Neither TDB spawns the trap; this core fires an environmental trap only from a spawned one.
-- Ours: one trap per mine at the mine's position (gameobject 3136000-3136018, 120 s as the mines); 205545 data7 (linked trap) 0, as
--   the core would fire it on every opening; 205547 data2 radius 3 (TrinityCore and the Cataclysm core read the field as a diameter,
--   2.5 yd; this core as a radius: with 5 a careful looter stands on the trap's edge when the cog lights up 5 yd from the mine),
--   data4 1 (one shot, then away for its respawn time), data8 1 (server-side only); the ScriptNames (the mine takes its trap with
--   it when looted; the bunny explodes only beside a mine that is there; the explosion hits players and their pets only and uses
--   no object). This file can be dropped alone (user question 10): the mines then stay harmless as before.
-- Ships with sos-ac's 2026_11_23_01 (the mines' respawn 300 -> 120 s): only with it do mine and trap come back together; without it a
--   trap returns 180 s before its mine and does nothing until then (the bunny finds no mine).
-- Not as the sources: auto-loot (shift-click) from the edge sets a mine off every time, manual looting from there does not
--   (2012-03-19 [+4]; 2025-05-22 [+1] and its "verified" reply): here only distance counts, auto-loot from 3-5 yd is safe; pets set
--   mines off (2014-03-19 [+3]): here only players do (the core's environmental traps search players), pets are only hit.
-- The safe 3-5 yd band comes from reading the code (server GameObject::IsAtInteractDistance, client decomp CheckRange), not from an
--   in-game trial (the live server was in use): test it first.

DELETE FROM `gameobject` WHERE `guid` BETWEEN 3136000 AND 3136018 AND `id` = 205547;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `VerifiedBuild`) VALUES
(3136000, 205547, 0, 8, 8, 1, 1, 0, 0, -9838.81, -3957.11, 21.9247, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136001, 205547, 0, 8, 300, 1, 1, 0, 0, -9787.59, -4039.01, 19.7078, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136002, 205547, 0, 8, 8, 1, 1, 0, 0, -10024.5, -4030.46, 17.3741, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136003, 205547, 0, 8, 8, 1, 1, 0, 0, -9983.17, -4049.89, 23.7919, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136004, 205547, 0, 8, 8, 1, 1, 0, 0, -10055, -4080.11, 23.6496, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136005, 205547, 0, 8, 1778, 1, 1, 0, 0, -10140, -4051.5, 22.0306, -2.54818, 0, 0, -0.956305, 0.292372, 120, 0, 1, '', 0),
(3136006, 205547, 0, 8, 1778, 1, 1, 0, 0, -10181.8, -4086.56, 21.7547, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136007, 205547, 0, 8, 8, 1, 1, 0, 0, -9848.73, -3907.06, 17.385, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136008, 205547, 0, 8, 8, 1, 1, 0, 0, -9861.95, -4011.64, 21.9713, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136009, 205547, 0, 8, 300, 1, 1, 0, 0, -9789.04, -4082.38, 3.20602, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136010, 205547, 0, 8, 300, 1, 1, 0, 0, -9800.46, -4116.68, -0.376234, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136011, 205547, 0, 8, 300, 1, 1, 0, 0, -9850.08, -4085.52, 21.7225, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136012, 205547, 0, 8, 300, 1, 1, 0, 0, -9959.33, -4186.53, 23.2012, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136013, 205547, 0, 8, 8, 1, 1, 0, 0, -10016.2, -4172.39, 21.7682, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136014, 205547, 0, 8, 8, 1, 1, 0, 0, -9943.79, -4131.04, 23.6227, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136015, 205547, 0, 8, 8, 1, 1, 0, 0, -9914.43, -4050.56, 17.3741, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136016, 205547, 0, 8, 8, 1, 1, 0, 0, -9902.76, -4016.6, 22.9735, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0),
(3136017, 205547, 0, 8, 8, 1, 1, 0, 0, -9919.27, -3842.72, 22.1676, 2.65289, 0, 0, 0.970295, 0.241925, 120, 0, 1, '', 0),
(3136018, 205547, 0, 8, 8, 1, 1, 0, 0, -9924.54, -3934.79, 17.3741, -2.26892, 0, 0, -0.906307, 0.422619, 120, 0, 1, '', 0);

UPDATE `gameobject_template` SET `data7` = 0, `AIName` = '', `ScriptName` = 'go_bogpaddle_stray_land_mine' WHERE `entry` = 205545;
UPDATE `gameobject_template` SET `data2` = 3, `data4` = 1, `data8` = 1 WHERE `entry` = 205547;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_bogpaddle_land_mine_explosion_bunny' WHERE `entry` = 45842;

DELETE FROM `spell_script_names` WHERE `spell_id` = 85445 AND `ScriptName` = 'spell_bogpaddle_land_mine_detonation';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(85445, 'spell_bogpaddle_land_mine_detonation');
