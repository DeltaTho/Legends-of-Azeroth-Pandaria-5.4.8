-- Duokna (3158) climbs on Galgar's table and dances, and Galgar scolds her.
-- Sourced: both TDBs (smart_scripts 3158 and action list 315800, rows identical): every 30 s out of combat she walks onto the table
-- (-563.1,-4217.3,42.9), dances (emote state 10) after 3 s, 2 s later Galgar (9796, closest within 20 yd) says one of his four lines
-- (creature_text 9796 group 0, already in mop: "Duokna, what are you doing?", "Get down from there this instant!", ...), 8 s later she
-- walks back to her spawn point, stops dancing and turns to her spawn facing after 3 s. Wowhead (Galgar) [+10]: "seems to get upset
-- when Duokna gets on his table and dances".
-- Duokna has no AI today (AIName '', ScriptName ''); beta's sql/updates have no rows for 3158 or 315800.
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 3158 AND `AIName` = '' AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3158 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 315800 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3158, 0, 0, 0, 1, 0, 100, 0, 2000, 2000, 30000, 30000, 0, 80, 315800, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Duokna - Out of Combat - Run Script'),
(315800, 9, 0, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 69, 1, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, -563.079, -4217.33, 42.8817, 5.00283, 'Duokna - On Script - Move To Galgar''s Table'),
(315800, 9, 1, 0, 0, 0, 100, 0, 3000, 3000, 0, 0, 0, 17, 10, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Duokna - On Script - Set Emote State 10 (Dance)'),
(315800, 9, 2, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 19, 9796, 20, 0, 0, 0, 0, 0, 0, 'Duokna - On Script - Galgar Says Line 0'),
(315800, 9, 3, 0, 0, 0, 100, 0, 8000, 8000, 0, 0, 0, 69, 2, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, -565.393, -4213.93, 41.661, 0, 'Duokna - On Script - Move Back'),
(315800, 9, 4, 0, 0, 0, 100, 0, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Duokna - On Script - Set Emote State 0'),
(315800, 9, 5, 0, 0, 0, 100, 0, 3000, 3000, 0, 0, 0, 66, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 5.18363, 'Duokna - On Script - Set Orientation');
