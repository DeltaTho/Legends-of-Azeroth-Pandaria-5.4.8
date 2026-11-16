-- Searing Gorge: Lunk's followers on Spider Rider, Cranky Little Dwarfs and Rendan's Weakness (plan D-3, D-4, D-5).
-- Sourced: log hand-in of 27959 / 27983 (TDB 4.4.2 / 12.1.0 Flags with AUTO_COMPLETE, no ender, followers npcflag 0; Wowhead
-- comments 2010-11-25 [+9], 2010-11-26 reply [+5]); the kill scold lines (broadcast texts 47698-47703, wiki quotes, comments
-- 2010-12-23, 2012-06-15 [+4]); a relog brings Lunk back (2010-12-02 [+23]); the spider/steamsmith Lunk comes for holders of the
-- other Lunk quest too (2012-01-28); 47332 removes its own aura 88291 (DBC).
-- Ours: the followers' C++ (npc_sg_lunk_follower: 4 yd behind-left, unattackable, passive, dismissed outside the zone, brought
-- back within 5 s), the scold mechanism (one line per 20 s, owner only), the extra venom/ride lines' grouping, giver chance 100 %
-- (user rule: the less grindy value; mop had 50 %).

-- The followers: C++ instead of their SmartAI (store target / follow / credit on data / despawn on a reward at them)
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_sg_lunk_follower', `npcflag`=0 WHERE `entry` IN (47281,47333,47430);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (47281,47333,47430) AND `source_type`=0;

-- Their summon spells: summon / lifecycle script, and not saved at logout (a relog re-casts them through spell_area)
DELETE FROM `spell_script_names` WHERE `spell_id` IN (88166,88292,88450) AND `ScriptName` IN ('spell_sg_lunk_summon','spell_sg_lunk_summon_aura');
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(88166,'spell_sg_lunk_summon'),(88166,'spell_sg_lunk_summon_aura'),
(88292,'spell_sg_lunk_summon'),(88292,'spell_sg_lunk_summon_aura'),
(88450,'spell_sg_lunk_summon'),(88450,'spell_sg_lunk_summon_aura');
DELETE FROM `spell_custom_attribute` WHERE `spell` IN (88166,88292,88450) AND `attribute`='SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(88166,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Lunk (Spider Rider): re-cast by spell_area at login'),
(88292,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Lunk (Cranky Little Dwarfs): re-cast by spell_area at login'),
(88450,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Summon Lunk (Rendan''s Weakness): re-cast by spell_area at login');

-- Hand-in from the quest log (TDB Flags), no follower ender
UPDATE `quest_template` SET `Flags`=1376264 WHERE `ID`=27959;
UPDATE `quest_template` SET `Flags`=1114120 WHERE `ID`=27983;
DELETE FROM `creature_questender` WHERE `id` IN (47281,47333) AND `quest` IN (27959,27983);

-- Lunk's lines go to his owner only (a private NPC); the kill scold for all three, the remaining venom lines and the ride laugh
UPDATE `creature_text` SET `TextRange`=5 WHERE `CreatureID` IN (47281,47333,47430);
DELETE FROM `creature_text` WHERE `CreatureID` IN (47281,47333,47430) AND `GroupID`=2;
DELETE FROM `creature_text` WHERE `CreatureID`=47281 AND ((`GroupID`=1 AND `ID` BETWEEN 3 AND 5) OR `GroupID`=3);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(47281,2,0,'Why you do that?  Why you kill?',12,0,100,0,0,0,0,47698,5,'Lunk - kill scold'),
(47281,2,1,'You stop killing now!  Lunk doesn''t like!',12,0,100,0,0,0,0,47699,5,'Lunk - kill scold'),
(47281,2,2,'No!  No kill!',12,0,100,0,0,0,0,47700,5,'Lunk - kill scold'),
(47281,2,3,'You hurt Lunk''s feelings when you kill.',12,0,100,1,0,0,0,47701,5,'Lunk - kill scold'),
(47281,2,4,'Please, no kill when Lunk is around.',12,0,100,0,0,0,0,47702,5,'Lunk - kill scold'),
(47281,2,5,'Oh no!  Why do you kill it?',12,0,100,0,0,0,0,47703,5,'Lunk - kill scold'),
(47333,2,0,'Why you do that?  Why you kill?',12,0,100,0,0,0,0,47698,5,'Lunk - kill scold'),
(47333,2,1,'You stop killing now!  Lunk doesn''t like!',12,0,100,0,0,0,0,47699,5,'Lunk - kill scold'),
(47333,2,2,'No!  No kill!',12,0,100,0,0,0,0,47700,5,'Lunk - kill scold'),
(47333,2,3,'You hurt Lunk''s feelings when you kill.',12,0,100,1,0,0,0,47701,5,'Lunk - kill scold'),
(47333,2,4,'Please, no kill when Lunk is around.',12,0,100,0,0,0,0,47702,5,'Lunk - kill scold'),
(47333,2,5,'Oh no!  Why do you kill it?',12,0,100,0,0,0,0,47703,5,'Lunk - kill scold'),
(47430,2,0,'Why you do that?  Why you kill?',12,0,100,0,0,0,0,47698,5,'Lunk - kill scold'),
(47430,2,1,'You stop killing now!  Lunk doesn''t like!',12,0,100,0,0,0,0,47699,5,'Lunk - kill scold'),
(47430,2,2,'No!  No kill!',12,0,100,0,0,0,0,47700,5,'Lunk - kill scold'),
(47430,2,3,'You hurt Lunk''s feelings when you kill.',12,0,100,1,0,0,0,47701,5,'Lunk - kill scold'),
(47430,2,4,'Please, no kill when Lunk is around.',12,0,100,0,0,0,0,47702,5,'Lunk - kill scold'),
(47430,2,5,'Oh no!  Why do you kill it?',12,0,100,0,0,0,0,47703,5,'Lunk - kill scold'),
(47281,1,3,'See?  No kill spider for venom.  Just ride.',12,0,100,0,0,0,0,47413,5,'Lunk - spider ride'),
(47281,1,4,'Here, I got you this.',12,0,100,0,0,0,0,47415,5,'Lunk - spider ride'),
(47281,1,5,'Here, you can scrape venom off Lunk''s tummy.',12,0,100,0,0,0,0,47416,5,'Lunk - spider ride'),
(47281,3,0,'Ha ha ha!',12,0,100,0,0,0,0,47410,5,'Lunk - spider ride');

-- The givers: every killing blow on a spider / steamsmith brings Lunk, also for those who hold or did the other Lunk quest
UPDATE `smart_scripts` SET `event_chance`=100 WHERE `entryorguid` IN (5840,5856) AND `source_type`=0 AND `id`=0;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=1 AND `SourceEntry`=5840 AND `ConditionValue1`=27959;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceGroup`=1 AND `SourceEntry`=5856 AND `ConditionValue1`=27983;
UPDATE `smart_scripts` SET `action_param1`=88291, `comment`='Lunk - On Quest Accepted - Remove Summon Lunk Aura' WHERE `entryorguid`=47332 AND `source_type`=0 AND `id`=0;

-- The Spider Rider giver: private to the spider's killer, following him for the spell's 2 minutes, passive and unattackable
-- (C++ spell_sg_summon_lunk_giver; sourced: he "follows you around for a minute or two", 2010-11-25 [+6]; private, as the
-- steamsmith giver 47332 already is, and so no other player's giver blocks a killer's within 100 yd: ours)
DELETE FROM `spell_script_names` WHERE `spell_id`=88152 AND `ScriptName`='spell_sg_summon_lunk_giver';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (88152,'spell_sg_summon_lunk_giver');
