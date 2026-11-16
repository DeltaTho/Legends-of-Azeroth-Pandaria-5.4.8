-- Searing Gorge A-4: Dig-Boss Dinwhisker turn-in scene (Jack's line, Image of Archduke Calcinder's four lines).
--
-- SOURCED: wiki 27964 'On complete', creature_text 47301 g0-3 (BT 47690-47693) and 47266 g0 (BT 47710), TDB spell_target_position 88220
-- (z 251.742). OURS: timings of the actionlist (2/6/6/7/5 s), the 88221 cast on summon, TextRange 5 (the personal range: only the summoning player hears the lines).
-- 88220 moves to RewardDisplaySpell; Player::RewardQuest still casts it when RewardSpell is 0 (Player.cpp 16899-16903).
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

-- F-27964-3/4: the turn-in scene.
UPDATE `quest_template` SET `RewardDisplaySpell`=88220, `RewardSpell`=0 WHERE `ID`=27964;
UPDATE `spell_target_position` SET `target_position_z`=251.742 WHERE `id`=88220 AND `effIndex`=0;
UPDATE `creature_text` SET `TextRange`=5 WHERE `CreatureID`=47301;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (47266,47301);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (47266,47301) AND `source_type`=0;
DELETE FROM `smart_scripts` WHERE `entryorguid`=4730100 AND `source_type`=9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47266,0,0,0,20,0,100,0,27964,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Jack Rockleg - On Quest Dig-Boss Dinwhisker Rewarded - Say 0'),
(47301,0,0,1,54,0,100,0,0,0,0,0,0,11,88221,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Image of Archduke Calcinder - Just Summoned - Cast Calcinder Fire Visual'),
(47301,0,1,0,61,0,100,0,0,0,0,0,0,80,4730100,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Image of Archduke Calcinder - Just Summoned - Run Script'),
(4730100,9,0,0,0,0,100,0,2000,2000,0,0,0,1,0,0,1,0,0,0,23,0,0,0,0,0,0,0,0,'Image of Archduke Calcinder - Script - Say 0 to summoner'),
(4730100,9,1,0,0,0,100,0,6000,6000,0,0,0,1,1,0,1,0,0,0,23,0,0,0,0,0,0,0,0,'Image of Archduke Calcinder - Script - Say 1 to summoner'),
(4730100,9,2,0,0,0,100,0,6000,6000,0,0,0,1,2,0,1,0,0,0,23,0,0,0,0,0,0,0,0,'Image of Archduke Calcinder - Script - Say 2 to summoner'),
(4730100,9,3,0,0,0,100,0,7000,7000,0,0,0,1,3,0,1,0,0,0,23,0,0,0,0,0,0,0,0,'Image of Archduke Calcinder - Script - Say 3 to summoner'),
(4730100,9,4,0,0,0,100,0,5000,5000,0,0,0,41,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Image of Archduke Calcinder - Script - Despawn');
