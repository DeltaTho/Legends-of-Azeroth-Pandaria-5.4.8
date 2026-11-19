-- Durotar, Spiketooth's camp: the six Cosmetic Trigger - PRK 39519 bunnies round the chained gladiators wandered 3 yd. Both TDBs
-- spawn them idle at the same six spots with the same orientations (310402 310584 310585 310587 310589 310591). Plan ruling R22.
-- Not ported: the TDBs' AIName SmartAI on the template (neither TDB has a smart_scripts row for 39519, so it does nothing there).

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 39519;
