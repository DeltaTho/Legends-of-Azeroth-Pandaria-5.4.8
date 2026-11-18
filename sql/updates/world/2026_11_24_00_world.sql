-- Blasted Lands A (_00): the entry quests are open to every player of level, both factions; each breadcrumb is offered only
-- while its entry quest is neither taken nor rewarded and no other breadcrumb of the same faction is in the log or rewarded.
-- (Plan section 2, ruling K1; dossiers S1 section 1 F-ENTRY, S2 section 1 F-CHAIN-1; gate report "The entry quests under one rule".)
--
-- Why: in this core a quest's NextQuestID makes the next quest REQUIRE it (ObjectMgr.cpp ~4948 pushes it into the next quest's
-- DependentPreviousQuests; Player::SatisfyQuestDependentPreviousQuests). Today Futile Pride 25674 needs 28553 / 28671 / 28858
-- rewarded, A Closer Look 25715 needs 27919 (also its PrevQuestID), Minor Distractions 25710 needs 28673 or 28857: a player who
-- flies or walks in, or comes by the Silithus portal, cannot start the zone (Okrilla's own breadcrumb rows were the Horde's way in).
--
-- SOURCED: the breadcrumbs are optional and "one at a time": wiki Template_Nethergarde_Keep_quest_chain ("optional
-- breadcrumbs"); 27919 2011-09-08 reply [+1] "No questlines needed ... All introductory quests are stand alone", 2012-02-29 [+3]
-- "unavailable if you've completed 25715", 2014-04-29 [+3] (did 28673 and 27919 both); 28867 2010-12-06 replies [+10], [+3];
-- 28865 2010-11-29 reply [+10] "dropped my other quest, and got this one", 2011-08-08 [+7] (did 28865 and 28553 one after the
-- other); 28671 2012-09-04 [+2] "unavailable as soon as you start any chain in the zone". Okrilla starts none of the breadcrumbs
-- (Wowhead npc 41124 "starts" tab: 25674, 25676, 25683 only; neither TDB has her rows).
-- OURS (user question, ruling K1 OPEN): no breadcrumb is required. The only source on the Horde side (Okrilla comment 2012-02-25
-- [+5], both TDBs' NextQuestID 25674) says Futile Pride needed one; the alternative below keeps that gate.
-- OURS: the mechanism (type-19 QUESTSTATE conditions instead of the TDBs' positive ExclusiveGroups, which here also forbid a
-- second breadcrumb after the first is rewarded, C25). Masks (ConditionMgr.cpp 517-531): 1 = none (neither in the log nor
-- rewarded), 74 = in the log (incomplete or complete; the breadcrumbs are complete on accept) or rewarded. Siblings use 74
-- (orchestrator's correction of K1, 2026-11-18; the TDBs' one-of groups and 28857 2014-08-24 [+5], 28867 reply [+3] "if you
-- have completed the Hero's Call quest ... no longer available"): once one breadcrumb is in the log or handed in, the others
-- are not offered. Nobody is locked out: the entry quests themselves are open to all. This drops the "did both" reading of
-- 27919 2014-04-29 [+3] and 28865 2011-08-08 [+7] (OURS: one rule for the zone).
-- Type 19 also hides the giver's "!" (Player::GetQuestDialogStatus checks it), so no type-20 rows (source 20 is unused here, C16).
-- A breadcrumb still in the log when its entry quest is taken keeps its hand-in: questender menus and the reward path check no
-- conditions (Player::PrepareQuestMenu, CanRewardQuest); only its "?" goes (C16: test-sheet note).
-- Not touched: 28553's own dependency on 27916 (zone 8, Swamp pass); Ruag 7623 / 28553 starter (zone 8); RewardNextQuest of
-- every breadcrumb (the entry quest is still offered at the hand-in). All conditions name quests of the player's own faction.
--
-- ALTERNATIVE (S1 option A, sourced for the Horde only, NOT applied): keep Futile Pride gated on a breadcrumb. To switch, skip
-- the Horde UPDATE below and run instead:
--   INSERT INTO `quest_template_addon` (`ID`, `NextQuestID`) VALUES (28865, 25674) ON DUPLICATE KEY UPDATE `NextQuestID` = 25674;
--   (28553 / 28671 / 28858 keep NextQuestID 25674; every other row of this file stays as it is.)

-- Horde: 25674 Futile Pride needs no breadcrumb.
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28553, 28671, 28858) AND `NextQuestID` = 25674;
-- Okrilla hands out no breadcrumbs (neither TDB, nor Wowhead).
DELETE FROM `creature_queststarter` WHERE (`id`, `quest`) IN ((41124, 28553), (41124, 28858), (41124, 28865));

-- Alliance: 25715 A Closer Look and 25710 Minor Distractions need no breadcrumb.
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25715 AND `PrevQuestID` = 27919;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` = 27919 AND `NextQuestID` = 25715;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28673, 28857) AND `NextQuestID` = 25710;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `ConditionTypeOrReference` = 47
  AND `SourceEntry` IN (28553, 28671, 28858, 28865, 27919, 28673, 28857, 28867);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
-- Horde: entry quest 25674 Futile Pride
(19, 0, 28553, 0, 0, 47, 0, 25674,  1, 0, 0, 0, 0, '', 'Okrilla and the Blasted Lands - only while Futile Pride is neither in the log nor rewarded'),
(19, 0, 28553, 0, 0, 47, 0, 28671, 74, 0, 1, 0, 0, '', 'Okrilla and the Blasted Lands - not while Warchief''s Command: Blasted Lands! is in the log or rewarded'),
(19, 0, 28553, 0, 0, 47, 0, 28858, 74, 0, 1, 0, 0, '', 'Okrilla and the Blasted Lands - not while Blasted Lands: The Other Side of the World (H) is in the log or rewarded'),
(19, 0, 28553, 0, 0, 47, 0, 28865, 74, 0, 1, 0, 0, '', 'Okrilla and the Blasted Lands - not while Call of the Warmatron is in the log or rewarded'),
(19, 0, 28671, 0, 0, 47, 0, 25674,  1, 0, 0, 0, 0, '', 'Warchief''s Command: Blasted Lands! - only while Futile Pride is neither in the log nor rewarded'),
(19, 0, 28671, 0, 0, 47, 0, 28553, 74, 0, 1, 0, 0, '', 'Warchief''s Command: Blasted Lands! - not while Okrilla and the Blasted Lands is in the log or rewarded'),
(19, 0, 28671, 0, 0, 47, 0, 28858, 74, 0, 1, 0, 0, '', 'Warchief''s Command: Blasted Lands! - not while Blasted Lands: The Other Side of the World (H) is in the log or rewarded'),
(19, 0, 28671, 0, 0, 47, 0, 28865, 74, 0, 1, 0, 0, '', 'Warchief''s Command: Blasted Lands! - not while Call of the Warmatron is in the log or rewarded'),
(19, 0, 28858, 0, 0, 47, 0, 25674,  1, 0, 0, 0, 0, '', 'Blasted Lands: The Other Side of the World (H) - only while Futile Pride is neither in the log nor rewarded'),
(19, 0, 28858, 0, 0, 47, 0, 28553, 74, 0, 1, 0, 0, '', 'Blasted Lands: The Other Side of the World (H) - not while Okrilla and the Blasted Lands is in the log or rewarded'),
(19, 0, 28858, 0, 0, 47, 0, 28671, 74, 0, 1, 0, 0, '', 'Blasted Lands: The Other Side of the World (H) - not while Warchief''s Command: Blasted Lands! is in the log or rewarded'),
(19, 0, 28858, 0, 0, 47, 0, 28865, 74, 0, 1, 0, 0, '', 'Blasted Lands: The Other Side of the World (H) - not while Call of the Warmatron is in the log or rewarded'),
(19, 0, 28865, 0, 0, 47, 0, 25674,  1, 0, 0, 0, 0, '', 'Call of the Warmatron - only while Futile Pride is neither in the log nor rewarded'),
(19, 0, 28865, 0, 0, 47, 0, 28553, 74, 0, 1, 0, 0, '', 'Call of the Warmatron - not while Okrilla and the Blasted Lands is in the log or rewarded'),
(19, 0, 28865, 0, 0, 47, 0, 28671, 74, 0, 1, 0, 0, '', 'Call of the Warmatron - not while Warchief''s Command: Blasted Lands! is in the log or rewarded'),
(19, 0, 28865, 0, 0, 47, 0, 28858, 74, 0, 1, 0, 0, '', 'Call of the Warmatron - not while Blasted Lands: The Other Side of the World (H) is in the log or rewarded'),
-- Alliance: 27919 leads to 25715 A Closer Look (Enohar); 28673 / 28857 / 28867 lead to 25710 Minor Distractions (Lungertz)
(19, 0, 27919, 0, 0, 47, 0, 25715,  1, 0, 0, 0, 0, '', 'Onward to the Blasted Lands - only while A Closer Look is neither in the log nor rewarded'),
(19, 0, 27919, 0, 0, 47, 0, 28673, 74, 0, 1, 0, 0, '', 'Onward to the Blasted Lands - not while Hero''s Call: Blasted Lands! is in the log or rewarded'),
(19, 0, 27919, 0, 0, 47, 0, 28857, 74, 0, 1, 0, 0, '', 'Onward to the Blasted Lands - not while Blasted Lands: The Other Side of the World (A) is in the log or rewarded'),
(19, 0, 27919, 0, 0, 47, 0, 28867, 74, 0, 1, 0, 0, '', 'Onward to the Blasted Lands - not while Nethergarde Needs You! is in the log or rewarded'),
(19, 0, 28673, 0, 0, 47, 0, 25710,  1, 0, 0, 0, 0, '', 'Hero''s Call: Blasted Lands! - only while Minor Distractions is neither in the log nor rewarded'),
(19, 0, 28673, 0, 0, 47, 0, 27919, 74, 0, 1, 0, 0, '', 'Hero''s Call: Blasted Lands! - not while Onward to the Blasted Lands is in the log or rewarded'),
(19, 0, 28673, 0, 0, 47, 0, 28857, 74, 0, 1, 0, 0, '', 'Hero''s Call: Blasted Lands! - not while Blasted Lands: The Other Side of the World (A) is in the log or rewarded'),
(19, 0, 28673, 0, 0, 47, 0, 28867, 74, 0, 1, 0, 0, '', 'Hero''s Call: Blasted Lands! - not while Nethergarde Needs You! is in the log or rewarded'),
(19, 0, 28857, 0, 0, 47, 0, 25710,  1, 0, 0, 0, 0, '', 'Blasted Lands: The Other Side of the World (A) - only while Minor Distractions is neither in the log nor rewarded'),
(19, 0, 28857, 0, 0, 47, 0, 27919, 74, 0, 1, 0, 0, '', 'Blasted Lands: The Other Side of the World (A) - not while Onward to the Blasted Lands is in the log or rewarded'),
(19, 0, 28857, 0, 0, 47, 0, 28673, 74, 0, 1, 0, 0, '', 'Blasted Lands: The Other Side of the World (A) - not while Hero''s Call: Blasted Lands! is in the log or rewarded'),
(19, 0, 28857, 0, 0, 47, 0, 28867, 74, 0, 1, 0, 0, '', 'Blasted Lands: The Other Side of the World (A) - not while Nethergarde Needs You! is in the log or rewarded'),
(19, 0, 28867, 0, 0, 47, 0, 25710,  1, 0, 0, 0, 0, '', 'Nethergarde Needs You! - only while Minor Distractions is neither in the log nor rewarded'),
(19, 0, 28867, 0, 0, 47, 0, 27919, 74, 0, 1, 0, 0, '', 'Nethergarde Needs You! - not while Onward to the Blasted Lands is in the log or rewarded'),
(19, 0, 28867, 0, 0, 47, 0, 28673, 74, 0, 1, 0, 0, '', 'Nethergarde Needs You! - not while Hero''s Call: Blasted Lands! is in the log or rewarded'),
(19, 0, 28867, 0, 0, 47, 0, 28857, 74, 0, 1, 0, 0, '', 'Nethergarde Needs You! - not while Blasted Lands: The Other Side of the World (A) is in the log or rewarded');
