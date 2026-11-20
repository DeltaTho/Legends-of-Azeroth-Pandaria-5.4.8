-- Burning Steppes, Assault on Dreadmaul Rock (28320 / 28454) and Glory Amidst Chaos (28321 / 28455): two play-test findings
-- (user, 2026-11-20).
--
-- 1. The cowering Blackrock Invaders start no fight.
-- Before: all 432 live Blackrock Invaders 48432 pulled on sight (2026_11_22_26 cleared the template's CIVILIAN flag, as the
-- TDBs and Glory's comments have it), the 160 among them that cower (template aura 78087 Cosmetic - Cower (Upper Body) Anim
-- Kit; the other 272 have an addon row of their own without it) included: a soldier shaking with fear ran up and attacked.
-- Ours (the user's call; retail pulled with all of them): a spawn that wears 78087 is set DEFENSIVE one second after each
-- spawn / reset, so it fights back when hit but starts nothing; the 272 that do not cower stay aggressive. Needs the core's
-- SmartAI::MoveInLineOfSight fix of the same commit series (a DEFENSIVE SmartAI creature pulled like an aggressive one).
DELETE FROM `smart_scripts` WHERE `entryorguid`=48432 AND `source_type`=0 AND `id`=1;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(48432,0,1,0,1,0,100,1,1000,1000,0,0,0,8,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackrock Invader - Out of Combat (No Repeat) - Set React State Defensive (only the cowering ones: condition)');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=2 AND `SourceEntry`=48432 AND `SourceId`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,2,48432,0,0,1,1,78087,0,0,0,0,0,'','Blackrock Invader - set defensive only while it wears Cosmetic - Cower (Upper Body) Anim Kit');

-- 2. What the pit lord leaves behind is not there while he is being summoned.
-- Before: the posed corpse 48655 (guid 313261) and the cowering invaders shared phase 342 with the rest of the army, which is
-- on for as long as the Assault is in the log - the cutscene included, so the dead pit lord lay in the shot in which Xi'lun
-- summons the living one and soldiers cowered before there was anything to fear.
-- Ours (the user's split): the corpse and the 160 cowering invaders (the spawns without an addon row of their own, see 1)
-- move to phase 346 (Phase.dbc "Assault on Dreadmaul Rock 2"; no spawn, phase_area row or spell used it), granted like 342
-- but only while the cutscene's aura 89947 (effect 1: PHASE 341) is not on the player: from the dragon's reveal through Glory
-- Amidst Chaos. The other 272 stay in 342 as before, so the dragon still has all 432 to burn. The core looks at area phases
-- again only on area and quest changes, so spell_bs_aodr_summon_camera_phase does it when 89947 lands and goes.
UPDATE `creature` SET `phaseId`=346 WHERE `guid`=313261 AND `id`=48655;
UPDATE `creature` c LEFT JOIN `creature_addon` a ON a.`guid`=c.`guid`
   SET c.`phaseId`=346
 WHERE c.`id`=48432 AND c.`map`=0 AND a.`guid` IS NULL;

DELETE FROM `phase_area` WHERE `AreaId`=46 AND `PhaseId`=346;
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(46,346,'Burning Steppes - Assault on Dreadmaul Rock 2 - the cowering Blackrock Invaders 48432 and Hellmondath''s corpse 48655: while 28320 / 28454 or 28321 / 28455 is in the log, not during the cutscene (aura 89947)');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=346 AND `SourceEntry`=46;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,346,46,0,0,47,0,28320,10,0,0,0,0,'','Burning Steppes phase 346 - Assault on Dreadmaul Rock (A) in the log'),
(26,346,46,0,0,1,0,89947,1,0,1,0,0,'','Burning Steppes phase 346 - and not in the cutscene (AODR: Summon Camera/Phase)'),
(26,346,46,0,1,47,0,28454,10,0,0,0,0,'','Burning Steppes phase 346 - Assault on Dreadmaul Rock (H) in the log'),
(26,346,46,0,1,1,0,89947,1,0,1,0,0,'','Burning Steppes phase 346 - and not in the cutscene (AODR: Summon Camera/Phase)'),
(26,346,46,0,2,47,0,28321,10,0,0,0,0,'','Burning Steppes phase 346 - Glory Amidst Chaos (A) in the log'),
(26,346,46,0,3,47,0,28455,10,0,0,0,0,'','Burning Steppes phase 346 - Glory Amidst Chaos (H) in the log');

DELETE FROM `spell_script_names` WHERE `spell_id`=89947 AND `ScriptName`='spell_bs_aodr_summon_camera_phase';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(89947,'spell_bs_aodr_summon_camera_phase');
