-- Northern Barrens: Crossroads Caravan Delivery 13975, the caravan ride from Grol'dom Farm to the Crossroads (ride 2 of
-- zone_northern_barrens_caravans.cpp, which must ship with this file). Until now nobody could complete 13975: Rocco had no
-- option, nothing was summoned and nothing gave its credit 65892 (dossier B, 13975-1).
-- Sourced: the option "Bring it on, Rocco." (menu 10528 option 0, BT 34817, both TDBs) shown only with 13975 in the log and
-- incomplete (E-2); the turret "The Hotseat" 34582 (vehicle 424, a seat that controls and casts; its sniffed copy stood beside
-- the ride's kodo copy at the Crossroads) with the bar Shoot 66427 + Face Smash 65704 (the wiki: "click to shoot ... butt them
-- with the gun"; comment 2013-02 [+8]); Face Smash's script (spell_nb_caravan_face_smash: the nearest Burning Blade Raider within
-- 10 yd, ours, is knocked off his wolf with Hit Raider in the Face's 853 damage); Rocco BT 34818 / 35138 (comment 2011-01-02
-- [+3]); Balgor BT 35139 at the first raider and BT 34821 at the Crossroads (wiki 13975). 34431 group 3 is beyond plan 0.3's
-- 0-2 (the entry is S2's). Deleted: sniff copies of the ride's summons
-- (none in either TDB): the head kodo 34577 and the turret 34582 at the Crossroads' east edge, Balgor 34431 in the Crossroads,
-- the Burning Blade Raider 34594 on the road (scope I's fold-in).
-- Ours: TextRange 0; 51031 "Well here we are, back at the Crossroads" is not used (4.1 id block of rides 3-4, no source places it).

UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_giver' WHERE `entry`=34578;
UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_kodo' WHERE `entry`=34577;
UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_attacker_mount' WHERE `entry`=34593;
UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_attacker' WHERE `entry`=34594;
UPDATE `creature_template` SET `spell1`=66427, `spell2`=65704, `spell3`=0 WHERE `entry`=34582;

DELETE FROM `spell_script_names` WHERE `spell_id`=65704;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (65704,'spell_nb_caravan_face_smash');

-- E-2
DELETE FROM `gossip_menu_option` WHERE `MenuID`=10528 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(10528,0,0,'Bring it on, Rocco.',34817,1,1,0,0,0,0,NULL,0,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10528 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10528,0,0,0,9,0,13975,0,0,0,0,0,'','Rocco Whipshank: ride option while Crossroads Caravan Delivery is in the log'),
(15,10528,0,0,0,28,0,13975,0,0,1,0,0,'','Rocco Whipshank: ride option while Crossroads Caravan Delivery is incomplete');

-- Lines
DELETE FROM `creature_text` WHERE `CreatureID`=34578 AND `GroupID` IN (0,1);
DELETE FROM `creature_text` WHERE `CreatureID`=34431 AND `GroupID` IN (0,3);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT t.c, t.g, 0, IF(b.`Text`<>'',b.`Text`,b.`Text1`), 12, 0, 100, 0, 0, 0, 0, b.`ID`, 0, t.n
FROM (SELECT 34578 AS c, 0 AS g, 34818 AS bt, 'Rocco Whipshank - ride 2 option chosen' AS n
      UNION ALL SELECT 34578, 1, 35138, 'Rocco Whipshank - ride 2 under way'
      UNION ALL SELECT 34431, 0, 34821, 'Balgor Whipshank - ride 2 arrival'
      UNION ALL SELECT 34431, 3, 35139, 'Balgor Whipshank - ride 2 first Burning Blade raider') t
JOIN `broadcast_text` b ON b.`ID`=t.bt;

-- E-6
DELETE FROM `creature_addon` WHERE `guid` IN (369140,369141,302460,302662);
DELETE FROM `waypoint_data` WHERE `id`=369140;
DELETE FROM `creature` WHERE (`id`=34577 AND `guid`=369140) OR (`id`=34582 AND `guid`=369141) OR (`id`=34431 AND `guid`=302460) OR (`id`=34594 AND `guid`=302662);
