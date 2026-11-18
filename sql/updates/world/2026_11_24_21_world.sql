-- Blasted Lands, 25708 Our Fallen Friends: a spirit rises from each slain Drowned Gilnean (C++ in
-- zone_blasted_lands_nethergarde.cpp).
-- Sourced (one comment, 2010-11-24 by one user, posted alike on 42249 [+19], 42244 [+8], 42248 / 42252 [+5]; 2014-06-21 [+4];
-- the wiki notes; spells 78849 / 78847 / 78848, the spirits' addon auras 33900 + 78853): each Merchant, Sailor or Settler killed releases its spirit
-- in human form (male / female by the corpse's model), in a pillar of light, waving at the player as it rises into the sky.
-- Nothing cast 78849 (no death row in mop or either TDB); the four static spirits that wandered the shore (neither TDB spawns
-- 42252 / 42253) go.
-- Ours: the death rows as the trigger (cast triggered on self), the wave (the 2010 comment and the wiki note) over the bow
-- (the 2014 comment), the rise and its timings (C++).
-- Rows: smart_scripts 42244 id 2, 42248 id 3, 42249 id 3; ScriptName of 42252 / 42253 and of 78849; creature guids 164463,
-- 164464, 164467 (42252) and 164411 (42253) deleted (no addon, formation, pool, event or per-guid rows exist for them).
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_bl_drowned_gilnean_spirit' WHERE `entry` IN (42252, 42253);

DELETE FROM `spell_script_names` WHERE `spell_id` = 78849 AND `ScriptName` = 'spell_bl_summon_drowned_gilnean_spirit';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(78849, 'spell_bl_summon_drowned_gilnean_spirit');

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (42244, 42248, 42249);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND ((`entryorguid` = 42244 AND `id` = 2) OR (`entryorguid` = 42248 AND `id` = 3) OR (`entryorguid` = 42249 AND `id` = 3));
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(42244, 0, 2, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 11, 78849, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Drowned Gilnean Merchant - On Death - Cast ''Summon Drowned Gilnean Spirit (Master)'''),
(42248, 0, 3, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 11, 78849, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Drowned Gilnean Sailor - On Death - Cast ''Summon Drowned Gilnean Spirit (Master)'''),
(42249, 0, 3, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 11, 78849, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Drowned Gilnean Settler - On Death - Cast ''Summon Drowned Gilnean Spirit (Master)''');

DELETE FROM `creature` WHERE `guid` IN (164463, 164464, 164467, 164411) AND `id` IN (42252, 42253);
