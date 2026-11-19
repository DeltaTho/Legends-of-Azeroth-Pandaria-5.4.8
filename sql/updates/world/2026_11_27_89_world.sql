-- Durotar wildlife: two template fields as both TDBs.
--
-- 1) 3123 Bloodtalon Scythemaw (23 spawns, all in zone 14) had UNIT_FLAG_STUNNED (0x40000; unit_flags 262144) in its
--    template. Spell::CheckCasterAuras refuses spells from a caster with that flag (Spell.cpp:7257),
--    so its SmartAI Rushing Charge (6268, on aggro) and Rend (13443) never landed, and the client showed it stunned.
--    Sourced, both TDBs: unit_flags 0.
-- 2) 3099 Dire Mottled Boar (157 spawns, all in zone 14): faction 7 -> 189, as both TDBs and every other Durotar boar.
--    Both templates belong to faction 7 (neutral to both player factions); nothing visible changes.

UPDATE `creature_template` SET `unit_flags` = 0 WHERE `entry` = 3123;
UPDATE `creature_template` SET `faction` = 189 WHERE `entry` = 3099;
