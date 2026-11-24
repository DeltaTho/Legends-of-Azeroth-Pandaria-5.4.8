-- An Ancient Enemy: "I am ready" cannot restart a running event, the braziers matter, Vol'jin is back after Vanira, everyone fighting
-- sees the fire prompt, Zar'jira taunts before the fight and says "Not so fast, little troll!" before she kills Zuni.
--
-- 1. Vol'jin 38225's "I am ready, Vol'jin." (menu 11020 option 0) only while no event runs. The option hid only through his npcflag
--    (3822503 sets it to 2 about 1.1 s after the choice; Player::PrepareGossipMenu, Player.cpp:15578, needs the option's npcflag),
--    but a menu already open, or opened in that second, could still be picked (HandleGossipSelectOptionOpcode does not re-check the
--    option), and the opening ran again: Vanira passive on her path, Zar'jira's phase reset, the fire counter lost. Ours: Vol'jin's
--    SmartAI phase 1 from the choice (new link id 22) until the fight sets phase 2; the option and his three gossip rows (ids 0-2)
--    need phase 0. Every way the event ends brings him back in phase 0: the outro despawns him (respawn), the reset list 3822504
--    despawns him and a Fire respawns him (SmartScript::OnInitialize / OnReset set phase 0), and a reached-home resets it too.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 11020 AND `SourceEntry` = 0 AND `ConditionTypeOrReference` = 101;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 38225 AND `SourceId` = 0 AND `SourceGroup` IN (1, 2, 3) AND `ConditionTypeOrReference` = 101;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 11020, 0, 0, 0, 101, 1, 0, 0, 0, 0, 0, 0, '', 'Vol''jin - "I am ready" only while no event runs (his SmartAI phase 0)'),
(22, 1, 38225, 0, 0, 101, 1, 0, 0, 0, 0, 0, 0, '', 'Vol''jin - gossip close only in phase 0'),
(22, 2, 38225, 0, 0, 101, 1, 0, 0, 0, 0, 0, 0, '', 'Vol''jin - speak credit only in phase 0'),
(22, 3, 38225, 0, 0, 101, 1, 0, 0, 0, 0, 0, 0, '', 'Vol''jin - event start only in phase 0');

