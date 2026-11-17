-- Burning Steppes B (_16): one catch per Flamefly; the lines of Acride, Troteman and the three Blackrock bosses; a new Blackrock
-- Disguise on handing in Placing the Pawns (plan B-24, B-25, B-27; S4-F13, S4-F15, K9).
--
-- SOURCED:
-- * SEVEN! YUP! 28415 / Not Fireflies, Flameflies 28491: one Flamefly gives one catch ("click fast and get 2-3 from one", comments
--   [+12], [+9]); mop's flies had no AI and stayed, so one fly gave any number. Respawn 120 s as both TDBs (mop 300).
-- * Lines (wiki; broadcast_text): Acride on A Deal With a Dragon 28316 / 28448 (48783); Troteman on accepting A Delivery for Xi'lun
--   28319 "Don't forget that disguise!" (48782; no Horde line found, R-18); General Thorg'izog / Dragon-Lord Neeralak / High Warlock
--   Xi'lun on their delivery (48784 / 48785 / 48786); Thorg'izog's aggro yell "Lok-Narash! To battle!" (50368, comment 2012-04-13).
-- * Placing the Pawns 28326 / 28449 (wiki notes, both factions): "On complete ... the Blackrock Disguise is found." The TDBs' RewardSpell
--   89249 is server-side and not in the 5.4.8 DBC. The deliveries that follow need the disguise; Enough Damage For One Day destroyed it.
-- OURS: the click only for holders of 28415 / 28491; the Flamefly despawn 1 s after a click (a quick second click can still catch one more, as the comments say); the triggers of
--   the lines (SmartAI on accept / reward / aggro); TextRange 5 for Troteman 48307, who is staged per player by section C (his line
--   reaches only the player who accepted); the disguise by SmartAI ADD_ITEM 63357 on the reward of 28326 / 28449 at Troteman 48307 /
--   Eitrigg 48569, only if the player has none (bags or bank).
-- Idempotent: absolute UPDATEs, DELETE + INSERT.

-- Flamefly
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 48671 AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE `entryorguid` = 48671 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(48671, 0, 0, 0, 73, 0, 100, 0, 0, 0, 0, 0, 0, 41, 1000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Flamefly - On Spellclick - Despawn in 1 s (one catch per fly)');
UPDATE `creature` SET `spawntimesecs` = 120 WHERE `id` = 48671;
-- only holders of the quest can catch one (so a passer-by does not clear the flies questers need); ours
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` = 48671 AND `SourceEntry` = 90672;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(18, 48671, 90672, 0, 0, 9, 0, 28415, 0, 0, 0, 0, 0, '', 'Flamefly - catchable while SEVEN! YUP! is in progress'),
(18, 48671, 90672, 0, 1, 9, 0, 28491, 0, 0, 0, 0, 0, '', 'Flamefly - or Not Fireflies, Flameflies');

-- lines
DELETE FROM `creature_text` WHERE `CreatureID` IN (48292, 48307) AND `GroupID` = 0;
DELETE FROM `creature_text` WHERE `CreatureID` IN (48312, 48314, 48316) AND `GroupID` IN (0, 1);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(48292, 0, 0, 'Your conspirator has informed me of your plan.  I shall see you on the battlefield... painted with the ashes of the elementals.', 12, 0, 100, 0, 0, 0, 0, 48783, 0, 'Acride - A Deal With a Dragon rewarded'),
(48307, 0, 0, 'Don''t forget that disguise!', 12, 0, 100, 0, 0, 0, 0, 48782, 5, 'Colonel Troteman - A Delivery for Xi''lun accepted (to the player: staged NPC)'),
(48316, 0, 0, 'Come on boys, let''s eat!  My favorite soldier brought enough worg for everyone!', 14, 0, 100, 0, 0, 0, 0, 48784, 0, 'General Thorg''izog - delivery rewarded'),
(48316, 1, 0, 'Lok-Narash! To battle!', 14, 0, 100, 0, 0, 0, 0, 50368, 0, 'General Thorg''izog - aggro'),
(48314, 0, 0, 'I guess I''ll just... leave the sleeping imps right over here?  Are these even... imps?  Gah!', 12, 0, 100, 0, 0, 0, 0, 48785, 0, 'Dragon-Lord Neeralak - delivery rewarded'),
(48312, 0, 0, 'You know, I''m going to be using this orb to perform a powerful ritual in just a few minutes.  Don''t tell anyone this... but I''ll be summoning a pit lord.  Redridge will bow to the Blackrock!', 12, 0, 100, 0, 0, 0, 0, 48786, 0, 'High Warlock Xi''lun - delivery rewarded');

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (48292, 48307, 48569) AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND (`entryorguid` = 48292 OR (`entryorguid` = 48307 AND `id` IN (0, 1)) OR (`entryorguid` = 48569 AND `id` = 0)
  OR (`entryorguid` IN (48312, 48314, 48316) AND `id` BETWEEN 10 AND 12));
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(48292, 0, 0, 0, 20, 0, 100, 0, 28316, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Acride - On A Deal With a Dragon (A) rewarded - Say 0'),
(48292, 0, 1, 0, 20, 0, 100, 0, 28448, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Acride - On A Deal With a Dragon (H) rewarded - Say 0'),
(48307, 0, 0, 0, 19, 0, 100, 0, 28319, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Colonel Troteman - On A Delivery for Xi''lun accepted - Say 0 to the player'),
(48307, 0, 1, 0, 20, 0, 100, 0, 28326, 0, 0, 0, 0, 56, 63357, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Colonel Troteman - On Placing the Pawns rewarded - Add Blackrock Disguise (if none held)'),
(48569, 0, 0, 0, 20, 0, 100, 0, 28449, 0, 0, 0, 0, 56, 63357, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Eitrigg - On Placing the Pawns rewarded - Add Blackrock Disguise (if none held)'),
(48316, 0, 10, 0, 20, 0, 100, 0, 28317, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'General Thorg''izog - On delivery (A) rewarded - Yell 0'),
(48316, 0, 11, 0, 20, 0, 100, 0, 28450, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'General Thorg''izog - On delivery (H) rewarded - Yell 0'),
(48316, 0, 12, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'General Thorg''izog - On Aggro - Yell 1'),
(48314, 0, 10, 0, 20, 0, 100, 0, 28318, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Dragon-Lord Neeralak - On delivery (A) rewarded - Say 0'),
(48314, 0, 11, 0, 20, 0, 100, 0, 28451, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Dragon-Lord Neeralak - On delivery (H) rewarded - Say 0'),
(48312, 0, 10, 0, 20, 0, 100, 0, 28319, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'High Warlock Xi''lun - On delivery (A) rewarded - Say 0'),
(48312, 0, 11, 0, 20, 0, 100, 0, 28452, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'High Warlock Xi''lun - On delivery (H) rewarded - Say 0');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND ((`SourceGroup` = 2 AND `SourceEntry` = 48307) OR (`SourceGroup` = 1 AND `SourceEntry` = 48569)) AND `SourceId` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 2, 48307, 0, 0, 2, 0, 63357, 1, 1, 1, 0, 0, '', 'Colonel Troteman - new Blackrock Disguise only if the player has none (bags or bank)'),
(22, 1, 48569, 0, 0, 2, 0, 63357, 1, 1, 1, 0, 0, '', 'Eitrigg - new Blackrock Disguise only if the player has none (bags or bank)');
