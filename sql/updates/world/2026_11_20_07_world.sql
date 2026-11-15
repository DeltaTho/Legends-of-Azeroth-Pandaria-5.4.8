-- Badlands: the helper spells of five quests are displayed, not offered as rewards.
--
-- This core sends RewardSpell to the client as the reward to show; RewardDisplaySpell is cast when RewardSpell is 0
-- (Player::RewardQuest), so the effects stay: 81040 (a deleted serverside spell "for some quests") on Rheastrasza's Gift
-- 27858 / 27898 and Devastation 27930, and Return to Blam: Summon Eye 87203 on Return to Blam 27794 / 27888, which the Return
-- to Blam scene (section E) relies on.
-- Sourced: TDB 12.1.0 (RewardDisplaySpell 81040 / 87203, RewardSpell 0); lessons.md (Eastern Plaguelands, 2026-11-14).

UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 81040 WHERE `ID` IN (27858, 27898, 27930);
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 87203 WHERE `ID` IN (27794, 27888);
