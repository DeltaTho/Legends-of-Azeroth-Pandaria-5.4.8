-- Durotar, Razorwind Canyon and the Dustwind cliffs: remove the doubled Dustwind harpies.
--
-- The user, play-testing 2026-11-23: "The dustwind harpy spawns appear to be doubled up in razorwind canyon."
-- mop had 101 spawns of 3115 Dustwind Harpy (37), 3116 Pillager (25), 3117 Savage (17), 3118 Storm Witch (22); both TDBs
-- (4.4.2 and 12.1.0, identical positions) have 64 (17 / 20 / 11 / 16), one harpy per spot. mop's surplus stands on the
-- same spots as another spawn of the same entry, 0.6-6.1 yd apart (19 of them carry 253xxx guids from a second import),
-- in pairs and five triples. Clustering mop's spawns within 6.5 yd gives 64 clusters (no cluster mixes entries); one
-- spawn of each is kept: a spawn with a waypoint path first (251469, 253541), otherwise the one nearest a TDB spot
-- (same entry preferred). The 37 below go. None has a creature_addon, waypoint path, game event, pool, formation, linked
-- respawn, movement override or guid SmartAI (checked; the deletes cover them anyway). Kept per entry: 21 / 14 / 12 / 17:
-- mop has Dustwind Harpies on some spots where the TDBs have Pillagers; entries are left as they are (ours: not changed).
-- Respawn: 300 s in mop, 120 s in both TDBs. Securing the Lines (835) needs 12 harpies (KillCredit 41007 on all four
-- entries) from the 64; with a third of the spawns gone, the TDBs' 120 s is both sourced and the less grindy value.
-- Ours: the 6.5 yd clustering and which twin is kept.

DELETE FROM `creature_addon` WHERE `guid` IN (251126,251185,251229,251235,251261,251302,251303,251353,251354,251355,251398,251399,
  251400,251422,251426,251427,251429,251433,251436,251443,251448,251449,251453,251454,
  251456,251460,251461,251467,251470,252026,253338,253442,253448,253449,253450,253536,
  253546);
DELETE FROM `game_event_creature` WHERE `guid` IN (251126,251185,251229,251235,251261,251302,251303,251353,251354,251355,251398,251399,
  251400,251422,251426,251427,251429,251433,251436,251443,251448,251449,251453,251454,
  251456,251460,251461,251467,251470,252026,253338,253442,253448,253449,253450,253536,
  253546);
DELETE FROM `pool_creature` WHERE `guid` IN (251126,251185,251229,251235,251261,251302,251303,251353,251354,251355,251398,251399,
  251400,251422,251426,251427,251429,251433,251436,251443,251448,251449,251453,251454,
  251456,251460,251461,251467,251470,252026,253338,253442,253448,253449,253450,253536,
  253546);
DELETE FROM `creature_formations` WHERE `memberGUID` IN (251126,251185,251229,251235,251261,251302,251303,251353,251354,251355,251398,251399,
  251400,251422,251426,251427,251429,251433,251436,251443,251448,251449,251453,251454,
  251456,251460,251461,251467,251470,252026,253338,253442,253448,253449,253450,253536,
  253546);
DELETE FROM `linked_respawn` WHERE `guid` IN (251126,251185,251229,251235,251261,251302,251303,251353,251354,251355,251398,251399,
  251400,251422,251426,251427,251429,251433,251436,251443,251448,251449,251453,251454,
  251456,251460,251461,251467,251470,252026,253338,253442,253448,253449,253450,253536,
  253546);
DELETE FROM `creature` WHERE `id` IN (3115, 3116, 3117, 3118) AND `guid` IN (251126,251185,251229,251235,251261,251302,251303,251353,251354,251355,251398,251399,
  251400,251422,251426,251427,251429,251433,251436,251443,251448,251449,251453,251454,
  251456,251460,251461,251467,251470,252026,253338,253442,253448,253449,253450,253536,
  253546);

UPDATE `creature` SET `spawntimesecs` = 120 WHERE `id` IN (3115, 3116, 3117, 3118) AND `map` = 1;
