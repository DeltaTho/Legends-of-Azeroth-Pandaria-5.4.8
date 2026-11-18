-- Blasted Lands A (_03): the two Silithus portals to the Blasted Lands work only while their quest is in the log, and the
-- Alliance one has a destination (dossier S2 F-PORTAL, its Horde twin S2 H-S1-1; S1 U-1).
--
-- Today: Nethergarde Needs You! (28867): the portal 207566 by the Nethergarde Mage casts 93726 Teleport to Blasted Lands, which
-- has no spell_target_position row (mop and both TDBs), so the player goes nowhere. Both portals (207566 / 93726 and 207565 /
-- 93733 for Call of the Warmatron 28865) can be used by anyone: GameObject::Use (SPELLCASTER, GameObject.cpp 1734-1758) checks no
-- quest, and the templates' Data5 PlayerConditions 11561 / 11562 are not in the 5.4.8 PlayerCondition.dbc (ids 923-23013, both
-- absent) and the 5.4.8 client decomp reads PlayerCondition only for vendor tooltips and a server failure message: the client
-- cannot grey them out either (settles S1 U-1).
-- SOURCED: quest text "take this portal in front of me to the Blasted Lands and speak with the quartermaster"; 28867 2011-01-18
-- reply [+5] "after completing the quest you are not able to use it again ... keep it in your log", 2010-12-06 reply [+3];
-- 50587 2013-06-01 [+4] "the portal only works while you have the quest"; 28865 2011-03-14 reply [+4] "the portal closes after
-- you finish the quest". The Horde destination 13 yd from Okrilla (both TDBs).
-- OURS: the Alliance landing spot (no source gives 93726's target): beside Quartermaster Lungertz (guid 163071) on the great-hall
-- floor, 4.5 yd from him, facing him (vmap floor 81.71 at the spot), the pattern of the Horde twin. The gate: a spell condition
-- (Spell::CheckCast checks type 17 for the user, who casts the portal's spell on himself: GameObject.cpp 1329, 1932). Both
-- breadcrumbs are complete on accept, so mask 10 (in the log, incomplete or complete).
-- Silithus rows (gameobjects 175814 / 175815, Nethergarde Mage, Okril'lon Mage) are not changed.

DELETE FROM `spell_target_position` WHERE `id` = 93726;
INSERT INTO `spell_target_position` (`id`, `effIndex`, `target_map`, `target_position_x`, `target_position_y`, `target_position_z`, `target_orientation`) VALUES
(93726, 0, 0, -10908.7, -3392.94, 81.75, 3.61);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 17 AND `SourceGroup` = 0 AND `SourceEntry` IN (93726, 93733) AND `ConditionTypeOrReference` = 47;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(17, 0, 93726, 0, 0, 47, 0, 28867, 10, 0, 0, 0, 0, '', 'Teleport to Blasted Lands (Alliance portal, Silithus) - only while Nethergarde Needs You! is in the log'),
(17, 0, 93733, 0, 0, 47, 0, 28865, 10, 0, 0, 0, 0, '', 'Teleport to Blasted Lands (Horde portal, Silithus) - only while Call of the Warmatron is in the log');
