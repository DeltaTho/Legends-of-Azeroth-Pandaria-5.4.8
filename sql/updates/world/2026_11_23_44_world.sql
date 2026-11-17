-- Swamp of Sorrows C (_44): Winter Reveler faction, Hallow's End skull lights imported twice (plan C-07, C-08; S5 dossier 3
-- Parts E, F).
--
-- SOURCED: Winter Reveler 15760 faction 35 (both TDBs; mop 774 is an Alliance-only template and two revelers stand in the Stonard
-- inn; the change is entry-wide, which is the point). Seven skull lights 180472 in Stonard are zone-0 copies of the zone-8 rows on
-- the same x/y/z.
-- Idempotent: absolute UPDATE, DELETE.

UPDATE `creature_template` SET `faction` = 35 WHERE `entry` = 15760;
DELETE FROM `game_event_gameobject` WHERE `guid` IN (104363, 104364, 104366, 104370, 104371, 104375, 104380);
DELETE FROM `gameobject_addon` WHERE `guid` IN (104363, 104364, 104366, 104370, 104371, 104375, 104380);
DELETE FROM `gameobject` WHERE `id` = 180472 AND `guid` IN (104363, 104364, 104366, 104370, 104371, 104375, 104380);
