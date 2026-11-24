-- An Ancient Enemy and Vol'jin's visions: helpers get the Sea Witch's credit, a hand-in no longer restarts a vision.
--
-- 1. Zar'jira's death credits every player within 60 yd who has the quest, as well as the player who started the event (id 32).
--    Sourced: Wowhead 24814 2010-11-23 ("If the event is already in progress, you will still get credit for it if you help") and
--    the DBC's own group credit 73534 Sea Witch Kill Credit (KILL_CREDIT2 38306, 60 yd around the caster). Ours: done with a SmartAI
--    credit to players in 60 yd rather than the spell (KilledMonsterCredit counts only for players with the quest active). Party
--    members and bots in range get it too, and so does an idle player with the quest who only stood in range: accepted as the
--    less grindy reading of "if you help" (KilledMonsterCredit cannot tell helping from watching).
DELETE FROM `smart_scripts` WHERE `entryorguid` = 38306 AND `source_type` = 0 AND `id` = 40;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(38306, 0, 40, 0, 6, 0, 100, 0, 0, 0, 0, 0, 33, 38306, 0, 0, 0, 0, 0, 18, 60, 0, 0, 0, 0, 0, 0, 'Zar''jira - On Death - Quest Credit to players within 60 yd (helpers)');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 38306;

-- 2. (Not changed, on purpose.) Vol'jin 38225's Shoot (id 7) stays blocked by its condition 22/8 (SmartAI phase 1, never true in
--    a row that runs only in phase 2). Shoot 20463 has base points -1 (no damage by the DBC) and, cast every 3-4 s, it would cut his
--    channelled Deluge of Shadow 72044 (the drain beam of the fire phases). The 22/7 row on the linked id 6 is never read (a linked
--    event's conditions are not checked: SmartScript::ProcessEvent, case SMART_EVENT_LINK), so Vol'jin reaches phase 2 four seconds
--    into the fight and Shadow Shock (id 8) runs; 2026_12_08_16 keeps him from casting it while he channels.

-- 3. Vol'jin 38966's "On Rewarded Quest" rows (ids 14-22: the nine More Than Expected; id 43: An Ancient Enemy) restarted a vision
--    that was already playing for another player; only the gossip rows (ids 1 and 23) carried the "not in phase 1" guard. Ours, from
--    the code: the same guard on those ten rows (source 22 group = id + 1). A player who hands in during a vision misses it and can
--    replay it from Vol'jin's menu.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 38966 AND `SourceId` = 0 AND `SourceGroup` IN (15, 16, 17, 18, 19, 20, 21, 22, 23, 44) AND `ConditionTypeOrReference` = 101;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 15, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 16, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 17, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 18, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 19, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 20, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 21, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 22, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 23, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Garrosh vision on reward only if no vision is playing'),
(22, 44, 38966, 0, 0, 101, 1, 1, 0, 0, 1, 0, 0, '', 'Vol''jin - Thrall vision on reward only if no vision is playing');
