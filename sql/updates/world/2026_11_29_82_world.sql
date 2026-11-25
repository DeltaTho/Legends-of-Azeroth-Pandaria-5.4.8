-- Northern Barrens, Grol'dom Farm: the two Injured Grol'dom Grunts 34563 lie in the hammocks (template addon StandState 3) but
-- wandered 3 yd out of them (MovementType 1). Both TDBs (4.4.2 and 12.1.0; spawns 303733 / 303735 at the same positions) have
-- wander 0 and MovementType 0 (play test 2026-11-24).
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=34563 AND `guid` IN (262675,262677);
