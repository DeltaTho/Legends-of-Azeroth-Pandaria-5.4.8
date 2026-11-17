-- Swamp of Sorrows A (_02): the Sunken Temple chain (plan A-08..A-12; S2 dossier F1, F2, F5, F6 + gate decision D1).
--
-- SOURCED: the four outer-temple steps are handed in from the quest log (both TDBs AUTO_COMPLETE 0x10000; wiki 27704 "Click on
-- the quest in your log to turn it in"; 27768 comment 2010-11-24 replies). Accepting Blessing of the Green Dragonflight pulls
-- the player to Itharius (quest text; 27773 comment 2010-11-30 [+11]; DBC 87712 Teleport to Itharius, destination as both TDBs'
-- spell_target_position, VerifiedBuild 25961). To Marshtide Watch / To Stonard follow Blessing (wiki "previous"; 27914 comment
-- 2010-12-26 [+6]). Pool of Tears is offered without the breadcrumb, and the breadcrumb is gone once Pool of Tears is taken
-- (comments 27869 2010-12-02 [+3] and 2011-03-14 [+11], 27914 2011-10-10 [+7], 27691 2012-03-09).
-- (The Darkest Depths' fourth reward, Sinister Belt 64619, is already in the base data: no row here.)
-- OURS: the teleport's facing (6.12, towards Itharius; both TDBs leave it NULL); the encoding of the breadcrumb close (QUESTSTATE
-- mask 1). 27869's NextQuestID 0 (D1) ships here: without it 27694 still depends on 27869 (ObjectMgr NextQuestID ->
-- DependentPreviousQuests) and F6 would change nothing.
-- F1 and F2 ship together: accepting 27914 from the log needs 27773 to be a log turn-in (QuestHandler: a quest offered by the
-- player himself is accepted only when its PrevQuestID has AUTO_COMPLETE).
-- Idempotent: absolute UPDATEs, DELETE + INSERT.

-- A-08: Legends of the Sunken Temple, Step One, Step Two, Step Three: Flags | AUTO_COMPLETE 0x10000 (values written absolute)
UPDATE `quest_template` SET `Flags` = 327684    WHERE `ID` = 27704; -- 0x00040004 | 0x10000
UPDATE `quest_template` SET `Flags` = 851968    WHERE `ID` = 27705; -- 0x000C0000 | 0x10000
UPDATE `quest_template` SET `Flags` = 134807552 WHERE `ID` = 27768; -- 0x08080000 | 0x10000
UPDATE `quest_template` SET `Flags` = 135069696 WHERE `ID` = 27773; -- 0x080C0000 | 0x10000

-- A-09: Blessing of the Green Dragonflight 27914 casts Teleport to Itharius on accept
DELETE FROM `spell_target_position` WHERE `id` = 87712 AND `effIndex` = 0;
INSERT INTO `spell_target_position` (`id`, `effIndex`, `target_map`, `target_position_x`, `target_position_y`, `target_position_z`, `target_orientation`) VALUES
(87712, 0, 0, -10450, -3823.38, 17.8718, 6.12);
INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`, `SourceSpellID`) VALUES (27914, 27773, 87712)
ON DUPLICATE KEY UPDATE `PrevQuestID` = 27773, `SourceSpellID` = 87712;

-- A-10: To Marshtide Watch / To Stonard after Blessing of the Green Dragonflight
INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`) VALUES (27870, 27914), (27871, 27914)
ON DUPLICATE KEY UPDATE `PrevQuestID` = VALUES(`PrevQuestID`);

-- A-11: Pool of Tears 27694 without the breadcrumb 27869; 27869 closes once 27694 is taken (D1: and no longer leads into it)
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 27694;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` = 27869;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 27869;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 27869, 0, 0, 47, 0, 27694, 1, 0, 0, 0, 0, '', 'The Dragon and the Temple - only while Pool of Tears is neither in the log nor rewarded (breadcrumb)');
