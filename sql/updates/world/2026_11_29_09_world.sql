-- Northern Barrens S1 (_09): Grol'dom Farm - map area, tusk drops, Mankrik's text, doubled pillagers and sack, the captured
-- Razormane and his options, Togrik's wake-up option, the kodo's walk, the barricade fight, Una's path.
-- (plan.md section 1 `_09`; dossier E: E-1 .. E-9, E-11, E-12.)
--
-- SOURCED: map area of 13961 in the 5.4.8 format (TDB 12.1.0: objective index 1, id 264309); Quilboar Tusk 100 % and 1-2 per
-- kill from Pillager and Frenzy (both TDBs); Mankrik's second text 3554 is in neither TDB and, unconditioned and last,
-- replaced his greeting 3553; the duplicate spawns stand 0.1-1.7 yd from another of the same entry (5 Pillagers, 1 Frenzy,
-- 1 Stolen Grain Sack); sacks respawn in 120 s (both TDBs); the Captured Razormane stands still at both TDBs' spot; the
-- Saintly buff hides every interrogation option (comment 2010-07-31 [+92] and replies; Nasty already hides 3 and 4); Una
-- paces in her hut on the sniffed path (both TDBs: creature_addon 303734 path 24298720).
-- OURS: Togrik's wake-up option (quest log text "Togrik can revive him"; the option was dead) closes the menu and gives the
-- prisoner his gossip flag back (his scripts take it off while they run; respawning a living creature restores nothing); the kodo of 13971 gets up and trudges toward the farm on accept (quest text), with our point, 15 s walk and
-- 30 s respawn - one shared kodo (questions.md Q15 default): for ~45 s after an accept the next player finds no kodo, and the
-- kodo's own quests (starts 13970 / 13971, ends 13969 / 13970) wait that long; NPC damage stops once a Razormane Pillager is at
-- 60 % (value ours; the hit that crosses the line is not clamped), so the player who fights it keeps the kill (IsDamageEnoughForLootingAndReward) and the barricade fight
-- goes on.

-- E-1: map area of 13961 in the 5.4.8 format.
UPDATE `quest_poi` SET `ObjectiveIndex`=1, `QuestObjectiveId`=264309 WHERE `QuestID`=13961 AND `Idx1`=0;

-- E-2: Quilboar Tusk 100 %, 1-2 per kill.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100, `mincountOrRef`=1, `maxcount`=2 WHERE `entry` IN (34503,34545) AND `item`=5085;

-- E-3: Mankrik greets with 3553 again.
DELETE FROM `gossip_menu` WHERE `MenuID`=2861 AND `TextID`=3554;

-- E-4: stacked duplicate Razormane Pillagers (5) and Razormane Frenzy (1).
DELETE FROM `creature_addon` WHERE `guid` IN (263083,263142,263147,263079,264266,262908);
DELETE FROM `creature` WHERE `guid` IN (263083,263142,263147,263079,264266) AND `id`=34503;
DELETE FROM `creature` WHERE `guid`=262908 AND `id`=34545;

-- E-5: the doubled Stolen Grain Sack; sacks respawn in 120 s.
DELETE FROM `gameobject` WHERE `guid`=175157 AND `id`=195118;
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `id`=195118;

-- E-6: the Captured Razormane stands still where both TDBs have him (mop: random movement 5 yd).
UPDATE `creature` SET `position_x`=281.347, `position_y`=-3051.85, `position_z`=95.9328, `orientation`=0.40822,
  `MovementType`=0, `wander_distance`=0 WHERE `guid`=303126 AND `id`=34523;

-- E-7: Saintly hides every interrogation option.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10521 AND `ConditionTypeOrReference`=1 AND `ConditionValue1`=65628;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10521,0,0,0,1,0,65628,0,0,1,0,0,'','Captured Razormane - hide option while player has Saintly'),
(15,10521,1,0,0,1,0,65628,0,0,1,0,0,'','Captured Razormane - hide option while player has Saintly'),
(15,10521,2,0,0,1,0,65628,0,0,1,0,0,'','Captured Razormane - hide option while player has Saintly'),
(15,10521,3,0,0,1,0,65628,0,0,1,0,0,'','Captured Razormane - hide option while player has Saintly'),
(15,10521,4,0,0,1,0,65628,0,0,1,0,0,'','Captured Razormane - hide option while player has Saintly');

