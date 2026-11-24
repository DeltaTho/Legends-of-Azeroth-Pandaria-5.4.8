-- Proving Pit: the Captive Spitescale Scout says one of its four lines when it comes out of the cage.
-- Sourced: warcraft.wiki.gg Captive Spitescale Scout "Quotes" (the four lines); broadcast_text 39089-39092 hold exactly them; mop
-- had 39089 alone, both TDBs 39091 alone. npc_captive_spitescale_scout already calls Talk(0), which picks one row of the group.
DELETE FROM `creature_text` WHERE `CreatureID` = 38142 AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(38142, 0, 0, 'I sshal ssslaughter you, Darksspear runt! ', 12, 0, 100, 0, 0, 0, 0, 39089, 0, 'Captive Spitescale Scout - leaves the cage'),
(38142, 0, 1, 'The Sssea Witch will kill you all.', 12, 0, 100, 0, 0, 0, 0, 39090, 0, 'Captive Spitescale Scout - leaves the cage'),
(38142, 0, 2, 'They sssend you to your death, youngling.', 12, 0, 100, 0, 0, 0, 0, 39091, 0, 'Captive Spitescale Scout - leaves the cage'),
(38142, 0, 3, 'I sshal tasste your blood, landling.', 12, 0, 100, 0, 0, 0, 0, 39092, 0, 'Captive Spitescale Scout - leaves the cage');
