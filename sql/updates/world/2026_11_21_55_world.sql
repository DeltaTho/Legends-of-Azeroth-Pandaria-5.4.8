-- Searing Gorge, From Whence He Came 28062 (plan E-10, E-11; dossier cauldron-finale 28062 rows 1-13, F16-F18).
-- Ship-order (plan rules 1-2): this file ships whole (AUTO_COMPLETE alone would let a plain kill complete the quest), and A-19 /
-- A-12 / B-2's 88582 row ship in the same build.
--
-- E-10 28062 had no ender and no AUTO_COMPLETE: nobody could hand it in, and Welcome to the Brotherhood 28064 (its
--      RewardNextQuest, auto-accept) was never offered. Flags | 0x10000 as both TDBs (0x8200008 -> 0x8210008): it completes from
--      the quest log ("There is a pop-up upon completion", 2010-11-25 replies [+2]); Player::GetNextQuest then offers 28064.
-- E-11 Archduke Calcinder 47462 died normally and the kill alone completed the quest. Now he cannot drop below 1 hp; on aggro
--      "The flames of Ragnaros will burn you all." (50366); at half health the boss emote "%s is weakened!  Banish him now!"
--      (47654); using the Consecrated Tripetricine 62925 (88547, now only on him) while he is at or below half health: "NOOOOOO!
--      THIS CANNOT BE!  I... AM... IMMORTAL...!" (47656), the Banish Effect bubble (88545, 8 s), he is out of the fight and
--      vanishes 4 s later, and the banish credit goes to the item's user and to the loot recipient's group in reward range. Kept
--      hitting at 1 hp (after a 5 s grace in which the banish still works): "Fools!  You cannot defeat me!  I will only return again..." (47657) and he vanishes without
--      credit (back after the spawn's 60 s). The static Calcinder Banish Credit 313222 goes (a copy of 88549's summon, which the
--      item's FORCE_CAST still makes him summon for 60 s).
-- Sourced: the texts, the 50 % / 1 hp / banish moments, the 50 % threshold ("damaged to less than half"), 1 hp as the moment
-- to banish and the vanish on further attacks, no kill, the bubble (wiki;
-- comments 2010-11-25 [+31], 2010-12-31 [+12], 2011-01-24 [+8]). Ours: the on-aggro moment of 50366 (dossier 28062 row
-- 4), the credit to the group in range as well as the user, the 4 s, the 5 s grace at 1 hp, out of the fight (immune, passive) after the banish.
-- Event phases (see also below): 1 = the fight (set on every reset), 2 = banished; nothing but the banish chain runs in
-- phase 2, so no "Fools!" during the 4 s after a banish. Their linked rows carry phase mask 0 and the phase change is the chain's
-- second-to-last row: this core phase-checks linked rows too (SmartScript::ProcessEvent), so a mask-1 row after a change to
-- phase 2 would never run (review B1).
-- 1 hp (walk W1): reaching 1 hp no longer makes him vanish. The wiki makes 1 hp the moment an over-levelled player banishes him
-- ("he vanishes only if you keep attacking"): at 1 hp he enters phase 3, a 5 s grace (ours) in which the banish still works and
-- hits do nothing more; then phase 4, in which the next damage (DAMAGED, read before the 1 hp floor zeroes it, SmartAI::DamageTaken)
-- brings "Fools! ..." and the vanish without credit. Phase masks: fight 1, grace 3 (4), at 1 hp 4 (8), banished 2; his spells,
-- the 50 % emote and the banish run in 1, 3 and 4 (mask 13). A one-shot from full health fires the 50 % emote and the 1 hp step
-- together. The UPDATE_IC timer of row 12 does not run outside phase 3 (SmartScript::UpdateTimer), and every reset restarts it.
-- After the banish he stops fighting for his last 4 s (review W1): his spell rows 0-3 run in phase 1 only, auto attack and
-- combat movement go off and COMBAT_STOP (203) drops his victim; passive keeps him from picking another, immune to players stops
-- theirs. The reset rows switch auto attack and combat movement back on (SmartAI keeps both through a reset). The banish's immunity flags are taken off again on reset (the respawn keeps
-- flags a SmartAI set). Nothing here relies on an evade clearing an aura (SmartAI keeps self-cast auras through an evade; 88545
-- lasts 8 s and he is gone after 4).

