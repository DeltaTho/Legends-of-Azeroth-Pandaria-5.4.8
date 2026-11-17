-- Burning Steppes B (_10): Trial by Magma 28266 / 28438 (Wyrtle releases a bound Kolob) and the Abuse of Power push on accepting
-- I Am the Law 28278 / I Am the Lash 28439 (plan B-02, B-03, B-04, B-12).
--
-- SOURCED: both TDBs (Magma Lord Kolob 48156 unit_flags IMMUNE_TO_PC); wiki and comments (Kolob "is hostile, but cannot be attacked,
-- yet" / "invalid target" without the quest, 2011-10-07 [+3]; Wyrtle's option "I'd like to challenge your magma lord to a fight.";
-- 28279 / 28440 "start=Automatic", comments 28439 2010-11-26, 28440 2010-11-26 [+11] "plops open in your quest tracker"); the lines
-- 48375 (Wyrtle yells), 48376 (Wyrtle on Kolob's death), 48387 (the General after it), 48385 (Wyrtle while Kolob is dead or busy;
-- attributed by its id block, inferred).
-- mop had: Kolob without IMMUNE_TO_PC (he aggroed every player at the General and anyone could kill him), Wyrtle's option with
-- OptionNpcflag 0 (Player::PrepareGossipMenu skips it, so it never showed), no texts, nothing pushing Abuse of Power.
-- OURS: the mechanism (Wyrtle stores the challenger and hands him to Kolob, STORE_TARGET_LIST + SEND_TARGET_TO_TARGET, core rule C62);
-- Kolob passive while bound (IMMUNE_TO_PC alone does not stop SmartAI aggro); "indisposed" also while Kolob fights another challenger;
-- the 3 s before the General's line; the push only if Abuse of Power was never taken (ADD_QUEST does not check CanTakeQuest, C61).
-- Idempotent: the flag UPDATE sets a bit; the rest absolute UPDATEs and DELETE + INSERT.

UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 0x100 WHERE `entry` = 48156;
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (48133, 48159) AND `ScriptName` = '';
UPDATE `gossip_menu_option` SET `OptionNpcflag` = 1 WHERE `MenuID` = 12397 AND `OptionID` = 0;

DELETE FROM `creature_text` WHERE `CreatureID` = 48159 AND `GroupID` IN (0, 1, 2);
DELETE FROM `creature_text` WHERE `CreatureID` = 48133 AND `GroupID` = 0;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(48159, 0, 0, 'Alright boys, we got a challenger!  Time to show the general what our little captive can do!', 14, 0, 100, 0, 0, 0, 0, 48375, 0, 'Wyrtle Spreelthonket - Kolob released'),
(48159, 1, 0, 'The magma lord is a little... indisposed right now.  Stick around, this won''t take more than a minute or two.', 12, 0, 100, 0, 0, 0, 0, 48385, 0, 'Wyrtle Spreelthonket - Kolob dead or busy'),
(48159, 2, 0, 'Nooo!  My baby...', 12, 0, 100, 0, 0, 0, 0, 48376, 0, 'Wyrtle Spreelthonket - Kolob defeated'),
(48133, 0, 0, 'Ah ha ha!  Well done!', 12, 0, 100, 0, 0, 0, 0, 48387, 0, 'General Thorg''izog - Kolob defeated');

