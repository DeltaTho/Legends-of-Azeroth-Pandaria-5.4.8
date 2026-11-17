-- Burning Steppes, Chiselgrip, the Heart of the Steppes 28184 (Alliance) / 28426 (Horde): John J. Keeshan 01 (48246) / Ariok 01
-- (48562) go with the player while the quest is in the log (zone_burning_steppes_followers.cpp).
--
-- Sourced: "On accept, Keeshan [Ariok] will join the player on the trek across the steppes ... will only attack a mob if the mob
-- hits you (not your hunter pet or warlock minion), otherwise he will say aggro quotes continuously" (wiki 28184 / 28426); the
-- summon spells 89674 / 90481 (DBC: SummonProperties 3007, AreaGroup 2830 = zone 46, effect 1 dummy aura); 48562 level 53,
-- faction 29 (TDB 4.4.2 creature_template / _difficulty; mop level 1, faction 35; the guardian summon itself takes the player's
-- level and faction); the lines broadcast 50371-50381 (Keeshan block) and 50383, 50389-50397 (Ariok), plan K6: wiki and comments
-- quote 50377-50381, 50383, 50389-50391, 50394.
-- Ours: spell_area as the caster (no TDB has a caster; plan K5), on quest status incomplete or complete (10), racemask per faction;
-- DONT_SAVE so that a relog brings him back with the aura (the AuraScript re-summons only while the aura stays); Ariok's lines
-- 50392-50397 by their position in the block; Say (12), personal to the owner (TextRange 5, the script passes him as target): text
-- reaches players who cannot see the speaker, and another player at another stage or of the other faction has no follower here.

-- Templates (TDB 4.4.2) and the follower AI
UPDATE `creature_template` SET `minlevel`=53, `maxlevel`=53, `faction`=29 WHERE `entry`=48562;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_burning_steppes_follower' WHERE `entry` IN (48246,48562);

-- Cast while the quest is in the log, in the Burning Steppes
DELETE FROM `spell_area` WHERE `spell` IN (89674,90481);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(89674,46,28184,0,0,18875469,2,1,10,0),
(90481,46,28426,0,0,33555378,2,1,10,0);

DELETE FROM `spell_custom_attribute` WHERE `spell` IN (89674,90481) AND `attribute`='SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(89674,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Personal Guardian (Keeshan 01), Chiselgrip 28184: spell_area casts it again, with the follower, at login'),
(90481,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Personal Guardian (Ariok 01), Chiselgrip 28426: spell_area casts it again, with the follower, at login');

DELETE FROM `spell_script_names` WHERE `spell_id` IN (89674,90481) AND `ScriptName` IN ('spell_burning_steppes_follower_summon','spell_burning_steppes_follower_aura');
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(89674,'spell_burning_steppes_follower_summon'),
(89674,'spell_burning_steppes_follower_aura'),
(90481,'spell_burning_steppes_follower_summon'),
(90481,'spell_burning_steppes_follower_aura');

-- Aggro lines (group 0, one picked at random)
DELETE FROM `creature_text` WHERE `CreatureID` IN (48246,48562) AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(48246,0,0,'Stay out of Redridge!',12,0,100,0,0,0,0,50371,5,'John J. Keeshan 01 - aggro'),
(48246,0,1,'AAAAHHHHH!',12,0,100,0,0,0,0,50372,5,'John J. Keeshan 01 - aggro'),
(48246,0,2,'You want more? YOU WANT MORE?',12,0,100,0,0,0,0,50373,5,'John J. Keeshan 01 - aggro'),
(48246,0,3,'Oh no... I''m not done with you.',12,0,100,0,0,0,0,50374,5,'John J. Keeshan 01 - aggro'),
(48246,0,4,'AAAAAAAAHHHHHHHH!!!',12,0,100,0,0,0,0,50375,5,'John J. Keeshan 01 - aggro'),
(48246,0,5,'There''s nowhere for you to run. The disease is inside you.',12,0,100,0,0,0,0,50376,5,'John J. Keeshan 01 - aggro'),
(48246,0,6,'Damn these orcs.',12,0,100,0,0,0,0,50377,5,'John J. Keeshan 01 - aggro'),
(48246,0,7,'Killin''s as easy as breathin''.',12,0,100,0,0,0,0,50378,5,'John J. Keeshan 01 - aggro'),
(48246,0,8,'See you in hell.',12,0,100,0,0,0,0,50379,5,'John J. Keeshan 01 - aggro'),
(48246,0,9,'You maggots brought this on yourselves.',12,0,100,0,0,0,0,50380,5,'John J. Keeshan 01 - aggro'),
(48246,0,10,'More blood! I want more blood!',12,0,100,0,0,0,0,50381,5,'John J. Keeshan 01 - aggro'),
(48562,0,0,'You fight without HONOR!',12,0,100,0,0,0,0,50383,5,'Ariok 01 - aggro'),
(48562,0,1,'Lok''tar ogar!',12,0,100,0,0,0,0,50389,5,'Ariok 01 - aggro'),
(48562,0,2,'Your blood... my axe.',12,0,100,0,0,0,0,50390,5,'Ariok 01 - aggro'),
(48562,0,3,'You have many lessons to learn.',12,0,100,0,0,0,0,50391,5,'Ariok 01 - aggro'),
(48562,0,4,'You fought without honor.',12,0,100,0,0,0,0,50392,5,'Ariok 01 - aggro (attribution by position)'),
(48562,0,5,'Ha! I expected a challenge!',12,0,100,0,0,0,0,50393,5,'Ariok 01 - aggro (attribution by position)'),
(48562,0,6,'There''s more where that came from. I am a well of rage.',12,0,100,0,0,0,0,50394,5,'Ariok 01 - aggro'),
(48562,0,7,'Feel my rage!',12,0,100,0,0,0,0,50395,5,'Ariok 01 - aggro (attribution by position)'),
(48562,0,8,'And stay down!',12,0,100,0,0,0,0,50396,5,'Ariok 01 - aggro (attribution by position)'),
(48562,0,9,'This is too easy.',12,0,100,0,0,0,0,50397,5,'Ariok 01 - aggro (attribution by position)');
