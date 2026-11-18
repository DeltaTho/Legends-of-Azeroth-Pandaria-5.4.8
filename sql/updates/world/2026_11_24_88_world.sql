-- Blasted Lands (zone 4): one pool per rare, so no rare can be up twice (section F, Part C).
-- Before: Teremus 7846, Akubar 8298, Ravage 8300, Mojo 8296, Magronos 8297, Spiteflayer 8299, Clack 8301 and Grunter 8303 each
--   had a spawn outside any pool (the classic spawn on a path plus a Cataclysm static), so two of one rare could be up at once.
-- Sourced: Wowhead MoP Classic pins fall on the spawn points of each rare (S6 dossier section 6), so every spawn point is kept
--   (Akubar 4, Ravage 3, the others 2). Deatheye's pool 1294 is rewritten too (same two members, chance 0 already).
-- Ours: max 1 per pool and chance 0 for every member. This core's pool manager rolls only at startup and when the active member
--   despawns, tries explicitly chanced members first, and leaves a pool whose chanced members all miss empty for good, so equal
--   chance is the safe form (pool 326 had a 40 % member). Spawn timers unchanged (28800 s; Teremus 1343 172800 s).
-- Pools 3139200-3139204 are new (section F's range); 326, 312, 313 and 1294 exist and are re-filled.

DELETE FROM `pool_creature` WHERE `guid` IN (1173,1256,1343,1356,53456,53457,53458,53459,53460,61882,61896,129593,129594,163931,163982,304192,313936,313937,318340,318341,318342) OR `pool_entry` IN (326,312,313,1294,3139200,3139201,3139202,3139203,3139204);
DELETE FROM `pool_template` WHERE `entry` BETWEEN 3139200 AND 3139204;
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES (3139200,1,'Blasted Lands - Mojo the Twisted (8296)'),(3139201,1,'Blasted Lands - Magronos the Unyielding (8297)'),(3139202,1,'Blasted Lands - Spiteflayer (8299)'),(3139203,1,'Blasted Lands - Clack the Reaver (8301)'),(3139204,1,'Blasted Lands - Grunter (8303)');
UPDATE `pool_template` SET `max_limit`=1,`description`='Blasted Lands - Teremus the Devourer (7846)' WHERE `entry`=326;
UPDATE `pool_template` SET `max_limit`=1,`description`='Blasted Lands - Akubar the Seer (8298)' WHERE `entry`=312;
UPDATE `pool_template` SET `max_limit`=1,`description`='Blasted Lands - Ravage (8300)' WHERE `entry`=313;
UPDATE `pool_template` SET `max_limit`=1,`description`='Blasted Lands - Deatheye (8302)' WHERE `entry`=1294;
INSERT INTO `pool_creature` (`guid`,`pool_entry`,`chance`,`description`) VALUES
(1343,326,0,'Teremus the Devourer'),
(304192,326,0,'Teremus the Devourer'),
(1173,312,0,'Akubar the Seer'),
(61882,312,0,'Akubar the Seer'),
(61896,312,0,'Akubar the Seer'),
(318342,312,0,'Akubar the Seer'),
(1356,313,0,'Ravage'),
(129593,313,0,'Ravage'),
(318340,313,0,'Ravage'),
(53459,1294,0,'Deatheye'),
(129594,1294,0,'Deatheye'),
(53456,3139200,0,'Mojo the Twisted'),
(163931,3139200,0,'Mojo the Twisted'),
(53457,3139201,0,'Magronos the Unyielding'),
(313937,3139201,0,'Magronos the Unyielding'),
(53458,3139202,0,'Spiteflayer'),
(163982,3139202,0,'Spiteflayer'),
(1256,3139203,0,'Clack the Reaver'),
(313936,3139203,0,'Clack the Reaver'),
(53460,3139204,0,'Grunter'),
(318341,3139204,0,'Grunter');
