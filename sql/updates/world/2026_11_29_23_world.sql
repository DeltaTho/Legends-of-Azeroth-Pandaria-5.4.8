-- Northern Barrens: Mor'shan Caravan Delivery 29111, the armoured caravan from Dreadmist Camp to the Mor'shan Rampart (ride 4 of
-- zone_northern_barrens_caravans.cpp, which must ship with this file). Until now nobody could complete 29111: Nagala had no
-- option, nothing was summoned and nothing gave 52505 / 52326 (dossier B, 29111-1).
-- Sourced: the option "I'm ready to ride." (menu 12754 option 0, BT 50996, the wiki) with 29111 incomplete in the log (E-2;
-- Nagala's text window 17900 / 17901 is S1's); the Master Caravan Kodo's bar Shoot 96791, Face Smash 96792, Spiral Barrage
-- 96961 ("A powerful rocket attack to take down aerial units": the rocket of the comments; E-4) on its seat 9784, which charms
-- the kodo (CAN_CONTROL + CAN_CAST); Face Smash's script (the nearest Burning Blade Attacker within 10 yd, ours, knocked off his
-- wolf with Hit Raider in the Face's 2441 damage); Balgor's lines BT 51228 51004 51230 51233 51229 51231 51226 (the wiki; 51004
-- "They've spotted us!" is inferred into the first wave). The kodo's spellclick row 65466 goes: a player's click with it would
-- seat him in seat 0 and throw Balgor off (Vehicle::AddPassenger ejects a named seat's passenger; E-7), and the script seats
-- both. Deleted: the ride's sniff copies (none in either TDB): the kodo 52314, the cart 52316, the attack controller 52334,
-- Balgor 52333, the four chase targets 52336 52370 52388 52391, and 26 hostile Burning Blade Attackers 52338 along the Mor'shan
-- road (scope I's fold-in; 310992, the one both TDBs have beside Windrider 302661, stays).
-- Ours: TextRange 0.

UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_giver' WHERE `entry`=52207;
UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_kodo', `spell1`=96791, `spell2`=96792, `spell3`=96961 WHERE `entry`=52314;
UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_attacker_mount' WHERE `entry` IN (52337,52385);
UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_attacker' WHERE `entry` IN (52338,52386);
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=52314 AND `spell_id`=65466;
UPDATE `creature_template` SET `npcflag`=`npcflag`&~16777216 WHERE `entry`=52314;   -- no row, no click cursor

DELETE FROM `spell_script_names` WHERE `spell_id`=96792;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (96792,'spell_nb_caravan_face_smash');

-- E-2
DELETE FROM `gossip_menu_option` WHERE `MenuID`=12754 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(12754,0,0,'I''m ready to ride.',50996,1,1,0,0,0,0,NULL,0,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=12754 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,12754,0,0,0,9,0,29111,0,0,0,0,0,'','Nagala Whipshank: ride option while Mor''shan Caravan Delivery is in the log'),
(15,12754,0,0,0,28,0,29111,0,0,1,0,0,'','Nagala Whipshank: ride option while Mor''shan Caravan Delivery is incomplete');

-- Lines (52333 groups 0-6)
DELETE FROM `creature_text` WHERE `CreatureID`=52333 AND `GroupID` BETWEEN 0 AND 6;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT 52333, t.g, 0, IF(b.`Text`<>'',b.`Text`,b.`Text1`), 12, 0, 100, 0, 0, 0, 0, b.`ID`, 0, t.n
FROM (SELECT 0 AS g, 51228 AS bt, 'Balgor Whipshank - ride 4 boarding' AS n
      UNION ALL SELECT 1, 51004, 'Balgor Whipshank - ride 4 first wave'
      UNION ALL SELECT 2, 51230, 'Balgor Whipshank - ride 4 first flier'
      UNION ALL SELECT 3, 51233, 'Balgor Whipshank - ride 4 attacker killed'
      UNION ALL SELECT 4, 51229, 'Balgor Whipshank - ride 4 half way'
      UNION ALL SELECT 5, 51231, 'Balgor Whipshank - ride 4 almost there'
      UNION ALL SELECT 6, 51226, 'Balgor Whipshank - ride 4 arrival') t
JOIN `broadcast_text` b ON b.`ID`=t.bt;

-- E-6
DELETE FROM `creature_addon` WHERE `guid` IN (317265,317267,317266,310978,310982,310983,310984,310985,310972)
    OR (`guid` BETWEEN 310986 AND 311011 AND `guid`<>310992);
DELETE FROM `waypoint_data` WHERE `id` IN (317265,310982,310983,310984,310985);
DELETE FROM `creature` WHERE (`id`=52314 AND `guid`=317265) OR (`id`=52316 AND `guid`=317267) OR (`id`=52334 AND `guid`=317266)
    OR (`id`=52333 AND `guid`=310978) OR (`id` IN (52336,52370,52388,52391) AND `guid` IN (310982,310983,310984,310985))
    OR (`id`=52338 AND (`guid`=310972 OR (`guid` BETWEEN 310986 AND 311011 AND `guid`<>310992)));
