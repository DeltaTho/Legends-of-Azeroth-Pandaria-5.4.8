-- Burning Steppes, Assault on Dreadmaul Rock 28320 (A) / 28454 (H): Fiery Breath's kills count for a grouped rider (fix round 1,
-- review F W1 / walk W1).
-- Ours: the script. The core's KillRewarder credits a group only within MaxGroupXPDistance (74 yd) of the victim, the killer
--   included, and the rider breathes from 100 yd up; spell_bs_aodr_fiery_breath gives him the Blackrock Invader 48432 credit for
--   each invader 90068 kills exactly when the core did not (grouped and out of that distance). Sourced: one breath counts every
--   invader it kills ("1 shot can kill upwards of 30 mobs", comment 2010-11-30 [+7]).

DELETE FROM `spell_script_names` WHERE `spell_id`=90068 AND `ScriptName`='spell_bs_aodr_fiery_breath';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(90068,'spell_bs_aodr_fiery_breath');
