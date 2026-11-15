-- Agmond's End: Into the Dragon's Mouth 27826 / New Kargath 27889 are offered only after Return to Blam 27794 / 27888.
--
-- SHIP ONLY IN THE SAME BATCH AS section E's E-1, E-2 and E-3 (the Warden's and Sentinel's Games and their flags): Return to
-- Blam sits behind both Games, Ancient Protectors and the Trove, which are not completable without those scripts.
--
-- Blam offered the purified egg from the first meeting on, before Troggish Troubles and the titans.
-- Sourced: wiki infoboxes (previous = Return to Blam); quest text (the egg comes from his titan device). Against both TDBs,
--   which have no link (Badlands ruling R2: enforced). Ours: the mechanism (PrevQuestID).

UPDATE `quest_template_addon` SET `PrevQuestID` = 27794 WHERE `ID` = 27826;
UPDATE `quest_template_addon` SET `PrevQuestID` = 27888 WHERE `ID` = 27889;
