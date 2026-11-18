-- Blasted Lands, Protecting Our Rear (25694 / 26173): Gomegaz 41166 back within 90 s.
-- Sourced: comments 25694 2011-01-01 [+50] and 2013-08-22 ("respawns in 1 min 30 s"). mop 600 s; TDB 120 s. The less grindy
-- sourced value. His second TDB spawn and the path are left as they are (one spawn, 4-point path).
-- Ours: nothing.
UPDATE `creature` SET `spawntimesecs` = 90 WHERE `guid` = 164619 AND `id` = 41166;
