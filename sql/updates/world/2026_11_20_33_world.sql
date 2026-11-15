-- Badlands: the same mob twice on one spot, in the Uldaman approach, New Kargath and the Scar (plan items C-8 and C-9).
--
-- Method (R3): spawns of one entry (or entry group) that stand within 2.5 yd of each other on the same floor are a second import
-- layer on the same sniffed spot; one is kept per spot against the TDB 4.4.2 / 12.1.0 box (which agree): the one nearest a TDB spawn,
-- or the one with a path, or, with no TDB spawn within 5 yd, the lowest guid. Each deleted row was re-read in mop_world and its
-- keeper and nearest TDB spawn re-measured before this file was written. No pool, game event, formation, linked respawn, condition
-- or guid SmartAI row names a deleted guid (queried); the addons deleted are SheathState only, plus paths on 162863 and 162643.
--
-- C-8 (27830 / 27895 area, the Uldaman approach, area 1517 and 1878 / 5565 / 347 / 1897):
--   4844 Shadowforge Surveyor 181616 181621 181579 181617; 4845 Shadowforge Ruffian 181615 181613 181622 181582 181620;
--   4846 Shadowforge Digger 181618; 4856 Stonevault Cave Hunter 181633; 46914 Raging Whelp 162549 162819; 2110 Black Rat 165322;
--   15475 Beetle 162277; 47073 New Kargath Grunt 162425 162429 162556: the three grunts with no TDB spot (mop has 15, both TDBs 12;
--   the other 12 match the TDB spots 1:1; 162554, which the first pass listed, stands exactly on TDB 289047 and is kept).
-- C-9 (27830, 27831, 27895, 27896, 27713):
--   Darkflight dragonspawn / soldiers 46915 / 46917 / 46918: 26 stacked copies, most a 46917 and a 46918 on the same sniffed spot
--   (the TDB has one of them). 2739 Shadowforge Tunneler 162863 (with its 4-point path) and 162859, 2740 Shadowforge Darkweaver
--   162741, 46467 Dang-Blasted Rock Elemental 162643 (with its 4-point path; 0.2 yd from 162390).
--   Left: the 46928 Butcher pair (the TDB has its own pairs), critter pairs, 2742 / 2743.
-- Sourced: the TDB layout (kept guid per spot). Ours: the choice of which of two stacked rows to delete.
-- Not taken (the user's choice later): replacing the whole New Kargath layout by the TDB's (option b, vikings VD-23): about 50
--   more deletes plus spots to add.
-- Hand-off: the Deathwing story setup (section B) must not name guid 162643; it updates 46467 by entry.

-- C-8
DELETE FROM `creature_addon` WHERE `guid` IN (181616,181621,181579,181617,181615,181613,181622,181582,181620,181618,181633,162549,162819,162425,162429,162556,165322,162277);
DELETE FROM `creature` WHERE `guid` IN (181616,181621,181579,181617) AND `id` = 4844;
DELETE FROM `creature` WHERE `guid` IN (181615,181613,181622,181582,181620) AND `id` = 4845;
DELETE FROM `creature` WHERE `guid` = 181618 AND `id` = 4846;
DELETE FROM `creature` WHERE `guid` = 181633 AND `id` = 4856;
DELETE FROM `creature` WHERE `guid` IN (162549,162819) AND `id` = 46914;
DELETE FROM `creature` WHERE `guid` IN (162425,162429,162556) AND `id` = 47073;
DELETE FROM `creature` WHERE `guid` = 165322 AND `id` = 2110;
DELETE FROM `creature` WHERE `guid` = 162277 AND `id` = 15475;

-- C-9
DELETE FROM `creature_addon` WHERE `guid` IN (162815,162287,162824,162558,162837,162465,162459,162466,162462,162562,162447,162448,162823,162573,162832,162591,162593,162846,162597,162840,162834,162833,162572,162590,162455,162842);
DELETE FROM `creature` WHERE `guid` IN (162815,162287,162824,162558,162837,162465,162459,162466,162462,162562,162447,162448,162823,162573,162832,162591,162593,162846,162597,162840,162834,162833,162572,162590,162455,162842) AND `id` IN (46915,46917,46918);
DELETE FROM `waypoint_data` WHERE `id` IN (162863,162643);
DELETE FROM `creature_addon` WHERE `guid` IN (162863,162859,162741,162643);
DELETE FROM `creature` WHERE (`guid` IN (162863,162859) AND `id` = 2739) OR (`guid` = 162741 AND `id` = 2740) OR (`guid` = 162643 AND `id` = 46467);
