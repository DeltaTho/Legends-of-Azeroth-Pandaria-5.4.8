-- Northern Barrens (zone 17), scope I-K2: the 67 Battlefield: Barrens resource objects (5.3 world event) are kept as a record
-- for a possible progressive server (user, 2026-11-20) and linked to a new, disabled game event.
--
-- Sourced: warcraft.wiki.gg "Battlefield: Barrens": patch-5.3 world event, its quests / quartermasters / many NPCs removed in 5.4.0
--   (patch 5.4.0 notes: the weekly will no longer be available). Window as the retired event 23: start 2013-05-21 (patch 5.3),
--   end 2013-09-10 (patch 5.4.0). Neither TDB spawns these objects.
-- Ours: event id 121 (first free id), occurence 1440 / length 1440 (length must be > 0 or GameEventMgr rejects the event as
--   "isn't a world event and has length = 0"; end_time is in the past so it is never active).
--   Re-enabling: give event 121 a current start/end window or `.event start 121`.
-- Effect (ObjectMgr::LoadGameobjects reads gameEvent through a LEFT JOIN on game_event_gameobject): a gameobject with such a row has
--   gameEvent != 0, so it is NOT added to the grid at load (only `gameEvent == 0 && PoolId == 0` is) and spawns only while its
--   event is active. The event is inactive, so Meat Racks, Stone Crates, Oil Drums and the Bonfire stop standing in the world.
-- Record of the rows: research\northern-barrens\battlefield-barrens\ (README.md, mop_world INSERTs).
DELETE FROM `game_event_gameobject` WHERE `eventEntry`=121 OR `guid`=540760 OR `guid` BETWEEN 540778 AND 540843;
DELETE FROM `game_event` WHERE `eventEntry`=121;
INSERT INTO `game_event` (`eventEntry`,`start_time`,`end_time`,`occurence`,`length`,`holiday`,`holidayStage`,`description`,`world_event`,`ScriptName`,`announce`,`world_state`) VALUES
(121,'2013-05-21 00:00:00','2013-09-10 00:00:00',1440,1440,0,0,'Battlefield: Barrens (patch 5.3)',0,'',2,0);
INSERT INTO `game_event_gameobject` (`eventEntry`,`guid`)
SELECT 121,`guid` FROM `gameobject` WHERE `zoneId`=17 AND `id` IN (220179,220353,220357,220359) AND (`guid`=540760 OR `guid` BETWEEN 540778 AND 540843);
