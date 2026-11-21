-- Northern Barrens (zone 17), scope I-R: rares, one spawn each on the sniffed spot.
-- Sourced: both TDBs (1210 / 442) have one spawn per rare; the classic pooled copies (a 12 percent pool with a placeholder) and the
--   unpooled Cataclysm copies stood up together. Wowhead MoP Classic map pins (research\northern-barrens\wowhead\npc_*.html,
--   g_mapperData, converted with WorldMapArea 17) agree with the kept spots that have no TDB support: Sister Rathtalon 264218
--   14 yd from a pin, Brokespear 265477 6 yd, Swiftmane 262944 23 yd (61 pins: a patroller), Humar 263286 18 yd. Takk's TDB spot
--   (785.6,-3250.9) is 22 yd from a pin (58 pins), the old 264834 spot 10 yd: both fit, the TDB spot is used.
-- 3270 keeps 262918; 3295 264860; 3398 263981; 5828 263286; 5829 Snort only his Southern Barrens spawn 302623 (zone 4709, not
--   touched; the zone-17 copy 53201 goes); 5831 262944; 5837 131438 (out of its pool); 5842 264834 (moved); 5836 264815; 5841
--   265520; 5865 263901; 5830 264218; 5838 265477. 35216 is a Savannah Matriarch double sitting in Humar's pool 154.
-- Ours: respawn 28800 s kept (rares are optional); pools 128/137/188/201/213 keep their placeholder, which now always spawns.
-- CROSS-ZONE: removing pool_pool 1262 leaves master pool 1045161 with one child, pool 1261 = Ghost Howl 3056 (Mulgore, zone 215):
--   he was up about half the time and is now always up at one of his spots.
DELETE FROM `pool_creature` WHERE `guid` IN (36681,53108,53109,33719,35262,53201,53202,263283,36654,265756,39195,39043,33146,53207,38197,32745,131438,35216);
DELETE FROM `pool_pool` WHERE `pool_id` IN (1262,1001681);
DELETE FROM `pool_template` WHERE `entry` IN (154,1262,1001681,1273);
DELETE FROM `creature_addon` WHERE `guid` IN (36681,53108,53109,33719,35262,53201,53202,263283,36654,265756,39195,39043,33146,53207,38197,32745,35216);
DELETE FROM `waypoint_data` WHERE `id`=53201;
DELETE FROM `creature` WHERE `id`=3270 AND `guid` IN (36681);
DELETE FROM `creature` WHERE `id`=3295 AND `guid` IN (53108,53109);
DELETE FROM `creature` WHERE `id`=3398 AND `guid` IN (33719);
DELETE FROM `creature` WHERE `id`=3416 AND `guid` IN (35216);
DELETE FROM `creature` WHERE `id`=5828 AND `guid` IN (35262);
DELETE FROM `creature` WHERE `id`=5829 AND `guid` IN (53201);
DELETE FROM `creature` WHERE `id`=5830 AND `guid` IN (38197);
DELETE FROM `creature` WHERE `id`=5831 AND `guid` IN (53202,263283);
DELETE FROM `creature` WHERE `id`=5836 AND `guid` IN (39043);
DELETE FROM `creature` WHERE `id`=5837 AND `guid` IN (36654,265756);
DELETE FROM `creature` WHERE `id`=5838 AND `guid` IN (32745);
DELETE FROM `creature` WHERE `id`=5841 AND `guid` IN (33146);
DELETE FROM `creature` WHERE `id`=5842 AND `guid` IN (39195);
DELETE FROM `creature` WHERE `id`=5865 AND `guid` IN (53207);
UPDATE `creature` SET `position_x`=785.619, `position_y`=-3250.85, `position_z`=212.829, `orientation`=5.50004 WHERE `guid`=264834 AND `id`=5842;
