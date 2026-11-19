-- Durotar rares: each could be up twice.
--
-- 5823 Death Flayer: pool 1271 (36474, 36705, 37171, max 1) plus an unpooled copy 253576 (255.9,-4077.2) that was always up.
--   Both TDBs have one Death Flayer (242.9,-3981.0). Pool the copy into 1271 (equal chance, as the others): the rare is
--   then up once, as in both TDBs. 253576 stands 97 yd from the TDB spot, so the pool's fourth spot is ours.
-- 5826 Geolord Mottle: pool 310 (six spots, max 1) plus unpooled 253556 (424.3,-4245.1), exactly the spot of the one
--   Mottle both TDBs have. Pool it into 310 (equal chance).
-- 5824 Captain Flat Tusk: pool 115 (17708, 53199, 53200 at 4 % each, a Razormane Quilboar the rest) plus 253587 standing
--   on 53200's spot with a 3 yd wander: always up, and twice when 53200 rolls. Neither TDB has him. Delete 253587.
-- 5822 Felweaver Scornn: 39715 stands at the one spot both TDBs have; 250943 (1492.4,-4753.4) was a second, always-up
--   copy. Delete 250943.
-- None of these guids has an addon, path, formation, event, SmartAI or linked respawn. Sourced: the TDB spawn counts;
-- ours: Death Flayer's fourth pool spot and equal pool chances for the two added members (the pools' other members have chance 0).

DELETE FROM `pool_creature` WHERE `guid` IN (253576, 253556);
INSERT INTO `pool_creature` (`guid`, `pool_entry`, `chance`, `description`) VALUES
(253576, 1271, 0, 'NPC 5823 Death Flayer'),
(253556, 310, 0, 'NPC 5826 Geolord Mottle (TDB both spot)');
DELETE FROM `creature_addon` WHERE `guid` IN (253587, 250943);
DELETE FROM `creature` WHERE (`id` = 5824 AND `guid` = 253587) OR (`id` = 5822 AND `guid` = 250943);
