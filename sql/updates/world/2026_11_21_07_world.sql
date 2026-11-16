-- Searing Gorge A-12: Lunk Like Your Style 28053 after From Whence He Came 28062.
--
-- SOURCED: Wowhead comment 2011-03-27, grimesilt row 12 (confidence low, Q13). Ships in the same build as the 28062 AUTO_COMPLETE (R-15);
-- the Thorium Point Lunk window (88582) needs 28062 rewarded as well.
-- SHIP ORDER (R-15, coder B's lead): only in the same build as section E's 28062 AUTO_COMPLETE (E-10) and E-11, never before it.
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

DELETE FROM `quest_template_addon` WHERE `ID`=28053;
INSERT INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,`RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,`RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,`RequiredMinRepValue`,`RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`,`ScriptName`) VALUES
(28053,0,0,0,28062,0,0,0,0,0,0,0,0,0,0,0,0,'');
