-- Clattering Scorpids (3125) respawn in 120 s as both TDBs (mop 300 s), and one doubled scorpid goes.
-- Never Trust a Big Barb and a Smile needs six of them, and a scorpid whose Envenom was resisted or interrupted is lost for the quest
-- (Envenom is cast once per fight), so the five-minute respawn made the quest grindy in a crowd (Wowhead 25165 comments). Not certain,
-- so the less grindy sourced value. 252208 stands 0.7 yd from 252169 (both random 3 yd, same template); neither TDB has two there.
-- The rest of the layout is left: mop 73 spawns (sniffed, random 3 yd or short paths) and both TDBs 78 (random 8 yd) cover the same
-- ground with different spawn points.
DELETE FROM `creature_addon` WHERE `guid` = 252208;
DELETE FROM `creature` WHERE `guid` = 252208 AND `id` = 3125;
UPDATE `creature` SET `spawntimesecs` = 120 WHERE `id` = 3125 AND `map` = 1;
