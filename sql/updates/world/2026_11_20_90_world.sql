-- Dustwind Dig / Bloodwatcher Point: the Pawn quests follow the camp's archaeology quest.
--
-- The Warden's Pawn 27796 / The Sentinel's Pawn 27797 (Alliance, Lead Prospector Durdin 46760) and 27883 / 27884 (Horde,
-- Bloodwatcher 46757) had PrevQuestID 0, so on the first visit to the camp they opened the Tomb chain and, through Return to
-- Blam and Into the Dragon's Mouth / New Kargath, everything after it, without Troggish Troubles or Rhea's camp.
-- Sourced: wiki infoboxes (previous = All's Fair in Love, War, and Archaeology 27792 / It's Not About History, It's About Power
--   27882); comment quest_27796 2014-04-14 [+8] "The Warden's Pawn is not initially available from Lead Prospector Durdin";
--   27789 replies under 2010-11-30 (several quests open only after Troggish Troubles, confirmed with a blue). Both TDBs have no
--   link (and a positive ExclusiveGroup 27796, not copied: mutually exclusive here). Badlands ruling R2 / orchestrator, fix round 2.
-- Checked: 27792 / 27882 need 27791 / 27881 (which need Troggish Troubles 27789) and four quest-only drops from the enemy
--   excavators (46772 for the Alliance, 46773 for the Horde, about 21 % each); no ExclusiveGroup, no other prerequisite, so a fresh
--   character and one who did the camp's side quests (27823 / 27824, 27877 / 27878) in any order can finish them. The Pawns keep
--   NextQuestID 27693 / 27709 / 27885 / 27886 and ExclusiveGroup 0; section E's files write no row for these six quests.

UPDATE `quest_template_addon` SET `PrevQuestID` = 27792 WHERE `ID` IN (27796, 27797);
UPDATE `quest_template_addon` SET `PrevQuestID` = 27882 WHERE `ID` IN (27883, 27884);
