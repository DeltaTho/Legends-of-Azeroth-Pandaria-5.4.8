-- Two doubled Dustwind Storm Witches (3118) in Razorwind Canyon: 253137 stands 0.3 yd from 251117 and 251419 0.2 yd from 251238 (layers.txt).
-- Keep the older guid of each pair; no addon, formation, pool, event or SmartAI rows use the two. Sourced (same-spot doubles).
DELETE FROM `creature_addon` WHERE `guid` IN (253137, 251419);
DELETE FROM `creature` WHERE `guid` IN (253137, 251419) AND `id` = 3118;
