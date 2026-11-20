-- Northern Barrens, Mutiny, Mon! (14063): Tony Two-Tusk and his crew take the Maiden's Dagger from Alicia Cuthbert
-- (zone_ratchet.cpp: spell_ratchet_blow_pirate_signal_horn, npc_ratchet_tony_two_tusk, npc_ratchet_alicia_cuthbert).
-- Sourced: the lines and their order (wiki; beta comment [+24]; comments 2011-03-29 [+4], 2012-01-14 [+4]; BT 35072-35085,
-- 35077-35080 female); Alicia appears only with the horn (2012-01-14 [+4], 2011-03-29 reply [+2]); 66226 Mutiny Complete
-- (KILL_CREDIT2 34782 to the units within 25 yd of the caster, "follow him into the cabin to get the quest complete"); neither
-- TDB spawns 34782 or 34790: mop's static Alicia 265913 and the four Southsea Mutineers walking looping paths (265911 /
-- 265912 from the pier and the stern, 265914 / 265915 starting 190-250 yd up in the air) are sniff copies of the event's
-- summons. mop's event script 21888 summoned Mount Hyjal's level-1 Tony 52235 for 1 s as a trigger for Alicia's faction 14.
-- Ours: the event in the script (one at a time, question 13); the credit kept to players with the quest in progress (source
-- 13 condition on 66226; the spell has none and would "credit" any unit in range); the boss emote "Mutiny!" from Tony; the
-- say / yell ranges. Southsea Cannoneers 3382 on the deck: faction 230 is S6's (I-T6); the script turns any deck Cannoneer or
-- Cutthroat that is not 230 to 230 for the event and back after it (FactionTemplate 106 fights 230, not 190).
-- Deletes drafted by scope F (F-14063-2, F-14063-3).
DELETE FROM `creature` WHERE `guid` IN (265911,265912,265914,265915) AND `id`=34790;
DELETE FROM `creature_addon` WHERE `guid` IN (265911,265912,265914,265915);
DELETE FROM `waypoint_data` WHERE `id` IN (265911,265912,265914,265915);
DELETE FROM `creature` WHERE `guid`=265913 AND `id`=34782;
DELETE FROM `creature_addon` WHERE `guid`=265913;
DELETE FROM `event_scripts` WHERE `id`=21888;

DELETE FROM `spell_script_names` WHERE `spell_id`=66204 AND `ScriptName`='spell_ratchet_blow_pirate_signal_horn';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (66204,'spell_ratchet_blow_pirate_signal_horn');

UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_ratchet_tony_two_tusk' WHERE `entry`=34749;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_ratchet_alicia_cuthbert' WHERE `entry`=34782;
DELETE FROM `smart_scripts` WHERE `entryorguid`=34782 AND `source_type`=0;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=66226;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,66226,0,0,47,0,14063,8,0,0,0,0,'','Mutiny Complete - credit only players with Mutiny, Mon! in progress');

DELETE FROM `creature_text` WHERE `CreatureID`=34749 AND `GroupID` BETWEEN 0 AND 7;
DELETE FROM `creature_text` WHERE `CreatureID`=34782 AND `GroupID` BETWEEN 1 AND 3;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34749,0,0,'C''mon mates! Take the ship and give no quarter!',14,0,100,0,0,0,0,35072,0,'Tony Two-Tusk - Mutiny, Mon!, boarding'),
(34749,1,0,'Right, Cuthbert should be below decks. Come with me, mon!',12,0,100,0,0,0,0,35073,0,'Tony Two-Tusk - Mutiny, Mon!, going below'),
(34749,2,0,'There she is, mon! Let''s finish this business.',12,0,100,0,0,0,0,35076,0,'Tony Two-Tusk - Mutiny, Mon!, at the cabin'),
(34749,3,0,'Help me out here, mon!',12,0,100,0,0,0,0,35082,0,'Tony Two-Tusk - Mutiny, Mon!, hurt in the fight'),
(34749,4,0,'I''m countin'' on it!',12,0,100,0,0,0,0,35083,0,'Tony Two-Tusk - Mutiny, Mon!, Alicia fallen'),
(34749,5,0,'We did it! The Maiden''s Dagger is mine, all mine!',12,0,100,0,0,0,0,35084,0,'Tony Two-Tusk - Mutiny, Mon!, the credit'),
(34749,6,0,'You tell Dizzywig that I''m open to negotiations....',12,0,100,0,0,0,0,35085,0,'Tony Two-Tusk - Mutiny, Mon!, the end'),
(34749,7,0,'Mutiny!',41,0,100,0,0,0,0,35074,0,'Tony Two-Tusk - Mutiny, Mon!, the horn (boss emote)'),
(34782,1,0,'I should''ve known you were behind this, Two-Tusk. Have at it, traitor!',12,0,100,396,0,0,0,35078,0,'Alicia Cuthbert - Mutiny, Mon!, Tony at her cabin'),
(34782,2,0,'Another mutiny put to rest. Now get this blood off my decks!',12,0,100,396,0,0,0,35079,0,'Alicia Cuthbert - Mutiny, Mon!, Tony fallen'),
(34782,3,0,'Cap''n Garvey will hear of this!',12,0,100,0,0,0,0,35080,0,'Alicia Cuthbert - Mutiny, Mon!, her death');
