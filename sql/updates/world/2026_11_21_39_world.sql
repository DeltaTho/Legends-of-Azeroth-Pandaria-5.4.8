-- Searing Gorge, C-15 + C-16 + C-17: posed and sniffed-idle spawns stop wandering; stacked Cauldron guards removed.
-- C-15: spawns of other sections' entries that sit within 0.5 yd of a TDB 12.1.0 / 4.4.2 spawn of the same entry with
--   MovementType 0 and wander 0; mop_world had them wander 3 yd (MovementType 1), which slides miners (emote 233), kneelers
--   (StandState 8), channelers (aura 8734) and marksmen about. Set idle. Re-checked against the TDB dump before shipping.
-- C-16: Ministers Kiyuubi 47309 (guid 186388) and Letherio 47310 (186401) idle. Sourced for Kiyuubi (TDB MovementType 0); Letherio's
--   TDB path with talk emotes is not ported (ours, deferred X10).
-- C-17: Digmasters 47533 / Blacksmiths 47535 stood on 8 spots twice or three times (guids 186641 186636 186545 186463 186228
--   186160 186159 186455 deleted; the 8 kept spots are idled above). The TDB stacks one of each at the 8 spots; which entry stays
--   is ours.
-- The tower-fire / smoke spawn line of the old hand-off is C-13's (file 38). Idempotent.

UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=5839 AND `guid` IN (186071,186128,186284,186325,186349,186368,186371,186378,186380,186385,186440);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=47275 AND `guid` IN (186093);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=47276 AND `guid` IN (162743,162789,162802,162807,162808,162812,186080,186085,186088,186435,186450,186531);
-- thorium-point: 5861 / 5862 kneeling (StandState 8), 8338 Dark Iron Marksman (Iron Summit siege line), 8419 Twilight
-- Idolater (channel 8734), 47311 Minister Finister, 47438 Rendan's Attendant
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=5861 AND `guid` IN (186176,186182,186203);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=5862 AND `guid` IN (186192);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=8338 AND `guid` IN (166173,186089,186177,186178,186184,186191,186193,186207,186213,186217,186226,186227,186254,186255,186257,186263,186287,186311,186314,186317,186342);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=8419 AND `guid` IN (186327,186331,186337,186376);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=47311 AND `guid` IN (186341);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=47438 AND `guid` IN (165199,165241,165243,165245);
-- cauldron-finale: 14621 Overseer Maltorius, 47460 Twilight-Lord Arkkus, 47462 Archduke Calcinder, 47533 / 47535
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=14621 AND `guid` IN (186150);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=47460 AND `guid` IN (186151);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=47462 AND `guid` IN (186222);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=47533 AND `guid` IN (186445,186551,186615,186645);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `id`=47535 AND `guid` IN (186370,186443,186457,186620);

UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid` IN (186388,186401) AND `id` IN (47309,47310);

DELETE FROM `creature_addon` WHERE `guid` IN (186641,186636,186545,186463,186228,186160,186159,186455);
DELETE FROM `creature` WHERE `guid` IN (186641,186636,186545,186463,186228,186160,186159,186455) AND `id` IN (47533,47535);
