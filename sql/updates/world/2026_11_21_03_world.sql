-- Searing Gorge A-8: Grimesilt quest texts (lost line breaks, stage directions, gender code, emotes, 28034 $N).
--
-- SOURCED: grimesilt F-TXT (qtext.py against both TDBs; retail 12.1.0 wins where they differ). Nothing ours.
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

UPDATE `quest_offer_reward` SET `RewardText`='Let\'s see... Overseer Maltorius... we\'re quite familiar with him and his work.$B$BWhat\'s this?  The "archduke"?  That sounds promising.', `Emote1`=1 WHERE `ID`=27963;
UPDATE `quest_offer_reward` SET `Emote1`=5 WHERE `ID`=27964;
UPDATE `quest_offer_reward` SET `RewardText`='Do I know you, $r?$B$B<Overseer Oilfist listens as you describe what you saw within the flames at Thorium Advance.>$B$BSounds like another one of Ragnaros\' minions.  I don\'t like the sound of that.', `Emote1`=6 WHERE `ID`=27965;
UPDATE `quest_offer_reward` SET `RewardText`='You\'ve got quick hands if you were able to gather this many in such a short time.$B$BExcellent work, $N.  I\'ll make sure these ones don\'t go to waste.', `Emote1`=1 WHERE `ID`=27961;
UPDATE `quest_offer_reward` SET `RewardText`='Yup, this was Margol\'s horn alright.  No doubt about it.$B$BBarnabas was a digger, like me.  He never stood a chance in combat against the beast.  I\'m glad you were here to set things right.', `Emote1`=1 WHERE `ID`=27962;
UPDATE `quest_request_items` SET `CompletionText`='Bring me the horn, $N.' WHERE `ID`=27962;
UPDATE `quest_offer_reward` SET `RewardText`='You didn\'t... KILL the machines to get these, right?.$B$B<Lunk looks upset.>$B$BRight?', `Emote1`=6 WHERE `ID`=27956;
UPDATE `quest_offer_reward` SET `RewardText`='No!  You are the same as Thorium Brotherhood dwarf.$B$B"Kill dwarf.  Kill spider.  Kill machine.  Kill, kill, kill."$B$BLunk come to gorge to go on adventure, not to go on murder spree.$B$BGoodbye, $r.  You kill too much.' WHERE `ID`=27957;
UPDATE `quest_offer_reward` SET `Emote1`=5 WHERE `ID`=27958;
UPDATE `quest_offer_reward` SET `RewardText`='Did I stutter?  I believe I clearly stated that I... won\'t...$B$BWow, ye\'ve got some good moves there!  I\'m impressed!', `Emote1`=5 WHERE `ID`=28034;
UPDATE `quest_template` SET `QuestDescription`=REPLACE(`QuestDescription`,'$n','$N') WHERE `ID`=28034;
-- 27960 progress text: the row may be missing; insert-or-update.
INSERT INTO `quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`CompletionText`,`VerifiedBuild`) VALUES (27960,0,0,'The fewer of them that remain, the better our prospects are.',15595)
ON DUPLICATE KEY UPDATE `CompletionText`=VALUES(`CompletionText`);
