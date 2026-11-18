-- Blasted Lands (zone 4): spawns moved onto their TDB spot (section F, Part A2; OPTIONAL: drop this file for the smallest change).
-- Sourced: TDB 4.4.2 / 12.1.0 positions. 47 Felscale Crawlers 45087 (no path, no formation, no guid SmartAI) each moved onto its
--   TDB partner 5-35 yd away; every target z is on the terrain (ground.py, within 0.4 yd). The Dreadmaul Hold spirit healer
--   371250 onto TDB 259350 (-10836.0,-2952.6), 17 yd from today's spot (the Wild Turkey that stood there goes in 2026_11_24_89).
-- Ours: which crawler goes to which TDB spot (greedy nearest match). The draft also moved Felscale Crawler 163067 148 yd, beyond
--   its own 40 yd rule: left in place.

UPDATE `creature` SET `position_x`=-12310.2,`position_y`=-3870.54,`position_z`=-2.84834,`orientation`=5.21262 WHERE `guid`=163065 AND `id`=45087; -- TDB 300746, 22.9 yd
UPDATE `creature` SET `position_x`=-12532.9,`position_y`=-3751.37,`position_z`=-11.2561,`orientation`=2.42386 WHERE `guid`=163177 AND `id`=45087; -- TDB 300724, 21.5 yd
UPDATE `creature` SET `position_x`=-12250,`position_y`=-3919.55,`position_z`=-19.7615,`orientation`=4.75043 WHERE `guid`=163178 AND `id`=45087; -- TDB 300747, 28.5 yd
UPDATE `creature` SET `position_x`=-12411.1,`position_y`=-3820.97,`position_z`=1.39135,`orientation`=6.1635 WHERE `guid`=163249 AND `id`=45087; -- TDB 300739, 15.7 yd
UPDATE `creature` SET `position_x`=-12679.9,`position_y`=-3581.1,`position_z`=-10.5879,`orientation`=3.40219 WHERE `guid`=163250 AND `id`=45087; -- TDB 300719, 8.0 yd
UPDATE `creature` SET `position_x`=-12322.2,`position_y`=-3781.9,`position_z`=4.31208,`orientation`=3.3719 WHERE `guid`=163336 AND `id`=45087; -- TDB 300743, 19.2 yd
UPDATE `creature` SET `position_x`=-12328.6,`position_y`=-3837.67,`position_z`=-0.612266,`orientation`=5.00881 WHERE `guid`=163337 AND `id`=45087; -- TDB 300745, 25.9 yd
UPDATE `creature` SET `position_x`=-12188.3,`position_y`=-3870.65,`position_z`=-5.53661,`orientation`=5.10523 WHERE `guid`=163365 AND `id`=45087; -- TDB 300906, 17.0 yd
UPDATE `creature` SET `position_x`=-12578.6,`position_y`=-3639.63,`position_z`=1.6383,`orientation`=2.0231 WHERE `guid`=163366 AND `id`=45087; -- TDB 300720, 27.6 yd
UPDATE `creature` SET `position_x`=-12399.3,`position_y`=-3862.22,`position_z`=0.0062685,`orientation`=0.431316 WHERE `guid`=163367 AND `id`=45087; -- TDB 300737, 6.8 yd
UPDATE `creature` SET `position_x`=-12392.3,`position_y`=-3920.41,`position_z`=-14.1319,`orientation`=0.377968 WHERE `guid`=163381 AND `id`=45087; -- TDB 300740, 22.7 yd
UPDATE `creature` SET `position_x`=-12115.7,`position_y`=-3888.82,`position_z`=-4.59117,`orientation`=3.18412 WHERE `guid`=163382 AND `id`=45087; -- TDB 300924, 24.0 yd
UPDATE `creature` SET `position_x`=-12282.8,`position_y`=-3758.21,`position_z`=2.67574,`orientation`=4.26797 WHERE `guid`=163384 AND `id`=45087; -- TDB 300783, 17.3 yd
UPDATE `creature` SET `position_x`=-12532.7,`position_y`=-3687.61,`position_z`=-1.00247,`orientation`=4.13847 WHERE `guid`=163399 AND `id`=45087; -- TDB 300725, 15.1 yd
UPDATE `creature` SET `position_x`=-12466.2,`position_y`=-3529.17,`position_z`=19.4788,`orientation`=3.14159 WHERE `guid`=163401 AND `id`=45087; -- TDB 300633, 22.7 yd
UPDATE `creature` SET `position_x`=-12447.9,`position_y`=-3880.72,`position_z`=-4.19347,`orientation`=3.67599 WHERE `guid`=163415 AND `id`=45087; -- TDB 300741, 27.5 yd
UPDATE `creature` SET `position_x`=-12594.6,`position_y`=-3689.95,`position_z`=-5.00181,`orientation`=3.09661 WHERE `guid`=163416 AND `id`=45087; -- TDB 300721, 12.2 yd
UPDATE `creature` SET `position_x`=-12272.4,`position_y`=-3681.2,`position_z`=9.77525,`orientation`=0.789887 WHERE `guid`=163439 AND `id`=45087; -- TDB 300792, 24.0 yd
UPDATE `creature` SET `position_x`=-12194.4,`position_y`=-3740.42,`position_z`=6.12206,`orientation`=3.1123 WHERE `guid`=163469 AND `id`=45087; -- TDB 300901, 16.6 yd
UPDATE `creature` SET `position_x`=-12059.8,`position_y`=-3915.94,`position_z`=-5.61062,`orientation`=2.05891 WHERE `guid`=163488 AND `id`=45087; -- TDB 300751, 10.8 yd
UPDATE `creature` SET `position_x`=-12617.2,`position_y`=-3570.24,`position_z`=4.84261,`orientation`=1.60789 WHERE `guid`=163491 AND `id`=45087; -- TDB 300717, 12.8 yd
UPDATE `creature` SET `position_x`=-12080.1,`position_y`=-3777.83,`position_z`=8.92076,`orientation`=1.07949 WHERE `guid`=163515 AND `id`=45087; -- TDB 300986, 15.9 yd
UPDATE `creature` SET `position_x`=-12638.5,`position_y`=-3175.6,`position_z`=-0.49348,`orientation`=0.867047 WHERE `guid`=163655 AND `id`=45087; -- TDB 300689, 18.2 yd
UPDATE `creature` SET `position_x`=-12542.1,`position_y`=-3080.88,`position_z`=7.72209,`orientation`=4.42336 WHERE `guid`=163667 AND `id`=45087; -- TDB 300682, 9.3 yd
UPDATE `creature` SET `position_x`=-12555.6,`position_y`=-3321.21,`position_z`=2.79854,`orientation`=4.62611 WHERE `guid`=163691 AND `id`=45087; -- TDB 300695, 5.0 yd
UPDATE `creature` SET `position_x`=-12493.3,`position_y`=-3263.36,`position_z`=10.9765,`orientation`=4.76127 WHERE `guid`=163698 AND `id`=45087; -- TDB 300692, 17.8 yd
UPDATE `creature` SET `position_x`=-12505,`position_y`=-3213.52,`position_z`=8.7922,`orientation`=0.105695 WHERE `guid`=163704 AND `id`=45087; -- TDB 300690, 12.0 yd
UPDATE `creature` SET `position_x`=-12604.7,`position_y`=-3059.99,`position_z`=1.93615,`orientation`=1.11405 WHERE `guid`=163712 AND `id`=45087; -- TDB 300679, 15.9 yd
UPDATE `creature` SET `position_x`=-12655.5,`position_y`=-3041.71,`position_z`=9.91288,`orientation`=2.37829 WHERE `guid`=163715 AND `id`=45087; -- TDB 300680, 6.9 yd
UPDATE `creature` SET `position_x`=-12674.4,`position_y`=-3518.29,`position_z`=-10.7624,`orientation`=5.87368 WHERE `guid`=163721 AND `id`=45087; -- TDB 300708, 5.8 yd
UPDATE `creature` SET `position_x`=-12702.6,`position_y`=-2968.83,`position_z`=-26.3473,`orientation`=3.60072 WHERE `guid`=163722 AND `id`=45087; -- TDB 300678, 24.3 yd
UPDATE `creature` SET `position_x`=-12641.4,`position_y`=-3099.36,`position_z`=2.28983,`orientation`=0.631433 WHERE `guid`=163740 AND `id`=45087; -- TDB 300683, 28.7 yd
UPDATE `creature` SET `position_x`=-12783.3,`position_y`=-2983.33,`position_z`=-26.8558,`orientation`=4.55101 WHERE `guid`=163753 AND `id`=45087; -- TDB 300578, 34.9 yd
UPDATE `creature` SET `position_x`=-12512.4,`position_y`=-3130.76,`position_z`=12.1708,`orientation`=3.36739 WHERE `guid`=163758 AND `id`=45087; -- TDB 300667, 7.0 yd
UPDATE `creature` SET `position_x`=-12549.1,`position_y`=-3175.89,`position_z`=7.6199,`orientation`=1.58698 WHERE `guid`=163773 AND `id`=45087; -- TDB 300688, 33.2 yd
UPDATE `creature` SET `position_x`=-12618.7,`position_y`=-2984.52,`position_z`=4.271,`orientation`=0.480705 WHERE `guid`=163777 AND `id`=45087; -- TDB 300676, 9.1 yd
UPDATE `creature` SET `position_x`=-12582.2,`position_y`=-3121.45,`position_z`=1.13425,`orientation`=5.69469 WHERE `guid`=163789 AND `id`=45087; -- TDB 300684, 9.7 yd
UPDATE `creature` SET `position_x`=-12546.3,`position_y`=-3238.93,`position_z`=6.19209,`orientation`=3.77455 WHERE `guid`=163799 AND `id`=45087; -- TDB 300696, 16.3 yd
UPDATE `creature` SET `position_x`=-12714.7,`position_y`=-3135.45,`position_z`=-9.60103,`orientation`=1.66852 WHERE `guid`=163804 AND `id`=45087; -- TDB 300685, 21.2 yd
UPDATE `creature` SET `position_x`=-12619.4,`position_y`=-3235.71,`position_z`=2.506,`orientation`=5.51701 WHERE `guid`=163809 AND `id`=45087; -- TDB 300698, 7.5 yd
UPDATE `creature` SET `position_x`=-12653.7,`position_y`=-3422.35,`position_z`=3.16406,`orientation`=1.05207 WHERE `guid`=163810 AND `id`=45087; -- TDB 300704, 24.1 yd
UPDATE `creature` SET `position_x`=-12482.4,`position_y`=-3686.35,`position_z`=7.95812,`orientation`=0.860051 WHERE `guid`=163915 AND `id`=45087; -- TDB 300729, 16.5 yd
UPDATE `creature` SET `position_x`=-12376.4,`position_y`=-3773.83,`position_z`=5.38199,`orientation`=0.999576 WHERE `guid`=163941 AND `id`=45087; -- TDB 300735, 11.9 yd
UPDATE `creature` SET `position_x`=-12459.5,`position_y`=-3608.68,`position_z`=10.1849,`orientation`=4.26782 WHERE `guid`=163942 AND `id`=45087; -- TDB 300623, 22.8 yd
UPDATE `creature` SET `position_x`=-12513,`position_y`=-3623.12,`position_z`=3.88715,`orientation`=5.66702 WHERE `guid`=163944 AND `id`=45087; -- TDB 300722, 32.0 yd
UPDATE `creature` SET `position_x`=-12495.9,`position_y`=-3724.09,`position_z`=2.53916,`orientation`=3.64983 WHERE `guid`=163994 AND `id`=45087; -- TDB 300728, 12.9 yd
UPDATE `creature` SET `position_x`=-12583.2,`position_y`=-3383.32,`position_z`=4.60945,`orientation`=3.89535 WHERE `guid`=164520 AND `id`=45087; -- TDB 300707, 27.5 yd
UPDATE `creature` SET `position_x`=-10836,`position_y`=-2952.57,`position_z`=13.9408,`orientation`=3.05433 WHERE `guid`=371250 AND `id`=6491; -- TDB 259350
