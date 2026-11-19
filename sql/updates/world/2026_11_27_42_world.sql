-- Ender rows of old class and profession quests on Razor Hill and Sen'jin NPCs, removed with the 4.0 class-quest cleanup (all carry Flags
-- 0x4000; Taming the Beast has MinLevel 85): nobody starts any of them - no creature or gameobject starter, no item with startquest, no spell
-- that starts a quest (checked 2026-11-18). Plan ruling R19: delete such enders, as A-5 does in the Valley. Nothing visible changes.
-- Un'Thuwa 5880: 1883 Speak with Un'thuwa, 1884 Ju-Ju Heaps. Ula'elek 6408: 1839, 1842, 1843 (Brutal Gauntlets). Thotar 3171: 6062, 6082, 6083
-- Taming the Beast (the taming rods 19681-19683 only complete them). Tai'jin 3706: 5648, 5649 (Garments). Telf Joolam 5900: 1464 Fire Sapta,
-- 1525 Call of Fire. These NPCs keep their trainer and gossip roles.
DELETE FROM `creature_questender` WHERE (`id` = 5880 AND `quest` IN (1883, 1884)) OR (`id` = 6408 AND `quest` IN (1839, 1842, 1843))
  OR (`id` = 3171 AND `quest` IN (6062, 6082, 6083)) OR (`id` = 3706 AND `quest` IN (5648, 5649)) OR (`id` = 5900 AND `quest` IN (1464, 1525));
