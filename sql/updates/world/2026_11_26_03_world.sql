-- Searing Gorge: They Build a Better Bullet (28030, 200 Dark Iron Bullets 62916).
-- Reported by the user in play (2026-11-18): the Marksmen always drop one bullet; it should be a small range, less than
-- the crates give.
-- Sourced: Wowhead MoP Classic, item 62916 "Dropped by": Dark Iron Marksman 8338 and Dark Iron Lookout 8566 both drop
--   stacks of 2-6, evenly spread (Marksman 2: 19.7 %, 3: 21.8 %, 4: 22.1 %, 5: 18.5 %, 6: 18.0 %; Lookout 22.6 / 17.8 / 19.6 /
--   17.8 / 22.3 %). The crates (object 206659) give 11-19 there, which mop already has.
-- Kept: the chances (Marksman quest drop 100 %, Lookout 77.8 %). Wowhead's shares (93 % and 14 %) count kills by players
--   without the quest too, so they are not the quest holder's rate; the less grindy values stay.

UPDATE `creature_loot_template` SET `mincountOrRef` = 2, `maxcount` = 6 WHERE `entry` IN (8338, 8566) AND `item` = 62916;
