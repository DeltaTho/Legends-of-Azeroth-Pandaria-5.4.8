-- Echo Isles: Zuni goes with the player in Spitescale Cavern (No More Mercy 24812, Territorial Fetish 24813) and runs up the hill
-- when both are done (zone_echo_isles.cpp: spell_echo_isles_zuni_cave_aura, npc_echo_isles_zuni_cave).
-- Sourced: the greeting and the eight kill lines (warcraft.wiki.gg No More Mercy, Notes; Wowhead 24813 2011-08-25) with their
-- broadcast texts 39070 and 38255-38262 and sounds (broadcast_text.SoundEntriesID; 38260 "Ya about to be darkspeared." exists,
-- which the dossier had not found); the aura 73130 Summon Zuni (Lvl 4) Aura, castable only in Spitescale Cavern 4913, and the
-- entry 38932 it summons through 73131 (Spell.dbc).
-- Ours: spell_area gives 73130 in area 4913 while either quest is in progress (quest_start_status 8 = QUEST_STATUS_INCOMPLETE);
-- the area includes Morakki, who gives both quests at the cave mouth. TextRange 5 (a personal summon, SummonProperties 2996).
-- DONT_SAVE_AURA_TO_DB on 73130: spell_area gives it again at login, and the script then brings Zuni.
-- 38932, 73130 and 73131 had no AI, text, spell_area, spell script or custom attribute rows (searched).
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_echo_isles_zuni_cave' WHERE `entry` = 38932;
DELETE FROM `creature_text` WHERE `CreatureID` = 38932;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(38932, 0, 0, 'Ha! I caught up with ya! Let''s stick together in ''ere, okay?', 12, 0, 100, 0, 0, 21387, 0, 39070, 5, 'Zuni (Lvl 4) - catches up in Spitescale Cavern'),
(38932, 1, 0, 'Ya momma was bait fish.', 12, 0, 100, 0, 0, 21375, 0, 38255, 5, 'Zuni (Lvl 4) - naga killed'),
(38932, 1, 1, 'Die snakefish!', 12, 0, 100, 0, 0, 21376, 0, 38256, 5, 'Zuni (Lvl 4) - naga killed'),
(38932, 1, 2, 'If I fished ya up, I''d throw ya back. Waste of good fish meat.', 12, 0, 100, 0, 0, 21378, 0, 38257, 5, 'Zuni (Lvl 4) - naga killed'),
(38932, 1, 3, 'Go suck on a trident.', 12, 0, 100, 0, 0, 21379, 0, 38258, 5, 'Zuni (Lvl 4) - naga killed'),
(38932, 1, 4, 'Ya mest with da wrong trolls, fishhead.', 12, 0, 100, 0, 0, 21380, 0, 38259, 5, 'Zuni (Lvl 4) - naga killed'),
(38932, 1, 5, 'Ya about to be darkspeared.', 12, 0, 100, 0, 0, 21382, 0, 38260, 5, 'Zuni (Lvl 4) - naga killed'),
(38932, 1, 6, 'Wow. Ya even ugly for a naga.', 12, 0, 100, 0, 0, 21384, 0, 38261, 5, 'Zuni (Lvl 4) - naga killed'),
(38932, 1, 7, 'Oi mon, it reeks of bad fish in ''ere.', 12, 0, 100, 0, 0, 21385, 0, 38262, 5, 'Zuni (Lvl 4) - naga killed');
DELETE FROM `spell_area` WHERE `spell` = 73130 AND `area` = 4913;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`, `quest_start_status`, `quest_end_status`) VALUES
(73130, 4913, 24812, 0, 0, 0, 2, 1, 8, 11),
(73130, 4913, 24813, 0, 0, 0, 2, 1, 8, 11);
DELETE FROM `spell_script_names` WHERE `spell_id` = 73130;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(73130, 'spell_echo_isles_zuni_cave_aura');
DELETE FROM `spell_custom_attribute` WHERE `spell` = 73130;
INSERT INTO `spell_custom_attribute` (`spell`, `attribute`, `comment`) VALUES
(73130, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'Summon Zuni (Lvl 4) Aura - spell_area gives it again at login');
