-- Echo Isles: Tiki Target 38038 runs npc_echo_isles_tiki_target (zone_echo_isles.cpp) instead of SmartAI.
-- The script ports every SmartAI row deleted here (random Tiki Target Visual 1-3 on spawn, health regeneration off, Set Data 0 1 on
-- the novices within 50 yd, Tiki Target Death on death, Spell Practice Credit 44175 for the practice spells) and adds the 5 s
-- end of combat with a player who stops hitting it (ours) and the 2 s corpse despawn (sourced: Wowhead 38038, 2011-02-10).
-- No condition rows exist for these SmartAI rows (source type 22 searched).
-- Ours: CREATURE_FLAG_EXTRA_NO_PLAYER_DAMAGE_REQ (0x400000). The novices (mop SmartAI; both TDBs have them attack the closest
-- target) wear the targets down and a target the player then finishes gave no kill credit for The Basics: Hitting Things
-- (Creature::IsDamageEnoughForLootingAndReward). With the flag the kill goes to the player who tapped it. flags_extra was 262208
-- (NO_XP_AT_KILL | NO_SKILLGAIN); written absolute.
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_echo_isles_tiki_target', `flags_extra` = 262208 | 0x400000 WHERE `entry` = 38038;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 38038 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (3803800, 3803801, 3803802) AND `source_type` = 9;
