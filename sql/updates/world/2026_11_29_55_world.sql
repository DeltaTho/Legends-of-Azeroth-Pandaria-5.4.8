-- Northern Barrens, A Growing Problem (13988): Tonga's eagle and the summit scene (npc_tonga_eyes, zone_the_barrens.cpp).
-- Sourced: Wowhead 13988 comments (2010-07-07 beta, 2011-01-14, 2012-02-19 [+214] and replies, 2013-04-04, 2014-02-09);
-- broadcast texts 34863-34868; video k9qcPVg-bv8 (5.4.8, second-pass.md: credit within ~10 s of the spirit appearing);
-- both TDBs spawn no Tonga's Spirit (34623 is a summon of 65763).
-- Ours: SourceSpellID 65751 (plan question 9: the eagle comes on accept; three comments imply it, the TDBs have 0 - to undo,
-- set it back to 0 and the player uses the totem), all lines personal (TextRange 5). All five lines are the spirit's, as the
-- wiki gives them (review round 1, walk M4). The eagle flies (video 0:00-0:33; review round 1, walk W3).

-- The eagle runs the scene, and flies (no movement row before: ground only)
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_tonga_eyes' WHERE `entry` = 34615;
DELETE FROM `creature_template_movement` WHERE `CreatureId` = 34615;
INSERT INTO `creature_template_movement` (`CreatureId`,`Ground`,`Swim`,`Flight`,`Rooted`,`Chase`,`Random`,`InteractionPauseTimer`) VALUES
(34615,1,0,1,0,0,0,NULL);

-- C-13988-3: the eagle comes on accept (QuestHandler casts SourceSpellID on the player)
UPDATE `quest_template_addon` SET `SourceSpellID` = 65751 WHERE `ID` = 13988;

-- C-13988-4: the spirit is summoned by the scene, not a standing (wandering) spawn
DELETE FROM `creature_addon` WHERE `guid` = 310964;
DELETE FROM `creature` WHERE `guid` = 310964;

-- Lines
DELETE FROM `creature_text` WHERE `CreatureID` = 34615 AND `GroupID` = 0;
DELETE FROM `creature_text` WHERE `CreatureID` = 34623 AND `GroupID` IN (0,1,2,3,4);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT CASE `ID` WHEN 34863 THEN 34615 ELSE 34623 END,
       CASE `ID` WHEN 34863 THEN 0 WHEN 34864 THEN 0 WHEN 34865 THEN 1 WHEN 34866 THEN 2 WHEN 34867 THEN 3 ELSE 4 END,
       0, `Text`, CASE `ID` WHEN 34863 THEN 16 ELSE 12 END, 0, 100, 0, 0, 0, 0, `ID`, 5,
       CASE `ID` WHEN 34863 THEN 'Tonga''s Eyes - summit reached' ELSE 'Tonga''s Spirit - A Growing Problem scene' END
FROM `broadcast_text` WHERE `ID` IN (34863,34864,34865,34866,34867,34868);
