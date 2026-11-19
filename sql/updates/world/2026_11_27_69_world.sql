-- Durotar, Skull Rock: three Burning Blade Fanatic 3197 spots carried three mop copies each (within 1-2 yd, all wandering 3 yd),
-- so a level-10 player pulled three Fanatics at once there. Both TDBs have one Fanatic per spot (310687, 310691, 310683, the same
-- in 4.4.2 and 12.1.0). Kept: the copy nearest each TDB point (205033 1.1 yd, 250992 0.1 yd, 205059 1.0 yd); deleted the other two
-- of each. None of the six has an addon, pool, formation, event or per-guid script row.
-- The stacks stand 31-37 yd from the 5.4 Kor'kron Grunts (dossier E, 25262); whether they were part of the 5.4 fight layout is
-- not settled by any source, and one Fanatic per spot is right for the levelling layout either way.

DELETE FROM `creature_addon` WHERE `guid` IN (205034, 205035, 205060, 205061, 251010, 251011);
DELETE FROM `creature` WHERE `guid` IN (205034, 205035, 205060, 205061, 251010, 251011);
