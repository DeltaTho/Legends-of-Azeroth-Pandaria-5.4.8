-- Northern Barrens (zone 17), scope I-T: templates, as both TDBs. (I-T1, the FLEEING flag, ships in S1.)
-- I-T2 Mor'shan Caravan Kodo 52212: no gossip (menu 7945 is a draenei-board text; both TDBs npcflag 0). Zone 17 only.
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=52212;
-- I-T3 Lost Barrens Kodo 3234 attackable (mop IMMUNE_TO_PC|IMMUNE_TO_NPC; both TDBs 0). It has no TAMEABLE type flag and no pet
--   family, so hunters cannot tame it. Zone 17 only.
UPDATE `creature_template` SET `unit_flags`=`unit_flags`&~0x300 WHERE `entry`=3234;
-- I-T4 Swine 10685 without PACIFIED (both TDBs). CROSS-ZONE template: spawns also in zone 14 (Durotar, 26 spawns), so Durotar's
--   swine lose PACIFIED too.
UPDATE `creature_template` SET `unit_flags`=`unit_flags`&~0x20000 WHERE `entry`=10685;
-- I-T5 Witchwing Ambusher 3279 stealthed (both TDBs: aura 22766 Sneak; their 7939 is not in 5.4.8). Zone 17 only.
UPDATE `creature_template_addon` SET `auras`='22766' WHERE `entry`=3279;
INSERT INTO `creature_template_addon` (`entry`,`auras`) SELECT 3279,'22766' FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `creature_template_addon` WHERE `entry`=3279);
-- I-T6 Southsea Cannoneer 3382 as both TDBs (faction 230, no IMMUNE_TO_PC): attackable pirates on the Dagger. S4 lists them in E-14063.
UPDATE `creature_template` SET `faction`=230, `unit_flags`=`unit_flags`&~0x100 WHERE `entry`=3382;
-- I-T7 Ralton 34509 shouts at the pillagers, as both TDBs (out of combat, first after 0.5-1 s, then every 10 min; texts in mop, group 0).
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=34509 AND `ScriptName`='';
DELETE FROM `smart_scripts` WHERE `entryorguid`=34509 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`target_type`,`comment`) VALUES
(34509,0,0,0,1,0,100,0,500,1000,600000,600000,1,0,1,'Ralton - Out of Combat - Say Line 0');
