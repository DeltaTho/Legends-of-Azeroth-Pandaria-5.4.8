-- Searing Gorge, C-13: the Tower Fires of 28029 Set Them Ablaze (R-12).
-- 23 Tower Fire objects (spawntimesecs 300) burned all the time; 8 stand at brazier level (dz -2..+0.4 from the Sentry Brazier;
-- kept: 156252 156253 156264-156267 156273 156274, the "wall of flame around the braziers", Wowhead 28029 2013-06-24), 15 stand
-- 12-19 yd above on the tower tops and made three towers look already burnt: deleted with their addon / event / pool rows (none
-- exist; no event_script, SmartAI or addon refers to them). The -600 fire and smoke rows that event_scripts 3201-3204 respawn
-- for 600 s stay. Smoke 40181 (149018, south-west tower) had spawntimesecs +600 and smoked from server start: -600 like the others.
-- Sourced (walls of flame, the event's -600 rows); ours: the dz threshold. Idempotent.

DELETE FROM `gameobject_addon` WHERE `guid` IN (156254,156255,156256,156257,156258,156259,156260,156261,156262,156263,156268,156269,156270,156271,156272);
DELETE FROM `game_event_gameobject` WHERE `guid` IN (156254,156255,156256,156257,156258,156259,156260,156261,156262,156263,156268,156269,156270,156271,156272);
DELETE FROM `pool_gameobject` WHERE `guid` IN (156254,156255,156256,156257,156258,156259,156260,156261,156262,156263,156268,156269,156270,156271,156272);
DELETE FROM `gameobject` WHERE `guid` IN (156254,156255,156256,156257,156258,156259,156260,156261,156262,156263,156268,156269,156270,156271,156272) AND `id` IN (148996,149017,149019,149020);

UPDATE `gameobject` SET `spawntimesecs`=-600 WHERE `guid`=40181 AND `id`=149018;
