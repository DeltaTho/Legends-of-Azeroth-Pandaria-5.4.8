-- Blasted Lands, Neptool's Revenge 25706: the Rockpool Gladiators 42367 fight each other in the two pits.
-- Sourced: "gladiatorial pools ... where they pit my people against one another" (quest text); "fighting pits that feature
-- murlocs forced to fight each other" (41404 comment 2010-12-04); template faction 2263 and idle spawns (both TDBs).
-- Ours: how. One gladiator of each pair takes FactionTemplate 1690 and its partner 1691 on every reset: hostile to each other,
-- friendly to both player factions (players still cannot attack them) and neutral to the Bloodwash naga (2245, 2205) and the
-- beasts nearby (73), so nobody else joins (2263 would draw the naga 2245: hostile.py); the EPL Darrowshire pair.
-- IMMUNE_TO_PC dropped (a unit flagged so cannot be any creature's victim here); creature_sparring_template keeps the fights
-- going (no NPC damage below 60 %).
UPDATE `creature_template` SET `faction` = 2263, `unit_flags` = 32768, `AIName` = 'SmartAI' WHERE `entry` = 42367;
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 42367;
DELETE FROM `creature_sparring_template` WHERE `creature_id` = 42367;
INSERT INTO `creature_sparring_template` (`creature_id`, `health_limit_pct`, `comment`) VALUES (42367, 60, 'Rockpool Gladiator - pit fights never end');
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (42367, -163022, -163023, -163024, -163025) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(-163022, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 0, 2, 1690, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Rockpool Gladiator (pit 1) - On Reset - Set Faction 1690'),
(-163022, 0, 1, 0, 1, 0, 100, 0, 2000, 2000, 5000, 5000, 0, 49, 0, 0, 0, 0, 0, 0, 10, 163025, 42367, 0, 0, 0, 0, 0, 0, 'Rockpool Gladiator (pit 1) - OOC - Attack its partner'),
(-163025, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 0, 2, 1691, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Rockpool Gladiator (pit 1) - On Reset - Set Faction 1691'),
(-163023, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 0, 2, 1690, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Rockpool Gladiator (pit 2) - On Reset - Set Faction 1690'),
(-163023, 0, 1, 0, 1, 0, 100, 0, 2000, 2000, 5000, 5000, 0, 49, 0, 0, 0, 0, 0, 0, 10, 163024, 42367, 0, 0, 0, 0, 0, 0, 'Rockpool Gladiator (pit 2) - OOC - Attack its partner'),
(-163024, 0, 0, 0, 25, 0, 100, 0, 0, 0, 0, 0, 0, 2, 1691, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Rockpool Gladiator (pit 2) - On Reset - Set Faction 1691');
