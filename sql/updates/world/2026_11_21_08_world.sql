-- Searing Gorge A-19: Dark Iron residue turn-ins 7737 / 13662 after Welcome to the Brotherhood 28064.
--
-- SOURCED: Wowhead 7737 2010-12-05 / 2010-12-09 / 2010-11-27, 13662 2011-08-11 / 2012-04-28; wiki infobox (previous = Welcome to the
-- Brotherhood). Both TDBs have the retired 7722 as PrevQuestID, so they are not the source.
-- SHIP ORDER (R-15, coder B's lead): only in the same build as section E's 28062 AUTO_COMPLETE (E-10) and E-11, never before it.
-- Without E-10 28064 cannot be reached and the Burninate turn-ins are closed.
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

-- TP-10 (F15, R-15) residue turn-ins after 28064; ship in the same build as cauldron F16, never before
UPDATE `quest_template_addon` SET `PrevQuestID`=28064 WHERE `ID` IN (7737,13662);
