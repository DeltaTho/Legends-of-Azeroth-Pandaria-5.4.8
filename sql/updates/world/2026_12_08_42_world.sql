-- Echo Isles: Zuni meets the player at the bridge to Kijara's island (A Troll's Truest Companion 24622) and runs off when he takes
-- Saving the Young 24623 (zone_echo_isles.cpp: at_echo_isles_zuni_bridge, npc_echo_isles_zuni_bridge).
-- Sourced: the four lines and when they are said (warcraft.wiki.gg A Troll's Truest Companion and Saving the Young, Notes), their
-- broadcast texts 39066-39069 and sounds (broadcast_text.SoundEntriesID), the entry 38930 (Spell.dbc 73302 Summon Zuni (Lvl 2)).
-- Ours: AreaTrigger.dbc 5677 (the box over the first bridge towards Bloodtalon Shore) as the place she appears; TextRange 5
-- (she is a personal summon, SummonProperties 2995, so only her player sees her). 38930 had no AI, text or spawn; 5677 had no
-- areatrigger row in mop or either TDB.
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_echo_isles_zuni_bridge' WHERE `entry` = 38930;
DELETE FROM `creature_text` WHERE `CreatureID` = 38930;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(38930, 0, 0, 'Wait up, mon!', 12, 0, 100, 0, 0, 21368, 0, 39066, 5, 'Zuni (Lvl 2) - appears at the bridge'),
(38930, 1, 0, 'You finished with ya trainin'' too? Glad you make it through, mon!', 12, 0, 100, 0, 0, 21370, 0, 39067, 5, 'Zuni (Lvl 2) - at the bridge'),
(38930, 2, 0, 'I know dis is prolly busy work, but I don''t mind. Dese baby raptors are cute lil devils.', 12, 0, 100, 0, 0, 21371, 0, 39068, 5, 'Zuni (Lvl 2) - at the bridge'),
(38930, 3, 0, 'Try not ta make me look too bad, eh?', 12, 0, 100, 0, 0, 21373, 0, 39069, 5, 'Zuni (Lvl 2) - Saving the Young accepted');
DELETE FROM `areatrigger_scripts` WHERE `entry` = 5677;
INSERT INTO `areatrigger_scripts` (`entry`, `ScriptName`) VALUES
(5677, 'at_echo_isles_zuni_bridge');
