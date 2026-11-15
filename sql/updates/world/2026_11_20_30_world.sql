-- Badlands: template fields of the zone's rares and wanderers as both TDBs have them (plan items C-1, C-2, C-3).
--
-- Sourced (TDB 4.4.2 and 12.1.0 agree on every row below):
--   * Stonevault Wanderers 46713 (the dead troggs round Dr. Blam's turret, Agmond's End): they STAY dead-posed (Permanent
--     Feign Death 29266 on the template stays; the first draft removed it, overturned by the orchestrator after the playthrough
--     walks). Reasons: ten of the 25 spawns stand within 20 yd of Blam 46664 at -7006 -3342, nine of them on TDB spots; both TDBs
--     have all 23 spawns idle (MovementType 0), and the Wowhead comments say "can't loot them" / "yield no experience, no loot".
--     Live hostile troggs would aggro at every Blam hand-in. The fault the player would have seen is corpses sliding about:
--     all 25 spawns now stand still (MovementType 0, wander 0), the nine that walked a 4-6 point path lose the path link
--     (creature_addon path_id 0; their waypoint_data rows go, no other spawn uses them: checked) and spawn 162724 is deleted
--     (1.6 yd from Blam, 5.3 yd from the nearest TDB spawn: in neither TDB, which have 23 spawns against mop's 25; mop's other
--     spawns without a TDB spot are left).
--     Addendum (re-check): Permanent Feign Death 29266 is only a stun plus a dummy: the corpses stayed hostile (faction 59), started combat with a player
--     walking past (seven stand 5-19 yd from Blam) and could be killed for XP and loot, against the comments. So the template
--     also gets unit_flags IMMUNE_TO_PC 0x100 + IMMUNE_TO_NPC 0x200 (current value 0, so 768): nobody can start combat with or
--     attack them (IMMUNE_TO_NPC is what stops them starting combat, as the archetypes list says). They stay selectable and their
--     loot table is untouched (they cannot be killed). No spawn overrides unit_flags (all 25 rows 0), and all 24 that remain
--     are dead ones (the aura is on the template, no spawn addon removes it). Their one SmartAI row (in combat, Stone Splinter
--     every 14-15 s) can never run on an immune corpse, so it stays.
--   * Broken Tooth 2850: unit_flags 64 (mop 262208 = 64 + UNIT_FLAG_STUNNED 0x40000: the rare stood stunned).
--   * Rumbler 2752 faction 91 (the Rock Elementals' own), Zaricotl 2931 faction 7 (neutral, a yellow rare).
--   * Obsidian Golem 4872: the template aura 9941 Obsidian Reflection goes (both TDBs cast it in combat from SmartAI, as mop
--     does, so mop had it permanently on top; one spawn). Exploding Sheep 50594: the template aura 93751 (a DUMMY aura) goes,
--     no sniffed sheep has it and nothing in mop uses it. The dossier named the
--     template row only; 11 of the 39 sheep (the ones on paths: guids 162974, 162985, 162988, 162990, 162991, 162994, 162995,
--     162998, 162999, 163000, 163005) also carry it in their own creature_addon, so those rows are cleared as well (ours: the
--     same fix, on the spawns that would otherwise keep the aura).
--   Ridge Stalker 2731 (7939 22766 in the TDBs, 22766 in mop) stays: 7939 is not in the 5.4.8 Spell.dbc.
-- Ours: deleting 162724 and dropping the paths of the nine walkers (the orchestrator's ruling); the sniffs have the rest idle.
--
-- Every spawn of each entry was listed before the template rows were changed: 46713 25 spawns (Agmond's End; 24 after the delete), 2850 4, 2752 3,
-- 2931 4, 4872 1, 50594 39 (all zone 3; no spawn row carries its own faction or unit_flags for these entries).

-- Stonevault Wanderers: inert (IMMUNE_TO_PC | IMMUNE_TO_NPC = 0x300), idle, no paths, 162724 gone
UPDATE `creature_template` SET `unit_flags` = 768 WHERE `entry` = 46713 AND `unit_flags` IN (0, 768);
UPDATE `creature_addon` SET `path_id` = 0 WHERE `path_id` IN (162127,162712,162716,162718,162719,162720,162722,162729,162883)
  AND `guid` IN (SELECT `guid` FROM `creature` WHERE `id` = 46713);
DELETE FROM `waypoint_data` WHERE `id` IN (162127,162712,162716,162718,162719,162720,162722,162729,162883);
DELETE FROM `creature_addon` WHERE `guid` = 162724;
DELETE FROM `creature` WHERE `guid` = 162724 AND `id` = 46713;
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 46713;

UPDATE `creature_template` SET `unit_flags` = 64 WHERE `entry` = 2850 AND `unit_flags` = 262208;
UPDATE `creature_template` SET `faction` = 91 WHERE `entry` = 2752 AND `faction` = 14;
UPDATE `creature_template` SET `faction` = 7 WHERE `entry` = 2931 AND `faction` = 14;

UPDATE `creature_template_addon` SET `auras` = NULL WHERE `entry` = 4872 AND `auras` = '9941';
UPDATE `creature_template_addon` SET `auras` = NULL WHERE `entry` = 50594 AND `auras` = '93751';
UPDATE `creature_addon` SET `auras` = NULL WHERE `auras` = '93751'
  AND `guid` IN (SELECT `guid` FROM `creature` WHERE `id` = 50594);
