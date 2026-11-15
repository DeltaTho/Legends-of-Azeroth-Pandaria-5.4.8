-- Badlands, The Day that Deathwing Came: The Real Story (27714): Lucien's story (plan F-3)
-- Sourced: the texts and their order (BroadcastText 47121-47177, 46595; the wiki's transcript), the two buttons ("1 grow, 2
-- search": comments 2011-08-21, 2010-11-24), Search Cloud's target (87777 effect 0 is a nearby-entry search: the clouds 47097).
-- Ours: the text types, the ScriptNames (zone_badlands_stories.cpp).
-- Relies on section B: B-6 (the nine clouds in phase 295; the static Cowardly Deathwing 162681 deleted), B-7 (DONT_SAVE on 87737,
-- 86723, 87790), B-8 (47080 template level 47; the script sets the player's level anyway).

UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_lucien_story', `spell1` = 87743, `spell2` = 87777 WHERE `entry` = 47080;
UPDATE `gameobject_template` SET `AIName` = '', `ScriptName` = 'go_badlands_tddc_sun' WHERE `entry` = 206550;

DELETE FROM `spell_script_names` WHERE `spell_id` IN (87743, 87777, 87790);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(87743, 'spell_badlands_shrink_the_world'),
(87777, 'spell_badlands_search_cloud'),
(87790, 'spell_badlands_summon_the_sun');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 87777;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
  `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 87777, 0, 0, 31, 0, 3, 47097, 0, 0, 0, 0, '', 'Search Cloud searches a Cloud');

DELETE FROM `creature_text` WHERE `CreatureID` = 47080;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`,
  `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(47080, 0, 0, 'First of all, it wasn''t sunny out.  It was cloudy when Deathwing appeared.', 42, 0, 100, 0, 0, 0, 0, 47121, 0, 'Lucien (TDDC 2) - story 1'),
(47080, 1, 0, 'The cowardly dragon must have seen me, because he turned away and flew into the clouds.', 42, 0, 100, 0, 0, 0, 0, 47122, 0, 'Lucien (TDDC 2) - story 2'),
(47080, 2, 0, '"I''ll find you in those clouds, you worm!" I yelled.  "And then I''ll throw you to Kalimdor!"', 42, 0, 100, 0, 0, 0, 0, 47124, 0, 'Lucien (TDDC 2) - story 3'),
(47080, 3, 0, 'I''ll find you in those clouds, you worm!', 14, 0, 100, 0, 0, 0, 0, 47125, 5, 'Lucien (TDDC 2) - yell'),
(47080, 4, 0, 'And then I''ll throw you to Kalimdor!', 14, 0, 100, 0, 0, 0, 0, 47126, 5, 'Lucien (TDDC 2) - yell'),
(47080, 5, 0, 'Luckily, I had been tinkering with my world-shrinking device.', 42, 0, 100, 0, 0, 0, 0, 47123, 0, 'Lucien (TDDC 2) - story 4'),
(47080, 6, 0, 'I decided to keep shrinking the world until I could reach the clouds.$b$b|TInterface\\Icons\\inv_helmet_47.blp:32|t', 42, 0, 100, 0, 0, 0, 0, 47127, 0, 'Lucien (TDDC 2) - story 5'),
(47080, 7, 0, 'Once the world was small enough, I started to hunt for Deathwing in the clouds.$b$b|TInterface\\Icons\\spell_frost_arcticwinds.blp:32|t', 42, 0, 100, 0, 0, 0, 0, 47154, 0, 'Lucien (TDDC 2) - grown'),
(47080, 8, 0, 'Where are you, dragon?', 12, 0, 100, 0, 0, 0, 0, 47170, 5, 'Lucien (TDDC 2) - search'),
(47080, 8, 1, 'Are you hiding in this cloud?', 12, 0, 100, 0, 0, 0, 0, 47171, 5, 'Lucien (TDDC 2) - search'),
(47080, 8, 2, 'Lucien''s gonna getcha!', 12, 0, 100, 0, 0, 0, 0, 47172, 5, 'Lucien (TDDC 2) - search'),
(47080, 8, 3, 'Surprise, dragon!  Aw, shucks.', 12, 0, 100, 0, 0, 0, 0, 47173, 5, 'Lucien (TDDC 2) - search'),
(47080, 8, 4, 'Where you at?', 12, 0, 100, 0, 0, 0, 0, 47174, 5, 'Lucien (TDDC 2) - search'),
(47080, 8, 5, 'He can''t have gotten far...', 12, 0, 100, 0, 0, 0, 0, 47175, 5, 'Lucien (TDDC 2) - search'),
(47080, 8, 6, 'When I find that dragon, I''m gonna throw him to Kalimdor.', 12, 0, 100, 0, 0, 0, 0, 47176, 5, 'Lucien (TDDC 2) - search'),
(47080, 8, 7, 'I hate you, Deathwing.', 12, 0, 100, 0, 0, 0, 0, 47177, 5, 'Lucien (TDDC 2) - search'),
(47080, 9, 0, 'I had searched every cloud, but I couldn''t find Deathwing.', 42, 0, 100, 0, 0, 0, 0, 47163, 0, 'Lucien (TDDC 2) - five clouds'),
(47080, 10, 0, 'It was then that I realized: he was hiding in the sun.  I looked up.', 42, 0, 100, 0, 0, 0, 0, 47164, 0, 'Lucien (TDDC 2) - the sun'),
(47080, 11, 0, 'The sun burned me bad, but I got my hands around his slimy neck.', 42, 0, 100, 0, 0, 0, 0, 47166, 0, 'Lucien (TDDC 2) - caught'),
(47080, 12, 0, 'I summoned all my strength, faced west, and threw him to Kalimdor.', 42, 0, 100, 0, 0, 0, 0, 47167, 0, 'Lucien (TDDC 2) - thrown'),
(47080, 13, 0, 'Hmm... I didn''t go this direction.  I think I''m telling the story wrong.', 42, 0, 100, 0, 0, 0, 0, 46595, 0, 'Lucien (TDDC 2) - left the Badlands');
