-- Northwatch Supply Crate (39251, Breaking the Chain): drop the copied Squirrel Scrubber spellclick and the golem accessory.
-- The crate carried npc_spellclick_spells 90102 Squirrel Scrubber Vehicle Aura (a 3 s stun under vehicle bar 1328 on the clicker; both
-- TDBs have 90102 only on 48457 Tainted Squirrel) and vehicle_template_accessory 39245 "Dark Iron Golem" (never used: 39251 has no
-- VehicleId). Both TDBs: npcflag 0 and no accessory. The crate keeps the AI it has today: with SPELLCLICK it fell to NullCreatureAI
-- (CreatureAISelector); without the flag it would get ReactorAI and hit back, so NullCreatureAI is now named (ours). It still dies to
-- attacks and counts for the quest by entry.
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 39251 AND `spell_id` = 90102;
DELETE FROM `vehicle_template_accessory` WHERE `entry` = 39251 AND `accessory_entry` = 39245;
UPDATE `creature_template` SET `npcflag` = 0, `AIName` = 'NullCreatureAI' WHERE `entry` = 39251;
