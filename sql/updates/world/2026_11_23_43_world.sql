-- Swamp of Sorrows C (_43): one of each rare at a time (plan C-06; S5 dossier 3 Part C; S2 H5; plan K1).
--
-- SOURCED: Captain Wyrmak, Gilmorian, Molt Thorn and the Lost One Cook each have two spawns that could be up together; neither
-- TDB spawns them, so which spot is right is unknown: both spots are kept and pooled, max 1.
-- OURS: the pools (3137200 Gilmorian, 3137201 Molt Thorn, 3137203 Lost One Cook; pool 170 gets Wyrmak's Hall of Masks copy and
-- loses the Shadow Panther, deleted in _40). Jade is not pooled (K1): her temple-top spawn 2900 is deleted in _45, 318338 stays
-- alone. The Lost One Cook is kept (queued Wowhead page 1106 not arrived; plan R-28 default).
-- OURS, Captain Wyrmak's rarity: before, pool 170 held Wyrmak at chance 12 beside the level-39 Shadow Panther (a classic
-- placeholder, no Shadow Panther in either TDB box), i.e. Wyrmak was up on about one roll in eight. With the panther gone a
-- 12 % chance alone would spawn nothing on 88 % of rolls and never roll again (PoolGroup<T>::SpawnObject runs only at start and
-- when a member despawns), so the chance is set to 0 (equal): Wyrmak is always up at one of his two spots and his rarity is
-- his 8-hour respawn (spawntimesecs 28800), as for Gilmorian, Molt Thorn and the Cook, which were never pooled with a
-- placeholder. No source gives a Cataclysm or MoP spawn chance or placeholder for him.
-- Idempotent: DELETE + INSERT, absolute UPDATEs.

UPDATE `pool_creature` SET `chance` = 0 WHERE `pool_entry` = 170;
DELETE FROM `pool_creature` WHERE `guid` IN (301936, 2150, 191010, 52906, 306440, 4041, 304344);
DELETE FROM `pool_template` WHERE `entry` IN (3137200, 3137201, 3137203);
INSERT INTO `pool_template` (`entry`, `max_limit`, `description`) VALUES
(3137200, 1, 'Swamp of Sorrows - Gilmorian (14447)'),
(3137201, 1, 'Swamp of Sorrows - Molt Thorn (14448)'),
(3137203, 1, 'Swamp of Sorrows - Lost One Cook (1106)');
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(301936, 170, 0, 'Captain Wyrmak'),
(2150, 3137200, 0, 'Gilmorian'),
(191010, 3137200, 0, 'Gilmorian'),
(52906, 3137201, 0, 'Molt Thorn'),
(306440, 3137201, 0, 'Molt Thorn'),
(4041, 3137203, 0, 'Lost One Cook'),
(304344, 3137203, 0, 'Lost One Cook');
UPDATE `pool_template` SET `description` = 'Swamp of Sorrows - Captain Wyrmak (14445)' WHERE `entry` = 170;
