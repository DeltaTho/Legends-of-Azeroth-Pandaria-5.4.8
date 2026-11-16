-- Badlands, The Day that Deathwing Came 27713: the Scar's 21 ordinary Rock Elementals 92 are hidden from the player while he
-- tells Theldurin's story, and only from him, only then.
--
-- They stand in the trench among the story's Dang-Blasted Rock Elementals 46467 with the same model (CreatureModelData 69, 0.75
-- scale against 1.0), but in phase 0, out of Theldurin's reach: the story vehicle has the story's phase 293 only, so they never
-- react to him and his punch cannot touch them (user's play test). The user's ruling: hide them in the story.
-- The player cannot leave phase 169 (Player::Update puts it back), so a phase cannot hide them. Instead:
-- - each of the 21 spawns carries 90442 Generic Quest Invisibility 17 (invisibility type 25, value 100). No other spawn on
--   map 0 uses type 25, and no other source gives it in the Badlands;
-- - every player in the Badlands (zone 3) gets 94680 See Quest Invis 17 (detection type 25, value 1000; no area restriction,
--   hidden, permanent) from spell_area, unless he has 86557 TDDC 1: Summon Theldurin, the story's phase aura. spell_area rows
--   keyed on an aura are checked again whenever that aura comes or goes (Aura::HandleAuraSpecificMods): 86557 coming at the
--   story's start takes the detection off, and 86557 going at any end gives it back (story end, Leave, the vehicle's death,
--   the player's death, an abandoned quest: the story's end strips it; a teleport ends it by its own TELEPORTED interrupt; a
--   logout keeps it until the login strips it, player_badlands_stories::OnLogin).
--   Leaving the zone takes it off and coming back gives it again (UpdateArea / UpdateZoneDependentAuras).
-- Everyone else in the Badlands sees them as before. Side effects: the 21 are seen only by those with the detection, so outside
-- the zone nobody sees them (the Scar lies deep inside it: the nearest spawn of another zone is 490 yd away); and this core
-- lets an invisible unit see only units that detect it, so the 21 do not see NPCs; players' pets, guardians and totems they
-- see through the controlling player's detection (Core/Visibility commit in the same series). Ours.

DELETE FROM `creature_addon` WHERE `guid` IN (161587, 161772, 162024, 162025, 162040, 162044, 162070, 162084, 162101, 162185, 162187,
    162188, 162189, 162190, 162191, 162192, 162194, 162195, 162196, 162197, 162198);
INSERT INTO `creature_addon` (`guid`, `path_id`, `mount`, `MountCreatureID`, `StandState`, `AnimTier`, `VisFlags`, `SheathState`,
    `PvPFlags`, `emote`, `aiAnimKit`, `movementAnimKit`, `meleeAnimKit`, `visibilityDistanceType`, `auras`) VALUES
(161587, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(161772, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162024, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162025, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162040, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162044, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162070, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162084, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162101, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162185, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162187, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162188, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162189, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162190, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162191, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162192, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162194, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162195, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162196, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162197, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442'),
(162198, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, '90442');

DELETE FROM `spell_area` WHERE `spell` = 94680 AND `area` = 3;
INSERT INTO `spell_area` (`spell`, `area`, `quest_start`, `quest_end`, `aura_spell`, `racemask`, `gender`, `autocast`,
    `quest_start_status`, `quest_end_status`) VALUES
(94680, 3, 0, 0, -86557, 0, 2, 1, 0, 0);
