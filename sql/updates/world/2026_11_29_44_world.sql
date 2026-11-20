-- Northern Barrens, Gazlowe's Fortune (14050): Baron Longshore's ambush when the treasure is dug up at the Curious Pirate
-- Landmark 195206 (zone_ratchet.cpp: go_ratchet_curious_pirate_landmark).
-- Sourced: the Baron and one or two Southsea Cutthroats come and attack, the Baron's yell "Hold it, $r! I promised told ye where
-- the treasure is, but never promised ye could keep it!" (BT 35060, emote 5; beta comment [+12], comments 2010-11-30 [+6],
-- 2011-03-08 [+3], 2011-08-06, the wiki), they give up and vanish if you run (2014-07-31 [+1]). Both TDBs' second Baron spawn
-- (guid 302182, 70 yd from the landmark) is the sniffed ambusher and is not ported as a static spawn.
-- Ours: the yell as a normal-range yell (the TDBs have no creature_text group for it); the sitting pose moves from the Baron's
-- template addon to his stockade spawn 265594 (same values), so the ambush copies stand (an evade reloads the template addon).
UPDATE `gameobject_template` SET `AIName`='', `ScriptName`='go_ratchet_curious_pirate_landmark' WHERE `entry`=195206;
DELETE FROM `creature_text` WHERE `CreatureID`=3467 AND `GroupID`=1;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(3467,1,0,'Hold it, $r! I promised told ye where the treasure is, but never promised ye could keep it!',14,0,100,5,0,0,0,35060,0,'Baron Longshore - Gazlowe''s Fortune ambush, to the digger');
DELETE FROM `creature_addon` WHERE `guid`=265594;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(265594,0,0,0,1,0,0,1,0,0,0,0,0,0,NULL);
UPDATE `creature_template_addon` SET `StandState`=0 WHERE `entry`=3467;
