-- Tomb of the Watchers: The Warden 46768 and The Sentinel 46769 wake for Ancient Protectors 27793 / 27887.
--
-- What the player sees: only a player with Ancient Protectors in progress reads the quest text ("Judging by its color, this
-- must be The Warden ..." / "This red statue looks a lot like the Sentinel's pawn ...") and gets the option "<Place the pawn
-- in the indentation.>"; everyone else reads the inert text and has no option. On the option the gossip closes, the golem
-- loses its freeze aura, casts Ancient Protectors: Awaken 87147 (its stretching visual), says "Active." / "Online.", and about
-- 3 s later turns hostile and attacks that player. In the fight the Warden casts Shockwave 83370 and the Sentinel Heave 83368.
-- After an evade (reset fires at its start and again at home) and after a respawn it is friendly and frozen again.
-- Sourced: the texts and option (wiki notes; npc_text 17072-17075, BroadcastText 46824, 50356, 50359), the stretch and the
--   attack (comment 2010-12-08 [+8]: "stretches its arms, takes a couple of seconds"), the abilities (Wowhead abilities tabs),
--   87147 (DBC, unreferenced until now).
-- Ours: 3 s, the ability timers, the conditions (CONDITION_QUESTSTATE 47 mask 8 = in progress, Alliance or Horde quest).
-- Kept: unit_flags2 DISABLE_TURN (client display only; the server still aims the cone at the victim), respawn 60 s.
-- Ours, the woken golem's way back: from the option until it is in combat it is passive (it attacks nobody but the stored
--   player, so a bystander is not pulled); entering combat makes it aggressive again. If it is still out of combat 6 s after
--   the option (the player left, died, logged out, or the attack did not start), it evades: the reset rows make it friendly,
--   frozen and aggressive again at its spot. In combat without a victim the core evades it anyway (CreatureAI::UpdateVictim).
--   Walks: wake and leave -> no combat -> evade at 6 s -> friendly; wake and die before the 3 s -> attack refused (dead) -> same;
--   wake and die in the fight -> no victim left -> evade -> reset; a second player standing near while the first leaves is never
--   attacked (passive, out of combat) and can wake it himself after the reset.

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (46768, 46769) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(46768, 0, 0, 1, 62, 0, 100, 0, 12146, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - On gossip option selected - Close gossip'),
(46768, 0, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, 28, 87134, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Remove Guardian Freeze Aura'),
(46768, 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 87147, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Cast Ancient Protectors: Awaken'),
(46768, 0, 3, 4, 61, 0, 100, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Say Line 0'),
(46768, 0, 4, 5, 61, 0, 100, 0, 0, 0, 0, 0, 0, 64, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Store invoker'),
(46768, 0, 5, 6, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Phase 1 (woken)'),
(46768, 0, 6, 7, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Passive until in combat'),
(46768, 0, 7, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 67, 1, 3000, 3000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Timed event 1 in 3 s'),
(46768, 0, 8, 9, 59, 0, 100, 0, 1, 0, 0, 0, 0, 2, 470, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - On timed event 1 - Set faction 470'),
(46768, 0, 9, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 12, 1, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Attack stored invoker'),
(46768, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - On aggro - Aggressive'),
(46768, 0, 11, 0, 0, 0, 100, 0, 5000, 7000, 8000, 12000, 0, 11, 83370, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - In combat - Cast Shockwave'),
(46768, 0, 12, 13, 25, 0, 100, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - On reset - Template faction'),
(46768, 0, 13, 14, 61, 0, 100, 0, 0, 0, 0, 0, 0, 75, 87134, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Add Guardian Freeze Aura'),
(46768, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Linked - Aggressive'),
(46768, 0, 15, 0, 1, 1, 100, 0, 6000, 6000, 2000, 2000, 0, 24, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Warden - Out of combat 6 s after waking (phase 1) - Evade (back friendly and frozen)'),
(46769, 0, 0, 1, 62, 0, 100, 0, 12147, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - On gossip option selected - Close gossip'),
(46769, 0, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 0, 28, 87134, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Remove Guardian Freeze Aura'),
(46769, 0, 2, 3, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 87147, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Cast Ancient Protectors: Awaken'),
(46769, 0, 3, 4, 61, 0, 100, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Say Line 0'),
(46769, 0, 4, 5, 61, 0, 100, 0, 0, 0, 0, 0, 0, 64, 1, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Store invoker'),
(46769, 0, 5, 6, 61, 0, 100, 0, 0, 0, 0, 0, 0, 22, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Phase 1 (woken)'),
(46769, 0, 6, 7, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Passive until in combat'),
(46769, 0, 7, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 67, 1, 3000, 3000, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Timed event 1 in 3 s'),
(46769, 0, 8, 9, 59, 0, 100, 0, 1, 0, 0, 0, 0, 2, 470, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - On timed event 1 - Set faction 470'),
(46769, 0, 9, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 12, 1, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Attack stored invoker'),
(46769, 0, 10, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - On aggro - Aggressive'),
(46769, 0, 11, 0, 0, 0, 100, 0, 5000, 7000, 8000, 12000, 0, 11, 83368, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - In combat - Cast Heave'),
(46769, 0, 12, 13, 25, 0, 100, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - On reset - Template faction'),
(46769, 0, 13, 14, 61, 0, 100, 0, 0, 0, 0, 0, 0, 75, 87134, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Add Guardian Freeze Aura'),
(46769, 0, 14, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 8, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Linked - Aggressive'),
(46769, 0, 15, 0, 1, 1, 100, 0, 6000, 6000, 2000, 2000, 0, 24, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'The Sentinel - Out of combat 6 s after waking (phase 1) - Evade (back friendly and frozen)');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` IN (14, 15) AND `SourceGroup` IN (12146, 12147);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 12146, 0, 0, 0, 47, 0, 27793, 8, 0, 0, 0, 0, '', 'The Warden - pawn option while Ancient Protectors (A) is in progress'),
(15, 12146, 0, 0, 1, 47, 0, 27887, 8, 0, 0, 0, 0, '', 'The Warden - pawn option while Ancient Protectors (H) is in progress'),
(15, 12147, 0, 0, 0, 47, 0, 27793, 8, 0, 0, 0, 0, '', 'The Sentinel - pawn option while Ancient Protectors (A) is in progress'),
(15, 12147, 0, 0, 1, 47, 0, 27887, 8, 0, 0, 0, 0, '', 'The Sentinel - pawn option while Ancient Protectors (H) is in progress'),
(14, 12146, 17074, 0, 0, 47, 0, 27793, 8, 0, 0, 0, 0, '', 'The Warden - indentation text while Ancient Protectors (A) is in progress'),
(14, 12146, 17074, 0, 1, 47, 0, 27887, 8, 0, 0, 0, 0, '', 'The Warden - indentation text while Ancient Protectors (H) is in progress'),
(14, 12146, 17072, 0, 0, 47, 0, 27793, 8, 0, 1, 0, 0, '', 'The Warden - inert text unless Ancient Protectors (A) is in progress'),
(14, 12146, 17072, 0, 0, 47, 0, 27887, 8, 0, 1, 0, 0, '', 'The Warden - inert text unless Ancient Protectors (H) is in progress'),
(14, 12147, 17075, 0, 0, 47, 0, 27793, 8, 0, 0, 0, 0, '', 'The Sentinel - pawn text while Ancient Protectors (A) is in progress'),
(14, 12147, 17075, 0, 1, 47, 0, 27887, 8, 0, 0, 0, 0, '', 'The Sentinel - pawn text while Ancient Protectors (H) is in progress'),
(14, 12147, 17073, 0, 0, 47, 0, 27793, 8, 0, 1, 0, 0, '', 'The Sentinel - old statue text unless Ancient Protectors (A) is in progress'),
(14, 12147, 17073, 0, 0, 47, 0, 27887, 8, 0, 1, 0, 0, '', 'The Sentinel - old statue text unless Ancient Protectors (H) is in progress');
