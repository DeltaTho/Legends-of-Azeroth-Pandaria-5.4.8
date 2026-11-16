-- Searing Gorge, C-1: the Stonewrought Pass portcullis is gone (Cataclysm unlocked the road from Loch Modan).
-- Sourced: warcraft.wiki.gg Searing Gorge ("the key and the quest to obtain it have been removed, and the entrance is now
-- unlocked"); neither TDB spawns Door 150138. Door 71688 (lock 84 = Key to Searing Gorge 5396 or lockpicking, flags
-- LOCKED|NODESPAWN, closed) still stood at (-6034.97, -2488.73, 311.09). Ours: nothing; the spawn and its (empty) addon, event and
-- pool rows are deleted, and so is the dead Door Lever 17156 SmartAI row that targeted guid 71688 (no 17156 is spawned in
-- mop_world). Idempotent: DELETEs only.

DELETE FROM `gameobject_addon` WHERE `guid`=71688;
DELETE FROM `game_event_gameobject` WHERE `guid`=71688;
DELETE FROM `pool_gameobject` WHERE `guid`=71688;
DELETE FROM `gameobject` WHERE `guid`=71688 AND `id`=150138;
DELETE FROM `smart_scripts` WHERE `entryorguid`=17156 AND `source_type`=1 AND `id`=0 AND `target_type`=14 AND `target_param1`=71688;
