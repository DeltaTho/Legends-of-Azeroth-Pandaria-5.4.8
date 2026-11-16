-- Searing Gorge A-24: Slag Pit quest texts (offer, progress, details, emotes).
--
-- SOURCED: TDB 12.1.0 (retail) and 4.4.2 quest texts (gate G7).
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

-- Searing Gorge cauldron-finale scope: quest-text repair (gate G7, sonnet 2026-11-16). Idempotent: absolute UPDATEs and INSERT ... ON DUPLICATE KEY UPDATE.
-- Source: TDB 12.1.0 (retail, 1210) and Cataclysm Classic 4.4.2 (442) quest_template / quest_offer_reward / quest_request_items /
-- quest_details. Applied where mop differs from 1210: texts only where the difference is lost $B breaks, stage directions, $g
-- gender codes or a lost tail (core text equal or 1210 is a superset); emotes and delays where 1210 has them and mop has 0/none.
-- Where the two TDBs differ the RETAIL (12.1.0) value wins. Not touched: QuestCompletionLog (1210 blanks
-- it, mop and 442 keep it), 28058 Pillaclencher/Pillamaster wording (1210 renamed her; mop and 442 say Chambermaid), 28028 'marksman'
-- (mop = 442), 28056 request text (only 442 has one), 27470/28058 offer texts (no TDB row). $b is kept as the TDBs write it.
INSERT INTO `quest_offer_reward` (`ID`,`RewardText`) VALUES (28052,'Well, here we are.$b$bI hope you''re ready, $n.') ON DUPLICATE KEY UPDATE `RewardText`=VALUES(`RewardText`);
INSERT INTO `quest_details` (`ID`,`Emote1`,`Emote2`,`Emote3`) VALUES (28052,1,1,1) ON DUPLICATE KEY UPDATE `Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`),`Emote3`=VALUES(`Emote3`);
INSERT INTO `quest_offer_reward` (`ID`,`Emote1`) VALUES (28054,273) ON DUPLICATE KEY UPDATE `Emote1`=VALUES(`Emote1`);
INSERT INTO `quest_details` (`ID`,`Emote1`,`Emote2`,`Emote3`,`Emote4`) VALUES (28054,1,1,5,1) ON DUPLICATE KEY UPDATE `Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`),`Emote3`=VALUES(`Emote3`),`Emote4`=VALUES(`Emote4`);
INSERT INTO `quest_offer_reward` (`ID`,`RewardText`,`Emote1`,`Emote2`) VALUES (28055,'Strange how so many slaves cope poorly with freedom.  It''s a shame to have to do what we do, but such are the truths of war.$b$bNow, we must move on to more pressing tasks.',6,1) ON DUPLICATE KEY UPDATE `RewardText`=VALUES(`RewardText`),`Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`);
INSERT INTO `quest_details` (`ID`,`Emote2`) VALUES (28055,1) ON DUPLICATE KEY UPDATE `Emote2`=VALUES(`Emote2`);
INSERT INTO `quest_offer_reward` (`ID`,`RewardText`,`Emote1`,`Emote2`) VALUES (28056,'A fight well-fought, $n!  I''m beginning to feel the tide turn.$b$bNow, when you''re ready, let''s hit these Dark Irons where it really hurts!',1,5) ON DUPLICATE KEY UPDATE `RewardText`=VALUES(`RewardText`),`Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`);
INSERT INTO `quest_details` (`ID`,`Emote1`,`Emote2`) VALUES (28056,1,1) ON DUPLICATE KEY UPDATE `Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`);
INSERT INTO `quest_offer_reward` (`ID`,`RewardText`,`Emote1`,`Emote2`) VALUES (28057,'I see Evonice is up to her old tricks again.  I guess I''ll just... um... hang onto these pillows for a while.$b$bThe important part is that you''re here.  We''re going to need your help.',6,1) ON DUPLICATE KEY UPDATE `RewardText`=VALUES(`RewardText`),`Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`);
INSERT INTO `quest_request_items` (`ID`,`CompletionText`) VALUES (28057,'What?  Pillows?$b$bWhat?') ON DUPLICATE KEY UPDATE `CompletionText`=VALUES(`CompletionText`);
INSERT INTO `quest_details` (`ID`,`Emote1`,`Emote2`,`Emote3`) VALUES (28057,1,1,1) ON DUPLICATE KEY UPDATE `Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`),`Emote3`=VALUES(`Emote3`);
INSERT INTO `quest_offer_reward` (`ID`,`RewardText`,`Emote1`,`Emote2`,`Emote3`) VALUES (28060,'Twilight''s Hammer, eh?  I should''ve expected as much.  I''m glad you arrived to help them out when you did.$b$bIt looks like, despite all odds, we''ve pressed our offensive to the doorstep of Calcinder''s lair.  It''s now time to finish the job.',273,1,1) ON DUPLICATE KEY UPDATE `RewardText`=VALUES(`RewardText`),`Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`),`Emote3`=VALUES(`Emote3`);
INSERT INTO `quest_details` (`ID`,`Emote1`,`Emote2`,`Emote3`,`Emote4`) VALUES (28060,1,1,5,1) ON DUPLICATE KEY UPDATE `Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`),`Emote3`=VALUES(`Emote3`),`Emote4`=VALUES(`Emote4`);
INSERT INTO `quest_details` (`ID`,`Emote1`,`Emote2`) VALUES (28061,1,1) ON DUPLICATE KEY UPDATE `Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`);
INSERT INTO `quest_details` (`ID`,`Emote1`,`Emote2`,`Emote3`) VALUES (28062,1,1,1) ON DUPLICATE KEY UPDATE `Emote1`=VALUES(`Emote1`),`Emote2`=VALUES(`Emote2`),`Emote3`=VALUES(`Emote3`);
INSERT INTO `quest_offer_reward` (`ID`,`RewardText`) VALUES (28064,'Our task is complete, and it''s all thanks to you, $n.  I''d like to offer you your choice from our coffers.  In addition, I intend to make you a full-fledged member of our order.$b$bWelcome to the Thorium Brotherhood, $n.  I''m proud to call you a $g brother: sister;.') ON DUPLICATE KEY UPDATE `RewardText`=VALUES(`RewardText`);
INSERT INTO `quest_details` (`ID`,`Emote2`) VALUES (28064,1) ON DUPLICATE KEY UPDATE `Emote2`=VALUES(`Emote2`);
