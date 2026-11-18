-- Blasted Lands, 25681 Some People Just Need Killing: the Inconspicuous Box (C++ in zone_blasted_lands_nethergarde.cpp).
-- Sourced (wiki notes on 25681; comments 2010-11-23 [+43], 2010-12-06 [+36], 2011-05-22 [+9] on Hondo, 2012-07-27 [+19],
-- 2014-01-15 [+7]; broadcast texts 41184-41189, 41195, 41250-41253, 41290-41295): clicking a crate puts the player in a box
-- the dwarves ignore; Foremen (8 lines) and Engineers (6 lines) comment on the walking box, Hondo says his canary line when the
-- box comes up to him; miners say nothing.
-- The speakers follow the wiki's list (cilla), which gives the six "ambulatory cube / box-demon / Heavens to Betsy" lines to the
-- Engineers; two comments (2012-07-27, 2014-01-15) list them among the Foremen's without telling the speakers apart. The
-- broadcast ids agree with the wiki: the Foremen's lines are 41184-41189 / 41250-41253, the six others a block of their own
-- (41290-41295).
-- Ours: one line of the group at random, at most one line a minute per Foreman / Engineer and one every two minutes from
-- Hondo, the C++ telling them through SmartAI DATA_SET 1 1 (77049's own enemy search finds no target from a box immune to
-- NPCs, and a hit would pull them into combat). Hondo's canary line leaves his aggro (both TDBs say it on aggro; the comments
-- put it on seeing the box); his Throw on aggro stays.
-- Rows: creature_text 5998 / 41171 / 5997 group 1, 41173 group 0 (its text corrected to the broadcast text); smart_scripts
-- 5998 id 3, 41171 id 2, 5997 id 5, 41173 ids 0-1; ScriptNames of 203192, 41174 and 77049. The script never activates the
-- crate (203192), so it stays for the next player (no NODESPAWN flag needed).
UPDATE `gameobject_template` SET `AIName` = '', `ScriptName` = 'go_bl_inconspicuous_box' WHERE `entry` = 203192;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_bl_inconspicuous_box' WHERE `entry` = 41174;

DELETE FROM `spell_script_names` WHERE `spell_id` = 77049 AND `ScriptName` = 'spell_bl_box_vehicle_trigger';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(77049, 'spell_bl_box_vehicle_trigger');

