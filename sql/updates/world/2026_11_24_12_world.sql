-- Blasted Lands A (_12): a Darktail Bonepicker missed by Enohar's Explosive Arrow comes for the archer, and a hit shows the
-- flaming-arrow hit (dossier S2 F-ARROW-MISS and 25709 claim 7; coverage audit C3; Curtail the Darktail 25709).
--
-- Today: row 0 (SPELLHIT 78838, 75 %, once) kills the bird (DIE) and its link row 1 credits the archer; on the other 25 %
-- nothing happens (78838 is a DUMMY counted as positive, so the hit starts no combat) and the bird keeps circling. Every shot,
-- hit or miss, shows only 78838's own visual 16668, which is the miss visual (78836 'Flaming Arrow (Miss)' carries the same
-- 16668); 78834 'Flaming Arrow (Hit)' (visual 16665, a projectile at speed 70, range 15-150 yd like the bow, AttributesEx2
-- 0x4 ignore line of sight, no CAN_TARGET_DEAD) is referenced by nothing.
-- SOURCED: wiki notes "if it does [miss], it will aggro the vulture"; 2010-11-23 [+6] "a miss, meaning the bird attacked me";
-- 2011-04-07 [+16]; 2013-07-14 [+2]; the hit / miss spell pair in the 5.4.8 DBC.
-- OURS: the miss row (row 4); and the hit visual: row 0 now has the archer cast 78834 on the bird (INVOKER_CAST, triggered)
-- while it is still alive (78834 cannot target a dead unit), then links to the new row 5 (DIE), which links to row 1 (credit,
-- unchanged). Same chance, same once-flag, same credit as before. Row 4 runs on every hit after row 0's chain (id order); when
-- the bird is already dead, Unit::Attack refuses a dead attacker (Unit.cpp 8906), so it only acts on a miss. Row 0's chance roll
-- comes before its once-flag (SmartScript.cpp 106-112). Rows 2 / 3 (abilities pass) untouched.

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 42235 AND `ScriptName` = '';
UPDATE `smart_scripts` SET `link` = 5, `action_type` = 85, `action_param1` = 78834, `action_param2` = 2, `action_param3` = 0, `target_type` = 1,
  `comment` = 'Darktail Bonepicker - On Spellhit ''Enohar''s Explosive Arrow'' (75 %) - Invoker Cast ''Flaming Arrow (Hit)'' on Self'
  WHERE `entryorguid` = 42235 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 8;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 42235 AND `source_type` = 0 AND `id` IN (4, 5);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(42235, 0, 4, 0, 8, 0, 100, 0, 78838, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Darktail Bonepicker - On Spellhit ''Enohar''s Explosive Arrow'' (missed: still alive) - Attack Invoker'),
(42235, 0, 5, 1, 61, 0, 100, 0, 0, 0, 0, 0, 0, 37, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Darktail Bonepicker - Linked - Die');
