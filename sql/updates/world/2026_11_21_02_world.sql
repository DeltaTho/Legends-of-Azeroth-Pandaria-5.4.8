-- Searing Gorge A-5, A-6, A-7, A-9, A-10, A-11: Grimesilt prerequisites, Ash Chicken click condition, drops.
--
-- SOURCED: gate G1 / R-1 (27965 after 27964 by PrevQuestID, 27957 by condition, no negative group), both TDBs (27961/27962 after 27960;
-- 27958 after 27957; Flywheel 100 % x2-4; venom 100 %), Wowhead comments 2010-12-04/10, 2011-09-13, 2014-09-02. OURS: the condition form
-- of the 27965 gate; the Ash Chicken spellclick condition (quest taken, incomplete); 27957 reward spell as a display spell (C21).
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

-- SP1 (R-1): 27965 needs Dig-Boss Dinwhisker (PrevQuestID) and Lunk No Kill (condition); no negative group anywhere.
DELETE FROM `quest_template_addon` WHERE `ID` IN (27957,27965);
INSERT INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,`RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,`RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,`RequiredMinRepValue`,`RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`,`ScriptName`) VALUES
(27957,0,0,0,27956,0,0,0,0,0,0,0,0,0,0,0,0,''),
(27965,0,0,0,27964,0,0,0,0,0,0,0,0,0,0,0,0,'');
UPDATE `quest_template_addon` SET `NextQuestID`=0, `ExclusiveGroup`=0 WHERE `ID`=27964;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=19 AND `SourceGroup`=0 AND `SourceEntry`=27965;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,27965,0,0,8,0,27957,0,0,0,0,0,'','Thorium Point: The Seat of the Brotherhood - only after Lunk No Kill');
-- F-BUR-1: Out of Place and A Lumbering Relic follow The Fewer, the Better (both TDBs; Wowhead 2014-09-02).
DELETE FROM `quest_template_addon` WHERE `ID` IN (27961,27962);
INSERT INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,`RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,`RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,`RequiredMinRepValue`,`RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`,`ScriptName`) VALUES
(27961,0,0,0,27960,0,0,0,0,0,0,0,0,0,0,0,0,''),
(27962,0,0,0,27960,0,0,0,0,0,0,0,0,0,0,0,0,'');
-- F-BUR-2: only players on Out of Place can pick up Ash Chickens (ours; quest collectible).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceGroup`=47278 AND `SourceEntry`=90102;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,47278,90102,0,0,9,0,27961,0,0,0,0,0,'','Ash Chicken - spellclick only while Out of Place is incomplete');
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100, `mincountOrRef`=2, `maxcount`=4 WHERE `entry`=5853 AND `item`=62805;
UPDATE `quest_template` SET `RewardDisplaySpell`=88212, `RewardSpell`=0 WHERE `ID`=27957;
DELETE FROM `quest_template_addon` WHERE `ID`=27958;
INSERT INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,`RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,`RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,`RequiredMinRepValue`,`RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`,`ScriptName`) VALUES
(27958,0,0,0,27957,0,0,0,0,0,0,0,0,0,0,0,0,'');
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100 WHERE `entry`=5856 AND `item`=62809;
