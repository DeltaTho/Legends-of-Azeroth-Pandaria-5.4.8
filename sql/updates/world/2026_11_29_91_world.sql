-- Northern Barrens nb-fix8 (_91): one Ornery Plainstrider where the Sludge Fen's north-east edge had two.
-- Ornery Plainstriders 3245 264519 (1184.7,-3049.1) and 264623 (1189.7,-3048.8) stood 5.0 yd apart, both wandering 3 yd.
-- OURS: neither TDB has a Plainstrider in the Sludge Fen (7 local, 0 TDB), so the lower guid stays and 264623 goes. No addon,
-- formation, path, guid SmartAI, pool, event or linked respawn on it.
DELETE FROM `creature_addon` WHERE `guid`=264623;
DELETE FROM `creature` WHERE `id`=3245 AND `guid`=264623;
