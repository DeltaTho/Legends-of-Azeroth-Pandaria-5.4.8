-- Searing Gorge: Set Them Ablaze! (28029): three towers burned before their brazier was used.
-- Reported by the user in play (2026-11-18): "the southeastern tower was ablaze before setting it", then a third tower the
-- same; the eastern tower showed no fire.
-- The classic / Wrath layout (AzerothCore base data: gameobject 16735-16743, event_scripts 3201-3204) is one Tower Fire and
-- one Tower Smoke per tower, spawntimesecs -600: hidden until the Sentry Brazier's event respawns them for 600 s. mop has
-- those eight rows right (4320, 6340, 40177-40182). It also carried 23 Cataclysm-sniffed Tower Fire rows caught while a
-- tower was burning and imported as always-on (spawntimesecs 300). 2026_11_21_38 deleted the 15 on the tower tops and kept
-- 8 at brazier level as a permanent "wall of flame" (one 2013 comment); those are what burned before the click:
--   south-western tower (brazier 149025, event 3201): 156264 156265 156266 156267
--   south-eastern tower (brazier 149030, event 3202): 156252 156253
--   western tower       (brazier 149032, event 3204): 156273 156274
--   eastern tower       (brazier 149031, event 3203): none in the sniff; it gets the tower-top fire and smoke only.
-- Now the eight are hidden until their tower's brazier is used and burn for the same 600 s as the tower-top fire.
-- Sourced: fires appear when the brazier is used (classic data, the user's report). Ours: tying the brazier-level flames
-- to the event. Needs a server restart (event_scripts and spawn times load at startup).

UPDATE `gameobject` SET `spawntimesecs` = -600
 WHERE `guid` IN (156252, 156253, 156264, 156265, 156266, 156267, 156273, 156274) AND `id` IN (148996, 149017, 149020);

DELETE FROM `event_scripts` WHERE `id` IN (3201, 3202, 3204) AND `command` = 9
 AND `datalong` IN (156252, 156253, 156264, 156265, 156266, 156267, 156273, 156274);
INSERT INTO `event_scripts` (`id`, `delay`, `command`, `datalong`, `datalong2`, `dataint`, `x`, `y`, `z`, `o`) VALUES
(3201, 2, 9, 156264, 600, 0, 0, 0, 0, 0),
(3201, 2, 9, 156265, 600, 0, 0, 0, 0, 0),
(3201, 2, 9, 156266, 600, 0, 0, 0, 0, 0),
(3201, 2, 9, 156267, 600, 0, 0, 0, 0, 0),
(3202, 2, 9, 156252, 600, 0, 0, 0, 0, 0),
(3202, 2, 9, 156253, 600, 0, 0, 0, 0, 0),
(3204, 2, 9, 156273, 600, 0, 0, 0, 0, 0),
(3204, 2, 9, 156274, 600, 0, 0, 0, 0, 0);
