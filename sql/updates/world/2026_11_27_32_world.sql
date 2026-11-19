-- Loss Reduction (25179): a rescued Injured Razor Hill Grunt (39270) thanks the player, follows him for a while, says goodbye and runs off
-- toward Razor Hill; lying grunts call for help. Until now a rescued grunt credited and vanished on the spot, an empty "Greetings" window
-- opened on it, and the cries (creature_text group 0) were never said.
-- What the player should see: talk to a lying grunt with the quest in the log -> credit at once, no gossip window; the grunt loses its
-- low-health aura, stands up, says one rescue line (Thank you, $r... / I was supposed to die in battle... / You've saved my life, $c... /
-- For the Warchief! You lead, I will follow.), follows the player 15-20 s, says one farewell line (I feel much better now... / Thank you
-- again. I will return to Razor Hill now. / It was an honor to watch you fight, $n. / You fight well...), runs toward Razor Hill, fades
-- out 10 s later and is gone 5 s after that; it lies at its spot again about two minutes after it vanished (60 s respawn plus the 60 s
-- corpse delay Creature::setDeathState adds to every despawn of a living creature). Lying grunts say a cry every 6-25 s. Talking to a grunt
-- when it has nothing for the player (From Bad to Worse not yet handed in, or Loss Reduction complete or rewarded) opens no window; the
-- grunt says one of its cries instead of an empty "Greetings" page.
-- Sourced: the lines and their order (comment 2010-11-25 [+10]; broadcast_text 39299-39306, cries 39327-39330), "follow the player around
-- for a while" and "they will then run off" (wiki Loss_Reduction Notes), the cry timers (both TDBs: OOC 2-5 s, then 6-25 s).
-- Ours: the follow time (15-20 s), the run-to point (a Razor Hill grunt's spot on the town's east side, 256.6,-4831.3), the 10 s despawn,
-- credit at the moment of rescue, keeping the "!" and the gossip start (neither TDB has a starter; hiding the "!" while the grunt still
-- offers the quest page needs a core change), the cry on an idle click, and the window handling: SEND_GOSSIP_MENU to the grunt itself sends
-- nothing but marks the gossip as handled, so the default menu is not sent after the script (NPCHandler HandleGossipHelloOpcode,
-- SmartAI::OnGossipHello _gossipReturn). While it follows, the grunt has no gossip/questgiver/spellclick flag (a second player cannot click
-- it) and IMMUNE_TO_NPC as well as IMMUNE_TO_PC, so nothing can pull it into a fight (an evade would reload its lying addon). Respawn
-- restores the template npcflag (setDeathState JUST_RESPAWNED) and the creature_addon pose and aura, but not unit_flags (Creature::Respawn
-- calls UpdateEntry only on an entry change), so On Reset removes IMMUNE_TO_NPC again and sets phase 1.
-- The timed part is an action list, not CREATE_TIMED_EVENT: stored timed events stay in the list for the creature's lifetime.
-- The existing quest-taken condition (smart event row 0 -> SourceGroup 1) moves with the gossip row to id 2 (SourceGroup 3); the idle-click
-- row 17 (SourceGroup 18) holds while 25179 is complete or rewarded, OR while From Bad to Worse is not rewarded, so the quest page (25173
-- rewarded, 25179 not taken) and the rescue (25179 incomplete) are never blocked.
DELETE FROM `creature_text` WHERE `CreatureID` = 39270 AND `GroupID` IN (1,2);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(39270,1,0,'Thank you, $r... I was close to death.  May I stay by your side for a moment?',12,0,100,0,0,0,0,39299,0,'Injured Razor Hill Grunt - rescued'),
(39270,1,1,'I was supposed to die in battle... ah well, another day.  I will follow you until I recover.',12,0,100,0,0,0,0,39300,0,'Injured Razor Hill Grunt - rescued'),
(39270,1,2,'You''ve saved my life, $c.  Protect me for a few more moments while I recover.',12,0,100,0,0,0,0,39301,0,'Injured Razor Hill Grunt - rescued'),
(39270,1,3,'For the Warchief!  You lead, I will follow.',12,0,100,0,0,0,0,39302,0,'Injured Razor Hill Grunt - rescued'),
(39270,2,0,'I feel much better now.  For the Horde!',12,0,100,0,0,0,0,39303,0,'Injured Razor Hill Grunt - leaves'),
(39270,2,1,'Thank you again.  I will return to Razor Hill now.',12,0,100,0,0,0,0,39304,0,'Injured Razor Hill Grunt - leaves'),
(39270,2,2,'It was an honor to watch you fight, $n.',12,0,100,0,0,0,0,39305,0,'Injured Razor Hill Grunt - leaves'),
(39270,2,3,'You fight well.  I will leave you now.  Lok''tar ogar!',12,0,100,0,0,0,0,39306,0,'Injured Razor Hill Grunt - leaves');

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 39270;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 39270 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3927000 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(39270,0,0,16,25,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - On Reset - Set Event Phase 1'),
(39270,0,1,0,1,1,100,0,2000,5000,6000,25000,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - OOC (phase 1) - Say Line 0'),
(39270,0,2,3,64,1,100,0,0,0,0,0,0,33,39270,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - On Gossip Hello (phase 1, 25179 incomplete) - Quest Credit'),
(39270,0,3,4,61,0,100,0,0,0,0,0,0,98,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Mark Gossip Handled (no default menu)'),
(39270,0,4,5,61,0,100,0,0,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Close Gossip'),
(39270,0,5,6,61,0,100,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Set Event Phase 2'),
(39270,0,6,7,61,0,100,0,0,0,0,0,0,83,16777219,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Remove Npc Flags Gossip, Questgiver, Spellclick'),
(39270,0,7,8,61,0,100,0,0,0,0,0,0,18,512,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Set Unit Flag Immune To NPC'),
(39270,0,8,9,61,0,100,0,0,0,0,0,0,28,76143,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Remove Aura Low Health'),
(39270,0,9,10,61,0,100,0,0,0,0,0,0,91,7,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Remove Stand State Dead (stand up)'),
(39270,0,10,11,61,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Set React State Passive'),
(39270,0,11,12,61,0,100,0,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Store Invoker'),
(39270,0,12,13,61,0,100,0,0,0,0,0,0,1,1,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Say Line 1 (rescued)'),
(39270,0,13,14,61,0,100,0,0,0,0,0,0,59,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Set Run'),
(39270,0,14,15,61,0,100,0,0,0,0,0,0,29,2,3,0,0,0,0,12,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Follow Stored Player (2 yd, behind)'),
(39270,0,15,0,61,0,100,0,0,0,0,0,0,80,3927000,0,2,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Run Action List (leave)'),
(39270,0,16,0,61,0,100,0,0,0,0,0,0,19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Remove Unit Flag Immune To NPC (respawn does not)'),
(39270,0,17,18,64,1,100,0,0,0,0,0,0,98,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - On Gossip Hello (phase 1, nothing to offer) - Mark Gossip Handled (no window)'),
(39270,0,18,0,61,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Linked - Say Line 0 (cry)'),
(3927000,9,0,0,0,0,100,0,15000,20000,0,0,0,1,2,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Action List - Say Line 2 (leaves)'),
(3927000,9,1,0,0,0,100,0,0,0,0,0,0,69,1,0,0,0,0,0,8,0,0,0,0,256.624,-4831.34,11.1914,0,'Injured Razor Hill Grunt - Action List - Run Toward Razor Hill'),
(3927000,9,2,0,0,0,100,0,0,0,0,0,0,41,10000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Injured Razor Hill Grunt - Action List - Despawn In 10 s');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 39270 AND `SourceId` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,3,39270,0,0,9,0,25179,0,0,0,0,0,'','Injured Razor Hill Grunt - rescue only while Loss Reduction is incomplete'),
(22,18,39270,0,0,47,0,25179,66,0,0,0,0,'','Injured Razor Hill Grunt - idle click: Loss Reduction complete or rewarded'),
(22,18,39270,0,1,8,0,25173,0,0,1,0,0,'','Injured Razor Hill Grunt - idle click: or From Bad to Worse not rewarded');
