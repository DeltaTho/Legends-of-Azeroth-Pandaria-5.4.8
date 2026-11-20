-- Northern Barrens: Mor'shan Caravan Pick-Up 29109, the caravan ride from the Crossroads to Dreadmist Camp and the Burning Blade
-- ambush there (ride 3 of zone_northern_barrens_caravans.cpp, which must ship with this file), and the captured cart of
-- Mor'shan Caravan Rescue 29110. Until now 29109 could not be completed (Rocco 52220 invisible to everyone, no option, no credit),
-- which blocked 29110, 29112 and 29111 (dossier B, 29109-1); three hostile Burning Blade Ambushers and an extra Balgor stood in
-- Nagala's camp (29109-2).
-- Sourced: Rocco's quest invisibility 80852 (type 18) and the cart's 83305 (type 19) are seen with the detections of the quest's
-- own id block, 96718 "Generic Quest Invisibility Detection 10" (type 18, 1000, AreaGroup 3000 = the Crossroads 380) while 29109
-- is in the log, and 96737 "... 11" (type 19, 1000, AreaGroup 3003 = Dreadmist Peak 384) from taking 29110 until 29112 is handed
-- in (E-1; that these are retail's rows is inferred from the id block, types and areas); the option "I'm ready. Let's go!"
-- (menu 12744 option 0, BT 50940, the wiki) with 29109 incomplete in the log (E-2); every line of the ride and the ambush in the
-- wiki's order (BT 50942 50943 50944 51151 51214 50945 51300 50968 50954 51303 Balgor, 50969 50971 Nagala, 50976 50970 50955
-- 50975 the ambushers); the ambushers' speakers by voice: 52274 is the female model (creature_model_info gender 1), so hers are
-- the two Text1 lines ("Quickly now! ... I take the supply cart!", "The fat one!"), the kidnapper 52275 (vehicle 1585, whose seat
-- carries Balgor) asks "Which one should I take?", 52276 greets (the brief had 52274 greet and ask). 96661 Burning Blade Net
-- (root + stun, no duration, death persistent) is not saved at logout (DONT_SAVE); the script also takes it off on every end.
-- The cart at the peak stands still (mop wandered 3 yd; E-6). Deleted: the ambush's sniff copies (Balgor 52227 netted, the three
-- ambushers; none in either TDB).
-- Inferred: 52209 Chief Caravan Kodo's VehicleId 1580 (mop and both TDBs 0; the only unassigned kodo-saddle vehicle beside
-- 415 / 422 / 1587, driver seat 9764 as the others, rider seat 9765 enterable and without a bar: "not attacked on this ride";
-- dossier U-2). Ours: TextRange 0.

-- E-1
DELETE FROM `spell_area` WHERE `spell` IN (96718,96737) AND `area` IN (380,384);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(96718,380,29109,29109,0,0,2,1,74,11),
(96737,384,29110,29112,0,0,2,1,74,11);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid`=310953 AND `id`=52310;

UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_giver' WHERE `entry`=52220;
UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_kodo', `VehicleId`=1580 WHERE `entry`=52209;
UPDATE `creature_template` SET `ScriptName`='npc_nb_dreadmist_ambusher' WHERE `entry` IN (52274,52275,52276);

DELETE FROM `spell_custom_attribute` WHERE `spell`=96661;
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(96661,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Burning Blade Net (29109 ambush): a player who logs out netted must not log in rooted and stunned');

-- E-2
DELETE FROM `gossip_menu_option` WHERE `MenuID`=12744 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(12744,0,0,'I''m ready. Let''s go!',50940,1,1,0,0,0,0,NULL,0,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=12744 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,12744,0,0,0,9,0,29109,0,0,0,0,0,'','Rocco Whipshank: ride option while Mor''shan Caravan Pick-Up is in the log'),
(15,12744,0,0,0,28,0,29109,0,0,1,0,0,'','Rocco Whipshank: ride option while Mor''shan Caravan Pick-Up is incomplete');

-- Lines (52227 groups 0-9, 52207 0-1, 52274 0-1, 52275 0, 52276 0)
DELETE FROM `creature_text` WHERE `CreatureID`=52227 AND `GroupID` BETWEEN 0 AND 9;
DELETE FROM `creature_text` WHERE `CreatureID`=52207 AND `GroupID` IN (0,1);
DELETE FROM `creature_text` WHERE `CreatureID`=52274 AND `GroupID` IN (0,1);
DELETE FROM `creature_text` WHERE `CreatureID` IN (52275,52276) AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT t.c, t.g, 0, IF(b.`Text`<>'',b.`Text`,b.`Text1`), 12, 0, 100, 0, 0, 0, 0, b.`ID`, 0, t.n
FROM (SELECT 52227 AS c, 0 AS g, 50942 AS bt, 'Balgor Whipshank - ride 3 boarding' AS n
      UNION ALL SELECT 52227, 1, 50943, 'Balgor Whipshank - ride 3 chatter 1'
      UNION ALL SELECT 52227, 2, 50944, 'Balgor Whipshank - ride 3 chatter 2'
      UNION ALL SELECT 52227, 3, 51151, 'Balgor Whipshank - ride 3 chatter 3'
      UNION ALL SELECT 52227, 4, 51214, 'Balgor Whipshank - ride 3 chatter 4'
      UNION ALL SELECT 52227, 5, 50945, 'Balgor Whipshank - ride 3 chatter 5'
      UNION ALL SELECT 52227, 6, 51300, 'Balgor Whipshank - ride 3 chatter 6'
      UNION ALL SELECT 52227, 7, 50968, 'Balgor Whipshank - ride 3 arrival at Dreadmist Camp'
      UNION ALL SELECT 52227, 8, 50954, 'Balgor Whipshank - ambush starts'
      UNION ALL SELECT 52227, 9, 51303, 'Balgor Whipshank - carried off'
      UNION ALL SELECT 52207, 0, 50969, 'Nagala Whipshank - greets Balgor'
      UNION ALL SELECT 52207, 1, 50971, 'Nagala Whipshank - Balgor carried off'
      UNION ALL SELECT 52274, 0, 50955, 'Burning Blade Ambusher (cart thief) - orders'
      UNION ALL SELECT 52274, 1, 50975, 'Burning Blade Ambusher (cart thief) - the fat one'
      UNION ALL SELECT 52275, 0, 50970, 'Burning Blade Ambusher (kidnapper) - which one'
      UNION ALL SELECT 52276, 0, 50976, 'Burning Blade Ambusher (greeter) - greetings') t
JOIN `broadcast_text` b ON b.`ID`=t.bt;
-- Nagala stands 46 yd from where the kodo stops (say range 40): her two lines are yells (ours)
UPDATE `creature_text` SET `Type`=14 WHERE `CreatureID`=52207 AND `GroupID` IN (0,1);
-- 52227's template kept the sniffed netted copy's UNIT_FLAG_STUNNED; the driver is netted only in the ambush (96661)
UPDATE `creature_template` SET `unit_flags`=`unit_flags`&~262144 WHERE `entry`=52227;

-- E-6
DELETE FROM `creature_addon` WHERE `guid` IN (303130,317260,317261,317262);
DELETE FROM `creature` WHERE (`id`=52227 AND `guid`=303130) OR (`id` IN (52274,52275,52276) AND `guid` IN (317260,317261,317262));
