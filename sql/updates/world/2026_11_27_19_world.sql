-- Riding On (25171) is offered only by Master Gadrin, and only after both Purge the Valley (25168) and The War of Northwatch Aggression
-- (25169); those two are taken side by side after Breaking the Chain (25167).
-- Before: 25171 needed only 25168, and Gar'Thok (3139, Razor Hill) also started it; with no objectives it completes on accept, so
-- anyone meeting Gar'Thok could take and hand it in on the spot and open his Razor Hill chain without Sen'jin.
-- Sourced: Wowhead 25171 2011-05-24 [+8] (Riding On opens after Breaking the Chain, Purge the Valley and The War of Northwatch
-- Aggression); both TDBs put 25168 and 25169 in group -25168 with NextQuestID towards 25171 and give 25171 only Gadrin as starter; wiki
-- 25168/25169 "should be done along with" the other. The wiki also lists Never Trust a Big Barb and a Smile as a previous of Riding On:
-- not used, neither TDB nor the 2011 walkthrough gates on it.
-- Ours: not the TDBs' literal rows. Their 25168 NextQuestID 25169 puts 25168 (group -25168) into 25169's prerequisite list; this core
-- fills that list in hash-map order (ObjectMgr.cpp:4939-4954) and SatisfyQuestDependentPreviousQuests (Player.cpp:17094) stops at the
-- first rewarded entry, so a player who handed in 25168 first could find 25169 demanding itself and never be offered it. Here both
-- point at 25171 instead: 25171's list is {25168, 25168, 25169}, and whichever group member is rewarded first demands the other, so
-- both are needed; 25169's list stays {25167}. The hand-in of 25168 still offers 25171 (RewardNextQuest) when 25169 is already done,
-- otherwise the offer fails quietly and Gadrin offers it once 25169 is handed in to Lar Prowltusk.
UPDATE `quest_template_addon` SET `NextQuestID` = 25171, `ExclusiveGroup` = -25168 WHERE `ID` IN (25168, 25169);
DELETE FROM `creature_queststarter` WHERE `id` = 3139 AND `quest` = 25171;
