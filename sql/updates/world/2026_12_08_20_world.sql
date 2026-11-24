-- Darkspear Hold: Vol'jin's visions stand in the smoke above the brazier, not on the floor of the hut.
-- Vol'jin's lists summon the Vision of Garrosh Hellscream 38938 and the Vision of Vol'jin 38953 (3896601) at Z 25.45 and the
-- Vision of Thrall 38939 (3896603) at Z 25.31, the sniffed spots (TDB 1210 creature 309028 / 309029 at the same coordinates);
-- the brazier 202434 / 202444 stands at Z 24.03 in a firepit the server's floor height does not include. The three had no
-- creature_template_movement row, so they were ground creatures and came down to the floor below the firepit.
-- Ours: Flight 1 (DisableGravity), as the smoke bunny 38003 beside them; the TDBs spawn them statically (no row there either) and
-- no source shows how retail held them up. Ground stays Run; they never move.
DELETE FROM `creature_template_movement` WHERE `CreatureId` IN (38938, 38939, 38953);
INSERT INTO `creature_template_movement` (`CreatureId`, `Ground`, `Swim`, `Flight`, `Rooted`, `Chase`, `Random`, `InteractionPauseTimer`) VALUES
(38938, 1, 0, 1, 0, NULL, NULL, NULL),
(38939, 1, 0, 1, 0, NULL, NULL, NULL),
(38953, 1, 0, 1, 0, NULL, NULL, NULL);
