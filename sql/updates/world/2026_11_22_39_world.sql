-- Burning Steppes, Strategic Cuts 28246 / 28434: the three death scenes of the Razor-Sharp Scorpid Barb 89447 (a bare DUMMY that did
-- nothing: the quest was finished only by dropping the disguise and killing the marks).
--
-- The scenes are C++ (zone_burning_steppes.cpp: npc_burning_steppes_voodooist_timan, _worgmistress_othana, _gorlop and
-- spell_burning_steppes_scorpid_barb; what the player sees and what is ours is in its header comment). Here:
-- 1. Voodooist Timan 48100 and Gorlop 9176 leave SmartAI for their scripts; their combat spells and timers (Hex, Shrink, Drain Life,
--    Poison Bolt; Ground Smash, Knock Away, Thrash - Gorlop's rows were copies of Gor'tesh's, as in both TDBs) are carried over in
--    the C++ unchanged. Worgmistress Othana 48099 had no AI. Her move into the worg pens is section C's (2026_11_22_21).
-- 2. Their lines (broadcast texts exist, none was in creature_text): Timan yells 48328, 48329; Othana says 48319-48323 (random,
--    out of combat), 48325, 48326 and yells 48327; Gorlop says 48334, 48335 and yells 48330 (wiki 28246 notes: say / yell as there).
-- 3. Gorlop's spawn 165949 moves to his TDB spawn point at the west lava pool (-8258.11, -1727.39, 140.665, o 1.817) = wiki 39.9,
--    60.5; from there the script runs him between the two pools. Neither TDB has a path for him; mop had him standing at
--    (-8246.4, -1831.8). Respawn stays 60 s (mop; TDB 120).
-- 4. The barb's check (only a ready mark; "Invalid target" otherwise) is a SpellScript in place of source-17 conditions.
-- Ours: the mechanism (C++), the group numbers, the pool positions' use as described in the C++.

-- 1
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (48100,9176,48099) AND `source_type`=0;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_burning_steppes_voodooist_timan' WHERE `entry`=48100;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_burning_steppes_worgmistress_othana' WHERE `entry`=48099;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_burning_steppes_gorlop' WHERE `entry`=9176;

-- 2
DELETE FROM `creature_text` WHERE `CreatureID` IN (48100,48099,9176);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(48100,0,0,'OW, MON!',14,0,100,0,0,0,0,48328,0,'Voodooist Timan - Strategic Cuts - stabbed'),
(48100,1,0,'HEX YOU!  HEX YOU!  HEX YOU!',14,0,100,0,0,0,0,48329,0,'Voodooist Timan - Strategic Cuts - hexes the stabber'),
(48099,0,0,'You stupid mongrels!  I ought to whip you all to death!',12,0,100,0,0,0,0,48319,0,'Worgmistress Othana - berates her worgs'),
(48099,0,1,'You wolves are worthless!  Worthless!',12,0,100,0,0,0,0,48320,0,'Worgmistress Othana - berates her worgs'),
(48099,0,2,'You stinking curs had better enjoy the taste of my whip!',12,0,100,0,0,0,0,48321,0,'Worgmistress Othana - berates her worgs'),
(48099,0,3,'I''ll make you bleed, you weak little sacks of bones!',12,0,100,0,0,0,0,48322,0,'Worgmistress Othana - berates her worgs'),
(48099,0,4,'Quit your whining, you worthless wolves!',12,0,100,0,0,0,0,48323,0,'Worgmistress Othana - berates her worgs'),
(48099,1,0,'Ahh!  I... I can''t move!',12,0,100,0,0,0,0,48325,0,'Worgmistress Othana - Strategic Cuts - stabbed'),
(48099,2,0,'No... no... get them away from me!',12,0,100,0,0,0,0,48326,0,'Worgmistress Othana - Strategic Cuts - worgs close in'),
(48099,3,0,'NO!  AHHHHHHH!!!!',14,0,100,0,0,0,0,48327,0,'Worgmistress Othana - Strategic Cuts - eaten'),
(9176,0,0,'This lava hot.',12,0,100,0,0,0,0,48334,0,'Gorlop - at a lava pool'),
(9176,1,0,'Gorlop wonder if other lava hot?',12,0,100,0,0,0,0,48335,0,'Gorlop - leaves for the other pool'),
(9176,2,0,'OWIE!  GORLOP CAN''T MOVE!  GORLOP GONNA FALL!',14,0,100,0,0,0,0,48330,0,'Gorlop - Strategic Cuts - stabbed');

-- 3
UPDATE `creature` SET `position_x`=-8258.11, `position_y`=-1727.39, `position_z`=140.665, `orientation`=1.817, `MovementType`=0, `wander_distance`=0 WHERE `guid`=165949 AND `id`=9176;

-- 4
DELETE FROM `spell_script_names` WHERE `spell_id`=89447;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (89447,'spell_burning_steppes_scorpid_barb');
