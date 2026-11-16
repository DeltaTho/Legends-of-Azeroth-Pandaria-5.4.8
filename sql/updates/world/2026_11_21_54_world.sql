-- Searing Gorge, Twisted Twilight Ties 28060: Hansel's assault (plan E-9; dossier cauldron-finale 28060 rows 1-13, F13, SP-3;
-- rulings R-10, R-16). Needs the Slag Pit Hansel 3132202 of section B (2026_11_21_2x; ship B with or before this file).
--
-- What the player sees: with 28060 in progress and Maltorius and Arkkus both alive, the Slag Pit Hansel offers "Let's do this!
-- Let's take out Maltorius and Arkkus!" (47648); otherwise his text is "Hang tight, $n.  We gotta wait for Maltorius and Arkkus
-- to come back before we can fight 'em." (47650). Picking it: "Now ye're talkin'!  I'll take the Twilight guy.  You focus on
-- the little dwarf." (47649); Hansel runs to Arkkus and punches him off the ledge (88537 Heavy Hands, knock-back); players within
-- 30 yd of Arkkus get his credit and he dies 2 s later; Hansel then helps on Maltorius. When Maltorius dies, players within
-- 40 yd get his credit, Hansel yells "Now that's what ye call heavy hands!" (47653) and walks back to Scrange.
-- Sourced: option, lines, the punch spell and Arkkus going over the side, "credit only when close" (comment 2010-11-29 [+14]),
-- Hansel helping and returning (wiki notes; 2010-11-25 [+4]). Ours (user question 8): Arkkus' death 2 s after the punch, the
-- 30 / 40 yd radii (the 40 yd row also keeps Hansel's damage from costing players Maltorius' credit:
-- IsDamageEnoughForLootingAndReward), the gating, the 8 yd reach check and the 15 s give-up.
--
-- Fixes against the draft:
-- - Hansel's faction 1475 and Maltorius' / Arkkus' 14 are neutral to each other both ways (hostile.py): Unit::IsValidAttackTarget
--   (CvC) refuses the attack, so Hansel would have stood still and the punch never landed. During the assault his faction is
--   734 (hostile.py: friendly to Alliance and Horde players; 14 -> 734 hostile, so the fight is valid; friendly both ways with
--   the Slag Pit Dark Irons' 54, so his run pulls no packs). The review proposed 113, but 54 -> 113 is hostile (hostile.py).
--   Not UNIT_FLAG_PVP_ATTACKABLE (the Badlands lesson: the 5.4.8 client treats a 0x8 creature by PvP rules). The reset puts
--   faction 1475 back (SET_FACTION 0 = template); a respawn does too (SmartAI::JustAppeared).
-- - The punch waits for Hansel to be within 8 yd of Arkkus (a RANGE event on his victim, every 1 s, phase 2) instead of a fixed
--   6 s; if he has not reached him after 15 s, he goes for Maltorius without the punch. Every row of the actionlist and of the
--   fight is phase-gated (phases 2 = going for Arkkus, 3 = on Maltorius; reset = phase 0), so a list cut short by an early end
--   does nothing after the reset (SmartScript::UpdateTimer skips rows out of phase).
-- - The reset restores both immunities (768: entering combat removes IMMUNE_TO_PC, Unit::SetInCombatState), the faction and the
--   gossip and quest flags; the "Maltorius down" rows run only during the assault, so a Maltorius killed without Hansel does not
--   make him yell and evade.
-- - Hansel-C is staged invisible (60921): his two lines go only to the player who started the assault (TextRange 5; the yell to
--   the stored invoker), not to players who cannot see him. Group 0 is used by no other Hansel row.
-- - Entry 14627 had AIName '' so the per-guid rows would never load: AIName 'SmartAI' (the Thorium Point Hansel 185728 has no
--   rows and keeps his quests and gossip).
-- Nothing here relies on an evade clearing an aura (SmartAI keeps self-cast auras through an evade).

UPDATE `creature_template` SET `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` = 14627;
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (14621, 47460);

-- texts
DELETE FROM `creature_text` WHERE `CreatureID` = 14627 AND `GroupID` = 1;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(14627,1,0,'Now ye''re talkin''!  I''ll take the Twilight guy.  You focus on the little dwarf.',12,0,100,0,0,0,47649,5,'Hansel Heavyhands - assault');
UPDATE `creature_text` SET `TextRange` = 5 WHERE `CreatureID` = 14627 AND `GroupID` = 0;
DELETE FROM `npc_text` WHERE `ID` = 3132420;
INSERT INTO `npc_text` (`ID`,`text0_0`,`text0_1`,`BroadcastTextID0`,`lang0`,`Probability0`) VALUES
(3132420,'Hang tight, $n.  We gotta wait for Maltorius and Arkkus to come back before we can fight ''em.','',47650,0,1);
DELETE FROM `gossip_menu` WHERE `MenuID` = 5963 AND `TextID` = 3132420;
INSERT INTO `gossip_menu` (`MenuID`,`TextID`,`VerifiedBuild`) VALUES (5963,3132420,0);

-- option and conditions
DELETE FROM `gossip_menu_option` WHERE `MenuID` = 5963 AND `OptionID` = 0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(5963,0,0,'Let''s do this!  Let''s take out Maltorius and Arkkus!',47648,1,1,0,0,0,0,NULL,0,0);
DELETE FROM `conditions` WHERE (`SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 5963 AND `SourceEntry` = 0)
  OR (`SourceTypeOrReferenceId` = 14 AND `SourceGroup` = 5963 AND `SourceEntry` = 3132420)
  OR (`SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 88537)
  OR (`SourceTypeOrReferenceId` = 22 AND `SourceEntry` = -3132202);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,5963,0,0,0, 9,0,28060,0,0,0,0,0,'','Hansel option - Twisted Twilight Ties in progress'),
