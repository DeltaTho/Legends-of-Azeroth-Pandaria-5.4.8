-- Northern Barrens S1 (_00): the Mor'shan Rampart chain - givers, order, reward display, progress texts, one map area.
-- (plan.md section 1 `_00`; dossier A: A-28876-1, A-13866-1, A-13866-2, A-CHAIN-1, A-13620-1, A-TEXT-1, A-13612-2.)
--
-- SOURCED: Kulg 34195 is the only starter of 13866 (both TDBs); 13866 closes once 13612 is taken (Wowhead 2011-09-18 [+17]
-- and reply [+8]); 28876 was removed in 4.1 (comments 2011-06-02, 2012-03-24 [+6]; the MoP Classic page has no starter);
-- 13621 follows 13620 (comment 2011-06-03 [+5]; text "Dinah ... Gorat's blood"), 13628 follows 13621 (comments 2012-07-07 [+35], 2011-02-11 [+7]; neither TDB); the five
-- progress texts are the TDBs' quest_request_items (13621 in 4.4.2 only, the rest in both); map area idx 2 of 13612 is the bowmen's (TDB 4.4.2 blob 2 = 33195).
-- OURS: retiring 28876 rather than keeping it as a breadcrumb (questions.md Q18 default; the alternative is
-- `BreadcrumbForQuestId`=13612 on an addon row for 28876, never NextQuestID); 62858 moved to RewardDisplaySpell (a DUMMY
-- helper this core would show as a reward spell; lessons EPL 2026-11-14).
-- Note: 13628 stays click-completable until the S3 ride lands (same deploy).

-- A-13866-1: Kadrak does not start "To The Ramparts!" (a breadcrumb to himself).
DELETE FROM `creature_queststarter` WHERE `id`=8582 AND `quest`=13866;
-- A-13866-2: "To The Ramparts!" is a breadcrumb for Mor'shan Defense.
UPDATE `quest_template_addon` SET `BreadcrumbForQuestId`=13612 WHERE `ID`=13866;

-- A-28876-1: Thork no longer offers "To the Mor'shan Rampart" (Q18 default: retire).
DELETE FROM `creature_queststarter` WHERE `id`=3429 AND `quest`=28876;

-- A-CHAIN-1: Gorat's Vengeance after To Dinah, at Once!; Got Wood? after Gorat's Vengeance.
UPDATE `quest_template_addon` SET `PrevQuestID`=13620 WHERE `ID`=13621;
UPDATE `quest_template_addon` SET `PrevQuestID`=13621 WHERE `ID`=13628;

-- A-13620-1: the "Dinah Dummy Spell" is shown, not given.
UPDATE `quest_template` SET `RewardDisplaySpell`=62858, `RewardSpell`=0 WHERE `ID`=13620 AND `RewardSpell` IN (0,62858);

-- A-13612-2: map area idx 2 belongs to the Ashenvale Bowmen objective (index 1).
UPDATE `quest_poi` SET `ObjectiveIndex`=1, `QuestObjectiveId`=264164 WHERE `QuestID`=13612 AND `Idx1`=2;

-- A-TEXT-1: progress texts both TDBs have and mop lacks.
DELETE FROM `quest_request_items` WHERE `ID` IN (13612,13613,13621,13628,13712);
INSERT INTO `quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`CompletionText`,`VerifiedBuild`) VALUES
(13612,0,0,'Was your hunt successful, $r?',0),
(13613,0,0,'Have you administered the salve to our fallen warriors, $r?',0),
(13621,0,0,'What have you learned, $r?',0),
(13628,0,0,'Quite an entrance, $r. What can I do for you?',0),
(13712,0,0,'Work complete!',0);
