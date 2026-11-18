-- Blasted Lands (zone 4): two gameobjects neither TDB has (section F, Part F).
-- [Deprecated for 4.x]Ancient Brazier 20807 (guid 216176; the template's own name says deprecated) and Flag of Ownership 190589
--   (guid 184233 at the Dark Portal: the flag a player's toy plants, sniffed as a spawn). No addon, swap, pool, event or SmartAI rows.

DELETE FROM `game_event_gameobject` WHERE `guid` IN (216176,184233);
DELETE FROM `pool_gameobject` WHERE `guid` IN (216176,184233);
DELETE FROM `gameobject_addon` WHERE `guid` IN (216176,184233);
DELETE FROM `gameobject` WHERE (`guid`=216176 AND `id`=20807) OR (`guid`=184233 AND `id`=190589);
