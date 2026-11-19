-- Durotar, The Burning Blade 25232 (plan section 3, CP2; dossier C-razorhill 25232 claims 3a/3b, finding C-9 (b)).
-- At five stacks of Felblood 80174 the target (player or pet) loses the stacks and becomes a demon: 77647 Fel-Infused
-- (transform 41787 Metamorphosis, 5 % health every 3 s, +25 % critical strike, 60 s), immune to Felblood while it lasts.
-- SOURCED: Wowhead 2010-11-24 [+15], 2010-11-25 [+6], 2011-07-10 [+5] ("you lost all stacks of Felblood"; pets too, replies),
-- wiki The Burning Blade Notes ("along with immunity to Felblood"); 77647 from the DBC. Grep of both TDB dumps (4.4.2 and
-- 12.1.0): no row casts, links or scripts 77647, and 80174 appears only in the cultists' SmartAI casts (3195-3199): the
-- trigger was server-side. OURS: where the check runs (each new stack and Felblood's 3 s periodic dummy), stacks summed over
-- casters. The SmartAI that makes the cultists cast Felblood when they die is section 2's (S9), not this file's.
DELETE FROM `spell_script_names` WHERE `spell_id` = 80174 AND `ScriptName` IN ('spell_durotar_felblood_aura', 'spell_durotar_felblood');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(80174, 'spell_durotar_felblood_aura'),
(80174, 'spell_durotar_felblood');
