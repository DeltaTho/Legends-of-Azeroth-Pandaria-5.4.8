-- The orc and troll wind rider chain of Razor Hill: Meats to Orgrimmar (6365) -> Ride to Orgrimmar (6384) -> Doras the Wind Rider Master (6385)
-- -> Return to Razor Hill (6386). Tauren were offered it (AllowableRaces 162 = orc, tauren, troll), and each of the three middle NPCs was also a
-- starter of the quest he ends: Burok (41140) of 6365, Gryshka (6929) of 6384, Doras (3310) of 6385 - take and hand in on the spot.
-- Sourced: TDB 4.4.2 6365 AllowableRaces 130 (orc, troll); Wowhead MoP "Races: Orc, Troll"; comments 2011-03-07 [+3], 2013-05-22 [+3] (tauren
-- cannot get it); starters in both TDBs and on Wowhead MoP: 6365 Zargh and Grimtak, 6384 Devrak and Burok, 6385 Gryshka, 6386 Doras.
-- 6384-6386 keep their races (any in the TDBs); the chain is gated by 6365. Enders unchanged (Wowhead MoP lists Devrak and Zargh too).
UPDATE `quest_template` SET `AllowableRaces` = 130 WHERE `ID` = 6365;
DELETE FROM `creature_queststarter` WHERE (`id` = 41140 AND `quest` = 6365) OR (`id` = 6929 AND `quest` = 6384) OR (`id` = 3310 AND `quest` = 6385);
