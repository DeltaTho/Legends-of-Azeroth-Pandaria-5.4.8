-- Badlands: Nyxondra is invisible until you accept Lifting the Veil, appears when Rhea "removes the fog from your eyes", and is
-- gone again once Third Sample: Implanted Eggs is handed in. While hidden she cannot see, and so cannot pull, players walking
-- past her to Rhea's camp (an invisible creature sees only units that detect it, Object.cpp:2474-2476).
--
-- Sourced: wiki 27770 notes ("I will now remove the fog from your eyes ... To the south, Nyxondra appears beneath a glowing
--   red bubble!"); neither TDB has a spawn or addon row for 46658 (only her Flame Breath script), which is how a
--   quest-invisible NPC looks in a sniff; the DBC's otherwise unused "See Quest Invis 11" 87007 (type 19, amount 1000,
--   AreaGroup Lethlor Ravine 339 + Rhea's Camp 5519) next to Rhea's 87006, and the matching Generic Quest Invisibility 11
--   (83305, type 19, amount 100).
-- Ours: the aura on her one spawn 312984 (no source has her aura list), the bounds (27770 taken/complete/rewarded and 27771
--   not yet rewarded) and the 339 row (she is seen from the ravine too; she stands 45-60 yd from its edge).
-- After Rhea Revealed's credit the phasemask-2 window (59073) hides her anyway. Her eggs stay as they are. The credit for
-- Lifting the Veil and her submission script are other commits.

DELETE FROM `creature_addon` WHERE `guid` = 312984;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(312984, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '83305');

DELETE FROM `spell_area` WHERE `spell` = 87007;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(87007, 5519, 27770, 27771, 0, 0, 2, 1, 74, 11),
(87007,  339, 27770, 27771, 0, 0, 2, 1, 74, 11);
