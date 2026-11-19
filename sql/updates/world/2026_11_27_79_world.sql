-- Durotar, Spiketooth's camp: Ghislania (25257), Griswold Hanniston (25258), Gaur Icehorn (25259). The three chained gladiators
-- had no challenge option and simply died to the player (respawn 60 s), the kill giving the credit.
-- Sourced: warcraft.wiki.gg (all three quest pages: talk to the gladiator, "I'm here to challenge you in combat.", defeat him or
-- her - "you can't kill her"); broadcast_text 39519 (the option); comment 2012-05-14 [-4] (a copy that "goes down to 1 hp waits
-- for a second or 2 then returns to same spot and resets her hp"); their combat rows (both TDBs, unchanged: Static Burst and
-- Chain Lightning, Taunka Rage at 30 % with its emote, Griswold's aggro line and Flurry of Claws).
-- What the player sees (quest in progress): talk to the gladiator -> the greeting with "I'm here to challenge you in combat." ->
-- the window closes and the gladiator attacks -> at 1 hp (it cannot drop lower) it stops fighting, the objective "X defeated"
-- completes for everyone it was fighting (a pet's damage credits its owner), it stands for 2 s unattackable, then walks back to
-- its spot and its health comes back (a third every 2 s). The challenge option is gone from the defeat until it is home and
-- has spent 6 s there out of combat (health full by then). Without the quest the option is hidden; anyone may still attack, the fight
-- ends the same way. Ghislania's Static Burst (30 yd around her) and Chain Lightning hit players near her who are not fighting
-- her, as the sources say (npc 39351 2012-05-18 [+2]); that puts them on her threat list, so a bystander on the quest is
-- credited too (ours, harmless).
-- Ours: the 0-2 % trigger, the 2 s pause, crediting the whole threat list, players unable to hit it during the pause, the option
-- hidden until it is home and healed. The reset (phase, react, flags) runs when the evade starts (SmartAI::EnterEvadeMode calls
-- Reset); an evading gladiator takes no damage and notices nobody on its way home. Not
-- reproduced: a one-shot at aggro giving no credit (2010-11-27, a retail fault), Griswold killable by Alliance players (2013-05-25:
-- one rule for all; he has no loot). Griswold's Flurry of Claws stays silent (a periodic dummy this core does not tick; deferred
-- CP13): he only melees.
-- Arithmetic (this core's formulas; level 11; both TDBs give the same template: level 11, warrior/paladin class, 2.0 s, damage
-- modifier 1 for Gaur and Griswold; Ghislania has 1.1 here from the open-world damage modifier file, TDB 1): health 271 / 311 /
-- 444 (Ghislania / Griswold / Gaur); melee (damage_base 4.84 .. x1.5 + attack power 36 / 14) x 2.0 s = 14.8-19.7 per swing for Gaur
-- and Griswold (8.6 dps), Ghislania 18-24 per swing but mostly casting (Static Burst 20 every 3.4-4.7 s, Chain Lightning 48-58
-- every 19-21 s: about 7.6 dps). Taunka Rage (Gaur at 30 %, 2.7 s cast, 10 s, once per fight; the same spell on retail): +30 FLAT
-- damage per swing (aura 13 MOD_DAMAGE_DONE, added as TOTAL_VALUE), so 44.8-49.7 per swing, about 23.6 dps for 10 s, and -70 %
-- speed on himself. Armor of a level 8-10 cloth player (about 80): 6 % less melee from level 11 (0.1 x A / (8.5 x 11 + 40));
-- about 10 % misses and dodges. A level 8 orc has 315 (mage) to 425 (warrior) health naked, level 10 384-494 (gtOCTBaseHPByClass
-- + stamina). At 10-12 player dps: Ghislania ~23 s / ~190 taken, Griswold ~26 s / ~210, Gaur 26-31 s to 30 % (~190-230 taken),
-- then up to ~200 more if the player stands in melee through the rage: 380-455 in all, more than a level 8-10 cloth character
-- has; a player who steps back during the rage (Gaur is slowed 70 %) takes almost nothing more and wins (~220-260). As retail
-- made him (same spell, same template), so left; on the test sheet: "step back while Gaur rages". A lost fight costs nothing:
-- the gladiator evades and resets.
-- Timers: the 2 s pause and the 6 s at home are action lists (3935x01, 3935x02), not created timed events: this core keeps every
-- created timed event for the creature's lifetime and never removes a fired one, and REMOVE_TIMED_EVENT blocks that id for good
-- (SmartScript.cpp ~1581, ~3750-3775; section 2's finding). A new list replaces the running one; the home list runs on the
-- out-of-combat timer only, so a fight started meanwhile holds it, and that fight's evade starts it again at home.
-- Phases: the combat rows run in phase 1 only; the reset sets phase 1, the defeat phase 2, so no cast lands after the defeat.

DELETE FROM `gossip_menu_option` WHERE `MenuID` IN (11229, 11230, 11231);
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcflag`,
 `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(11229, 0, 0, 'I''m here to challenge you in combat.', 39519, 1, 1, 0, 0, 0, 0, NULL, 0, 0),
(11230, 0, 0, 'I''m here to challenge you in combat.', 39519, 1, 1, 0, 0, 0, 0, NULL, 0, 0),
(11231, 0, 0, 'I''m here to challenge you in combat.', 39519, 1, 1, 0, 0, 0, 0, NULL, 0, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (11229, 11230, 11231);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
 `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 11229, 0, 0, 0, 47, 0, 25257, 8, 0, 0, 0, 0, '', 'Ghislania - challenge only while Ghislania is in progress'),
(15, 11230, 0, 0, 0, 47, 0, 25259, 8, 0, 0, 0, 0, '', 'Gaur Icehorn - challenge only while Gaur Icehorn is in progress'),
(15, 11231, 0, 0, 0, 47, 0, 25258, 8, 0, 0, 0, 0, '', 'Griswold Hanniston - challenge only while Griswold Hanniston is in progress');

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (39351, 39352, 39353);
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (39351, 39352, 39353);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(39351, 0, 0, 0, 0, 1, 100, 0, 0, 0, 3400, 4700, 0, 11, 76429, 64, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - In Combat - Cast ''Static Burst'' (both TDBs) - only while fighting (phase 1)'),
(39351, 0, 1, 0, 0, 1, 100, 0, 5000, 5000, 19000, 21000, 0, 11, 79913, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - In Combat - Cast ''Chain Lightning'' (both TDBs) - only while fighting (phase 1)'),
(39351, 0, 10, 11, 25, 0, 100, 0, 0, 0, 0, 0, 0, 42, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - On Reset - Never below 1 hp (beaten, not killed)'),
(39351, 0, 11, 12, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - React aggressive'),
(39351, 0, 12, 13, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Phase 1 (fighting)'),
(39351, 0, 13, 14, 61, 0, 100, 0, 0, 0, 0, 0, 0, 20, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Melee again'),
(39351, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Attackable by players again'),
(39351, 0, 15, 16, 62, 0, 100, 0, 11229, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Gossip ''I''m here to challenge you in combat.'' - Close gossip'),
(39351, 0, 16, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Attack the challenger'),
(39351, 0, 17, 18, 2, 0, 100, 1, 0, 2, 0, 0, 0, 33, 39351, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - At 1 hp (0-2%) - Defeated: credit everyone on the threat list (a pet credits its owner)'),
(39351, 0, 18, 19, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Phase 2 (beaten: no more combat casts)'),
(39351, 0, 19, 20, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - React passive'),
(39351, 0, 20, 21, 61, 0, 100, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Stop melee'),
(39351, 0, 21, 22, 61, 0, 100, 0, 0, 0, 0, 0, 0, 92, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Interrupt own casts'),
(39351, 0, 22, 23, 61, 0, 100, 0, 0, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Not attackable by players while beaten'),
(39351, 0, 23, 25, 61, 0, 100, 0, 0, 0, 0, 0, 0, 83, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - No gossip (no challenge) until it is home and healed'),
(39351, 0, 25, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 80, 3935101, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Linked - Action list: evade in 2 s'),
(39351, 0, 26, 0, 21, 0, 100, 0, 0, 0, 0, 0, 0, 80, 3935102, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Reached home - Action list: gossip again after 6 s out of combat'),
(39352, 0, 0, 0, 2, 1, 100, 1, 0, 30, 0, 0, 0, 11, 76423, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Between 0-30% Health - Cast ''Taunka Rage'' (No Repeat; both TDBs) - only while fighting (phase 1)'),
(39352, 0, 1, 0, 2, 1, 100, 1, 0, 30, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Between 0-30% Health - Say Line 0 (No Repeat; both TDBs) - only while fighting (phase 1)'),
(39352, 0, 10, 11, 25, 0, 100, 0, 0, 0, 0, 0, 0, 42, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - On Reset - Never below 1 hp (beaten, not killed)'),
(39352, 0, 11, 12, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - React aggressive'),
(39352, 0, 12, 13, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Phase 1 (fighting)'),
(39352, 0, 13, 14, 61, 0, 100, 0, 0, 0, 0, 0, 0, 20, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Melee again'),
(39352, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Attackable by players again'),
(39352, 0, 15, 16, 62, 0, 100, 0, 11230, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Gossip ''I''m here to challenge you in combat.'' - Close gossip'),
(39352, 0, 16, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Attack the challenger'),
(39352, 0, 17, 18, 2, 0, 100, 1, 0, 2, 0, 0, 0, 33, 39352, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - At 1 hp (0-2%) - Defeated: credit everyone on the threat list (a pet credits its owner)'),
(39352, 0, 18, 19, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Phase 2 (beaten: no more combat casts)'),
(39352, 0, 19, 20, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - React passive'),
(39352, 0, 20, 21, 61, 0, 100, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Stop melee'),
(39352, 0, 21, 22, 61, 0, 100, 0, 0, 0, 0, 0, 0, 92, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Interrupt own casts'),
(39352, 0, 22, 23, 61, 0, 100, 0, 0, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Not attackable by players while beaten'),
(39352, 0, 23, 25, 61, 0, 100, 0, 0, 0, 0, 0, 0, 83, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - No gossip (no challenge) until it is home and healed'),
(39352, 0, 25, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 80, 3935201, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Linked - Action list: evade in 2 s'),
(39352, 0, 26, 0, 21, 0, 100, 0, 0, 0, 0, 0, 0, 80, 3935202, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Reached home - Action list: gossip again after 6 s out of combat'),
(39353, 0, 0, 0, 4, 1, 100, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - On Aggro - Say Line 0 (No Repeat; both TDBs) - only while fighting (phase 1)'),
(39353, 0, 1, 0, 0, 1, 100, 0, 5000, 8000, 22000, 26000, 0, 11, 76490, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - In Combat - Cast ''Flurry of Claws'' (both TDBs) - only while fighting (phase 1)'),
(39353, 0, 10, 11, 25, 0, 100, 0, 0, 0, 0, 0, 0, 42, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - On Reset - Never below 1 hp (beaten, not killed)'),
(39353, 0, 11, 12, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - React aggressive'),
(39353, 0, 12, 13, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Phase 1 (fighting)'),
(39353, 0, 13, 14, 61, 0, 100, 0, 0, 0, 0, 0, 0, 20, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Melee again'),
(39353, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Attackable by players again'),
(39353, 0, 15, 16, 62, 0, 100, 0, 11231, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Gossip ''I''m here to challenge you in combat.'' - Close gossip'),
(39353, 0, 16, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Attack the challenger'),
(39353, 0, 17, 18, 2, 0, 100, 1, 0, 2, 0, 0, 0, 33, 39353, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - At 1 hp (0-2%) - Defeated: credit everyone on the threat list (a pet credits its owner)'),
(39353, 0, 18, 19, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Phase 2 (beaten: no more combat casts)'),
(39353, 0, 19, 20, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - React passive'),
(39353, 0, 20, 21, 61, 0, 100, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Stop melee'),
(39353, 0, 21, 22, 61, 0, 100, 0, 0, 0, 0, 0, 0, 92, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Interrupt own casts'),
(39353, 0, 22, 23, 61, 0, 100, 0, 0, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Not attackable by players while beaten'),
(39353, 0, 23, 25, 61, 0, 100, 0, 0, 0, 0, 0, 0, 83, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - No gossip (no challenge) until it is home and healed'),
(39353, 0, 25, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 80, 3935301, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Linked - Action list: evade in 2 s'),
(39353, 0, 26, 0, 21, 0, 100, 0, 0, 0, 0, 0, 0, 80, 3935302, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Reached home - Action list: gossip again after 6 s out of combat');

DELETE FROM `smart_scripts` WHERE `source_type` = 9 AND `entryorguid` IN (3935101, 3935102, 3935201, 3935202, 3935301, 3935302);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3935101, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Action list (beaten) - Evade after 2 s (walks home, reset)'),
(3935102, 9, 0, 0, 0, 0, 100, 0, 6000, 6000, 0, 0, 0, 82, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Ghislania - Action list (home, out of combat timer) - Gossip again: the challenge can be chosen'),
(3935201, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Action list (beaten) - Evade after 2 s (walks home, reset)'),
(3935202, 9, 0, 0, 0, 0, 100, 0, 6000, 6000, 0, 0, 0, 82, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Gaur Icehorn - Action list (home, out of combat timer) - Gossip again: the challenge can be chosen'),
(3935301, 9, 0, 0, 0, 0, 100, 0, 2000, 2000, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Action list (beaten) - Evade after 2 s (walks home, reset)'),
(3935302, 9, 0, 0, 0, 0, 100, 0, 6000, 6000, 0, 0, 0, 82, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Griswold Hanniston - Action list (home, out of combat timer) - Gossip again: the challenge can be chosen');
