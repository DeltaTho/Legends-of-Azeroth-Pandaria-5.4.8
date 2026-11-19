-- Gato (63296), the Valley of Trials monk trainer, cannot be attacked, like every other trainer here (unit_flags 768) and as TDB 12.1.0
-- has him (IMMUNE_TO_PC | IMMUNE_TO_NPC). With 0 an Alliance player or a hostile NPC could fight him.
UPDATE `creature_template` SET `unit_flags` = 768 WHERE `entry` = 63296;
