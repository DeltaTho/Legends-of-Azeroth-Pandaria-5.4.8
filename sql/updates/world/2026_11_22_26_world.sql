-- Burning Steppes: the Blackrock army of Assault on Dreadmaul Rock (28320 / 28454) is seen only by the players fighting it
-- (dossier S4 2.8#14, S4-F1b, H4, S4-F14; S5 3.5; plan C-09, C-10, C-11, K13).
--
-- Before: 692 Blackrock Invaders stood in phase 0 for everyone, at every stage and of both factions, across Valley of Ashes,
-- Dreadmaul Rock and Terror Wing Path: 515 Blackrock Invader 48432 (faction 40, hostile, civilian so they never pulled) stood in the way of
-- every quest of the region; 177 48414 (IMMUNE_TO_PC, no AI) stood among them; Hellmondath 48655 and 81 invaders posed dead (29266) walked about.
-- Sourced: neither TDB spawns a single invader (one sniff, both boxes); Phase.dbc 342 "Assault on Dreadmaul Rock 1" and 341
-- "Assault on Dreadmaul Rock - Cinematic", granted by 89947 AODR: Summon Camera/Phase; the leftovers still fight the player in Glory
-- Amidst Chaos (28321 / 28455 comments); posed-dead spawns idle (both TDBs; 29266 is a stun).
-- Ours (S4 H4, the encoding section F reuses): 48432 and Hellmondath in phase 342, granted zone-wide (one phase_area row) while
-- 28320 / 28454 or 28321 / 28455 is in the log (mask 10); 48414 in phase 341, which only F's camera aura grants, so they are
-- unseen until F ships (their being cinematic-only is inferred: name, count, place, IMMUNE_TO_PC). The posed-dead invaders get
-- IMMUNE_TO_PC (template 0x8210 | 0x100; a spawn's unit_flags replaces the template's) so they are scenery, not kills.
-- One of each exact duplicate (0.2-0.5 yd, same entry): 313590 (of 313582), 313914 (of 313911), 313915 (of 313912).
-- 48432 flags_extra 2 (CIVILIAN, mop only; both TDBs 0) kept the whole army from ever starting a fight (Creature::CanStartAttack),
-- while Glory's sources say the leftovers aggro you (28455 2012-02-25 [+32], 28321 [+33], 28320 Nythe [+2]): cleared, as the TDBs.
-- Only players (and their pets / followers) in phase 342 can be seen and attacked. The posed dead keep IMMUNE_TO_PC | IMMUNE_TO_NPC
-- and the 29266 stun, so they start nothing; the live ones keep the template's IMMUNE_TO_NPC, so they do not assist (CanAssistTo).

DELETE FROM `creature_addon` WHERE `guid` IN (313590,313914,313915);
DELETE FROM `creature` WHERE `guid` IN (313590,313914,313915) AND `id` IN (48414,48432);

UPDATE `creature_template` SET `flags_extra`=0 WHERE `entry`=48432;
UPDATE `creature` SET `phaseId`=342 WHERE `id`=48432 AND `map`=0;
UPDATE `creature` SET `phaseId`=342 WHERE `guid`=313261 AND `id`=48655;
UPDATE `creature` SET `phaseId`=341 WHERE `id`=48414 AND `map`=0;

-- S4-F14 (s4_draft.sql): the posed dead lie still.
UPDATE `creature` c JOIN `creature_addon` a ON a.`guid`=c.`guid`
   SET c.`MovementType`=0, c.`wander_distance`=0, c.`unit_flags`=0x8310
 WHERE c.`id`=48432 AND a.`auras` LIKE '%29266%';
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid`=313261 AND `id`=48655;

DELETE FROM `phase_area` WHERE `AreaId`=46 AND `PhaseId`=342;
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(46,342,'Burning Steppes - Assault on Dreadmaul Rock 1 - the Blackrock army 48432 and Hellmondath 48655: while 28320 / 28454 or 28321 / 28455 is in the log');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=342 AND `SourceEntry`=46;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,342,46,0,0,47,0,28320,10,0,0,0,0,'','Burning Steppes phase 342 - Assault on Dreadmaul Rock (A) in the log'),
(26,342,46,0,1,47,0,28454,10,0,0,0,0,'','Burning Steppes phase 342 - Assault on Dreadmaul Rock (H) in the log'),
(26,342,46,0,2,47,0,28321,10,0,0,0,0,'','Burning Steppes phase 342 - Glory Amidst Chaos (A) in the log'),
(26,342,46,0,3,47,0,28455,10,0,0,0,0,'','Burning Steppes phase 342 - Glory Amidst Chaos (H) in the log');
