-- Swamp of Sorrows, the assault on Stonard: the Stonard Attack sky over the town while the assault is held.
--
-- Sourced: spell 87292 "Stonard Attack - Skybox" (5.4.8 DBC: FORCE_WEATHER and SCREEN_EFFECT 776, infinite) sits in the id
-- block of the battle's spells (Marked for Retrieval 87293 / 87296) and nothing references it.
-- Ours (plan question 4; no sniff or comment places it): where and when it applies. Stonard (area 75) while Assault on
-- Stonard, Cutting Supply or We're Under Attack! is in the log (status 10 = complete or incomplete). The rows carry no
-- aura_spell, so the aura stays while any of them fits (SpellInfo::CheckLocation) and goes on leaving Stonard, on the last
-- hand-in and on abandoning (Player::SendQuestUpdate refreshes area auras). Dropping this file removes the sky.

DELETE FROM `spell_area` WHERE `spell`=87292;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(87292,75,27849,0,0,0,2,1,10,0),
(87292,75,27851,0,0,0,2,1,10,0),
(87292,75,27857,0,0,0,2,1,10,0);
