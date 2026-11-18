-- Searing Gorge (zone 51): doubled elementals and Heavy War Golems in the Pyrox Flats and around the Cauldron.
-- Reported by the user in play on 2026-11-18 ("some of the elementals and war golems in Pyrox Flats appear to be duplicate
-- spawns"). The Searing Gorge pass removed only same-entry pairs under 2 yd and left the denser layer alone.
-- Sourced: the layout. Both TDBs (4.4.2 and 12.1.0, one witness) have 64 elemental spots in the zone, each holding one of
--   Blazing Elemental 5850 / Inferno Elemental 5852 / Magma Elemental 5855 (63 spots carry a row of all three entries), and
--   28 Heavy War Golems 5854. mop had 109 elementals standing at once (38 / 31 / 40) and 45 golems: an old 165xxx spawn band
--   lying under the 185xxx-186xxx one, and several spots filled twice inside the newer band.
-- Ours: the rule. Each TDB spot keeps the nearest local spawn (elementals: any of the three entries, within 12 yd; golems
--   within 20 yd). A spawn that got no TDB spot and stands within 15 yd of a kept one is deleted: 43 elementals (13 Blazing,
--   13 Inferno, 17 Magma) and 13 golems. Spawns without a TDB spot that stand alone are kept (4 elementals, 6 golems).
-- After this file: 66 elementals (25 / 18 / 23) and 32 Heavy War Golems. Quests: 12 golem kills, and Furnace Flasks on any
--   living elemental (27981): unaffected.
-- Dependents: 34 creature_addon rows and the seven private waypoint paths of the deleted patrollers (no other spawn or
--   template uses them). No pool, event, formation, linked respawn, guid SmartAI, SmartAI target or condition names a guid.

DELETE FROM `waypoint_data` WHERE `id` IN (165686,186116,186477,186517,186578,186580,186672);

DELETE FROM `creature_addon` WHERE `guid` IN
(165502,165519,165521,165686,165687,165691,165692,165742,165909,165913,165941,165943,165955,165956,165964,185877,185878,185886,
 185887,185903,185918,185970,186016,186031,186042,186084,186090,186098,186106,186109,186112,186115,186116,186165,186169,186219,
 186246,186267,186277,186279,186424,186464,186477,186486,186487,186490,186494,186496,186517,186524,186552,186578,186580,186656,
 186657,186672);

DELETE FROM `creature` WHERE `id` IN (5850,5852,5855,5854) AND `guid` IN
(165502,165519,165521,165686,165687,165691,165692,165742,165909,165913,165941,165943,165955,165956,165964,185877,185878,185886,
 185887,185903,185918,185970,186016,186031,186042,186084,186090,186098,186106,186109,186112,186115,186116,186165,186169,186219,
 186246,186267,186277,186279,186424,186464,186477,186486,186487,186490,186494,186496,186517,186524,186552,186578,186580,186656,
 186657,186672);
