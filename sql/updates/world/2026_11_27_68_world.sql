-- Durotar: Skull Rock (25262): the Searing Collar 4871 drops at 80 % (quest-required) from the Burning Blade, as both TDBs.
-- mop had 70 % on all five (Thug 3195, Neophyte 3196, Fanatic 3197, Apprentice 3198, Cultist 3199).
-- Sourced: TDB 4.4.2 and 12.1.0 creature_loot_template (-80 on the same five). Wowhead's 2010 comments ("100 % when on quest",
-- "medium-rare") are pre-Cataclysm; the both-TDB value is also the less grindy one of the two in this core.

UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -80 WHERE `item` = 4871 AND `entry` IN (3195, 3196, 3197, 3198, 3199);
