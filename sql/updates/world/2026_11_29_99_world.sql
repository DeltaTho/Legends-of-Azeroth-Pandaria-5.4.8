-- Northern Barrens, Read the Manual (14006): Samophlange Manual Page 11148 dropped at 10% (quest-only) from Venture Co.
-- Enforcer 3283 and Overseer 3286, the TDB value. Wowhead MoP Classic counts it in 11,098 of 56,108 Enforcer kills (19.8%)
-- and 7,144 of 45,776 Overseer kills (15.6%), over all kills, players without the quest included, so a quester's rate is at
-- least that (play test 2026-11-25: "ridiculously low"). Ours: 20% and 16%, count 1-2 kept.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-20 WHERE `entry`=3283 AND `item`=11148;
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-16 WHERE `entry`=3286 AND `item`=11148;
