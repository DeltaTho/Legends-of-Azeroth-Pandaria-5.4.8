-- Durotar, Northwatch Foothold: Breaking the Chain (25167): the Northwatch Lugs carry the supply crates in from the shore.
--
-- Sourced: Wowhead 25167 2010-11-23 [+3] "Northwatch Lug's will spawn carrying a crate", 2010-12-12 [+4] "they spawn from two places";
-- warcraft.wiki.gg Notes: the lugs "spawn at regular intervals. If left unmolested, they will form a chain of mobs between the spawn
-- point and the encampments", "coming three to a crate". The data: the three Caravan Spawners 39255 (both TDBs, mop) and Spell.dbc
-- 73691 / 73736 / 73737 Summon Northwatch Caravan A / B / C; the caravans' VehicleId 680 / 684 / 685 with walker seats (Walk + arms
-- holding up the load) and one seat 0.47 higher for the crate: 680 seats 0 1 3 + crate 2, 684 seat 0 + crate 1, 685 seats 0 1 +
-- crate 2. Which lug sits where: both TDBs' static groups are snapshots of these caravans (2x 39249 + 39245 under a crate = A,
-- 39249 under a crate = B, 2x 39245 = C, each at a spot of the caravans' sniffed paths); the seat with the larger offset (0.18 to
-- the side) gets the 39245.
-- The static lugs (33) and crates (17) go: they are those snapshots (each group on a caravan's sniffed spot, group sizes = seat
-- counts). The quest's lugs and crates now come only from the caravans (npc_northwatch_caravan_spawner / npc_northwatch_caravan
-- in zone_durotar.cpp), which send a new crate every 14-18 s from each of the three spawners (up to 11 caravans per spawner;
-- ~22 lugs and ~11 crates a minute against ~23 and ~17 from the static spawns at 60/120 s).
-- Ours: the accessory summon type (1 = timed or dead despawn, 600 s out of combat, a backstop: the caravan script despawns them),
-- non-minion accessories (a minion accessory is unsummoned as soon as it leaves its seat), and the spellclick rows the core needs
-- to seat an accessory (Vehicle::InstallAccessory -> Unit::HandleSpellClick; 46598 Ride Vehicle Hardcoded cast by the accessory;
-- user_type 2 = raid, which no player clicker passes for a creature: players cannot board, and the caravans are unselectable).
-- No addon, event, pool, formation, linked respawn or guid SmartAI uses the static guids (checked); the deletes cover them anyway.

DELETE FROM `creature_addon` WHERE `guid` BETWEEN 252744 AND 252837 AND `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (39245, 39249, 39251));
DELETE FROM `game_event_creature` WHERE `guid` BETWEEN 252744 AND 252837 AND `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (39245, 39249, 39251));
DELETE FROM `pool_creature` WHERE `guid` BETWEEN 252744 AND 252837 AND `guid` IN (SELECT `guid` FROM `creature` WHERE `id` IN (39245, 39249, 39251));
DELETE FROM `creature_formations` WHERE `memberGUID` BETWEEN 252744 AND 252837 AND `memberGUID` IN (SELECT `guid` FROM `creature` WHERE `id` IN (39245, 39249, 39251));
DELETE FROM `creature` WHERE `id` IN (39245, 39249, 39251) AND `map` = 1 AND `guid` BETWEEN 252744 AND 252837;

UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_northwatch_caravan_spawner' WHERE `entry` = 39255;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_northwatch_caravan' WHERE `entry` IN (39244, 39318, 39319);

DELETE FROM `vehicle_template_accessory` WHERE `entry` IN (39244, 39318, 39319);
INSERT INTO `vehicle_template_accessory` (`entry`, `accessory_entry`, `seat_id`, `minion`, `description`, `summontype`, `summontimer`) VALUES
(39244, 39245, 0, 0, 'Northwatch Caravan A - Northwatch Lug', 1, 600000),
(39244, 39249, 1, 0, 'Northwatch Caravan A - Northwatch Lug', 1, 600000),
(39244, 39251, 2, 0, 'Northwatch Caravan A - Northwatch Supply Crate', 1, 600000),
(39244, 39249, 3, 0, 'Northwatch Caravan A - Northwatch Lug', 1, 600000),
(39318, 39249, 0, 0, 'Northwatch Caravan B - Northwatch Lug', 1, 600000),
(39318, 39251, 1, 0, 'Northwatch Caravan B - Northwatch Supply Crate', 1, 600000),
(39319, 39245, 0, 0, 'Northwatch Caravan C - Northwatch Lug', 1, 600000),
(39319, 39245, 1, 0, 'Northwatch Caravan C - Northwatch Lug', 1, 600000),
(39319, 39251, 2, 0, 'Northwatch Caravan C - Northwatch Supply Crate', 1, 600000);

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (39244, 39318, 39319);
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(39244, 46598, 1, 2),
(39318, 46598, 1, 2),
(39319, 46598, 1, 2);
