-- Searing Gorge, Kill 'em With Sleep Deprivation 28057 / Look at the Size of It! 28058 (plan E-7, E-8; dossier
-- cauldron-finale 28057 rows 1-6, F9-F11, 28058 rows 1-3, SP-2; gate G3).
--
-- E-7 Pillows: mop had 16 Dark Iron Pillows 179828 at 300 s for 16 needed (a group of three needed 48 loots); the TDB has 24 at
--     30 s ("very fast spawn rate", OLD 2009-12-11 [+9]). The 12 TDB 4.4.2 spots mop lacked are added (guids 3132400-3132411,
--     TDB 225650-225673 positions and rotations) and all pillows respawn in 30 s; mop's 4 extra spots stay (less grind).
-- E-8 The pillow event (zone_searing_gorge_cauldron.cpp): opening a pillow starts the generator 179829 (one spawn of ours, 3132412,
--     displayId 0, in the middle of the bunk hall), which summons the two Sleepy gangs and the Chambermaid. Their static copies go:
--     the ten Sleepy Dark Iron Workers 186353-186362 with their short paths (neither TDB spawns 14635) and Chambermaid
--     Pillaclencher 186573 (always there; the sources make her the event's last stage), and the static Ornate Pillow 160548
--     (always there, free for all).
--     The Ornate Pillow 179832 lies at the Chambermaid's body when she dies, for 5 minutes, and every player who has not taken
--     Look at the Size of It! and does not hold the starter gets Chambermaid Pillaclencher's Pillow 62933 by clicking it
--     ("Anyone (multiple people) can click on it until it despawns", 2011-02-27 [+4]; OLD 2010-11-07). In this core a chest's loot
--     serves one looter (a summoned GO is deleted once looted, GameObject.cpp; gate G3), so the object has no loot and hands the
--     item out by SmartGameObjectAI; SEND_GOSSIP_MENU makes OnGossipHello return true, which stops the loot window (it sends an
--     empty gossip frame that row 1 closes at once: a window may blink - test sheet). 18950
--     (Pillamaster's Pillow) is no longer in the object: the quest provides it on accept (StartItem, wiki "provided").
--     The pillow is summoned with summonType 1 (timed, not owned by her): owned by her it would vanish with her corpse
--     (Unit::RemoveAllGameObjects), whose time the summon's out-of-combat timer sets, not the 5 minutes.
-- Sourced: the 24 TDB spots and 30 s, the gangs' and the Chambermaid's yells (BroadcastText 9799 / 9800; 9810 exists as 14636
-- group 0), the multi-use pillow. Ours: the generator object, 5 minutes for the pillow, the per-player gate.

-- E-7
UPDATE `gameobject` SET `spawntimesecs` = 30 WHERE `id` = 179828;
DELETE FROM `gameobject` WHERE `guid` BETWEEN 3132400 AND 3132411;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) VALUES
(3132400,179828,0,51,1443,1,1,0,0,-6569.39,-1335.83,210.199,2.33874,0,0,0.920505,0.390732,30,100,1,'',0),
(3132401,179828,0,51,1443,1,1,0,0,-6527.64,-1340.23,212.095,1.83259,0,0,0.793352,0.608764,30,100,1,'',0),
(3132402,179828,0,51,1443,1,1,0,0,-6518.91,-1364.86,210.541,5.65487,0,0,0.309015,-0.951057,30,100,1,'',0),
(3132403,179828,0,51,1443,1,1,0,0,-6572.96,-1327.58,212.095,3.56047,0,0,0.978148,-0.207911,30,100,1,'',0),
(3132404,179828,0,51,1443,1,1,0,0,-6570.39,-1332.69,212.095,5.37562,0,0,0.438369,-0.898795,30,100,1,'',0),
(3132405,179828,0,51,1443,1,1,0,0,-6554.68,-1351.74,212.682,2.14675,0,0,0.878816,0.477161,30,100,1,'',0),
(3132406,179828,0,51,1443,1,1,0,0,-6562.07,-1344.44,212.619,1.25664,0,0,0.587786,0.809016,30,100,1,'',0),
(3132407,179828,0,51,1443,1,1,0,0,-6554.33,-1313.80,210.260,5.28835,0,0,0.477158,-0.878818,30,100,1,'',0),
(3132408,179828,0,51,1443,1,1,0,0,-6551.14,-1354.85,210.421,4.36332,0,0,0.819153,-0.573575,30,100,1,'',0),
(3132409,179828,0,51,1443,1,1,0,0,-6531.65,-1337.63,210.180,4.39823,0,0,0.809017,-0.587785,30,100,1,'',0),
(3132410,179828,0,51,1443,1,1,0,0,-6508.78,-1365.26,212.859,0.645772,0,0,0.317305,0.948324,30,100,1,'',0),
(3132411,179828,0,51,1443,1,1,0,0,-6528.76,-1363.60,212.657,2.61799,0,0,0.965925,0.258821,30,100,1,'',0);

-- E-8: the hook and the generator
UPDATE `gameobject_template` SET `AIName` = '', `ScriptName` = 'go_searing_gorge_dark_iron_pillow' WHERE `entry` = 179828;
UPDATE `gameobject_template` SET `AIName` = '', `ScriptName` = 'go_searing_gorge_pillow_event_generator' WHERE `entry` = 179829;
DELETE FROM `gameobject` WHERE `guid` = 3132412;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) VALUES
(3132412,179829,0,51,1443,1,1,0,0,-6541.0,-1348.0,208.9,0,0,0,0,1,0,100,1,'',0);

