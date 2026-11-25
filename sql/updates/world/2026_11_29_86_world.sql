-- Northern Barrens nb-fix6 (_86): one Sunscale Ravager where Thorn Hill had two.
-- Five pairs of Sunscale Ravagers 44164 stood 2.9-6.4 yd apart in Thorn Hill (area 1699), all static (MovementType 0), one
-- copy from each of two stacked layers (2625xx and 2630xx/2631xx). Retail (TDB 1210 and 4.4.2, identical here) has one
-- Ravager per spot, wandering 10 yd, and 14 Ravagers in this part of the zone against 18 local ones.
-- SOURCED: where a TDB spot is near, the copy farther from it goes: 263034 (TDB 303914: 9.2 yd, kept 262523: 7.9 yd),
-- 263036 (TDB 303890: 3.7 yd, kept 262525: 1.8 yd), 262529 (TDB 303891: 6.8 yd, kept 263039: 1.3 yd).
-- OURS: the pairs at (-370,-3364) and (-357,-3378) have no TDB Ravager within 48 yd; the lower guid stays (262526, 262527),
-- 263131 and 263139 go. None of the five has an addon, formation, path, guid SmartAI, pool, event or linked respawn.
DELETE FROM `creature` WHERE `id`=44164 AND `guid` IN (263034,263036,262529,263131,263139);
