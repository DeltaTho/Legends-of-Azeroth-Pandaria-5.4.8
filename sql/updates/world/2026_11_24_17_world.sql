-- Blasted Lands A (_17): Nethergarde Keep quest texts and emotes (dossier S2 F-TEXTS; gate report task 1: the accept emotes,
-- quest_details, which F-TEXTS did not cover).
--
-- Today: progress texts missing for 25708-25713 and 25715 (the ender says nothing while the quest is open); reward texts without
-- paragraph breaks and stage directions ("<Enohar takes a sip off of a freshly-refilled mug.>", "<The watcher selects a spell
-- focus ...>") and every emote 0 (Lungertz's insult at the 25711 hand-in, Enohar's drink); no quest_details rows (accept emotes).
-- 25708's accept stage direction "<Enohar takes a long draw off of a mug of black ale.>" is already in mop's QuestDescription
-- (the gate report's "missing" is overturned: only the emote row was missing).
-- SOURCED: TDB 4.4.2 quest_details / quest_request_items / quest_offer_reward, matching the wiki. 25708's reward line keeps the
-- TDB's "$g lad: lassie;" (the wiki shows the male form only). 28857 / 28867 keep mop's text (no TDB row).
-- Idempotent: INSERT ... ON DUPLICATE KEY UPDATE with the full values.

INSERT INTO `quest_details` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`) VALUES
(25708, 1, 1, 1, 0, 0, 0, 0, 0),
(25709, 1, 1, 0, 0, 0, 1111, 0, 0),
(25710, 0, 1, 0, 0, 0, 0, 0, 0),
(25711, 25, 1, 1, 0, 0, 0, 0, 0),
(25712, 396, 1, 0, 0, 0, 555, 0, 0),
(25713, 1, 1, 0, 0, 0, 888, 0, 0),
(25714, 1, 1, 0, 0, 0, 0, 0, 0),
(25715, 1, 1, 0, 0, 0, 0, 0, 0),
(25716, 1, 1, 0, 0, 0, 0, 0, 0),
(26157, 1, 1, 1, 0, 0, 0, 0, 0),
(27919, 0, 1, 0, 0, 0, 0, 0, 0),
(28673, 1, 1, 0, 0, 0, 0, 0, 0)
ON DUPLICATE KEY UPDATE `Emote1` = VALUES(`Emote1`), `Emote2` = VALUES(`Emote2`), `Emote3` = VALUES(`Emote3`), `Emote4` = VALUES(`Emote4`), `EmoteDelay1` = VALUES(`EmoteDelay1`), `EmoteDelay2` = VALUES(`EmoteDelay2`), `EmoteDelay3` = VALUES(`EmoteDelay3`), `EmoteDelay4` = VALUES(`EmoteDelay4`);

INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `CompletionText`) VALUES
(25708, 0, 0, 'The Gilneans need us, $N.  Get back out there and give them their respite.'),
(25709, 0, 0, 'It breaks a dwarf''s heart to think about those poor travelers.'),
(25710, 0, 0, 'What''s the matter, too scared to fight?$b$bI should have known not to trust an outsider $c like you.  Best leave Nethergarde''s defenses to its own men.'),
(25711, 0, 0, 'What are you waiting for, $N?  Get out there and FIGHT!'),
(25712, 0, 0, 'Are you lost?  You''ll find Metlek riding a black wolf behind the front lines.'),
(25713, 0, 0, 'How did it go out there?'),
(25715, 0, 0, 'What news from the Shattershore, $N?'),
(25716, 0, 0, 'The cultists will not part easily with their foci.  Slay them quickly before they suspect our intent.'),
(26157, 0, 0, 'I don''t know you.')
ON DUPLICATE KEY UPDATE `EmoteOnComplete` = VALUES(`EmoteOnComplete`), `EmoteOnIncomplete` = VALUES(`EmoteOnIncomplete`), `CompletionText` = VALUES(`CompletionText`);

INSERT INTO `quest_offer_reward` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `RewardText`) VALUES
(25708, 92, 1, 0, 0, 0, 0, 0, 0, '<Enohar takes a sip off of a freshly-refilled mug.>$b$bAye, you''ve done well, $g lad: lassie;.  You do the Alliance proud.'),
(25709, 1, 1, 0, 0, 0, 0, 0, 0, 'It''s a tragedy, what happened on the Shattershore.  They weren''t even soldiers... just people looking for a new home.$b$bI think we''ve done all we can, $N.'),
(25710, 1, 0, 0, 0, 0, 0, 0, 0, 'Hmm... not bad.  You''re quicker than many of my men.  Stick around, $N... I may have use of you yet.'),
(25711, 1, 14, 0, 0, 0, 0, 0, 0, 'You''re an excellent asset to the Alliance and the Kirin Tor, $N.  Well done.$b$bWith time, our forces will retake the mine and press these Horde dogs out of the Blasted Lands.'),
(25712, 396, 396, 0, 0, 0, 0, 0, 0, 'Thank you, $N.  Thanks to your efforts, I am confident that with time, we will take back the Nethergarde Mine.'),
(25713, 24, 0, 0, 0, 0, 0, 0, 0, 'Ahh, the sound of things going boom makes my heart pitter-pat.  You''ve made this gnome''s day, $n.'),
(25714, 1, 0, 0, 0, 0, 0, 0, 0, 'My associates were correct to send you to me.  I have a problem which may threaten the sanctity of Nethergarde, and I need someone more capable than most.'),
(25715, 274, 274, 1, 0, 0, 777, 777, 0, 'You saw worgen?  That''s bad.$b$bWorgen ghosts?  That''s even worse.$b$bThose weren''t Horde ships... they were Gilnean.  And they must have been headed down to Surwich, at the bottom of the Tainted Forest.  That makes a lot more sense.$b$bWe''ve got to try to help them, $N!  The worgen are our allies!'),
(25716, 1, 0, 0, 0, 0, 0, 0, 0, 'Ably done, $N.  Now we see if my suspicions are correct.$b$b<The watcher selects a spell focus and focuses intently on its shadows.  After a moment, he turns back to you with a look of horror on his face.>'),
(26157, 1, 1, 0, 0, 0, 0, 0, 0, 'Hah!  You Nethergarde nincompoops are always two steps behind me, and I''m nowhere near as fast as I used to be.$b$bI don''t need Mahar''s note to know what''s going on.  Why do you think I''m cooped up in the back of this cave?  What I do need, however, is a strong $r like you.'),
(27919, 0, 0, 0, 0, 0, 0, 0, 0, 'Ah, has Avuun sent ye? Good, good...'),
(28673, 1, 0, 0, 0, 0, 0, 0, 0, 'For decades has the garrison at Nethergarde held firm against the threat of the Horde and we do not intend to surrender now.')
ON DUPLICATE KEY UPDATE `Emote1` = VALUES(`Emote1`), `Emote2` = VALUES(`Emote2`), `Emote3` = VALUES(`Emote3`), `Emote4` = VALUES(`Emote4`), `EmoteDelay1` = VALUES(`EmoteDelay1`), `EmoteDelay2` = VALUES(`EmoteDelay2`), `EmoteDelay3` = VALUES(`EmoteDelay3`), `EmoteDelay4` = VALUES(`EmoteDelay4`), `RewardText` = VALUES(`RewardText`);
