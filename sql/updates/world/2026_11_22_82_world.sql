-- Burning Steppes, Glory Amidst Chaos (28321 / 28455): the invaders that still fight are gone once the Assault is handed in
-- (user, play test 2026-11-20).
--
-- Before: phase 342 (the 272 Blackrock Invaders 48432 that do not cower, and the 81 posed dead) stayed on through Glory Amidst
-- Chaos, as Glory's comments have it for retail ("the leftovers aggro you"). In play the hostile ones stood packed at the ways
-- in to the three bosses (Firegut Furnace, the peak cave, the Skull Warren): too many to get through on foot.
-- Ours (the user's call; retail kept them): 342 is granted only while the Assault on Dreadmaul Rock (28320 / 28454) is in the
-- log, so the dragon still has all 432 to burn. The 81 posed dead move to the aftermath phase 346 (2026_11_22_81: the cowering
-- 160 and Hellmondath's corpse; off during the cutscene, on from the dragon's reveal through Glory), so Glory's field keeps its
-- dead and its cowering survivors, who start no fight.
UPDATE `creature` c JOIN `creature_addon` a ON a.`guid`=c.`guid`
   SET c.`phaseId`=346
 WHERE c.`id`=48432 AND c.`map`=0 AND a.`auras` LIKE '%29266%';

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceGroup`=342 AND `SourceEntry`=46 AND `ElseGroup` IN (2,3);

UPDATE `phase_area` SET `Comment`='Burning Steppes - Assault on Dreadmaul Rock 1 - the Blackrock Invaders 48432 that fight: while 28320 / 28454 is in the log'
 WHERE `AreaId`=46 AND `PhaseId`=342;
UPDATE `phase_area` SET `Comment`='Burning Steppes - Assault on Dreadmaul Rock 2 - the cowering and the posed dead Blackrock Invaders 48432, Hellmondath''s corpse 48655: while 28320 / 28454 or 28321 / 28455 is in the log, not during the cutscene (aura 89947)'
 WHERE `AreaId`=46 AND `PhaseId`=346;
