-- Searing Gorge, C-11: RewardSpell 81040 on 27965, 28028, 28029, 28030, 28061, 28062, 28099.
-- 81040 is a server-only spell_dbc row ("deleted spell for some quests") that the 5.4.8 Spell.dbc lacks; the core sends RewardSpell
-- to the client as the reward to show. Moved to RewardDisplaySpell with RewardSpell 0, which Player::RewardQuest still casts (as the
-- Badlands commit 2d99858b0). R-3: this file is the single owner of 81040 in the zone. Sourced rule.
-- Idempotent: absolute UPDATE.

UPDATE `quest_template` SET `RewardSpell`=0, `RewardDisplaySpell`=81040 WHERE `ID` IN (27965,28028,28029,28030,28061,28062,28099) AND `RewardSpell`=81040;
