-- Zureetha Fargaze (3145), Foreman Thazz'ril (11378) and Nartok (3156) talk with their hands while idle, as both TDBs
-- (smart_scripts: out of combat, every 5-10 s, emote 1 TALK). They stood mute. AIName is set here only where the creature has no
-- other AI (all three have none today, and beta's sql/updates have no rows for them).
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (3145, 11378, 3156) AND `AIName` = '' AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (3145, 11378, 3156) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3145, 0, 0, 0, 1, 0, 100, 0, 1000, 1000, 5000, 10000, 0, 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Zureetha Fargaze - Out of Combat - Play Emote 1'),
(11378, 0, 0, 0, 1, 0, 100, 0, 1000, 1000, 5000, 10000, 0, 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Foreman Thazz''ril - Out of Combat - Play Emote 1'),
(3156, 0, 0, 0, 1, 0, 100, 0, 1000, 1000, 5000, 10000, 0, 5, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nartok - Out of Combat - Play Emote 1');
