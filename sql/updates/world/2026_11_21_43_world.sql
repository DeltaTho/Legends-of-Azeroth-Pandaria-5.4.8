-- Searing Gorge: Rendan's Weakness (28034) - the guards' "Care to join our dance?", the dancing line and the dancing Lunk
-- (plan D-8; grimesilt-lunk F-LUNK-6, E2.4, SP3; C++ npc_sg_iron_summit_dancer, spell_sg_summon_dancer, npc_sg_lunk_follower).
-- Sourced: the option (menu 12265, BT 47607, both TDBs), the three Summon Dancer spells and 88460's credit (DBC), "every guard you
-- talk to joins your conga line" (Wowhead 2011-01-19 [+22], 2011-02-20 [+9]), Lunk comes along dancing (2011-08-23 [+5],
-- 2013-03-12 [-1], screenshots 202159 / 202161), the follower spell 88450 (DBC, private, like 88166 / 88292).
-- Found here: the option had OptionNpcflag 0, which this core never shows (Player::PrepareGossipMenu: OptionNpcFlag & npcflags):
-- set to 1 (gossip) as the option rows of every other gossip NPC.
-- The player dances too (2011-02-20 [+9], 2011-02-27 [+15], 2011-08-23 [+5], 2011-11-03 [+5], 2013-03-12, 2013-12-21 [+3]; this
-- overturns the Q6 default): 88451 Lunk's Infectious Dance reaches only Lunk's owner and his dancers and plays a dance on the owner
-- (C++ spell_sg_lunks_infectious_dance).
-- Ours: the spell_area window (as 88166 / 88292), the dancers' line and their passive, unattackable AI, the owner's dance anim
-- (AnimKit 1535) and the aura's target limit.

UPDATE `gossip_menu_option` SET `OptionNpcflag`=1 WHERE `MenuID`=12265 AND `OptionID`=0;

-- The guards: the option only while the quest is in progress; each pick adds the next dancer, the third credits (rows fire in id
-- order on one pick, so the highest dancer is checked first and one pick adds one dancer). CONDITION_AURA's ConditionValue2 is
-- the effect index (Unit::HasAuraEffect): on 88457 / 88459 / 88460 effect 0 is the summon, the aura is effect 1.
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=47434;
DELETE FROM `smart_scripts` WHERE `entryorguid`=47434 AND `source_type`=0 AND `id` BETWEEN 3 AND 6;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47434,0,3,0,62,0,100,0,12265,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Iron Summit Guard - On Gossip Select - Close Gossip'),
(47434,0,4,0,62,0,100,0,12265,0,0,0,0,85,88460,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Iron Summit Guard - On Gossip Select - Invoker Cast Summon Dancer 3 (credit)'),
(47434,0,5,0,62,0,100,0,12265,0,0,0,0,85,88459,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Iron Summit Guard - On Gossip Select - Invoker Cast Summon Dancer 2'),
(47434,0,6,0,62,0,100,0,12265,0,0,0,0,85,88457,2,0,0,0,0,7,0,0,0,0,0,0,0,0,'Iron Summit Guard - On Gossip Select - Invoker Cast Summon Dancer 1');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=47434 AND `SourceGroup` IN (5,6,7);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=12265;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,12265,0,0,0,9,0,28034,0,0,0,0,0,'','Iron Summit Guard - join option only while Rendan''s Weakness is incomplete'),
(22,5,47434,0,0,1,0,88459,1,0,0,0,0,'','Guard - dancer 3 only with dancer 2'),
(22,5,47434,0,0,1,0,88460,1,0,1,0,0,'','Guard - dancer 3 only once'),
(22,6,47434,0,0,1,0,88457,1,0,0,0,0,'','Guard - dancer 2 only with dancer 1'),
(22,6,47434,0,0,1,0,88459,1,0,1,0,0,'','Guard - dancer 2 only once'),
(22,7,47434,0,0,1,0,88457,1,0,1,0,0,'','Guard - dancer 1 only once'),
(22,7,47434,0,0,9,0,28034,0,0,0,0,0,'','Guard - dancer 1 only on Rendan''s Weakness');

-- The dancers and their auras
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_sg_iron_summit_dancer' WHERE `entry` IN (47435,47436,47437);
DELETE FROM `spell_script_names` WHERE `spell_id` IN (88457,88459,88460) AND `ScriptName`='spell_sg_summon_dancer';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(88457,'spell_sg_summon_dancer'),(88459,'spell_sg_summon_dancer'),(88460,'spell_sg_summon_dancer');
DELETE FROM `spell_custom_attribute` WHERE `spell` IN (88457,88459,88460) AND `attribute`='SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(88457,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Dancer 1: the guardian does not outlive a logout'),
(88459,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Dancer 2: the guardian does not outlive a logout'),
(88460,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Dancer 3: the guardian does not outlive a logout');

-- Lunk 47430 dances along while the quest is in the log (in progress or complete) in Searing Gorge
DELETE FROM `spell_area` WHERE `spell`=88450 AND `area`=51;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(88450,51,28034,28034,0,0,2,1,74,11);

-- Lunk's Infectious Dance: only Lunk's owner and his dancers, and the owner dances
DELETE FROM `spell_script_names` WHERE `spell_id`=88451 AND `ScriptName`='spell_sg_lunks_infectious_dance';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (88451,'spell_sg_lunks_infectious_dance');
