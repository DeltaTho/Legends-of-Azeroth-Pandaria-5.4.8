-- Sarkoth (3281) can be skinned for a skill-up, without yielding leather.
-- Sourced: Wowhead 3281 2013-09-08 [+5] "This mob can be skinned for a skill-up, but will not yield any leather"; TDB 12.1.0 flags him
-- SKINNABLE (TDB 4.4.2 and mop did not).
-- Ours, the mechanism: this core never takes SKINNABLE from the template for long (Unit::setDeathState clears it at every respawn)
-- and sets it at death only when the creature's skinning loot has rows (LootTemplates_Skinning.HaveLootFor). So Sarkoth gets a skinning
-- loot entry of his own whose only row is Ruined Leather Scraps at 0.0001 %: he becomes skinnable once looted, skinning gives the
-- skill-up (Spell::EffectSkinning) and the loot window is, in effect, always empty.
DELETE FROM `skinning_loot_template` WHERE `entry` = 3281;
INSERT INTO `skinning_loot_template` (`entry`, `item`, `ChanceOrQuestChance`, `lootmode`, `groupid`, `mincountOrRef`, `maxcount`) VALUES
(3281, 2934, 0.0001, 1, 0, 1, 1);
UPDATE `creature_template` SET `skinloot` = 3281 WHERE `entry` = 3281;
