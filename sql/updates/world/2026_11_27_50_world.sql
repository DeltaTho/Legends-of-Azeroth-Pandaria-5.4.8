-- Durotar, Lazy Peons 25134 (plan section 3, CP1; dossier A-valley 25134, findings A-2a, A-2b, A-2c). Ships with the
-- npc_lazy_peon rework in zone_durotar.cpp: a peon sleeps at his spawn, wakes on the Foreman's Blackjack, works at the wood
-- pile, walks back and sleeps again.
--
-- A-2a SOURCED (both TDBs, 4.4.2 and 12.1.0): 20 Lazy Peons in the Valley, all idle (MovementType 0). mop has 34: the 20 of
-- the 25xxxx block (each 0.0-11.7 yd from one TDB spot) plus 14 pre-Cataclysm guids 34707-36202 (respawn 200 s), each the
-- SECOND peon at one of the 20 TDB spots (0.3-12.3 yd from the kept one). Re-checked guid by guid against both TDB boxes
-- (R\tdb-box-442.json, R\tdb-box-1210.json): after the delete every TDB spot keeps exactly one peon (within 11.7 yd) and the 20 kept
-- peons map to 20 distinct spots; at six spots the deleted peon stood a little nearer than the kept 25xxxx (sniff block) one. The 14 have no creature_addon, smart_scripts, formation, pool, game_event, linked_respawn or
-- waypoint_data rows (checked).
DELETE FROM `creature` WHERE `id` = 10556 AND `guid` IN (34707, 34712, 34734, 34738, 35166, 35196, 35520, 35561, 35830, 35916, 35933, 36043, 36086, 36202);

-- A-2b SOURCED (both TDBs): every peon idle. Random movement or a path fights the script's walks and the sleep root. Two
-- spawns had a 5-6 point path (251480, 251826; no other creature_addon or creature_template_addon uses those path ids, checked).
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 10556;
UPDATE `creature_addon` SET `path_id` = 0 WHERE `guid` IN (251480, 251826);
DELETE FROM `waypoint_data` WHERE `id` IN (251480, 251826);

-- A-2c SOURCED (both TDBs creature_text 10556 group 0 ids 0, 2, 3, 4, Sound 7514 B_PeonBackToWork, Orcish; broadcast_text
-- 5774, 40937, 40938, 40936; wiki and Wowhead quote the lines): mop had only id 0, without the sound.
DELETE FROM `creature_text` WHERE `CreatureID` = 10556 AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(10556,0,0,'Ow!  OK, I''ll get back to work, $n!',12,1,100,0,0,7514,0,5774,0,'Lazy Peon to Player'),
(10556,0,2,'OK boss, I get back to tree-hitting.',12,1,100,0,0,7514,0,40937,0,'Lazy Peon to Player'),
(10556,0,3,'Just was resting eyes!  Back to work now!',12,1,100,0,0,7514,0,40938,0,'Lazy Peon to Player'),
(10556,0,4,'Sleepy... so sleepy...',12,1,100,0,0,7514,0,40936,0,'Lazy Peon to Player');