-- E-8 (ours): Togrik's "wake up the prisoner" option closes the menu and wakes the prisoner (data 0 2: gossip flag on).
DELETE FROM `smart_scripts` WHERE `entryorguid`=34513 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34513,0,0,1,62,0,100,0,10520,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Togrik - On Gossip Option 0 Selected - Close Gossip'),
(34513,0,1,0,61,0,100,0,0,0,0,0,0,45,0,2,0,0,0,0,10,303126,34523,0,0,0,0,0,0,'Togrik - Linked - Set Data 0 2 on Captured Razormane');
DELETE FROM `smart_scripts` WHERE `entryorguid`=34523 AND `source_type`=0 AND `id`=25;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34523,0,25,0,38,0,100,0,0,2,0,0,0,82,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Captured Razormane - On Data Set 0 2 (Togrik wakes him) - Add Npc Flag Gossip');

-- E-9 (ours): the kodo gets up and trudges off toward the farm when The Kodo's Return is accepted.
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34547 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid`=34547 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34547,0,0,1,19,0,100,0,13971,0,0,0,0,83,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Grol''dom Kodo - On Quest 13971 Accepted - Remove Questgiver Flag'),
(34547,0,1,2,61,0,100,0,0,0,0,0,0,28,54852,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Grol''dom Kodo - Linked - Remove Cosmetic Stun'),
(34547,0,2,3,61,0,100,0,0,0,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Grol''dom Kodo - Linked - Stand Up'),
(34547,0,3,4,61,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,8,0,0,0,0,-52.6,-3125.2,91.8,0,'Grol''dom Kodo - Linked - Walk Toward Grol''dom Farm'),
(34547,0,4,0,61,0,100,0,0,0,0,0,0,41,15000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Grol''dom Kodo - Linked - Despawn In 15 s');
UPDATE `creature` SET `spawntimesecs`=30 WHERE `guid`=263066 AND `id`=34547;

-- E-11 (ours, value): NPC damage stops once a Razormane Pillager is at 60 % (Unit::DealDamage; the crossing hit is not clamped).
DELETE FROM `creature_sparring_template` WHERE `creature_id`=34503;
INSERT INTO `creature_sparring_template` (`creature_id`,`health_limit_pct`,`comment`) VALUES (34503,60,'Razormane Pillager - Grol''dom Farm barricade');

-- E-12: Una Wolfclaw paces in her hut on the sniffed path.
UPDATE `creature` SET `position_x`=238.021, `position_y`=-2899.69, `position_z`=98.1011, `orientation`=3.48435, `MovementType`=2 WHERE `guid`=262652 AND `id`=34560;
DELETE FROM `creature_addon` WHERE `guid`=262652;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(262652,262652,0,0,0,0,0,1,1,0,0,0,0,0,'');
DELETE FROM `waypoint_data` WHERE `id`=262652;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_flag`,`action`,`action_chance`,`wpguid`) VALUES
(262652,1,238.021,-2899.69,98.1011,0,6000,0,0,100,0),
(262652,2,237.951,-2899.78,98.3611,0,0,0,0,100,0),
(262652,3,234.776,-2901.86,98.4251,0,0,0,0,100,0),
(262652,4,233.776,-2902.11,98.4251,0,0,0,0,100,0),
(262652,5,233.514,-2902.14,98.3966,0,0,0,0,100,0),
(262652,6,231.764,-2902.64,98.3966,0,6000,0,0,100,0);

-- Coverage 1.3 (dossier E 13963 walk): the Captured Razormane is quest-invisible, so his lines go only to the player who
-- spoke to him (TextRange 5; the talk target is the gossip invoker, SmartScript.cpp:154).
UPDATE `creature_text` SET `TextRange`=5 WHERE `CreatureID`=34523;
