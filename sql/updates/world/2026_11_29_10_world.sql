-- Northern Barrens S1 (_10): Tortusk rides Fez (13968).
-- (plan.md section 1 `_10`; dossier E: E-10.)
--
-- SOURCED: both TDBs spawn Tortusk 34544 on Fez 34543's spot 1.5 yd up; comments: "the piggy riding on a raptor", "Fez needs
-- half a second to spawn Tortusk on top of him", kill the raptor and Tortusk fights on; Fez's spot and its 120 s respawn
-- are both TDBs'.
-- OURS: Tortusk boards through Fez's spellclick 46598 Ride Vehicle Hardcoded, usable by 34544 only (source-18 condition;
-- Fez's SAI strips the spellclick npcflag too): Vehicle::InstallAccessory unsummons an accessory whose HandleSpellClick fails
-- (Vehicle.cpp:556-565) and Fez had no npc_spellclick_spells row (review B1). Tortusk is an accessory, not a minion (Unit::_ExitVehicle kills a minion accessory with its vehicle, and he must
-- outlive Fez); Fez wanders 10 yd; Quilboar Rush moves from "on aggro" to an in-combat timer (3-5 s, then every 12-16 s),
-- because seat 4386 (vehicle 420 seat 0) lacks CAN_ATTACK and the aggro cast would fail while he rides; it succeeds once he
-- is on foot. Open point (plan (a) E U-4): whether a seated Tortusk melees at all - smoke test.

-- E-10: the static Tortusk goes; Fez carries him.
DELETE FROM `creature_addon` WHERE `guid`=263064;
DELETE FROM `creature` WHERE `guid`=263064 AND `id`=34544;
DELETE FROM `vehicle_template_accessory` WHERE `entry`=34543;
INSERT INTO `vehicle_template_accessory` (`entry`,`accessory_entry`,`seat_id`,`minion`,`description`,`summontype`,`summontimer`) VALUES
(34543,34544,0,0,'Fez - Tortusk',6,60000);
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=34543;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES (34543,46598,1,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceGroup`=34543;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,34543,46598,0,0,31,0,3,34544,0,0,0,0,'','Fez - only Tortusk boards');
UPDATE `creature` SET `position_x`=-37.5, `position_y`=-3351.627, `position_z`=91.79166, `orientation`=0.8383393,
  `spawntimesecs`=120, `MovementType`=1, `wander_distance`=10 WHERE `guid`=263063 AND `id`=34543;
UPDATE `smart_scripts` SET `event_type`=0, `event_flags`=0, `event_param1`=3000, `event_param2`=5000, `event_param3`=12000, `event_param4`=16000,
  `target_type`=2, `comment`='Tortusk - In Combat - Cast Quilboar Rush' WHERE `entryorguid`=34544 AND `source_type`=0 AND `id`=0;
