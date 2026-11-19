-- Durotar, Skull Rock (25262): the Burning Blade Fanatics 3197 and Apprentices 3198 burst into Felblood (80174) when they die, as
-- section 2 made the Dustwind Cave cultists do (2026_11_27_40: same rows, chance and wording). This replaces the in-combat timer rows
-- both TDBs have (cast at 6-8 s, then every 60-65 s, on the victim), with which a player saw about one burst per fight and rarely
-- reached the five stacks the sources describe. The move to "on death" is our reading of the sources below.
-- What the player should see: when a Fanatic or Apprentice dies (3 times in 4), a small fel burst around the corpse: 7 fire damage to
-- every enemy of the cultist within 10 yd, and a stack of Felblood (+3 fire and shadow damage taken, 60 s, up to 5) on every enemy
-- within 6 yd - players of either faction, pets, guardians, totems, and a Kor'kron standing beside it.
-- Sourced: wiki Skull_Rock_(quest) Notes ("enemies in the cavern have a high chance of inflicting Felblood on the player upon their
-- death ... it's easier to survive to gain 5 stacks"); Spell.dbc/SpellEffect 80174 (TARGET_SRC_CASTER + TARGET_UNIT_SRC_AREA_ENEMY,
-- radius 6 / 10 / 10 yd, 60 s).
-- Ours: the 75 % chance ("high chance"). Triggered, so the dead caster passes Spell::CheckCast (core #456). The five-stack transform
-- into Fel-Infused (77647) is section 3's spell script on 80174 (limited by section 3 to players and their pets, so a Kor'kron hit by
-- the bursts does not turn). With npc_durotar_skull_rock_cultist (2026_11_27_81): the cultists die only to players (NPC damage stops
-- at 85 %), so the bursts come only where a player is; the script touches damage taken and the tag only, not the death event.
-- Same row ids as the timer rows they replace.

DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND ((`entryorguid` = 3197 AND `id` = 1) OR (`entryorguid` = 3198 AND `id` = 3));
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3197,0,1,0,6,0,75,0,0,0,0,0,0,11,80174,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Fanatic - On Death - Cast Felblood (triggered)'),
(3198,0,3,0,6,0,75,0,0,0,0,0,0,11,80174,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Apprentice - On Death - Cast Felblood (triggered)');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (3197, 3198);
