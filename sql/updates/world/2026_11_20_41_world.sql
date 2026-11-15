-- Badlands, Troggish Troubles 27789: the Blam Turrets run the four trogg waves from a script (npc_badlands_blam_turret).
--
-- The turret's old SmartAI (LoA's own; neither TDB has rows for 46707, 4670700 or the trogg summons) sent four identical waves
-- of 32 troggs, removed nothing between waves, credited the rider only and left him in the turret at the end. It goes; the
-- script does the waves (see zone_badlands_fuselight.cpp).
-- Sourced (dossier fuselight, Second pass 1.1/1.2): four growing waves, about 2 minutes, the fourth shorter than a Power Burst
--   cooldown, up to ~20 troggs at once, leftovers vanish when a wave ends, the rider is thrown off after the fourth.
-- Ours: the counts and timings (6 / 9 / 12 / 20 troggs over 30 / 30 / 32 / 25 s), the restart at wave 1 after an interrupted run,
--   bot group members within 40 yd of the rider credited with him, bots never man a turret.
-- Unchanged: the troggs' SmartAI (46711 / 46712 attack the turret that summoned them, despawn on reaching home), the spellclick
--   row (46707, 46598), the five spawns.

UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_blam_turret' WHERE `entry` = 46707;
DELETE FROM `smart_scripts` WHERE (`entryorguid` = 46707 AND `source_type` = 0) OR (`entryorguid` = 4670700 AND `source_type` = 9);

-- The spellclick flag on the template: a destroyed turret respawns with the template npcflag (Creature::setDeathState), and with
-- 0 it could no longer be clicked. The five spawns have npcflag 0 (= the template's). The vehicle code still clears the flag
-- while the seat is taken.
UPDATE `creature_template` SET `npcflag` = `npcflag` | 16777216 WHERE `entry` = 46707;
