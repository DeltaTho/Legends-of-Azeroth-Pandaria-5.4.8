-- Razor Hill: Runda's profession menus get their "Train me in <profession>." shortcuts.
--
-- 47418 Runda <Profession Trainer> (npcflag GOSSIP|TRAINER, 106 npc_trainer rows) opens menu 12180, which in mop had only
-- "Tell me about gathering / production professions". Correction of the dossier (V2 "trains nobody"): she does train;
-- the submenus "Tell me about Herbalism" etc. (12188-12199) each carry an unconditioned "Train me in X." option
-- (OptionType 5) that opens her trainer list. What was missing is the first-page shortcut.
-- Sourced, both TDBs: menus 12180, 12185 and 12186 each have options 0-10 "Train me in <profession>." (trainer icon),
-- each shown only while the player has that skill (conditions 15, CONDITION_SKILL >= 1). Broadcast texts 47109-47119
-- are mop's (5.4.8). OptionType 5 (GOSSIP_OPTION_TRAINER) opens SendTrainerList; OptionNpcflag 16 (TRAINER) matches
-- her npcflag (Player::PrepareGossipMenu shows an option only when OptionNpcflag & npcflag).
-- Menu 12180 is shared (here as in the TDBs) by ten other starting-area Profession Trainers (Lien Farner, Wembil Taskwidget,
-- Nedric and Therisa Sallow, Lalum Darkmane, Iranis Shadebloom, Saren, Valn, Jack Derrington, Elder Oakpaw; all
-- npcflag TRAINER, 106 trainer spells each, Oakpaw 76): they get the same shortcuts.
-- trainer_type: Runda and nine of the others had trainer_type 0 (TRAINER_TYPE_CLASS) with trainer_class 0, so every
-- OptionType 5 option they show logged "GOSSIP_OPTION_TRAINER:: ... wrong class" to sql.sql (Player::PrepareGossipMenu,
-- Player.cpp:15636-15640; the existing submenu options already did). Set to 2 (TRAINER_TYPE_TRADESKILLS), as mop's 528
-- other profession trainers and Elder Oakpaw. The field is read nowhere else but Creature::isCanTrainingAndResetTalentsOf
-- (class trainers only; false for these before and after). One spawn each, Derrington three. Ours (mop's convention).
-- Not changed: some submenu "Tell me about ... professions" options in mop have ActionMenuID 0 where the TDBs link the
-- menu (they close the window instead of navigating).

DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (12180,12185,12186) AND `OptionID` BETWEEN 0 AND 10;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`,
  `OptionNpcflag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(12180, 0, 3, 'Train me in Alchemy.', 47109, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 1, 3, 'Train me in Blacksmithing.', 47110, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 2, 3, 'Train me in Enchanting.', 47111, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 3, 3, 'Train me in Engineering.', 47119, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 4, 3, 'Train me in Herbalism.', 47112, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 5, 3, 'Train me in Inscription.', 47113, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 6, 3, 'Train me in Jewelcrafting.', 47114, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 7, 3, 'Train me in Leatherworking.', 47115, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 8, 3, 'Train me in Mining.', 47116, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 9, 3, 'Train me in Skinning.', 47117, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12180, 10, 3, 'Train me in Tailoring.', 47118, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 0, 3, 'Train me in Alchemy.', 47109, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 1, 3, 'Train me in Blacksmithing.', 47110, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 2, 3, 'Train me in Enchanting.', 47111, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 3, 3, 'Train me in Engineering.', 47119, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 4, 3, 'Train me in Herbalism.', 47112, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 5, 3, 'Train me in Inscription.', 47113, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 6, 3, 'Train me in Jewelcrafting.', 47114, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 7, 3, 'Train me in Leatherworking.', 47115, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 8, 3, 'Train me in Mining.', 47116, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 9, 3, 'Train me in Skinning.', 47117, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12185, 10, 3, 'Train me in Tailoring.', 47118, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 0, 3, 'Train me in Alchemy.', 47109, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 1, 3, 'Train me in Blacksmithing.', 47110, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 2, 3, 'Train me in Enchanting.', 47111, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 3, 3, 'Train me in Engineering.', 47119, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 4, 3, 'Train me in Herbalism.', 47112, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 5, 3, 'Train me in Inscription.', 47113, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 6, 3, 'Train me in Jewelcrafting.', 47114, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 7, 3, 'Train me in Leatherworking.', 47115, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 8, 3, 'Train me in Mining.', 47116, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 9, 3, 'Train me in Skinning.', 47117, 5, 16, 0, 0, 0, 0, '', 0, 0),
(12186, 10, 3, 'Train me in Tailoring.', 47118, 5, 16, 0, 0, 0, 0, '', 0, 0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (12180,12185,12186) AND `SourceEntry` BETWEEN 0 AND 10;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`,
  `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`,
  `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 12180, 0, 0, 0, 7, 0, 171, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Alchemy if the player has Alchemy'),
(15, 12180, 1, 0, 0, 7, 0, 164, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Blacksmithing if the player has Blacksmithing'),
(15, 12180, 2, 0, 0, 7, 0, 333, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Enchanting if the player has Enchanting'),
(15, 12180, 3, 0, 0, 7, 0, 202, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Engineering if the player has Engineering'),
(15, 12180, 4, 0, 0, 7, 0, 182, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Herbalism if the player has Herbalism'),
(15, 12180, 5, 0, 0, 7, 0, 773, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Inscription if the player has Inscription'),
(15, 12180, 6, 0, 0, 7, 0, 755, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Jewelcrafting if the player has Jewelcrafting'),
(15, 12180, 7, 0, 0, 7, 0, 165, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Leatherworking if the player has Leatherworking'),
(15, 12180, 8, 0, 0, 7, 0, 186, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Mining if the player has Mining'),
(15, 12180, 9, 0, 0, 7, 0, 393, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Skinning if the player has Skinning'),
(15, 12180, 10, 0, 0, 7, 0, 197, 1, 0, 0, 0, 0, '', 'Runda menu 12180: Train me in Tailoring if the player has Tailoring'),
(15, 12185, 0, 0, 0, 7, 0, 171, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Alchemy if the player has Alchemy'),
(15, 12185, 1, 0, 0, 7, 0, 164, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Blacksmithing if the player has Blacksmithing'),
(15, 12185, 2, 0, 0, 7, 0, 333, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Enchanting if the player has Enchanting'),
(15, 12185, 3, 0, 0, 7, 0, 202, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Engineering if the player has Engineering'),
(15, 12185, 4, 0, 0, 7, 0, 182, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Herbalism if the player has Herbalism'),
(15, 12185, 5, 0, 0, 7, 0, 773, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Inscription if the player has Inscription'),
(15, 12185, 6, 0, 0, 7, 0, 755, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Jewelcrafting if the player has Jewelcrafting'),
(15, 12185, 7, 0, 0, 7, 0, 165, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Leatherworking if the player has Leatherworking'),
(15, 12185, 8, 0, 0, 7, 0, 186, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Mining if the player has Mining'),
(15, 12185, 9, 0, 0, 7, 0, 393, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Skinning if the player has Skinning'),
(15, 12185, 10, 0, 0, 7, 0, 197, 1, 0, 0, 0, 0, '', 'Runda menu 12185: Train me in Tailoring if the player has Tailoring'),
(15, 12186, 0, 0, 0, 7, 0, 171, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Alchemy if the player has Alchemy'),
(15, 12186, 1, 0, 0, 7, 0, 164, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Blacksmithing if the player has Blacksmithing'),
(15, 12186, 2, 0, 0, 7, 0, 333, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Enchanting if the player has Enchanting'),
(15, 12186, 3, 0, 0, 7, 0, 202, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Engineering if the player has Engineering'),
(15, 12186, 4, 0, 0, 7, 0, 182, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Herbalism if the player has Herbalism'),
(15, 12186, 5, 0, 0, 7, 0, 773, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Inscription if the player has Inscription'),
(15, 12186, 6, 0, 0, 7, 0, 755, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Jewelcrafting if the player has Jewelcrafting'),
(15, 12186, 7, 0, 0, 7, 0, 165, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Leatherworking if the player has Leatherworking'),
(15, 12186, 8, 0, 0, 7, 0, 186, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Mining if the player has Mining'),
(15, 12186, 9, 0, 0, 7, 0, 393, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Skinning if the player has Skinning'),
(15, 12186, 10, 0, 0, 7, 0, 197, 1, 0, 0, 0, 0, '', 'Runda menu 12186: Train me in Tailoring if the player has Tailoring');

UPDATE `creature_template` SET `trainer_type` = 2 WHERE `entry` IN (47384,47396,47400,47418,47419,47420,47421,47431,48619,50247);
