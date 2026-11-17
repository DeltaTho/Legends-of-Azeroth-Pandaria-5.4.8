-- Swamp of Sorrows A (_03): Sunken Temple texts and templates (plan A-13..A-17; S2 dossier F3, F4, F8 aura half, F10, F11).
--
-- SOURCED: Step Two's reward text and the progress texts of Marshfin Madness, Legends of the Sunken Temple and The Darkest
-- Depths (both TDBs, VerifiedBuild 32750); Priestess Udum'bra channels Shadow Channeling 75965 when idle (both TDBs' template
-- addon); the Butchered Drakes are not selectable (TDB 4.4.2 unit_flags NOT_SELECTABLE; they lie as corpses, aura 70628);
-- Hr'nglth the Lost says "Hear the call... serve him... join ussssssssssss..." on aggro (BroadcastText 46416; wiki quest_27757
-- Notes "On aggro"; comments 2011-02-23 [+6], 2013-08-06 [+8]).
-- OURS: nothing beyond the encoding (Hr'nglth has no other AI: the new SmartAI holds only the line; he fought with melee only
-- before and still does). Udum'bra's spot is section C's (_45).
-- Idempotent: absolute UPDATEs, DELETE + INSERT.

-- A-13: Step Two: The Bloodletter 27768 reward text
DELETE FROM `quest_offer_reward` WHERE `ID` = 27768;
INSERT INTO `quest_offer_reward` (`ID`, `Emote1`, `Emote2`, `Emote3`, `Emote4`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `EmoteDelay4`, `RewardText`, `VerifiedBuild`) VALUES
(27768, 1, 0, 0, 0, 0, 0, 0, 0, 'A deserved fate. You will not find the pacifism of the red dragonflight among my kin, $n; we will not suffer the intrusions of mortals.', 32750);

-- A-14: progress texts
DELETE FROM `quest_request_items` WHERE `ID` IN (27691, 27704, 27757);
INSERT INTO `quest_request_items` (`ID`, `EmoteOnComplete`, `EmoteOnIncomplete`, `CompletionText`, `VerifiedBuild`) VALUES
(27691, 0, 1, 'I''ve still got a few tricks up my sleeve, but I''m not going to tussle with murlocs if I don''t have to.', 32750),
(27704, 0, 0, 'You must not falter, $n. Your actions will pave the way for me to enter the temple myself.', 32750),
(27757, 0, 0, 'Getting cold feet?', 32750);

-- A-15: Priestess Udum'bra channels
UPDATE `creature_template_addon` SET `auras` = '75965' WHERE `entry` = 46424;

-- A-16: Butchered Drakes are corpses: not selectable (mop 0)
UPDATE `creature_template` SET `unit_flags` = 33554432 WHERE `entry` = 46629;

-- A-17: Hr'nglth the Lost's aggro line
DELETE FROM `creature_text` WHERE `CreatureID` = 46371;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(46371, 0, 0, 'Hear the call... serve him... join ussssssssssss...', 12, 0, 100, 0, 0, 0, 0, 46416, 0, 'Hr''nglth the Lost - aggro');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 46371;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 46371 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(46371, 0, 0, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Hr''nglth the Lost - On Aggro - Say Line 0');
