-- A Rough Start: the Wildmane Cats' Wild Pounce kills the Docile Island Boar it lands on.
-- Sourced: the quest text "There be cats killing our boars"; warcraft.wiki.gg Wildmane Cat ("Wild Pounce: Leap at a Docile Island
-- Boar, pinning it to the ground"); TDB 4.4.2 and 12.1.0 smart_scripts 38141 (spell hit 71232: die, despawn 2 s later), AIName
-- SmartAI and unit_flags 0 in both TDBs. mop already had the cat's half (38046 id 2: out of combat every 2-5 min, Wild Pounce on a
-- boar 8-25 yd away) but the boar had no AI, so the pounce landed and nothing happened.
-- unit_flags: mop 33280 carries IMMUNE_TO_NPC (0x200), which neither TDB has; dropped so the cat's spell cannot be refused on it.
-- Cats (634), boars (1999), novices, watchers and guards are neutral to each other both ways (hostile.py), so no fights start.
UPDATE `creature_template` SET `AIName` = 'SmartAI', `unit_flags` = 32768 WHERE `entry` = 38141;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 38141 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(38141, 0, 0, 1, 8, 0, 100, 0, 71232, 0, 1000, 2000, 37, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Docile Island Boar - On Spellhit ''Wild Pounce'' - Die'),
(38141, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 41, 2000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Docile Island Boar - Linked - Despawn In 2000 ms');
