-- Blasted Lands A (_09): Buttonwillow's Hand Grenade acts only on Okril'lon Weapons Crates (dossier S2 F-GRENADE; Remove Their
-- Arms 25713).
--
-- Today: 78811 triggers 79059, whose only effect (index 0, ACTIVATE_OBJECT, TARGET_GAMEOBJECT_DEST_AREA, 5 yd) "uses" every
-- gameobject within 5 yd of the impact anywhere in zone 4: doors, the Bloodstone Teleporters 203752 / 203753 (credit for 26158
-- and a teleport for the thrower), Ore Heaps 203183 (25677).
-- SOURCED: objective "Lob one of Buttonwillow's Hand Grenades at an Okril'lon Weapons Crate"; 57117 2011-01-13 [+7] (anywhere
-- else it does nothing but a visual). OURS: the condition (implicit target condition, applied in Spell::SearchAreaTargets).
-- SourceGroup 1 = effect mask of effect 0; type 31 OBJECT_ENTRY_GUID, TypeID 5 (gameobject), entry 203707.

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 79059;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 79059, 0, 0, 31, 0, 5, 203707, 0, 0, 0, 0, '', 'Buttonwillow''s Hand Grenade - activates only Okril''lon Weapons Crates');
