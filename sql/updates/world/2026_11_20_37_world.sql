-- New Kargath: the Grunts fight the Darkflight dragonspawn on the ramp below the town (plan item C-16).
--
-- What the player sees: on the ramp below New Kargath seven Grunts fight seven Darkflight dragonspawn face to face and neither
-- side dies; players and the vikings' companions can still kill either; the Grunts attack players who come near (Alliance
-- players too, without being flagged for PvP).
-- Sourced: comments "watch out for the New Kargath grunts, they're fighting with the Darkflight on the ramp leading up to the
--   Horde town and will attack you, ... but won't make you pvp" (27830 evidence, 2011-05-27 [+2]); "the grunts originally
--   fighting the dragons in front of Gorn are the only ones who will aggro on the dragons trying to invade" (2011-11-02 [+2]);
--   wiki "New Kargath Grunts are fending off the dragonspawn". Both TDBs: 7 of the 12 Grunts stand 3.3-3.7 yd from a Darkflight
--   (TDB guids 288814/288815, 289047, 293713/293735 with 293718, 294775/294779, 294792/294795), facing each other. unit_flags2 of
--   47073 is 2048 in TDB 4.4.2 (mop 33556480 = 2048 + 0x02000000, which is no unit_flags2 bit of this core).
-- Ours (mechanics, not sniffed): factions 83 (Grunt) and 16 (dragonspawn) are neutral to each other both ways (hostile.py
--   --npc 47073 46917 46918), so even a scripted attack is refused (Unit::IsValidAttackTarget, creature-vs-creature case). A first
--   draft flagged the six partners UNIT_FLAG_PVP_ATTACKABLE; the 5.4.8 client then applies PvP rules to them and refuses a
--   player's attack on a quest mob (Their Hunt Continues), so no per-spawn unit_flags are set (fix round 2). Instead the six partner
--   dragonspawn get a guid SmartAI row on RESET (runs at first spawn, after every respawn, after every evade) that sets
--   FactionTemplate 2296 (faction 14, group 8): hostile to the Grunts' template 83 (2296 -> 83 hostile), hostile to Alliance AND
--   Horde players, friendly to the Darkflight's 16 both ways (hostile.py 2296 83 16: it fights the Grunts and nothing of its kin).
--   SmartAI restores the template faction 16 on respawn before RESET runs, and an evade keeps the set faction; the RESET row sets
--   it again either way. Side effect: with 2296 the six are hostile to every Horde NPC (group 4), so New Kargath's guards near the
--   ramp may join the fight too. Their entry rows (Enrage / Flameblade, Shadow Bolt / Curse of Agony) are copied into the guid
--   scripts, because a guid script replaces the entry script. Guid SmartAI on the seven Grunts (out of combat every 3 s ATTACK_START
--   on the closest creature of the partner's entry within 8 yd) plus copies of the entry's Sunder Armor and Blood Fury rows, for
--   the same reason. creature_sparring_template 85 % on 47073 / 46917 / 46918: damage dealt by creatures stops at 85 % (damage from
--   players, their pets and companions is not capped: Unit::DealDamage skips attackers owned by a player), so the fight is endless.
--   Two Grunts move onto their TDB spots (162428 to TDB 293713, 5.7 yd; 162209 to TDB 294792, 4.7 yd) so that each stands 3-4 yd
--   from its partner: positions ours within 3-4 yd of a sniffed spawn on open ground (the ramp, z 242 and 273). The comments'
--   "very quick respawn" is not built (the Grunts keep 300 s).
-- The seven pairs (grunt -> the dragonspawn it faces in mop, within 3.7 yd, each facing the other; checked from the spawn positions
--   and orientations in mop_world after files 33 and 35; entry the script targets in brackets):
--   162424 -> 162565 (46917), 162554 -> 162439 (46918), 162555 -> 162567 (46917), 162428 -> 162828 (46918),
--   162211 -> 162867 (46918), 162209 -> 162285 (46917), 162210 -> 162285 (46917; two grunts share it, as TDB 294792 and 294795
--   share 294803). Six distinct dragonspawn are the partners (faction row): 162565 162439 162567 162828 162867 162285. 162555 faces 162567 in mop (the
--   spawn faces 1.47 rad, 162567 lies at that bearing); the first draft sent it and 162209 after 46918 spawns behind them
--   (review round 1). 162305, a former partner, is only kept still.
-- Sparring applies to the whole entries (creature_sparring_template has no per-spawn form; the faction row is per spawn): every 46917 / 46918 /
--   47073 in the zone (32 / 34 / 15 spawns before file 33) stops creature-dealt damage at 85 %: a town guard fighting a dragonspawn a
--   player led into New Kargath cannot kill it. Damage of players, their pets and companions is not capped.
-- Needs 2026_11_20_33 (doubles removed: partners 162565 162439 162567 162828 162867 162285 stay, the stacked copies are gone)
--   and 2026_11_20_35 (the Grunts stand still).
-- What the player sees is unchanged: players can attack every one of these mobs (no PvP flag anywhere).
-- Risk: a fighter that chases its partner after a player pulls the dragonspawn goes home and re-engages after the respawn.

UPDATE `creature` SET `position_x`=-6757.46, `position_y`=-2540.69, `position_z`=241.964, `orientation`=2.21657 WHERE `guid`=162428 AND `id`=47073; -- TDB 293713
UPDATE `creature` SET `position_x`=-6775.2, `position_y`=-2441.21, `position_z`=272.833, `orientation`=2.16179 WHERE `guid`=162209 AND `id`=47073; -- TDB 294792
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid` IN (162565,162439,162828,162867,162567,162285) AND `id` IN (46917,46918);
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid`=162305 AND `id`=46918;
UPDATE `creature_template` SET `unit_flags2`=2048 WHERE `entry`=47073 AND `unit_flags2`=33556480; -- TDB 4.4.2; 0x02000000 is no unit_flags2 bit of this core
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-162424,-162554,-162555,-162428,-162211,-162209,-162210);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-162424,0,0,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,46917,8,0,0,0,0,0,0,'New Kargath Grunt - Out of Combat - Attack closest 46917 (sniffed battle pair)'),
(-162424,0,1,0,0,0,100,0,5000,8000,12000,15000,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'New Kargath Grunt - In Combat - Cast Sunder Armor'),
(-162424,0,2,0,2,0,100,1,0,40,0,0,0,11,82836,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'New Kargath Grunt - At 40% HP - Cast Blood Fury'),
(-162554,0,0,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,46918,8,0,0,0,0,0,0,'New Kargath Grunt - Out of Combat - Attack closest 46918 (sniffed battle pair)'),
(-162554,0,1,0,0,0,100,0,5000,8000,12000,15000,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'New Kargath Grunt - In Combat - Cast Sunder Armor'),
(-162554,0,2,0,2,0,100,1,0,40,0,0,0,11,82836,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'New Kargath Grunt - At 40% HP - Cast Blood Fury'),
(-162555,0,0,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,46917,8,0,0,0,0,0,0,'New Kargath Grunt - Out of Combat - Attack closest 46917 (sniffed battle pair)'),
(-162555,0,1,0,0,0,100,0,5000,8000,12000,15000,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'New Kargath Grunt - In Combat - Cast Sunder Armor'),
(-162555,0,2,0,2,0,100,1,0,40,0,0,0,11,82836,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'New Kargath Grunt - At 40% HP - Cast Blood Fury'),
(-162428,0,0,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,46918,8,0,0,0,0,0,0,'New Kargath Grunt - Out of Combat - Attack closest 46918 (sniffed battle pair)'),
(-162428,0,1,0,0,0,100,0,5000,8000,12000,15000,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'New Kargath Grunt - In Combat - Cast Sunder Armor'),
(-162428,0,2,0,2,0,100,1,0,40,0,0,0,11,82836,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'New Kargath Grunt - At 40% HP - Cast Blood Fury'),
(-162211,0,0,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,46918,8,0,0,0,0,0,0,'New Kargath Grunt - Out of Combat - Attack closest 46918 (sniffed battle pair)'),
(-162211,0,1,0,0,0,100,0,5000,8000,12000,15000,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'New Kargath Grunt - In Combat - Cast Sunder Armor'),
(-162211,0,2,0,2,0,100,1,0,40,0,0,0,11,82836,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'New Kargath Grunt - At 40% HP - Cast Blood Fury'),
(-162209,0,0,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,46917,8,0,0,0,0,0,0,'New Kargath Grunt - Out of Combat - Attack closest 46917 (sniffed battle pair)'),
(-162209,0,1,0,0,0,100,0,5000,8000,12000,15000,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'New Kargath Grunt - In Combat - Cast Sunder Armor'),
(-162209,0,2,0,2,0,100,1,0,40,0,0,0,11,82836,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'New Kargath Grunt - At 40% HP - Cast Blood Fury'),
(-162210,0,0,0,1,0,100,0,1000,1000,3000,3000,0,49,0,0,0,0,0,0,19,46917,8,0,0,0,0,0,0,'New Kargath Grunt - Out of Combat - Attack closest 46917 (sniffed battle pair)'),
(-162210,0,1,0,0,0,100,0,5000,8000,12000,15000,0,11,11971,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'New Kargath Grunt - In Combat - Cast Sunder Armor'),
(-162210,0,2,0,2,0,100,1,0,40,0,0,0,11,82836,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'New Kargath Grunt - At 40% HP - Cast Blood Fury');
DELETE FROM `creature_sparring_template` WHERE `creature_id` IN (47073,46917,46918);
INSERT INTO `creature_sparring_template` (`creature_id`,`health_limit_pct`,`comment`) VALUES
(47073,85,'New Kargath Grunt - endless fight with the Darkflight on the New Kargath ramp'),
(46917,85,'Darkflight Flameblade - endless fight with the New Kargath Grunts'),
(46918,85,'Darkflight Shadowspeaker - endless fight with the New Kargath Grunts');

