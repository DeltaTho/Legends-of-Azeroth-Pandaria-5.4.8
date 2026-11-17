-- Burning Steppes, Assault on Dreadmaul Rock 28320 (A) / 28454 (H): the Obsidian-Cloaked Dragon, Fiery Breath, the leash and the
-- teleport back to the camp (plan F, S4 E1).
-- Sourced: Fiery Breath 90067 as the dragon's one ability (wiki; DBC tooltip "Inflicts $s1 damage to all Blackrock Invaders in a
--   15 yard radius" -> condition 13 on 90068 effect 0: Blackrock Invader 48432 only); "Return to Dreadmaul Rock, or you will be
--   dropped!" (BT 48653, comment 2013-11-30 [+4]); "The Blackrock forces are panicking!  Strike at them now!" (BT 48656, wiki);
--   93901 AODR: Teleport Back Master with 93898 Morgan's Vigil / 93900 Flame Crest (DBC).
-- Ours: 93898 / 93900 have no spell_target_position in mop or either TDB: 3-4 yd in front of Colonel Troteman 48307 (guid 318103)
--   and Eitrigg 48569 (guid 313225), the quests' enders, on open ground (maps + vmaps: 194.9 / 165.6), facing them; the boss
--   whisper type of 48653 and the boss emote of 48656, both personal (TextRange 5).

UPDATE `creature_template` SET `ScriptName`='npc_bs_obsidian_cloaked_dragon', `spell1`=90067 WHERE `entry`=48434;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry`=90068;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,90068,0,0,31,0,3,48432,0,0,0,0,'','Fiery Breath (Obsidian-Cloaked Dragon) - only Blackrock Invaders 48432');

DELETE FROM `spell_script_names` WHERE `spell_id`=93901 AND `ScriptName`='spell_bs_aodr_teleport_back_master';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(93901,'spell_bs_aodr_teleport_back_master');

DELETE FROM `spell_target_position` WHERE `id` IN (93898,93900) AND `effIndex`=0;
INSERT INTO `spell_target_position` (`id`,`effIndex`,`target_map`,`target_position_x`,`target_position_y`,`target_position_z`,`target_orientation`) VALUES
(93898,0,0,-8393.3,-2784.0,194.9,3.73),
(93900,0,0,-7503.4,-2187.0,165.6,5.87);

DELETE FROM `creature_text` WHERE `CreatureID`=48434;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(48434,0,0,'The Blackrock forces are panicking!  Strike at them now!',41,0,100,0,0,0,0,48656,5,'Obsidian-Cloaked Dragon - after the AODR cutscene'),
(48434,1,0,'Return to Dreadmaul Rock, or you will be dropped!',42,0,100,0,0,0,0,48653,5,'Obsidian-Cloaked Dragon - leash, outside the battle area');
