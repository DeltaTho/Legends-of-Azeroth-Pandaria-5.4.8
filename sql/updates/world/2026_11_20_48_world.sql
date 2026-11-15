-- Badlands, Fuselight, Ho! 27762: The Uncrashable, the rocket that flies the player from Light's Hope Chapel to
-- Fuselight-by-the-Sea (npc_badlands_uncrashable_rocket, spell_badlands_rocket_ride_to_badlands).
--
-- INERT until 2026_11_20_49 gives The Uncrashable 48708 at Light's Hope its spellclick: nothing else casts 87956 or summons 48766.
--
-- Sourced (dossier fuselight F-27762-1 and Second pass 2; comments of 27762 / 48708 / 48766 / 48837, the wiki): 87956 Rocket Ride
--   to Badlands summons 48766 as a vehicle (SummonProperties 161, 900 s); Gobby Nozzlerocket 48837 flies it and cannot be
--   targeted; the player cannot get off; about five minutes south over the Hinterlands, Arathi, the Wetlands (not the Twilight
--   Highlands), Loch Modan and the gorge into the Badlands, speed bursts between zones, areas discovered on the way; it lands by
--   Eddie Flofizzle at Fuselight-by-the-Sea; one way. Models 31992 / 36290 were already set.
-- Ours (no TDB has any vehicle, accessory, spellclick, script or path row for 48708 / 48766 / 48837):
--   - VehicleId 1364 (The Bogpaddle Bullet's, same rocket model): seat 0 = the pilot (9198), seat 1 = the passenger (9199: no
--     exit, not selectable). The spell script seats the player in seat 1 by name.
--   - The spellclick row (48766, 46598) only lets Gobby board as the accessory (Vehicle::InstallAccessory goes through
--     HandleSpellClick); once he sits in the only enterable seat, the rocket is not clickable.
--   - NON_ATTACKABLE | IMMUNE_TO_PC | IMMUNE_TO_NPC on the rocket and the pilot: nobody shoots it down (a retail fault). The
--     pilot is also NOT_SELECTABLE (sourced: "Gobby cannot be targeted", 48837 comment 2010-12-27 [+7]). The passenger is made
--     unselectable by his seat (9199 flag 0x00100000); no comment says the rocket itself could not be targeted, so it stays
--     selectable (but cannot be attacked).
--   - Flight movement as the Silver Bullet X-831 52201 (Ground 1, Flight 2).
--   - The route: 69 points, legs of at most 200 yd; straight up from the launch spot to z 130 (over the gate's walls, top z 104),
--     then 75 yd or more above the terrain (liquid counted) along every leg until the coast, down over the sea to the dock;
--     no model within 100 yd of any leg (checked against the 5.4.8 maps and vmaps, sampled every 5-20 yd); the launch spot 4.4 yd from the sniffed 48708 and the landing
--     spot 3.5 yd from the sniffed Eddie on open ground; about 12 000 yd flown (11 400 yd over the ground), about 5 min 15 s at
--     the script's speeds (measured on retail: 4 min 56 s).

UPDATE `creature_template` SET `VehicleId` = 1364, `AIName` = '', `ScriptName` = 'npc_badlands_uncrashable_rocket', `unit_flags` = 770 WHERE `entry` = 48766;
UPDATE `creature_template` SET `unit_flags` = 33555202 WHERE `entry` = 48837;

DELETE FROM `creature_template_movement` WHERE `CreatureId` = 48766;
INSERT INTO `creature_template_movement` (`CreatureId`, `Ground`, `Swim`, `Flight`, `Rooted`, `Chase`, `Random`, `InteractionPauseTimer`) VALUES
(48766, 1, 0, 2, 0, NULL, NULL, NULL);

DELETE FROM `vehicle_template_accessory` WHERE `entry` = 48766;
INSERT INTO `vehicle_template_accessory` (`entry`, `accessory_entry`, `seat_id`, `minion`, `description`, `summontype`, `summontimer`) VALUES
(48766, 48837, 0, 1, 'The Uncrashable - Gobby Nozzlerocket', 8, 0);

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 48766;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(48766, 46598, 1, 0);

DELETE FROM `spell_script_names` WHERE `spell_id` = 87956;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(87956, 'spell_badlands_rocket_ride_to_badlands');

DELETE FROM `waypoints` WHERE `entry` = 48766;
INSERT INTO `waypoints` (`entry`, `pointid`, `position_x`, `position_y`, `position_z`, `orientation`, `delay`, `point_comment`) VALUES
(48766,1,2274.50,-5262.50,130.00,NULL,0,'lift-off above the gate'),
(48766,2,2240.00,-5225.00,159.58,NULL,0,'Eastern Plaguelands, 85 yd above ground'),
(48766,3,2150.00,-5150.00,179.63,NULL,0,'Eastern Plaguelands, 109 yd above ground'),
(48766,4,1985.71,-5071.43,243.37,NULL,0,'Eastern Plaguelands, 157 yd above ground'),
(48766,5,1821.43,-4992.86,307.11,NULL,0,'Eastern Plaguelands, 216 yd above ground'),
(48766,6,1657.14,-4914.29,370.84,NULL,0,'Eastern Plaguelands, 283 yd above ground'),
(48766,7,1492.86,-4835.71,434.58,NULL,0,'Eastern Plaguelands, 258 yd above ground'),
(48766,8,1328.57,-4757.14,435.01,NULL,0,'Eastern Plaguelands, 104 yd above ground'),
(48766,9,1164.29,-4678.57,427.01,NULL,0,'The Hinterlands, 119 yd above ground'),
(48766,10,1000.00,-4600.00,418.47,NULL,0,'The Hinterlands, 155 yd above ground'),
(48766,11,833.33,-4500.00,414.00,NULL,0,'The Hinterlands, 96 yd above ground'),
(48766,12,666.67,-4400.00,406.40,NULL,0,'The Hinterlands, 127 yd above ground'),
(48766,13,500.00,-4300.00,393.13,NULL,0,'The Hinterlands, 228 yd above ground'),
(48766,14,333.33,-4200.00,246.61,NULL,0,'The Hinterlands, 127 yd above ground'),
(48766,15,166.67,-4100.00,247.48,NULL,0,'The Hinterlands, 125 yd above ground'),
(48766,16,0.00,-4000.00,315.51,NULL,0,'The Hinterlands, 185 yd above ground'),
(48766,17,-133.33,-3875.00,379.48,NULL,0,'The Hinterlands, 154 yd above ground'),
(48766,18,-266.67,-3750.00,443.45,NULL,0,'The Hinterlands, 188 yd above ground'),
(48766,19,-400.00,-3625.00,471.06,NULL,0,'The Hinterlands, 132 yd above ground'),
(48766,20,-533.33,-3500.00,471.06,NULL,0,'The Hinterlands, 119 yd above ground'),
(48766,21,-666.67,-3375.00,448.25,NULL,0,'Arathi Highlands, 193 yd above ground'),
(48766,22,-800.00,-3250.00,359.59,NULL,0,'Arathi Highlands, 278 yd above ground'),
(48766,23,-960.00,-3160.00,170.61,NULL,0,'Arathi Highlands, 122 yd above ground'),
(48766,24,-1120.00,-3070.00,129.90,NULL,0,'Arathi Highlands, 88 yd above ground'),
(48766,25,-1280.00,-2980.00,123.17,NULL,0,'Arathi Highlands, 88 yd above ground'),
(48766,26,-1440.00,-2890.00,120.64,NULL,0,'Arathi Highlands, 86 yd above ground'),
(48766,27,-1600.00,-2800.00,126.12,NULL,0,'Arathi Highlands, 87 yd above ground'),
(48766,28,-1750.00,-2740.00,151.21,NULL,0,'Arathi Highlands, 103 yd above ground'),
(48766,29,-1900.00,-2680.00,171.65,NULL,0,'Arathi Highlands, 113 yd above ground'),
(48766,30,-2050.00,-2620.00,185.27,NULL,0,'Arathi Highlands, 107 yd above ground'),
(48766,31,-2200.00,-2560.00,212.90,NULL,0,'Arathi Highlands, 165 yd above ground'),
(48766,32,-2350.00,-2500.00,241.13,NULL,0,'Arathi Highlands, 241 yd above ground'),
(48766,33,-2520.00,-2520.00,301.04,NULL,0,'Wetlands, 194 yd above ground'),
(48766,34,-2690.00,-2540.00,301.04,NULL,0,'Wetlands, 133 yd above ground'),
(48766,35,-2860.00,-2560.00,297.54,NULL,0,'Wetlands, 247 yd above ground'),
(48766,36,-3030.00,-2580.00,128.93,NULL,0,'Wetlands, 122 yd above ground'),
(48766,37,-3200.00,-2600.00,98.93,NULL,0,'Wetlands, 92 yd above ground'),
(48766,38,-3400.00,-2600.00,164.10,NULL,0,'Wetlands, 148 yd above ground'),
(48766,39,-3600.00,-2600.00,219.63,NULL,0,'Wetlands, 150 yd above ground'),
(48766,40,-3800.00,-2600.00,266.99,NULL,0,'Wetlands, 146 yd above ground'),
(48766,41,-4000.00,-2600.00,336.99,NULL,0,'Wetlands, 274 yd above ground'),
(48766,42,-4160.00,-2640.00,394.71,NULL,0,'Wetlands, 349 yd above ground'),
(48766,43,-4320.00,-2680.00,452.44,NULL,0,'Wetlands, 362 yd above ground'),
(48766,44,-4480.00,-2720.00,510.16,NULL,0,'Wetlands, 238 yd above ground'),
(48766,45,-4640.00,-2760.00,510.16,NULL,0,'Loch Modan, 154 yd above ground'),
(48766,46,-4800.00,-2800.00,481.37,NULL,0,'Loch Modan, 158 yd above ground'),
(48766,47,-4925.00,-2925.00,469.88,NULL,0,'Loch Modan, 99 yd above ground'),
(48766,48,-5050.00,-3050.00,469.35,NULL,0,'Loch Modan, 144 yd above ground'),
(48766,49,-5175.00,-3175.00,402.34,NULL,0,'Loch Modan, 114 yd above ground'),
(48766,50,-5300.00,-3300.00,368.50,NULL,0,'Loch Modan, 100 yd above ground'),
(48766,51,-5475.00,-3287.50,392.92,NULL,0,'Loch Modan, 106 yd above ground'),
(48766,52,-5650.00,-3275.00,411.06,NULL,0,'Loch Modan, 112 yd above ground'),
(48766,53,-5825.00,-3262.50,411.47,NULL,0,'Loch Modan, 101 yd above ground'),
(48766,54,-6000.00,-3250.00,426.28,NULL,0,'Badlands, 109 yd above ground'),
(48766,55,-6133.33,-3333.33,422.73,NULL,0,'Badlands, 168 yd above ground'),
(48766,56,-6266.67,-3416.67,477.77,NULL,0,'Badlands, 239 yd above ground'),
(48766,57,-6400.00,-3500.00,477.78,NULL,0,'Badlands, 76 yd above ground'),
(48766,58,-6406.67,-3650.00,477.78,NULL,0,'Badlands, 236 yd above ground'),
(48766,59,-6413.33,-3800.00,458.16,NULL,0,'Badlands, 166 yd above ground'),
(48766,60,-6420.00,-3950.00,478.08,NULL,0,'Badlands, 198 yd above ground'),
(48766,61,-6400.00,-4125.00,464.19,NULL,0,'Badlands, 204 yd above ground'),
(48766,62,-6380.00,-4300.00,444.65,NULL,0,'Badlands, 111 yd above ground'),
(48766,63,-6390.00,-4470.00,400.00,NULL,0,'Badlands, 220 yd above ground'),
(48766,64,-6400.00,-4620.00,250.00,NULL,0,'Badlands, 219 yd above ground'),
(48766,65,-6420.00,-4760.00,140.00,NULL,0,'Badlands, 140 yd above ground'),
(48766,66,-6500.00,-4850.00,80.00,NULL,0,'Badlands, 80 yd above ground'),
(48766,67,-6580.00,-4850.00,45.00,NULL,0,'Badlands, 45 yd above ground'),
(48766,68,-6630.00,-4805.00,18.00,NULL,0,'Badlands, 18 yd above ground'),
(48766,69,-6648.40,-4745.00,8.57,NULL,0,'landing by Eddie Flofizzle');
