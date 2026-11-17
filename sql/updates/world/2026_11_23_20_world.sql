-- Swamp of Sorrows, the Battle of the Bloodmire and the assault on Stonard: three stages shown per player by quest state.
--
-- Sourced: the battle has three stages (wiki The Bloodmire; notes of 27795, 27843, 27845, 27849, 27851, 27854-27857):
-- stage I, Stonard Warriors against Marshtide Footmen with wardrummers and clerics, peons and peasants at the edges; stage II
-- ("The battle has advanced phases") while Tides of Darkness, Reinforcements Denied or Marking the Fallen is held: Stonard
-- Ogres and Marshtide Knights "appear", warlocks and mages, and "corpses of footmen and warriors now litter the ground";
-- stage III while Assault on Stonard, Cutting Supply or We're Under Attack! is held: "the Bloodmire is empty and Stonard is
-- besieged by Marshtide Invaders ... the normal NPCs of Stonard are not visible, including the flight master", and "when I
-- was done with the line everything reverted" (Joanna comment 2010-12-02 [+5], 27849 2014-09-01 [+1], 2013-04-18 [+3]).
-- Phase.dbc 302 "The Bloodmire - Phase II", 304 "The Bloodmire - Phase III - Stonard". Ruag (7623), Joanna (46676), the
-- spirit healers and the whole of Marshtide Watch stay phase 0: Ruag is met upstairs in the inn during the assault (27849
-- 2011-11-27 [+12]) and takes the Horde hand-ins.
--
-- Ours: phase 125 (Phase.dbc "Test Phase", unused) carries the normal Stonard, hidden only during the assault, and phase 126
-- (Phase.dbc "Test Phase", unused) the stage-I battle of the Bloodmire, hidden while any stage-II or stage-III quest is in
-- the log, because a phase-0 spawn can never be hidden from a player here (every player carries 169); the quest windows
-- (mask 10, "in the log": complete or incomplete); all four phases keyed on the zone, so a stage is seen from anywhere in the
-- Swamp of Sorrows (the Blasted Lands surface is 113 yd or more from any phased spawn, beyond the 90-yd view range).
-- Stage II replaces stage I (plan question 1, default changed in review): creatures of different phases cannot see each
-- other here, so shown together the ogres would walk through the living footmen without a fight, beside the corpses the
-- wiki puts there. Every stage-I quest is rewarded before stage II opens (2026_11_23_22), so no stage-I target is ever
-- needed while 126 is hidden. The additive variant is R\tmp\coder-b\alt_stage2_additive.sql (one file).
-- Retail's PhaseGroup 526 {169, 304} also hid other players from a stage-III player; this core gives every player 169, so
-- players stay visible to each other (plan D2, R-16: recorded, not emulated).

