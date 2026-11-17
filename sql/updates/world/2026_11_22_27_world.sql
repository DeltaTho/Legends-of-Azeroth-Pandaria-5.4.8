-- Burning Steppes: spread the last Blackrock Soldier and Smolderthorn Assassin knots at the Fields of Honor (review C-E M1).
--
-- _21 moved a kept spawn onto its retail partner only when the two were more than 5 yd apart; several kept 7025 / 48119 stood
-- 1.5-4 yd from one retail spot, each matched to a different partner, and none moved: 165577 / 165599 / 165601 / 165908 and
-- 165583 / 165586 / 165608 within 0.6-1.9 yd, 48119 165593 / 165603 0.74 yd apart. Retail has no 7025 or 48119 pair under 1.5 yd.
-- Here every non-patrolling 7025 / 48119 of the zone is matched one-to-one to the TDB 1210 spots of its entry (66 / 42 after the
-- patroller 165532 keeps its own; nearest first, then pairwise swaps that shorten the total) and moved onto its spot when more than
-- 0.3 yd away. Counts unchanged (66 / 43). Sourced: positions and facing (TDB guid per line). Ours: the matching.

UPDATE `creature` SET `position_x`=-7770.85,`position_y`=-1558.1,`position_z`=133.019,`orientation`=2.05949 WHERE `guid`=165595 AND `id`=7025; -- TDB 289445, 0.3 yd
UPDATE `creature` SET `position_x`=-7764.52,`position_y`=-1561.99,`position_z`=132.452,`orientation`=2.05949 WHERE `guid`=165586 AND `id`=7025; -- TDB 289453, 1.5 yd
UPDATE `creature` SET `position_x`=-7767.75,`position_y`=-1556.02,`position_z`=132.717,`orientation`=2.05949 WHERE `guid`=165599 AND `id`=7025; -- TDB 289456, 1.7 yd
UPDATE `creature` SET `position_x`=-7767.42,`position_y`=-1563.97,`position_z`=132.863,`orientation`=2.05949 WHERE `guid`=165608 AND `id`=7025; -- TDB 289442, 2.1 yd
UPDATE `creature` SET `position_x`=-7771.16,`position_y`=-1724.01,`position_z`=133.107,`orientation`=2.05949 WHERE `guid`=165790 AND `id`=7025; -- TDB 289387, 2.9 yd
UPDATE `creature` SET `position_x`=-7785.19,`position_y`=-1729.3,`position_z`=132.76,`orientation`=2.05949 WHERE `guid`=165767 AND `id`=7025; -- TDB 289359, 3.1 yd
UPDATE `creature` SET `position_x`=-7764.95,`position_y`=-1554.26,`position_z`=132.488,`orientation`=2.05949 WHERE `guid`=165601 AND `id`=7025; -- TDB 289467, 3.1 yd
UPDATE `creature` SET `position_x`=-7716.69,`position_y`=-1596.8,`position_z`=131.881,`orientation`=0.872665 WHERE `guid`=165574 AND `id`=7025; -- TDB 289450, 3.2 yd
UPDATE `creature` SET `position_x`=-7767.3,`position_y`=-1729.64,`position_z`=133.411,`orientation`=2.05949 WHERE `guid`=165778 AND `id`=7025; -- TDB 289383, 3.3 yd
UPDATE `creature` SET `position_x`=-7777.15,`position_y`=-1736.05,`position_z`=133.34,`orientation`=2.05949 WHERE `guid`=165782 AND `id`=7025; -- TDB 289370, 3.3 yd
UPDATE `creature` SET `position_x`=-7721.71,`position_y`=-1597.42,`position_z`=131.656,`orientation`=0.872665 WHERE `guid`=165569 AND `id`=7025; -- TDB 289443, 3.4 yd
UPDATE `creature` SET `position_x`=-7782.16,`position_y`=-1609.46,`position_z`=133.003,`orientation`=3.4282 WHERE `guid`=165679 AND `id`=7025; -- TDB 289435, 3.4 yd
UPDATE `creature` SET `position_x`=-7725.33,`position_y`=-1538.74,`position_z`=134.227,`orientation`=1.55334 WHERE `guid`=165662 AND `id`=7025; -- TDB 289507, 3.4 yd
UPDATE `creature` SET `position_x`=-7777.49,`position_y`=-1720.76,`position_z`=132.889,`orientation`=2.05949 WHERE `guid`=165794 AND `id`=7025; -- TDB 289386, 3.4 yd
UPDATE `creature` SET `position_x`=-7763.15,`position_y`=-1549.57,`position_z`=132.729,`orientation`=2.05949 WHERE `guid`=165390 AND `id`=7025; -- TDB 289481, 3.5 yd
UPDATE `creature` SET `position_x`=-7710.87,`position_y`=-1589.01,`position_z`=132.722,`orientation`=0.872665 WHERE `guid`=165570 AND `id`=7025; -- TDB 289480, 3.5 yd
UPDATE `creature` SET `position_x`=-7722.84,`position_y`=-1592.59,`position_z`=132.354,`orientation`=0.872665 WHERE `guid`=165566 AND `id`=7025; -- TDB 289455, 3.5 yd
UPDATE `creature` SET `position_x`=-7761.46,`position_y`=-1559.98,`position_z`=132.116,`orientation`=2.05949 WHERE `guid`=165908 AND `id`=7025; -- TDB 289463, 3.5 yd
UPDATE `creature` SET `position_x`=-7762.81,`position_y`=-1564.85,`position_z`=132.432,`orientation`=2.05949 WHERE `guid`=165583 AND `id`=7025; -- TDB 289451, 4.9 yd
UPDATE `creature` SET `position_x`=-7722.29,`position_y`=-1695.19,`position_z`=133.561,`orientation`=1.71515 WHERE `guid`=165604 AND `id`=48119; -- TDB 289394, 1.8 yd
UPDATE `creature` SET `position_x`=-7772.8,`position_y`=-1721.63,`position_z`=132.856,`orientation`=2.05949 WHERE `guid`=165779 AND `id`=48119; -- TDB 289388, 2.9 yd
UPDATE `creature` SET `position_x`=-7783.61,`position_y`=-1731.97,`position_z`=132.912,`orientation`=2.05949 WHERE `guid`=165781 AND `id`=48119; -- TDB 289360, 3.1 yd
UPDATE `creature` SET `position_x`=-7718.42,`position_y`=-1599.46,`position_z`=131.324,`orientation`=0.872665 WHERE `guid`=165589 AND `id`=48119; -- TDB 289440, 3.2 yd
UPDATE `creature` SET `position_x`=-7772.59,`position_y`=-1729.16,`position_z`=133.336,`orientation`=2.05949 WHERE `guid`=165775 AND `id`=48119; -- TDB 289380, 3.2 yd
UPDATE `creature` SET `position_x`=-7772.61,`position_y`=-1554.43,`position_z`=133.107,`orientation`=2.05949 WHERE `guid`=165593 AND `id`=48119; -- TDB 289447, 4.2 yd
UPDATE `creature` SET `position_x`=-7779.29,`position_y`=-1725.45,`position_z`=132.973,`orientation`=2.05949 WHERE `guid`=165774 AND `id`=48119; -- TDB 289379, 3.3 yd
UPDATE `creature` SET `position_x`=-7769.02,`position_y`=-1726.8,`position_z`=133.324,`orientation`=2.05949 WHERE `guid`=165784 AND `id`=48119; -- TDB 289385, 3.3 yd
UPDATE `creature` SET `position_x`=-7778.86,`position_y`=-1733.18,`position_z`=133.177,`orientation`=2.05949 WHERE `guid`=165776 AND `id`=48119; -- TDB 289371, 3.3 yd
UPDATE `creature` SET `position_x`=-7719.8,`position_y`=-1594.63,`position_z`=132.251,`orientation`=0.872665 WHERE `guid`=165695 AND `id`=48119; -- TDB 289452, 3.4 yd
UPDATE `creature` SET `position_x`=-7713.58,`position_y`=-1586.79,`position_z`=132.798,`orientation`=0.872665 WHERE `guid`=165571 AND `id`=48119; -- TDB 289483, 3.5 yd
UPDATE `creature` SET `position_x`=-7725.79,`position_y`=-1590.7,`position_z`=132.249,`orientation`=0.872665 WHERE `guid`=165573 AND `id`=48119; -- TDB 289459, 3.5 yd
UPDATE `creature` SET `position_x`=-7763.29,`position_y`=-1557.08,`position_z`=132.273,`orientation`=2.05949 WHERE `guid`=165602 AND `id`=48119; -- TDB 289465, 3.9 yd
UPDATE `creature` SET `position_x`=-7717.83,`position_y`=-1591.82,`position_z`=132.771,`orientation`=0.872665 WHERE `guid`=165567 AND `id`=48119; -- TDB 289462, 4.6 yd
UPDATE `creature` SET `position_x`=-7769.19,`position_y`=-1552.74,`position_z`=132.892,`orientation`=2.05949 WHERE `guid`=165603 AND `id`=48119; -- TDB 289458, 3.9 yd
UPDATE `creature` SET `position_x`=-7758.25,`position_y`=-1557.97,`position_z`=132.001,`orientation`=2.05949 WHERE `guid`=165592 AND `id`=48119; -- TDB 289476, 12.8 yd
