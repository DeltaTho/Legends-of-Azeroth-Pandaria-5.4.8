-- Durotar: rares up on the razors or in the air.
--
-- The user, play-testing 2026-11-23: Geolord Mottle (guid 36929) "appears to be in a bugged position - up on top of a razor, kind
-- of glitching as it wanders". Heights below are from the extracted 5.4.8 terrain (maps) and model collision (vmaps).
--
-- Geolord Mottle 5826, pool 310 (one up at a time): seven spots. 36905 36929 36958 37930 stood 4-35 yd above the ground or on
-- the tip of a thorn (MovementType 2 with a one-node "path" at the spawn height), 36989 8 yd up, 37865 on the ground. Both
-- TDBs (4.4.2 and 12.1.0) have one Mottle: 253556 (424.3, -4245.1), in the Razormane camp of Dustrunners and Battleguards; the
-- six others are the pre-Cataclysm layout. Sourced: keep only 253556; delete the six with their paths, addons and pool rows.
-- Respawn: warcraft.wiki.gg "She is on a 1-2 hour respawn timer": the less grindy end, 3600 s (mop 28800, TDBs 120).
-- Ours: 253556 keeps mop's 3 yd wander (the TDBs stand her still; the wiki says she "patrols the Razormane camp").
--
-- Death Flayer 5823, pool 1271: 36474 (one-node path), 36705 and 37171 stood 25-31 yd in the air. Both TDBs have one Death
-- Flayer at (242.865, -3981.03, 20.5564), wandering 8 yd. Sourced: the three airborne spots go; the fourth pool spot 253576
-- (on the ground but 97 yd from the TDB spot, ours since 2026_11_27_90) moves to the TDB spot with the TDB's wander.
--
-- Captain Flat Tusk 5824, pool 115 (three Flat Tusk spots at 4 % each, the rest a Razormane Quilboar 36520): neither TDB has
-- Flat Tusk (a Cataclysm rare the sniffs missed), so his spots stay; 53199 stood on the tip of a thorn (70.2, ground 39.4),
-- 53200 37 yd in the air (62.7, ground 25.4) and the pool's quilboar 36520 39 yd in the air (60.1, ground 20.9): each is put
-- on the ground below it (ours: same x/y). 17708 stood 2.4 yd over the terrain with no collision or gameobject under it: set to the
-- terrain (22.94) too.
--
-- Orgrimmar Grunt 127332 (Durotar side of the Orgrimmar gate): MovementType 2 with a one-node path at its spawn point; it
-- stands (MovementType 0), the path and the otherwise empty addon row go.
--
-- No game event, formation, linked respawn or guid SmartAI uses the deleted guids (checked); the deletes cover them anyway.

DELETE FROM `waypoint_data` WHERE `id` IN (36474, 36905, 36929, 36958, 37930, 127332);
DELETE FROM `creature_addon` WHERE `guid` IN (36474, 36705, 37171, 36905, 36929, 36958, 36989, 37865, 37930, 127332);
DELETE FROM `game_event_creature` WHERE `guid` IN (36474, 36705, 37171, 36905, 36929, 36958, 36989, 37865, 37930);
DELETE FROM `pool_creature` WHERE `guid` IN (36474, 36705, 37171, 36905, 36929, 36958, 36989, 37865, 37930);
DELETE FROM `creature_formations` WHERE `memberGUID` IN (36474, 36705, 37171, 36905, 36929, 36958, 36989, 37865, 37930);
DELETE FROM `linked_respawn` WHERE `guid` IN (36474, 36705, 37171, 36905, 36929, 36958, 36989, 37865, 37930);
DELETE FROM `creature` WHERE (`id` = 5826 AND `guid` IN (36905, 36929, 36958, 36989, 37865, 37930))
                          OR (`id` = 5823 AND `guid` IN (36474, 36705, 37171));

UPDATE `creature` SET `spawntimesecs` = 3600 WHERE `id` = 5826 AND `guid` = 253556;
UPDATE `creature` SET `position_x` = 242.865, `position_y` = -3981.03, `position_z` = 20.5564, `MovementType` = 1, `wander_distance` = 8
  WHERE `id` = 5823 AND `guid` = 253576;
UPDATE `creature` SET `position_z` = 39.39 WHERE `id` = 5824 AND `guid` = 53199;
UPDATE `creature` SET `position_z` = 25.38 WHERE `id` = 5824 AND `guid` = 53200;
UPDATE `creature` SET `position_z` = 20.90 WHERE `id` = 3111 AND `guid` = 36520;
UPDATE `creature` SET `position_z` = 22.94 WHERE `id` = 5824 AND `guid` = 17708;
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 3296 AND `guid` = 127332;
