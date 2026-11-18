-- Blasted Lands, You Are Rakh'likh, Demon (25701 H / 26171 A): the Deathly Usher 8816 takes you (or your group) up to the
-- Rise of the Defiler again.
-- Sourced: the two options and their casts (TDB 4.4.2 and 12.1.0 SmartAI 8816: option 0 -> 12885, option 1 -> 27686), the group
-- spell's script name (TDB spell_script_names 27686), the landing point of 12885 / 13142 (both TDBs), the option wording
-- ("I wish ..." alone, "We wish ..." in a group: wiki 26171 notes).
-- Ours: the quest conditions (the TDB rows serve no quest of ours), CLOSE_GOSSIP before the cast, OptionNpcflag 1 on option 1
-- (with 0 the core never shows it), and the removal of the classic Rune of the Defiler traps (ruling K3: neither TDB has them,
-- no comment mentions them, and the Usher is the way up from now on; the purple glyph 155851 beside the Usher stays).

-- The Usher's old C++ (npc_deathly_usher) showed its own option only for the retired quest 3628 and hid the menu's options
UPDATE `creature_template` SET `ScriptName`='', `AIName`='SmartAI' WHERE `entry`=8816;
UPDATE `gossip_menu_option` SET `OptionNpcflag`=1 WHERE `MenuID`=1541 AND `OptionID`=1;

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=1541;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,
 `ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,1541,0,0,0,47,0,25701,8,0,0,0,0,'','Deathly Usher - I wish to face the Defiler: 25701 incomplete'),
(15,1541,0,0,0,104,0,0,0,0,1,0,0,'','Deathly Usher - I wish to face the Defiler: not in a group'),
(15,1541,0,0,1,47,0,26171,8,0,0,0,0,'','Deathly Usher - I wish to face the Defiler: 26171 incomplete'),
(15,1541,0,0,1,104,0,0,0,0,1,0,0,'','Deathly Usher - I wish to face the Defiler: not in a group'),
(15,1541,1,0,0,47,0,25701,8,0,0,0,0,'','Deathly Usher - We wish to face the Defiler: 25701 incomplete'),
(15,1541,1,0,0,104,0,0,0,0,0,0,0,'','Deathly Usher - We wish to face the Defiler: in a group'),
(15,1541,1,0,1,47,0,26171,8,0,0,0,0,'','Deathly Usher - We wish to face the Defiler: 26171 incomplete'),
(15,1541,1,0,1,104,0,0,0,0,0,0,0,'','Deathly Usher - We wish to face the Defiler: in a group');

DELETE FROM `smart_scripts` WHERE `entryorguid`=8816 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,
 `event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,
 `action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,
 `target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8816,0,0,1,62,0,100,0,1541,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Deathly Usher - On Gossip Option 0 Selected - Close Gossip'),
(8816,0,1,0,61,0,100,0,0,0,0,0,0,11,12885,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Deathly Usher - Linked - Cast Teleport to Razelikh'),
(8816,0,2,3,62,0,100,0,1541,1,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Deathly Usher - On Gossip Option 1 Selected - Close Gossip'),
(8816,0,3,0,61,0,100,0,0,0,0,0,0,11,27686,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Deathly Usher - Linked - Cast Teleport to Razelikh (GROUP)');

DELETE FROM `spell_script_names` WHERE `spell_id`=27686;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (27686,'spell_blasted_lands_teleport_to_razelikh_group');

-- Landing point as both TDBs (mop had it 3 yd off)
UPDATE `spell_target_position` SET `target_map`=0, `target_position_x`=-11235.3, `target_position_y`=-2832.14, `target_position_z`=157.925,
 `target_orientation`=4.71 WHERE `id` IN (12885,13142) AND `effIndex`=0;

-- 13044 Teleport to Ground (the Rune of Return on the ledge north of the summit) set players down at the classic rune circle on the
-- west side, 219 yd from the Usher; comments say it takes you "back to the Deathly Usher" (Cyndy [+15], 705621 [+75]). Ours: the
-- spot, on open ground 6 yd from the Usher's spawn (163108), facing him; map height 10.68
DELETE FROM `spell_target_position` WHERE `id`=13044 AND `effIndex`=0;
INSERT INTO `spell_target_position` (`id`,`effIndex`,`target_map`,`target_position_x`,`target_position_y`,`target_position_z`,`target_orientation`) VALUES
(13044,0,0,-11112.0,-2901.0,10.75,2.47);

-- K3: the classic Rune of the Defiler traps 153204 (spell 12885: anyone stepping on them was sent to the summit) and their focus runes
-- 153203 at the old rune circle round the foot of the Rise
DELETE FROM `gameobject_addon` WHERE `guid` IN (8268,8269,8275,48564,20948,20949,20950,20951);
DELETE FROM `gameobject` WHERE (`guid` IN (8268,8269,8275,48564) AND `id`=153204) OR (`guid` IN (20948,20949,20950,20951) AND `id`=153203);
