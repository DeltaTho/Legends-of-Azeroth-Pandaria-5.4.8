-- Repel Boarders! (24934, Alliance; Southern Barrens quest ended on the Blackpool in the Northern Barrens): the Northwatch
-- gryphon from Admiral Aubrey's tower to the Blackpool and back (zone_ratchet.cpp: npc_ratchet_admiral_aubrey,
-- npc_ratchet_captain_fisher, npc_ratchet_northwatch_gryphon, player_ratchet_northwatch_gryphon).
-- Sourced: the quest's log text "Speak to Admiral Aubrey to fly to the Blackpool", the options and lines (BT 38574 "Admiral, can
-- I get a ride to the Blackpool?", 38583 "Mister Blaine? Flag down a gryphon for $n if you please.", 38584 "Aye aye sir!
-- Immediately, sir!", 38581 "Captain, I need a ride back to Northwatch Hold.", 38582 "Godspeed, $c!"; comments 2012-05-13 [+10],
-- 2012-02-08 [+1]); video kEpy1ea727k: a ~35 s flight from the tower top, landing on the ship's deck. The gryphons 38707 / 38709
-- are the summons of 72596 / 72609 (SummonProperties 161, vehicle) and had VehicleId 0, so nothing could ride them.
-- Ours (question 17 default "nearest fitting vehicle"): VehicleId 1255, the Mullan Gryphon Mount's (47225, the same model
-- 17697; seat 8950 usable, no exit at will); the gryphons are summoned by the script at fixed launch spots (72596 / 72609 put
-- them front-left of the caster, on the tower top possibly inside the parapet); the routes; the say ranges. Neither TDB has
-- any gossip, script or text for these NPCs.
UPDATE `creature_template` SET `VehicleId`=1255, `AIName`='', `ScriptName`='npc_ratchet_northwatch_gryphon' WHERE `entry` IN (38707,38709);
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_ratchet_admiral_aubrey' WHERE `entry`=38619;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_ratchet_captain_fisher' WHERE `entry`=38622;
DELETE FROM `creature_text` WHERE `CreatureID` IN (38619,38697,38622) AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(38619,0,0,'Mister Blaine? Flag down a gryphon for $n if you please.',12,0,100,0,0,0,0,38583,0,'Admiral Aubrey - Repel Boarders!, the ride to the Blackpool'),
(38697,0,0,'Aye aye sir! Immediately, sir!',12,0,100,0,0,0,0,38584,0,'Nathan Blaine - Repel Boarders!, the ride to the Blackpool'),
(38622,0,0,'Godspeed, $c!',12,0,100,0,0,0,0,38582,0,'Captain Fisher - the ride back to Northwatch Hold');