-- the gangs
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_searing_gorge_sleepy_worker' WHERE `entry` = 14635;
DELETE FROM `creature_text` WHERE `CreatureID` = 14635;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(14635,0,0,'Our pillas! Someone has stolen our pillas!',14,0,100,0,0,0,9799,0,'Sleepy Dark Iron Worker - first gang'),
(14635,1,0,'We''ll not let this act of madness go unpunished!',14,0,100,0,0,0,9800,0,'Sleepy Dark Iron Worker - second gang');

-- the static event actors
DELETE FROM `waypoint_data` WHERE `id` BETWEEN 186354 AND 186362;
DELETE FROM `creature_addon` WHERE `guid` BETWEEN 186353 AND 186362 OR `guid` = 186573;
DELETE FROM `creature` WHERE `id` = 14635 AND `guid` BETWEEN 186353 AND 186362;
DELETE FROM `creature` WHERE `id` = 14636 AND `guid` = 186573;
DELETE FROM `gameobject` WHERE `id` = 179832 AND `guid` = 160548;

-- the Ornate Pillow: summoned on her death, one starter per player
UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI', `ScriptName` = '' WHERE `entry` = 179832;
DELETE FROM `gameobject_loot_template` WHERE `entry` = 179832;
UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 14636;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 179832 AND `source_type` = 1;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 14636 AND `source_type` = 0 AND `id` = 2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(179832,1,0,1,64,0,100,0,0,0,0,0,0,98,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Pillaclencher''s Ornate Pillow - On Use - Take Over Use (no loot)'),
(179832,1,1,0,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Pillaclencher''s Ornate Pillow - On Use - Close Window'),
(179832,1,2,0,64,0,100,0,0,0,0,0,0,56,62933,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Pillaclencher''s Ornate Pillow - On Use - Give Chambermaid Pillaclencher''s Pillow'),
(14636,0,2,0,6,0,100,0,0,0,0,0,0,50,179832,300,1,0,0,0,1,0,0,0,0,0,0,0,0,'Chambermaid Pillaclencher - On Death - Summon Ornate Pillow (5 min, not owned)');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceGroup` = 3 AND `SourceEntry` = 179832;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,3,179832,1,0,47,0,28058,1,0,0,0,0,'','Ornate Pillow - only for players who have not taken Look at the Size of It!'),
(22,3,179832,1,0, 2,0,62933,1,0,1,0,0,'','Ornate Pillow - and do not hold the pillow already');
