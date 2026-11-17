-- Burning Steppes A (_04): progress texts of Burning Vengeance 28174 / 28416 / 28418, Shadow Boxing 28182 / 28424, Prove Yer
-- Allegiance 28225 and Golem Training 28227 (plan A-14, A-21, A-28).
--
-- SOURCED: both TDBs quest_request_items (the same texts; mop had no row, so the progress window was empty).
-- Idempotent: DELETE + INSERT.

DELETE FROM `quest_request_items` WHERE `ID` IN (28174, 28416, 28418, 28182, 28424, 28225, 28227);
INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `CompletionText`, `VerifiedBuild`) VALUES
(28174, 0, 0, 'I suppose you don''t have what it takes.$b$bThat''s fine.  I can fight this war myself.', 0),
(28416, 0, 0, 'You have trouble finding them?  They''re to the south, $N.', 0),
(28418, 0, 0, 'I suppose you don''t have what it takes.$b$bThat''s fine.  I can fight this war myself.', 0),
(28182, 0, 0, 'Go ahead.  Kill him!', 0),
(28424, 0, 0, 'Go ahead.  Kill him!', 0),
(28225, 0, 0, 'Watch yerself, stranger...', 0),
(28227, 0, 0, 'Please, help us out, $r.', 0);
