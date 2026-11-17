-- Burning Steppes, Blood Tour 28314 / 28446, Draconic Vanguard 28315 / 28447, A Deal With a Dragon 28316 / 28448 and Glory Amidst
-- Chaos 28321 / 28455: John J. Keeshan 03 (48346) / Ariok 03 (48567) go with the player while one of them is in the log; he offers
-- the other quests of the group and takes Blood Tour and Draconic Vanguard in the field (creature_queststarter / _questender as both
-- TDBs, already in mop). zone_burning_steppes_followers.cpp. The static copies at camp go in 2026_11_22_53.
--
-- Sourced: "Accepting the first of these three quests will put Keeshan [Ariok] in the player's party ... Ariok will only attack a
-- mob if the mob hits you (not your hunter pet or warlock minion)" (wiki 28314, 28446); Blood Tour and Draconic Vanguard end at him
-- (wiki end=, both TDBs); "Keeshan joins the player's party again" for Glory (wiki 28321; comments 218896 [+31], Yogilaw); Keeshan's
-- eight quoted lines (wiki 28314: 50371-50376, 50380, 50381; the whole block 50371-50381 per plan K6); the summon spells 89869 /
-- 90483 (DBC: SummonProperties 3007, AreaGroup 2830 = zone 46); 48567 level 53 / faction 29 (TDB 4.4.2; mop level 1, faction 35;
-- the guardian summon itself takes the player's level and faction).
-- Ours: spell_area as the caster, one row per quest on status incomplete or complete (10): he stays while any of the four is held,
-- leaves with the last of the Blood Tour group handed in (the wiki says at the Placing the Pawns turn-in; plan K14 matches the camp
-- staging instead), and again after Glory; DONT_SAVE; Ariok's lines by position (no Horde quotes found, S4 U7).

-- Template (TDB 4.4.2) and the follower AI; the 03 copies keep npcflag 3 (gossip + quest giver)
UPDATE `creature_template` SET `minlevel`=53, `maxlevel`=53, `faction`=29 WHERE `entry`=48567;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_burning_steppes_follower' WHERE `entry` IN (48346,48567);

-- Cast while one of the quests is in the log, in the Burning Steppes
DELETE FROM `spell_area` WHERE `spell` IN (89869,90483);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(89869,46,28314,0,0,18875469,2,1,10,0),
(89869,46,28315,0,0,18875469,2,1,10,0),
(89869,46,28316,0,0,18875469,2,1,10,0),
(89869,46,28321,0,0,18875469,2,1,10,0),
(90483,46,28446,0,0,33555378,2,1,10,0),
(90483,46,28447,0,0,33555378,2,1,10,0),
(90483,46,28448,0,0,33555378,2,1,10,0),
(90483,46,28455,0,0,33555378,2,1,10,0);

DELETE FROM `spell_custom_attribute` WHERE `spell` IN (89869,90483) AND `attribute`='SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(89869,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Personal Guardian (Keeshan 03), Blood Tour group / Glory: spell_area casts it again, with the follower, at login'),
(90483,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Personal Guardian (Ariok 03), Blood Tour group / Glory: spell_area casts it again, with the follower, at login');

DELETE FROM `spell_script_names` WHERE `spell_id` IN (89869,90483) AND `ScriptName` IN ('spell_burning_steppes_follower_summon','spell_burning_steppes_follower_aura');
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(89869,'spell_burning_steppes_follower_summon'),
(89869,'spell_burning_steppes_follower_aura'),
(90483,'spell_burning_steppes_follower_summon'),
(90483,'spell_burning_steppes_follower_aura');

-- Aggro lines (group 0, one picked at random)
DELETE FROM `creature_text` WHERE `CreatureID` IN (48346,48567) AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(48346,0,0,'Stay out of Redridge!',12,0,100,0,0,0,0,50371,0,'John J. Keeshan 03 - aggro'),
(48346,0,1,'AAAAHHHHH!',12,0,100,0,0,0,0,50372,0,'John J. Keeshan 03 - aggro'),
(48346,0,2,'You want more? YOU WANT MORE?',12,0,100,0,0,0,0,50373,0,'John J. Keeshan 03 - aggro'),
(48346,0,3,'Oh no... I''m not done with you.',12,0,100,0,0,0,0,50374,0,'John J. Keeshan 03 - aggro'),
(48346,0,4,'AAAAAAAAHHHHHHHH!!!',12,0,100,0,0,0,0,50375,0,'John J. Keeshan 03 - aggro'),
(48346,0,5,'There''s nowhere for you to run. The disease is inside you.',12,0,100,0,0,0,0,50376,0,'John J. Keeshan 03 - aggro'),
(48346,0,6,'Damn these orcs.',12,0,100,0,0,0,0,50377,0,'John J. Keeshan 03 - aggro'),
(48346,0,7,'Killin''s as easy as breathin''.',12,0,100,0,0,0,0,50378,0,'John J. Keeshan 03 - aggro'),
(48346,0,8,'See you in hell.',12,0,100,0,0,0,0,50379,0,'John J. Keeshan 03 - aggro'),
(48346,0,9,'You maggots brought this on yourselves.',12,0,100,0,0,0,0,50380,0,'John J. Keeshan 03 - aggro'),
(48346,0,10,'More blood! I want more blood!',12,0,100,0,0,0,0,50381,0,'John J. Keeshan 03 - aggro'),
(48567,0,0,'You fight without HONOR!',12,0,100,0,0,0,0,50383,0,'Ariok 03 - aggro'),
(48567,0,1,'Lok''tar ogar!',12,0,100,0,0,0,0,50389,0,'Ariok 03 - aggro'),
(48567,0,2,'Your blood... my axe.',12,0,100,0,0,0,0,50390,0,'Ariok 03 - aggro'),
(48567,0,3,'You have many lessons to learn.',12,0,100,0,0,0,0,50391,0,'Ariok 03 - aggro'),
(48567,0,4,'You fought without honor.',12,0,100,0,0,0,0,50392,0,'Ariok 03 - aggro (attribution by position)'),
(48567,0,5,'Ha! I expected a challenge!',12,0,100,0,0,0,0,50393,0,'Ariok 03 - aggro (attribution by position)'),
(48567,0,6,'There''s more where that came from. I am a well of rage.',12,0,100,0,0,0,0,50394,0,'Ariok 03 - aggro'),
(48567,0,7,'Feel my rage!',12,0,100,0,0,0,0,50395,0,'Ariok 03 - aggro (attribution by position)'),
(48567,0,8,'And stay down!',12,0,100,0,0,0,0,50396,0,'Ariok 03 - aggro (attribution by position)'),
(48567,0,9,'This is too easy.',12,0,100,0,0,0,0,50397,0,'Ariok 03 - aggro (attribution by position)');