DELETE FROM `creature_text` WHERE `CreatureID` IN (5998, 41171, 5997) AND `GroupID` = 1;
DELETE FROM `creature_text` WHERE `CreatureID` = 41173 AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(5998, 1, 0, 'Hmm...', 12, 0, 100, 0, 0, 0, 0, 41188, 0, 'Nethergarde Foreman - sees the Inconspicuous Box'),
(5998, 1, 1, 'Get back to work!  Oh wait... you''re just a box, never mind.', 12, 0, 100, 0, 0, 0, 0, 41253, 0, 'Nethergarde Foreman - sees the Inconspicuous Box'),
(5998, 1, 2, 'What in tarnation?', 12, 0, 100, 0, 0, 0, 0, 41250, 0, 'Nethergarde Foreman - sees the Inconspicuous Box'),
(5998, 1, 3, 'How peculiar.', 12, 0, 100, 0, 0, 0, 0, 41184, 0, 'Nethergarde Foreman - sees the Inconspicuous Box'),
(5998, 1, 4, 'A box that walks?  I should ask Hondo about this... nah, maybe later.', 12, 0, 100, 0, 0, 0, 0, 41251, 0, 'Nethergarde Foreman - sees the Inconspicuous Box'),
(5998, 1, 5, 'I do declare... a moving box.  The engineers have really done it this time!', 12, 0, 100, 0, 0, 0, 0, 41189, 0, 'Nethergarde Foreman - sees the Inconspicuous Box'),
(5998, 1, 6, 'Oh my.', 12, 0, 100, 0, 0, 0, 0, 41252, 0, 'Nethergarde Foreman - sees the Inconspicuous Box'),
(5998, 1, 7, 'Was that box there a second ago?', 12, 0, 100, 0, 0, 0, 0, 41185, 0, 'Nethergarde Foreman - sees the Inconspicuous Box'),
(41171, 1, 0, 'Hmm...', 12, 0, 100, 0, 0, 0, 0, 41188, 0, 'Reassuring Nethergarde Foreman - sees the Inconspicuous Box'),
(41171, 1, 1, 'Get back to work!  Oh wait... you''re just a box, never mind.', 12, 0, 100, 0, 0, 0, 0, 41253, 0, 'Reassuring Nethergarde Foreman - sees the Inconspicuous Box'),
(41171, 1, 2, 'What in tarnation?', 12, 0, 100, 0, 0, 0, 0, 41250, 0, 'Reassuring Nethergarde Foreman - sees the Inconspicuous Box'),
(41171, 1, 3, 'How peculiar.', 12, 0, 100, 0, 0, 0, 0, 41184, 0, 'Reassuring Nethergarde Foreman - sees the Inconspicuous Box'),
(41171, 1, 4, 'A box that walks?  I should ask Hondo about this... nah, maybe later.', 12, 0, 100, 0, 0, 0, 0, 41251, 0, 'Reassuring Nethergarde Foreman - sees the Inconspicuous Box'),
(41171, 1, 5, 'I do declare... a moving box.  The engineers have really done it this time!', 12, 0, 100, 0, 0, 0, 0, 41189, 0, 'Reassuring Nethergarde Foreman - sees the Inconspicuous Box'),
(41171, 1, 6, 'Oh my.', 12, 0, 100, 0, 0, 0, 0, 41252, 0, 'Reassuring Nethergarde Foreman - sees the Inconspicuous Box'),
(41171, 1, 7, 'Was that box there a second ago?', 12, 0, 100, 0, 0, 0, 0, 41185, 0, 'Reassuring Nethergarde Foreman - sees the Inconspicuous Box'),
(5997, 1, 0, 'Hey!  Somebody''s ambulatory cube is escaping!', 12, 0, 100, 0, 0, 0, 0, 41292, 0, 'Nethergarde Engineer - sees the Inconspicuous Box'),
(5997, 1, 1, 'Heavens to Betsy!', 12, 0, 100, 0, 0, 0, 0, 41291, 0, 'Nethergarde Engineer - sees the Inconspicuous Box'),
(5997, 1, 2, 'Looks like somebody''s getting a special delivery.', 12, 0, 100, 0, 0, 0, 0, 41295, 0, 'Nethergarde Engineer - sees the Inconspicuous Box'),
(5997, 1, 3, 'I think I''ve been down in this mine too long.', 12, 0, 100, 0, 0, 0, 0, 41293, 0, 'Nethergarde Engineer - sees the Inconspicuous Box'),
(5997, 1, 4, 'Look out!  It''s a box-demon!', 12, 0, 100, 0, 0, 0, 0, 41294, 0, 'Nethergarde Engineer - sees the Inconspicuous Box'),
(5997, 1, 5, 'Gadzooks!  Would ya look at that?', 12, 0, 100, 0, 0, 0, 0, 41290, 0, 'Nethergarde Engineer - sees the Inconspicuous Box'),
(41173, 0, 0, 'Is that box walking on its own?  Am I going mad?  Quick, someone check the canary!', 12, 0, 100, 0, 0, 0, 0, 41195, 0, 'Chief Prospector Hondo - sees the Inconspicuous Box');

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (5998, 41171, 5997, 41173);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND ((`entryorguid` = 5998 AND `id` = 3) OR (`entryorguid` = 41171 AND `id` = 2) OR (`entryorguid` = 5997 AND `id` = 5) OR (`entryorguid` = 41173 AND `id` IN (0, 1)));
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(5998, 0, 3, 0, 38, 0, 100, 0, 1, 1, 60000, 60000, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nethergarde Foreman - On Data Set 1 1 (sees the Inconspicuous Box) - Say Line 1'),
(41171, 0, 2, 0, 38, 0, 100, 0, 1, 1, 60000, 60000, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Reassuring Nethergarde Foreman - On Data Set 1 1 (sees the Inconspicuous Box) - Say Line 1'),
(5997, 0, 5, 0, 38, 0, 100, 0, 1, 1, 60000, 60000, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nethergarde Engineer - On Data Set 1 1 (sees the Inconspicuous Box) - Say Line 1'),
(41173, 0, 0, 0, 38, 0, 100, 0, 1, 1, 120000, 120000, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Chief Prospector Hondo - On Data Set 1 1 (sees the Inconspicuous Box) - Say Line 0'),
(41173, 0, 1, 0, 4, 0, 100, 1, 0, 0, 0, 0, 0, 11, 38557, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Chief Prospector Hondo - On Aggro - Cast ''Throw'' (No Repeat)');
