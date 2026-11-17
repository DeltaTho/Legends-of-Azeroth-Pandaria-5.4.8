-- Burning Steppes A (_05): creature templates as both TDBs (plan A-13, A-27, A-32..A-35; S5 Part E, plan K4).
--
-- SOURCED (both TDBs, verified against the 4.4.2 dump):
-- * Blackrock Whelper 47782 (Burning Vengeance) and Thaurissan Spy 7036 (Prove Yer Allegiance): unit_flags 0. mop had 0x20048000;
--   STUNNED (0x40000) refuses every cast (Spell::CheckCasterAuras) and the client draws them stunned, so Whelpers never used Sunder
--   Armor / Blood Fury and Spies never Poison / Backstab. 0x20000000 (PREVENT_EMOTES) goes too; 0x8000 stays as on every mop mob.
--   All their spawns carry creature.unit_flags 0, so the template value applies.
-- * Obsidian Elemental 7031: no template or spawn aura. mop had 9941 Obsidian Reflection on permanently; its SmartAI casts it at 40 % (as
--   both TDBs).
-- * Festival Scorchling 26520 (Midsummer, Horde bonfire ender): faction 188 (mop 83, drawn hostile to the Alliance).
-- * Blackrock Anomaly 27471 is given by Helendis 9562 only; mop also let Acride 10299 (its ender, inside Lower Blackrock Spire) give
--   it.
-- * Ragged John 9563: no "Milk me, John." option (retired classic quest Mother's Milk; in neither TDB).
-- Idempotent: the flag UPDATE clears bits only; the others are absolute or DELETEs.

UPDATE `creature_template` SET `unit_flags` = `unit_flags` & ~0x20040000 WHERE `entry` IN (7036, 47782);
UPDATE `creature_template_addon` SET `auras` = NULL WHERE `entry` = 7031 AND `auras` = '9941';
-- four spawns carry it on their own addon too (165546, 165881, 165882, 165977; a spawn addon replaces the template's)
UPDATE `creature_addon` a JOIN `creature` c ON c.`guid` = a.`guid` SET a.`auras` = NULL WHERE c.`id` = 7031 AND a.`auras` = '9941';
UPDATE `creature_template` SET `faction` = 188 WHERE `entry` = 26520;
DELETE FROM `creature_queststarter` WHERE `id` = 10299 AND `quest` = 27471;
DELETE FROM `gossip_menu_option` WHERE `MenuID` = 2061 AND `OptionID` = 0;
