-- Blasted Lands, The Amulet of Grol (25699 H / 26169 A): opening the Head of Grol 203230 in the sunken wreck calls the Spirit of
-- Grol 41267, who carries the amulet.
-- Sourced: the boss emote "You hear a noise behind you." and the two yells (wiki 26169 notes; broadcast 41202 / 41201 / 41203;
-- comments FuryWar [+2], Mecha [+8]), the Broken Amulet from the head first (Mecha, 181947), the spirit appearing behind the opener
-- where the TDBs' Generic Bunny 41200 (163088) faces the head (both TDBs spawn the bunny; neither spawns the spirit), "he can only
-- be spawned during the quest and has a pre-set death timer" (Nulgar [+3]): 79049's duration, 120 s; touching the head again calls
-- him again (969161; 146544).
-- Ours: the trigger (the object's SmartAI on open: lootedEvent 24694 has no event script in mop or either TDB and 79049 is cast by
-- nothing), the gate (quest in progress, no Amulet of Grol yet, no living spirit within 25 yd), the Broken Amulet only for players on
-- the quest. The spirit stays enslavable (Nulgar): an enslaved spirit led out of the 25 yd circle no longer shuts the head.

-- The static Spirit of Grol (a sniff of the summon) wandered the wreck, the only source of the amulet, once per 5 min for anyone
DELETE FROM `creature_addon` WHERE `guid`=313938;
DELETE FROM `creature` WHERE `guid`=313938 AND `id`=41267;

UPDATE `gameobject_template` SET `AIName`='SmartGameObjectAI' WHERE `entry`=203230;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=41267;
DELETE FROM `smart_scripts` WHERE `entryorguid`=203230 AND `source_type`=1;
DELETE FROM `smart_scripts` WHERE `entryorguid`=41267 AND `source_type`=0 AND `id` IN (3,4,5);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,
 `event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,
 `action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,
 `target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(203230,1,0,0,64,0,100,0,0,0,0,0,0,12,41267,1,120000,1,0,0,8,0,0,0,0,-11445.2,-3800.71,-8.93,2.16,'Head of Grol - On Open - Summon Spirit of Grol at the bunny, attacking the opener'),
(41267,0,3,0,4,0,100,1,0,0,0,0,0,1,0,2000,0,0,0,0,7,0,0,0,0,0,0,0,0,'Spirit of Grol - On Aggro - Emote Line 0 to the victim (no repeat)'),
(41267,0,4,0,52,0,100,0,0,41267,0,0,0,1,1,3000,0,0,0,0,1,0,0,0,0,0,0,0,0,'Spirit of Grol - On Text 0 Over - Yell Line 1'),
(41267,0,5,0,52,0,100,0,1,41267,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Spirit of Grol - On Text 1 Over - Yell Line 2');

DELETE FROM `creature_text` WHERE `CreatureID`=41267;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,
 `BroadcastTextId`,`TextRange`,`comment`) VALUES
(41267,0,0,'You hear a noise behind you.',41,0,100,0,0,0,0,41202,0,'Spirit of Grol - boss emote'),
(41267,1,0,'You will never take amulet!  Grol lives forever!',14,0,100,0,0,0,0,41201,0,'Spirit of Grol - yell'),
(41267,2,0,'Grol will kill you!',14,0,100,0,0,0,0,41203,0,'Spirit of Grol - yell');

DELETE FROM `conditions` WHERE (`SourceTypeOrReferenceId`=22 AND `SourceGroup`=1 AND `SourceEntry`=203230 AND `SourceId`=1)
 OR (`SourceTypeOrReferenceId`=4 AND `SourceGroup`=203230 AND `SourceEntry`=56007);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,
 `ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,203230,1,0,47,0,25699,8,0,0,0,0,'','Head of Grol - summon for 25699 incomplete'),
(22,1,203230,1,0,2,0,10753,1,0,1,0,0,'','Head of Grol - summon only without the Amulet of Grol'),
(22,1,203230,1,0,29,0,41267,25,0,1,0,0,'','Head of Grol - summon only with no living Spirit of Grol within 25 yd'),
(22,1,203230,1,1,47,0,26169,8,0,0,0,0,'','Head of Grol - summon for 26169 incomplete'),
(22,1,203230,1,1,2,0,10753,1,0,1,0,0,'','Head of Grol - summon only without the Amulet of Grol'),
(22,1,203230,1,1,29,0,41267,25,0,1,0,0,'','Head of Grol - summon only with no living Spirit of Grol within 25 yd'),
(4,203230,56007,0,0,47,0,25699,8,0,0,0,0,'','Head of Grol - Broken Amulet for 25699 incomplete'),
(4,203230,56007,0,1,47,0,26169,8,0,0,0,0,'','Head of Grol - Broken Amulet for 26169 incomplete');

-- The head comes back after 2 minutes instead of 5 (both TDBs: 120 s for the same spawn, 216238)
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `guid`=156016 AND `id`=203230;
