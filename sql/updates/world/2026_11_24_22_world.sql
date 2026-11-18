-- Blasted Lands, Nethergarde Mines (25678 Pick Your Fate, 25681 Some People Just Need Killing): let the Ticking Time Bombs
-- explode. Nethergarde Engineers 5997 (SAI id 4) and Chief Prospector Hondo 41173 (SAI id 4) cast 79726 Ticking Time Bomb
-- (1.5 s cast) at their victim: it summons 42776 there (SummonProperties 61: ally guardian, so the bomb takes its owner's
-- faction 1575 and level, Minion::InitStats / Guardian::InitStats). 42776 had no AIName and no rows, so the bombs stood there
-- for their 3 s and did nothing.
-- Sourced (TDB 4.4.2 smart_scripts 42776 ids 0-1, as written there): on spawn the bomb casts 79728 Explosion on itself and
-- despawns 3 s later. 79728: school damage, 4 yd around the bomb (radius index 26), enemies of the bomb only: Horde players,
-- their pets and bots; not the dwarves (its own faction), not Alliance players (friendly to 1575), not a boxed player (the
-- rider is not selectable and the box is immune to NPCs).
-- Rows: creature_template 42776 AIName; smart_scripts 42776 ids 0-1.
UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 42776;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 42776 AND `source_type` = 0 AND `id` IN (0, 1);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(42776, 0, 0, 1, 11, 0, 100, 0, 0, 0, 0, 0, 0, 11, 79728, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ticking Time Bomb - On Respawn - Cast ''Explosion'''),
(42776, 0, 1, 0, 61, 0, 100, 1, 0, 0, 0, 0, 0, 41, 3000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ticking Time Bomb - On Respawn - Despawn In 3000 ms (No Repeat)');
