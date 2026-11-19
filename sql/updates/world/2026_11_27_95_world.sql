-- Durotar, Northwatch Foothold (south-west): remove the static Northwatch caravans; the caravan spawners stand still and
-- invisible as both TDBs.
--
-- What they were for: 39244/39318/39319 Northwatch Caravan A/B/C are invisible vehicles (InvisibleStalker model 17345;
-- VehicleId 680/684/685) that the three Caravan Spawners 39255 summon with Summon Northwatch Caravan A/B/C (73691, 73736,
-- 73737, in the 5.4.8 Spell.dbc). With lugs (39245/39249) and crates (39251) in their seats they made the moving lug chain
-- the wiki describes for Breaking the Chain (25167: "the Northwatch Lugs spawn at regular intervals ... form a chain of
-- mobs between the spawn point and the encampments ... coming three to a crate"). mop has 17 of them as static spawns
-- on 16 waypoint paths: sniff copies of those summons (two stand exactly on a spawner's spot), empty (no
-- vehicle_template_accessory in mop or either TDB) and moved by nothing.
-- Sourced: neither TDB spawns a caravan; both TDBs spawn the three spawners at mop's spots, idle (MovementType 0), with no
-- SmartAI, and both give the spawner's second model 22903 (Rocket Chicken) Probability 0 and the invisible 11686
-- Probability 1 (mop: both 1). Tidied to both TDBs, with no visible effect: the three spawns carry creature.modelid 11686,
-- which ObjectMgr::ChooseDisplayId (ObjectMgr.cpp:1513-1518) uses before any template model, so they were always
-- invisible. They also wandered 3 yd, unseen.
-- The lugs and crates stay static, as in both TDBs (Breaking the Chain's kill credit is by entry and works). Building
-- the moving chain would be ours throughout (seat layout, timers, summon AI): not done; listed as a lead.
-- No formation, event, pool, SmartAI or linked respawn uses these guids; the 16 paths are used by no other spawn.

DELETE FROM `waypoint_data` WHERE `id` IN (252743,252748,252754,252758,252764,252768,252772,252777,252791,252796,252809,252814,252818,252823,252826,252830);
DELETE FROM `creature_addon` WHERE `guid` IN (252743,252748,252754,252758,252764,252768,252772,252777,252791,252796,252809,252814,252818,252823,252826,252830,
  252835);
DELETE FROM `creature` WHERE `id` IN (39244,39318,39319) AND `guid` IN (252743,252748,252754,252758,252764,252768,252772,252777,252791,252796,252809,252814,252818,252823,252826,252830,
  252835);

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 39255 AND `guid` IN (251643,251644,251645);
UPDATE `creature_template_model` SET `Probability` = 0 WHERE `CreatureID` = 39255 AND `CreatureDisplayID` = 22903;
UPDATE `creature_template_model` SET `Probability` = 1 WHERE `CreatureID` = 39255 AND `CreatureDisplayID` = 11686;
