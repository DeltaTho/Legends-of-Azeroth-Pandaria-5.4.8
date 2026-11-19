-- Progress texts of six Southfury Watershed quests were missing, so talking to the ender with the quest unfinished showed an empty page.
-- Sourced: both TDBs verbatim (25189 from 4.4.2 only; 12.1.0 has no row, the quest changed in 6.2.4). EmoteOnComplete/EmoteOnIncomplete 0 as
-- the TDBs. Lost in the Floods (Thonk), Watershed Patrol (Thonk), Spirits Be Praised (Raggaran), Raggaran's Fury (Raggaran), Unbidden Visitors
-- (Zen'Taji), That's the End of That Raptor (Zen'Taji).
DELETE FROM `quest_request_items` WHERE `ID` IN (25187, 25188, 25189, 25192, 25194, 25195);
INSERT INTO `quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`CompletionText`,`VerifiedBuild`) VALUES
(25187,0,0,'What have you seen?',0),
(25188,0,0,'How goes your journey, $c?',0),
(25189,0,0,'My grandmother is still out there somewhere...',0),
(25192,0,0,'Quilboar!  Kill them!',0),
(25194,0,0,'Just beat on ''em, mon.  Trust Zen''Taji, they will run.  It is no big thing.',0),
(25195,0,0,'The raptor has always been a quick adapter.',0);