-- E-10
UPDATE `quest_template` SET `Flags` = `Flags` | 0x10000 WHERE `ID` = 28062;

-- E-11
DELETE FROM `creature_text` WHERE `CreatureID` = 47462 AND `GroupID` = 3;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(47462,3,0,'NOOOOOO!  THIS CANNOT BE!  I... AM... IMMORTAL...!',14,0,100,0,0,0,47656,0,'Archduke Calcinder - banished');

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 47462;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 47462 AND `source_type` = 0 AND `id` BETWEEN 4 AND 30;
-- his spells (rows 0-3, the 2026_10_29 abilities rows) only in the fight phase: none after the banish
UPDATE `smart_scripts` SET `event_phase_mask` = 13 WHERE `entryorguid` = 47462 AND `source_type` = 0 AND `id` BETWEEN 0 AND 3;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(47462,0,4,5,25,0,100,0,0,0,0,0,0,42,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - On Reset - Cannot Drop Below 1 HP'),
(47462,0,5,6,61,0,100,0,0,0,0,0,0,19,768,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - On Reset - Attackable'),
(47462,0,6,7,61,0,100,0,0,0,0,0,0,20,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - On Reset - Auto Attack On'),
(47462,0,7,8,61,0,100,0,0,0,0,0,0,21,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - On Reset - Combat Movement On'),
(47462,0,8,0,61,0,100,0,0,0,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - On Reset - Phase 1 (the fight)'),
(47462,0,9,0,4,0,100,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - On Aggro - Say 0 (50366)'),
(47462,0,10,0,2,13,100,1,0,50,0,0,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - At 50% - Emote Weakened (once per fight)'),
(47462,0,11,0,2,1,100,1,0,1,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Down to 1 hp - Phase 3 (5 s grace: banish him now)'),
(47462,0,12,0,0,4,100,1,5000,5000,0,0,0,22,4,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - 5 s at 1 hp - Phase 4 (more damage makes him vanish)'),
(47462,0,13,14,8,13,100,0,88547,0,0,0,0,1,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Hit by Consecrated Tripetricine - Yell Banished'),
(47462,0,14,15,61,0,100,0,0,0,0,0,0,11,88545,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Banish Effect'),
(47462,0,15,16,61,0,100,0,0,0,0,0,0,18,768,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Out of the Fight (immune)'),
(47462,0,16,17,61,0,100,0,0,0,0,0,0,8,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Passive'),
(47462,0,17,18,61,0,100,0,0,0,0,0,0,20,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Auto Attack Off'),
(47462,0,18,19,61,0,100,0,0,0,0,0,0,21,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Combat Movement Off'),
(47462,0,19,20,61,0,100,0,0,0,0,0,0,203,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Combat Stop (no victim)'),
(47462,0,20,21,61,0,100,0,0,0,0,0,0,33,47462,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Credit to the Banisher'),
(47462,0,21,22,61,0,100,0,0,0,0,0,0,33,47462,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Credit to the Loot Recipient and his Group'),
(47462,0,22,23,61,0,100,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Phase 2 (spells, 1% and banish rows off)'),
(47462,0,23,0,61,0,100,0,0,0,0,0,0,41,4000,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Banished - Vanish'),
(47462,0,24,25,32,8,100,1,1,10000000,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Hit Again at 1 hp - Yell Fools'),
(47462,0,25,26,61,0,100,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Hit Again at 1 hp - Phase 2 (nothing more)'),
(47462,0,26,0,61,0,100,0,0,0,0,0,0,41,500,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Archduke Calcinder - Hit Again at 1 hp - Vanish (no credit)');
-- the banish only counts while he is weakened (SmartAI condition on id 13: SourceGroup = id + 1; ConditionTarget 1 = Calcinder)
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 47462 AND `SourceId` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22,14,47462,0,0,38,1,50,4,0,0,0,0,'','Archduke Calcinder - banish only at or below 50% health');
-- the item works only on Calcinder (88547 effect 0, TARGET_UNIT_NEARBY_ENTRY)
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 88547;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,88547,0,0,31,0,3,47462,0,0,0,0,'','Consecrated Tripetricine - targets Archduke Calcinder only');

-- the static banish bunny (a copy of 88549's summon)
DELETE FROM `creature_addon` WHERE `guid` = 313222;
DELETE FROM `creature` WHERE `guid` = 313222 AND `id` = 47464;
