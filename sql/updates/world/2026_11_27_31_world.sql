-- Gail Nozzywig (39423) flirts with men and is rude to women: her progress and completion texts for Exploiting the Situation (25176) and
-- Shipwreck Searching (25178) had only the male half. Sourced: both TDBs (4.4.2 and 12.1.0) verbatim, texts and emotes; comments 2010-11-27
-- [+29], 2012-08-23 [+11], 2010-12-31 quote the female lines. Only the enUS columns change; the koKR locale rows are left as they are.
UPDATE `quest_offer_reward` SET `Emote1` = 1, `RewardText` = '$G You brought me my treasure!  What a sweetheart!: About time you showed up.  Don''t even think about stealing that treasure... it''s worthless here in Kalimdor, anyhow.;' WHERE `ID` = 25176;
UPDATE `quest_offer_reward` SET `Emote1` = 1, `RewardText` = '$g You really know how to treat a girl, you know that?  If you ever need anything...: Well, I suppose you''re not completely useless.  Now stay away from my men!;' WHERE `ID` = 25178;
UPDATE `quest_request_items` SET `EmoteOnComplete` = 25, `EmoteOnIncomplete` = 25, `CompletionText` = '$g<Gail purrs disarmingly at you.>: <Gail glares menacingly at you.>;' WHERE `ID` = 25176;
UPDATE `quest_request_items` SET `EmoteOnComplete` = 25, `EmoteOnIncomplete` = 25, `CompletionText` = '$g Has my knight in shining armor returned?: Well?;' WHERE `ID` = 25178;
