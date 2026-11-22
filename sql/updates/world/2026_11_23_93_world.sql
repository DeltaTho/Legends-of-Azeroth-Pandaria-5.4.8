-- Swamp of Sorrows: the dead Bogpaddle Privateers at the Marshfin murloc camp stay dead.
-- 14 spawns of 45887 carry Permanent Feign Death 70628 (spawn addon) but were ordinary units: the Marshfin Murkdwellers
-- (faction 18) attacked them and the "corpses" fought back and slid around (play test 2026-11-22). Make them inert like
-- the Badlands corpses: template flags 32768 plus IMMUNE_TO_PC | IMMUNE_TO_NPC (a spawn's unit_flags replaces the
-- template's). The living privateers of 45887 (no feign aura) keep their flags.
UPDATE `creature` c
JOIN `creature_addon` a ON a.`guid` = c.`guid`
SET c.`unit_flags` = 32768 | 256 | 512
WHERE c.`id` = 45887 AND a.`auras` = '70628';
