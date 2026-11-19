-- Riding On (25171): Raider Jhash's wolf takes the sniffed road through the gate, makes its pit stop, and never runs on without its rider.
-- What the player sees (sourced, TDB 12.1.0 smart_scripts 39239 and waypoint paths 3923900/3923901, Wowhead 25171 2011-06-21 [+33]
-- "...what's that smell? Oh, BAD DOG!" and 2010-11-24 reply "the wolf took a pit stop"): the player asks Jhash for a ride, sits on a
-- Durotar Riding Wolf, Raider Kerr runs along behind; the wolf runs out through the Sen'jin gate and up the road, stops after the 11th
-- point, the "Bad dog!" sound plays (6319 B_WolfriderPissed3) and an Accident puddle (203112) lies there for 10 s, then after 3.6 s the
-- wolf runs on to Razor Hill and sets the player down near Gar'Thok.
-- Before: mop had only the second leg (the wolf ran straight from Jhash to its start by path finding) and a bare 3 s pause there.
-- Boarding: the summon (73678, SummonProperties 161 = category vehicle) makes the player cast Ride Vehicle Hardcoded (46598, base points
-- 0, so seat -1) on the wolf (Spell::EffectSummonType, SUMMON_CATEGORY_VEHICLE). With seat -1 Vehicle::AddPassenger takes the first
-- empty seat that CanEnterOrExit() or IsUsableByOverride(); the wolf's only seat, VehicleSeat 7600, has flags 0x4000800B but flagsB
-- 0x02000000 (VEHICLE_SEAT_FLAG_B_USABLE_FORCED_4, the DBC column the core loads as m_flagsB, VehicleSeatEntryfmt position 44), so
-- IsUsableByOverride() is true and the player is seated, before Jhash's script goes on. Jhash's own cross-cast (10676 id 2) then had the
-- player, already a passenger, cast 46598 again on the closest wolf within 5 yd of Jhash: refused by the seat (no CAN_ATTACK: "You
-- can't do that right now"), or another player's wolf. Removed. TDB 12.1.0's "on just created, the summoner casts Ride Vehicle" (B-13
-- of the dossier) would only duplicate the core's own cast, so it is not added.
-- Ours, so the wolf cannot leave empty: the path and Kerr start when the passenger boards (not when the wolf appears); a wolf nobody
-- boarded within 2.5 s despawns; when the passenger leaves (death, logout, teleport; the seat has no exit button) the wolf tells its own
-- Kerr to go and despawns after 1 s.
-- Ours, Raider Kerr: the wolf summons him with a 150 s timed despawn (TDB 12.1.0 casts 76496, whose summon lasts 80 s against a ride of
-- about 79 s from boarding: 1,168 yd at 16.1 yd/s + 3 s start + 3.6 s stop), stores him on SUMMONED_UNIT and sends the despawn to that
-- stored Kerr only, not to the closest one (another rider's). Kerr is passive as in TDB 12.1.0 ("on just created: react state passive")
-- and follows his own summoner, the wolf (TDB 12.1.0: owner/summoner at 2 yd, angle 245 degrees = 4.28 rad; this core passes the angle
-- to MoveFollow in radians and the parameter is an integer: 4).
-- Entries 39239, 10676, 10682 are not in beta's sql/updates.
DELETE FROM `waypoints` WHERE `entry` = 39239;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `point_comment`) VALUES
(39239, 1, -787.175, -4851.32, 19.3997, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 2, -757.425, -4830.07, 19.1497, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 3, -741.175, -4816.82, 22.1497, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 4, -728.175, -4805.57, 25.6497, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 5, -716.925, -4795.07, 29.6497, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 6, -701.675, -4781.57, 33.6497, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 7, -680.175, -4763.32, 33.8997, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 8, -663.175, -4746.82, 33.8997, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 9, -641.925, -4731.07, 33.8997, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 10, -621.175, -4725.07, 34.8997, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 11, -606.297, -4724.68, 34.9756, NULL, 0, 'Durotar Riding Wolf - gate to the pit stop'),
(39239, 12, -591.606, -4735.14, 33.6657, NULL, 0, 'Durotar Riding Wolf'),
(39239, 13, -555.918, -4744.07, 33.2341, NULL, 0, 'Durotar Riding Wolf'),
(39239, 14, -525.587, -4756.05, 32.8557, NULL, 0, 'Durotar Riding Wolf'),
(39239, 15, -499.273, -4766.02, 32.3088, NULL, 0, 'Durotar Riding Wolf'),
(39239, 16, -469.24, -4774.02, 32.4108, NULL, 0, 'Durotar Riding Wolf'),
(39239, 17, -441.08, -4780.39, 32.7105, NULL, 0, 'Durotar Riding Wolf'),
(39239, 18, -415.996, -4791.22, 32.3369, NULL, 0, 'Durotar Riding Wolf'),
(39239, 19, -392.153, -4803.29, 32.4044, NULL, 0, 'Durotar Riding Wolf'),
(39239, 20, -372.151, -4811.6, 32.2775, NULL, 0, 'Durotar Riding Wolf'),
(39239, 21, -347.844, -4812.67, 31.8915, NULL, 0, 'Durotar Riding Wolf'),
(39239, 22, -318.059, -4807.02, 30.2798, NULL, 0, 'Durotar Riding Wolf'),
(39239, 23, -292.337, -4801.08, 29.6089, NULL, 0, 'Durotar Riding Wolf'),
(39239, 24, -263.773, -4795.03, 27.5809, NULL, 0, 'Durotar Riding Wolf'),
(39239, 25, -229.802, -4786.03, 25.2157, NULL, 0, 'Durotar Riding Wolf'),
(39239, 26, -198.078, -4774.98, 23.7437, NULL, 0, 'Durotar Riding Wolf'),
(39239, 27, -168.069, -4764.53, 23.2603, NULL, 0, 'Durotar Riding Wolf'),
(39239, 28, -132.807, -4753.15, 22.5032, NULL, 0, 'Durotar Riding Wolf'),
(39239, 29, -105.254, -4747, 21.8531, NULL, 0, 'Durotar Riding Wolf'),
(39239, 30, -74.9219, -4746.31, 20.7799, NULL, 0, 'Durotar Riding Wolf'),
(39239, 31, -41.0833, -4747.56, 21.1075, NULL, 0, 'Durotar Riding Wolf'),
(39239, 32, -17.0382, -4749.41, 21.545, NULL, 0, 'Durotar Riding Wolf'),
(39239, 33, 16.5677, -4746.46, 22.0367, NULL, 0, 'Durotar Riding Wolf'),
(39239, 34, 42.1007, -4743.79, 20.907, NULL, 0, 'Durotar Riding Wolf'),
(39239, 35, 58.1111, -4744.43, 19.7751, NULL, 0, 'Durotar Riding Wolf'),
(39239, 36, 82.6597, -4743.16, 17.7463, NULL, 0, 'Durotar Riding Wolf'),
(39239, 37, 97.8628, -4746.3, 16.8021, NULL, 0, 'Durotar Riding Wolf'),
(39239, 38, 122.576, -4760.18, 13.7035, NULL, 0, 'Durotar Riding Wolf'),
(39239, 39, 141.448, -4767.58, 12.2902, NULL, 0, 'Durotar Riding Wolf'),
(39239, 40, 156.293, -4760.38, 11.8314, NULL, 0, 'Durotar Riding Wolf'),
(39239, 41, 182.731, -4750.92, 11.3994, NULL, 0, 'Durotar Riding Wolf'),
(39239, 42, 211.969, -4745.92, 10.3757, NULL, 0, 'Durotar Riding Wolf'),
(39239, 43, 231.312, -4739.25, 10.1021, NULL, 0, 'Durotar Riding Wolf'),
(39239, 44, 241.84, -4736.72, 10.1021, NULL, 0, 'Durotar Riding Wolf'),
(39239, 45, 249.76, -4737.88, 10.1021, NULL, 0, 'Durotar Riding Wolf');
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10676 AND `source_type` = 0 AND `id` = 2 AND `action_type` = 86;
UPDATE `smart_scripts` SET `link` = 0 WHERE `entryorguid` = 10676 AND `source_type` = 0 AND `id` = 1;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 39239 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(39239, 0, 0, 8, 27, 0, 100, 0, 0, 0, 0, 0, 0, 80, 3923900, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - On Passenger Boarded - Run Script (Kerr, path)'),
(39239, 0, 8, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - Linked To Id 0 - Set Event Phase 2 (ridden)'),
(39239, 0, 7, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - On Just Summoned - Set Event Phase 1 (waiting for its rider)'),
(39239, 0, 9, 0, 1, 1, 100, 1, 2500, 2500, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - Out of Combat 2.5 s (Phase 1, nobody boarded) - Despawn'),
(39239, 0, 1, 5, 40, 0, 100, 0, 11, 39239, 0, 0, 0, 54, 3600, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - On Waypoint 11 Reached - Pause 3.6 s (pit stop)'),
(39239, 0, 5, 6, 61, 0, 100, 0, 0, 0, 0, 0, 0, 4, 6319, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - Linked To Id 1 - Play Sound 6319 (Bad dog!)'),
(39239, 0, 6, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 50, 203112, 10, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - Linked To Id 5 - Summon Gameobject Accident (10 s)'),
(39239, 0, 2, 3, 58, 0, 100, 0, 45, 39239, 0, 0, 0, 28, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - On Waypoint 45 Ended - Remove All Auras (set the rider down)'),
(39239, 0, 3, 4, 61, 0, 100, 0, 0, 0, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 12, 1, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - Linked To Id 2 - Set Data 0 1 on its own Raider Kerr (stored)'),
(39239, 0, 4, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - Linked To Id 3 - Despawn'),
(39239, 0, 10, 11, 28, 0, 100, 0, 0, 0, 0, 0, 0, 45, 0, 1, 0, 0, 0, 0, 12, 1, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - On Passenger Removed - Set Data 0 1 on its own Raider Kerr (stored)'),
(39239, 0, 11, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 1000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - Linked To Id 10 - Despawn in 1 s'),
(39239, 0, 12, 0, 17, 0, 100, 0, 10682, 0, 0, 0, 0, 64, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - On Raider Kerr Summoned - Store Him (target list 1)');
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3923900 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3923900, 9, 0, 0, 0, 0, 100, 0, 1000, 1000, 0, 0, 0, 12, 10682, 3, 150000, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - On Script - Summon Raider Kerr (150 s timed despawn)'),
(3923900, 9, 1, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 53, 1, 39239, 0, 25171, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Durotar Riding Wolf - On Script - Waypoint Start');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (39239, 10682) AND `ScriptName` = '';
UPDATE `smart_scripts` SET `action_param1` = 2, `action_param2` = 4, `target_type` = 23, `target_param1` = 0, `target_param2` = 0,
 `comment` = 'Raider Kerr - Linked To Id 0 - Follow Owner/Summoner (his wolf) at 2 yd, angle 4 rad'
 WHERE `entryorguid` = 10682 AND `source_type` = 0 AND `id` = 1 AND `action_type` = 29;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 10682 AND `source_type` = 0 AND `id` = 3;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10682, 0, 3, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Raider Kerr - On Just Summoned - Set React State Passive');
