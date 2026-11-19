-- Valley of Trials clean-up against both TDBs: doubled spawns and pre-Cataclysm abilities.
-- Mottled Boar 252339 stands idle inside the pathing boar 252393 (0.2 yd apart; neither TDB has two there).
-- Cactus Apple (171938) pool 1131: 38 pre-Cataclysm apples (rounded coordinates, 600 s respawn, 13 up at a time; five of them outside
-- the Valley, none in either TDB), several standing on a sniffed apple, beside mop's 46 sniffed apples. The pool goes (no pool_pool
-- parent). Four pool apples are the only mop apple on a TDB apple spot (14729 on TDB 218332, 3251 on 218380, 2743 on 218381, 6357 on
-- 218382, 0.5-3.7 yd): they stay as plain spawns with the sniffed set's 300 s respawn; the other 34 are deleted. After this every one of
-- the 45 TDB apples (identical in both TDBs) has a mop apple within 5 yd. Kept although in neither TDB: the sniffed apples 173110 and
-- 173143 (60 and 72 yd from any TDB apple) and 173138, 173142 (6-16 yd off).
-- Vile Familiar flee at 15 % (3101 id 1), Sarkoth's Poison 11918 (3281 id 0) and Yarrog's Corruption/Immolate (3183 ids 0, 1) are not
-- in either TDB, whose scripts are Fireball / Venom Splash / Fel Fireball, Fel Immolate (kept: the beta rows). Yarrog's
-- out-of-combat channel uses 75965 as both TDBs and his template addon aura (51733 is the same dummy channel under another id).
DELETE FROM `creature_addon` WHERE `guid` = 252339;
DELETE FROM `creature` WHERE `guid` = 252339 AND `id` = 3098;
DELETE FROM `gameobject` WHERE `id` = 171938 AND `guid` IN (333, 454, 1166, 1363, 1651, 1672, 2412, 3065, 3299, 3578, 3972, 4001, 4676,
 4691, 5426, 5692, 5980, 6539, 8258, 8601, 9149, 9461, 12186, 12442, 12580, 12759, 12922, 13175, 13573, 15268, 15646, 15647, 16747, 16873);
UPDATE `gameobject` SET `spawntimesecs` = 300 WHERE `id` = 171938 AND `guid` IN (2743, 3251, 6357, 14729);
DELETE FROM `pool_gameobject` WHERE `pool_entry` = 1131;
DELETE FROM `pool_template` WHERE `entry` = 1131;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3101 AND `source_type` = 0 AND `id` = 1;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3281 AND `source_type` = 0 AND `id` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3183 AND `source_type` = 0 AND `id` IN (0, 1);
UPDATE `smart_scripts` SET `action_param1` = 75965 WHERE `entryorguid` = 3183 AND `source_type` = 0 AND `id` = 3;
