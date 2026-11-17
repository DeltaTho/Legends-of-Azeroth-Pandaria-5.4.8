-- Burning Steppes B (_11): Abuse of Power 28279 / 28440 handed in from the log and only after I Am the Law / Lash; General Thorg'izog
-- 28265 / 28437 only after Golem Training 28227 (plan B-01, B-13, B-14).
--
-- SOURCED: both TDBs (28279 / 28440 Flags 0x2D0000: + 0x10000 log turn-in, and 0x200000 on 28440 as 28279 has it); wiki 28279 /
-- 28440 "completes automatically" and 28286 / 28441 "start=Automatic" (GetNextQuest from the log needs 0x10000, Player.cpp);
-- comments 2010-11-26 [+16], 2010-12-02 [+4], 2010-12-16 [+7], the 2010-12-27 guide ("You don't meet the requirements" when Taking the
-- Horn offers 28265) and 28437 2010-11-26 [+3] reply: Stebben's three quests come before the General, for both factions.
-- OURS: Troteman / Eitrigg offer Abuse of Power only once I Am the Law / Lash is held or done (the TDBs have the same hole: anyone at
-- Chiselgrip could take it and skip the whole hovel arc). QUESTSTATE mask 74 = complete | incomplete | rewarded.
-- Idempotent: the flag UPDATEs set bits; DELETE + INSERT.

UPDATE `quest_template` SET `Flags` = `Flags` | 0x10000 WHERE `ID` IN (28279, 28440);
UPDATE `quest_template` SET `Flags` = `Flags` | 0x200000 WHERE `ID` = 28440;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` IN (28279, 28440, 28265, 28437);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 28279, 0, 0, 47, 0, 28278, 74, 0, 0, 0, 0, '', 'Abuse of Power (A) - only once I Am the Law was taken (complete, incomplete or rewarded)'),
(19, 0, 28440, 0, 0, 47, 0, 28439, 74, 0, 0, 0, 0, '', 'Abuse of Power (H) - only once I Am the Lash was taken'),
(19, 0, 28265, 0, 0, 8, 0, 28227, 0, 0, 0, 0, 0, '', 'General Thorg''izog (A) - Golem Training rewarded'),
(19, 0, 28437, 0, 0, 8, 0, 28227, 0, 0, 0, 0, 0, '', 'General Thorg''izog (H) - Golem Training rewarded');
