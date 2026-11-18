-- Blasted Lands: Loramus Thalipedes 7783 in the two caves (Dreadmaul Furnace, area 5086, Horde; the Serpent's Coil, area 1440,
-- Alliance) is seen from The Altar of Storms (25688 / 26162) complete until You Are Rakh'likh, Demon (25701 / 26171) is accepted,
-- again after abandoning it, never after it is handed in (ruling K2, a user question).
-- He wears 80698 Apply Quest Invis Zone 1 (template addon); 80695 Detect: Quest Invis Zone 1 (same strength) lets a player see him.
-- Sourced: the story (he is dead and in three pieces until the Altar of Storms: comment Schnoodledorfer [+43], wiki 25698; after it
-- "Meet up with me back in the cave, heroes.", broadcast 41283), one player who "had not seen him in the cave at all until I
-- completed it" (25687, 2010-12-08 [+3]), and his "!" back after an abandon (634319 [+5]).
-- Against (why this is a question): three early-Cataclysm comments saw him beside the givers throughout the chain and took it for a
-- bug (26161 Angaurwen [+10] and replies, Blog [+3]), and neither TDB carries his invisibility or a detection row.
-- Ours: the window itself. quest_start_status 66 = complete or rewarded; quest_end_status 1 = the finale not taken (in this core
-- quest_end_status is a required mask: SpellMgr.cpp SpellArea::IsFitToRequirements).
--
-- The alternative (Loramus visible to his own faction all the time, as before) is this swap:
--   DELETE FROM `spell_area` WHERE `spell`=80695 AND `area` IN (5086,1440);
--   INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
--   (80695,5086,0,0,0,33555378,2,1,64,11),
--   (80695,1440,0,0,0,18875469,2,1,64,11);

DELETE FROM `spell_area` WHERE `spell`=80695 AND `area` IN (5086,1440);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,
 `quest_start_status`,`quest_end_status`) VALUES
(80695,5086,25688,25701,0,33555378,2,1,66,1),
(80695,1440,26162,26171,0,18875469,2,1,66,1);

-- The Serpent's Coil copy had no zone or area stored (both are filled in at runtime; this is only bookkeeping)
UPDATE `creature` SET `zoneId`=4, `areaId`=1440 WHERE `guid`=401001 AND `id`=7783;
