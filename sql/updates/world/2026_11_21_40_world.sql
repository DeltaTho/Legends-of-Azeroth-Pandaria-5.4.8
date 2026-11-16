-- Searing Gorge: Dig-Boss Dinwhisker (27964) comes after about a dozen dig-site dwarves die; his Dark Ember is given per player.
-- (plan D-1, D-2; grimesilt-lunk dossier E1, SP2; C++ zone_searing_gorge_lunk.cpp)
-- Sourced: only Dark Iron Footmen 47275 and Excavators 47276 count (Wowhead 27964 comments 2010-11-24 [+4], 2014-07-09 [+4]),
-- "about a dozen" kills (2010-11-24 [+131] and confirmations), he rides in from the west end and circles counter-clockwise (wiki
-- notes of 27964), his two yells (creature_text 47271 groups 0/1), the ember is clicked on the ground by anyone on the quest
-- (2013-04-11 reply [+11], 2010-11-28 [+8]); no TDB spawns him or the ember (summoned).
-- Ours: the controller spawn 3132001 and its spot, the count 12, the loop's points (through his Wowhead pins), the 5-minute stay,
-- the per-player ember objects (40 yd, 2 minutes).

-- The controller (ELM General Purpose Bunny; the ScriptName on the spawn replaces the entry's own SmartAI for this one)
DELETE FROM `creature` WHERE `guid`=3132001;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`spawntimesecs_max`,`wander_distance`,`currentwaypoint`,`curhealth`,`curmana`,`MovementType`,`npcflag`,`npcflag2`,`unit_flags`,`unit_flags2`,`dynamicflags`,`ScriptName`,`walk_mode`,`VerifiedBuild`) VALUES
(3132001,23837,0,51,246,1,1,0,0,0,0,-6770,-1580,193.1,0,300,0,0,0,0,0,0,0,0,0,0,0,'npc_sg_dinwhisker_controller',0,0);

-- Each Footman / Excavator that dies tells the controller
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (47275,47276);
DELETE FROM `smart_scripts` WHERE `entryorguid`=47275 AND `source_type`=0 AND `id`=1;
DELETE FROM `smart_scripts` WHERE `entryorguid`=47276 AND `source_type`=0 AND `id`=2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47275,0,1,0,6,0,100,0,0,0,0,0,0,45,1,1,0,0,0,0,10,3132001,23837,0,0,0,0,0,0,'Dark Iron Footman - On Death - Set Data 1 1 (Dinwhisker controller)'),
(47276,0,2,0,6,0,100,0,0,0,0,0,0,45,1,1,0,0,0,0,10,3132001,23837,0,0,0,0,0,0,'Dark Iron Excavator - On Death - Set Data 1 1 (Dinwhisker controller)');

-- Dinwhisker: summoned now (C++: arrival yell, loop, aggro yell, his old charge and Battle Shout); the static one goes
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_sg_dig_boss_dinwhisker' WHERE `entry`=47271;
DELETE FROM `smart_scripts` WHERE `entryorguid`=47271 AND `source_type`=0;
DELETE FROM `waypoint_data` WHERE `id`=313153;
DELETE FROM `creature_addon` WHERE `guid`=313153;
DELETE FROM `creature` WHERE `guid`=313153 AND `id`=47271;

-- His loop, counter-clockwise from the west end: south side, east end, north side (points on his Wowhead pins, z from the terrain)
DELETE FROM `waypoint_data` WHERE `id`=4727100;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(4727100,1,-6772.4,-1492.1,180.7,0,0,0,0,100,0),
(4727100,2,-6781.3,-1532.3,192.3,0,0,0,0,100,0),
(4727100,3,-6793.2,-1554.6,192.4,0,0,0,0,100,0),
(4727100,4,-6808.1,-1572.4,195.0,0,0,0,0,100,0),
(4727100,5,-6808.1,-1594.7,194.9,0,0,0,0,100,0),
(4727100,6,-6796.1,-1612.6,189.7,0,0,0,0,100,0),
(4727100,7,-6787.2,-1634.9,191.9,0,0,0,0,100,0),
(4727100,8,-6766.4,-1648.3,191.9,0,0,0,0,100,0),
(4727100,9,-6745.6,-1634.9,191.9,0,0,0,0,100,0),
(4727100,10,-6733.7,-1617.0,192.7,0,0,0,0,100,0),
(4727100,11,-6730.7,-1599.2,192.4,0,0,0,0,100,0),
(4727100,12,-6745.6,-1568.0,194.7,0,0,0,0,100,0),
(4727100,13,-6745.6,-1541.2,195.3,0,0,0,0,100,0),
(4727100,14,-6742.6,-1514.4,191.1,0,0,0,0,100,0),
(4727100,15,-6766.4,-1509.9,186.1,0,0,0,0,100,0);

-- The ember: no free static embers, no tapper-only creature drop (TDB: object 206573 only, never spawned; its object loot stays)
DELETE FROM `gameobject` WHERE `guid` IN (183842,183843) AND `id`=206573;
DELETE FROM `creature_loot_template` WHERE `entry`=47271 AND `item`=62806;
