-- Durotar: Ignoring the Warnings (25206): the Furious Earthguards 39595 and Teeming Waterguards 39596 "war against one another"
-- (quest text). Both TDBs spawn them idle in facing pairs 3-4 yd apart with the template addon emote state 35; mop let all of
-- them wander 3 yd with no emote, so the pairs drifted apart and nothing looked like a fight.
-- Sourced: TDB 4.4.2 and 12.1.0 (MovementType 0 on every spawn of both entries, creature_template_addon emote 35). The mop
-- spawns that match a TDB spawn have its exact orientation, so idle they face their partner again.

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` IN (39595, 39596);
UPDATE `creature_template_addon` SET `emote` = 35 WHERE `entry` IN (39595, 39596);
