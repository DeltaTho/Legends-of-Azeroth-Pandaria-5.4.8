-- Durotar layer, plan ruling R1 option D (pending the user's word; this commit and the next can be dropped together):
-- keep the 5.4 Siege layer and remove the levelling-layer NPCs it stands on.
--
-- Sources and strength (medium, spotcheck.md section F): wiki Razor_Hill "5.4.0: Now completely under Darkspear
-- troll and tauren control ... Razor Hill Grunts removed", Razor_Hill_Grunt "5.4.0 Removed, 6.0.2 Re-added"; Darkspear
-- Headhunter and Thunder Bluff Warrior "5.4.0 Added"; a 2013-09-29 comment on 72559 ("everyone at Razor Hill is rebelling
-- against Garrosh"). Neither TDB has any rebel NPC (both are outside 5.3-5.4), so no TDB confirms or refutes this; the
-- dossier's claim L2-10 (the sniff saw no grunt) is withdrawn and not relied on. Phase.dbc has no 5.4 Razor Hill phase.
--
-- Plan R1 listed all 41 grunts; narrowed to the 17 a Siege guard took the post of, per the ruling given to the coder
-- ("delete only where a rebel replaced the grunt; keep any grunt no rebel replaced").
-- Rule (ours): a Razor Hill Grunt goes only if a Siege guard or leader (72366 Darkspear Headhunter, 72376/72559 Thunder
-- Bluff Warrior, 72392 Vol'jin, 72394 Baine) stands within 10 yd of its spawn point, matched one to one, nearest pair
-- first. Wounded warriors, Meko (the healer tending them, 5.7 yd from 251523's patrol start) and the demolishers do not
-- count: they took no grunt's post. Every other grunt stays.
-- Deleted (17): guid, entry, spawn point, the rebel on or near its post and the distance
--   251528 5953 308.0,-4666.9  563751 72366 Darkspear Headhunter at 3.2 yd
--   251695 5953 319.1,-4812.9  563960 72376 Thunder Bluff Warrior at 0.2 yd
--   251790 5953 265.3,-4639.4  563759 72366 Darkspear Headhunter at 0.4 yd
--   251792 5953 296.2,-4739.6  563829 72392 Vol'jin at 3.3 yd
--   251793 5953 298.5,-4744.3  563828 72394 Baine Bloodhoof at 2.3 yd
--   251794 5953 369.9,-4818.8  563807 72559 Thunder Bluff Warrior at 0.6 yd
--   251839 5953 310.9,-4768.1  563808 72376 Thunder Bluff Warrior at 5.2 yd
--   251841 5953 302.0,-4815.6  563963 72366 Darkspear Headhunter at 0.1 yd
--   251844 5953 256.4,-4644.7  563758 72376 Thunder Bluff Warrior at 0.4 yd
--   251875 5953 368.2,-4798.6  563823 72559 Thunder Bluff Warrior at 9.3 yd
--   251877 5953 245.6,-4855.9  563732 72376 Thunder Bluff Warrior at 2.1 yd
--   251908 5953 300.1,-4770.2  563822 72559 Thunder Bluff Warrior at 0.3 yd
--   253088 5953 216.8,-4711.6  563726 72376 Thunder Bluff Warrior at 7.0 yd
--   253091 5953 256.6,-4831.3  563731 72366 Darkspear Headhunter at 0.3 yd
--   253170 5953 243.6,-4742.1  563725 72366 Darkspear Headhunter at 0.4 yd
--   253171 5953 244.3,-4730.2  563724 72376 Thunder Bluff Warrior at 0.3 yd
--   253172 5953 262.9,-4742.4  563722 72366 Darkspear Headhunter at 8.3 yd
-- Kept (23: 21 of 5953, 2 of 51911): guid, entry, spawn point, nearest Siege spawn
--   251523 5953 254.8,-4677.8  kept: nearest are 72435 Wounded Thunder Bluff Warrior 4.6 yd and Meko Skychaser 5.7 yd (wounded and healer, no guard; the grunt patrols)
--   251526 5953 394.1,-4599.2  nearest 563763 72366 Darkspear Headhunter at 97.3 yd
--   251692 5953 365.5,-4827.2  nearest 563807 72559 Thunder Bluff Warrior at 9.8 yd
--   251694 5953 414.8,-4613.0  nearest 563779 72419 Horde Demolisher at 97.9 yd
--   251697 5953 383.8,-4598.7  nearest 563763 72366 Darkspear Headhunter at 89.7 yd
--   251698 5953 265.8,-4592.2  nearest 563759 72366 Darkspear Headhunter at 47.5 yd
--   251699 5953 399.0,-4707.6  kept: its match is 72419 Horde Demolisher 7.1 yd away (a siege engine; the grunt stands beside it, not inside it)
--   251788 5953 377.8,-4673.2  nearest 563779 72419 Horde Demolisher at 46.3 yd
--   251840 5953 388.3,-4588.4  nearest 563754 72366 Darkspear Headhunter at 99.9 yd
--   251872 5953 368.9,-4761.2  nearest 563788 72419 Horde Demolisher at 15.2 yd
--   251873 5953 387.1,-4851.4  nearest 563807 72559 Thunder Bluff Warrior at 37.4 yd
--   251874 5953 403.1,-4570.0  nearest 563754 72366 Darkspear Headhunter at 123.0 yd
--   251876 5953 381.4,-4557.8  nearest 563754 72366 Darkspear Headhunter at 116.7 yd
--   251878 5953 382.7,-4583.0  nearest 563754 72366 Darkspear Headhunter at 99.1 yd
--   251903 5953 392.5,-4582.6  nearest 563754 72366 Darkspear Headhunter at 106.8 yd
--   251909 5953 320.2,-4914.0  nearest 563732 72376 Thunder Bluff Warrior at 95.2 yd
--   251910 5953 400.8,-4741.1  nearest 563805 72366 Darkspear Headhunter at 10.7 yd
--   251911 5953 419.8,-4588.9  nearest 563779 72419 Horde Demolisher at 122.4 yd
--   251924 5953 385.9,-4618.4  nearest 563763 72366 Darkspear Headhunter at 79.7 yd
--   253087 5953 216.9,-4647.6  nearest 563912 72556 Orc Child at 13.4 yd
--   253149 5953 251.4,-4738.8  nearest 563725 72366 Darkspear Headhunter at 8.7 yd
--   303089 51911 175.7,-4776.4  nearest 563914 72366 Darkspear Headhunter at 53.1 yd
--   303090 51911 171.4,-4770.5  nearest 563914 72366 Darkspear Headhunter at 58.2 yd
-- (303088, the 51911 grunt inside Burok, went in 2026_11_27_97 whatever the ruling.)
-- The kept grunts keep menu 3285 (directions: bank, wind rider, inn, stable, class and profession trainers), so Razor
-- Hill still has guards who give directions in town (e.g. 251872, 253149, 251699, 251523). No grunt carries the wiki's
-- "Thonk has been expecting you" line: it is not built anywhere in mop (no gossip, text or script row).
-- Nothing else depends on the deleted grunts: no quest, gossip condition, formation, event, pool or SmartAI target;
-- the two patrols' paths (ids = guids) are used by no other spawn.
--
-- 2) Dranosh'ar Overseer 40892 guid 204461 (1397.99,-4910.35, both TDBs' spot) has Kor'kron Motivator 563958 standing
--    0.4 yd inside it: the 5.4 layer's replacement on the same post. Delete the Overseer. No quest names 40892.
--
-- hostile.py over mop's factions left side by side in Razor Hill (Horde player 2, Alliance player 1, grunts 85, rebels
-- 126 / 104, Kor'kron 1735, townsfolk 29, 35, 2159, 2662, 2663, 1074, wildlife 7, 413, 91): no town pair fights; all are
-- friendly to a Horde player, so nothing attacks a level-5 orc; Alliance players are attacked as before. Scorpids (413)
-- and sea elementals (91) are fought only by the grunts (85): the rebels (126/104) ignore them. TDB 12.1.0 has the rebels
-- on 877 / 105, which do fight scorpids, and a 2013-09-29 comment shows a 72559 attacking one; not applied here (see
-- the coder's reply: level-90 rebels would then also attack the Hallow's End flame bunny 3 yd from a post and the
-- Clattering Scorpids 52 yd out that quest 25165 needs).

DELETE FROM `waypoint_data` WHERE `id` IN (251877,253172);
DELETE FROM `creature_addon` WHERE `guid` IN (251528,251695,251790,251792,251793,251794,251839,251841,251844,251875,251877,251908,253088,253091,253170,253171,
  253172);
DELETE FROM `creature` WHERE `id` = 5953 AND `guid` IN (251528,251695,251790,251792,251793,251794,251839,251841,251844,251875,251877,251908,253088,253091,253170,253171,
  253172);

DELETE FROM `creature_addon` WHERE `guid` = 204461;
DELETE FROM `creature` WHERE `id` = 40892 AND `guid` = 204461;
