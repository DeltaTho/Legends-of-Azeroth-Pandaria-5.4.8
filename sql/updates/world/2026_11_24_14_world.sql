-- Blasted Lands A (_14): everyone in the Nethergarde Mines stands where he was put (plan section 2 orphan; dossier S1 hand-off
-- to S6, gate report task 4 item 2).
--
-- Today (zone 4, area 1457 and one Ore Heap Bunny in area 4; 255 spawns = 240 dwarves + Illycor + Hondo + 13 bunnies): 5996 x112, 5997 x46, 5998 x47, 41162 x21, 41171 x14, Illycor
-- 41163, Hondo 41173 and 13 Ore Heap Bunnies 41149 move: random 3 yd (MovementType 1), and 8 of them walk 4-5 point paths
-- (5997 163375 / 190714, 5998 163411 / 190735, 41162 163432 / 190600 / 190875, 41171 190506). Miners work with emote 233,
-- engineers with 133 and terrified miners cower with 431 while they move, so they slide; 14 miners lie as corpses
-- (29266 Permanent Feign Death on the spawn) and slide; Illycor and Hondo wander off their spots; random-moving dwarves meet
-- Rofilian Dane, Illycor and the entrance defenders (hostile.py: 1575 <-> 29 / 90 / 85 fight).
-- SOURCED: both TDBs have every creature of these entries in the zone box idle (MovementType 0, wander 0: 70 / 12 / 14 / 11 / 6
-- / 1 / - / 3 spawns), archetype "spawns posed as dead with a MovementType slide".
-- No spawn is deleted (ruling K6; counts are the layout section's call). Matched by entry and zone, so no guid is depended on.
-- Not changed: Ore Heap Bunny 163537 (zone 8, Stonard area 75, by the mine tunnel: the Swamp pass owns zone-8 rows; lead),
-- Rofilian Dane 41133 and Tak'arili 41134 (already idle).

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0, `currentwaypoint` = 0
  WHERE `map` = 0 AND `zoneId` = 4 AND `id` IN (5996, 5997, 5998, 41162, 41171, 41163, 41173, 41149);
UPDATE `creature_addon` ca JOIN `creature` c ON c.`guid` = ca.`guid` SET ca.`path_id` = 0
  WHERE c.`map` = 0 AND c.`zoneId` = 4 AND c.`id` IN (5996, 5997, 5998, 41162, 41171, 41163, 41173, 41149) AND ca.`path_id` <> 0;
