-- Swamp of Sorrows C (_48): posed spawns stop sliding about (not a plan row: the archetype check "spawns posed as dead or
-- asleep with a MovementType other than 0", run over zones 8 and 1477).
--
-- SOURCED: both TDBs have every one of these idle (MovementType 0, wander 0). The eight Butchered Drakes in the Butchery lie as
-- corpses (template aura 70628 Permanent Feign Death) and wandered 3 yd; four Atal'ai kneel (StandState 8) and wandered; Duskfang
-- sleeps in his cave (StandState 3) and wandered.
-- Battle entries (section B) are not touched; none of them showed up in the query.
-- Idempotent: absolute UPDATEs.

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 46629 AND `guid` IN (189899, 189900, 189901, 189902, 189903, 189904, 189905, 189906);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (191099, 191103) AND `id` = 5243;
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 191101 AND `id` = 5269;
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 191108 AND `id` = 5261;
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 190271 AND `id` = 47053;
