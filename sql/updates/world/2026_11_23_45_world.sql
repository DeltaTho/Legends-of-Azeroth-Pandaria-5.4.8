-- Swamp of Sorrows C (_45): the Sunken Temple outside the instance (plan C-09..C-13; S2 dossier F7, F8, F9, H4, H6; S5 section
-- 5; plan K1, K16, K17, R-15).
--
-- SOURCED:
-- - Jade 1063 guid 2900, a hostile level-55 rare, stands 1.4 yd from Lord Itharius on the temple top; neither TDB has her there
--   (her other spawn 318338 in the north of the zone stays, unpooled).
-- - Priestess Udum'bra and Hr'nglth the Lost onto their TDB 12.1.0 spots (293211, 292722), where the quest POIs of 27705 / 27757
--   are centred (14 and 8 yd off today).
-- - Two Corrupted Guardians at the Hall of Masks (comment 27705 2011-07-11 [+20]; both TDBs): the unmatched copies 190514 /
--   190515 (1.6 yd apart, 13-18 yd from the TDB pair) go.
-- - Atal'ai Artifacts (30854, 30855, 30856: three displays of one object, all three loot 30854 -> 6175; 63 spawns, 61 after):
--   161972 (z 18.7, on dry land, 51 yd from any TDB artifact of the three entries) and 161973 (z 5.4, 1.6 yd under the terrain,
--   78 yd from any TDB artifact) go. The comments put the artifacts on the lake bottom; the eleven artifacts that stand above the
--   water on the ruins and the shore are on TDB spots and stay (plan K17 said "above the water surface": overturned, see the report).
-- - The pit (zone 1477) holds the outdoor trash and critters twice (local 137, TDB 88): S5's doubles rule (tmp\S5\plan2.py)
--   run over zone 1477 (tmp\coder-ac\pit.py) deletes the 37 below. Three more (S2 H6's
--   unmatched list) stand exactly on a mob of another entry that has its TDB partner, with no TDB spawn of their own entry on
--   the spot: one mob per spot, as S5 did for the Enthralled in Stagalbog Cave.
-- - Veyzhak the Cannibal 5399 (49696, by Gomora) and Zekkis 5400 (123648-123650, pool 1269, at Jammal'an): classic rares of the
--   outdoor temple halls. Wowhead MoP Classic has no map pin for either (gate pages 2026-11-17; every comment predates
--   Cataclysm) and neither TDB spawns them: gone in 5.4.8. Their pool 1269 and its master pool 1045145, which held nothing
--   else, go with them.
-- OURS: the rule's thresholds (15 yd, TDB partner within 40 yd) plus a height guard for the pit's floors (no cluster across more
--   than 5 yd of height, a TDB partner within 8 yd of height). Udum'bra, Gomora, Jammal'an, Captain Wyrmak, Veyzhak, Zekkis, the
--   Butchered Drakes, Lord Itharius and the Guardians are outside the rule.
-- Every dependent row of a deleted spawn goes with it. Idempotent: DELETE, absolute UPDATEs.

-- C-10: Udum'bra and Hr'nglth on their sniffed spots
UPDATE `creature` SET `position_x` = -10359.8, `position_y` = -3956.93, `position_z` = -99.4814, `orientation` = 1.37881 WHERE `guid` = 191062 AND `id` = 46424;
UPDATE `creature` SET `position_x` = -10968.9, `position_y` = -3665.62, `position_z` = 27.9034, `orientation` = 2.94961 WHERE `guid` = 191070 AND `id` = 46371;

-- C-09, C-11, C-13: dependents of every creature deleted below
DELETE FROM `creature_addon` WHERE `guid` IN (2900,190514,190515,189795,189913,189969,190044,190140,190165,190217,190220,190221,190251,190401,190475,190639,190682,190703,190728,190737,190746,190757,190770,190791,190798,190804,190825,190836,190838,190846,190917,190918,190921,190923,191061,191063,191068,191073,191098,191100,191163,191165,191172);
DELETE FROM `waypoint_data` WHERE `id` IN (190737);
DELETE FROM `pool_creature` WHERE `guid` IN (2900,190514,190515,189795,189913,189969,190044,190140,190165,190217,190220,190221,190251,190401,190475,190639,190682,190703,190728,190737,190746,190757,190770,190791,190798,190804,190825,190836,190838,190846,190917,190918,190921,190923,191061,191063,191068,191073,191098,191100,191163,191165,191172);
DELETE FROM `game_event_creature` WHERE `guid` IN (2900,190514,190515,189795,189913,189969,190044,190140,190165,190217,190220,190221,190251,190401,190475,190639,190682,190703,190728,190737,190746,190757,190770,190791,190798,190804,190825,190836,190838,190846,190917,190918,190921,190923,191061,191063,191068,191073,191098,191100,191163,191165,191172);
DELETE FROM `creature_formations` WHERE `memberGUID` IN (2900,190514,190515,189795,189913,189969,190044,190140,190165,190217,190220,190221,190251,190401,190475,190639,190682,190703,190728,190737,190746,190757,190770,190791,190798,190804,190825,190836,190838,190846,190917,190918,190921,190923,191061,191063,191068,191073,191098,191100,191163,191165,191172) OR `leaderGUID` IN (2900,190514,190515,189795,189913,189969,190044,190140,190165,190217,190220,190221,190251,190401,190475,190639,190682,190703,190728,190737,190746,190757,190770,190791,190798,190804,190825,190836,190838,190846,190917,190918,190921,190923,191061,191063,191068,191073,191098,191100,191163,191165,191172);
DELETE FROM `linked_respawn` WHERE `guid` IN (2900,190514,190515,189795,189913,189969,190044,190140,190165,190217,190220,190221,190251,190401,190475,190639,190682,190703,190728,190737,190746,190757,190770,190791,190798,190804,190825,190836,190838,190846,190917,190918,190921,190923,191061,191063,191068,191073,191098,191100,191163,191165,191172) OR `linkedGuid` IN (2900,190514,190515,189795,189913,189969,190044,190140,190165,190217,190220,190221,190251,190401,190475,190639,190682,190703,190728,190737,190746,190757,190770,190791,190798,190804,190825,190836,190838,190846,190917,190918,190921,190923,191061,191063,191068,191073,191098,191100,191163,191165,191172);
DELETE FROM `creature_movement_override` WHERE `SpawnId` IN (2900,190514,190515,189795,189913,189969,190044,190140,190165,190217,190220,190221,190251,190401,190475,190639,190682,190703,190728,190737,190746,190757,190770,190791,190798,190804,190825,190836,190838,190846,190917,190918,190921,190923,191061,191063,191068,191073,191098,191100,191163,191165,191172);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (-2900,-190514,-190515,-189795,-189913,-189969,-190044,-190140,-190165,-190217,-190220,-190221,-190251,-190401,-190475,-190639,-190682,-190703,-190728,-190737,-190746,-190757,-190770,-190791,-190798,-190804,-190825,-190836,-190838,-190846,-190917,-190918,-190921,-190923,-191061,-191063,-191068,-191073,-191098,-191100,-191163,-191165,-191172);
-- C-09: Jade on the temple top
DELETE FROM `creature` WHERE `id` = 1063 AND `guid` = 2900;
-- C-11: the doubled Corrupted Guardians
DELETE FROM `creature` WHERE `id` = 46068 AND `guid` IN (190514, 190515);
-- C-13: pit doubles
DELETE FROM `creature` WHERE `id` = 4075 AND `guid` IN (189795,189913,190140,190217,190221,190703,190746,190791,190798,190921); -- Rat x10
DELETE FROM `creature` WHERE `id` = 5225 AND `guid` IN (191068,191073); -- Murk Spitter x2
DELETE FROM `creature` WHERE `id` = 5243 AND `guid` IN (191098,191100); -- Cursed Atalai x2
DELETE FROM `creature` WHERE `id` = 5263 AND `guid` IN (190401,191061,191063); -- Mummified Atalai x3
DELETE FROM `creature` WHERE `id` = 13321 AND `guid` IN (189969,190044,190165,190220,190251,190475,190639,190728,190737,190757,190825,190836,190838,190918,190923); -- Small Frog x15
DELETE FROM `creature` WHERE `id` = 14881 AND `guid` IN (190682,190770,190804,190846,190917); -- Spider x5
-- C-13: one mob per spot where two entries stand on each other
DELETE FROM `creature` WHERE `id` = 5269 AND `guid` = 191163; -- Atalai Priest on the spot of a TDB-matched mob
DELETE FROM `creature` WHERE `id` = 5243 AND `guid` = 191165; -- Cursed Atalai on the spot of a TDB-matched mob
DELETE FROM `creature` WHERE `id` = 5225 AND `guid` = 191172; -- Murk Spitter on the spot of a TDB-matched mob

-- C-12: Atal'ai Artifacts away from the lake
DELETE FROM `gameobject_addon` WHERE `guid` IN (161972, 161973);
DELETE FROM `pool_gameobject` WHERE `guid` IN (161972, 161973);
DELETE FROM `game_event_gameobject` WHERE `guid` IN (161972, 161973);
DELETE FROM `gameobject` WHERE `id` = 30854 AND `guid` IN (161972, 161973);

-- R-15: Veyzhak the Cannibal and Zekkis (classic rares; no MoP Classic pin)
DELETE FROM `creature_addon` WHERE `guid` IN (49696, 123648, 123649, 123650);
DELETE FROM `game_event_creature` WHERE `guid` IN (49696, 123648, 123649, 123650);
DELETE FROM `creature_formations` WHERE `memberGUID` IN (49696, 123648, 123649, 123650) OR `leaderGUID` IN (49696, 123648, 123649, 123650);
DELETE FROM `linked_respawn` WHERE `guid` IN (49696, 123648, 123649, 123650) OR `linkedGuid` IN (49696, 123648, 123649, 123650);
DELETE FROM `creature_movement_override` WHERE `SpawnId` IN (49696, 123648, 123649, 123650);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (-49696, -123648, -123649, -123650);
DELETE FROM `pool_creature` WHERE `guid` IN (49696, 123648, 123649, 123650) OR `pool_entry` = 1269;
DELETE FROM `pool_pool` WHERE `pool_id` = 1269 OR `mother_pool` = 1045145;
DELETE FROM `pool_template` WHERE `entry` IN (1269, 1045145);
DELETE FROM `creature` WHERE `id` = 5399 AND `guid` = 49696;
DELETE FROM `creature` WHERE `id` = 5400 AND `guid` IN (123648, 123649, 123650);
