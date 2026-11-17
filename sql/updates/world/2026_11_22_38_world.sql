-- Burning Steppes, Black Tooth Hovel: Into the Black Tooth Hovel 28239 / 28432 line, Grunt Work 28245 / 28433 (push + Boot Spiders),
-- Strategic Cuts 28246 / 28434 (log hand-in, gating), The Kodocaller's Horn 28252 / 28435 (could never be handed in; hostile kodo
-- left behind) and Taking the Horn For Ourselves 28253 / 28436 (needs both). Strategic Cuts' group and Kodocaller's hand-in ship in
-- this one file (plan section 4).
--
-- 1. F-B2: "Don't forget to put on that disguise!" (broadcast 48439) from Colonel Troteman (Alliance) / Eitrigg (Horde) when Into the
--    Black Tooth Hovel is accepted (wiki 28239 / 28432 notes). Ours: the hook (SmartAI on accept at Keeshan 48109 / Eitrigg 48568)
--    and TextRange 5: the three stand in per-faction phases at Chiselgrip, so only the accepting player hears it.
-- 2. F-S1: accepting Grunt Work pushes Strategic Cuts with Troteman's / Eitrigg's portrait (wiki 28245 notes "Troteman radios in";
--    28246 2010-11-30 [+3]); only if the player never had it. The TDBs' extra starters (Gorlop, Othana, Timan) are the sniff of that
--    push, not copied. Troteman / Eitrigg still offer it by hand (gated below).
-- 3. F-S2: Strategic Cuts AUTO_ACCEPT|AUTO_COMPLETE (both TDBs 589824: handed in from the log), offered once Grunt Work is taken
--    (PrevQuestID -28245, both TDBs 28245); Strategic Cuts + Kodocaller as an each-of group (ExclusiveGroup -28246 / -28434, shared
--    NextQuestID 28253 / 28436) so Taking the Horn comes only when both are handed in (28436 [+5] rysah, wharris guide; the first
--    one shows "You don't meet the requirements", as retail).
-- 4. F-K1: Kodocaller AUTO_COMPLETE (both TDBs 8454152 / 8716296; wiki "end = automatic"); it had no ender and no log hand-in, so it
--    could never be turned in. Completion text from both TDBs (mop had no quest_offer_reward row).
-- 5. F-K2: a kodo that turned hostile (faction 14, invincible at 1 hp) and evades goes back to its template faction (40 since
--    2026_11_22_36) and loses the invincibility (28252 [+15] Landon + reply). Ours: the rows. Also ours: the hostile branch puts the
--    kodo in event phase 1 and the "submits at half health" row runs only in that phase, so a kodo fought without the horn (an
--    undisguised player or bot) is not walked off at 50 %; reset (evade, respawn) returns it to phase 0.
-- 6. F-G1 data: the static Boot Spider 166276 next to Kaoshin goes (neither TDB spawns 48106: they come from polishing, C++
--    go_burning_steppes_blackrock_boots, ScriptName set here).

-- 1
DELETE FROM `creature_text` WHERE `CreatureID` IN (48110,48568) AND `GroupID`=0;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(48110,0,0,'Don''t forget to put on that disguise!',12,0,100,0,0,0,0,48439,5,'Colonel Troteman - Into the Black Tooth Hovel accepted'),
(48568,0,0,'Don''t forget to put on that disguise!',12,0,100,0,0,0,0,48439,5,'Eitrigg - Into the Black Tooth Hovel accepted');
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (48109,48568);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (48109,48568) AND `source_type`=0 AND `id`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48109,0,0,0,19,0,100,0,28239,0,0,0,0,1,0,0,0,0,0,0,19,48110,15,0,0,0,0,0,0,'John J. Keeshan - On Quest Into the Black Tooth Hovel Accepted - Colonel Troteman Say Line 0 (to the player)'),
(48568,0,0,0,19,0,100,0,28432,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Eitrigg - On Quest Into the Black Tooth Hovel Accepted - Say Line 0 (to the player)');

-- 2
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=48085;
DELETE FROM `smart_scripts` WHERE `entryorguid`=48085 AND `source_type`=0 AND `id` IN (0,1);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48085,0,0,0,19,0,100,0,28245,0,0,0,0,7,28246,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Quartermaster Kaoshin - On Quest Grunt Work Accepted - Add Quest Strategic Cuts'),
(48085,0,1,0,19,0,100,0,28433,0,0,0,0,7,28434,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Quartermaster Kaoshin - On Quest Grunt Work Accepted - Add Quest Strategic Cuts');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=48085 AND `SourceId`=0 AND `SourceGroup` IN (1,2);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,1,48085,0,0,47,0,28246,1,0,0,0,0,'','Kaoshin - push Strategic Cuts only if the player never took it'),
(22,2,48085,0,0,47,0,28434,1,0,0,0,0,'','Kaoshin - push Strategic Cuts only if the player never took it');

-- 3
UPDATE `quest_template` SET `Flags`=589824 WHERE `ID` IN (28246,28434);
UPDATE `quest_template_addon` SET `PrevQuestID`=-28245, `ExclusiveGroup`=-28246 WHERE `ID`=28246;
UPDATE `quest_template_addon` SET `PrevQuestID`=-28433, `ExclusiveGroup`=-28434 WHERE `ID`=28434;
UPDATE `quest_template_addon` SET `ExclusiveGroup`=-28246 WHERE `ID`=28252;
UPDATE `quest_template_addon` SET `ExclusiveGroup`=-28434 WHERE `ID`=28435;

-- 4
UPDATE `quest_template` SET `Flags`=8454152 WHERE `ID`=28252;
UPDATE `quest_template` SET `Flags`=8716296 WHERE `ID`=28435;
DELETE FROM `quest_offer_reward` WHERE `ID` IN (28252,28435);
INSERT INTO `quest_offer_reward` (`ID`,`Emote1`,`Emote2`,`Emote3`,`Emote4`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`EmoteDelay4`,`RewardText`,`VerifiedBuild`) VALUES
(28252,0,0,0,0,0,0,0,0,'Your job is complete.  You take a look at the horn that they gave you, and decide to hang onto it for a while longer.',15595),
(28435,0,0,0,0,0,0,0,0,'Your job is complete.  You take a look at the horn that they gave you, and decide to hang onto it for a while longer.',15595);

-- 5
UPDATE `smart_scripts` SET `event_phase_mask`=1 WHERE `entryorguid`=48111 AND `source_type`=0 AND `id`=2;
DELETE FROM `smart_scripts` WHERE (`entryorguid`=48111 AND `source_type`=0 AND `id` IN (8,9)) OR (`entryorguid`=4811102 AND `source_type`=9 AND `id`=3);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(48111,0,8,9,7,0,100,0,0,0,0,0,0,2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackrock War Kodo - On Evade - Restore Template Faction'),
(48111,0,9,0,61,0,100,0,0,0,0,0,0,42,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackrock War Kodo - Linked - Clear Invincibility HP Level'),
(4811102,9,3,0,0,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Blackrock War Kodo - On Script - Set Event Phase 1 (horned, hostile)');

-- 6
DELETE FROM `creature` WHERE `guid`=166276 AND `id`=48106;
DELETE FROM `creature_addon` WHERE `guid`=166276;
UPDATE `gameobject_template` SET `AIName`='', `ScriptName`='go_burning_steppes_blackrock_boots' WHERE `entry`=206977;
