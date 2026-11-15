-- Tomb of the Watchers: the slabs no longer start the Horde Pawn quests, and the Horde Games / Ancient Protectors get their
-- completion texts.
--
-- The Warden's Pawn 27883 / The Sentinel's Pawn 27884 (Horde): the Stone Slab 206335 / Marble Slab 206336 also started them, so
--   a Horde player could take a Pawn quest, statue and all, at the slab without Bloodwatcher. Sourced: neither TDB nor Wowhead
--   ("Start: Bloodwatcher") has the slabs as starters. The slabs stay the enders, and their other starter / ender rows are
--   section E's (the Games, Ancient Protectors and the Trove).
-- The Warden's Game 27885, The Sentinel's Game 27886, Ancient Protectors 27887 (Horde) had no quest_offer_reward row.
--   Sourced: TDB 12.1.0 quest_offer_reward (the same text as the Alliance copies 27693 / 27709 / 27793).

DELETE FROM `gameobject_queststarter` WHERE (`id` = 206335 AND `quest` = 27883) OR (`id` = 206336 AND `quest` = 27884);

DELETE FROM `quest_offer_reward` WHERE `ID` IN (27885, 27886, 27887);
INSERT INTO `quest_offer_reward` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `RewardText`, `VerifiedBuild`) VALUES
(27885, 0, 0, 0, 0, 0, 0, 0, 0, 'The jade statue becomes one again, and you place it in your pocket.  You hear a shifting noise in the tomb''s central chamber.', 32750),
(27886, 0, 0, 0, 0, 0, 0, 0, 0, '<The red statue falls over, and you place it back in your bags.  You hear a rumbling noise in the tomb''s central chamber.>', 32750),
(27887, 0, 0, 0, 0, 0, 0, 0, 0, 'With your inspection complete, the statues return to their original positions.  Something seems different in the room, however...', 32750);
