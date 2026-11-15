-- Badlands, Tomb of the Watchers: The Sentinel's Game (27709 Alliance / 27886 Horde) - the data of the board script
-- npc_badlands_sentinels_game_start_pawn / npc_badlands_titan_game_piece / go_badlands_titan_slab (zone_badlands_titans.cpp).
--
-- Sourced: 86429 "Sentinel's Game: Summon Start Pawn" (the red statue 46397 on the marble slab, a 20-minute marker aura on the
--   player), the stone statues 46395 and the alcove statue 46398, BroadcastText 47074, the slab's menu 12171 / text 17115.
-- Ours: as the Warden's Game (2026_11_20_50): start on quest accept, the restart option, the marker not saved, clicks handled by
--   the script (the old spellclick row of 46395 cast the Warden's summon spell 86342); the placed statue 46397 turns too and
--   the script gives it the click; 46398 gets the piece script only so that it goes with its board.

DELETE FROM `spell_custom_attribute` WHERE `spell`=86429;
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(86429,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Sentinel''s Game: Summon Start Pawn - the board marker is not saved');

UPDATE `creature_template` SET `ScriptName`='npc_badlands_sentinels_game_start_pawn' WHERE `entry`=46397;
UPDATE `creature_template` SET `npcflag`=0, `ScriptName`='npc_badlands_titan_game_piece' WHERE `entry`=46395;
UPDATE `creature_template` SET `ScriptName`='npc_badlands_titan_game_piece' WHERE `entry`=46398;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=46395;

UPDATE `gameobject_template` SET `AIName`='', `ScriptName`='go_badlands_titan_slab' WHERE `entry`=206336;

DELETE FROM `gossip_menu_option` WHERE `MenuID`=12171 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(12171,0,0,'Place the statue down on the slab.',47074,1,1,0,0,0,0,'',0,0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=12171;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,12171,0,0,0,47,0,27709,8,0,0,0,0,'','Marble Slab restart - The Sentinel''s Game (Alliance) in progress'),
(15,12171,0,0,0,1,0,86429,1,0,1,0,0,'','Marble Slab restart - and no board out (no marker aura)'),
(15,12171,0,0,1,47,0,27886,8,0,0,0,0,'','Marble Slab restart - The Sentinel''s Game (Horde) in progress'),
(15,12171,0,0,1,1,0,86429,1,0,1,0,0,'','Marble Slab restart - and no board out (no marker aura)');
