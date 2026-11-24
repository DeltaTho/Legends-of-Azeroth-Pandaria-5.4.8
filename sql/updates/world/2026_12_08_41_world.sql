-- Echo Isles: the class trainer speaks when The Basics: Hitting Things or Proving Pit becomes complete (quest_echo_isles_trainer_praise).
-- Sourced: group 0 "Not bad, $n. Not bad." (broadcast 37928) and group 1 "Well done, $n!" (broadcast 37898) on exactly these nine
-- trainers in TDB 4.4.2 and 12.1.0; warcraft.wiki.gg The Basics: Hitting Things (hunter), Notes: "After destroying the tiki targets:
-- Ortezza says: Not bad, <name>. Not bad." Ours: group 1 is said when Proving Pit becomes complete (no source names the event);
-- TextRange 5 (personal): the trainer may stand beyond say range of the player, and nobody else needs a stranger's name.
-- None of the nine had creature_text rows before. quest_template_addon rows exist for all eighteen quests; only ScriptName is set.
DELETE FROM `creature_text` WHERE `CreatureID` IN (38037, 38242, 38243, 38244, 38245, 38246, 38247, 42618, 63310) AND `GroupID` IN (0, 1);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(38037, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Nortet - The Basics: Hitting Things complete'),
(38037, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Nortet - Proving Pit complete'),
(38242, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Nekali - The Basics: Hitting Things complete'),
(38242, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Nekali - Proving Pit complete'),
(38243, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Zen''tabra - The Basics: Hitting Things complete'),
(38243, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Zen''tabra - Proving Pit complete'),
(38244, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Legati - The Basics: Hitting Things complete'),
(38244, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Legati - Proving Pit complete'),
(38245, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Tunari - The Basics: Hitting Things complete'),
(38245, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Tunari - Proving Pit complete'),
(38246, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Soratha - The Basics: Hitting Things complete'),
(38246, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Soratha - Proving Pit complete'),
(38247, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Ortezza - The Basics: Hitting Things complete'),
(38247, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Ortezza - Proving Pit complete'),
(42618, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Voldreka - The Basics: Hitting Things complete'),
(42618, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Voldreka - Proving Pit complete'),
(63310, 0, 0, 'Not bad, $n. Not bad.', 12, 0, 100, 0, 0, 0, 0, 37928, 5, 'Zabrax - The Basics: Hitting Things complete'),
(63310, 1, 0, 'Well done, $n!', 12, 0, 100, 0, 0, 0, 0, 37898, 5, 'Zabrax - Proving Pit complete');
UPDATE `quest_template_addon` SET `ScriptName` = 'quest_echo_isles_trainer_praise' WHERE `ID` IN (24639, 24751, 24759, 24765, 24771, 24777, 24783, 26273, 31158, 24642, 24754, 24762, 24768, 24774, 24780, 24786, 26276, 31161);
