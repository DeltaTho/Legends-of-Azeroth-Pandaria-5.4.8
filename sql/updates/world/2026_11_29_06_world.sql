-- Northern Barrens S1 (_06): harpies and centaurs - the harpy chain order, Verog's chain, Regthar's stray enders, Barak's
-- flags, Hezrul's Bloodguards, drop rates.
-- (plan.md section 1 `_06`; dossier D: D-867-1, D-867-2, D-851-1, D-850-1, D-850-2 / D-851-3, D-852-1, D-855-1, D-851-2,
-- D-851-4.)
--
-- SOURCED: 867 and 875 are offered together and either unlocks 876 (comments 2014-02-13, 2014-05-17; Wowhead series step 4
-- parallel; RewardNextQuest 876 on both); 851 follows 14072 (both TDBs; beta comment 2010-07-07); Regthar ends neither 850
-- nor 851 (both TDBs: 34841 / 34638 only; the completion texts name them); Barak 3394 has unit_flags 0 in both TDBs (mop
-- STUNNED | 0x20000000: every cast failed SPELL_FAILED_STUNNED); Hezrul's two static Bloodguards walk with him (both TDBs:
-- no summon rows); Bracers / Harpy Talons drop at 80 % (Bloodguard 90 %) in both TDBs, less grindy than mop's 50 / 28-30 /
-- 38 / 11; killing other Kolkar no longer summons Verog in Cataclysm (comment 2010-11-24 [+3]); only Wyneth does.
-- OURS: ExclusiveGroup of 867 / 875 left 0 (the TDB's positive group 867 would make them exclusive, against the comments);
-- Verog's 2-minute out-of-combat life (was until killed; Wyneth respawns every 300 s); the formation's distances/angles.
-- Checked, not changed: Ta'jari's greeting (menu 10536, npc_text 14574 = BroadcastText 34852) is the 2011 quote already.
-- Note: 867 reaches players without a breadcrumb only with `_14` (G16 clears 28877 / 29094's NextQuestID 867).

-- D-867-1: Harpy Raiders and Harpy Lieutenants side by side; either leads to Serena Bloodfeather.
UPDATE `quest_template_addon` SET `NextQuestID`=876 WHERE `ID`=867;
UPDATE `quest_template_addon` SET `PrevQuestID`=0, `NextQuestID`=876 WHERE `ID`=875;
UPDATE `quest_template_addon` SET `PrevQuestID`=0 WHERE `ID`=876;

-- D-851-1: Verog the Dervish follows Flushing Out Verog.
UPDATE `quest_template_addon` SET `PrevQuestID`=14072 WHERE `ID`=851;

-- D-850-2 / D-851-3: Regthar is not an ender of 850 / 851.
DELETE FROM `creature_questender` WHERE `id`=3389 AND `quest` IN (850,851);

-- D-850-1: Barak Kodobane casts again.
UPDATE `creature_template` SET `unit_flags`=0 WHERE `entry`=3394;

-- D-852-1: Hezrul's two Bloodguards walk his path; no more Bloodguards summoned 290 yd away on every respawn.
DELETE FROM `smart_scripts` WHERE `entryorguid`=3396 AND `source_type`=0 AND `id` IN (0,1);
DELETE FROM `creature_formations` WHERE `leaderGUID`=264181 OR `memberGUID` IN (264181,264182,264183);
INSERT INTO `creature_formations` (`leaderGUID`,`memberGUID`,`dist`,`angle`,`groupAI`,`point_1`,`point_2`) VALUES
(264181,264181,0,0,514,0,0),(264181,264182,3,90,514,0,0),(264181,264183,3,270,514,0,0);

-- D-855-1 / D-867-2: drop rates as both TDBs.
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-80 WHERE `item`=5030 AND `entry` IN (3272,3273,3274,3275,3394,3395,3396,3397,5837,5838,5841,9456,9523,9524);
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-90 WHERE `item`=5030 AND `entry`=44170;
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-80 WHERE `item`=5064 AND `entry` IN (3276,3277,3278,3279,3280,3452);

-- D-851-2: Kolkar Pack Runners and Kolkar Bloodchargers no longer summon Verog on death (3397 carried the same 3 % death
-- line + summon rows; review S5-S6 W2: S5's 13995 waves use 3397).
DELETE FROM `smart_scripts` WHERE `entryorguid`=3274 AND `source_type`=0 AND `id` IN (1,2);
DELETE FROM `smart_scripts` WHERE `entryorguid`=3397 AND `source_type`=0 AND `id` IN (2,3);

-- D-851-4: Verog, summoned by Wyneth, leaves after 2 minutes out of combat.
UPDATE `smart_scripts` SET `action_param2`=4, `action_param3`=120000 WHERE `entryorguid`=34846 AND `source_type`=0 AND `id`=1 AND `action_type`=12;
