-- Burning Steppes, A Needle in a Hellhole 28254 / 28427 and A Perfect Costume 28202-28205 / 28428-28431 (Thelaron Direneedle 48001,
-- Tailor's Table 206947).
--
-- 1. Needle only after Chiselgrip 28184 / 28426 (wiki previous = Chiselgrip; 48001 2010-11-29 [+14], [+5] Saurdeloth; Eitrigg
--    48568 2011-03-08 [+11] "28426 must be completed before he will show up"). mop: no prerequisite at all. Ours: expressed as
--    PrevQuestID (neither quest had a quest_template_addon row).
-- 2. The costume only after Needle (48001 [+5] Saurdeloth; wiki previous = Needle). mop: PrevQuestID 0.
-- 3. Spurious givers (neither TDB has them): Thelaron offered the Alliance Needle (taken and handed in at him without Keeshan),
--    Eitrigg offered the troll costume 28431.
-- 4. The recipe puzzle moves to C++ (zone_burning_steppes.cpp: go_burning_steppes_tailors_table, npc_burning_steppes_thelaron_
--    direneedle). The old SmartAI took any combination as perfect and set Thelaron's gossip flag for every player at once: its rows
--    go, AIName '' and the ScriptNames are set. Thelaron keeps his template npcflag 3 (the SmartAI took GOSSIP off on respawn).
-- 5. The thread options of menu 12374 lead to menu 12375 "You have gathered your supplies. Bring them to Thelaron..." (text 17387,
--    present in mop and never shown: ActionMenuID 0 and the SmartAI closed the gossip). Sourced: wiki 28428 notes.
-- 6. Thelaron's six reaction lines (broadcast 48235-48240 exist; mop had group 0 "This... this is perfect!" only), say as group 0.
--    Group numbers are ours (the C++ picks them): 1 = 48235 + n.
-- Sourced: order, texts, recipes (wiki reaction tables, 28428 2012-07-01 [+6] jtbalogh). Ours: who may use the table, the 10-minute
-- memory of a choice (both in the C++ header comment), the group numbers.

-- 1 + 2 + 3
DELETE FROM `quest_template_addon` WHERE `ID` IN (28254,28427);
INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`) VALUES (28254,28184),(28427,28426);
UPDATE `quest_template_addon` SET `PrevQuestID`=28254 WHERE `ID` IN (28202,28203,28204,28205);
UPDATE `quest_template_addon` SET `PrevQuestID`=28427 WHERE `ID` IN (28428,28429,28430,28431);
DELETE FROM `creature_queststarter` WHERE (`id`=48001 AND `quest`=28254) OR (`id`=48568 AND `quest`=28431);

-- 4
DELETE FROM `smart_scripts` WHERE (`entryorguid`=48001 AND `source_type`=0) OR (`entryorguid`=206947 AND `source_type`=1);
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_burning_steppes_thelaron_direneedle', `npcflag`=3 WHERE `entry`=48001;
UPDATE `gameobject_template` SET `AIName`='', `ScriptName`='go_burning_steppes_tailors_table' WHERE `entry`=206947;

-- 5
UPDATE `gossip_menu_option` SET `ActionMenuID`=12375 WHERE `MenuID`=12374 AND `OptionID` IN (0,1,2,3);

-- 6
DELETE FROM `creature_text` WHERE `CreatureID`=48001 AND `GroupID` BETWEEN 1 AND 6;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(48001,1,0,'There''s not nearly enough hide here to make a proper disguise.',12,0,100,0,0,0,0,48235,0,'Thelaron Direneedle - A Perfect Costume - not enough hide'),
(48001,2,0,'Alright, this is far too much mud.  Your disguise will be too dark and gloppy.',12,0,100,0,0,0,0,48236,0,'Thelaron Direneedle - A Perfect Costume - too much mud'),
(48001,3,0,'You''ve brought me way too much worg-hide, $n!',12,0,100,0,0,0,0,48237,0,'Thelaron Direneedle - A Perfect Costume - too much hide'),
(48001,4,0,'We''re going to need more mud to properly color your disguise.',12,0,100,0,0,0,0,48238,0,'Thelaron Direneedle - A Perfect Costume - not enough mud'),
(48001,5,0,'I''ve got the proper amounts of mud and hide, but not enough thread to hold it together.',12,0,100,0,0,0,0,48239,0,'Thelaron Direneedle - A Perfect Costume - not enough thread'),
(48001,6,0,'Ach!  Everything else looks good, but there''s too much thread!',12,0,100,0,0,0,0,48240,0,'Thelaron Direneedle - A Perfect Costume - too much thread');
