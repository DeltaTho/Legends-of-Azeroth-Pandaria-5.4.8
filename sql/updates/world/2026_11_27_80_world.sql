-- Durotar, Bladefist Bay: Message for Garrosh (25267, goblins). "Take my battleworg. Hurry, little goblin": the goblin got the
-- battleworg only by guessing the Kor'kron Loyalist's gossip option "Use my wolf to reach Garrosh" (2026_10_04_88), and that option
-- had no condition: anyone, any race, at any time could summon a player-steered level-85 worg there.
-- Sourced: quest text; DBC 5.4.8 74032 "Message For Garrosh: Quest Accept" (FORCE_CAST 74031 on the target) -> 74031 "Message For
-- Garrosh: Summon Battleworg" (SUMMON 39611, SummonProperties 827 = vehicle, value 74030 "Riding Battleworg" = CONTROL_VEHICLE, at
-- DEST_NEARBY_ENTRY within 100 yd). Nothing in mop cast 74032.
-- Now: taking the quest from the Loyalist makes him cast 74032 on the goblin, who is seated on a battleworg at once. The gossip
-- option stays as a way to get a new worg after getting off early, shown only with 25267 in the log (it is complete on accept, so
-- mask 2 | 8).
-- Ours: where the worg appears. 74031's DEST_NEARBY_ENTRY needs a condition naming what it is near (SelectImplicitNearbyTargets
-- reads the source-13 conditions; with none the nearest object of any kind, the goblin himself included, wins): the Loyalist's
-- own static Battleworg 39610, 4 yd from him ("take my battleworg"). The static worg stays where it stands; the summoned one leaves
-- with the goblin.
-- The ride as the data has it (no source describes it): vehicle 802, seat 7836 CAN_CONTROL | CAN_ENTER_OR_EXIT |
-- PASSENGER_NOT_SELECTABLE, no CAN_CAST (no action bar) and no ALLOWS_INTERACTION; no waypoints or script for 39611; run speed
-- 1.57 (about 11 yd/s). So the goblin steers the worg himself the ~700 yd to Grommash Hold, has a Leave button, and must get off to
-- talk to Garrosh; the worg is a vehicle minion of the goblin, which the core removes the moment he gets off (Unit::_ExitVehicle).
-- The worg is no personal summon: others see him ride.

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 39609;
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 39609 AND `id` = 2;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(39609, 0, 2, 0, 19, 0, 100, 0, 25267, 0, 0, 0, 0, 11, 74032, 2, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Kor''kron Loyalist - On Message for Garrosh accepted - Cast Quest Accept on the goblin (force-casts Summon Battleworg)');

DELETE FROM `conditions` WHERE (`SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 11245) OR (`SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 74031);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
 `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 11245, 0, 0, 0, 47, 0, 25267, 10, 0, 0, 0, 0, '', 'Kor''kron Loyalist - a new battleworg only with Message for Garrosh in the log'),
(13, 1, 74031, 0, 0, 31, 0, 3, 39610, 0, 0, 0, 0, '', 'Summon Battleworg - appears at the Loyalist''s battleworg (ours)');
