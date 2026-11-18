-- Blasted Lands, The Altar of Storms (25688 Horde / 26162 Alliance): the Blood Altar 203196 can be used again and starts the
-- resurrection ritual (zone_blasted_lands_bloodstone.cpp: go_blasted_lands_blood_altar, npc_blasted_lands_loramus_body).
--
-- Sourced: gameobject_template_addon.flags 0 as both TDBs (mop 1 = GO_FLAG_IN_USE, "disables interaction": nobody could start
-- the ritual and the chain stopped here); the texts of Loramus' Body 41193 (broadcast 41144, 41284, 41147, 41285, 41280, 41281,
-- 41283, 41141; the wiki 26162 notes and the comments quoted in the script); neither TDB spawns 41193 or 41191 anywhere: mop's
-- body hovering over the altar (307815) and five Obstructors on the five summon spots (307816-307820, two with paths) are sniff
-- copies of the event's summons and go.
-- Ours: the emotes reach the Altar of Storms area (TextRange 1) rather than 40 yd, so players round the foot of the spine see
-- them; the yells keep the normal yell range.
-- Core: flags_extra 0x200 (NO_MOVE_FLAGS_UPDATE) lets the script hold the body's hover (sniffed AnimTier 3) with gravity off.
UPDATE `gameobject_template_addon` SET `flags` = 0 WHERE `entry` = 203196;
UPDATE `gameobject_template` SET `AIName` = '', `ScriptName` = 'go_blasted_lands_blood_altar' WHERE `entry` = 203196;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_blasted_lands_loramus_body', `flags_extra` = `flags_extra` | 0x200 WHERE `entry` = 41193;

-- The Obstructors' Disrupt Ritual must not start combat with the body at its first hit (Spell::DoAllEffectOnTarget ->
-- Unit::CombatStart); the ticks are kept out of combat by the body's script (combat disallowed). 77129 is cast only by 41191.
DELETE FROM `spell_custom_attribute` WHERE `spell` = 77129 AND `attribute` = 'SPELL_ATTR0_CU_DONT_SET_IN_COMBAT_STATE';
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(77129,'SPELL_ATTR0_CU_DONT_SET_IN_COMBAT_STATE','Disrupt Ritual - the Obstructors stay out of combat with Loramus'' Body');

DELETE FROM `creature_addon` WHERE `guid` IN (307815,307816,307817,307818,307819,307820);
DELETE FROM `creature` WHERE `guid` IN (307815,307816,307817,307818,307819,307820) AND `id` IN (41193,41191);
DELETE FROM `waypoint_data` WHERE `id` IN (307819,307820);

DELETE FROM `creature_text` WHERE `CreatureID` = 41193;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(41193,0,0,'Protect %s until the ritual completes!',41,0,100,0,0,0,0,41144,1,'Loramus'' Body - ritual start'),
(41193,1,0,'Holy moley!',14,8,100,0,0,0,0,41284,0,'Loramus'' Body - ritual start (Demonic)'),
(41193,2,0,'%s is under attack!  Protect him!',41,0,100,0,0,0,0,41147,1,'Loramus'' Body - first damage'),
(41193,3,0,'This is horrible!',14,8,100,0,0,0,0,41285,0,'Loramus'' Body - after the first damage (Demonic)'),
(41193,4,0,'Grol!!',14,0,100,0,0,0,0,41280,0,'Loramus'' Body - ritual success 1'),
(41193,5,0,'You, what have you done?',14,0,100,0,0,0,0,41281,0,'Loramus'' Body - ritual success 2'),
(41193,6,0,'I see... this is the path I must take.  Meet up with me back in the cave, heroes.',14,0,100,0,0,0,0,41283,0,'Loramus'' Body - ritual success 3'),
(41193,7,0,'The resurrection ritual has failed!',41,0,100,0,0,0,0,41141,1,'Loramus'' Body - died');
