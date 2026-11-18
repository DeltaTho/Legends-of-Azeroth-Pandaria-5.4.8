-- Blasted Lands: Oath-Chained Infernal 41253's Fel Streak 84392 charges and explodes (The Vile Blood of Demons 25692 / 26165).
-- Sourced: comment 25692 2011-03-19 [+4] ("roll into a ball, roll at you and explode"); the spells 84392 (SCRIPT_EFFECT naming
-- 84391 + a 4 s ball transform), 84391 (JUMP_DEST + missile 84390), 84390 (fire damage, 15 yd). Only 41253 casts 84392 (its
-- on-aggro SmartAI row). Script: spell_blasted_lands_fel_streak (zone_blasted_lands_bloodstone.cpp). Ours: nothing.
DELETE FROM `spell_script_names` WHERE `spell_id` = 84392 AND `ScriptName` = 'spell_blasted_lands_fel_streak';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (84392,'spell_blasted_lands_fel_streak');
