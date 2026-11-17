-- Burning Steppes, Unmask 89596 / Unmask Effect 89594 (I Am the Law and I Am the Lash 28278 / 28439, Abuse of Power 28279 / 28440):
-- a Blackrock troop that notices the disguise channels Unmask on the player; unless it dies, is interrupted or the player
-- right-clicks the buff within 8 s, the disguise comes off and the troops attack. The behaviour is the C++ AuraScript
-- spell_burning_steppes_unmask (zone_burning_steppes.cpp header comment: what the player sees, sourced and ours); 89594's eff1
-- SCRIPT_EFFECT gets a no-op handler (eff0 does the work: REMOVE_AURA 89261, and 2026_11_22_35 takes the race aura with it).
--
-- Blackrock Sergeant 48201 id 0 ("On Cudgel Hit - Cast Unmask", the first hit, wiki 28279) cast Unmask on himself (target_type 1):
-- the aura sat on the sergeant and nobody could be unmasked by one. Now on the invoker (7), the cudgeling player, as the soldier /
-- assassin / flamespeaker rows of section B. The casters' contract (with section B, 2026_11_22_12): caster = the troop, target = the
-- player who hit it (target_type 7) or its victim in combat (48119 / 48121 "on close", target_type 2: the script does nothing there
-- unless the target wears the disguise).

DELETE FROM `spell_script_names` WHERE `spell_id` IN (89596,89594);
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(89596,'spell_burning_steppes_unmask'),
(89594,'spell_burning_steppes_unmask_effect');

UPDATE `smart_scripts` SET `target_type`=7, `comment`='Blackrock Sergeant - On Cudgel Hit - Cast Unmask on the cudgeler' WHERE `entryorguid`=48201 AND `source_type`=0 AND `id`=0 AND `action_type`=11 AND `action_param1`=89596;
