-- Badlands: a logout in the middle of a "The Day that Deathwing Came" story leaves nothing of it behind: no story phase, no
-- sunny sky or weather, no detection of the rock elementals after the next login.
--
-- Ours (code traced): the story vehicles are the player's summons and go at logout, but the start spells' auras are self-cast,
-- not channelled and not vehicle auras, so Aura::CanBeSaved (SpellAuras.cpp:1389-1427) saves them: a relog would put the
-- player on foot in phase 293 / 295 / 310 under the story sky, seeing (and killing for credit) the story actors. The story
-- scripts remove these auras on every normal end; this covers the logout.
--   86557 TDDC 1: Summon Theldurin (phase 293 + screen effect), 87737 TDDC 2: Summon Lucien (phase 295 + screen effect),
--   86675 TDDC 3: Summon Martek's Hog (phase 310 + weather), 86637 See Quest Invis 1 and 87785 See Quest Invis 1 - Vehicle
--   (the elementals' detection), 87790 TDDC 2: Summon the Sun (2 min screen effect), 86723 TDDC 2: Weather.

DELETE FROM `spell_custom_attribute` WHERE `spell` IN (86557, 87737, 86675, 86637, 87785, 87790, 86723) AND `attribute` = 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';
INSERT INTO `spell_custom_attribute` (`spell`, `attribute`, `comment`) VALUES
(86557, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'TDDC 1: Summon Theldurin - phase 293 + sky, not across logout'),
(87737, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'TDDC 2: Summon Lucien - phase 295 + sky, not across logout'),
(86675, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'TDDC 3: Summon Martek''s Hog - phase 310 + weather, not across logout'),
(86637, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'See Quest Invis 1 (TDDC 1 elementals), not across logout'),
(87785, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'See Quest Invis 1 - Vehicle (TDDC 1 elementals), not across logout'),
(87790, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'TDDC 2: Summon the Sun (2 min screen effect), not across logout'),
(86723, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'TDDC 2: Weather, not across logout');
