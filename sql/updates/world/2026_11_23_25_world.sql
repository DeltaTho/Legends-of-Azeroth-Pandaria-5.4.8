-- Swamp of Sorrows, the battle quests of Joanna Blueheart and Ruag: progress texts and emotes.
--
-- Sourced: TDB 4.4.2 quest_request_items (texts, EmoteOnComplete, EmoteOnIncomplete) for the twelve quests mop has no row
-- for, and the emotes of Cutting Supply 27851 (mop has its text with emotes 0 / 0; TDB 25 / 25).

DELETE FROM `quest_request_items` WHERE `ID` IN (27795,27821,27822,27843,27845,27849,27852,27853,27854,27855,27856,27857);
INSERT INTO `quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`CompletionText`,`VerifiedBuild`) VALUES
(27795,0,25,'There''s still too many out there. Those knights need help.',0),
(27821,0,25,'I''m pretty sure you still have some slaying to do.',0),
(27822,0,0,'Have you taken care of those peons?',0),
(27843,0,0,'Is there a problem, $n?',0),
(27845,0,0,'It''s a grim task, I know. But one worth doing.',0),
(27849,0,25,'Remember what I said, $n. Surgical.',0),
(27852,0,25,'I''m pretty sure you still have some slaying to do.',0),
(27853,0,0,'If you have a complaint about killing peasants, $r, give me a moment to spit in disgust.',0),
(27854,0,25,'The ogres are powerful, but without help they will fall to the Alliance riders.',0),
(27855,0,0,'Is there a problem, $n?',0),
(27856,0,0,'The spirits will watch over us, $n.',0),
(27857,0,25,'There is no time! Go! Fight!',0);
UPDATE `quest_request_items` SET `EmoteOnComplete`=25, `EmoteOnIncomplete`=25 WHERE `ID`=27851;
