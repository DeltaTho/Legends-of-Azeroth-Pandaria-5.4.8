-- Swamp of Sorrows, the Bloodmire stage II: Marshtide Knights fighting the Stonard Ogres.
--
-- Sourced: the knights ride against the ogres in the advanced battle ("I've sent in our cavalry ... Our knights are
-- well-matched against the brutes, but they're going to need help", 27795; Horde progress text of 27854 (TDB 4.4.2): "The
-- ogres are powerful, but without help they will fall to the Alliance riders"); Tides of Darkness (H) 27854 is "slay 6
-- Marshtide Knights in the Bloodmire", and the only six knights stood as a mounted block inside Marshtide Watch, beside
-- level-60 and level-85 sentries (those six stay, phase 0, sniffed in both TDBs). Wowhead MoP Classic has 94 knight pins, 89
-- of them across the Bloodmire.
-- Ours: the count (30, plan question 2: the knight pins are as dense as the ogres', whose 70 mop spawns all sit under pins);
-- the points (the centroids of the knight pins outside the Watch, merged within 20 yd where at least two pins agree; heights
-- from the 5.4.8 terrain (ground.py); a point in swamp water, on a slope of more than 2 yd within its 5-yd wander, within 3 yd
-- of a tree stump or within 4 yd of another spawn was moved to the nearest spot within 10 yd without them: 19 moved 0.5-9 yd,
-- 11 as pinned; 3136403 kept on a 2.2-yd slope, 3136406 / 3136407 / 3136409 / 3136415 / 3136419 / 3136422 on 2.2-2.5-yd
-- slopes, nothing flatter within 10 yd); facing Stonard; phase 302 (seen only while a stage-II quest is held); respawn 60 s
-- and a 5-yd wander (the pins scatter, no path is known), 2 yd for the ten on the water's edge (3136403, 06, 07, 09, 10,
-- 11, 13, 15, 16, 22: their spot is dry, half of a 5-yd circle is swamp up to 1 yd deep); armed (creature_equip_template 1: the Watch block has none). The
-- template (mount 8469 in its addon, no AI: plain melee, sparring cap 80 % in 2026_11_23_21) is unchanged. Changing the count
-- is this file alone.

DELETE FROM `creature` WHERE `guid` BETWEEN 3136400 AND 3136429;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3136400,46414,0,8,5460,1,1,302,0,0,1,-10183.3,-3474.3,22.18,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136401,46414,0,8,5460,1,1,302,0,0,1,-10201.5,-3478.8,22.58,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136402,46414,0,8,5460,1,1,302,0,0,1,-10141.2,-3490.5,23.40,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136403,46414,0,8,5460,1,1,302,0,0,1,-10249.8,-3488.4,18.46,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136404,46414,0,8,5460,1,1,302,0,0,1,-10215.4,-3497.8,22.43,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136405,46414,0,8,5460,1,1,302,0,0,1,-10170.0,-3508.5,23.28,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136406,46414,0,8,5460,1,1,302,0,0,1,-10263.6,-3520.5,18.38,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136407,46414,0,8,5460,1,1,302,0,0,1,-10223.3,-3522.0,18.41,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136408,46414,0,8,5460,1,1,302,0,0,1,-10280.8,-3523.1,22.16,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136409,46414,0,8,5460,1,1,302,0,0,1,-10150.4,-3541.5,18.39,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136410,46414,0,8,5460,1,1,302,0,0,1,-10189.6,-3545.1,18.37,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136411,46414,0,8,5460,1,1,302,0,0,1,-10263.7,-3550.0,18.35,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136412,46414,0,8,5460,1,1,302,0,0,1,-10239.7,-3553.6,23.91,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136413,46414,0,8,5460,1,1,302,0,0,1,-10286.2,-3552.6,18.38,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136414,46414,0,8,5460,1,1,302,0,0,1,-10216.6,-3574.2,24.14,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136415,46414,0,8,5460,1,1,302,0,0,1,-10295.8,-3583.7,18.39,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136416,46414,0,8,5460,1,1,302,0,0,1,-10332.2,-3589.2,18.40,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136417,46414,0,8,5460,1,1,302,0,0,1,-10270.8,-3604.3,24.43,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136418,46414,0,8,5460,1,1,302,0,0,1,-10351.8,-3601.3,20.51,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136419,46414,0,8,5460,1,1,302,0,0,1,-10204.8,-3622.1,22.22,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136420,46414,0,8,5460,1,1,302,0,0,1,-10298.3,-3616.3,22.00,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136421,46414,0,8,5460,1,1,302,0,0,1,-10335.1,-3621.4,21.46,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136422,46414,0,8,5460,1,1,302,0,0,1,-10182.0,-3629.1,18.36,2.16,60,0,2,0,1,0,1,0,0,0,0,0,'',0,0),
(3136423,46414,0,8,5460,1,1,302,0,0,1,-10245.6,-3625.1,22.55,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136424,46414,0,8,5460,1,1,302,0,0,1,-10279.9,-3626.4,22.59,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136425,46414,0,8,5460,1,1,302,0,0,1,-10185.4,-3650.8,23.18,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136426,46414,0,8,5460,1,1,302,0,0,1,-10215.7,-3654.8,22.11,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136427,46414,0,8,5460,1,1,302,0,0,1,-10264.8,-3651.5,23.17,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136428,46414,0,8,5460,1,1,302,0,0,1,-10180.0,-3683.2,22.96,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0),
(3136429,46414,0,8,5460,1,1,302,0,0,1,-10231.3,-3689.1,23.96,2.16,60,0,5,0,1,0,1,0,0,0,0,0,'',0,0);
