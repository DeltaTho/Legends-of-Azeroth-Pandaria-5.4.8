-- Searing Gorge, C-8: same-entry doubles within 2 yd of another spawn (zone-wide scan, layers.txt): 32 creatures and their addons.
-- One kept per spot (a path spawn first, then the one nearest a TDB spawn of the entry, then the lowest guid). Entries of other
-- sections included (5840, 5844, 5846, 5861, 8566, 9318, 47275): no owner vetoed; none has a path, pool, formation, game event,
-- smart_scripts row or linked respawn (checked), only creature_addon rows. Ours (rule: no doubled mobs).
-- Idempotent: DELETEs only.

DELETE FROM `creature_addon` WHERE `guid` IN (186553,186555,186398,165315,186605,186079,186530,186590,186452,186238,165739,185876,186270,165698,165699,186447,165940,186158,186156,186048,186047,186091,186092,186148,186471,165711,186202,186500,186595,186297,186295,186612);
DELETE FROM `creature` WHERE `guid` IN (186553,186555,186398,165315,186605,186079,186530,186590,186452,186238,165739,185876,186270,165698,165699,186447,165940,186158,186156,186048,186047,186091,186092,186148,186471,165711,186202,186500,186595,186297,186295,186612);
