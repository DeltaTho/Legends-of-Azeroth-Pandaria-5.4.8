-- Camp Cagg / Dustbelch Grotto: each Dustbelcher Chest gives 2-4 silk, and Dustbelcher Shamans heal hurt ogres.
--
-- Survival of the Fattest 27825 / 27879: Dustbelcher Chest 206499 gave one Dustbelcher Silk 62547 per opening (10 needed).
--   Sourced: Wowhead contained-in, 6011 loots: 2 = 27.2 %, 3 = 40.4 %, 4 = 32.4 %; wiki "2 or 4 Dustbelcher Silk each". Both
--   TDBs leave the default 1/1. Respawn and spawns of the grotto objects are section C's.
-- Half-Ton Holdouts 27833 / 27880: Dustbelcher Shaman 2718 never cast its heal. Sourced: both TDBs' SmartAI (Healing Wave
--   11986 on a friend below 50 %, every 18-24 s, 40 yd). Ours: event 14 (lowest-health friend in combat missing more than N hp;
--   event 74 does not fire here with the TDB target, research _core-issues C8) with N = 1150, half of a level 46 Mauler's
--   2,303 hp (class 1 base 1,919 x Health_mod 1.2; the dossier's 950 was a slip). The Shaman's spawntimesecs are section C's.

UPDATE `gameobject_loot_template` SET `mincountOrRef` = 2, `maxcount` = 4 WHERE `entry` = 206499 AND `item` = 62547;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 2718 AND `source_type` = 0 AND `id` = 2;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(2718, 0, 2, 0, 14, 0, 100, 0, 1150, 40, 18000, 24000, 0, 11, 11986, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Dustbelcher Shaman - Friendly missing 1150 health - Cast Healing Wave');
