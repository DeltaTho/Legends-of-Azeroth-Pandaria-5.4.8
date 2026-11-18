-- Blasted Lands A (_15): sleeping ogres and cultists and three Nethergarde Defender bodies stop sliding about (dossier S1 claim
-- 25675 #3, plan orphan "the sleeping 5977"; dossier S2 F-CORPSES; archetype "posed spawns with a MovementType").
--
-- Today (zone-wide query of posed spawns against creature.MovementType):
-- - Dreadmaul Hold / Post ogres lying asleep (StandState 3, spawn or template addon) with random movement 3 yd: Maulers 5977
--   163918, 164220, 164608; Warlocks 5978 163842, 163919, 164246; Ogre 5974 163811; Ogre Mage 5975 163894 (Ogre Combat 25675
--   targets and their camp).
-- - Shadowsworn Spellblade 42296 163644 (StandState 3) and Occultist 42297 163772 (Sleep Zzz 78677 + StandState 3) with random
--   movement 3 yd (Cultists at our Doorstep 25716).
-- - Nethergarde Defender 41158 bodies (template 29266 Permanent Feign Death) 163062, 163166, 163168 walk waypoint paths of 9, 17
--   and 5 points (MovementType 2): the dossier's "[I] no path exists" is overturned.
-- SOURCED: both TDBs have these entries idle (MovementType 0); 5977 / 5978 2010-11-24 [+5] (some lie or sit and a hit on them
-- crits); 26157 wiki notes (the Occultists sleep and can be skipped).
-- None of these guids is on the layout section's delete list (R\tmp\S6\S6_spawns_draft.sql, checked 2026-11-18). Each row is
-- also matched by entry, so a deleted or re-used guid changes nothing.

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0, `currentwaypoint` = 0
  WHERE (`guid`, `id`) IN ((163918, 5977), (164220, 5977), (164608, 5977), (163842, 5978), (163919, 5978), (164246, 5978),
    (163811, 5974), (163894, 5975), (163644, 42296), (163772, 42297), (163062, 41158), (163166, 41158), (163168, 41158));
UPDATE `creature_addon` ca JOIN `creature` c ON c.`guid` = ca.`guid` SET ca.`path_id` = 0
  WHERE c.`id` = 41158 AND c.`guid` IN (163062, 163166, 163168) AND ca.`path_id` <> 0;
