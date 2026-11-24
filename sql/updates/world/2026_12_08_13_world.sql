-- An Ancient Enemy: Zar'jira the Sea Witch dies in about four minutes of fighting instead of about twenty-five (OURS, droppable).
-- Arithmetic (research\echo-isles\dossiers\EI-B.md, "Second pass"): at level 85 with Health_mod 6.34017 (491300 HP, the sniffed
-- health the 2026_10_30_1030 fix aimed at) Vanira, Vol'jin (Shadow Shock), Zuni and a level-5 player deal about 360 dps, so the
-- fight runs about 25 minutes. The sources describe a short scripted fight the NPCs win while the player kills the Manifestations
-- and stamps out the fires ("Just sit there and listen to the event ... kill the level 4 adds and stomp on the braziers", Wowhead
-- 2013-11-11; "The friendly NPCs do most of the work", 2010-11-29); none gives the length. The health figures point the other way:
-- Wowhead MoP Classic shows 1,059,300 HP, a level-85 player saw "almost 500k" (2011-02-25), Cataclysm Classic has her at level 5.
-- Ours: Health_mod 1.0 (77490 HP): about 107 s to 50 %, 85 s to 10 %, 43 s to 2 %, plus the dialogue. She stays level 85 and still
-- kills a low player who attacks her; every phase is still driven by her health thresholds. A level-85 visitor kills her faster.
UPDATE `creature_template` SET `Health_mod` = 1 WHERE `entry` = 38306;
UPDATE `creature` SET `curhealth` = 77490 WHERE `guid` = 252719;