-- Kolob: phase 1 = bound (IMMUNE_TO_PC, passive), phase 2 = fighting the challenger. The "busy" row (4) comes before the release chain
-- (5-9): SmartScript::ProcessEventsFor checks each row's phase when it reaches it, so a release chain placed first would set phase 2
-- and the busy row would then fire in the same pass.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (48156, 48159, 48133) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(48156, 0, 0, 0, 0, 0, 100, 0, 5000, 8000, 12000, 15000, 0, 11, 80549, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - In Combat - Cast Gout of Flame'),
(48156, 0, 1, 2, 25, 0, 100, 0, 0, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Reset - Set IMMUNE_TO_PC (bound)'),
(48156, 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Reset - Set Passive'),
(48156, 0, 3, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Reset - Set Phase 1'),
(48156, 0, 4, 0, 38, 2, 100, 0, 1, 1, 0, 0, 0, 45, 3, 1, 0, 0, 0, 0, 19, 48159, 40, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Data 1 1 (busy) - Set Data 3 1 on Wyrtle'),
(48156, 0, 5, 6, 38, 1, 100, 0, 1, 1, 0, 0, 0, 19, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Data 1 1 (bound) - Remove IMMUNE_TO_PC'),
(48156, 0, 6, 7, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Data 1 1 - Set Aggressive'),
(48156, 0, 7, 8, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Data 1 1 - Set Phase 2'),
(48156, 0, 8, 9, 61, 0, 100, 0, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 12, 1, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Data 1 1 - Attack the challenger (stored 1)'),
(48156, 0, 9, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 45, 4, 1, 0, 0, 0, 0, 19, 48159, 40, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Data 1 1 - Set Data 4 1 on Wyrtle (yell)'),
(48156, 0, 10, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 45, 2, 1, 0, 0, 0, 0, 19, 48159, 100, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Death - Set Data 2 1 on Wyrtle (100 yd: also when kited to his leash)'),
(48156, 0, 11, 0, 7, 0, 100, 0, 0, 0, 0, 0, 0, 18, 256, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Magma Lord Kolob - On Evade - Set IMMUNE_TO_PC'),
(48159, 0, 0, 1, 62, 0, 100, 0, 12397, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Gossip Option 0 (Kolob alive) - Close Gossip'),
(48159, 0, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, 64, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Gossip Option 0 - Store Challenger'),
(48159, 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 0, 100, 1, 0, 0, 0, 0, 0, 19, 48156, 40, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Gossip Option 0 - Send Challenger to Kolob'),
(48159, 0, 3, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 19, 48156, 40, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Gossip Option 0 - Set Data 1 1 on Kolob'),
(48159, 0, 4, 5, 62, 0, 100, 0, 12397, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Gossip Option 0 (Kolob dead) - Close Gossip'),
(48159, 0, 5, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Gossip Option 0 (Kolob dead) - Say Indisposed'),
(48159, 0, 6, 0, 38, 0, 100, 0, 3, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Data 3 1 (Kolob busy) - Say Indisposed'),
(48159, 0, 7, 0, 38, 0, 100, 0, 4, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Data 4 1 (Kolob released) - Yell Challenger'),
(48159, 0, 8, 9, 38, 0, 100, 0, 2, 1, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Data 2 1 (Kolob died) - Say My Baby'),
(48159, 0, 9, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 45, 1, 1, 0, 0, 0, 0, 19, 48133, 30, 0, 0, 0, 0, 0, 0, 'Wyrtle Spreelthonket - On Data 2 1 - Set Data 1 1 on Thorg''izog'),
(48133, 0, 0, 0, 19, 0, 100, 0, 28278, 0, 0, 0, 0, 7, 28279, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'General Thorg''izog - On Quest 28278 Accepted - Add Abuse of Power (Troteman radios in)'),
(48133, 0, 1, 0, 19, 0, 100, 0, 28439, 0, 0, 0, 0, 7, 28440, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'General Thorg''izog - On Quest 28439 Accepted - Add Abuse of Power (Eitrigg radios in)'),
(48133, 0, 2, 0, 38, 0, 100, 0, 1, 1, 0, 0, 0, 67, 1, 3000, 3000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'General Thorg''izog - On Data 1 1 (Kolob died) - Timed Event 1 in 3 s'),
(48133, 0, 3, 0, 59, 0, 100, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'General Thorg''izog - On Timed Event 1 - Say Well Done');

-- the option only with the Trial in progress; release (Kolob alive) vs. indisposed (dead); push only if Abuse of Power was never taken
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 12397 AND `SourceEntry` = 0;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` IN (48159, 48133) AND `SourceId` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 12397, 0, 0, 0, 47, 0, 28266, 8, 0, 0, 0, 0, '', 'Wyrtle - challenge option while Trial by Magma (A) is in progress'),
(15, 12397, 0, 0, 1, 47, 0, 28438, 8, 0, 0, 0, 0, '', 'Wyrtle - challenge option while Trial by Magma (H) is in progress'),
(22, 1, 48159, 0, 0, 29, 1, 48156, 40, 0, 0, 0, 0, '', 'Wyrtle - release only while Kolob is alive'),
(22, 5, 48159, 0, 0, 29, 1, 48156, 40, 0, 1, 0, 0, '', 'Wyrtle - indisposed while Kolob is dead'),
(22, 1, 48133, 0, 0, 47, 0, 28279, 1, 0, 0, 0, 0, '', 'Thorg''izog - push Abuse of Power (A) only if never taken'),
(22, 2, 48133, 0, 0, 47, 0, 28440, 1, 0, 0, 0, 0, '', 'Thorg''izog - push Abuse of Power (H) only if never taken');
