-- Swamp of Sorrows, the Bloodmire and Stonard: remove doubled spawns.
--
-- Marshtide Cleric 46841 is the seated accessory of the Marshtide Steed 46840 (vehicle_template_accessory); the three static
-- clerics are sniffed copies of those riders (two on the very spot of their steed, z +2.5 = seat height; the third 11 yd
-- from its steed), as the Stonard Wardrummers removed in 2026_10_29_986b_01. Six Stonard Ogres are each a second copy of
-- another ogre: same start spot (0.1-0.9 yd) and the same waypoint path point for point (311767 = 311711, 311744 = 311718,
-- 311747 = 311720, 311755 = 311752, 311815 = 311783, 311802 = 311793); 64 ogres stay for Tides of Darkness. In Stonard and
-- the Bloodmire, checked against the TDB spawns (one witness: both boxes hold the same rows), each removed spawn leaves a
-- kept spawn of its entry within 15 yd and 3 yd of height, and the TDB has one spawn where mop had two or three: Stonard Orc
-- 864 189966 / 190635 (TDB 3, mop 7; 6.6 yd apart, beside 163145), Stonard Grunt 866 189791 (11 yd from 163936), 189792
-- (4.7 yd from 190474) and 190207 (0.3 yd from 163516) (TDB 10 in Stonard, mop 16; mop's own patrol paths, the TDB has
-- them standing), Stonard Warrior 46166 191011 (the only one of 29 not on a TDB spot; its nearest TDB spot is 191009's,
-- 14.2 yd). Fallen Stonard Warrior 46882 580140 lies 2.1 yd from 311624 (same x, the next closest pair of corpses is 6.6 yd;
-- 580140 is of the zone-0 batch 580128-580154 that LoA added beside the 311xxx corpses; no TDB or Wowhead source spawns the
-- corpses at all): one body twice, the 5-yd banner search offered the second at once. 30 Fallen Stonard Warriors stay.
-- Kept: the ten kodos (no shared spot or path), the Splinterspear tower grunts (area 1780, different floors).
-- Nothing else refers to these spawns (pools, game events, formations, linked respawns, per-spawn SmartAI: none).

DELETE FROM `creature_addon` WHERE `guid` IN (311767,311744,311747,311755,311815,311802,189791,189792,190207);
DELETE FROM `waypoint_data` WHERE `id` IN (311767,311744,311747,311755,311815,311802,189791,189792,190207);
DELETE FROM `creature` WHERE `guid` IN (190581,190583,190866) AND `id`=46841;
DELETE FROM `creature` WHERE `guid` IN (311767,311744,311747,311755,311815,311802) AND `id`=46765;
DELETE FROM `creature` WHERE `guid` IN (189966,190635) AND `id`=864;
DELETE FROM `creature` WHERE `guid` IN (189791,189792,190207) AND `id`=866;
DELETE FROM `creature` WHERE `guid`=191011 AND `id`=46166;
DELETE FROM `creature` WHERE `guid`=580140 AND `id`=46882;
