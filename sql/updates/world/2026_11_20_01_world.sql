-- Fuselight-by-the-Sea: Dolph's progress text, the Instructors' rods, Gina's Billy Goat Blaster DX.
--
-- Easily Swayed 27774: the quest_request_items row was missing.
--   Sourced: TDB 12.1.0 quest_request_items 27774, wiki "Progress".
-- When the Going Gets Tough, Cheat 27775: Instructor's Rod 62396 dropped from 78.5 % of the six Dustbelcher Instructors 46693.
--   Sourced: both TDBs 100 %. Wowhead's 77 % is flagged "progressive loot" (a chance that rises with failures), so no fixed
--   rate is certain; by the user's rule the less grindy value, 100 % (still quest-only, negative chance).
-- It's Goat Time, Baby 27776: Gina Gotgoods 48067 sold the Billy Goat Blaster DX 65898 before the quest was done.
--   Sourced: Wowhead comment 2010-11-25 [+11] with a rated reply [+2] (sold "after you complete It's Goat Time, Baby").

DELETE FROM `quest_request_items` WHERE `ID` = 27774;
INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `CompletionText`, `VerifiedBuild`) VALUES
(27774, 0, 0, 'I''ll feel much better when those ogres are gone.', 32750);

UPDATE `creature_loot_template` SET `ChanceOrQuestChance` = -100 WHERE `entry` = 46693 AND `item` = 62396;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 23 AND `SourceGroup` = 48067 AND `SourceEntry` = 65898;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(23, 48067, 65898, 0, 0, 8, 0, 27776, 0, 0, 0, 0, 0, '', 'Gina Gotgoods sells the Billy Goat Blaster DX once It''s Goat Time, Baby is rewarded');
