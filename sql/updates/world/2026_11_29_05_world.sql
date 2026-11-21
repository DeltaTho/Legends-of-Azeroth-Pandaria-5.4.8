-- Northern Barrens S1 (_05): Crossroads hunters and the oases - Echeyakee's lair, Sergra's shout, the raptor nests, the
-- Fissure Plants, the spore trap, and UNIT_FLAG_FLEEING off nine templates.
-- (plan.md section 1 `_05`; dossier C: C-881-1, C-881-2, C-905-1/2/3, C-877-2, C-13998-1, C-903-1 / C-844-1; dossier I:
-- I-T1, moved here by ruling R9.)
--
-- SOURCED: neither TDB spawns Echeyakee 3475 (he comes from the horn, event 2980); the 5.3+ lair is at the retail quest POI
-- of objective 265890 (47.8,44.0), 470 yd from the vanilla focus 164651; 147524 "Echeyakee's Lair" (type 8, focus 363,
-- radius 40, display 327 present in GameObjectDisplayInfo.dbc) is both TDBs' template. Sergra's zone-wide shout on the
-- turn-in (comment 2013-11-14 [+78]; BroadcastText 44333, female text). The three Raptor Nest Bunnies stand still (both
-- TDBs); the vanilla nests 6906-6908 are in neither TDB; map area idx 3 of 905 is the yellow nest (retail: index 1,
-- objective 254500). Planting the seeds grows Fissure Plants round the fissure (comment 2011-04-10 [+8]); the five
-- vanilla plant spawns (spawntimesecs -30) are respawned by the goober's event 525, empty in mop and both TDBs; the six
-- permanent copies and the permanent Mutated Fungus 175547 (a Disgusting Spores trap by the oasis; 65849 summons it for
-- 30 s) are in neither TDB. UNIT_FLAG_FLEEING 0x800000 makes every cast of the creature fail with SPELL_FAILED_FLEEING
-- (Spell.cpp:7287): Savannah Huntress never Dashes or Pounces, Greater Plainstrider never casts Dust Cloud; both TDBs
-- have it clear on all nine templates.
-- OURS: the focus spot (153,-2534; terrain z 107.34, POI-derived) and the summon point of event 2980 (14 yd WSW of it on
-- flat ground, facing the lair); the plants' despawn after 120 s.
-- CROSS-ZONE: the FLEEING clear touches templates that spawn in other zones too (620 Chicken, 1412 Squirrel, 1420 Toad,
-- 2620 Prairie Dog, 3300 Adder, 3478 Traugh, 4166 Gazelle, 3244 Greater Plainstrider, 3415 Savannah Huntress); TDB-supported
-- everywhere.
-- Note: 881's tame credit is S5's (same deploy).

-- C-881-1: Echeyakee is summoned by the horn at the 5.3+ lair, not a standing spawn.
DELETE FROM `waypoint_data` WHERE `id`=265760;
DELETE FROM `creature_addon` WHERE `guid`=265760;
DELETE FROM `creature` WHERE `guid`=265760 AND `id`=3475;
DELETE FROM `gameobject` WHERE `guid`=66257 AND `id`=164651;
DELETE FROM `gameobject` WHERE `guid`=3144400;
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnMask`,`phaseMask`,`phaseId`,`phaseGroup`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) VALUES
(3144400,147524,1,17,17,1,1,0,0,153,-2534,107.34,0,0,0,0,1,120,255,1,'',0);
UPDATE `event_scripts` SET `x`=140, `y`=-2540, `z`=95.58, `o`=0.43 WHERE `id`=2980 AND `command`=10 AND `datalong`=3475;

-- C-881-2: Sergra's zone-wide shout when Echeyakee is handed in (3338 has SAI ids 0-1 and AIName SmartAI already).
DELETE FROM `creature_text` WHERE `CreatureID`=3338 AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(3338,0,0,'Lok-tar ogar! This young $r $c has conquered the great Echeyakee. Let $ghis:her; actions show the might of the new Horde!',14,0,100,0,0,0,0,44333,2,'Sergra Darkthorn - quest 881 rewarded');
DELETE FROM `smart_scripts` WHERE `entryorguid`=3338 AND `source_type`=0 AND `id`=2;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3338,0,2,0,20,0,100,0,881,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Sergra Darkthorn - On Quest ''Echeyakee'' Rewarded - Say Line 0 (zone yell)');

-- C-905-1: the three Raptor Nest Bunnies stand still (they wandered 3 yd against a 5 yd feather check and credit).
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid` IN (265075,265076,265077) AND `id`=34967;
-- C-905-2: the vanilla nests that do nothing when clicked.
DELETE FROM `gameobject` WHERE `guid` IN (216160,216161,216162) AND `id` IN (6906,6907,6908);
-- C-905-3: map area at the yellow nest belongs to that objective.
UPDATE `quest_poi` SET `ObjectiveIndex`=1, `QuestObjectiveId`=254500 WHERE `QuestID`=905 AND `Idx1`=3;

-- C-877-2: planting the seeds makes the five Fissure Plants grow for 120 s; the six permanent copies go.
DELETE FROM `gameobject` WHERE `guid` IN (175548,175549,175550,175551,175552,175553) AND `id`=3743;
DELETE FROM `event_scripts` WHERE `id`=525;
INSERT INTO `event_scripts` (`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(525,1,9,8445,120,0,0,0,0,0),
(525,1,9,9477,120,0,0,0,0,0),
(525,1,9,9481,120,0,0,0,0,0),
(525,1,9,9482,120,0,0,0,0,0),
(525,1,9,9483,120,0,0,0,0,0);

-- C-13998-1: the permanent Mutated Fungus spore trap by the oasis.
DELETE FROM `gameobject` WHERE `guid`=175547 AND `id`=195160;

-- C-903-1 / C-844-1 + I-T1 (ruling R9, one statement): UNIT_FLAG_FLEEING off.
UPDATE `creature_template` SET `unit_flags`=`unit_flags`&~0x800000 WHERE `entry` IN (620,1412,1420,2620,3244,3300,3415,3478,4166);
