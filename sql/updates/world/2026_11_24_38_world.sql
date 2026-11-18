-- Blasted Lands: progress texts of Attune the Bloodstone (25684 / 26158), Protecting Our Rear (25694 / 26173) and Watching Our
-- Back (25695 / 26174), shown when the player talks to the ender before the quest is done. mop had none.
-- Sourced: TDB 4.4.2 quest_request_items (VerifiedBuild 32750 / 58558). (Blood Ritual's texts ship with its gossip, file 31.)
-- Ours: nothing.
DELETE FROM `quest_request_items` WHERE `ID` IN (25684, 26158, 25694, 26173, 25695, 26174);
INSERT INTO `quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`CompletionText`,`VerifiedBuild`) VALUES
(25684,0,0,'The attunement process is simple, but will certainly come in handy down the line.',0),
(26158,0,0,'The attunement process is simple, but will certainly come in handy down the line.',0),
(25694,0,0,'You have not yet killed these demons.  $N!  Get back to the field!',0),
(26173,0,0,'You have not yet killed these demons.  $N!  Get back to the field!',0),
(25695,0,0,'Did you get a look at those plans, $N?',0),
(26174,0,0,'Did you get a look at those plans, $N?',0);
