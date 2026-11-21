-- Northern Barrens S1 (_13): Ratchet miscellany - Trouble at the Docks retired, Mending Old Wounds below Neutral, King
-- Reaperclaw's horn and consorts, Mebok's tasting, medal drops, two quests' map areas.
-- (plan.md section 1 `_13`; dossier G: G6, G7, G8, G9, G10, G11, G12.)
--
-- SOURCED: per block below (both TDBs, Wowhead comments).
-- OURS: nothing. G8 takes consort 263120 off its waypoint path into Reaperclaw's formation; 263120 is one of the eight
-- path-walking Sunscales of H1 (`_15`), consistent with it.

-- G6 (959 Trouble at the Docks): retired in Cataclysm (Wowhead 2010-11-26 [+14], 2011-01-12 [+18], 2011-11-14, 2011-12-29:
-- Bigglefuzz offers nothing; TDB 12.1.0 flags it DEPRECATED 0x4000). The ender stays so an old log copy can be handed in.
DELETE FROM `creature_queststarter` WHERE `id`=3665 AND `quest`=959;

-- G7 (9267 Mending Old Wounds): only below Neutral with Ratchet (both TDBs RequiredMaxRepValue 0; Wowhead 2013-04-01 [+14]).
-- SatisfyQuestReputation refuses at rep >= value, so mop's 1 offers it to every character at exactly 0 (a fresh character).
UPDATE `quest_template_addon` SET `RequiredMaxRepValue`=0 WHERE `ID`=9267 AND `RequiredMaxRepFaction`=470;

-- G8 (865): King Reaperclaw's horn always drops (both TDBs 100; "just kill him and loot the item"); respawn 120 s as the TDBs
-- (Wowhead 2010-11-24: 70-83 s). His two Sunscale Consorts travel with him (both TDBs: formation groupAI 515, dist 3, 45/315 deg;
-- Wowhead 2010-11-27 [+34] "travels with 2 smaller raptors", 2013-10-03 "sap the consorts").
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100 WHERE `entry`=34829 AND `item`=46850;
UPDATE `creature` SET `spawntimesecs`=120 WHERE `guid`=263119 AND `id`=34829;
DELETE FROM `creature_formations` WHERE `leaderGUID`=263119 OR `memberGUID` IN (263119,263120,263121);
INSERT INTO `creature_formations` (`leaderGUID`,`memberGUID`,`dist`,`angle`,`groupAI`,`point_1`,`point_2`) VALUES
(263119,263119,0,0,515,0,0),(263119,263120,3,45,515,0,0),(263119,263121,3,315,515,0,0);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0, `spawntimesecs`=120 WHERE `guid` IN (263120,263121) AND `id`=44165;
UPDATE `creature_addon` SET `path_id`=0 WHERE `guid`=263120;

-- G9 (865 turn-in): Mebok tastes the drink (both TDBs: SmartAI 3446 event 20 -> actionlist 344600; mop has the two texts and no AI).
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=3446 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE (`entryorguid`=3446 AND `source_type`=0) OR (`entryorguid`=344600 AND `source_type`=9);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3446,0,0,0,20,0,100,0,865,0,0,0,0,80,344600,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mebok Mizzyrix - On Quest ''It''s Gotta be the Horn'' Rewarded - Run Script'),
(344600,9,0,0,0,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mebok Mizzyrix - On Script - Say Line 0'),
(344600,9,1,0,0,0,100,0,2000,2000,0,0,0,11,17550,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mebok Mizzyrix - On Script - Cast Purification'),
(344600,9,2,0,0,0,100,0,4000,4000,0,0,0,5,34,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mebok Mizzyrix - On Script - Play Emote 34'),
(344600,9,3,0,0,0,100,0,4000,4000,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Mebok Mizzyrix - On Script - Say Line 1');

-- G10 (891): medal drops as both TDBs (marine 80, preserver 80, sharpshooter 100, deck hand 100); mop 54/38/28/50 is grindier.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-80 WHERE `entry` IN (3385,3386) AND `item`=5078;
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100 WHERE `entry` IN (34706,34707) AND `item`=5078;
-- G11 (891): map areas carry the wrong objective (TDB 12.1.0 by position): Buckland's area is objective 0, Pyre's 1, the camp 2.
UPDATE `quest_poi` SET `ObjectiveIndex`=0, `QuestObjectiveId`=254682 WHERE `QuestID`=891 AND `Idx1`=1;
UPDATE `quest_poi` SET `ObjectiveIndex`=1, `QuestObjectiveId`=254683 WHERE `QuestID`=891 AND `Idx1`=2;
UPDATE `quest_poi` SET `ObjectiveIndex`=2, `QuestObjectiveId`=254684 WHERE `QuestID`=891 AND `Idx1` IN (3,4,5);
-- G12 (14067): the lockbox area is the Stolen Silver objective (TDB 12.1.0 and 4.4.2).
UPDATE `quest_poi` SET `ObjectiveIndex`=2, `QuestObjectiveId`=264551 WHERE `QuestID`=14067 AND `Idx1`=2;

