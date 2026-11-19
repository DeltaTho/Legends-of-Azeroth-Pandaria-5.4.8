-- Valley of Trials class quests: details emotes and the "Class" quest type.
-- Sourced: TDB 4.4.2 quest_details Emote1 1, Emote2 1 (talk) on all twelve; mop had them only on 2383 3087 3088 3089, so the other
-- trainers did not talk-animate when showing their quest. QuestInfoID 21 "Class" as Wowhead MoP Classic (type 21) and TDB 12.1.0; mop's
-- own monk pair 31156/31157 already has 21. The quest log showed no "Class" tag.
DELETE FROM `quest_details` WHERE `ID` IN (3090, 25138, 25139, 25141, 25143, 25145, 25147, 25149);
INSERT INTO `quest_details` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `VerifiedBuild`) VALUES
(3090, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(25138, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(25139, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(25141, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(25143, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(25145, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(25147, 1, 1, 0, 0, 0, 0, 0, 0, 0),
(25149, 1, 1, 0, 0, 0, 0, 0, 0, 0);
UPDATE `quest_template` SET `QuestInfoID` = 21 WHERE `ID` IN (2383, 3087, 3088, 3089, 3090, 25138, 25139, 25141, 25143, 25145, 25147, 25149);
