-- Searing Gorge, C-6 + C-7 + C-14: three small template / vendor / loot fixes.
-- C-6 Thorium Brotherhood Lookout 14622: faction 1475 -> 2364 (faction 59 with CONTESTED_GUARD|0x1, FactionTemplate.dbc 2364
--   exists) and idle, as both TDBs; two stood on tower tops (z 324-327) and could wander off. Sourced.
-- C-7 Gavan Crunchore 47939: Jeweler's Kit 20815 and Virtuoso Inking Set 39505 as both TDBs. Sourced.
-- C-14 Margol the Rager 5833: item 10000 at 100 % to everyone; no quest uses it (R-13). Sourced rule.
-- C-18 Dark Iron Bullets crates 206659 (28030 needs 200 bullets): respawn 300 s -> 120 s as both TDBs (less grindy). Sourced.
-- Idempotent: DELETE + INSERT, absolute UPDATEs.

UPDATE `creature_template` SET `faction`=2364 WHERE `entry`=14622;
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=14622 AND `guid` IN (185722,185723,185724,185725,185726,185727);

DELETE FROM `npc_vendor` WHERE `entry`=47939 AND `item` IN (20815,39505);
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`) VALUES
(47939,0,20815,0,0,0,1),(47939,0,39505,0,0,0,1);

DELETE FROM `creature_loot_template` WHERE `Entry`=5833 AND `Item`=10000;
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `id`=206659;
