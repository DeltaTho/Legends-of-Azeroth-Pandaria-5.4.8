-- Blasted Lands A (_07): Terrified Nethergarde Miners (41162) do not attack on sight; they cower, call for help, fight back
-- when attacked and run at low health (dossier S1 F-TERRIFIED; Pick Your Fate 25678 credit via KillCredit1 5996, That's Not Us
-- 25680's tunnel).
--
-- Today: no AI (AggressorAI), faction 1575 hostile to the Horde: every terrified miner attacks a Horde player on sight; no text.
-- SOURCED: 25680 [+19] "Terrified Miners won't aggro unless you attack them; the Reassuring Foremen will"; 41162 [+11] they shout
-- "Save us" / "Help us" even to the Horde (broadcast texts 41118 "Help us!", 41121 "Save us!"); template spell1 80382 Dirt Toss,
-- spell2 6016 Pierce Armor.
-- OURS: the civilian flag as the mechanism (Creature::CanStartAttack returns false, Creature.cpp 1779; CanAssistTo too, so they
-- do not join a foreman's fight), the line timer (25 % every 45-90 s, out of combat), the spell timers, the flee at 15 %.
-- They stay attackable by players, pets and bots and fight back (civilian only stops them starting a fight).

UPDATE `creature_template` SET `flags_extra` = `flags_extra` | 0x2, `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 41162;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 41162 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(41162, 0, 0, 0, 1, 0, 25, 0, 15000, 45000, 45000, 90000, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Terrified Nethergarde Miner - Out of Combat - Say Line 0'),
(41162, 0, 1, 0, 0, 0, 100, 0, 6000, 9000, 21000, 26000, 0, 11, 80382, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Terrified Nethergarde Miner - In Combat - Cast ''Dirt Toss'''),
(41162, 0, 2, 0, 9, 0, 100, 0, 0, 5, 12000, 13000, 0, 11, 6016, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Terrified Nethergarde Miner - Within 0-5 Range - Cast ''Pierce Armor'''),
(41162, 0, 3, 0, 2, 0, 100, 1, 0, 15, 0, 0, 0, 25, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Terrified Nethergarde Miner - Between 0-15% Health - Flee For Assist (No Repeat)');
DELETE FROM `creature_text` WHERE `CreatureID` = 41162;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(41162, 0, 0, 'Help us!', 12, 0, 50, 0, 0, 0, 0, 41118, 0, 'Terrified Nethergarde Miner - idle'),
(41162, 0, 1, 'Save us!', 12, 0, 50, 0, 0, 0, 0, 41121, 0, 'Terrified Nethergarde Miner - idle');