-- 2. The braziers matter: Vol'jin deals no damage while he channels. At 50 % Zar'jira freezes Vanira and Zuni, turns immune to
--    players and drains Vol'jin through the fires; at 10 % she freezes him again. His Shadow Shock (id 8, phase 2) kept hitting her
--    through both, so she sank from 50 % to 10 % and died without a single fire stamped (walk W1-2; sources: the fires must be
--    stamped out, "She's drawing power from the fires! Stamp out the braziers, quickly!"; Wowhead 2011-02-13: she stays near the
--    threshold until they are). Ours: data 2 2 and data 4 4 (his channel starts) also set his phase 4, where no damage row runs;
--    data 3 3 (fires out, id 11) already sets phase 2 again. His reset rows (ids 20, 21) run in phases 2 and 4 (mask 10).
UPDATE `smart_scripts` SET `link` = 22 WHERE `entryorguid` = 38225 AND `source_type` = 0 AND `id` = 3;
UPDATE `smart_scripts` SET `link` = 23 WHERE `entryorguid` = 38225 AND `source_type` = 0 AND `id` = 10;
UPDATE `smart_scripts` SET `link` = 24 WHERE `entryorguid` = 38225 AND `source_type` = 0 AND `id` = 13;
UPDATE `smart_scripts` SET `event_phase_mask` = 10 WHERE `entryorguid` = 38225 AND `source_type` = 0 AND `id` IN (20, 21);
DELETE FROM `smart_scripts` WHERE `entryorguid` = 38225 AND `source_type` = 0 AND `id` IN (22, 23, 24);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(38225, 0, 22, 0, 61, 0, 100, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Vol''jin - Linked To Id 3 - Set Phase 1 (event started, "I am ready" hidden)'),
(38225, 0, 23, 0, 61, 0, 100, 0, 0, 0, 0, 0, 22, 4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Vol''jin - Linked To Id 10 - Set Phase 4 (drained through the fires: no damage)'),
(38225, 0, 24, 0, 61, 0, 100, 0, 0, 0, 0, 0, 22, 4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Vol''jin - Linked To Id 13 - Set Phase 4 (frozen at 10 %: no damage)');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (38225, 38306);

-- 3. Vol'jin was missing for up to 5 minutes after a finished event (spawn 252717 respawn 300 s). Ours: 180 s, so he comes back
--    after Vanira: her outro ends with her gossip (teleport) at about 60 s after Zar'jira's death and a 60 s despawn, then her 60 s
--    respawn, so she is back at about 180 s; Vol'jin despawns some 30 s after the death and returns at about 210 s. With a shorter
--    respawn a new "I am ready" could start a fight while Vanira was still in her outro or gone, and she would join only at 10 %.
--    His respawn list respawns Zuni, Vanira and Zar'jira if any of them is still away.
UPDATE `creature` SET `spawntimesecs` = 180 WHERE `guid` = 252717;

-- 4. "She's drawing power from the fires! Stamp out the braziers, quickly!" (raid-boss emote, type 41) reached only players within
--    the text-emote range (40 yd) of Vol'jin; the fires and Zar'jira are about 46-51 yd from him, so a player fighting the
--    Manifestations by the fires saw nothing. Ours: TextRange 1 (every player in Spitescale Cove, area 4867, where the whole fight
--    stands). A text cannot be limited to quest holders.
UPDATE `creature_text` SET `TextRange` = 1 WHERE `CreatureID` = 38225 AND `GroupID` = 1 AND `ID` = 0;

-- 5. Zar'jira's taunts before the fight. Sourced: Wowhead npc 38306 2011-12-31 ("Can be found yelling things like: The tides shall
--    wash away the entire Darkspear Tribe / ... that orcish cur ... / You were fools to leave the safety of your city ..."); the
--    seven lines are broadcast_text 39014-39020 (female text). The source has her yelling while she waits ("can be found yelling"),
--    not at players on the quest. Ours: one at random every 60-120 s (first after 20-40 s), as group 4, only while she idles
--    (SmartAI phase 0): data 1 1 (the start of the scripted opening, id 4) now also sets her phase 5 (new link id 42; no row uses
--    phase 5), which lasts until the opening ends in phase 2, so no taunt falls between Vol'jin's yell and her answer. A respawn or
--    the event reset returns her to phase 0. A creature text cannot be limited to players with the quest.
DELETE FROM `creature_text` WHERE `CreatureID` = 38306 AND `GroupID` = 4;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(38306, 4, 0, 'Your father was a weakling, Vol''jin. I shall enjoy sucking the life from you as I did him.', 14, 0, 100, 0, 0, 0, 0, 39014, 0, 'Zar''jira - out of combat'),
(38306, 4, 1, 'Ah, another Darkspear Warrior sacrificed on my altar. One by one, you shall all perish.', 14, 0, 100, 0, 0, 0, 0, 39015, 0, 'Zar''jira - out of combat'),
(38306, 4, 2, 'Thrall is not here to save you this time, Darkspear. Slink away to the shadows, for I shall hunt every last one of you down.', 14, 0, 100, 0, 0, 0, 0, 39016, 0, 'Zar''jira - out of combat'),
(38306, 4, 3, 'The tides shall wash away the entire Darkspear Tribe.', 14, 0, 100, 0, 0, 0, 0, 39017, 0, 'Zar''jira - out of combat'),
(38306, 4, 4, 'Troll weaklings, there is no hope. Your death has been foretold by the tides.', 14, 0, 100, 0, 0, 0, 0, 39018, 0, 'Zar''jira - out of combat'),
(38306, 4, 5, 'When I am finished with your tribe, I shall hunt down that orcish cur that saved you from my wrath once before. None will survive.', 14, 0, 100, 0, 0, 0, 0, 39019, 0, 'Zar''jira - out of combat'),
(38306, 4, 6, 'You were fools to leave the safety of your city. Your return to the ocean has assured your demise.', 14, 0, 100, 0, 0, 0, 0, 39020, 0, 'Zar''jira - out of combat');

-- 6. "Not so fast, little troll!" before Zuni falls. The sources: at low health Zuni runs for the fires ("I'll get the fires dis
--    time!"), Zar'jira: "Not so fast, little troll!", kills him, then dies. mop said it as she died (id 31), after Zuni's death had
--    already started. Ours: said at 2 %, where she stops attacking and turns to Zuni (id 30's chain, new link to id 32); her death
--    row 31 now gives the starter's credit itself and links on to id 33 (Zuni's Frost Explosion) as before.
UPDATE `smart_scripts` SET `link` = 32 WHERE `entryorguid` = 38306 AND `source_type` = 0 AND `id` = 30;
UPDATE `smart_scripts` SET `link` = 42 WHERE `entryorguid` = 38306 AND `source_type` = 0 AND `id` = 4;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 38306 AND `source_type` = 0 AND `id` IN (31, 32, 41, 42);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(38306, 0, 31, 33, 6, 0, 100, 0, 0, 0, 0, 0, 33, 38306, 0, 0, 0, 0, 0, 12, 1, 0, 0, 0, 0, 0, 0, 'Zar''jira - On Death - Quest Credit (stored player)'),
(38306, 0, 32, 0, 61, 0, 100, 0, 0, 0, 0, 0, 1, 3, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zar''jira - Between 0-2% Health (Link) - Say Text Line 3 "Not so fast, little troll!"'),
(38306, 0, 41, 0, 1, 0, 100, 0, 20000, 40000, 60000, 120000, 1, 4, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zar''jira - Out of Combat - Say Text Line 4 (taunts; phase 0 only)'),
(38306, 0, 42, 0, 61, 0, 100, 0, 0, 0, 0, 0, 22, 5, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Zar''jira - Linked To Id 4 - Set Phase 5 (scripted opening: no taunts)');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceGroup` = 42 AND `SourceEntry` = 38306 AND `SourceId` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 42, 38306, 0, 0, 101, 1, 0, 0, 0, 0, 0, 0, '', 'Zar''jira - taunts only while she idles (phase 0)');