-- The six partners: copy of the entry script (a guid script replaces it) plus the faction row on RESET.
DELETE FROM `smart_scripts` WHERE `source_type`=0 AND `entryorguid` IN (-162565,-162439,-162567,-162828,-162867,-162285);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT -c.`guid`,0,e.`id`,e.`link`,e.`event_type`,e.`event_phase_mask`,e.`event_chance`,e.`event_flags`,e.`event_param1`,e.`event_param2`,e.`event_param3`,e.`event_param4`,e.`event_param5`,e.`action_type`,e.`action_param1`,e.`action_param2`,e.`action_param3`,e.`action_param4`,e.`action_param5`,e.`action_param6`,e.`target_type`,e.`target_param1`,e.`target_param2`,e.`target_param3`,e.`target_param4`,e.`target_x`,e.`target_y`,e.`target_z`,e.`target_o`,e.`comment`
FROM `creature` c JOIN `smart_scripts` e ON e.`entryorguid`=c.`id` AND e.`source_type`=0
WHERE c.`guid` IN (162565,162439,162567,162828,162867,162285) AND c.`id` IN (46917,46918);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-162565,0,10,0,25,0,100,0,0,0,0,0,0,2,2296,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkflight Flameblade - On Reset - Set faction 2296 (fights the New Kargath Grunt)'),
(-162439,0,10,0,25,0,100,0,0,0,0,0,0,2,2296,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkflight Shadowspeaker - On Reset - Set faction 2296 (fights the New Kargath Grunt)'),
(-162567,0,10,0,25,0,100,0,0,0,0,0,0,2,2296,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkflight Flameblade - On Reset - Set faction 2296 (fights the New Kargath Grunt)'),
(-162828,0,10,0,25,0,100,0,0,0,0,0,0,2,2296,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkflight Shadowspeaker - On Reset - Set faction 2296 (fights the New Kargath Grunt)'),
(-162867,0,10,0,25,0,100,0,0,0,0,0,0,2,2296,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkflight Shadowspeaker - On Reset - Set faction 2296 (fights the New Kargath Grunt)'),
(-162285,0,10,0,25,0,100,0,0,0,0,0,0,2,2296,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Darkflight Flameblade - On Reset - Set faction 2296 (fights the New Kargath Grunt)');
