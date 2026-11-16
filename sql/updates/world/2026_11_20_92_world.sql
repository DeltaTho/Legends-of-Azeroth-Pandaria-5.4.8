-- Badlands, The Morons' League 27877: Dark Iron Head 62650 drops on every kill from the four Shadowforge dwarves.
--
-- The head (15 needed) was a quest-only drop at -56.1702 % from Shadowforge Warrior 2743, -45.1826 % from Chanter 2742,
-- -26.2125 % from Tunneler 2739 and -25.7104 % from Darkweaver 2740. Now -100 on all four: still quest-only (a negative chance
-- is "only while a player on the quest still needs it" in this core), and one head per kill (group 0, min/max count 1/1, as before).
-- The creatures' lootid equals their entry; no other loot table (creature, reference, gameobject, item, ...) holds item 62650.
-- Why: the true retail rate is not known. Wowhead's 5.5-9.3 % is counted over all kills of these old-world mobs, and the old
-- values were scraped ratios that differ per mob. Where a rate is not certain the less grindy value is used.
-- Sourced: nothing (the retail rate is unknown). Ours: the 100 %.

UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100 WHERE `item` = 62650 AND `entry` IN (2739, 2740, 2742, 2743);
