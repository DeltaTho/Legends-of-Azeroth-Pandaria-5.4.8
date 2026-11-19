-- The Burning Blade (25232): the cultists of Dustwind Cave burst into Felblood (80174) when they die. This replaces the in-combat timer rows
-- both TDBs have (cast at 6-8 s, then every 60-65 s, on the victim), with which a player saw about one burst per fight and the stacks the
-- sources describe never built up. The move to "on death" is our reading of the sources below.
-- What the player should see: when a Burning Blade Thug (3195), Neophyte (3196) or Cultist (3199) dies (3 times in 4), a small fel burst
-- around the corpse: 7 fire damage to every enemy of the cultist within 10 yd, and a stack of Felblood (+3 fire and shadow damage taken,
-- 60 s, up to 5 stacks, one debuff even from different cultists) on every enemy within 6 yd. "Enemy" is any player of either faction and
-- any level, grouped or not, and pets, guardians and totems; a player who kills from beyond 10 yd gets nothing (the quest is loot only).
-- Sourced: wiki The_Burning_Blade_(quest) Notes ("a high chance of inflicting Felblood on player upon their death ... that explosion that
-- inflicts Felblood also deals Fire damage"); Wowhead 25232 2011-07-10 [+5] ("when you kill these mobs, you recieve a debuff called
-- Felblood"); replies on pets turning into demons, so pets are meant to be hit too. Spell.dbc/SpellEffect: TARGET_SRC_CASTER +
-- TARGET_UNIT_SRC_AREA_ENEMY, radius 6 / 10 / 10 yd. Not narrowed further: nothing in the sources limits it to the killer.
-- Ours: the 75 % chance ("high chance"). Triggered, so the dead caster passes Spell::CheckCast (core #456, as Volcanoth's death explosion).
-- The five-stack transform into Fel-Infused (77647) is section 3's spell script on 80174; this file is only the SmartAI half. Skull Rock's
-- Fanatic 3197 and Apprentice 3198 are section 4's. Same row ids as the timer rows they replace.
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND ((`entryorguid` = 3195 AND `id` = 1) OR (`entryorguid` IN (3196, 3199) AND `id` = 3));
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3195,0,1,0,6,0,75,0,0,0,0,0,0,11,80174,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Thug - On Death - Cast Felblood (triggered)'),
(3196,0,3,0,6,0,75,0,0,0,0,0,0,11,80174,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Neophyte - On Death - Cast Felblood (triggered)'),
(3199,0,3,0,6,0,75,0,0,0,0,0,0,11,80174,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Burning Blade Cultist - On Death - Cast Felblood (triggered)');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (3195, 3196, 3199);
