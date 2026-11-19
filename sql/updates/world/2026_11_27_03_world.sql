-- Valley of Trials class trainers: quest markers that do not belong to them.
-- Karranisha (39214) also started Etched Parchment (3087), so a hunter saw "!" on her, took the parchment from her and handed it
-- straight back. Sourced: TDB 4.4.2 and Wowhead MoP Classic give 3087 to Gornek (3143) only. Karranisha stays its ender.
-- Zureetha (3145) still ended the warlock quest 1499 and Canaga (5887) the shaman quests 1516 and 1518 (Call of Earth): pre-Cataclysm
-- quests with no starter of any kind (creature, object, item, SmartAI, C++), so nobody can hold them; neither TDB has these enders.
DELETE FROM `creature_queststarter` WHERE `id` = 39214 AND `quest` = 3087;
DELETE FROM `creature_questender` WHERE (`id` = 3145 AND `quest` = 1499) OR (`id` = 5887 AND `quest` IN (1516, 1518));
