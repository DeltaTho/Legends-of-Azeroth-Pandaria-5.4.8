-- Remember the Light 24913: the private scene's data (the scene itself: npc_rtl_exodar_portal, zone_swamp_of_sorrows.cpp).
-- Ships only with that script: the residents' invisibility below hides them from a player with the quest in progress, and only
-- the script's copies stand in for them.
-- Sourced: the start spell 87530 (DBC "Remember the Light - Master Summon Trigger"; the scene plays on accept: wiki quest_24913
-- "On accept", Wowhead 24913 2010-12-18 [+20]); the residents' template auras 49414 / 49415 + 99480 (TDB 12.1.0 and 4.4.2);
-- Magtoor's copy says "Yes..." (bt 47051; the wiki has Magtoor answer in the
-- scene, and 47004 is the scene's Magtoor); Extreme Unction / Rise to the Light on Magtoor (wiki).
-- Ours: the detection rows (who sees the residents when, and that only holders of the quest in progress see the scene: Generic
-- Quest Invisibility 14 81717 on the portal and actors, its detection 81742 by spell_area; 81742 is in no other spell_area row
-- and no spawn within sight of the Harborage carries type 22), the copies' looks (the residents' levels 45 / 55, Magtoor's lying pose and Sleep aura as the
-- resident's; Velen at the level and rank of the Exodar's Prophet Velen 17468: 93, elite), personal text range, emotes played by
-- the script, immune and passive actors, the conditions, the ScriptNames.
-- K10: quest_template_addon 24913 is shared with section A (PrevQuestID); this file writes only SourceSpellID.

-- Avuun's old public scene (first accepter only; one per 55 s) goes
DELETE FROM `smart_scripts` WHERE (`entryorguid`=17127 AND `source_type`=0) OR (`entryorguid`=1712700 AND `source_type`=9);
UPDATE `creature_template` SET `AIName`='' WHERE `entry`=17127;

-- The residents: Anchorite Avuun 17127 (Generic Quest Invisibility 1, type 7 value 1) and Magtoor 1776 (Generic Quest
-- Invisibility 2, type 8 value 100, asleep)
UPDATE `creature_template_addon` SET `auras`='49414' WHERE `entry`=17127;
UPDATE `creature_template_addon` SET `auras`='49415 99480' WHERE `entry`=1776;

-- In The Harborage: everyone sees Avuun unless Remember the Light is in progress (NONE, COMPLETE, REWARDED = 67), and sees Magtoor
-- only before taking it (NONE = 1). Detection strengths 1000 / 100 reach the invisibilities 1 / 100
DELETE FROM `spell_area` WHERE `spell` IN (49416,49417) AND `area`=657;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(49416,657,24913,0,0,0,2,1,67,0),
(49417,657,24913,0,0,0,2,1,1,0);

-- The start spell: summons the Exodar Portal, the scene's controller
INSERT INTO `quest_template_addon` (`ID`,`SourceSpellID`) VALUES (24913,87530) ON DUPLICATE KEY UPDATE `SourceSpellID`=87530;

-- The portal (immune, not selectable) and the actors Velen 46986, Avuun 47001, Magtoor 47004 (immune to players and NPCs)
UPDATE `creature_template` SET `ScriptName`='npc_rtl_exodar_portal', `AIName`='', `unit_flags`=33555200 WHERE `entry`=46988;
UPDATE `creature_template` SET `ScriptName`='npc_rtl_scene_actor', `AIName`='', `unit_flags`=768 WHERE `entry` IN (46986,47001,47004);
UPDATE `creature_template` SET `minlevel`=45, `maxlevel`=45, `rank`=0 WHERE `entry`=47001;
UPDATE `creature_template` SET `minlevel`=55, `maxlevel`=55, `rank`=0 WHERE `entry`=47004;
UPDATE `creature_template` SET `minlevel`=93, `maxlevel`=93, `rank`=1 WHERE `entry`=46986;

-- Only holders of the quest in progress see the scene (detection 81742 while 24913 is INCOMPLETE = 8, in The Harborage)
DELETE FROM `spell_area` WHERE `spell`=81742 AND `area`=657;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(81742,657,24913,0,0,0,2,1,8,0);

-- The scene's invisibility on the portal and the actors; the actors also detect it (an invisible unit sees only units that detect
-- its type, so Velen could not reach Magtoor otherwise). Magtoor's copy lies in the bed asleep as the resident does (the
-- resident's addon values and Sleep 99480); Avuun's copy as the resident Avuun's addon
DELETE FROM `creature_template_addon` WHERE `entry` IN (46986,46988,47001,47004);
INSERT INTO `creature_template_addon` (`entry`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(46986,0,0,0,0,0,0,1,0,0,0,0,0,0,'81717 81742'),
(46988,0,0,0,0,0,0,1,0,0,0,0,0,0,'81717'),
(47001,0,0,0,0,0,1,1,0,0,0,0,0,0,'81717 81742'),
(47004,0,0,0,3,0,1,1,0,0,0,0,0,0,'81717 81742 99480');

-- Lines: Magtoor's "Yes..." is said by the scene's Magtoor; all of the scene's lines are personal (the script sends each to each
-- viewer). The resident Magtoor's old row (1776 group 0) is left as it was; nothing says it any more
DELETE FROM `creature_text` WHERE `CreatureID`=47004 AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(47004,0,0,'Yes...',12,0,100,0,0,0,0,47051,5,'Magtoor - Remember the Light');
-- The emotes of these rows (6, 5, 273, 396) are played once per line by the script, not once per viewer
UPDATE `creature_text` SET `TextRange`=5, `Emote`=0 WHERE `CreatureID` IN (46986,47001);

-- Extreme Unction 87524 and its tick Rise to the Light 87525 (TARGET_UNIT_NEARBY_ENTRY) find the scene's Magtoor
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceEntry` IN (87524,87525);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,87524,0,0,31,0,3,47004,0,0,0,0,'','Extreme Unction - target Magtoor (Remember the Light)'),
(13,1,87525,0,0,31,0,3,47004,0,0,0,0,'','Rise to the Light - target Magtoor (Remember the Light)');
