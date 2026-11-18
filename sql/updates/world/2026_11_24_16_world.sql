-- Blasted Lands A (_16): Dreadmaul Hold quest texts and emotes (dossier S1 F-PROGRESS, extended to the accept and reward
-- screens; gate report task 1).
--
-- Today: no quest_request_items rows (the ender shows a blank progress page), no quest_details rows (no accept emotes), and the
-- reward texts lost their paragraph breaks and stage directions ("<Tak'arili sighs.>", "<Okrilla glances over the report.>",
-- "<Lynnore listens to your tale.>") with every reward emote 0.
-- SOURCED: TDB 4.4.2 quest_details / quest_request_items / quest_offer_reward, matching the wiki "Progress" and "Completion"
-- sections. 28671 / 28858 keep mop's reward text (neither TDB has a row). The 25681 progress text is also in section B's scope
-- (25681 claims table): an identical upsert, harmless in either order.
-- Idempotent: INSERT ... ON DUPLICATE KEY UPDATE with the full values.

INSERT INTO `quest_details` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`) VALUES
(25674, 1, 1, 1, 0, 0, 0, 0, 0),
(25675, 1, 1, 1, 0, 0, 0, 0, 0),
(25676, 274, 1, 1, 0, 0, 0, 0, 0),
(25677, 1, 1, 0, 0, 0, 0, 0, 0),
(25678, 0, 1, 0, 0, 0, 0, 0, 0),
(25679, 1, 1, 0, 0, 0, 0, 0, 0),
(25680, 1, 1, 6, 1, 0, 0, 0, 0),
(25681, 1, 1, 1, 0, 0, 0, 0, 0),
(25682, 6, 1, 0, 0, 0, 0, 0, 0),
(25683, 1, 1, 1, 0, 0, 0, 0, 0)
ON DUPLICATE KEY UPDATE `Emote1` = VALUES(`Emote1`), `Emote2` = VALUES(`Emote2`), `Emote3` = VALUES(`Emote3`), `Emote4` = VALUES(`Emote4`), `EmoteDelay1` = VALUES(`EmoteDelay1`), `EmoteDelay2` = VALUES(`EmoteDelay2`), `EmoteDelay3` = VALUES(`EmoteDelay3`), `EmoteDelay4` = VALUES(`EmoteDelay4`);

INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `CompletionText`) VALUES
(25674, 0, 0, 'Is that ogre blood I smell?  It had better be...'),
(25675, 0, 0, 'The less we have to worry about ogres, the more we can focus on our true mission here.'),
(25677, 0, 0, 'I wouldn''t store that solvent where I store my potions, if I were you.'),
(25678, 0, 0, 'Just because you''re costing the Alliance hundreds of gold doesn''t mean I''m going to pay you hundreds of gold.  So don''t even think about asking.'),
(25680, 0, 0, 'What was it, mon?  You get a close enough look?'),
(25681, 0, 0, 'Hondo ain''t gonna know what hit him.'),
(25682, 0, 0, 'You''ve returned, $n?')
ON DUPLICATE KEY UPDATE `EmoteOnComplete` = VALUES(`EmoteOnComplete`), `EmoteOnIncomplete` = VALUES(`EmoteOnIncomplete`), `CompletionText` = VALUES(`CompletionText`);

INSERT INTO `quest_offer_reward` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `RewardText`) VALUES
(25674, 1, 0, 0, 0, 0, 0, 0, 0, 'Well done, $r.  You''ve proven that you can take down an ogre... no small feat.  Now let''s see if you can take down an Alliance iron mine...'),
(25675, 1, 0, 0, 0, 0, 0, 0, 0, 'You''ve done well today, $n.  Not only have you purchased more time before the next ogre attack, but I think you scared some of the captives into working harder.'),
(25676, 1, 0, 0, 0, 0, 0, 0, 0, 'Finally... another operative shows up.  I hope you''re loosened up... it''s time to tango, partner.'),
(25677, 4, 0, 0, 0, 0, 0, 0, 0, 'There''s nothing quite like a big fat kick in the wallet, is there, you Alliance lunkheads?!'),
(25678, 1, 0, 0, 0, 0, 0, 0, 0, 'Excellent work, friend.  I like the way you do business.'),
(25679, 1, 0, 0, 0, 0, 0, 0, 0, 'Good, you here already.  Stick around for a bit, little $r.  We gonna mess with the Alliance.$b$bI love my job, mon.'),
(25680, 1, 1, 0, 0, 0, 0, 0, 0, 'So it was a demon?  Those miners never seen a demon before?  We''re in the Blasted Lands, mon!  Demons are everywhere!$b$b<Tak''arili sighs.>$b$bAh well... let''s get on to da good stuff, shall we?'),
(25681, 1, 0, 0, 0, 0, 0, 0, 0, 'Nice work, mon!  Without Hondo, these guys are helpless.  Dis mine''ll be ours soon enough!'),
(25682, 0, 0, 0, 0, 0, 0, 0, 0, '<Okrilla glances over the report.>$b$bImpressive, $n.  I wouldn''t have hidden in that box, but otherwise, you have performed bravely and admirably.  The battle we won today may not win us any immediate spoils, but the damage you''ve done to the Alliance will last for a long time.'),
(25683, 1, 0, 0, 0, 0, 0, 0, 0, 'Okrilla sent you?  Okrilla the killa''?$b$b<Lynnore listens to your tale.>$b$bLoramus was his name?  I''m sorry to say that we have not seen your demon hunter... but we have ways of finding him.'),
(28553, 0, 0, 0, 0, 0, 0, 0, 0, 'Well, well, well... look what the Ruag dragged in!'),
(28865, 11, 1, 5, 0, 0, 0, 0, 0, 'Silithus, such a worthless piece of land. It is a wonder that the great cataclysm did not sunder it fully!')
ON DUPLICATE KEY UPDATE `Emote1` = VALUES(`Emote1`), `Emote2` = VALUES(`Emote2`), `Emote3` = VALUES(`Emote3`), `Emote4` = VALUES(`Emote4`), `EmoteDelay1` = VALUES(`EmoteDelay1`), `EmoteDelay2` = VALUES(`EmoteDelay2`), `EmoteDelay3` = VALUES(`EmoteDelay3`), `EmoteDelay4` = VALUES(`EmoteDelay4`), `RewardText` = VALUES(`RewardText`);
