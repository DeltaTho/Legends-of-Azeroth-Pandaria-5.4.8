-- Benedict's Chest (gameobject 3239, guid 871) still stood on the roof of Tiragarde Keep. It holds the Aged Envelope that starts The Admiral's
-- Orders (830), removed in 4.0.3a (wiki; Wowhead MoP: "marked obsolete by Blizzard"), which has no ender here: a rogue with 100 lockpicking
-- could open it and get a quest he can never finish; everybody else saw a locked chest. Neither TDB spawns 3239. Sourced.
-- No gameobject_addon, event, pool or SmartAI rows use the spawn.
DELETE FROM `gameobject` WHERE `guid` = 871 AND `id` = 3239;
