-- Searing Gorge, C-3: the Frigid Lieutenant (26214) of the Midsummer quest Striking Back (11952).
-- mop_world had a static Lieutenant (guid 373404, faction 14, in no game event) hostile at Firewatch Ridge all year, and
-- Ice Stones 188145-188147 (menus 9266-9268 "Lay your hand on the stone.", spawned for event 1) with no AI.
-- Sourced (TDB 4.4.2 smart_scripts 188145-188147 + action lists 18814500/600/700, conditions 15/9266-9268; 12.1.0 has the
-- same for 188146/188147; faction 91 in both): on option 0 the stone closes the gossip, 1 s later summons a Lieutenant at its own
-- sniffed point for 120 s (TIMED_DESPAWN), 1 s after that despawns itself; the option shows only with 11952 in the log or
-- complete (quest state mask 10). No static Lieutenant in either TDB.
-- Ours: faction 91 is applied to the entry. The stone's despawn is a plain despawn, so it returns after its own spawntimesecs:
-- set to 100 s as the TDB script asks (was 300 s).
-- Idempotent: DELETE + INSERT, absolute UPDATEs.

DELETE FROM `creature_addon` WHERE `guid`=373404;
DELETE FROM `creature` WHERE `guid`=373404 AND `id`=26214;
UPDATE `creature_template` SET `faction`=91 WHERE `entry`=26214;
UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry` IN (188145,188146,188147);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (188145,188146,188147) AND `source_type`=1;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (18814500,18814600,18814700) AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(188145,1,0,0,62,0,100,0,9266,0,0,0,0,80,18814500,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ice Stone - On Gossip Option 0 Selected - Run Script'),
(188146,1,0,0,62,0,100,0,9267,0,0,0,0,80,18814600,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ice Stone - On Gossip Option 0 Selected - Run Script'),
(188147,1,0,0,62,0,100,0,9268,0,0,0,0,80,18814700,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ice Stone - On Gossip Option 0 Selected - Run Script'),
(18814500,9,0,0,0,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Ice Stone - On Script - Close Gossip'),
(18814500,9,1,0,0,0,100,0,1000,1000,0,0,0,12,26214,3,120000,0,0,0,8,0,0,0,0,-6631.12,-661.678,234.804,0.5,'Ice Stone - On Script - Summon Frigid Lieutenant'),
(18814500,9,2,0,0,0,100,0,1000,1000,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ice Stone - On Script - Despawn'),
(18814600,9,0,0,0,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Ice Stone - On Script - Close Gossip'),
(18814600,9,1,0,0,0,100,0,1000,1000,0,0,0,12,26214,3,120000,0,0,0,8,0,0,0,0,-6607.44,-648.12,235.142,3.40001,'Ice Stone - On Script - Summon Frigid Lieutenant'),
(18814600,9,2,0,0,0,100,0,1000,1000,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ice Stone - On Script - Despawn'),
(18814700,9,0,0,0,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Ice Stone - On Script - Close Gossip'),
(18814700,9,1,0,0,0,100,0,1000,1000,0,0,0,12,26214,3,120000,0,0,0,8,0,0,0,0,-6620.22,-631.247,234.566,4.944,'Ice Stone - On Script - Summon Frigid Lieutenant'),
(18814700,9,2,0,0,0,100,0,1000,1000,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Ice Stone - On Script - Despawn');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup` IN (9266,9267,9268) AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,9266,0,0,0,47,0,11952,10,0,0,0,0,'','Ice Stone - Show option only with Striking Back (Searing Gorge) in the log'),
(15,9267,0,0,0,47,0,11952,10,0,0,0,0,'','Ice Stone - Show option only with Striking Back (Searing Gorge) in the log'),
(15,9268,0,0,0,47,0,11952,10,0,0,0,0,'','Ice Stone - Show option only with Striking Back (Searing Gorge) in the log');
UPDATE `gameobject` SET `spawntimesecs`=100 WHERE `guid` IN (214331,214332,214333) AND `id` IN (188145,188146,188147);
