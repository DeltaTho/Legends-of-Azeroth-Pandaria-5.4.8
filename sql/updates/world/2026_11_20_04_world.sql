-- Rhea's Camp: Nyxondra 46658 is beaten into submission for Third Sample: Implanted Eggs 27771, and never dies.
--
-- SHIP ONLY WITH OR AFTER the Lifting the Veil 27770 witness credit (section H, H-2): 27770's objective is a kill credit of
-- 46658, and once she cannot die nothing else gives it.
--
-- What the player sees: Nyxondra stands at her spot (no wandering). She fights with Flame Breath. Beaten down to about a third
-- of her health she stops fighting, turns friendly (nobody can attack her, pets and bots stop), lies down where she is and the
-- emote "Nyxondra slumps down in exhaustion." shows; she gets her health back while she lies there. About 15 s later
-- "Nyxondra appears to be waking up!", she stands up hostile, walks back to her spot and fights again at full health. Her
-- health never drops below 1, so she cannot be killed. Her implanted eggs (206321, 10 s to open) are taken while she lies
-- down or is crowd-controlled.
-- Sourced: the behaviour (wiki 27771 notes; Wowhead comments 2010-11-27 [+15], 2011-01-29 [+3] "only reduces her health to
--   1"; quest text "beat her into submission"), the emotes (BroadcastText 46759, 46760), Flame Breath (both TDBs' entry
--   script, unchanged). Her two Wowhead pins 4 yd apart: a captive standing still.
-- Ours: the 36 % threshold (about 1,000 of 2,772 hp as the wiki puts it), 15 s, lying down (stand state sleep), the 1 hp floor.
-- Core notes: an evade does not restore a SmartAI faction (SmartAI::EnterEvadeMode), a respawn does (SmartAI::JustAppeared);
--   RESET fires at the start of an evade and again at home, so the reset rows restore faction, react state and stand state.
--   COMBAT_STOP leaves the creature engaged and chasing, and CreatureAI::UpdateVictim then evades a passive creature at once
--   (#904 "dropped fight"): the zero-offset MOVE_OFFSET replaces the chase with a point move on the spot, so she stays down.
-- Her emotes are personal (TextRange 5) to the player who was fighting her when she slumped (her victim, stored before the
--   combat stop): section B hides her behind quest invisibility, and creature text reaches everyone in range seen or not.
--   Ours: if a pet was her victim (a hunter's pet tanking), no player is stored and both emotes are not shown.
-- Do not add SMART_ACTION_REMOVE_TIMED_EVENT for timed event 1: this core never clears its remove list (SmartScript.cpp:3759),
--   so every later wake-up would be dropped and she would never get up.

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 312984;

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 46658;

DELETE FROM `smart_scripts` WHERE `entryorguid` = 46658 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(46658, 0, 0, 0, 0, 1, 100, 0, 5000, 8000, 17000, 20000, 0, 11, 8873, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - In combat (awake) - Cast Flame Breath'),
(46658, 0, 1, 2, 25, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - On reset - Phase 1 (awake)'),
(46658, 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 0, 42, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Never below 1 hp'),
(46658, 0, 3, 4, 61, 0, 100, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Template faction'),
(46658, 0, 4, 5, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Aggressive'),
(46658, 0, 5, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 91, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Stand up'),
(46658, 0, 6, 7, 2, 1, 100, 0, 0, 36, 1000, 1000, 0, 22, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - At 36% health (awake) - Phase 2 (exhausted)'),
(46658, 0, 7, 8, 61, 0, 100, 0, 0, 0, 0, 0, 0, 64, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Store victim (her emotes go to that player only)'),
(46658, 0, 8, 9, 61, 0, 100, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 12, 1, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Emote to the stored player: slumps down in exhaustion'),
(46658, 0, 9, 10, 61, 0, 100, 0, 0, 0, 0, 0, 0, 203, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Combat stop'),
(46658, 0, 10, 11, 61, 0, 100, 0, 0, 0, 0, 0, 0, 114, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Stop chasing (point move on the spot)'),
(46658, 0, 11, 12, 61, 0, 100, 0, 0, 0, 0, 0, 0, 2, 35, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Friendly'),
(46658, 0, 12, 13, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Passive'),
(46658, 0, 13, 14, 61, 0, 100, 0, 0, 0, 0, 0, 0, 90, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Lie down'),
(46658, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 67, 1, 15000, 15000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Wake up in 15 s'),
(46658, 0, 15, 16, 59, 2, 100, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 12, 1, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - On timed event 1 (exhausted) - Emote to the stored player: appears to be waking up'),
(46658, 0, 16, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 24, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Nyxondra - Linked - Evade (reset rows: awake, hostile, standing; walks home)');

DELETE FROM `creature_text` WHERE `CreatureID` = 46658;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(46658, 0, 0, '%s slumps down in exhaustion.', 16, 0, 100, 0, 0, 0, 0, 46759, 5, 'Nyxondra - exhausted (Third Sample: Implanted Eggs)'),
(46658, 1, 0, '%s appears to be waking up!', 16, 0, 100, 0, 0, 0, 0, 46760, 5, 'Nyxondra - wakes (Third Sample: Implanted Eggs)');
