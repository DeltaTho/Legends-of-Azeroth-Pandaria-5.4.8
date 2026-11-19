-- Durotar: Thunder Down Under (25236). Clicking a Drowned Thunder Lizard 39464 made the player cast Lightning Discharge 73958
-- (100 nature damage and a 2 s stun on every unit within 8 yd: the clicker, other players, nothing excluded); the lizard's SmartAI
-- then gave the credit on that spell's hit. Retail: the click is a 1 s cast "Attach Tether", a Hulking Orcish Laborer hauls the
-- carcass out on the rope, and the lizards discharge on their own and stun you if you linger beside them.
-- Sourced: comments 2011-08-09 [+8] (a cast bar, "the rope is attached to the last target you click"), 2011-11-30 [+2] ("tether
-- them up to surface"), npc 39465 comment [+11] (the laborer pulls the lizard out and it despawns), 2010-12-17 [+4] and the wiki
-- notes (they periodically discharge and stun you if close, about 100 nature damage, though dead); quest text ("I've got grunts
-- that can lift them out"). DBC 5.4.8: 73945 Attach Tether (1 s cast; SUMMON 39465 at DEST_NEARBY_ENTRY 40 yd, 60 s; KILL_CREDIT
-- 39464 on the caster, group-wide), 73951 Lift Drowned Thunder Lizard - Effect (1 s, channelled 25 s dummy aura on the target: the
-- rope), 73958 Lightning Discharge (2.5 s cast, 100 nature, 2 s stun, 8 yd around the caster). Both TDBs: the lizard casts 73958
-- in combat every 22-25 s (kept: id 1; the lizards are friendly and never enter combat, so it never runs).
-- What the player sees: right-click a lizard (quest in progress) -> 1 s "Attach Tether" bar -> credit; a laborer appears on the
-- nearest shore, faces the lizard and casts his rope on it; the carcass floats up the rope towards him and is gone 7 s later
-- (respawn 60 s); the laborer goes after 9 s (script spell_durotar_attach_tether, which replaces the spell's own summon at the
-- carcass on the lake floor; the clicked lizard is the one the player has selected). A hauled lizard discharges no more.
-- Swimming within 8 yd of a lizard, the lizard casts Lightning Discharge (2.5 s bar) at most every 15-25 s: 100 damage and 2 s stun.
-- Ours: the ambient trigger (a player moving within 8 yd, in line of sight, cooldown 15-25 s per lizard: "if close"), the shore
-- points and the haul. Keeping it harmless (ours): the discharge hits only players (no NPC, no pet) with more than 150 health, so it
-- can never kill (100 flat damage, cannot crit, creature spell damage rate 1); no two lizards stand within 16 yd of each other, so
-- one lizard at a time can reach a player. The lizards are friendly (faction 35): the damage starts no combat (CombatManager
-- refuses friendly pairs; Unit::DealDamage sets none), so out-of-combat regeneration (1 % per 2 s) keeps running.
-- The fishing daily's click (80948, Orgrimmar's 26572) is untouched. The sources' shock is "if close", not on the tether: the haul
-- interrupts the lizard's cast and ends its discharges (phase 2), so the one who tethers is not shocked by that lizard afterwards.

-- The click: Attach Tether, only while the quest is in progress
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 39464 AND `spell_id` IN (73958, 73945);
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(39464, 73945, 1, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` = 39464 AND `SourceEntry` IN (73958, 73945);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` IN (73945, 73958);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
 `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(18, 39464, 73945, 0, 0, 47, 0, 25236, 8, 0, 0, 0, 0, '', 'Drowned Thunder Lizard - Attach Tether only while Thunder Down Under is in progress'),
(13, 1, 73945, 0, 0, 31, 0, 3, 39464, 0, 0, 0, 0, '', 'Attach Tether - the target is the Drowned Thunder Lizard (spell_durotar_attach_tether puts the laborer on the shore)'),
(13, 3, 73958, 0, 0, 32, 0, 16, 0, 0, 0, 0, 0, '', 'Lightning Discharge - players only'),
(13, 3, 73958, 0, 0, 37, 0, 150, 1, 0, 0, 0, 0, '', 'Lightning Discharge - only players above 150 health (never kills; ours)');

-- The lizard: ambient discharge, and hauled out on the rope
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 39464;
UPDATE `creature_template` SET `AIName` = '' WHERE `entry` = 39465;
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (39464, 39465);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(39464, 0, 0, 0, 10, 1, 100, 0, 1, 8, 15000, 25000, 1, 11, 73958, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Drowned Thunder Lizard - Player within 8 yd - Cast Lightning Discharge (wiki: discharges and stuns you if close; ours: cooldown 15-25 s; not once hauled)'),
(39464, 0, 1, 0, 0, 0, 100, 0, 4000, 7000, 22000, 25000, 0, 11, 73958, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Drowned Thunder Lizard - In Combat - Cast Lightning Discharge (both TDBs)'),
(39464, 0, 2, 4, 25, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Drowned Thunder Lizard - On Reset (spawn, respawn) - Phase 1 (lying, discharging)'),
(39464, 0, 3, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Drowned Thunder Lizard - On data 1 = 1 (hauled out by spell_durotar_attach_tether) - Phase 2 (no more discharges)'),
(39464, 0, 4, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 60, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Drowned Thunder Lizard - Linked - Gravity back on (after a haul)');

-- The laborer is summoned by Attach Tether; the one wandering static copy on the shore is in neither TDB
DELETE FROM `creature_addon` WHERE `guid` = 303082;
DELETE FROM `creature` WHERE `guid` = 303082;

-- The haul (script). The laborer's rope (73951) is cast triggered from the shore and must not fail line of sight to a lizard deep
-- under the water: disables flag 64 (SPELL_DISABLE_LOS) for this cosmetic channel only.
DELETE FROM `disables` WHERE `sourceType` = 0 AND `entry` = 73951;
INSERT INTO `disables` (`sourceType`, `entry`, `flags`, `params_0`, `params_1`, `comment`) VALUES
(0, 73951, 64, '', '', 'Ignore LOS - Lift Drowned Thunder Lizard - Effect (the laborer''s rope from the shore, Thunder Down Under)');
DELETE FROM `spell_script_names` WHERE `spell_id` = 73945;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(73945, 'spell_durotar_attach_tether');
