-- Dragon's Mouth / New Kargath: Rhea is a fallback starter of The Wrath of a Dragonflight 27829 / 27894.
--
-- A player who abandoned the quest, or lost the companions who normally offer it, could not get it back.
-- Sourced: Wowhead comment 2011-01-21 [+4] (Rhea offered it); Badlands ruling R1. She offers it only once all three training
--   quests are rewarded (ExclusiveGroup -27828 / -27891 with NextQuestID 27829 / 27894), and only her Dragon's Mouth / New
--   Kargath copy (section B) is visible while it can be taken (until The Hidden Clutch 27832 / 27897 is accepted). The rows are
--   on the entry, so every copy of Rhea carries them.

DELETE FROM `creature_queststarter` WHERE `id` = 46654 AND `quest` IN (27829, 27894);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES
(46654, 27829),
(46654, 27894);
