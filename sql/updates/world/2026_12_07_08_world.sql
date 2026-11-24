-- Durotar: the warring elementals of Ignoring the Warnings (25206) really fight, held at 80 %.
--
-- The user, play-testing 2026-11-23: the Furious Earthguards 39595 and Teeming Waterguards 39596 "are not fighting each other -
-- they should be in an eternal battle and locked at relatively high health". Quest text: they "war against one another".
-- Both TDBs only stand them in facing pairs with emote state 35 (ONESHOT_ATTACK_UNARMED, a fake fight); 2026_11_27_72 put that
-- back. Nothing makes them engage: both use FactionTemplate 91 (faction 74), friendly to itself (hostile.py 91 91), and a
-- static NPC never starts a fight on its own (line-of-sight aggro only runs on movement).
-- Ours (mechanics, not sniffed), as the New Kargath battle (2026_11_20_37) and the Bloodmire (2026_11_23_21):
--  - Teeming Waterguard FactionTemplate 91 -> 1681 (faction 957, used by Restless Spirit of Earth 17179): faction 74 is on its
--    enemy list, so it is hostile to the Earthguards (1681 -> 91 hostile, 91 -> 1681 neutral); hostile to every player as 91
--    (hostile mask 1); friendly to its own kind. The only other faction-74 NPCs in Durotar are the Foaming Sea Elementals
--    39272 on the south coast (x -57..348), 550+ yd from the elementals (x 896..1253, y -4121..-3847).
--  - Both entries, out of combat every 3 s: attack the closest creature of the other entry within 8 yd (pairs stand 3-4 yd apart).
--    No guid scripts exist on any of the 56 spawns, so the entry rows run.
--  - creature_sparring_template 80 % on both: creature-dealt damage stops at 80 % and can never kill (Unit::DealDamage); damage
--    of players, their pets and companions is not capped, so a player still makes the kill and keeps more than half of the
--    damage (Creature::IsDamageEnoughForLootingAndReward).
-- The sniffed emote 35 stays (the punching loop; it matches the melee and keeps a pose while a partner respawns).
-- What the player sees: Earthguards and Waterguards trade blows and spells in pairs, never dropping below ~80 %; a player can
-- pull and kill either as before (still 12 for the quest).

UPDATE `creature_template` SET `faction`=1681 WHERE `entry`=39596 AND `faction`=91;

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (39595,39596) AND `source_type`=0 AND `id`=1;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39595,0,1,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,39596,8,0,0,0,0,0,0,'Furious Earthguard - Out of Combat - Attack closest Teeming Waterguard (warring pair)'),
(39596,0,1,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,39595,8,0,0,0,0,0,0,'Teeming Waterguard - Out of Combat - Attack closest Furious Earthguard (warring pair)');

DELETE FROM `creature_sparring_template` WHERE `creature_id` IN (39595,39596);
INSERT INTO `creature_sparring_template` (`creature_id`,`health_limit_pct`,`comment`) VALUES
(39595,80,'Furious Earthguard - warring elementals, Durotar'),
(39596,80,'Teeming Waterguard - warring elementals, Durotar');
