-- Echo Isles class line (54 quests): quest emotes, progress texts, the "Class" quest type, a gender text and one flag. The same
-- faults Durotar fixed for the Valley of Trials class quests (2026_11_27_13); no Durotar row is touched here.
-- Sourced: TDB 4.4.2 quest_details (all 48 non-monk quests), quest_offer_reward Emote1..4 / EmoteDelay1..4, quest_request_items
-- (TDB 12.1.0 for monk 31158 and 31161; the Arts progress texts are the ones Wowhead MoP Classic shows, e.g. 24760 24772 24778);
-- QuestInfoID 21 = Wowhead MoP Classic "Type: Class" and TDB 12.1.0, on exactly these 18; "$G boy:girl;" in A Rough Start = both
-- TDBs and Wowhead 24779 2011-07-16 (a female character reads "girl"); 31159 Flags = TDB 12.1.0 and its eight siblings.
-- Ours: the monk set's quest_details / offer-reward emotes copy the warrior set's (no source has monk emotes).
-- 1. quest_details emotes (mop has no row for any of the 54)
DELETE FROM `quest_details` WHERE `ID` IN (24607, 24639, 24640, 24641, 24642, 24643, 24750, 24751, 24752, 24753, 24754, 24755, 24758, 24759, 24760, 24761, 24762, 24763, 24764, 24765, 24766, 24767, 24768, 24769, 24770, 24771, 24772, 24773, 24774, 24775, 24776, 24777, 24778, 24779, 24780, 24781, 24782, 24783, 24784, 24785, 24786, 24787, 26272, 26273, 26274, 26275, 26276, 26277, 31159, 31158, 31162, 31160, 31161, 31163);
INSERT INTO `quest_details` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `VerifiedBuild`) VALUES
(24607, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(24639, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24640, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24641, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24642, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24643, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(24750, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(24751, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24752, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24753, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24754, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24755, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(24758, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(24759, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24760, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24761, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24762, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24763, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(24764, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(24765, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24766, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24767, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24768, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24769, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(24770, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(24771, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24772, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24773, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24774, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24775, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(24776, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(24777, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24778, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24779, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24780, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24781, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(24782, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(24783, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24784, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24785, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(24786, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(24787, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(26272, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(26273, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(26274, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(26275, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(26276, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(26277, 0, 1, 0, 0, 0, 0, 0, 0, 0),
(31159, 1, 1, 1, 0, 0, 60, 60, 0, 0),
(31158, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(31162, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(31160, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(31161, 1, 1, 0, 0, 0, 60, 0, 0, 0),
(31163, 0, 1, 0, 0, 0, 0, 0, 0, 0);

-- 2. quest_offer_reward emotes (mop has 0 everywhere; the rows exist and their texts are already right)
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24607;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24639;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24640;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24641;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24642;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24643;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24750;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24751;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24752;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24753;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24754;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24755;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24758;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24759;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24760;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24761;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24762;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24763;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24764;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24765;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24766;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24767;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24768;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24769;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24770;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24771;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24772;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24773;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24774;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24775;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24776;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24777;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24778;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24779;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24780;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24781;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24782;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24783;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24784;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24785;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24786;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 24787;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 26272;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 26273;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 26274;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 26275;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 26276;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 26277;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 5, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 60, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 31159;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 31158;
UPDATE `quest_offer_reward` SET `Emote1` = 5, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 31162;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 31160;
UPDATE `quest_offer_reward` SET `Emote1` = 4, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 31161;
UPDATE `quest_offer_reward` SET `Emote1` = 6, `Emote2` = 0, `Emote3` = 0, `Emote4` = 0, `EmoteDelay1` = 0, `EmoteDelay2` = 0, `EmoteDelay3` = 0, `EmoteDelay4` = 0 WHERE `ID` = 31163;

-- 3. quest_request_items: progress text of Basics, Arts and Proving Pit (mop has rows only for the nine A Rough Start and 24752).
--    31162 (monk Arts) has no source text and is left without one.
DELETE FROM `quest_request_items` WHERE `ID` IN (24639, 24640, 24642, 24751, 24754, 24759, 24760, 24762, 24765, 24766, 24768, 24771, 24772, 24774, 24777, 24778, 24780, 24783, 24784, 24786, 26273, 26274, 26276, 31158, 31161);
INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `CompletionText`, `VerifiedBuild`) VALUES
(24639, 0, 1, 'Strength isn\'t da end all of defeating ya enemy, and it most certainly isn\'t tha end all of stayin\' alive. Fightin\' is about balance. Everytin has its time and place.', 0),
(24640, 0, 1, 'Veteran warriors can control much of da battlefield simply with da strength of deir presence. Whether it be rallyin\' other fighters beside ya to greater strength, demoralizin\' ya enemies with da fierceness of ya attacks, our intimidatin\' ya foes into runnin\' from da very sight of ya, it\'s more than just the weapon dat makes da warrior.', 0),
(24642, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0),
(24751, 0, 1, 'Power isn\'t da end all of defeating ya enemy, and it most certainly isn\'t tha end all of stayin\' alive. Fightin\' is about balance. Everytin\' has its time and place.', 0),
(24754, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0),
(24759, 0, 1, 'Power isn\'t da end all of defeating ya enemy, and it most certainly isn\'t tha end all of stayin\' alive. Fightin\' is about balance. Everytin has its time and place.', 0),
(24760, 0, 1, 'Der are many other ways to enchant yer weapon. Ya\'ll learn more wit time.', 0),
(24762, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0),
(24765, 0, 1, 'Strength isn\'t da end all of defeating ya enemy, and it most certainly isn\'t tha end all of stayin\' alive. Fightin\' is about balance. This\'ll become more apparent as ya learn animal forms, but it holds true even now. Everytin\' has its time and place.', 0),
(24766, 0, 1, 'Veteran druids can take on animal forms, grantin\' great speed, tough skin, or even tha ability ta fly.', 0),
(24768, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0),
(24771, 0, 1, 'Strength isn\'t da end all of defeating ya enemy, and it most certainly isn\'t tha end all of stayin\' alive. Fightin\' is about balance. Everytin has its time and place.', 0),
(24772, 0, 1, 'As ya progress in skill, it will become even harder for people or tings to detect ya.', 0),
(24774, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0),
(24777, 0, 1, 'Aim isn\'t da end all of defeating ya enemy, and it most certainly isn\'t tha end all of stayin\' alive. Fightin\' is about balance. Everytin has its time and place.', 0),
(24778, 0, 1, 'No matta how much ya learn or how good ya get, it\'s the steady hand between ya shots that will keep ya enemies hurtin\'. Don\'t forget to mix dis practice in-between da rest of tha tricks ya learn.', 0),
(24780, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0),
(24783, 0, 1, 'Power isn\'t da end all of defeating ya enemy, and it most certainly isn\'t tha end all of stayin\' alive. Fightin\' is about balance. Everytin has its time and place.', 0),
(24784, 0, 1, 'As ya progress in skill, dis power will become greater naturally, as will many of your others.', 0),
(24786, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0),
(26273, 0, 1, 'Power stems from dis world and worlds you\'ve not yet seen. Masterin\' da power of one ain\'t gonna be enough ta make it outside of dese trainin\' grounds - you gonna need to be pullin ya power from all of dem.', 0),
(26274, 0, 1, 'With time, ya\'ll learn ta conjure more powerful fire and shadow to tear away at ya enemies. Summon ya allies from other parts of da world. Beckon terrifying and powerful demons.$B$BAll in time.', 0),
(26276, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0),
(31158, 0, 1, 'Strength isn\'t da end all of defeating ya enemy, and it most certainly isn\'t tha end all of stayin\' alive. Fightin\' is about balance. Everytin has its time and place.', 0),
(31161, 0, 1, 'All trolls gotta prove demselves before we let them move past da training grounds.', 0);

-- 4. Quest type 'Class' where Wowhead MoP Classic and TDB 12.1.0 show it (warrior, druid and warlock sets; 31162 already has 21).
--    The other six sets show no type in either source and stay 0.
UPDATE `quest_template` SET `QuestInfoID` = 21 WHERE `ID` IN (24607, 24639, 24640, 24641, 24642, 24643, 24764, 24765, 24766, 24767, 24768, 24769, 26272, 26273, 26274, 26275, 26276, 26277);

-- 5. A Rough Start: mop's reward text calls every player 'boy' (all nine copies, monk included)
UPDATE `quest_offer_reward` SET `RewardText` = 'Dese are some fine pelts, $G boy:girl;. We could make some hefty cloaks outta dese.' WHERE `ID` IN (24641, 24753, 24761, 24767, 24773, 24779, 24785, 26275, 31160);

-- 6. 31159 (monk Rise) has 0x40000 DISPLAY_COMPLETION_TEXT, which its eight siblings and TDB 12.1.0 (524288) lack
UPDATE `quest_template` SET `Flags` = 524288 WHERE `ID` = 31159;
