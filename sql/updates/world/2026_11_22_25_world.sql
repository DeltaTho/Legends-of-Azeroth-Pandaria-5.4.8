-- Burning Steppes: stage the story NPC copies, so each faction sees one Keeshan / Troteman / Ariok / Eitrigg, at the hub of its
-- own stage (dossier S4-staging; plan C-07, C-08, K14).
--
-- One mechanism zone-wide (the EPL Tyr's Hand pattern): each copy's spawn gets a phaseId; one phase_area row per phase on the zone
-- (AreaId 46) grants it under conditions source 26 (QUESTSTATE 47 masks 1 none, 10 in the log, 64 rewarded; TEAM 6 469 / 67;
-- ElseGroups OR'd). Phases are re-evaluated on area change and every quest status change.
-- Sourced windows (wiki and comments, S4-staging section 2): 47811 / 48559 at Flamestar Post until Chiselgrip 28184 / 28426 is taken;
-- 48109, 48110 / 48568 at Chiselgrip from 28184 / 28426 rewarded until Morgan's Vigil 28310 / Flame Crest 28442 is taken; 48306,
-- 48307 / 48565, 48569 at the Vigil / Flame Crest from 28310 / 28442 rewarded, Keeshan / Ariok hidden while his follower copy is out
-- (28314-28316 or 28321 / 28446-28448 or 28455 held). 48561 Ariok beside Eitrigg at Chiselgrip (comment; his standing there
-- inferred): the mop-only 80797 Generic Quest Invisibility 5 (no detection anywhere, so never visible; neither TDB has it) goes.
-- Ours: the encoding, the phase ids (Phase.dbc entries 223, 225, 1211, 1216, 314, 316, 330, 334, 400, 401, used nowhere in
-- mop_world or any branch's sql/updates; 230 and 290 were dropped because Tol Barad's 79457 and the Twilight Shift raid auras
-- grant them; 316 is also granted by 88438 Shifted (Bastion of Twilight) but goes with section E's followers), and the "also while one of his quests is held" extensions that keep every hand-in
-- reachable. The Keeshan 03 / Ariok 03 statics 373734 / 373702 are phased to the follower window (314 / 316) until section E's
-- follower replaces them (E deletes the spawns and these two phases).

DELETE FROM `phase_area` WHERE `AreaId`=46 AND `PhaseId` IN (225,1211,1216,314,223,334,400,401,316,330,230,290); -- 230, 290: ids of an earlier draft
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(46,225,'Burning Steppes - Flamestar Post - Keeshan 47811 (A): until Chiselgrip 28184 is taken, or while one of his quests is held'),
(46,1211,'Burning Steppes - Chiselgrip - Keeshan 48109, Troteman 48110 (A): from 28184 rewarded until Morgan''s Vigil 28310 is taken, or while one of their quests is held'),
(46,1216,'Burning Steppes - Morgan''s Vigil - Keeshan 48306 (A): from 28310 rewarded, hidden while his follower copy is out (28314-28316, 28321 held)'),
(46,314,'Burning Steppes - Morgan''s Vigil - Keeshan 03 48346 static (A, until the follower E2 replaces it): while 28314-28316 or 28321 are held'),
(46,223,'Burning Steppes - Morgan''s Vigil - Troteman 48307 (A): from 28310 rewarded'),
(46,334,'Burning Steppes - Flamestar Post - Ariok 48559 (H): until Chiselgrip 28426 is taken, or while one of his quests is held'),
(46,400,'Burning Steppes - Chiselgrip - Eitrigg 48568, Ariok 48561 (H): from 28426 rewarded until Flame Crest 28442 is taken, or while one of Eitrigg''s quests is held'),
(46,401,'Burning Steppes - Flame Crest - Ariok 48565 (H): from 28442 rewarded, hidden while his follower copy is out (28446-28448, 28455 held)'),
(46,316,'Burning Steppes - Flame Crest - Ariok 03 48567 static (H, until the follower E2 replaces it): while 28446-28448 or 28455 are held'),
(46,330,'Burning Steppes - Flame Crest - Eitrigg 48569 (H): from 28442 rewarded');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceEntry`=46 AND `SourceGroup` IN (225,1211,1216,314,223,334,400,401,316,330,230,290);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,225,46,0,0,6,0,469,0,0,0,0,0,'','Burning Steppes phase 225 - Alliance'),
(26,225,46,0,0,47,0,28184,1,0,0,0,0,'','Burning Steppes phase 225 - 28184 not taken'),
(26,225,46,0,1,47,0,28174,10,0,0,0,0,'','Burning Steppes phase 225 - 28174 held'),
(26,225,46,0,2,47,0,28177,10,0,0,0,0,'','Burning Steppes phase 225 - 28177 held'),
(26,225,46,0,3,47,0,28178,10,0,0,0,0,'','Burning Steppes phase 225 - 28178 held'),
(26,225,46,0,4,47,0,28179,10,0,0,0,0,'','Burning Steppes phase 225 - 28179 held'),
(26,225,46,0,5,47,0,28183,10,0,0,0,0,'','Burning Steppes phase 225 - 28183 held'),
(26,225,46,0,6,47,0,28416,10,0,0,0,0,'','Burning Steppes phase 225 - 28416 held'),
(26,225,46,0,7,47,0,28666,10,0,0,0,0,'','Burning Steppes phase 225 - 28666 held'),
(26,1211,46,0,0,6,0,469,0,0,0,0,0,'','Burning Steppes phase 1211 - Alliance'),
(26,1211,46,0,0,47,0,28184,64,0,0,0,0,'','Burning Steppes phase 1211 - 28184 rewarded'),
(26,1211,46,0,0,47,0,28310,1,0,0,0,0,'','Burning Steppes phase 1211 - 28310 not taken'),
(26,1211,46,0,1,47,0,28202,10,0,0,0,0,'','Burning Steppes phase 1211 - 28202 held'),
(26,1211,46,0,2,47,0,28203,10,0,0,0,0,'','Burning Steppes phase 1211 - 28203 held'),
(26,1211,46,0,3,47,0,28204,10,0,0,0,0,'','Burning Steppes phase 1211 - 28204 held'),
(26,1211,46,0,4,47,0,28205,10,0,0,0,0,'','Burning Steppes phase 1211 - 28205 held'),
(26,1211,46,0,5,47,0,28246,10,0,0,0,0,'','Burning Steppes phase 1211 - 28246 held'),
(26,1211,46,0,6,47,0,28253,10,0,0,0,0,'','Burning Steppes phase 1211 - 28253 held'),
(26,1211,46,0,7,47,0,28279,10,0,0,0,0,'','Burning Steppes phase 1211 - 28279 held'),
(26,1211,46,0,8,47,0,28286,10,0,0,0,0,'','Burning Steppes phase 1211 - 28286 held'),
(26,1216,46,0,0,6,0,469,0,0,0,0,0,'','Burning Steppes phase 1216 - Alliance'),
(26,1216,46,0,0,47,0,28310,64,0,0,0,0,'','Burning Steppes phase 1216 - 28310 rewarded'),
(26,1216,46,0,0,47,0,28314,10,0,1,0,0,'','Burning Steppes phase 1216 - 28314 NOT held'),
(26,1216,46,0,0,47,0,28315,10,0,1,0,0,'','Burning Steppes phase 1216 - 28315 NOT held'),
(26,1216,46,0,0,47,0,28316,10,0,1,0,0,'','Burning Steppes phase 1216 - 28316 NOT held'),
(26,1216,46,0,0,47,0,28321,10,0,1,0,0,'','Burning Steppes phase 1216 - 28321 NOT held'),
(26,314,46,0,0,47,0,28314,10,0,0,0,0,'','Burning Steppes phase 314 - 28314 held'),
(26,314,46,0,1,47,0,28315,10,0,0,0,0,'','Burning Steppes phase 314 - 28315 held'),
(26,314,46,0,2,47,0,28316,10,0,0,0,0,'','Burning Steppes phase 314 - 28316 held'),
(26,314,46,0,3,47,0,28321,10,0,0,0,0,'','Burning Steppes phase 314 - 28321 held'),
(26,223,46,0,0,6,0,469,0,0,0,0,0,'','Burning Steppes phase 223 - Alliance'),
(26,223,46,0,0,47,0,28310,64,0,0,0,0,'','Burning Steppes phase 223 - 28310 rewarded'),
(26,334,46,0,0,6,0,67,0,0,0,0,0,'','Burning Steppes phase 334 - Horde'),
(26,334,46,0,0,47,0,28426,1,0,0,0,0,'','Burning Steppes phase 334 - 28426 not taken'),
(26,334,46,0,1,47,0,28418,10,0,0,0,0,'','Burning Steppes phase 334 - 28418 held'),
(26,334,46,0,2,47,0,28419,10,0,0,0,0,'','Burning Steppes phase 334 - 28419 held'),
(26,334,46,0,3,47,0,28420,10,0,0,0,0,'','Burning Steppes phase 334 - 28420 held'),
(26,334,46,0,4,47,0,28421,10,0,0,0,0,'','Burning Steppes phase 334 - 28421 held'),
(26,334,46,0,5,47,0,28425,10,0,0,0,0,'','Burning Steppes phase 334 - 28425 held'),
(26,334,46,0,6,47,0,28667,10,0,0,0,0,'','Burning Steppes phase 334 - 28667 held'),
(26,400,46,0,0,6,0,67,0,0,0,0,0,'','Burning Steppes phase 400 - Horde'),
(26,400,46,0,0,47,0,28426,64,0,0,0,0,'','Burning Steppes phase 400 - 28426 rewarded'),
(26,400,46,0,0,47,0,28442,1,0,0,0,0,'','Burning Steppes phase 400 - 28442 not taken'),
(26,400,46,0,1,47,0,28428,10,0,0,0,0,'','Burning Steppes phase 400 - 28428 held'),
(26,400,46,0,2,47,0,28429,10,0,0,0,0,'','Burning Steppes phase 400 - 28429 held'),
(26,400,46,0,3,47,0,28430,10,0,0,0,0,'','Burning Steppes phase 400 - 28430 held'),
(26,400,46,0,4,47,0,28431,10,0,0,0,0,'','Burning Steppes phase 400 - 28431 held'),
(26,400,46,0,5,47,0,28434,10,0,0,0,0,'','Burning Steppes phase 400 - 28434 held'),
(26,400,46,0,6,47,0,28436,10,0,0,0,0,'','Burning Steppes phase 400 - 28436 held'),
(26,400,46,0,7,47,0,28440,10,0,0,0,0,'','Burning Steppes phase 400 - 28440 held'),
(26,400,46,0,8,47,0,28441,10,0,0,0,0,'','Burning Steppes phase 400 - 28441 held'),
(26,401,46,0,0,6,0,67,0,0,0,0,0,'','Burning Steppes phase 401 - Horde'),
(26,401,46,0,0,47,0,28442,64,0,0,0,0,'','Burning Steppes phase 401 - 28442 rewarded'),
(26,401,46,0,0,47,0,28446,10,0,1,0,0,'','Burning Steppes phase 401 - 28446 NOT held'),
(26,401,46,0,0,47,0,28447,10,0,1,0,0,'','Burning Steppes phase 401 - 28447 NOT held'),
(26,401,46,0,0,47,0,28448,10,0,1,0,0,'','Burning Steppes phase 401 - 28448 NOT held'),
(26,401,46,0,0,47,0,28455,10,0,1,0,0,'','Burning Steppes phase 401 - 28455 NOT held'),
(26,316,46,0,0,47,0,28446,10,0,0,0,0,'','Burning Steppes phase 316 - 28446 held'),
(26,316,46,0,1,47,0,28447,10,0,0,0,0,'','Burning Steppes phase 316 - 28447 held'),
(26,316,46,0,2,47,0,28448,10,0,0,0,0,'','Burning Steppes phase 316 - 28448 held'),
(26,316,46,0,3,47,0,28455,10,0,0,0,0,'','Burning Steppes phase 316 - 28455 held'),
(26,330,46,0,0,6,0,67,0,0,0,0,0,'','Burning Steppes phase 330 - Horde'),
(26,330,46,0,0,47,0,28442,64,0,0,0,0,'','Burning Steppes phase 330 - 28442 rewarded');
UPDATE `creature` SET `phaseId`=225 WHERE `guid`=318100 AND `id`=47811;
UPDATE `creature` SET `phaseId`=1211 WHERE `guid`=318102 AND `id`=48109;
UPDATE `creature` SET `phaseId`=1211 WHERE `guid`=318101 AND `id`=48110;
UPDATE `creature` SET `phaseId`=1216 WHERE `guid`=318104 AND `id`=48306;
UPDATE `creature` SET `phaseId`=314 WHERE `guid`=373734 AND `id`=48346;
UPDATE `creature` SET `phaseId`=223 WHERE `guid`=318103 AND `id`=48307;
UPDATE `creature` SET `phaseId`=334 WHERE `guid`=165205 AND `id`=48559;
UPDATE `creature` SET `phaseId`=400 WHERE `guid`=313223 AND `id`=48568;
UPDATE `creature` SET `phaseId`=400 WHERE `guid`=313224 AND `id`=48561;
UPDATE `creature` SET `phaseId`=401 WHERE `guid`=313226 AND `id`=48565;
UPDATE `creature` SET `phaseId`=316 WHERE `guid`=373702 AND `id`=48567;
UPDATE `creature` SET `phaseId`=330 WHERE `guid`=313225 AND `id`=48569;
-- Ariok 48561: the mop-only 80797 (GQI 5, no detection anywhere: never visible) goes; phase 400 stages him (both TDBs: no aura).
UPDATE `creature_template_addon` SET `auras`=NULL WHERE `entry`=48561 AND `auras`='80797';
