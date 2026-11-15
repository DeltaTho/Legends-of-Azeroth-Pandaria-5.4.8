-- Badlands, Tomb of the Watchers: The Warden's Game (27693 Alliance / 27885 Horde) - the data of the board script
-- npc_badlands_wardens_game_controller / npc_badlands_titan_game_piece / go_badlands_titan_slab (zone_badlands_titans.cpp).
--
-- Sourced: 86343 "Warden's Game: Summon Controller" (46339 on the stone slab at its spell_target_position, a 20-minute marker
--   aura on the player), the eight Warden's Pawns 46344, BroadcastText 47074 "Place the statue down on the slab." (a gossip
--   text no menu used), the slab's menu 12172 / text 17116.
-- Ours: the slab lays the board out on quest accept and offers the restart option while the Game is in the log and the player
--   has no marker, i.e. no board out (after a logout or the 20-minute expiry; the slab's script puts the marker back when the
--   player returns to a board still out after walking out of the tomb, whose AreaGroup strips it, or dying, and drops it when
--   his board vanished without its end path, before this condition is read); the marker is not saved, so after a relog it
--   cannot claim a board that went with the logout (Aura::CanBeSaved would save this dummy aura); the click on a pawn is
--   handled by the script (the old spellclick row cast 86342, the summon spell, which would only have made more pawns), so the
--   template's spellclick flag goes too (a flag without a row is stripped at load) and the script sets it on its own pawns.

DELETE FROM `spell_custom_attribute` WHERE `spell`=86343;
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(86343,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Warden''s Game: Summon Controller - the board marker is not saved');

UPDATE `creature_template` SET `ScriptName`='npc_badlands_wardens_game_controller' WHERE `entry`=46339;
UPDATE `creature_template` SET `npcflag`=0, `ScriptName`='npc_badlands_titan_game_piece' WHERE `entry`=46344;
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=46344;

UPDATE `gameobject_template` SET `AIName`='', `ScriptName`='go_badlands_titan_slab' WHERE `entry`=206335;

DELETE FROM `gossip_menu_option` WHERE `MenuID`=12172 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(12172,0,0,'Place the statue down on the slab.',47074,1,1,0,0,0,0,'',0,0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=12172;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,12172,0,0,0,47,0,27693,8,0,0,0,0,'','Stone Slab restart - The Warden''s Game (Alliance) in progress'),
(15,12172,0,0,0,1,0,86343,1,0,1,0,0,'','Stone Slab restart - and no board out (no marker aura)'),
(15,12172,0,0,1,47,0,27885,8,0,0,0,0,'','Stone Slab restart - The Warden''s Game (Horde) in progress'),
(15,12172,0,0,1,1,0,86343,1,0,1,0,0,'','Stone Slab restart - and no board out (no marker aura)');
