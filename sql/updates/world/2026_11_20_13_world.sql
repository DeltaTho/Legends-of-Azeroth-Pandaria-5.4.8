-- Agmond's End: Dustwind Dig 27791 (Alliance) / Bloodwatcher Point 27881 (Horde) are offered only after Troggish Troubles 27789.
--
-- Both had PrevQuestID 0 and nothing pointed at them (27789 NextQuestID 0), so Blam offered them before the troggs were dealt
-- with. Sourced: Wowhead comments citing a blue and a GM (27789 2010-11-30 reply [+1], 27891 2011-02-02 [+7], 27794
-- 2010-12-07 [+6]); both TDBs have no link (Badlands ruling R2: enforced). Troggish Troubles is completable today.

UPDATE `quest_template_addon` SET `PrevQuestID` = 27789 WHERE `ID` IN (27791, 27881);
