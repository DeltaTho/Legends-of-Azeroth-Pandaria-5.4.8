-- Zone 46 (Burning Steppes) rows from the Swamp of Sorrows pass; held out of its first build, shipped 2026-11-20 when the
-- user found no way to start the ride.
-- DEPLOY: applied to a running server this needs a worldserver RESTART, not a reload: a script object is kept only if its
-- ScriptName is in the DB at startup (ScriptMgr), so npc_sos_sharon_boomgetter is dropped while this file is held.
--
-- Burning Steppes, Sharon Boomgetter 48948 (sniffed 165434, the south-east corner): "Alright!  Let's head down to the Swamp of
-- Sorrows!" starts the Bogpaddle Bullet rocket ride to Bogpaddle (npc_sos_sharon_boomgetter in zone_swamp_of_sorrows_bullet.cpp,
-- with the rocket of 2026_11_23_90).
--
-- Sourced: the option text and BroadcastText 49049 as both TDBs (menu 12464, option 0, no action, no condition); her greeting
--   npc_text 17532 (BT 49048) "Need a ride, sugar? Hop on. We're headed down to Bogpaddle, and it's a one way trip." is already
--   there; the quest texts of 28569 / 28570 send the player to her to ride the Bogpaddle Bullet. No quest gate: neither TDB has
--   a condition on the menu, and comments send holders of the capital boards' Hero's Call / Warchief's Command to her as well
--   (28675, 2013-10-29 [+12]).
-- Ours: OptionType 1 / OptionNpcflag 1 (an option with OptionNpcflag 0 is never shown here: _core-issues C42); the ScriptName
--   (no TDB has SmartAI or a script for her). The script gives no rocket to a bot, nor to a player who is dead, in combat, on a
--   taxi or already on a vehicle.

UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_sos_sharon_boomgetter' WHERE `entry` = 48948;

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 12464;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcflag`, `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(12464, 0, 0, 'Alright!  Let''s head down to the Swamp of Sorrows!', 49049, 1, 1, 0, 0, 0, 0, '', 0, 0);
