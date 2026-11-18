-- Blasted Lands, The First Step (25685 / 26159): Snickerfang Hyena Blood and Redstone Basilisk Blood drop every time for a player
-- on the quest.
-- Sourced: comment 25685 2012-04-01 [+4] with a confirming reply, and the same on 26159 with the reply "they don't drop for
-- people not on the quest": 100 % for quest holders; Wowhead's 65-70 % counts kills by players without the quest. mop had
-- 72.8 % / 68.4 % (TDB 69 / 64), grindier than sourced. Also the less grindy value at section F's thinner spawns (28 each).
-- Ours: nothing.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100 WHERE (`entry` = 5985 AND `item` = 55826) OR (`entry` = 5990 AND `item` = 55827);
