-- Searing Gorge, Operation: Stir the Cauldron 28052 (plan E-1 .. E-4; dossier cauldron-finale 28052 F1-F5, SP-4).
--
-- E-1 Grisha 3305 (Horde) had no flight option: menu 5968 option 1 and her gossip-select rows, copied from Lanie Reed 2941
--     (Alliance; menu 5967 option 1, SmartAI 2941 ids 3/4). Sourced: TDB gossip 5968 option 1 (BroadcastText 47631).
--     Both flight masters cast 88498 triggered (cast flag 2): a mounted player picked the option and nothing happened (the cast
--     failed SPELL_FAILED_NOT_MOUNTED, Spell::CheckCast); the ride's Unit::_EnterVehicle then dismounts him (walk M3, ours).
-- E-2 The quest condition sat on option 0 ("I need a ride.", the taxi): Alliance could not use the Thorium Point taxi without
--     28052 in the log, and the flight option showed to everyone. The condition moves to option 1 of both menus: shown while
--     28052 is in the log (complete or not), and again after it until Welcome to the Brotherhood 28064 is rewarded, so that a
--     player can fly back into the Cauldron during the Slag Pit quests (comments 2012-10-09 [+14], 2012-02-09). In-log sourced;
--     the upper bound 28064 is ours.
-- E-3 The 17 static Cauldron Defenders 47470 on the landing terrace are sniff copies of 88502's summon (neither TDB spawns
--     47470): they go; their spots are the summon points of the script (zone_searing_gorge_cauldron.cpp DefenderPoints).
-- E-4 The Brotherhood Flying Machine 47467 is flown by npc_searing_gorge_flying_machine (see its commit): its SmartAI (ids 0-4,
--     actionlist 4746700) and `waypoints` 47467 (the path is in the script) go; spell1 88496 Shoot (4.4.2
--     creature_template_spell slot 0) is the action bar of its gun seat; creature_text group 0 is the whisper 47787 as
--     RAID_BOSS_WHISPER (DBC 88645 "Operation: Stir the Cauldron: Plane Boss Whisper", a script effect nothing casts).
--     The dossier's interim F5 (despawn on passenger removed) is not shipped: the script replaces it.

-- E-1
DELETE FROM `gossip_menu_option` WHERE `MenuID` = 5968 AND `OptionID` = 1;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(5968,1,0,'I''m ready to take the flight into the Cauldron!',47631,1,1,0,0,0,0,NULL,0,0);

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 3305;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3305 AND `source_type` = 0 AND `id` IN (3,4);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3305,0,3,4,62,0,100,0,5968,1,0,0,0,86,88498,2,7,0,0,0,1,0,0,0,0,0,0,0,0,'Grisha - On Gossip Option 1 Selected - Invoker Casts Summon Brotherhood Flying Machine'),
(3305,0,4,0,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Grisha - On Gossip Option 1 Selected - Close Gossip');
UPDATE `smart_scripts` SET `action_param2` = 2 WHERE `entryorguid` = 2941 AND `source_type` = 0 AND `id` = 3;

-- E-2
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (5967,5968) AND `SourceEntry` IN (0,1);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,5967,1,0,0,47,0,28052,10,0,0,0,0,'','Lanie Reed - flight into the Cauldron while Operation: Stir the Cauldron is in the log'),
(15,5967,1,0,1, 8,0,28052, 0,0,0,0,0,'','Lanie Reed - or after Operation: Stir the Cauldron ...'),
(15,5967,1,0,1, 8,0,28064, 0,0,1,0,0,'','Lanie Reed - ... until Welcome to the Brotherhood is rewarded'),
(15,5968,1,0,0,47,0,28052,10,0,0,0,0,'','Grisha - flight into the Cauldron while Operation: Stir the Cauldron is in the log'),
(15,5968,1,0,1, 8,0,28052, 0,0,0,0,0,'','Grisha - or after Operation: Stir the Cauldron ...'),
(15,5968,1,0,1, 8,0,28064, 0,0,1,0,0,'','Grisha - ... until Welcome to the Brotherhood is rewarded');

-- E-3
DELETE FROM `creature_addon` WHERE `guid` IN (313156,313158,313159,313168,313172,313181,313182,313186,313187,313189,313193,313204,313205,313209,313212,313215,313220);
DELETE FROM `creature` WHERE `id` = 47470 AND `guid` IN (313156,313158,313159,313168,313172,313181,313182,313186,313187,313189,313193,313204,313205,313209,313212,313215,313220);

-- E-4
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_searing_gorge_flying_machine', `spell1` = 88496 WHERE `entry` = 47467;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 47467 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 4746700 AND `source_type` = 9;
DELETE FROM `waypoints` WHERE `entry` = 47467;
DELETE FROM `creature_text` WHERE `CreatureID` = 47467;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(47467,0,0,'Clear the terrace for landing!  Shoot at Cauldron Defenders!',42,0,100,0,0,0,47787,0,'Brotherhood Flying Machine - gun phase (88645 Plane Boss Whisper)');