DELETE FROM `phase_area` WHERE `AreaId`=8 AND `PhaseId` IN (125,126,302,304);
INSERT INTO `phase_area` (`AreaId`,`PhaseId`,`Comment`) VALUES
(8,125,'Swamp of Sorrows - normal Stonard (hidden during the assault)'),
(8,126,'Swamp of Sorrows - The Bloodmire, stage I battle (hidden in stages II and III)'),
(8,302,'Swamp of Sorrows - The Bloodmire, Phase II'),
(8,304,'Swamp of Sorrows - The Bloodmire, Phase III - Stonard');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceEntry`=8 AND `SourceGroup` IN (125,126,302,304);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(26,125,8,0,0,47,0,27849,10,0,1,0,0,'','Normal Stonard - Assault on Stonard not in the log'),
(26,125,8,0,0,47,0,27851,10,0,1,0,0,'','Normal Stonard - Cutting Supply not in the log'),
(26,125,8,0,0,47,0,27857,10,0,1,0,0,'','Normal Stonard - We''re Under Attack! not in the log'),
(26,126,8,0,0,47,0,27795,10,0,1,0,0,'','Bloodmire stage I - Tides of Darkness (A) not in the log'),
(26,126,8,0,0,47,0,27843,10,0,1,0,0,'','Bloodmire stage I - Reinforcements Denied (A) not in the log'),
(26,126,8,0,0,47,0,27845,10,0,1,0,0,'','Bloodmire stage I - Marking the Fallen (A) not in the log'),
(26,126,8,0,0,47,0,27854,10,0,1,0,0,'','Bloodmire stage I - Tides of Darkness (H) not in the log'),
(26,126,8,0,0,47,0,27855,10,0,1,0,0,'','Bloodmire stage I - Reinforcements Denied (H) not in the log'),
(26,126,8,0,0,47,0,27856,10,0,1,0,0,'','Bloodmire stage I - Marking the Fallen (H) not in the log'),
(26,126,8,0,0,47,0,27849,10,0,1,0,0,'','Bloodmire stage I - Assault on Stonard not in the log'),
(26,126,8,0,0,47,0,27851,10,0,1,0,0,'','Bloodmire stage I - Cutting Supply not in the log'),
(26,126,8,0,0,47,0,27857,10,0,1,0,0,'','Bloodmire stage I - We''re Under Attack! not in the log'),
(26,302,8,0,0,47,0,27795,10,0,0,0,0,'','Bloodmire Phase II - Tides of Darkness (A) in the log'),
(26,302,8,0,1,47,0,27843,10,0,0,0,0,'','Bloodmire Phase II - Reinforcements Denied (A) in the log'),
(26,302,8,0,2,47,0,27845,10,0,0,0,0,'','Bloodmire Phase II - Marking the Fallen (A) in the log'),
(26,302,8,0,3,47,0,27854,10,0,0,0,0,'','Bloodmire Phase II - Tides of Darkness (H) in the log'),
(26,302,8,0,4,47,0,27855,10,0,0,0,0,'','Bloodmire Phase II - Reinforcements Denied (H) in the log'),
(26,302,8,0,5,47,0,27856,10,0,0,0,0,'','Bloodmire Phase II - Marking the Fallen (H) in the log'),
(26,304,8,0,0,47,0,27849,10,0,0,0,0,'','Bloodmire Phase III - Assault on Stonard in the log'),
(26,304,8,0,1,47,0,27851,10,0,0,0,0,'','Bloodmire Phase III - Cutting Supply in the log'),
(26,304,8,0,2,47,0,27857,10,0,0,0,0,'','Bloodmire Phase III - We''re Under Attack! in the log');

-- Normal Stonard (area 75): 57 spawns of these entries. The spirit healer, Ruag and wildlife are not listed and stay phase 0.
UPDATE `creature` SET `phaseId`=125 WHERE `map`=0 AND `areaId`=75 AND `id` IN
 (864,866,980,981,982,983,984,985,986,987,988,989,1386,3622,5416,5546,5547,5591,6026,6930,8176,8177,10049,12807,17109,27705,46486,51918);
-- Stage I of the Bloodmire (area 5460): 92 spawns. The garrison of Marshtide Watch (area 5459) stays phase 0.
UPDATE `creature` SET `phaseId`=126 WHERE `map`=0 AND `areaId`=5460 AND `id` IN (46164,46166,46486,46487,46748,46840);
-- Stage II: ogres, warlocks, mages, the fallen (148 spawns; 27 corpses carry areaId 0, so these go by entry).
UPDATE `creature` SET `phaseId`=302 WHERE `map`=0 AND `id` IN (46765,46770,46775,46881,46882);
-- Stage III: invaders, defenders, cowering peons, marksmen (58 spawns) and the 18 Stonard Supplies.
UPDATE `creature` SET `phaseId`=304 WHERE `map`=0 AND `id` IN (46869,46870,46874,46876);
UPDATE `gameobject` SET `phaseId`=304 WHERE `map`=0 AND `id`=206391;
