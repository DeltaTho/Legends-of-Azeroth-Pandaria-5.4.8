-- Durotar, the Dranosh'ar Blockade: The Wolf and The Kodo (25205, Shin Stonepillar) and Thunder Down Under (25236, Gor the
-- Enforcer) are offered without The Dranosh'ar Blockade (25196), as both TDBs have them: neither TDB has a PrevQuestID for either
-- (25205 has no addon row in TDB 4.4.2 or 12.1.0; 25236's row has PrevQuestID 0 in both). mop required 25196 rewarded for both, so
-- a player who reached the blockade without Razor Hill's chain found Gor and Shin with nothing to offer. Only the wiki lists 25196
-- before 25236; both TDBs agree on 0, so they are followed (the wiki rule applies where a TDB has nothing to say).
-- Unchanged: Fizzled 25260 keeps PrevQuestID 25196 (both TDBs), Ignoring the Warnings 25206 needs 25205 (2026_11_27_65), Beyond
-- Durotar 25648 needs 25206 (2026_11_27_66). Nothing names 25205 or 25236 as its NextQuestID, so their previous-quest lists are empty.
-- Who offers what (level 8+, Horde):
--   nothing done: Gor 25236; Shin 25205.
--   25196 in the log: Gor takes 25196 back, offers 25236; Shin 25205.
--   25196 rewarded: Gor 25236 and 25260 (25260 also offered at once on the hand-in); Shin 25205.
--   25205 rewarded: Gor also 25206, then 25648 after it.

UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` IN (25205, 25236);
