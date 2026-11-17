-- Burning Steppes B (_19, fix round 1): progress texts of I Am the Law 28278, I Am the Lash 28439 and Trial by Magma (Horde) 28438
-- (walk trials M1, coverage).
--
-- SOURCED: TDB 4.4.2 quest_request_items (mop had no row: an empty progress window at the General). 28266 already has its text.
-- Chiselgrip 28184 / 28426: neither TDB has a progress text; nothing added.
-- Idempotent: DELETE + INSERT.

DELETE FROM `quest_request_items` WHERE `ID` IN (28278, 28439, 28438);
INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `CompletionText`, `VerifiedBuild`) VALUES
(28278, 0, 0, 'Do I have to use the cudgel on you, soldier?  Get back out there!', 0),
(28439, 0, 0, 'Do I have to use the cudgel on you, soldier?  Get back out there!', 0),
(28438, 0, 0, 'What''s the matter, are you scared?', 0);
