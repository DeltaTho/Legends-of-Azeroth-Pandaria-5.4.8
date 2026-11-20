-- Northern Barrens / Ashenvale, 13653 Crisis at Splintertree: Gorka's ride back to Mor'shan on Brutusk II, the road block and
-- her death at the rampart (dossier A, event brief E2; plan.md S3-3, A-13653-1, A-13653-2). Script:
-- zone_northern_barrens_morshan.cpp (npc_nb_gorka, npc_nb_brutusk_crisis, npc_nb_morshan_actor).
--
-- Sourced: Gorka's option (menu 10342 option 0, both TDBs); the lines BT 33593 33596 33619 33630 33631 33640-33645 33653
--   33654 (wiki pre-8.3 paragraph and 8.3 list, all in 5.4.8 broadcast_text; the road block's speaker is the Ashenvale
--   Assailant, second-pass.md); Brutusk II 33509 and Gorka 33507 (spells 63162 / 63155); the objective 33507.
-- Ours: VehicleId 366 for 33509 (VehicleId 0 in mop and both TDBs; 366 is unassigned, in 33509's creation slot, with the
--   saddle seat for Gorka and an enterable seat behind it for the player; see the script's header); the option's condition
--   (13653 in the log, incomplete; none in either TDB, it showed to everybody); the woods actors (34012 bowmen, 34117
--   skirmisher) and the 34013 fallback speakers of the road block, whose first choice is mop's static Assailants 33569 there
--   (in neither TDB); who says which assailant line; the condition that aims Gorka Bowshot 63262 (TARGET_UNIT_NEARBY_ENTRY,
--   which with no condition takes the nearest unit) at the leaping skirmisher 34117.
-- Removed: Gorka 33421's SmartAI (it credited 13653 on the spot and closed the gossip); the static Gorka 33507 (guid 311016)
--   standing on top of the quest giver (neither TDB spawns 33507; 63155 summons her there).

DELETE FROM `smart_scripts` WHERE `entryorguid`=33421 AND `source_type`=0;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_nb_gorka' WHERE `entry`=33421;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10342 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10342,0,0,0,9,0,13653,0,0,0,0,0,'','Gorka - ride option with Crisis at Splintertree in the log');

UPDATE `creature_template` SET `VehicleId`=366, `AIName`='', `ScriptName`='npc_nb_brutusk_crisis' WHERE `entry`=33509;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_nb_morshan_actor' WHERE `entry` IN (33507,34012,34013,34117);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=63262;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,63262,0,0,31,0,3,34117,0,0,0,0,'','Gorka Bowshot - at the leaping Ashenvale Skirmisher');

DELETE FROM `creature_addon` WHERE `guid`=311016;
DELETE FROM `creature` WHERE `guid`=311016 AND `id`=33507;

DELETE FROM `creature_text` WHERE `CreatureID`=33421 AND `GroupID` IN (0);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(33421,0,0,'Follow me, $n! Hurry!',12,0,100,0,0,0,0,33593,5,'Gorka - Crisis at Splintertree start');

DELETE FROM `creature_text` WHERE `CreatureID`=33507 AND `GroupID` IN (0,1,2,3,4,5,6);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(33507,0,0,'Gorka calls for Brutusk!',16,0,100,0,0,0,0,33596,5,'Gorka (rider) - calls Brutusk'),
(33507,1,0,'To Mor''shan!!',14,0,100,0,0,0,0,33619,5,'Gorka (rider) - ride starts'),
(33507,2,0,'Out of our way, fools!',14,0,100,0,0,0,0,33631,5,'Gorka (rider) - road block'),
(33507,3,0,'Unghh!',12,0,100,0,0,0,0,33644,5,'Gorka (rider) - hit'),
(33507,4,0,'Hurry, Brutusk. I''m wounded!',12,0,100,0,0,0,0,33645,5,'Gorka (rider) - wounded'),
(33507,5,0,'I am... finished....',12,0,100,0,0,0,0,33653,5,'Gorka (rider) - collapses at Mor''shan'),
(33507,6,0,'$n... You have served the Horde well.$b$bHurry now... speak with Kadrak....$b$bSave Splintertree!!',12,0,100,0,0,0,0,33654,5,'Gorka (rider) - last words');

DELETE FROM `creature_text` WHERE `CreatureID`=33569 AND `GroupID` IN (0,1,2,3,4);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(33569,0,0,'That''s far enough, orc! Dismount and submit or die!',14,0,100,0,0,0,0,33630,5,'Ashenvale Assailant - road block'),
(33569,1,0,'Kill her!!',14,0,100,0,0,0,0,33640,5,'Ashenvale Assailant - road block'),
(33569,2,0,'Shoot!',14,0,100,0,0,0,0,33642,5,'Ashenvale Assailant - road block'),
(33569,3,0,'Fire!!',14,0,100,0,0,0,0,33643,5,'Ashenvale Assailant - road block'),
(33569,4,0,'Ahhh!',12,0,100,0,0,0,0,33641,5,'Ashenvale Assailant - knocked aside');

DELETE FROM `creature_text` WHERE `CreatureID`=34013 AND `GroupID` IN (0,1,2,3,4);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34013,0,0,'That''s far enough, orc! Dismount and submit or die!',14,0,100,0,0,0,0,33630,5,'Ashenvale Assailant (scene) - road block (fallback speaker)'),
(34013,1,0,'Kill her!!',14,0,100,0,0,0,0,33640,5,'Ashenvale Assailant (scene) - road block (fallback speaker)'),
(34013,2,0,'Shoot!',14,0,100,0,0,0,0,33642,5,'Ashenvale Assailant (scene) - road block (fallback speaker)'),
(34013,3,0,'Fire!!',14,0,100,0,0,0,0,33643,5,'Ashenvale Assailant (scene) - road block (fallback speaker)'),
(34013,4,0,'Ahhh!',12,0,100,0,0,0,0,33641,5,'Ashenvale Assailant (scene) - knocked aside (fallback speaker)');
