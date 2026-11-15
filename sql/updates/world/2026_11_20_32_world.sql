-- Badlands: classic leftovers of retired quests go (plan items C-5 and C-7).
--
-- C-5. Enraged Rock Elemental 2791 (12 spawns on the southern ridge, -7246..-7336 / -3387..-3486, z 292-325, level 42-43):
--   a pre-Cataclysm mob. Neither TDB (4.4.2, 12.1.0) spawns 2791 anywhere; within 150 yd of the ridge retail has Rock
--   Elementals 92, which mop also has. Its loot is Scroll Fragments and the Rock Elemental Shard of retired quests (692,
--   2258, 2500: no starter and no ender), and no live quest objective names it. The 12 have no
--   creature_addon row; no pool, game event, formation, linked respawn or SmartAI row names any of the 12 guids (queried).
-- C-7. Pillar of Diamond 2842 (guid 9909), Pillar of Opal 2848 (4216) and Pillar of Amethyst 2858 (9219): chests whose only
--   loot is a quest item (4845 / 4844 / 4843, quest chance -100) of retired quests, respawn 1 s; neither TDB spawns them. A
--   player could click one and get an empty loot window. No pool, game event or addon row names them (queried).
-- Sourced: both TDBs. Ours: nothing.

DELETE FROM `creature_addon` WHERE `guid` IN (6867,60292,60293,60294,60295,60296,60298,60301,60303,60304,60305,60306);
DELETE FROM `creature` WHERE `id` = 2791 AND `guid` IN (6867,60292,60293,60294,60295,60296,60298,60301,60303,60304,60305,60306);

DELETE FROM `gameobject` WHERE `guid` IN (9909,4216,9219) AND `id` IN (2842,2848,2858);
