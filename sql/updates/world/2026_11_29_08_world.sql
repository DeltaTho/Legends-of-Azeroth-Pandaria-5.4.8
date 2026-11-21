-- Northern Barrens S1 (_08): item-started quests that could not be handed in - Chen's Empty Kegs, the Vendetta Point
-- quests, the Alliance Outrunners' scroll.
-- (plan.md section 1 `_08`; dossier D: D-819-1, D-883-1 / D-897-1, D-3513-1; questions.md Q10 default: ship here.)
--
-- SOURCED: the kegs were removed in 4.0.3 (comment 2012-09-15 [+16]; both TDBs: no 3238 spawns); Lakota'mani, Owatanka,
-- Washte Pawne and The Harvester end at Jorn Skyseer (Vendetta Point) in Cataclysm (comments 2011-02-06, 2011-03-07,
-- 2011-03-22; TDB 12.1.0 enders) and had no ender at all in mop; the Silithid Harvester drops his head again (4.0.6; both
-- TDBs 100 %); the Alliance Outrunners were removed in the Shattering (comments 2010-12-10 [+24], 2013-08-24; both TDBs: no
-- spawns), and their scroll starts The Runed Scroll (3513), which nobody ends.
-- OURS: nothing.
-- OUTSIDE ZONE 17 (Q10): two kegs (9412, 12552), the four Outrunners (32859 32868 32875 32876) and the Harvester 3253 stand in
-- Southern Barrens (zone 4709), and so does Jorn Skyseer 3387; shipped with this zone because the quests are its own.

-- D-819-1: the ten stale kegs (8 in zone 17, 2 in 4709) and their pool.
DELETE FROM `pool_gameobject` WHERE `guid` IN (2892,4410,7069,8461,9412,10625,11001,11350,12552,15523);
DELETE FROM `gameobject` WHERE `id`=3238 AND `guid` IN (2892,4410,7069,8461,9412,10625,11001,11350,12552,15523);
DELETE FROM `pool_template` WHERE `entry`=116 AND 0=(SELECT COUNT(*) FROM `pool_gameobject` WHERE `pool_entry`=116) AND 0=(SELECT COUNT(*) FROM `pool_creature` WHERE `pool_entry`=116);

-- D-883-1 / D-897-1: Jorn Skyseer ends the four quests; the Harvester's head drops again.
DELETE FROM `creature_questender` WHERE `id`=3387 AND `quest` IN (883,884,885,897);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (3387,883),(3387,884),(3387,885),(3387,897);
DELETE FROM `creature_loot_template` WHERE `entry`=3253 AND `item`=5138;
INSERT INTO `creature_loot_template` (`entry`,`item`,`ChanceOrQuestChance`,`lootmode`,`groupid`,`mincountOrRef`,`maxcount`) VALUES (3253,5138,100,1,0,1,1);

-- D-3513-1: the four Alliance Outrunners (zone 4709).
DELETE FROM `creature_addon` WHERE `guid` IN (32859,32868,32875,32876);
DELETE FROM `creature` WHERE `guid` IN (32859,32868,32875,32876) AND `id` IN (5797,5798,5799,5800);

-- D-3513-1 (review W3): their pool 100 ("4 elite_rare", child of mother pool 102 at chance 12) goes with them, so pool 102
-- always picks its other child 101 (giraffe 32816) and PoolMgr no longer logs four missing spawns (pools 101 / 102 stay).
DELETE FROM `pool_creature` WHERE `guid` IN (32859,32868,32875,32876) AND `pool_entry`=100;
DELETE FROM `pool_pool` WHERE `pool_id`=100;
DELETE FROM `pool_template` WHERE `entry`=100;
