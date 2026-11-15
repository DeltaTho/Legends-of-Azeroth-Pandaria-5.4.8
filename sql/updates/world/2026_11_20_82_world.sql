-- Badlands H-3: Rheastrasza's Gift 27858 (Alliance) / 27898 (Horde): the Deathwing camera scene, its credit and the log turn-in
-- The scene is C++ (zone_badlands_rhea.cpp): quest_badlands_rheas_gift starts it when the Gift is taken on the Hidden Clutch hill
-- (a real player only), npc_badlands_rg_camera plays it on the RG Event Camera 46958 (Vehicle 1230), npc_badlands_rg_actor runs
-- Rhea 46955, the Player Mirror Image 46956 and Deathwing 46957, player_badlands_rg_login credits a player who logged out
-- during it, spell_badlands_rg_mirror_image makes the copy (87439).
-- Sourced: the scene's sequence and lines (comments 2010-11-30 [+19], 2011-07-30 [+8]; wiki 27858 / 27898 / 27930 notes), the
-- broadcast texts 46974-46983 with their emotes and say / yell, the RG spells and their spell_target_position spots (mop = both
-- TDBs), the camera seats' CameraModes 90 / 91 / 94 (DBC), completion on every exit (2011-05-07, 2011-05-30), the log turn-in
-- (Flags 0x10000 in both TDBs: 0x310008) and Devastation 27930 following (RewardNextQuest, AUTO_ACCEPT | AUTO_TAKE).
-- Ours: the camera's flight and Rhea's stops, the first half's timings, Rhea's end, Deathwing's way off, the text range
-- (TextRange 5: the actors are the player's private summons), DONT_SAVE on the master aura 87436, the playerbot credit (R4 as
-- amended), the login credit near the Clutch.
-- Ships with section B's B-1 (the Clutch copy of Rhea, 3130202) and section A's A-13. Never ship the flag without this script.
UPDATE `quest_template` SET `Flags`=`Flags`|0x10000 WHERE `ID` IN (27858,27898);
UPDATE `quest_template_addon` SET `ScriptName`='quest_badlands_rheas_gift' WHERE `ID` IN (27858,27898);

UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_badlands_rg_actor' WHERE `entry` IN (46955,46956,46957);
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_badlands_rg_camera' WHERE `entry`=46958;

DELETE FROM `creature_text` WHERE `CreatureID` IN (46955,46957);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(46955,0,0,'I''ll just leave this right here.',12,0,100,432,0,0,0,46974,5,'Rhea - Rheastrasza''s Gift, the note'),
(46955,1,0,'Now to get the egg...',12,0,100,0,0,0,0,46975,5,'Rhea - Rheastrasza''s Gift, to the egg'),
(46955,2,0,'How''s my little baby doing?',12,0,100,4,0,0,0,46976,5,'Rhea - Rheastrasza''s Gift, the egg'),
(46955,3,0,'No... it''s... it''s you!  NO!',12,0,100,0,0,0,0,46977,5,'Rhea - Rheastrasza''s Gift, sees Deathwing (cower state by script)'),
(46955,4,0,'Yes.  Just... just show mercy to the egg.',12,0,100,0,0,0,0,46981,5,'Rhea - Rheastrasza''s Gift, mercy'),
(46957,0,0,'You impetuous little whelp... I know exactly what you and the mortal are up to.',12,0,100,1,0,0,0,46979,5,'Deathwing - Rheastrasza''s Gift'),
(46957,1,0,'Are you ready to die, dragon?',12,0,100,6,0,0,0,46980,5,'Deathwing - Rheastrasza''s Gift'),
(46957,2,0,'Mercy?!',14,0,100,5,0,0,0,46982,5,'Deathwing - Rheastrasza''s Gift'),
(46957,3,0,'THERE IS NO MERCY!  YOU WILL BURN FOR THIS, DRAGON!',14,0,100,0,0,0,0,46983,5,'Deathwing - Rheastrasza''s Gift');

-- 87439 RG: Mirror Image Aura: its three effects (TARGET_UNIT_NEARBY_ENTRY) on the Player Mirror Image
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=87439;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,7,87439,0,0,31,0,3,46956,0,0,0,0,'','RG: Mirror Image Aura - target Player Mirror Image');
DELETE FROM `spell_script_names` WHERE `spell_id`=87439;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (87439,'spell_badlands_rg_mirror_image');

-- 87436 RG: Master Force Phase/Invis (phase 307, infinite): not kept over a logout
DELETE FROM `spell_custom_attribute` WHERE `spell`=87436;
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES (87436,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','RG: Master Force Phase/Invis - not saved');

-- 87436 also hides the rider from everyone else while it lasts (its "Invis" half is not in the DBC; ours)
DELETE FROM `spell_script_names` WHERE `spell_id`=87436;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (87436,'spell_badlands_rg_master_force_phase');
