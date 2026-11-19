-- Northwatch Foothold respawns: the three attack plans (The War of Northwatch Aggression) and the quest mobs of Breaking the Chain and
-- Purge the Valley.
-- Plans 3189 3190 3192 (consumable goobers): Wowhead 25169 2014-01-28 [+3] "respawn about 10 seconds after another player burned one";
-- both TDBs 120 (TC's value for unsniffed objects). Not certain, so the less grindy sourced value: 10 s.
-- Northwatch Lug 39249 (the 19 with KillCredit to 39245), Infantryman 39260 and Ranger 39261: 300 s in mop, 120 s in both TDBs
-- (Wowhead 25168 2010-11-24: "terrible respawn rate"; 19 mobs for 12 kills).
UPDATE `gameobject` SET `spawntimesecs` = 10 WHERE `guid` IN (173146, 173147, 173148) AND `id` IN (3189, 3190, 3192);
UPDATE `creature` SET `spawntimesecs` = 120 WHERE `id` IN (39249, 39260, 39261) AND `map` = 1;
