-- Burning Steppes B (_13): Morgan's Vigil 28310 / Flame Crest 28442 given only by Troteman / Eitrigg; General Thorg'izog respawn
-- (plan B-06, B-16).
--
-- SOURCED: both TDBs (creature_queststarter of 28310 / 28442 is Troteman 48110 / Eitrigg 48568 only; Oralius 9177 / Kibler 10260 are
-- their enders. mop also made them givers: a "!" at the ender after Enough Damage For One Day, and accepting there skipped the walk
-- with Keeshan and Troteman / Ariok and Eitrigg). General Thorg'izog 165490 respawn 120 s as both TDBs (mop 300).
-- Idempotent: DELETE, absolute UPDATE.

DELETE FROM `creature_queststarter` WHERE (`id`, `quest`) IN ((9177, 28310), (10260, 28442));
UPDATE `creature` SET `spawntimesecs` = 120 WHERE `guid` = 165490 AND `id` = 48133;
