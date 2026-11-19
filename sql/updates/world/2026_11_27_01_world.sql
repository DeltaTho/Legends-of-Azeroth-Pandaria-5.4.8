-- Valley of Trials quest targets respawn as the sources describe.
-- Sourced: Sarkoth (3281) "every 90 seconds" (Wowhead, Cataclysm era; the "every minute" comment is from 2007, before the revamp,
-- and is set aside), Yarrog Baneshadow (3183) "90-120 s", "2 min" (Wowhead comments); both TDBs 120 s, which is the TDB value of
-- every spawn in this box. Not certain, so the less grindy of the Cataclysm-era values, 90 s (the user's rule).
-- Thazz'ril's Pick (178087, a consumable chest) "There is a 10 second respawn time" (wiki) and
-- "15 second respawn time" (2010-09-22): 10 s. Yarrog stands on his ledge channelling (both TDBs: MovementType 0); mop let him wander
-- 3 yd, which broke the channel pose.
UPDATE `creature` SET `spawntimesecs` = 90 WHERE `id` IN (3281, 3183);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 3183;
UPDATE `gameobject` SET `spawntimesecs` = 10 WHERE `id` = 178087;
