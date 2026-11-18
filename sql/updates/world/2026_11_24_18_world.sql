-- Blasted Lands A (_18): posed spawns in the Serpent's Coil, on the Shattershore and among the cultists south of the keep stop
-- sliding, and the Sunveil Excursion's scout and the vulture flying through the camp stand / circle no more (coverage audit
-- C1, C2, C8; same fix class as _15).
--
-- A spawn's pose is its own creature_addon row when it has one, else the template's (Creature::GetCreatureAddon); each guid
-- below was read that way on 2026-11-18. All have MovementType 1 (random, wander 3) unless said.
-- - C1 Serpent's Coil (area 1440), asleep (StandState 3, Sleep Zzz 78677): Shadowsworn Ritualist 6004 164008, 164134, 164224 and
--   Adept 6006 164009, 164023 (template pose, no spawn addon); Thug 6005 164342 (spawn addon). The other 6004-6006 spawns stand
--   upright with no state emote and are left as they are (wanderers and the 9 patrol paths are not posed).
-- - C2 Shattershore (Our Fallen Friends 25708): Drowned Gilnean Settlers 42249 sitting / asleep / kneeling (StandState 1 / 3 / 8,
--   spawn addon): 163908, 163903, 163966, 164242, 164275, 163572; Sailors 42248 at STATE_WORK (template emote 173, no spawn
--   addon): 163568, 163730, 163897, 163950, 164029, 164214, 164232, 164254, 164257. Upright Merchants / Settlers / Sailors are
--   left as they are.
-- - Cultists of Cultists at our Doorstep 25716 in a state emote while wandering: Spellblades 42296 163898, 163937 (STATE_WORK
--   173, template), 163996 (STATE_SPELL_CHANNEL_OMNI 468); Occultists 42297 163975, 164035 (173), 164423 (468), 163726
--   (STATE_EAT 418) (spawn addons).
-- - C8 Sunveil Excursion (area 5083): Sunveil Scout 51541 307976 walks an 8-point path (MovementType 2) where both TDBs have it
--   idle at the same spot (TDB (-12382.8, -3024.0), mop 3.5 yd away); Bonepicker Felfeeder 5983 163736 flies an 11-point path
--   through the camp (S5: mop only), pulling into the guards. Path ids cleared on both.
-- SOURCED: both TDBs have every spawn of these entries idle (tdb-box 4.4.2 / 12.1.0: MovementType 0) and none of these entries
-- has a TDB spawn addon; 26157 wiki notes (the sleeping cultists in the Coil can be skipped).
-- Dispositions without a row (C8): Surwich Warden 51542 x2 (164633, 164641): no TDB spawn, sourced as existing (S5): kept, still
-- random 3 yd (no source either way for a post). The other 71 Felfeeders keep their circling paths (wildlife, outside the hubs;
-- both TDBs idle: layout lead). Surwich / Sunveil wildlife count differences (cat, beetle, adder): left to the layout section.
-- Checked against bl-f's list (R\coders\f-guids.tsv): only 163736 is on it, for its addon aura (kept, other columns untouched);
-- path_id is cleared here by guid and entry, so the two rows do not overlap. Matched by (guid, id): a deleted guid changes nothing.

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0, `currentwaypoint` = 0
  WHERE (`guid`, `id`) IN (
    (164008, 6004), (164134, 6004), (164224, 6004), (164009, 6006), (164023, 6006), (164342, 6005),
    (163908, 42249), (163903, 42249), (163966, 42249), (164242, 42249), (164275, 42249), (163572, 42249),
    (163568, 42248), (163730, 42248), (163897, 42248), (163950, 42248), (164029, 42248), (164214, 42248), (164232, 42248),
    (164254, 42248), (164257, 42248),
    (163898, 42296), (163937, 42296), (163996, 42296), (163975, 42297), (164035, 42297), (164423, 42297), (163726, 42297),
    (307976, 51541), (163736, 5983));
UPDATE `creature_addon` ca JOIN `creature` c ON c.`guid` = ca.`guid` SET ca.`path_id` = 0
  WHERE (c.`guid`, c.`id`) IN ((307976, 51541), (163736, 5983)) AND ca.`path_id` <> 0;