(15,5963,0,0,0,31,1,3,14627,3132202,0,0,0,'','Hansel option - only the Slag Pit Hansel'),
(15,5963,0,0,0,29,1,14621,60,0,0,0,0,'','Hansel option - Maltorius alive nearby'),
(15,5963,0,0,0,29,1,47460,60,0,0,0,0,'','Hansel option - Arkkus alive nearby'),
(14,5963,3132420,0,0,31,1,3,14627,3132202,0,0,0,'','Hansel text Hang tight - Slag Pit Hansel ...'),
(14,5963,3132420,0,0,29,1,14621,60,0,1,0,0,'','... and Maltorius is dead'),
(14,5963,3132420,0,1,31,1,3,14627,3132202,0,0,0,'','Hansel text Hang tight - Slag Pit Hansel ...'),
(14,5963,3132420,0,1,29,1,47460,60,0,1,0,0,'','... or Arkkus is dead'),
(13,3,88537,0,0,31,0,3,47460,0,0,0,0,'','Heavy Hands - Twilight-Lord Arkkus only');

-- Hansel (Slag Pit copy only), Arkkus, Maltorius
DELETE FROM `smart_scripts` WHERE `entryorguid` = -3132202 AND `source_type` = 0;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (1462700, 4746000) AND `source_type` = 9;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (47460, 14621) AND `source_type` = 0 AND `id` IN (10,11,12);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-3132202,0,0,1,62,0,100,0,5963,0,0,0,0,72,0,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - On Option - Close Gossip'),
(-3132202,0,1,2,61,0,100,0,0,0,0,0,0,64,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - On Option - Store the Player'),
(-3132202,0,2,0,61,0,100,0,0,0,0,0,0,80,1462700,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - On Option - Run Assault'),
(-3132202,0,3,4,9,2,100,0,0,8,1000,1000,0,11,88537,0,0,0,0,0,2,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - Arkkus within 8 yd - Heavy Hands'),
(-3132202,0,4,5,61,0,100,0,0,0,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - Punched - Phase 3'),
(-3132202,0,5,0,61,0,100,0,0,0,0,0,0,49,0,0,0,0,0,0,19,14621,60,0,0,0,0,0,0,'Hansel (Slag Pit) - Punched - Attack Maltorius'),
(-3132202,0,6,7,38,6,100,0,1,1,0,0,0,1,0,0,0,0,0,0,12,1,0,0,0,0,0,0,0,'Hansel (Slag Pit) - Maltorius Down (assault) - Yell Heavy Hands to the Player'),
(-3132202,0,7,0,61,0,100,0,0,0,0,0,0,24,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - Maltorius Down (assault) - Evade Home'),
(-3132202,0,8,9,25,0,100,0,0,0,0,0,0,18,768,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - On Reset - Immune to Players and NPCs again'),
(-3132202,0,9,10,61,0,100,0,0,0,0,0,0,2,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - On Reset - Own Faction back'),
(-3132202,0,10,0,61,0,100,0,0,0,0,0,0,81,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel (Slag Pit) - On Reset - Gossip and Quest Flags back'),
(1462700,9,0,0,0,0,100,0,0,0,0,0,0,83,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel - Assault - Busy (no gossip)'),
(1462700,9,1,0,0,0,100,0,0,0,0,0,0,1,1,0,0,0,0,0,7,0,0,0,0,0,0,0,0,'Hansel - Assault - Say Now ye''re talkin'' to the Player'),
(1462700,9,2,0,0,0,100,0,0,0,0,0,0,2,734,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel - Assault - Faction 734 (fights faction 14, friendly to players and Dark Irons)'),
(1462700,9,3,0,0,0,100,0,0,0,0,0,0,19,512,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel - Assault - May fight NPCs'),
(1462700,9,4,0,0,0,100,0,0,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel - Assault - Phase 2'),
(1462700,9,5,0,0,2,100,0,0,0,0,0,0,49,0,0,0,0,0,0,19,47460,60,0,0,0,0,0,0,'Hansel - Assault - Attack Arkkus'),
(1462700,9,6,0,0,2,100,0,15000,15000,0,0,0,49,0,0,0,0,0,0,19,14621,60,0,0,0,0,0,0,'Hansel - Assault - Arkkus not reached in 15 s - Attack Maltorius'),
(1462700,9,7,0,0,2,100,0,0,0,0,0,0,22,3,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Hansel - Assault - Arkkus not reached in 15 s - Phase 3'),
(47460,0,10,11,8,0,100,0,88537,0,0,0,0,33,47460,0,0,0,0,0,17,0,30,0,0,0,0,0,0,'Twilight-Lord Arkkus - Punched Off - Credit to Players within 30 yd'),
(47460,0,11,0,61,0,100,0,0,0,0,0,0,80,4746000,2,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight-Lord Arkkus - Punched Off - Fall'),
(4746000,9,0,0,0,0,100,0,2000,2000,0,0,0,37,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Twilight-Lord Arkkus - Fall - Die'),
(14621,0,10,11,6,0,100,0,0,0,0,0,0,33,14621,0,0,0,0,0,17,0,40,0,0,0,0,0,0,'Overseer Maltorius - On Death - Credit to Players within 40 yd'),
(14621,0,11,0,61,0,100,0,0,0,0,0,0,45,1,1,0,0,0,0,10,3132202,14627,0,0,0,0,0,0,'Overseer Maltorius - On Death - Tell Hansel');
