-- Badlands: a viking helmet on the player while the Lost Vikings are with him (Viking Helmet 87391, cast by Eric on his owner;
-- the Bad Dogs' twin Ex-KEF: Active Aura 87592 from Amakkar, no helmet described), without the spell data's cut of the player's
-- kill XP.
--
-- Sourced: the helmet (wiki notes and screenshot of 27828 / 27834 / 27835).
-- Ours: the XP cut (effect 1, MOD_XP_PCT -50) is kept at 0: no source mentions halved XP (questions.md 1, default "helmet only").
-- Who casts it and when (the leader, on summon and after each evade): zone_badlands_companions.cpp.

DELETE FROM `spell_script_names` WHERE `spell_id` IN (87391, 87592);
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(87391,'spell_badlands_companion_active_aura'),
(87592,'spell_badlands_companion_active_aura');
