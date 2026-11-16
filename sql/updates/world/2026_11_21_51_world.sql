-- Searing Gorge, Sweet, Horrible Freedom 28055 (plan E-5; dossier cauldron-finale 28055 rows 1-8, F6).
--
-- The Slave Workers' "Come on, let's get out of here!" (menu 12271 option 0, BroadcastText 47635) never showed: its
-- OptionNpcflag was 0, and Player::PrepareGossipMenu skips an option whose npcflag the creature lacks (the dossier read it as
-- "shown, does nothing"). It gets npcflag 1 (gossip), and the slave answers it:
-- - most thank you, count for the quest and run off (BroadcastText 47639-47641: "I knew the Thorium Brotherhood would come
--   through!" / "Oh, thank you!  Thank you!" / "It's about time!  I'm sick of being a slave!"); a fleeing slave can still be
--   killed for a second credit (comments 2010-11-26 [+52], 2011-11-01 [+8]);
-- - some refuse with one of 47636-47638 ("Never!  I love working for the Dark Iron!" ...) and attack you; kill them for the
--   credit (comments 2010-11-26 [+35], 2011-11-29 [+16], 2012-07-11 [+6]).
-- Sourced: the option, the six lines, flee / fight ("run off", wiki "Flee"), credit for freeing and for killing. Ours: 3 in 4 flee (from "most")
-- and 1 in 4 refuse, the emote state cleared (34 slaves mine, spawn addon emote 233; an evade or respawn reloads it), the run (15 yd straight away from the freer: face him, then MOVE_OFFSET 15 yd backwards, with path finding)
-- and the despawn about 6 s after the thanks, the Dark Iron faction 54 of a refuser, the credit to the freer
-- only (a kill gives the normal group kill credit), the restore on evade and respawn. The option is unconditioned (as both TDBs).
-- An evade does not restore a faction set by SmartAI: rows 3/4 do; a respawn starts from the template (faction 190, npcflag 1)
-- and row 5 sets the react state back.

UPDATE `gossip_menu_option` SET `OptionNpcflag` = 1 WHERE `MenuID` = 12271 AND `OptionID` = 0;

DELETE FROM `creature_text` WHERE `CreatureID` = 5843;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(5843,0,0,'Never!  I love working for the Dark Iron!',12,0,100,0,0,0,47636,0,'Slave Worker - refuses'),
(5843,0,1,'Intruder!  The intruder is trying to save me!',12,0,100,0,0,0,47637,0,'Slave Worker - refuses'),
(5843,0,2,'I''ll never leave!  I wouldn''t know what to do outside!',12,0,100,0,0,0,47638,0,'Slave Worker - refuses'),
(5843,1,0,'I knew the Thorium Brotherhood would come through!',12,0,100,0,0,0,47639,0,'Slave Worker - freed'),
(5843,1,1,'Oh, thank you!  Thank you!',12,0,100,0,0,0,47640,0,'Slave Worker - freed'),
(5843,1,2,'It''s about time!  I''m sick of being a slave!',12,0,100,0,0,0,47641,0,'Slave Worker - freed');

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 5843;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 5843 AND `source_type` = 0 AND `id` BETWEEN 1 AND 5;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (584300,584301) AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5843,0,1,2,62,0,100,0,12271,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Slave Worker - On Gossip Option 0 Selected - Close Gossip'),
(5843,0,2,0,61,0,100,0,0,0,0,0,0,87,584300,584300,584300,584301,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - On Gossip Option 0 Selected - Flee (3 in 4) or Fight (random)'),
(5843,0,3,4,7,0,100,0,0,0,0,0,0,2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - On Evade - Restore Faction'),
(5843,0,4,0,61,0,100,0,0,0,0,0,0,81,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - On Evade - Restore Gossip Flag'),
(5843,0,5,0,11,0,100,0,0,0,0,0,0,8,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - On Respawn - React Aggressive'),
(584300,9,0,0,0,0,100,0,0,0,0,0,0,83,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - Freed - Remove Gossip Flag'),
(584300,9,1,0,0,0,100,0,0,0,0,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - Freed - Stop Working (emote state 0)'),
(584300,9,2,0,0,0,100,0,0,0,0,0,0,1,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Slave Worker - Freed - Say Thanks'),
(584300,9,3,0,0,0,100,0,0,0,0,0,0,33,5843,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Slave Worker - Freed - Quest Credit to Freer'),
(584300,9,4,0,0,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - Freed - React Passive'),
(584300,9,5,0,0,0,100,0,1000,1000,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - Freed - Run'),
(584300,9,6,0,0,0,100,0,0,0,0,0,0,66,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Slave Worker - Freed - Face the Freer'),
(584300,9,7,0,0,0,100,0,200,200,0,0,0,114,0,0,0,0,0,0,1,0,0,0,0,0,-15,0,0,'Slave Worker - Freed - Run Off 15 yd Away from the Freer'),
(584300,9,8,0,0,0,100,0,5000,5000,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - Freed - Despawn'),
(584301,9,0,0,0,0,100,0,0,0,0,0,0,83,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - Refuses - Remove Gossip Flag'),
(584301,9,1,0,0,0,100,0,0,0,0,0,0,17,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - Refuses - Stop Working (emote state 0)'),
(584301,9,2,0,0,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Slave Worker - Refuses - Say Refusal'),
(584301,9,3,0,0,0,100,0,0,0,0,0,0,2,54,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Slave Worker - Refuses - Set Faction Dark Iron'),
(584301,9,4,0,0,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Slave Worker - Refuses - Attack Invoker');
