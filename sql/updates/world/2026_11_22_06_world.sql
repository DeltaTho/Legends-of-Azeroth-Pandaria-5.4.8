-- Burning Steppes A (_06): Ember Worg Hide drop, the standing War Reaver Parts, the Chiseled Golem's missing line (plan A-17, A-30,
-- A-31).
--
-- * A Future Project 28178 / 28420: Ember Worg Hide 63136 from Ember Worg 9690 at 100 %. Sources disagree (Wowhead 85 %, comment
--   2012-10-06 "seems to be a 100% drop"): the less grindy value (the user's rule). Giant Ember Worg 9697 (1.6 %) unchanged.
-- * Scrapped Golems 28226: War Reaver Parts 206971-206974 are summoned where a War Reaver dies (89413-89418 from
--   npc_burning_steppes_war_reaver, 120 s). Neither TDB spawns any; mop had eight static sniff copies (300 s respawn) that gave a free
--   part each. SOURCED: both TDBs. No addon, pool or event rows on these guids.
-- * Golem Training 28227: "Defeated.  Shame level: High.  Adjusting strategy for future battles." (wiki, comment 2010-12-18 [+15];
--   broadcast_text 48289) was in no text group. OURS: it joins group 0 beside 48288, the line of the first defeat.
-- Idempotent: absolute UPDATE, DELETE (+ INSERT).

UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100 WHERE `entry` = 9690 AND `item` = 63136;

DELETE FROM `gameobject_addon` WHERE `guid` IN (156249, 156251, 156283, 156285, 156286, 156287, 156288, 156289);
DELETE FROM `gameobject` WHERE `guid` IN (156249, 156251, 156283, 156285, 156286, 156287, 156288, 156289) AND `id` BETWEEN 206971 AND 206974;

DELETE FROM `creature_text` WHERE `CreatureID` = 48037 AND `GroupID` = 0 AND `ID` = 1;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(48037, 0, 1, 'Defeated.  Shame level: High.  Adjusting strategy for future battles.', 12, 0, 100, 0, 0, 0, 0, 48289, 0, 'Chiseled Golem - first defeat');
