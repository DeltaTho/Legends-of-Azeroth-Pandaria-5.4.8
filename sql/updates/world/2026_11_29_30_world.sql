-- Northern Barrens, 13628 Got Wood?: Kadrak's reins and the ride on Brutusk to the Warsong Labor Camp (dossier A, event brief
-- E1; plan.md S3-1 / S3-2; A-13628-1). Script: zone_northern_barrens_morshan.cpp (npc_nb_kadrak, npc_nb_brutusk_got_wood,
-- spell_nb_ride_brutusk).
--
-- Sourced: Kadrak's option "Truun is in need of lumber..." (BT 33514) and his reply (BT 33515), item 45051 Kadrak's Reins
--   (wiki "Speaking with Kadrak", comments 2011-05-18 / 2014-02-21); the click on Brutusk carries the player to the camp
--   (comments 2010-07-09 / 2013-07-13): Ride Brutusk 62885 (summons 33386 at its spell_target_position and makes the clicker
--   cast 62896) and the credit 62890 Ride Brutusk Kill Credit, both 5.4.8 DBC; the ambush lines BT 33537 33521 33522.
-- Ours: the click conditions (quest 13628 in the log, incomplete, and the reins in the bags), the private-copy ambushers
--   (34101) who speak when none of mop's static Ashenvale Ambushers 33394 (in neither TDB) is free, the option's condition
--   (no reins in the bags; reins left in the bank are pointed out by the script).
-- Removed: 33374's spellclick 46990 "Cosmetic - Talk - Test" and its SmartAI row (credit on the click). 33374 gets a small
--   script instead (npc_nb_brutusk_parked): a mounted clicker, refused by the spell, is dismounted and seated (ours, dossier
--   A: "dismount ... before seating").
-- Ours (A-13628-1): the parked Brutusk 238414 stands still instead of wandering 3 yd (neither TDB spawns 33374; the MoP
--   Classic page shows him at his post).

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry`=33374;
INSERT INTO `npc_spellclick_spells` (`npc_entry`,`spell_id`,`cast_flags`,`user_type`) VALUES
(33374,62885,1,0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceGroup`=33374;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,33374,62885,0,0,9,0,13628,0,0,0,0,0,'','Brutusk - Ride Brutusk only with Got Wood? in the log'),
(18,33374,62885,0,0,2,0,45051,1,0,0,0,0,'','Brutusk - Ride Brutusk only with Kadrak''s Reins');

DELETE FROM `smart_scripts` WHERE `entryorguid`=33374 AND `source_type`=0;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_nb_brutusk_parked' WHERE `entry`=33374;
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid`=238414 AND `id`=33374;

UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_nb_brutusk_got_wood' WHERE `entry`=33386;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_nb_morshan_actor' WHERE `entry`=34101;
DELETE FROM `spell_script_names` WHERE `spell_id`=62896;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(62896,'spell_nb_ride_brutusk');

-- Kadrak: script, the reins option (options 1-3 of menu 10411 are in 2026_11_29_32)
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_nb_kadrak' WHERE `entry`=8582;
DELETE FROM `gossip_menu_option` WHERE `MenuID`=10411 AND `OptionID`=0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(10411,0,0,'Truun is in need of lumber from the Warsong Camp. I need to use Brutusk to haul it.',33514,1,1,0,0,0,0,'',0,0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=10411 AND `SourceEntry`=0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,10411,0,0,0,9,0,13628,0,0,0,0,0,'','Kadrak - reins option with Got Wood? in the log'),
(15,10411,0,0,0,2,0,45051,1,0,1,0,0,'','Kadrak - reins option only without Kadrak''s Reins in the bags');

DELETE FROM `creature_text` WHERE `CreatureID`=8582 AND `GroupID` IN (0);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(8582,0,0,'Very well, $c. But be careful, Brutusk can be very... spirited.',12,0,100,0,0,0,0,33515,5,'Kadrak - gives the reins');

DELETE FROM `creature_text` WHERE `CreatureID`=33386 AND `GroupID` IN (0);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(33386,0,0,'Brutusk roars as he leaps into the ambush!',16,0,100,0,0,0,0,33537,5,'Brutusk - leaps into the ambush');

DELETE FROM `creature_text` WHERE `CreatureID`=33394 AND `GroupID` IN (0,1);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(33394,0,0,'Kill the Kodo and capture the rider!',14,0,100,0,0,0,0,33521,5,'Ashenvale Ambusher - Got Wood? ambush'),
(33394,1,0,'Do not let it pass!',14,0,100,0,0,0,0,33522,5,'Ashenvale Ambusher - Got Wood? ambush');

DELETE FROM `creature_text` WHERE `CreatureID`=34101 AND `GroupID` IN (0,1);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(34101,0,0,'Kill the Kodo and capture the rider!',14,0,100,0,0,0,0,33521,5,'Ashenvale Skirmisher (scene) - Got Wood? ambush (fallback speaker)'),
(34101,1,0,'Do not let it pass!',14,0,100,0,0,0,0,33522,5,'Ashenvale Skirmisher (scene) - Got Wood? ambush (fallback speaker)');
