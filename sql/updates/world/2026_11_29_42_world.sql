-- Northern Barrens, Love it or Limpet (14038): the Limpet Mine counts down and explodes at the Theramore ship's hull.
-- Sourced: Plant Limpet Mine 66165 (focus 1616 "Thinnest Part of the Hull" 195202, SEND_EVENT 21873, KILL_CREDIT2 34764 on the
-- caster), NPC 34767 "Limpet Mine" subname "Swim Away!" (neither TDB spawns it: mop's static 265910 floating at the hull is a
-- sniff copy of the summon), the countdown "Limpet Mine Planted! Detonation in: ...5... ...4... ...3... ...2... ...1..." (wiki
-- Notes; BT 35042-35047), 66168 Explosion (SCHOOL_DAMAGE 200 at 25 yd; comments 2013-05-10 [+10], 2010-12-16 [+9] "swim away",
-- 2011-07-18 [+6] "the explosion is ridiculously small"), unit_flags 768 on 34767 as both TDBs.
-- Ours: the mine is summoned at the static copy's sniffed spot (not at the player), 1 s per countdown step, a 9 s
-- TIMED_OR_DEAD_DESPAWN backstop, the countdown as boss emotes (the wiki shows them so) seen by the planter alone; faction 14
-- and passive on summon, a precaution only: 66168's damage effect is TARGET_UNIT_DEST_AREA_ENTRY (A 18 / B 8) with no
-- conditions row, which the target check takes as any unit (Spell.cpp:9414), and an instant spell is not evaded on a friendly
-- target (Spell.cpp:3058), so the blast hits every unit within 25 yd - the planter if he has not swum off - with the sniffed
-- 2028 as well; the 768 flags keep anything from attacking the mine and it starts no fight. The credit stays on planting (66165 eff1 KILL_CREDIT2 on the caster, 5.4.8 DBC).
-- Drafted by scope F (F-14038-1).
DELETE FROM `creature` WHERE `guid`=265910 AND `id`=34767;
DELETE FROM `creature_addon` WHERE `guid`=265910;
DELETE FROM `event_scripts` WHERE `id`=21873;
INSERT INTO `event_scripts` (`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`) VALUES
(21873,0,10,34767,9000,0,-1457.18,-3970.81,-4.50941,0);
UPDATE `creature_template` SET `AIName`='SmartAI',`unit_flags`=`unit_flags`|768 WHERE `entry`=34767;
DELETE FROM `smart_scripts` WHERE `entryorguid`=34767 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(34767,0,0,8,54,0,100,0,0,0,0,0,0,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Limpet Mine - Just summoned - Faction 14 (so the blast hits the units round it)'),
(34767,0,8,9,61,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Limpet Mine - Linked - Passive'),
(34767,0,9,0,61,0,100,0,0,0,0,0,0,1,0,1000,0,0,0,0,23,0,0,0,0,0,0,0,0,'Limpet Mine - Linked - Talk 0 (Planted! Detonation in:) to summoner'),
(34767,0,1,0,52,0,100,0,0,34767,0,0,0,1,1,1000,0,0,0,0,23,0,0,0,0,0,0,0,0,'Limpet Mine - Text 0 over - Talk 1 (...5...)'),
(34767,0,2,0,52,0,100,0,1,34767,0,0,0,1,2,1000,0,0,0,0,23,0,0,0,0,0,0,0,0,'Limpet Mine - Text 1 over - Talk 2 (...4...)'),
(34767,0,3,0,52,0,100,0,2,34767,0,0,0,1,3,1000,0,0,0,0,23,0,0,0,0,0,0,0,0,'Limpet Mine - Text 2 over - Talk 3 (...3...)'),
(34767,0,4,0,52,0,100,0,3,34767,0,0,0,1,4,1000,0,0,0,0,23,0,0,0,0,0,0,0,0,'Limpet Mine - Text 3 over - Talk 4 (...2...)'),
(34767,0,5,0,52,0,100,0,4,34767,0,0,0,1,5,1000,0,0,0,0,23,0,0,0,0,0,0,0,0,'Limpet Mine - Text 4 over - Talk 5 (...1...)'),
(34767,0,6,7,52,0,100,0,5,34767,0,0,0,11,66168,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Limpet Mine - Text 5 over - Cast Explosion'),
(34767,0,7,0,61,0,100,0,0,0,0,0,0,41,1000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Limpet Mine - Linked - Despawn');
DELETE FROM `creature_text` WHERE `CreatureID`=34767;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34767,0,0,'Limpet Mine Planted! Detonation in:',41,0,100,0,0,0,0,35042,5,'Limpet Mine - boss emote to the planter'),
(34767,1,0,'...5...',41,0,100,0,0,0,0,35043,5,'Limpet Mine - boss emote to the planter'),
(34767,2,0,'...4...',41,0,100,0,0,0,0,35044,5,'Limpet Mine - boss emote to the planter'),
(34767,3,0,'...3...',41,0,100,0,0,0,0,35045,5,'Limpet Mine - boss emote to the planter'),
(34767,4,0,'...2...',41,0,100,0,0,0,0,35046,5,'Limpet Mine - boss emote to the planter'),
(34767,5,0,'...1...',41,0,100,0,0,0,0,35047,5,'Limpet Mine - boss emote to the planter');
