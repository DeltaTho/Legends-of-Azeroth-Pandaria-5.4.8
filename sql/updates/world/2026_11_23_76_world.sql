-- Swamp of Sorrows, the Baron's Cannons: In With a Bang 27600 (Lil' Crazy Jerry to the frigate), Baba Bogbrew 27740 (Lil' Crazy
-- Daisy across the zone to Baba Bogbrew) and the frigate's Landward Cannon (back to shore). Without Jerry's option 27600 cannot be
-- done below flying level (no way aboard from the water).
-- Sourced: the three options' texts and broadcast texts (menus 12099 / 12132 / 12292, both TDBs); the summon spells 85565 / 86685 /
--   88633 and their cannons 45873 / 46504 / 47538 (DBC); 47538 'The Baron's Cannon' is vehicle 1151.
-- Ours: the conditions (Jerry's option while In With a Bang is in the log, Daisy's while Baba Bogbrew is: mask 10, 27740 is complete
--   on accept; the Landward Cannon for anyone); OptionNpcflag 1 (this core filters creature options by it); VehicleId 1151 on
--   45873 / 46504 (0 in mop and both TDBs, unsniffed); the condition that names the Landward Cannon for 88633's
--   TARGET_DEST_NEARBY_ENTRY; the ScriptNames (zone_swamp_of_sorrows_bogpaddle.cpp: the hold, the shot, the landing).

DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (12099, 12132, 12292);
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcflag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(12099, 0, 0, 'Load me into that cannon, boy!', 46336, 1, 1, 0, 0, 0, 0, '', 0, 0),
(12132, 0, 0, 'Your dad says to fire me across the bay.', 46892, 1, 1, 0, 0, 0, 0, '', 0, 0),
(12292, 0, 0, 'I''ll get in and fire it! What could go wrong?', 47776, 1, 1, 0, 0, 0, 0, '', 0, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (12099, 12132, 12292);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 12099, 0, 0, 0, 47, 0, 27600, 10, 0, 0, 0, 0, '', 'Lil'' Crazy Jerry - cannon option while In With a Bang is in the log'),
(15, 12132, 0, 0, 0, 47, 0, 27740, 10, 0, 0, 0, 0, '', 'Lil'' Crazy Daisy - cannon option while Baba Bogbrew is in the log');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 88633;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 88633, 0, 0, 31, 0, 5, 206679, 0, 0, 0, 0, '', 'Summon Baron''s Cannon Bunny (Ship to Shore) - at the Landward Cannon');

UPDATE `creature_template` SET `VehicleId` = 1151 WHERE `entry` IN (45873, 46504);
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_bogpaddle_barons_cannon' WHERE `entry` IN (45873, 46504, 47538);
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_bogpaddle_cannon_kid' WHERE `entry` IN (46245, 46503);
UPDATE `gameobject_template` SET `AIName` = '', `ScriptName` = 'go_bogpaddle_landward_cannon' WHERE `entry` = 206679;
