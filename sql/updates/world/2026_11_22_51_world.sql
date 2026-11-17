-- Burning Steppes, Morgan's Vigil 28310 (Alliance) / Flame Crest 28442 (Horde): John J. Keeshan 02 (48345) and Colonel Troteman
-- (48347) / Ariok 02 (48566) and Eitrigg (48570) go with the player from Chiselgrip to Morgan's Vigil / Flame Crest while the quest
-- is in the log (complete on accept; handed in to Oralius / Kibler). zone_burning_steppes_followers.cpp.
--
-- Sourced: quest text "Keeshan will be joining you on the road. As will I." / "my son Ariok will be joining you on the road. As will
-- I."; wiki "On accept, Troteman and Keeshan [Ariok and Eitrigg] join the player's party ... On complete, [they] head off to the
-- building to the east [set up outside the cave]"; "Keeshan and Colonel will spawn when you land" after a taxi (28310 2010-11-30
-- [+5]); the summon spells 89868, 89871, 90482, 90485 (DBC: SummonProperties 3007, AreaGroup 2830 = zone 46); Keeshan's lines on
-- this road (28310 2011-03-31 [+3], broadcast 50371-50381); templates 48566 level 53 / faction 29 and 48570 level 85 / faction 29
-- (TDB 4.4.2; mop level 1, faction 35; the guardian summon itself takes the player's level and faction).
-- Inferred: that the 02 copies are these quests' followers (01 = Chiselgrip, 03 = the Blood Tour group; dossier S3 U3).
-- Ours: spell_area as the caster on status incomplete or complete (10), racemask per faction; DONT_SAVE; Ariok's lines 50392-50397
-- by position (S3 U4); Troteman and Eitrigg say nothing (no lines found).

-- Templates (TDB 4.4.2) and the follower AI
UPDATE `creature_template` SET `minlevel`=53, `maxlevel`=53, `faction`=29 WHERE `entry`=48566;
UPDATE `creature_template` SET `minlevel`=85, `maxlevel`=85, `faction`=29 WHERE `entry`=48570;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_burning_steppes_follower' WHERE `entry` IN (48345,48347,48566,48570);

-- Cast while the quest is in the log, in the Burning Steppes
DELETE FROM `spell_area` WHERE `spell` IN (89868,89871,90482,90485);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(89868,46,28310,0,0,18875469,2,1,10,0),
(89871,46,28310,0,0,18875469,2,1,10,0),
(90482,46,28442,0,0,33555378,2,1,10,0),
(90485,46,28442,0,0,33555378,2,1,10,0);

DELETE FROM `spell_custom_attribute` WHERE `spell` IN (89868,89871,90482,90485) AND `attribute`='SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(89868,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Personal Guardian (Keeshan 02), Morgan''s Vigil 28310: spell_area casts it again, with the follower, at login'),
(89871,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Personal Guardian (Troteman), Morgan''s Vigil 28310: spell_area casts it again, with the follower, at login'),
(90482,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Personal Guardian (Ariok 02), Flame Crest 28442: spell_area casts it again, with the follower, at login'),
(90485,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Personal Guardian (Eitrigg), Flame Crest 28442: spell_area casts it again, with the follower, at login');

DELETE FROM `spell_script_names` WHERE `spell_id` IN (89868,89871,90482,90485) AND `ScriptName` IN ('spell_burning_steppes_follower_summon','spell_burning_steppes_follower_aura');
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(89868,'spell_burning_steppes_follower_summon'),
(89868,'spell_burning_steppes_follower_aura'),
(89871,'spell_burning_steppes_follower_summon'),
(89871,'spell_burning_steppes_follower_aura'),
(90482,'spell_burning_steppes_follower_summon'),
(90482,'spell_burning_steppes_follower_aura'),
(90485,'spell_burning_steppes_follower_summon'),
(90485,'spell_burning_steppes_follower_aura');

-- Aggro lines of Keeshan and Ariok (group 0, one picked at random)
DELETE FROM `creature_text` WHERE `CreatureID` IN (48345,48566) AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(48345,0,0,'Stay out of Redridge!',12,0,100,0,0,0,0,50371,0,'John J. Keeshan 02 - aggro'),
(48345,0,1,'AAAAHHHHH!',12,0,100,0,0,0,0,50372,0,'John J. Keeshan 02 - aggro'),
(48345,0,2,'You want more? YOU WANT MORE?',12,0,100,0,0,0,0,50373,0,'John J. Keeshan 02 - aggro'),
(48345,0,3,'Oh no... I''m not done with you.',12,0,100,0,0,0,0,50374,0,'John J. Keeshan 02 - aggro'),
(48345,0,4,'AAAAAAAAHHHHHHHH!!!',12,0,100,0,0,0,0,50375,0,'John J. Keeshan 02 - aggro'),
(48345,0,5,'There''s nowhere for you to run. The disease is inside you.',12,0,100,0,0,0,0,50376,0,'John J. Keeshan 02 - aggro'),
(48345,0,6,'Damn these orcs.',12,0,100,0,0,0,0,50377,0,'John J. Keeshan 02 - aggro'),
(48345,0,7,'Killin''s as easy as breathin''.',12,0,100,0,0,0,0,50378,0,'John J. Keeshan 02 - aggro'),
(48345,0,8,'See you in hell.',12,0,100,0,0,0,0,50379,0,'John J. Keeshan 02 - aggro'),
(48345,0,9,'You maggots brought this on yourselves.',12,0,100,0,0,0,0,50380,0,'John J. Keeshan 02 - aggro'),
(48345,0,10,'More blood! I want more blood!',12,0,100,0,0,0,0,50381,0,'John J. Keeshan 02 - aggro'),
(48566,0,0,'You fight without HONOR!',12,0,100,0,0,0,0,50383,0,'Ariok 02 - aggro'),
(48566,0,1,'Lok''tar ogar!',12,0,100,0,0,0,0,50389,0,'Ariok 02 - aggro'),
(48566,0,2,'Your blood... my axe.',12,0,100,0,0,0,0,50390,0,'Ariok 02 - aggro'),
(48566,0,3,'You have many lessons to learn.',12,0,100,0,0,0,0,50391,0,'Ariok 02 - aggro'),
(48566,0,4,'You fought without honor.',12,0,100,0,0,0,0,50392,0,'Ariok 02 - aggro (attribution by position)'),
(48566,0,5,'Ha! I expected a challenge!',12,0,100,0,0,0,0,50393,0,'Ariok 02 - aggro (attribution by position)'),
(48566,0,6,'There''s more where that came from. I am a well of rage.',12,0,100,0,0,0,0,50394,0,'Ariok 02 - aggro'),
(48566,0,7,'Feel my rage!',12,0,100,0,0,0,0,50395,0,'Ariok 02 - aggro (attribution by position)'),
(48566,0,8,'And stay down!',12,0,100,0,0,0,0,50396,0,'Ariok 02 - aggro (attribution by position)'),
(48566,0,9,'This is too easy.',12,0,100,0,0,0,0,50397,0,'Ariok 02 - aggro (attribution by position)');
