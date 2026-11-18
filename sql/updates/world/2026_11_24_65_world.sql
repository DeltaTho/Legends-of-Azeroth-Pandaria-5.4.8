-- Blasted Lands, 25707 The Future of the Rockpool: the data of the crate drag (the behaviour is
-- src/server/scripts/EasternKingdoms/zone_blasted_lands_rockpool.cpp, ScriptNames in 2026_11_24_66).
-- Sourced: log hand-in (Flags 0x10000: TDB 4.4.2 has 0x1D0000, TDB 12.1.0 0x190000, both with 0x10000; wiki
-- "end=Automatic"); no "!" over the crate, started by talking to it once Atrocities is handed in (quest 25707 comments
-- 2010-11-24 [+76], 2014-05-04 [+6], the reply to 2010-12-03; wiki notes): the comments justify deleting the crate's
-- quest-starter row, which both TDBs keep; npcflag gossip only and no IMMUNE_TO_PC (both TDBs); the gossip texts 16059 / 16060
-- / 16231 and options 0-2 (wiki notes, broadcast texts 41363-41366, 42289, 42290); three tadpoles on each crate (TDB triplets
-- of 41385 at +1.55 yd = seats 1-3 of vehicle 820); the fourth crate spot (TDB 4.4.2 guid 300608, 60.2 64.8).
-- mop-only data, design ours: the crate adrift 41454 and its vehicle 824 (neither TDB spawns it; its seats fit the comments'
-- crate floating off with the tadpoles), and the three tadpoles seated on it.
-- Ours: the 46598 spellclick rows conditioned to the tadpole entry (they seat the accessories, Vehicle::InstallAccessory, and
-- hide the spellclick flag from players so a right-click opens the gossip, Player::CanSeeSpellClickOn); 77549's area effect
-- limited to the crate entry (condition 13; the script further limits it to the crate talked to); the marker aura of 77549
-- not saved at logout (DONT_SAVE).
UPDATE `quest_template` SET `Flags` = 1900544 WHERE `ID` = 25707;                           -- 0x1C0000 | 0x10000 (4.4.2 0x1D0000, 12.1.0 0x190000)
DELETE FROM `creature_queststarter` WHERE `id` = 41402 AND `quest` = 25707;                 -- started by 77549 QUEST_START from the gossip
UPDATE `creature_template` SET `npcflag` = 1, `unit_flags` = 0 WHERE `entry` = 41402;       -- both TDBs (mop 3 / 0x100)

DELETE FROM `gossip_menu` WHERE `MenuID` = 11507 AND `TextID` = 16231;
INSERT INTO `gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES (11507, 16231, 0);
UPDATE `gossip_menu_option` SET `OptionNpcflag` = 1 WHERE `MenuID` = 11507 AND `OptionID` IN (0, 1, 2);   -- 0 hid them
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` IN (14, 15) AND `SourceGroup` = 11507;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(14, 11507, 16060, 0, 0, 47, 0, 25703, 64, 0, 0, 0, 0, '', 'Abandoned Bloodwash Crate - offer text once Atrocities is rewarded'),
(14, 11507, 16060, 0, 0, 47, 0, 25707,  1, 0, 0, 0, 0, '', 'Abandoned Bloodwash Crate - offer text while 25707 was never taken'),
(14, 11507, 16231, 0, 0, 47, 0, 25707,  8, 0, 0, 0, 0, '', 'Abandoned Bloodwash Crate - dropped-crate text while 25707 is incomplete'),
(15, 11507, 0, 0, 0, 47, 0, 25703, 64, 0, 0, 0, 0, '', 'Help the Rockpool tadpoles - Atrocities rewarded'),
(15, 11507, 0, 0, 0, 47, 0, 25707,  1, 0, 0, 0, 0, '', 'Help the Rockpool tadpoles - 25707 never taken'),
(15, 11507, 1, 0, 0, 47, 0, 25703, 64, 0, 0, 0, 0, '', 'Leave them - Atrocities rewarded'),
(15, 11507, 1, 0, 0, 47, 0, 25707,  1, 0, 0, 0, 0, '', 'Leave them - 25707 never taken'),
(15, 11507, 2, 0, 0, 47, 0, 25707,  8, 0, 0, 0, 0, '', 'Continue helping the Rockpool tadpoles - 25707 incomplete');

-- three Rockpool Tadpoles 41385 on the abandoned crate and on the one adrift
DELETE FROM `vehicle_template_accessory` WHERE `entry` IN (41402, 41454);
INSERT INTO `vehicle_template_accessory` (`entry`, `accessory_entry`, `seat_id`, `minion`, `description`, `summontype`, `summontimer`) VALUES
(41402, 41385, 1, 1, 'Abandoned Bloodwash Crate - Rockpool Tadpole', 6, 30000),
(41402, 41385, 2, 1, 'Abandoned Bloodwash Crate - Rockpool Tadpole', 6, 30000),
(41402, 41385, 3, 1, 'Abandoned Bloodwash Crate - Rockpool Tadpole', 6, 30000),
(41454, 41385, 1, 1, 'Abandoned Bloodwash Crate (adrift) - Rockpool Tadpole', 6, 30000),
(41454, 41385, 2, 1, 'Abandoned Bloodwash Crate (adrift) - Rockpool Tadpole', 6, 30000),
(41454, 41385, 3, 1, 'Abandoned Bloodwash Crate (adrift) - Rockpool Tadpole', 6, 30000);
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (41402, 41454) AND `spell_id` = 46598;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES (41402, 46598, 1, 0), (41454, 46598, 1, 0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` IN (41402, 41454) AND `SourceEntry` = 46598;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(18, 41402, 46598, 0, 0, 31, 0, 3, 41385, 0, 0, 0, 0, '', 'Abandoned Bloodwash Crate - only its tadpoles ride by click (players get the gossip)'),
(18, 41454, 46598, 0, 0, 31, 0, 3, 41385, 0, 0, 0, 0, '', 'Abandoned Bloodwash Crate (adrift) - only its tadpoles ride by click');

-- 77549 The Future of the Rockpool: Quest Launch: its CONTROL_VEHICLE effect (1) boards only an Abandoned Bloodwash Crate
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 77549;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 2, 77549, 0, 0, 31, 0, 3, 41402, 0, 0, 0, 0, '', 'The Future of the Rockpool: Quest Launch - board only an Abandoned Bloodwash Crate');
DELETE FROM `spell_custom_attribute` WHERE `spell` = 77549;
INSERT INTO `spell_custom_attribute` (`spell`, `attribute`, `comment`) VALUES
(77549, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'The Future of the Rockpool: Quest Launch - the dragging marker does not outlive a logout');

-- the fourth crate (TDB 4.4.2 guid 300608, the hills right of the cave), idle
DELETE FROM `creature` WHERE `guid` = 3138800;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `phaseId`, `phaseGroup`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawntimesecs_max`, `wander_distance`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`, `unit_flags2`, `dynamicflags`, `ScriptName`, `walk_mode`, `VerifiedBuild`) VALUES
(3138800, 41402, 0, 4, 4, 1, 1, 0, 0, 37201, 0, -12159.8, -3398.46, 46.4699, 4.66003, 60, 0, 0, 0, 2784, 0, 0, 0, 0, 0, 0, 0, '', 0, 0);
