-- Breaking the Chain (25167) is offered to every Horde player at Master Gadrin; Sen'jin Village (25073) is a breadcrumb that closes once
-- Breaking the Chain is taken; the orc and troll hand-overs to Sen'jin no longer exclude each other.
-- mop gave Sen'jin Village (25073, Vol'jin, Echo Isles) and Report to Sen'jin Village (25133, the Valley) NextQuestID 25167 and
-- ExclusiveGroup 25073. This core reads the NextQuestIDs as "Breaking the Chain requires one of them" (ObjectMgr
-- DependentPreviousQuests): a Horde player who reached Sen'jin any other way was never offered 25167, nor anything after it (Purge the
-- Valley, The War of Northwatch Aggression, Riding On, Razor Hill). The positive group made 25073 untakeable after 25133.
-- Sourced: both TDBs give 25167 no prerequisite, make 25073 BreadcrumbForQuestId 25167 and give 25073 and 25133 neither a
-- NextQuestID nor a group; Wowhead 25073 2014-08-26 [+7]: an orc did 25133, then the Echo Isles, then got 25073 from Vol'jin "as long
-- as I took nothing more from Gadrin".
-- Ours: the mechanism, as for the Northfold Manor and Stone Shards breadcrumbs (2026_11_25_02, 2026_11_25_60): NextQuestID 0 and
-- ExclusiveGroup 0 on both (they must change together: clearing only one leaves 25167 requiring the other and blocks every orc or
-- every troll), and a "Breaking the Chain never taken" condition (type 14, false once 25167 is in the log or rewarded) on 25073.
-- Player::GetQuestDialogStatus also reads QUEST_ACCEPT conditions for the quests an NPC ends (Player.cpp:17635), so the type-14 row
-- alone would hide Gadrin's "?" for a 25073 in the log once 25167 is taken (the hand-in itself still works: PrepareQuestMenu and
-- CanRewardQuest read no conditions). An OR branch (ElseGroup 1, type 47 on 25073 itself, mask 10 = incomplete or complete) holds
-- while 25073 is in the log, as section 2 does for 25227 and 25178. The branch cannot open the accept: CanTakeQuest refuses a quest
-- already in the log before conditions (SatisfyQuestStatus), and outside the log only ElseGroup 0 can hold. The three readers of
-- source 19 are Player.cpp:17253 (accept), 17635 (ender status) and 17668 (starter status). 25133 stays open as both TDBs (no
-- breadcrumb there). 25167 and 25073 are Horde-only, so the conditions are only ever evaluated for Horde players.
UPDATE `quest_template_addon` SET `NextQuestID` = 0, `ExclusiveGroup` = 0 WHERE `ID` IN (25073, 25133);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` = 25073 AND `SourceId` = 0 AND `ElseGroup` IN (0, 1);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 25073, 0, 0, 14, 0, 25167, 0, 0, 0, 0, 0, '', 'Sen''jin Village (breadcrumb) - only while Breaking the Chain has never been taken'),
(19, 0, 25073, 0, 1, 47, 0, 25073, 10, 0, 0, 0, 0, '', 'Sen''jin Village - or while it is in the log (keeps the ender''s ? after Breaking the Chain is taken)');
