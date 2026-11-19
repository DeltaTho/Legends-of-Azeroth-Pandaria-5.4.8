-- Durotar, Spirits Be Praised 25189 (plan section 3, CP4 / ruling R17; dossier D-watershed, D-2, D-3 and event brief EB-2).
-- Ships with npc_durotar_grandmatron_tekla (zone_durotar.cpp), the escort. D-3 must not ship without it: SpecialFlags 2 with
-- nothing to complete the quest would block it.
--
-- D-2 SOURCED (both TDBs guid 309907: 562.012 -4103.38 16.8399 o2.74017, spawntimesecs 120; Wowhead 2014-08-10,
-- 2010-11-25 [+9] "inside the building at 40,35", screenshot 2011-03-21 221336): she waits in the doorway of the flooded hut.
-- mop had two copies on her escort's end point beside Raggaran (253489 visible, 253749 kneeling behind 49414 Generic Quest
-- Invisibility 1, which nothing detects). 253749 goes (it had only its creature_addon row; no pool, event, formation,
-- linked_respawn or SmartAI rows, checked); 253489 moves to the hut. Both TDBs also have 310152 at 392.446 -4081.49: a sniff of
-- her walking, used as a point of the route, not spawned. She fights what comes near (2011-06-04, 2012-10-04 [+7],
-- 2011-04-20 [+4]): IMMUNE_TO_NPC (mop only) goes, unit_flags as 32768 (UNIT_FLAG 0x8000 kept, 0x200 dropped).
DELETE FROM `creature_addon` WHERE `guid` = 253749;
DELETE FROM `creature` WHERE `guid` = 253749 AND `id` = 39325;
UPDATE `creature` SET `position_x` = 562.012, `position_y` = -4103.38, `position_z` = 16.8399, `orientation` = 2.74017,
  `areaId` = 4981, `spawntimesecs` = 120, `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 253489 AND `id` = 39325;
UPDATE `creature_template` SET `unit_flags` = 32768, `AIName` = '', `ScriptName` = 'npc_durotar_grandmatron_tekla' WHERE `entry` = 39325;

-- D-3 OURS (the mechanism; both TDBs give the quest no objectives either: retail ended it through the escort): SpecialFlags 2
-- (EXPLORATION_OR_EVENT) so the quest is no longer complete on accept; the escort completes it on arrival
-- (AreaExploredOrEventHappens for the escorting player and his group members within 60 yd).
UPDATE `quest_template_addon` SET `SpecialFlags` = 2 WHERE `ID` = 25189;

-- Her lines and Raggaran's reply, SOURCED: Wowhead 2010-11-24 [+12] (707541) quotes them in this order; broadcast_text
-- 39456, 39452, 39453, 39457, 39458 (yell), 39459, 39454 and Raggaran's 39455. Neither TDB has creature_text for them.
DELETE FROM `creature_text` WHERE `CreatureID` = 39325 AND `GroupID` BETWEEN 0 AND 6;
DELETE FROM `creature_text` WHERE `CreatureID` = 39326 AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(39325,0,0,'Let us be off then.  Take me to my grandson Raggaran.',12,0,100,0,0,0,0,39456,0,'Grandmatron Tekla - escort start'),
(39325,1,0,'I''m tired of wading in water.  Let''s make this a little bit easier on ourselves, shall we?  Spirit of water, come to our aid!',12,0,100,0,0,0,0,39452,0,'Grandmatron Tekla - second pool, before Water Walking'),
(39325,2,0,'There, isn''t that much better?',12,0,100,0,0,0,0,39453,0,'Grandmatron Tekla - after Water Walking'),
(39325,3,0,'No!  M-my ankle!  I''m not sure I can make it... after we''ve come so far...',12,0,100,0,0,0,0,39457,0,'Grandmatron Tekla - ankle'),
(39325,4,0,'Spirits of air!  Come to my aid!',14,0,100,0,0,0,0,39458,0,'Grandmatron Tekla - Air Spirit''s Boon'),
(39325,5,0,'We can continue now, I think.  Let us press on.',12,0,100,0,0,0,0,39459,0,'Grandmatron Tekla - floating on'),
(39325,6,0,'Raggaran, I''m safe.',12,0,100,0,0,0,0,39454,0,'Grandmatron Tekla - arrived'),
(39326,0,0,'Grandmatron... you''re alive!',12,0,100,0,0,0,0,39455,0,'Raggaran - Tekla arrived');
