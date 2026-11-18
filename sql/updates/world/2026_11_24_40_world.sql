-- Blasted Lands, The Altar of Storms (25688 / 26162): Shadowsworn Obstructor 41191 gets its C++ AI
-- (npc_blasted_lands_shadowsworn_obstructor): channel at Loramus' Body out of combat, wander between channels, pulled by players
-- coming near. Its one SmartAI row (in combat, Disrupt Ritual on the victim; both TDBs, carried into 2026_10_29_987) is in the
-- script with the same timers, so the row goes.
-- Sourced: the in-combat row's spell and timers. Ours: everything the script header marks as ours.
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_blasted_lands_shadowsworn_obstructor' WHERE `entry` = 41191;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 41191 AND `source_type` = 0;
