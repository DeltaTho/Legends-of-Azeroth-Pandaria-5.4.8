-- Northern Barrens / Ashenvale, 13712 To the Rescue!: Kadrak's ride on Brutusk III to Splintertree, the gate scene, and the 5.3
-- wind rider shortcut (dossier A, event brief E3; plan.md S3-4 / S3-5 / S3-6, A-13712-1, A-13712-2). Script:
-- zone_northern_barrens_morshan.cpp (npc_nb_kadrak, npc_nb_brutusk_rescue, npc_nb_morshan_actor).
--
-- Sourced: the options "I am ready to accompany you to Splintertree, Kadrak!" (BT 34040), "I will check back with you shortly,
--   Kadrak." (34045), "This seems urgent, Kadrak. There must be another way!" (74240, patch 5.3.0) and every line of the ride
--   and the gate scene (BT 34047 34049 34087 34094 34111-34114 34117 34160 34164 34165 34171 34182 74241; wiki's "removed
--   from game" section, comments 2011-09-17 / 2011-12-16); Brutusk III 34007, Kadrak 34006, the scene entries with factions
--   1801 / 1802 (34012 34013 34052 34101 34124 34126 34136; no spawns); spells 64265 64293 64327 64400 64477 64506.
-- Ours: VehicleId 366 for 34007 (VehicleId 0 in mop and both TDBs; the dossier's 386 has no enterable seat and cannot hold two
--   riders in this core, see the script's header); the option conditions (13712 in the log, incomplete; "ready" while Kadrak
--   is not busy, "check back" only while he holds 64243, which only the script's shared mode sets: questions.md Q5 default =
--   private rides, both 13712 options side by side); the shortcut as the taxi path 1253 with credit on choosing (Q6); the
--   spell conditions that keep Brutusk's lightning and stomp on the ride's own actors (they are area spells and would hit the
--   live Ashenvale mobs beside the road). The gate scene plays on the battlefield in front of the closed gate (wiki); the
--   gate is not opened (three stacked public gate models). 64477 Throw Brutusk Boulder is not cast (a dummy whose nearby-entry
--   search runs at 50 000 yd): the Ancient's throw is an emote, so its old condition row goes.
-- Removed: 34007's SmartAI row (Kodo Stomp in melee range; the stomp is now cast by the ride) and the static Brutusk III
--   (guid 373658) parked inside Splintertree (neither TDB spawns 34007; 64239 summons it at Mor'shan).
-- Removed (Ashenvale static, orchestrator ruling): Raging Ancient 33688 guid 238064 inside Splintertree Post (2254.6, -2537.2),
--   in neither TDB (both have 33688 only at 2160,-2423 and 2143,-2509, mop's 237187 / 238078), a hostile level-35 elite 31 yd
--   from Kadrak 33837 that attacks players arriving by this ride or the wind rider. No SmartAI, formation or game event
--   refers to the guid.

DELETE FROM `gossip_menu_option` WHERE `MenuID`=10411 AND `OptionID` IN (1,2,3);
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(10411,1,0,'I am ready to accompany you to Splintertree, Kadrak!',34040,1,1,0,0,0,0,'',0,0),
(10411,2,0,'I will check back with you shortly, Kadrak.',34045,1,1,0,0,0,0,'',0,0),
(10411,3,0,'This seems urgent, Kadrak. There must be another way!',74240,1,1,0,0,0,0,'',0,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10411 AND `SourceEntry` IN (1,2,3);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10411,1,0,0,9,0,13712,0,0,0,0,0,'','Kadrak - ready option with To the Rescue! in the log'),
(15,10411,1,0,0,1,1,64243,0,0,1,0,0,'','Kadrak - ready option while Kadrak is not busy'),
(15,10411,2,0,0,9,0,13712,0,0,0,0,0,'','Kadrak - check back option with To the Rescue! in the log'),
(15,10411,2,0,0,1,1,64243,0,0,0,0,0,'','Kadrak - check back option only while Kadrak is busy'),
(15,10411,3,0,0,9,0,13712,0,0,0,0,0,'','Kadrak - wind rider option with To the Rescue! in the log');

DELETE FROM `smart_scripts` WHERE `entryorguid`=34007 AND `source_type`=0;
UPDATE `creature_template` SET `VehicleId`=366, `AIName`='', `ScriptName`='npc_nb_brutusk_rescue' WHERE `entry`=34007;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_nb_morshan_actor' WHERE `entry` IN (34006,34012,34013,34052,34101,34117,34124,34126,34136);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (64327,64400,64477);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,64327,0,0,31,0,3,34012,0,0,0,0,'','Brutusk Chain Lightning - only the ride''s scene actors'),
(13,1,64327,0,1,31,0,3,34013,0,0,0,0,'','Brutusk Chain Lightning - only the ride''s scene actors'),
(13,1,64327,0,2,31,0,3,34101,0,0,0,0,'','Brutusk Chain Lightning - only the ride''s scene actors'),
(13,1,64327,0,3,31,0,3,34117,0,0,0,0,'','Brutusk Chain Lightning - only the ride''s scene actors'),
(13,1,64327,0,4,31,0,3,34126,0,0,0,0,'','Brutusk Chain Lightning - only the ride''s scene actors'),
(13,3,64400,0,0,31,0,3,34012,0,0,0,0,'','Kodo Stomp - only the ride''s scene actors'),
(13,3,64400,0,1,31,0,3,34013,0,0,0,0,'','Kodo Stomp - only the ride''s scene actors'),
(13,3,64400,0,2,31,0,3,34101,0,0,0,0,'','Kodo Stomp - only the ride''s scene actors'),
(13,3,64400,0,3,31,0,3,34117,0,0,0,0,'','Kodo Stomp - only the ride''s scene actors'),
(13,3,64400,0,4,31,0,3,34126,0,0,0,0,'','Kodo Stomp - only the ride''s scene actors');

DELETE FROM `creature_addon` WHERE `guid`=373658;
DELETE FROM `creature` WHERE `guid`=373658 AND `id`=34007;
DELETE FROM `creature_addon` WHERE `guid`=238064;
DELETE FROM `creature` WHERE `guid`=238064 AND `id`=33688;

DELETE FROM `creature_text` WHERE `CreatureID`=8582 AND `GroupID` IN (1,2);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(8582,1,0,'Now... witness the power of a war kodo in the hands of a master!',12,0,100,0,0,0,0,34047,5,'Kadrak - To the Rescue! start'),
(8582,2,0,'Very well, $n. I''ll meet you there.',12,0,100,0,0,3980,0,74241,5,'Kadrak - wind rider shortcut');

DELETE FROM `creature_text` WHERE `CreatureID`=34006 AND `GroupID` IN (0,1,2,3,4,5,6,7,8,9,10,11);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34006,0,0,'To Splintertree!',14,0,100,0,0,0,0,34049,5,'Kadrak (rider) - ride starts'),
(34006,1,0,'Make ''em pay, Brutusk!',12,0,100,0,0,0,0,34160,5,'Kadrak (rider) - group 1'),
(34006,2,0,'Teach them the meaning of blood and thunder!',12,0,100,0,0,0,0,34087,5,'Kadrak (rider) - group 1'),
(34006,3,0,'Lok''tar Ogar!!',14,0,100,0,0,0,0,34094,5,'Kadrak (rider) - group 2'),
(34006,4,0,'Not far now....',12,0,100,0,0,0,0,34111,5,'Kadrak (rider) - near the Barrow Den'),
(34006,5,0,'Splintertree...',12,0,100,0,0,0,0,34112,5,'Kadrak (rider) - Splintertree in sight'),
(34006,6,0,'We must break the siege!',12,0,100,0,0,0,0,34113,5,'Kadrak (rider) - group 4'),
(34006,7,0,'For the Horde!!',14,0,100,0,0,0,0,34114,5,'Kadrak (rider) - charge'),
(34006,8,0,'Open the gates brothers! Let us welcome our visitors in true Horde fashion!',14,0,100,0,0,0,0,34117,5,'Kadrak (rider) - at the gate'),
(34006,9,0,'Drive them back! Back to Darnassus!',14,0,100,0,0,0,0,34165,5,'Kadrak (rider) - gate scene'),
(34006,10,0,'Brutusk... NOOOOOO!!',14,0,100,0,0,0,0,34171,5,'Kadrak (rider) - Brutusk falls'),
(34006,11,0,'The siege is broken... for now. Follow me to Splintertree.',12,0,100,0,0,0,0,34182,5,'Kadrak (rider) - siege broken');

DELETE FROM `creature_text` WHERE `CreatureID`=34052 AND `GroupID` IN (0,1);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34052,0,0,'Blood and Thunder!',14,0,100,0,0,0,0,34164,5,'Splintertree Guard (scene) - out of the gate'),
(34052,1,0,'For the Horde!!',14,0,100,0,0,0,0,34114,5,'Splintertree Guard (scene) - out of the gate');

DELETE FROM `creature_text` WHERE `CreatureID`=34136 AND `GroupID` IN (0,1);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34136,0,0,'Blood and Thunder!',14,0,100,0,0,0,0,34164,5,'Splintertree Guard (scene) - out of the gate'),
(34136,1,0,'For the Horde!!',14,0,100,0,0,0,0,34114,5,'Splintertree Guard (scene) - out of the gate');
