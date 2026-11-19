-- Shikrik's letter (Rune-Inscribed Parchment 9568, page_text 2461) was cut off after its first words ("Lok-tar, $gbrother:sister",
-- without the closing semicolon, so the gender token did not even resolve). Sourced: the full text, identical in TDB 12.1.0 and
-- TDB 4.4.2.
UPDATE `page_text` SET `text` = 'Lok''tar, $g brother:sister;. The elements beckon you closer and bid me to show you the path of the shaman. The spirits of our ancestors watch from beyond and swell with pride knowing you have joined our ranks.$B$BWhen you are ready, seek me out near the entrance to the Den. It is there that I will be training others of our kind. Until then, may the wind be at your back.$B$B-Shikrik, Shaman Trainer', `next_page` = 0 WHERE `entry` = 2461;
