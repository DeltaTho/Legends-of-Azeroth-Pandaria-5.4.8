-- Badlands: guards, party goers and Camp Kosh's ogres stand where both TDBs have them (plan items C-12 and C-13).
--
-- C-12. Both TDBs (4.4.2, 12.1.0) have these spawns idle at their posts; mop has them wander 3 yd (the two Fuselight Bruisers
--   161763 / 161801 stand 4.4 yd apart facing each other in the sniff, as a pair that shuffles about they lose that):
--   Fuselight Bruiser 48075 (all 19 spawns), New Kargath Grunt 47073 (the 12 that remain after 2026_11_20_33; seven of them are
--   the battle line that 2026_11_20_37 sets fighting: that fight is scripted and does not need them to wander), New Kargath
--   Defender 51523 (302625), Dragon's Mouth Sentry 51537 (162596, 162598) and the six goblins of the beach party at
--   Fuselight-by-the-Sea: Kramer 49921 (161744), Kerwin the Destroyer 49922 (161703), Joe Mag 49924 (161747), Johnny Shinster
--   49925 (161605), Zak Callabang 49936 (161702), Jeigh Southie 49944 (161783). Per spawn, never the template. Left wandering:
--   Exploding Sheep 50594, Billy Goat 46393, the Dustbelcher Merchant (hostile mob) and every patrol on a path.
-- C-13 (27774, 27775). Camp Kosh: 31 spawns; 27 stand on a TDB spot (0.0 yd), four (the Instructors 162224 / 162689, 162233
--   and 162675) are 8-20 yd off the TDB's and are left where they are. Eleven stand on a TDB spot
--   with the other entry: mop has Initiates 46694 where the sniff has Trainees 46695 (162227, 162228, 162680) and Trainees where it
--   has Initiates (162048, 162226, 162670, 162673, 162678, 162684, 162917, 162920). Swapping gives the sniff's counts (15 Initiates,
--   10 Trainees; 6 Instructors). It also restores the sniffed facing pair Trainee 162225 + 162227. All 31 are idle in both TDBs
--   and mop has them wander 3 yd, among them the Initiate 162232 whose spawn aura 78677 is Cosmetic - Sleep Zzz Breakable: a
--   sleeping ogre that walked. Quest 27774 counts 9 kills of 46695 (46693 and 46694 give credit 46695), so the swap changes
--   nothing for the quest; 27775's rod drops only from the Instructors, who keep their entry.
--   Respawn: mop's own split is kept by entry (Trainees 60 s, Initiates 300 s; the TDBs have 120 s for all): the swapped spawns
--   would otherwise carry the old entry's time.
--   Not here: the progress text of 27774 (quest_request_items) is item A-2.
-- Sourced: both TDBs (movement, entries, facing). Ours: the respawn split (mop's own values).

-- C-12
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 48075 AND `guid` IN (161653,161657,161722,161725,161726,161728,161729,161761,161762,161763,161764,161767,161770,161800,161801,161804,161805,161831,161833);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 47073 AND `guid` IN (161563,161564,162072,162207,162208,162209,162210,162211,162424,162428,162554,162555);
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` IN (302625,162596,162598,161744,161703,161747,161605,161702,161783) AND `id` IN (51523,51537,49921,49922,49924,49925,49936,49944);

-- C-13
UPDATE `creature` SET `id` = 46695 WHERE `guid` IN (162227,162228,162680) AND `id` = 46694;
UPDATE `creature` SET `id` = 46694 WHERE `guid` IN (162048,162226,162670,162673,162678,162684,162917,162920) AND `id` = 46695;
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` IN (46693,46694,46695) AND `map` = 0 AND `zoneId` = 3;
UPDATE `creature` SET `spawntimesecs` = 60 WHERE `id` = 46695 AND `map` = 0 AND `zoneId` = 3;
UPDATE `creature` SET `spawntimesecs` = 300 WHERE `id` = 46694 AND `map` = 0 AND `zoneId` = 3;
-- Review round 1: the swapped spawns carried the old entry's own modelid (Initiate 11545 / Trainee 10714); the template model of the new entry is used.
UPDATE `creature` SET `modelid` = 0 WHERE `guid` IN (162227,162228,162680,162048,162226,162670,162673,162678,162684,162917,162920) AND `modelid` IN (11545,10714);
