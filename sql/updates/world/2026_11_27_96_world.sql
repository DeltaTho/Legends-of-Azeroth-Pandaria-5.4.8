-- Sergeant Curtis (5809, rare, Tiragarde Keep, guid 252648): drop the SmartAI rows of the NPC he replaced.
--
-- Entry 5809 was Watch Commander Zalaphil before Cataclysm; patch 4.0.3a replaced him with Sergeant Curtis (wiki). mop's
-- SmartAI kept Zalaphil's four rows (ids 0-3: Defensive Stance out of combat, Shield Bash on a timer and on a cast,
-- flee at 15 %, all commented "Watch Commander Zalaphil") beside Curtis's own two (ids 4-5).
-- Sourced, both TDBs: exactly two rows, id 0 On Aggro cast 78894 Leaping Cleave on the aggressor (target 7), id 1 In Combat 7-9 s then
-- every 22-27 s cast 79726 Ticking Time Bomb on the victim. mop's ids 4 and 5 are those two rows, added by the abilities
-- pass (2026_10_29_988_abilities_008, which deletes ids >= 4 and inserts them); they are kept as that file wrote them
-- (event_flags 1 on the aggro row where the TDBs have 0: the same, as On Aggro fires once per aggro) and renumbered 0 and
-- 1. This file runs after it and replaces the whole entry.

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 5809;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 5809 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`,
  `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`,
  `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`,
  `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(5809, 0, 0, 0, 4, 0, 100, 1, 0, 0, 0, 0, 0, 11, 78894, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Sergeant Curtis - On Aggro - Cast ''Leaping Cleave'' (No Repeat)'),
(5809, 0, 1, 0, 0, 0, 100, 0, 7000, 9000, 22000, 27000, 0, 11, 79726, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Sergeant Curtis - In Combat - Cast ''Ticking Time Bomb''');
