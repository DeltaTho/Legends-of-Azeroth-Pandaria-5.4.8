-- Blasted Lands, 25707 The Future of the Rockpool: the scripts of the crate drag (zone_blasted_lands_rockpool.cpp).
-- 41402 Abandoned Bloodwash Crate (the crate dragged into the sea), 41454 Abandoned Bloodwash Crate (the one adrift, summoned by
-- 77563), 77549 The Future of the Rockpool: Quest Launch (boards only the crate talked to).
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_abandoned_bloodwash_crate' WHERE `entry` = 41402;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_bloodwash_crate_adrift' WHERE `entry` = 41454;
DELETE FROM `spell_script_names` WHERE `spell_id` = 77549 AND `ScriptName` = 'spell_rockpool_quest_launch';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (77549, 'spell_rockpool_quest_launch');
