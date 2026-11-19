-- Orgrimmar, Cleft of Shadow: Neeru Fireblade 3216 (ender of Neeru Fireblade 25263, giver of Ak'Zeloth 25264) showed the
-- pre-Cataclysm Hidden Enemies option "You may speak frankly, Neeru..." (menu 3701 option 0) to every player, leading into the
-- old Burning Blade dialogue (menus 21272 / 50010). Both TDBs show it only with the Lieutenant's Insignia 14544 in the bags (a
-- quest drop of the retired Hidden Enemies 5726-5730, which have no starter in mop), and have no options 1 and 2: option 1 is a
-- Darkshore NPC's "Tharnariun, I have lost the trap..." (conditioned on the Alliance quest 2118, which nobody gives), option 2 a
-- second "speak frankly" conditioned on 5727 taken (which nobody can take). Plan ruling R7: shipped with this zone.
-- Sourced: TDB 4.4.2 and 12.1.0 gossip_menu_option 3701 (option 0 only) and conditions (15, 3701, 0: item 14544 x1).
-- What the player sees: Neeru's greeting and his quests only.

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 3701 AND `OptionID` IN (1, 2);
DELETE FROM `gossip_menu_option_locale` WHERE `MenuID` = 3701 AND `OptionID` IN (1, 2);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 3701;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
 `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 3701, 0, 0, 0, 2, 0, 14544, 1, 0, 0, 0, 0, '', 'Neeru Fireblade - Hidden Enemies option only with the Lieutenant''s Insignia (both TDBs)');
