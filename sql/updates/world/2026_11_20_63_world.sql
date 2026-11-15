-- Badlands, The Day that Deathwing Came: What Really Happened (27715): Martek's story (plan F-4)
-- Sourced: the texts and their order (BroadcastText 47198-47216, 47222-47230, 47192, 46595; the wiki's transcript and comments),
-- the admirers' gossip option "Hop in, baby." 47188 on menu 12204 (both TDBs), Speed Boost on the bar (wiki, comment 2012-02-25),
-- 87912's target (a nearby-entry dummy: Deathwing 46471). Ours: the text types, which goodbye line each admirer says (the blood
-- elf's own line from the comment npc 47126 2014-09-27), the ScriptNames (zone_badlands_stories.cpp).
-- Relies on section B: B-6 (the pillar Deathwing 161582 and the 23 Cave In Triggers in phase 310 and idle, 47128 / 47129 trigger
-- flag), B-7 (DONT_SAVE on 86675), B-8 (46501 template level 47; the script sets the player's level anyway).

UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_martek_story', `spell1` = 87851 WHERE `entry` = 46501;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_tddc_admirer', `gossip_menu_id` = 12204 WHERE `entry` IN (47123, 47124, 47125, 47126);
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_tddc_cave_in_trigger' WHERE `entry` = 47128;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_tddc_cave_in_stalker' WHERE `entry` = 47129;

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 12204 AND `OptionID` = 0;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcflag`,
  `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(12204, 0, 0, 'Hop in, baby.', 47188, 1, 1, 0, 0, 0, 0, NULL, 0, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 87912;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
  `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 87912, 0, 0, 31, 0, 3, 46471, 0, 0, 0, 0, '', 'TDDC 3: Punch Deathwing hits Deathwing');

DELETE FROM `creature_text` WHERE `CreatureID` IN (46497, 47123, 47124, 47125, 47126, 47157);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`,
  `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(46497, 0, 0, 'The day that Deathwing came, blood rained from the skies.', 42, 0, 100, 0, 0, 0, 0, 47198, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 1, 0, 'I believe I was showing my motorcycle to some hot babes at the time.', 42, 0, 100, 0, 0, 0, 0, 47199, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 2, 0, 'After Deathwing appeared, they became quite frightened, but I only had room to rescue one of them.', 42, 0, 100, 0, 0, 0, 0, 47200, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 3, 0, 'Obviously, I picked the orc.', 42, 0, 100, 0, 0, 0, 0, 47201, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 4, 0, 'Obviously, I picked the human.', 42, 0, 100, 0, 0, 0, 0, 47202, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 5, 0, 'Obviously, I picked the night elf.', 42, 0, 100, 0, 0, 0, 0, 47203, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 6, 0, 'Obviously, I picked the blood elf.', 42, 0, 100, 0, 0, 0, 0, 47204, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 7, 0, 'We rode off down the canyon, careful to avoid falling rocks.', 42, 0, 100, 0, 0, 0, 0, 47205, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 8, 0, 'When I reached the end of the canyon, I remembered that my motorcycle could fly.', 42, 0, 100, 0, 0, 0, 0, 47206, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 9, 0, 'That would have been helpful to know earlier.', 42, 0, 100, 0, 0, 0, 0, 47207, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 10, 0, 'I flew to the top of the pillar located just north of the canyon.', 42, 0, 100, 0, 0, 0, 0, 47208, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 11, 0, 'During the flight, I shared a tender moment with the lovely orc.', 42, 0, 100, 0, 0, 0, 0, 47213, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 12, 0, 'During the flight, I shared a tender moment with the attractive human.', 42, 0, 100, 0, 0, 0, 0, 47214, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 13, 0, 'During the flight, I shared a tender moment with the grateful young night elf.', 42, 0, 100, 0, 0, 0, 0, 47215, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 14, 0, 'During the flight, I shared a tender moment with the strapping blood elf.', 42, 0, 100, 0, 0, 0, 0, 47216, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 15, 0, 'Atop the pillar, I saw him: Deathwing.  The time for the ultimate confrontation had arrived.', 42, 0, 100, 0, 0, 0, 0, 47209, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 16, 0, 'Hey, stop it Theldurin!  This is my story!', 42, 0, 100, 0, 0, 0, 0, 47210, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 17, 0, 'Cut it out guys!  Quit interrupting!', 42, 0, 100, 0, 0, 0, 0, 47211, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 18, 0, 'Fine.  You don''t get to hear about how I beat Deathwing in a knife fight.  Your loss.', 42, 0, 100, 0, 0, 0, 0, 47212, 0, 'Martek the Awesome (TDDC 3) - story'),
(46497, 19, 0, 'Hmm... I didn''t go this direction.  I think I''m telling the story wrong.', 42, 0, 100, 0, 0, 0, 0, 46595, 0, 'Martek the Awesome (TDDC 3) - story'),
(47123, 0, 0, 'Woo hoo!  Martek picked me!', 12, 0, 100, 0, 0, 0, 0, 47230, 5, 'Night Elf Admirer - picked'),
(47123, 1, 0, 'No!  I love you, Martek!', 12, 0, 100, 0, 0, 0, 0, 47222, 5, 'Night Elf Admirer - left behind'),
(47123, 1, 1, 'Why?  Why are you leaving me?', 12, 0, 100, 0, 0, 0, 0, 47223, 5, 'Night Elf Admirer - left behind'),
(47123, 1, 2, 'I loved you, Martek!', 12, 0, 100, 0, 0, 0, 0, 47224, 5, 'Night Elf Admirer - left behind'),
(47123, 1, 3, 'I''m just happy to have known you while I lived, Martek.', 12, 0, 100, 0, 0, 0, 0, 47225, 5, 'Night Elf Admirer - left behind'),
(47123, 1, 4, 'Goodbye, Martek.', 12, 0, 100, 0, 0, 0, 0, 47226, 5, 'Night Elf Admirer - left behind'),
(47123, 1, 5, 'I can die in peace, knowing that my last few moments were with Martek.', 12, 0, 100, 0, 0, 0, 0, 47228, 5, 'Night Elf Admirer - left behind'),
(47124, 0, 0, 'Woo hoo!  Martek picked me!', 12, 0, 100, 0, 0, 0, 0, 47230, 5, 'Human Admirer - picked'),
(47124, 1, 0, 'No!  I love you, Martek!', 12, 0, 100, 0, 0, 0, 0, 47222, 5, 'Human Admirer - left behind'),
(47124, 1, 1, 'Why?  Why are you leaving me?', 12, 0, 100, 0, 0, 0, 0, 47223, 5, 'Human Admirer - left behind'),
(47124, 1, 2, 'I loved you, Martek!', 12, 0, 100, 0, 0, 0, 0, 47224, 5, 'Human Admirer - left behind'),
(47124, 1, 3, 'I''m just happy to have known you while I lived, Martek.', 12, 0, 100, 0, 0, 0, 0, 47225, 5, 'Human Admirer - left behind'),
(47124, 1, 4, 'Goodbye, Martek.', 12, 0, 100, 0, 0, 0, 0, 47226, 5, 'Human Admirer - left behind'),
(47124, 1, 5, 'I can die in peace, knowing that my last few moments were with Martek.', 12, 0, 100, 0, 0, 0, 0, 47228, 5, 'Human Admirer - left behind'),
(47125, 0, 0, 'Woo hoo!  Martek picked me!', 12, 0, 100, 0, 0, 0, 0, 47230, 5, 'Orc Admirer - picked'),
(47125, 1, 0, 'No!  I love you, Martek!', 12, 0, 100, 0, 0, 0, 0, 47222, 5, 'Orc Admirer - left behind'),
(47125, 1, 1, 'Why?  Why are you leaving me?', 12, 0, 100, 0, 0, 0, 0, 47223, 5, 'Orc Admirer - left behind'),
(47125, 1, 2, 'I loved you, Martek!', 12, 0, 100, 0, 0, 0, 0, 47224, 5, 'Orc Admirer - left behind'),
(47125, 1, 3, 'I''m just happy to have known you while I lived, Martek.', 12, 0, 100, 0, 0, 0, 0, 47225, 5, 'Orc Admirer - left behind'),
(47125, 1, 4, 'Goodbye, Martek.', 12, 0, 100, 0, 0, 0, 0, 47226, 5, 'Orc Admirer - left behind'),
(47125, 1, 5, 'I can die in peace, knowing that my last few moments were with Martek.', 12, 0, 100, 0, 0, 0, 0, 47228, 5, 'Orc Admirer - left behind'),
(47126, 0, 0, 'Woo hoo!  Martek picked me!', 12, 0, 100, 0, 0, 0, 0, 47230, 5, 'Blood Elf Admirer - picked'),
(47126, 1, 0, 'I''ll never forget that magical summer we shared, Martek.', 12, 0, 100, 0, 0, 0, 0, 47229, 5, 'Blood Elf Admirer - left behind'),
(47157, 0, 0, 'I''m gonna punch that dragon in the face!', 14, 0, 100, 0, 0, 0, 0, 47192, 5, 'Theldurin (TDDC 3) - interrupts');
