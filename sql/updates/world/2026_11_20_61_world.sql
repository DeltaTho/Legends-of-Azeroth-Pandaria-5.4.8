-- Badlands, The Day that Deathwing Came (27713): Theldurin's story (plan F-2)
-- Sourced: the texts and their order (BroadcastText 46563-46582, 46595; the wiki's transcript), Theldurin's one button (86561,
-- "precisely one ability", the wiki), both TDBs' unit_flags 0 for 46471. Ours: the text types (boss whispers to the player,
-- the teller's yells and punch lines personal), the walls' autoClose (60 s; retail had 0: a wall stayed open until respawn),
-- 46471 keeps IMMUNE_TO_NPC (so the elementals never fight him), the ScriptNames (zone_badlands_stories.cpp).
-- Relies on section B: B-6 (elementals, the trench Deathwing 161640 and the 77 walls in phase 293, 161640 idle), B-7 (DONT_SAVE
-- on 86557 / 86637), B-8 (46466 template level 47; the script sets the player's level anyway).

UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_theldurin_story', `spell1` = 86561 WHERE `entry` = 46466;

-- Deathwing in human form: passive and still; Theldurin's punch reaches him (NON_ATTACKABLE 0x2 and IMMUNE_TO_PC 0x100 off)
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_tddc_deathwing', `unit_flags` = 33280 WHERE `entry` = 46471;

-- Gol' Durned Rock Heap: a punched wall closes again after 60 s for the next teller
UPDATE `gameobject_template` SET `Data2` = 60000 WHERE `entry` = 206108;

DELETE FROM `spell_script_names` WHERE `spell_id` = 86561;
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (86561, 'spell_badlands_theldurins_fist');

DELETE FROM `creature_text` WHERE `CreatureID` = 46466;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`,
  `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(46466, 0, 0, 'I remember it well.  It was a bright, shiny day...', 42, 0, 100, 0, 0, 0, 0, 46563, 0, 'Theldurin (TDDC 1) - story 1'),
(46466, 1, 0, 'I was just mindin'' my own business, when all of a sudden, Deathwing appeared!', 42, 0, 100, 0, 0, 0, 0, 46564, 0, 'Theldurin (TDDC 1) - story 2'),
(46466, 2, 0, 'I said to myself, "I''m gonna punch that dragon in the face!"', 42, 0, 100, 0, 0, 0, 0, 46565, 0, 'Theldurin (TDDC 1) - story 3'),
(46466, 3, 0, 'I''m gonna punch that dragon in the face!', 14, 0, 100, 0, 0, 0, 0, 46566, 5, 'Theldurin (TDDC 1) - yell'),
(46466, 4, 0, 'Unfortunately, the cataclysm had knocked loose a bunch of angry elementals.', 42, 0, 100, 0, 0, 0, 0, 46567, 0, 'Theldurin (TDDC 1) - story 4'),
(46466, 5, 0, '"You dang-blasted rock elementals!", I said.  "I''ll punch you too!"', 42, 0, 100, 0, 0, 0, 0, 46568, 0, 'Theldurin (TDDC 1) - story 5'),
(46466, 6, 0, 'You dang-blasted rock elementals!', 14, 0, 100, 0, 0, 0, 0, 46569, 5, 'Theldurin (TDDC 1) - yell'),
(46466, 7, 0, 'I''ll punch you too!', 14, 0, 100, 0, 0, 0, 0, 46570, 5, 'Theldurin (TDDC 1) - yell'),
(46466, 8, 0, 'Get punched!', 12, 0, 100, 0, 0, 0, 0, 46575, 5, 'Theldurin (TDDC 1) - punch'),
(46466, 8, 1, 'Taste my fist!', 12, 0, 100, 0, 0, 0, 0, 46576, 5, 'Theldurin (TDDC 1) - punch'),
(46466, 8, 2, 'P-p-punch!', 12, 0, 100, 0, 0, 0, 0, 46577, 5, 'Theldurin (TDDC 1) - punch'),
(46466, 8, 3, 'I''m coming for you, Deathwing!', 12, 0, 100, 0, 0, 0, 0, 46578, 5, 'Theldurin (TDDC 1) - punch'),
(46466, 8, 4, 'Theldurin the Lost!', 12, 0, 100, 0, 0, 0, 0, 46579, 5, 'Theldurin (TDDC 1) - punch'),
(46466, 8, 5, 'I''m going to punch that dragon right in the face!', 12, 0, 100, 0, 0, 0, 0, 46580, 5, 'Theldurin (TDDC 1) - punch'),
(46466, 8, 6, 'Face punch!', 12, 0, 100, 0, 0, 0, 0, 46581, 5, 'Theldurin (TDDC 1) - punch'),
(46466, 8, 7, 'Take that, dangerous enemy!', 12, 0, 100, 0, 0, 0, 0, 46582, 5, 'Theldurin (TDDC 1) - punch'),
(46466, 9, 0, 'Hmm... I didn''t go this direction.  I think I''m telling the story wrong.', 42, 0, 100, 0, 0, 0, 0, 46595, 0, 'Theldurin (TDDC 1) - left the Badlands');
