-- Searing Gorge A-26 (coder B's lead): quests whose giver is hidden by design are not "available" before the giver shows.
--
-- Source type 19 is CONDITION_SOURCE_TYPE_QUEST_ACCEPT, read by Player::SatisfyQuestConditions (Player.cpp 17251) from CanTakeQuest,
-- which also decides the available marker. OURS: 27984 only once 27979 is taken (incomplete 9, complete 28) or rewarded (8), the
-- window in which Zamael is visible (88474); 28053 only once 27959 is rewarded (Lunk Like Your Style, giver Lunk 47429 window 88582).
-- ElseGroups are OR'd in this core (ConditionMgr.cpp); 27984 uses one QUESTSTATE (47) row, mask 74 = complete 2 | incomplete 8 | rewarded 64.
-- Side effect: these also gate the ender's marker, so abandoning 27979 after taking 27984 hides Zamael's '?' until 27979 is retaken.
-- SHIP ORDER (R-15, coder B's lead): only in the same build as section E's 28062 AUTO_COMPLETE (E-10) and E-11, never before it.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceGroup`=0 AND `SourceEntry` IN (27984,28053);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,27984,0,0,47,0,27979,74,0,0,0,0,'','Dark Ministry follow-up 27984 - 27979 taken, complete or rewarded'),
(19,0,28053,0,0,8,0,27959,0,0,0,0,0,'','Lunk Like Your Style 28053 - only after 27959 rewarded');
