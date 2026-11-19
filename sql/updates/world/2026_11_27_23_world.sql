-- Zalazane's Fall (game_event 46, a one-time 3.3.5 event of September 2010): retire its quests, remove its never-spawned Durotar
-- spawns, and bring back the Sen'jin bat roost that was bound to it.
-- Sourced: both TDBs have game_event 61 "Zalazane's Fall" with no game_event_creature/gameobject rows and no queststarter for any of
-- the seven quests (enders only); Wowhead 25444 2010-10-13 [+9] "As of patch 4.0.1 this quest is no longer available"; the wiki event
-- page (Zalazane killed, the Echo Isles became the troll starting area). Both TDBs spawn the Sen'jin bat roost (Bat Totem 202833,
-- Roost Straw 202834, 2 Fences 202835, Fence Post 202839) and its Scout Bat 40222 permanently beside Handler Marnlek (the flight
-- master), idle; mop had them as event-46 spawns, so the flight master stood on an empty patch.
-- What the player sees: the roost and a hovering Scout Bat beside Handler Marnlek. Nothing else changes in game: game_event 46 runs
-- 2010-09-07 to 2010-12-06 and never starts (GameEventMgr), so none of the removed spawns was ever in the world.
-- Removed, zone 14 outside its Echo Isles subzone (area 6453 rows, 23 creatures and 17 objects with zoneId 14, and the zone-6453 rows
-- are left for the Echo Isles pass, plan ruling R7): 99 creatures and 61 gameobjects, every one
-- bound to event 46 only (checked guid by guid against game_event_creature/gameobject), with their 2 creature_addon rows and their
-- waypoint paths 87747/87748 (used by no other creature). None has a formation, pool, linked respawn, per-guid SmartAI, ScriptName or
-- game_event model/npcflag/vendor row; none of their entries has a spawn outside the event, and no live quest needs them (Vanira 40192,
-- an extra ender of Vashj'ir's 26040, stands in area 6453 and is not touched; 26040's real ender 41885 is spawned). Kept: the quest
-- templates,
-- the enders (as both TDBs), the game_event 46 row, its stray rows outside Durotar and the spell_area rows of 75434.
DELETE FROM `creature_queststarter` WHERE `quest` IN (25444, 25445, 25446, 25461, 25470, 25480, 25495);
DELETE FROM `game_event_creature` WHERE `eventEntry` = 46 AND `guid` = 251612;
DELETE FROM `game_event_gameobject` WHERE `eventEntry` = 46 AND `guid` IN (172928, 172929, 172930, 172931, 172932);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 251612 AND `id` = 40222;
DELETE FROM `waypoint_data` WHERE `id` IN (87747, 87748);
DELETE FROM `creature_addon` WHERE `guid` IN (56557, 56558, 56559, 56560, 56561, 56562, 56563, 56564, 57721, 57773, 59651, 59743, 59745, 59762, 59789, 61198, 65629, 65652,
 65670, 65717, 65745, 65758, 65825, 65902, 65916, 65933, 65979, 66022, 67982, 68787, 72292, 72336, 72688, 72888, 73056, 73940,
 74014, 76166, 76167, 78162, 78163, 78374, 78376, 78393, 78399, 80833, 81129, 81164, 81530, 81538, 81710, 81711, 81712, 81799,
 81800, 81801, 81802, 81803, 81804, 81805, 81806, 81807, 81808, 81825, 82291, 82292, 82293, 82294, 82295, 82296, 82297, 82298,
 82299, 82300, 82301, 82302, 82809, 82810, 82812, 82818, 87723, 87724, 87725, 87726, 87727, 87728, 87737, 87738, 87739, 87740,
 87741, 87742, 87743, 87744, 87745, 87746, 87747, 87748, 87775);
DELETE FROM `game_event_creature` WHERE `eventEntry` = 46 AND `guid` IN (56557, 56558, 56559, 56560, 56561, 56562, 56563, 56564, 57721, 57773, 59651, 59743, 59745, 59762, 59789, 61198, 65629, 65652,
 65670, 65717, 65745, 65758, 65825, 65902, 65916, 65933, 65979, 66022, 67982, 68787, 72292, 72336, 72688, 72888, 73056, 73940,
 74014, 76166, 76167, 78162, 78163, 78374, 78376, 78393, 78399, 80833, 81129, 81164, 81530, 81538, 81710, 81711, 81712, 81799,
 81800, 81801, 81802, 81803, 81804, 81805, 81806, 81807, 81808, 81825, 82291, 82292, 82293, 82294, 82295, 82296, 82297, 82298,
 82299, 82300, 82301, 82302, 82809, 82810, 82812, 82818, 87723, 87724, 87725, 87726, 87727, 87728, 87737, 87738, 87739, 87740,
 87741, 87742, 87743, 87744, 87745, 87746, 87747, 87748, 87775);
DELETE FROM `creature` WHERE `guid` IN (56557, 56558, 56559, 56560, 56561, 56562, 56563, 56564, 57721, 57773, 59651, 59743, 59745, 59762, 59789, 61198, 65629, 65652,
 65670, 65717, 65745, 65758, 65825, 65902, 65916, 65933, 65979, 66022, 67982, 68787, 72292, 72336, 72688, 72888, 73056, 73940,
 74014, 76166, 76167, 78162, 78163, 78374, 78376, 78393, 78399, 80833, 81129, 81164, 81530, 81538, 81710, 81711, 81712, 81799,
 81800, 81801, 81802, 81803, 81804, 81805, 81806, 81807, 81808, 81825, 82291, 82292, 82293, 82294, 82295, 82296, 82297, 82298,
 82299, 82300, 82301, 82302, 82809, 82810, 82812, 82818, 87723, 87724, 87725, 87726, 87727, 87728, 87737, 87738, 87739, 87740,
 87741, 87742, 87743, 87744, 87745, 87746, 87747, 87748, 87775);
DELETE FROM `game_event_gameobject` WHERE `eventEntry` = 46 AND `guid` IN (2038, 2040, 2043, 2044, 2047, 2051, 2052, 2053, 2054, 2056, 2057, 2059, 2061, 2063, 2066, 2067, 2068, 2070, 2072, 2073, 2075,
 2077, 2078, 2080, 2086, 2088, 2090, 2093, 2094, 2096, 2097, 2100, 2101, 2103, 2104, 2106, 2108, 2109, 2110, 2111, 2112, 2115,
 2118, 2121, 2122, 2123, 2124, 2125, 2129, 2130, 2134, 2138, 2140, 2141, 2142, 2143, 2146, 2148, 2152, 2320, 2558);
DELETE FROM `gameobject` WHERE `guid` IN (2038, 2040, 2043, 2044, 2047, 2051, 2052, 2053, 2054, 2056, 2057, 2059, 2061, 2063, 2066, 2067, 2068, 2070, 2072, 2073, 2075,
 2077, 2078, 2080, 2086, 2088, 2090, 2093, 2094, 2096, 2097, 2100, 2101, 2103, 2104, 2106, 2108, 2109, 2110, 2111, 2112, 2115,
 2118, 2121, 2122, 2123, 2124, 2125, 2129, 2130, 2134, 2138, 2140, 2141, 2142, 2143, 2146, 2148, 2152, 2320, 2558);
