-- Blasted Lands A (_04): Illycor (41163, That's Not Us 25680) spits Corrosive Saliva instead of teleporting his victim to
-- Western Plaguelands (dossier S1 F-ILLYCOR).
--
-- Today: SmartAI row 0 casts 84257 'The Reckoning: Cancel Phase and Teleport' on the victim every 14-22 s (both TDBs carry the
-- same slip); 84257 effect 1 TELEPORT_UNITS -> spell_target_position (1536.13, -1685.16, 57.39) map 0, Western Plaguelands.
-- SOURCED: Wowhead abilities Corrosive Saliva and Optic Link; template spell1 84297 Corrosive Saliva, spell2 84298 Optic Link
-- (row 1, unchanged); 41163 comment [+8] (Optic Link only on players).
-- OURS: the Corrosive Saliva timers (3-6 s first, then every 9-14 s).
-- Walked whole: row 0 (Saliva, victim), row 1 (Optic Link, victim); no evade, death or respawn rows; respawn 60 s.

UPDATE `smart_scripts` SET `event_type` = 0, `event_param1` = 3000, `event_param2` = 6000, `event_param3` = 9000, `event_param4` = 14000,
  `action_type` = 11, `action_param1` = 84297, `action_param2` = 0, `target_type` = 2,
  `comment` = 'Illycor - In Combat - Cast ''Corrosive Saliva'''
  WHERE `entryorguid` = 41163 AND `source_type` = 0 AND `id` = 0;
