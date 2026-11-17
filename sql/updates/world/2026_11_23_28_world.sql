-- Swamp of Sorrows, the Bloodmire and Stonard: posed battle NPCs stand still, every warlock and mage channels its ritual,
-- every kodo carries its banner, and the Marshtide Mages keep Frost Armor up.
--
-- Sourced: Marshtide Marksmen (46876, emote 214, a firing line north of Stonard), Cowering Peons (46874, emote 431) and
-- Stonard Peons (46486, emote 234, chopping) wandered 3 yd while posed, and so did the Stonard Warlocks and Marshtide Mages
-- (46770, 46775) while channelling over the portal each summons where it spawns (87116). Ritual of Summoning 87114
-- (template aura of the Stonard Warlock 46770 and the Marshtide Mage 46775) and Horde Banner 87093 (template aura of the Stonard Kodo Beast 46748)
-- were lost on seven warlocks / mages and two static kodos whose own creature_addon row holds no aura (a spawn addon
-- replaces the template addon, C47); those rows hold nothing else the template does not give. Frost Armor 79865 is the
-- Marshtide Mage's (ledger ABILITY-UNUSED; Wowhead abilities tab, its Chilled proc).
-- Ours: the out-of-combat Frost Armor timer (1 s after spawn, then every 30 min, only while the aura is missing).

UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `map`=0 AND `id` IN (46876,46874,46486,46770,46775);

DELETE FROM `creature_addon` WHERE `guid` IN (311677,311678,311679,311664,311665,311666,311670,191123,191136);

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=46775;
DELETE FROM `smart_scripts` WHERE `entryorguid`=46775 AND `source_type`=0 AND `id`=3;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(46775,0,3,0,1,0,100,0,1000,1000,1800000,1800000,0,11,79865,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Marshtide Mage - Out of Combat - Cast Frost Armor');
