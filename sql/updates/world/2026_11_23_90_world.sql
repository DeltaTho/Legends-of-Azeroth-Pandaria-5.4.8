-- Swamp of Sorrows, The Bogpaddle Bullet 28569 / 28570: the rocket 48324 that flies the player from Sharon Boomgetter's launch
-- rig in the Burning Steppes down to Bogpaddle, and its pilot Higs Blastscorch 48990 (npc_sos_bogpaddle_bullet and
-- player_sos_bogpaddle_bullet in zone_swamp_of_sorrows_bullet.cpp).
--
-- No zone-46 row in this file: 48324 and 48990 have no spawn anywhere (summons only). INERT until 2026_11_23_91 gives Sharon
-- 48948 her option and script (zone 46, held for the Burning Steppes session): nothing else summons 48324. The only part active
-- without _91 is the login check, which moves only a player saved in mid-air on the rocket's flight path.
--
-- Sourced (dossier S1 section 2 and G1; Wowhead screenshots of 48324 / 28569; the wiki): the ride is a rocket with a goblin
--   pilot in front and the player behind him; the pilot is Higs Blastscorch (wiki), whose display 36290 is the same goblin as
--   Gobby Nozzlerocket, the pilot of the same rocket model in the Badlands. VehicleId 1364 and model 31992 were already set.
-- Ours (no TDB has any vehicle, accessory, spellclick, script or path row for 48324 / 48990):
--   - The spellclick row (48324, 46598) replaces mop's (48324, 97203 Rocket Loop Sound): it only lets Higs board as the
--     accessory (Vehicle::InstallAccessory goes through HandleSpellClick, Badlands lesson). Once he sits in the only enterable
--     seat (seat 0), the rocket is no longer clickable. The loop sound 97203 is now cast by the script when the rocket starts.
--   - No vehicle_template_accessory row: the script seats the player in seat 1 first and Higs in seat 0 after him (seated
--     first, a pilot loses his seat when the player boards: Badlands fix 2026_11_20_91).
--   - NON_ATTACKABLE | IMMUNE_TO_PC | IMMUNE_TO_NPC on the rocket, and NOT_SELECTABLE as well on the pilot (as The Uncrashable
--     48766 and Gobby 48837): nobody shoots it down. The passenger is unselectable through his seat (9199).
--   - Flight movement as 48766 (Ground 1, Flight 2).
--   - The route, speeds and landing are in the script (one table, BulletRoute): 19 points, legs of at most 200 yd, about
--     2240 yd and 70 s; straight up 63 yd from a launch spot 3.7 yd from Sharon, then 75 yd or more above the terrain along
--     the mountains east of the Redridge valleys (322 yd or more from every Redridge spawn), down over the sea and Misty Reed
--     Strand, landing 3.5 yd in front of Trade Baron Silversnap facing him; no model under any leg but the last two (9 yd
--     clear). Checked against the 5.4.8 maps and vmaps.

UPDATE `creature_template` SET `VehicleId` = 1364, `AIName` = '', `ScriptName` = 'npc_sos_bogpaddle_bullet', `unit_flags` = 770 WHERE `entry` = 48324;
UPDATE `creature_template` SET `unit_flags` = 33555202 WHERE `entry` = 48990;

DELETE FROM `creature_template_movement` WHERE `CreatureId` = 48324;
INSERT INTO `creature_template_movement` (`CreatureId`, `Ground`, `Swim`, `Flight`, `Rooted`, `Chase`, `Random`, `InteractionPauseTimer`) VALUES
(48324, 1, 0, 2, 0, NULL, NULL, NULL);

DELETE FROM `vehicle_template_accessory` WHERE `entry` = 48324;

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 48324;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(48324, 46598, 1, 0);
