-- Blasted Lands: the three amulets, then the Amulet Ritual, in their order (Horde 25697-25700 in the Dreadmaul Furnace, Alliance
-- 26167-26170 in the Serpent's Coil).
-- Sourced: the order (wiki Template_Dreadmaul_Hold_quest_chain / Template_Nethergarde_Keep_quest_chain; comments 1059507 [+11] and
-- Dovzhenko [+4] on 25699: "Loramus will offer the 3 amulet quests" after Enhancing the Stone; wiki: the Alliance amulets follow the
-- Blood Ritual and lead to Time is Short, The Final Ritual follows the Altar of Storms); the givers (both TDBs: Loramus alone gives
-- the Horde amulets, Lynnore alone Loramus Thalipedes Awaits; Wazzik only takes You Are Rakh'likh, Demon in); the ritual completing
-- 25700 / 26170 (comments 473214 + reply, furiosul [+4]: "talk to Kasim and tell him you're ready before you can talk to Loramus and
-- complete the quest"; "she'll cast a spell on you and the quest will be marked as completed"); the Amulet Ritual on option 1 of
-- Kasim's menu (TDB 11613/1); the lines and their speakers (broadcast 41391 / 41392 Lynnore, female; 42217 / 42218 Kasim; languages
-- as the broadcast texts, as section C's Blood Ritual lines); spell 77581 Amulet Ritual ("binding the target to the lair of
-- Razelikh").
-- Ours: Lynnore's option also on option 1 (neither TDB has an Amulet option for her; the wiki gives its text), the option hidden once
-- the quest is complete (mask 8), and the credit to every player within 15 yd holding the quest (playerbots never choose gossip).
--
-- Shared rows (ruling K5): option 1, SmartAI ids 10-14 and creature_text groups 0 / 1 of Bloodmage Lynnore 7506 / Kasim Sharim 42298
-- are this file's; option 0 (the Blood Ritual), ids 0-9 and groups 2+ are section C's and are never deleted here. mop's old Amulet
-- Ritual rows 0-3 are deleted by their exact comments (C's file deletes ids 0-9 as well). The mask-8 conditions need SpecialFlags 2
-- on 25700 / 26170 (without it the quests are complete on accept): keep them in one file.

-- Prerequisites: all three amulets after Enhancing the Stone (H) / the Blood Ritual (A); each leads to 25700 / 26163, which needs all
-- three (NextQuestID + negative ExclusiveGroup). No addon rows existed for the six
DELETE FROM `quest_template_addon` WHERE `ID` IN (25697,25698,25699,26167,26168,26169);
INSERT INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,
 `RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,`RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,
 `RequiredMinRepValue`,`RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`,`ScriptName`) VALUES
(25697,0,0,0,25693,25700,-25697,0,0,0,0,0,0,0,0,0,0,''),
(25698,0,0,0,25693,25700,-25697,0,0,0,0,0,0,0,0,0,0,''),
(25699,0,0,0,25693,25700,-25697,0,0,0,0,0,0,0,0,0,0,''),
(26167,0,0,0,26160,26163,-26167,0,0,0,0,0,0,0,0,0,0,''),
(26168,0,0,0,26160,26163,-26167,0,0,0,0,0,0,0,0,0,0,''),
(26169,0,0,0,26160,26163,-26167,0,0,0,0,0,0,0,0,0,0,'');
UPDATE `quest_template_addon` SET `PrevQuestID`=26162 WHERE `ID`=26170;
UPDATE `quest_template_addon` SET `SpecialFlags`=2 WHERE `ID` IN (25700,26170);

-- Givers neither TDB has: Lynnore for the Horde amulets, Loramus for 25700, Wazzik for 25701
DELETE FROM `creature_queststarter` WHERE (`id`=7506 AND `quest` IN (25697,25698,25699)) OR (`id`=7783 AND `quest`=25700)
 OR (`id`=41159 AND `quest`=25701);

-- The Amulet Ritual: option 1 of both menus while the quest is in progress
DELETE FROM `gossip_menu_option` WHERE (`MenuID`=11473 AND `OptionBroadcastTextID`=41390) OR (`MenuID`=11613 AND `OptionBroadcastTextID`=42216);
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,
 `ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(11473,1,0,'I would like to start the Amulet Ritual, Lynnore.',41390,1,1,0,0,0,0,NULL,0,0),
(11613,1,0,'I would like to start the Amulet Ritual, Kasim.',42216,1,1,0,0,0,0,NULL,0,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND ((`SourceGroup`=11473 AND `ConditionValue1`=25700)
 OR (`SourceGroup`=11613 AND `ConditionValue1`=26170));
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,
 `ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,11473,1,0,0,47,0,25700,8,0,0,0,0,'','Bloodmage Lynnore - Amulet Ritual while Loramus Thalipedes Awaits is incomplete'),
(15,11613,1,0,0,47,0,26170,8,0,0,0,0,'','Kasim Sharim - Amulet Ritual while The Final Ritual is incomplete');

UPDATE `creature_template` SET `AIName`='SmartAI', `ScriptName`='' WHERE `entry` IN (7506,42298);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (7506,42298) AND `source_type`=0 AND (`id` BETWEEN 10 AND 14
 OR (`id` BETWEEN 0 AND 3 AND `comment` IN ('Bloodmage Lynnore - On Gossip Select - Set Data Set Self','Bloodmage Lynnore - On Gossip Select - Close Gossip',
 'Bloodmage Lynnore - On Data Set Self - Say Line 0','Bloodmage Lynnore - On Text Over - Say Line 1','Kasim Sharim - On Gossip Select - Set Data Set Self',
 'Kasim Sharim - On Gossip Select - Close Gossip','Kasim Sharim - On Data Set Self - Say Line 0','Kasim Sharim - On Text Over - Say Line 1')));
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,
 `event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,
 `action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,
 `target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(7506,0,10,11,62,0,100,0,11473,1,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - On Amulet Ritual option - Close Gossip'),
(7506,0,11,12,61,0,100,0,0,0,0,0,0,11,77581,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - Linked - Cast Amulet Ritual on invoker'),
(7506,0,12,13,61,0,100,0,0,0,0,0,0,15,25700,0,0,0,0,0,17,0,15,0,0,0,0,0,0,'Bloodmage Lynnore - Linked - Complete Loramus Thalipedes Awaits within 15 yd'),
(7506,0,13,0,61,0,100,0,0,0,0,0,0,1,0,5000,0,0,0,0,7,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - Linked - Say Line 0'),
(7506,0,14,0,52,0,100,0,0,7506,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Bloodmage Lynnore - On Text 0 Over - Say Line 1'),
(42298,0,10,11,62,0,100,0,11613,1,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Kasim Sharim - On Amulet Ritual option - Close Gossip'),
(42298,0,11,12,61,0,100,0,0,0,0,0,0,11,77581,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Kasim Sharim - Linked - Cast Amulet Ritual on invoker'),
(42298,0,12,13,61,0,100,0,0,0,0,0,0,15,26170,0,0,0,0,0,17,0,15,0,0,0,0,0,0,'Kasim Sharim - Linked - Complete The Final Ritual within 15 yd'),
(42298,0,13,0,61,0,100,0,0,0,0,0,0,1,0,5000,0,0,0,0,7,0,0,0,0,0,0,0,0,'Kasim Sharim - Linked - Say Line 0'),
(42298,0,14,0,52,0,100,0,0,42298,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Kasim Sharim - On Text 0 Over - Say Line 1');

DELETE FROM `creature_text` WHERE `CreatureID` IN (7506,42298) AND `GroupID` IN (0,1);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,
 `BroadcastTextId`,`TextRange`,`comment`) VALUES
(7506,0,0,'With the power within the amulets of Razelikh...',12,1,100,0,0,0,0,41391,0,'Bloodmage Lynnore - Amulet Ritual 1'),
(7506,1,0,'... I bind you to his lair!',12,1,100,0,0,0,0,41392,0,'Bloodmage Lynnore - Amulet Ritual 2'),
(42298,0,0,'With the power within the amulets of Razelikh...',12,7,100,0,0,0,0,42217,0,'Kasim Sharim - Amulet Ritual 1'),
(42298,1,0,'... I bind you to his lair!',12,7,100,0,0,0,0,42218,0,'Kasim Sharim - Amulet Ritual 2');
