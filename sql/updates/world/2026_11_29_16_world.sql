-- Northern Barrens S1 (_16): the wrecked shredder's pilot and the Silver Bullet X-831 - Wizzlecrank's Cataclysm lines, the
-- parked rocket back after 15 s, Gyrotilt's four missing lines and the credit to the rider who summoned the rocket.
-- (plan.md section 1 `_16`; dossier H: H4, H8, H9.)
--
-- SOURCED: Pilot Wizzlecrank's Cataclysm lines are BroadcastText 1045 / 1046 (wiki); mop had the Classic ones that send the
-- player to Ratchet. Gyrotilt's four missing lines are BroadcastText 51022 51029 51035 51030, in the wiki's order.
-- OURS: the parked rocket 310950 returns 15 s after a click (it despawns for everyone on each click; was 300 s); the
-- waypoints the four lines are tied to (9, 41, 43, end of path 46); the credit's target is now the rocket's summoner
-- (was the closest player within 5 yd).
-- Note: whether the player is seated at all is S5's check (backport D1, plan S5-11).

-- H4 (863): Pilot Wizzlecrank's Cataclysm lines (broadcast 1045, 1046; wiki) replace the Classic ones that send the player to Ratchet.
UPDATE `creature_text` ct JOIN `broadcast_text` bt ON bt.`ID`=1045 SET ct.`Text`=bt.`Text`, ct.`BroadcastTextId`=1045 WHERE ct.`CreatureID`=3451 AND ct.`GroupID`=0 AND ct.`ID`=0;
UPDATE `creature_text` ct JOIN `broadcast_text` bt ON bt.`ID`=1046 SET ct.`Text`=bt.`Text`, ct.`BroadcastTextId`=1046 WHERE ct.`CreatureID`=3451 AND ct.`GroupID`=1 AND ct.`ID`=0;

-- H8 (29094): the parked rocket despawns for everyone on each click; bring it back after 15 s instead of 5 min.
UPDATE `creature` SET `spawntimesecs`=15 WHERE `guid`=310950 AND `id`=52203;

-- H9 (29094): Gyrotilt's four missing lines (broadcast 51022, 51029, 51035, 51030; wiki order); credit target = summoner.
DELETE FROM `creature_text` WHERE `CreatureID`=52204 AND `GroupID` IN (9,10,11,12);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`)
SELECT 52204, CASE `ID` WHEN 51022 THEN 9 WHEN 51029 THEN 10 WHEN 51035 THEN 11 ELSE 12 END, 0, `Text`, 12, 0, 100, 0, 0, 0, 0, `ID`, 0, 'Gyrotilt' FROM `broadcast_text` WHERE `ID` IN (51022,51029,51035,51030);
UPDATE `smart_scripts` SET `link`=0 WHERE `entryorguid`=52204 AND `source_type`=0 AND `id`=8;
UPDATE `smart_scripts` SET `event_type`=38, `event_param1`=0, `event_param2`=13, `comment`='Gyrotilt - On Data Set 0 13 - Despawn after 3 sec' WHERE `entryorguid`=52204 AND `source_type`=0 AND `id`=9;
DELETE FROM `smart_scripts` WHERE `entryorguid`=52204 AND `source_type`=0 AND `id` IN (10,11,12,13);
DELETE FROM `smart_scripts` WHERE `entryorguid`=52201 AND `source_type`=0 AND `id` IN (20,21,22,23);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(52204,0,10,0,38,0,100,0,0,10,0,0,0,1,9,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gyrotilt - On Data Set 0 10 - Say Line 9'),
(52204,0,11,0,38,0,100,0,0,11,0,0,0,1,10,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gyrotilt - On Data Set 0 11 - Say Line 10'),
(52204,0,12,0,38,0,100,0,0,12,0,0,0,1,11,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gyrotilt - On Data Set 0 12 - Say Line 11'),
(52204,0,13,0,38,0,100,0,0,13,0,0,0,1,12,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Gyrotilt - On Data Set 0 13 - Say Line 12'),
(52201,0,20,0,40,0,100,0,9,52201,0,0,0,45,0,10,0,0,0,0,19,52204,5,0,0,0,0,0,0,'Silver Bullet X-831 - On Waypoint 9 Reached - Set Data 0 10'),
(52201,0,21,0,40,0,100,0,41,52201,0,0,0,45,0,11,0,0,0,0,19,52204,5,0,0,0,0,0,0,'Silver Bullet X-831 - On Waypoint 41 Reached - Set Data 0 11'),
(52201,0,22,0,40,0,100,0,43,52201,0,0,0,45,0,12,0,0,0,0,19,52204,5,0,0,0,0,0,0,'Silver Bullet X-831 - On Waypoint 43 Reached - Set Data 0 12'),
(52201,0,23,0,58,0,100,0,46,52201,0,0,0,45,0,13,0,0,0,0,19,52204,5,0,0,0,0,0,0,'Silver Bullet X-831 - On Waypoint 46 Ended - Set Data 0 13');
UPDATE `smart_scripts` SET `target_type`=23, `target_param1`=0 WHERE `entryorguid`=52201 AND `source_type`=0 AND `id`=1 AND `action_type`=64;

-- S5 lead: Gyrotilt is a minion accessory, so he goes 2 s after leaving the rocket (Unit::_ExitVehicle) when it despawns
-- early (rider logs out mid-flight); with minion 0 and summontype 8 he stayed for ever.
UPDATE `vehicle_template_accessory` SET `minion`=1 WHERE `entry`=52201 AND `accessory_entry`=52204;
