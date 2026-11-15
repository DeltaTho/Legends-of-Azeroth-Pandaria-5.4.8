-- Badlands, Agmond's End: Return to Blam (27794 Alliance / 27888 Horde) - the purification scene after the hand-in, run by
-- npc_badlands_eye_of_the_watchers (zone_badlands_titans.cpp).
--
-- Sourced: the Eye of the Watchers' seven lines (BroadcastText 46896-46902, in this order; 46899 twice: comment 2010-11-30 [+16],
--   wiki notes), the scene spells 87186 / 87196 / 87197 / 87207-87209 / 87218 and their points.
-- Ours: the lines are personal to the player (TextRange 5: the Eye is his private summon, other players do not see it); the
--   props 46826 / 46828 / 46829 get a passive script (faction 16 with no AI they would attack their player: AggressorAI, and
--   IMMUNE_TO_PC does not stop it here); the corruption 46836 gets its smoke and a 6 s life from a script; the three Summon
--   Corruption spells pick their prop through conditions (TARGET_DEST_NEARBY_ENTRY); the marker 87186 is not saved, so a relog
--   in mid-scene cannot keep the camp's static egg hidden (spell_area aura_spell -87186 of the staging commit).
-- Blam's line "Hey, look! It's flying!" is his creature_text group 2, written with his other texts by the Blam data commit.

DELETE FROM `creature_text` WHERE `CreatureID`=46833;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(46833,0,0,'Boot-up protocol completed.  Scanning for objective...',12,0,100,0,0,0,0,46896,5,'Eye of the Watchers - Return to Blam 1'),
(46833,1,0,'Objective identified.  Scanning...',12,0,100,0,0,0,0,46897,5,'Eye of the Watchers - Return to Blam 2'),
(46833,2,0,'Anomaly detected.  Probable source: Azerothian Old God.  Attempting to excise anomaly...',12,0,100,0,0,0,0,46898,5,'Eye of the Watchers - Return to Blam 3 (whelp corpse)'),
(46833,3,0,'Anomaly excised.  Repeating sub-protocol...',12,0,100,0,0,0,0,46899,5,'Eye of the Watchers - Return to Blam 4 (the eggs, twice)'),
(46833,4,0,'Anomaly excised.  Re-assembling remaining material...',12,0,100,0,0,0,0,46900,5,'Eye of the Watchers - Return to Blam 5'),
(46833,5,0,'Viable subject compiled.  No anomalies detected.',12,0,100,0,0,0,0,46901,5,'Eye of the Watchers - Return to Blam 6'),
(46833,6,0,'User-objective protocol complete.  Stasis protocol re-enabled.',12,0,100,0,0,0,0,46902,5,'Eye of the Watchers - Return to Blam 7');

UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_badlands_eye_of_the_watchers' WHERE `entry`=46833;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_badlands_blam_scene_actor' WHERE `entry` IN (46826,46828,46829);
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_badlands_black_dragon_corruption' WHERE `entry`=46836;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (87207,87208,87209);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,87207,0,0,31,0,3,46826,0,0,0,0,'','Return to Blam: Summon Corruption 1 at the whelp corpse'),
(13,1,87208,0,0,31,0,3,46828,0,0,0,0,'','Return to Blam: Summon Corruption 2 at the wild egg'),
(13,1,87209,0,0,31,0,3,46829,0,0,0,0,'','Return to Blam: Summon Corruption 3 at Nyxondra''s egg');

DELETE FROM `spell_custom_attribute` WHERE `spell`=87186;
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(87186,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Return to Blam: scene marker not saved');
