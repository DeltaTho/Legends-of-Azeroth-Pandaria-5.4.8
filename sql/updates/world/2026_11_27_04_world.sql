-- Progress texts for Valley of Trials and Sen'jin Village quests: talking to the quest giver before the objectives are done opened an
-- empty window. Sourced: TDB 4.4.2 quest_request_items (texts and EmoteOnIncomplete); the same texts are in TDB 12.1.0, the wiki
-- Progress sections and Wowhead MoP Classic. 25145 keeps Blizzard's "Immolate" line as every source shows it (a 4.x leftover the 5.x
-- client still showed). Not added: 25149 Frost Nova and 31157 Tiger Palm (no 5.x source).
DELETE FROM `quest_request_items` WHERE `ID` IN (25126, 25131, 25172, 25139, 25141, 25143, 25145, 25147, 25165, 25167, 25168);
INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `CompletionText`, `VerifiedBuild`) VALUES
(25126, 0, 0, 'I hope you haven''t returned to try and convince me that you have completed your task, $n? No, of course not. I would think better of you.', 0),
(25131, 0, 1, 'To prove yourself against the Burning Blade, you must first defeat these vile familiars.  Return to me when you have done this.', 0),
(25172, 0, 0, 'Quickly, $n.  Dispatch of these humans in our valley.', 0),
(25139, 0, 2, 'Whenever you''re ready, we''ll move forward.', 0),
(25141, 0, 2, 'We don''t move forward until I get paid.', 0),
(25143, 0, 2, 'We must continue your training before pressing forward, young $n.', 0),
(25145, 0, 2, 'Once you have learned Immolate, then we can test your abilities.', 0),
(25147, 0, 6, 'After we train, then we will test your abilities.', 0),
(25165, 0, 0, 'You got the jujus, ya?', 0),
(25167, 0, 0, 'We gotta get rid of these humans, $c.', 0),
(25168, 0, 0, 'Slay them all.', 0);
