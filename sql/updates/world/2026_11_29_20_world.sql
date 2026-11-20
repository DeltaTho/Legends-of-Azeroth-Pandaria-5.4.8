-- Northern Barrens: Crossroads Caravan Pickup 13949, the caravan ride from Far Watch Post to Grol'dom Farm (ride 1 of
-- zone_northern_barrens_caravans.cpp, which must ship with this file: a new ScriptName needs a restart).
-- Sourced: Halga's option 10514/0 (both TDBs) shown only with 13949 in the log and incomplete (dossier B, E-2); her SmartAI gave
-- 13949's credit on the spot and goes (E-3, her C++ gossip starts the ride); the turret "Riding Shotgun" 34438 carries the
-- rider and its bar is Shoot 65479 ("Reduce your target to pulp.", comments 2010-11 / 2011-01): the brief put Shoot on the kodo
-- (E-4), but a passenger who does not control his vehicle cannot cast its spells in this core, and 34438 (vehicle 418: one seat
-- that controls and casts, sitting 2.2 yd down onto a kodo saddle) has three sniffed copies exactly at 65486's summon spot;
-- the lines Halga BT 34630 / 34626 (the wiki; 2011-01-16 [+4]), the emote "Defend the Caravan Kodo!" BT 34625 (wiki: emote;
-- given to Balgor as a boss whisper to the rider, ours) and Balgor's arrival line BT 34667 (wiki 13949). The statics deleted below are sniff copies of the ride's summons (none in either TDB; Wowhead pins show
-- them moving with the caravan): the lead kodo 34430, the pack kodo 34432, the three turrets 34438, and the 27 hostile
-- Razormane Raiders 34487 patrolling the road for everybody (65496's summons; E-6 and scope I's fold-in).
-- Ours: TextRange 0 (heard by all nearby).

-- E-3 Halga's shortcut
DELETE FROM `smart_scripts` WHERE `entryorguid`=34258 AND `source_type`=0;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_nb_caravan_giver' WHERE `entry`=34258;

UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_kodo' WHERE `entry`=34430;
UPDATE `creature_template` SET `ScriptName`='npc_nb_caravan_attacker' WHERE `entry`=34487;
UPDATE `creature_template` SET `spell1`=65479, `spell2`=0, `spell3`=0 WHERE `entry`=34438;

-- E-2 the ride option only with the quest incomplete in the log
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10514 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10514,0,0,0,9,0,13949,0,0,0,0,0,'','Halga Bloodeye: ride option while Crossroads Caravan Pickup is in the log'),
(15,10514,0,0,0,28,0,13949,0,0,1,0,0,'','Halga Bloodeye: ride option while Crossroads Caravan Pickup is incomplete');

-- Lines
DELETE FROM `creature_text` WHERE `CreatureID`=34258 AND `GroupID` IN (0,1);
DELETE FROM `creature_text` WHERE `CreatureID`=34431 AND `GroupID` IN (1,2);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT t.c, t.g, 0, IF(b.`Text`<>'',b.`Text`,b.`Text1`), 12, 0, 100, 0, 0, 0, 0, b.`ID`, 0, t.n
FROM (SELECT 34258 AS c, 0 AS g, 34630 AS bt, 'Halga Bloodeye - ride 1 option chosen' AS n
      UNION ALL SELECT 34258, 1, 34626, 'Halga Bloodeye - ride 1 under way'
      UNION ALL SELECT 34431, 1, 34625, 'Balgor Whipshank - rides 1 and 2 boarding (boss whisper to the rider)'
      UNION ALL SELECT 34431, 2, 34667, 'Balgor Whipshank - ride 1 arrival') t
JOIN `broadcast_text` b ON b.`ID`=t.bt;
-- "Defend the Caravan Kodo!" is an emote (wiki 13949) / a boss emote (13975): shown to the rider as a boss whisper (ours)
UPDATE `creature_text` SET `Type`=42 WHERE `CreatureID`=34431 AND `GroupID`=1;

-- E-6 sniff copies of the ride's summons
DELETE FROM `creature_addon` WHERE `guid` IN (310970,310967,310966,310969,310971) OR `guid` BETWEEN 303096 AND 303123;
DELETE FROM `waypoint_data` WHERE `id`=310970 OR `id` BETWEEN 303096 AND 303123;
DELETE FROM `creature` WHERE (`id`=34430 AND `guid`=310970) OR (`id`=34432 AND `guid`=310967) OR (`id`=34438 AND `guid` IN (310966,310969,310971))
    OR (`id`=34487 AND `guid` BETWEEN 303096 AND 303123);
