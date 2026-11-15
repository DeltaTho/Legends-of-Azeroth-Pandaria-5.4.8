-- Badlands: the Lost Vikings (Eric 46855, Baelog 46856, Olaf 46857) and the Bad Dogs (Amakkar 47021, Jurrix 47024, Gargal 47022)
-- come with the FIRST of their three training quests taken (27828 / 27834 / 27835, 27891 / 27892 / 27893), follow through the
-- arc's areas, and stay through The Wrath of a Dragonflight, Their Hunt Continues and The Sorrow and the Fury until The Hidden
-- Clutch (27832 / 27897) is handed in to Rhea. They vanish outside those areas (Dustbelch Grotto, the Scar of the Worldbreaker,
-- the open zone) and come back on return, and after a relog, a death and resurrection, a Dismiss or a hunter's own pet.
--
-- Before this: one spell_area row per faction, keyed on Eric's / Amakkar's quest only and only inside Dragon's Mouth / New
-- Kargath, ending at 27829 complete: Baelog's or Olaf's quest taken alone brought nobody and could not be completed, the three
-- stayed with the player world-wide after leaving the camp (nothing tied them to the aura), a second trio came on every return to
-- the camp (spell_linked_spell), and none came back after a relog, a death or a dead companion.
--
-- Sourced: all three with the first quest taken (wiki notes of 27828/27834/27835/27891-27893; Adelorna 2010-12-01 [+30]); they
--   stay until The Hidden Clutch is completed (wiki 27832/27897 "Completing the quest will have players saying goodbye"; plan
--   ruling R1: quest_end status 11 = until rewarded); they vanish in the Grotto, the Scar and away from the quest area and come
--   back on return (comments on 27825, 27879, 27829, 27894, 27831); they come back after a relog, a death, a Dismiss, and a dead
--   one after the fight (C18, C19); the hunter's pet is dismissed (C11).
-- Ours: the seven areas (server map sample of where the arc is played: Dragon's Mouth 5564, New Kargath 5565, The Dustbowl 1878,
--   Ruins of Kargath 340, The Hidden Clutch 5592, Mirage Flats 1879, Camp Cagg 344, both factions); the 5 s check that brings a
--   missing companion back; no trio for a playerbot.
-- The summon aura (87262 / 87589) stays the marker of "the trio is with you": section B's spell_area rows show the static trio at
-- the camps only while the player does not hold it (2026_11_20_24).
-- C++: zone_badlands_companions.cpp (spell_badlands_companion_summon / _aura, npc_badlands_companion).

DELETE FROM `spell_area` WHERE `spell` IN (87262, 87589);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`)
SELECT s.spell, a.area, s.q, s.qend, 0, 0, 2, 1, 74, 11
FROM (SELECT 87262 AS spell, 27828 AS q, 27832 AS qend UNION ALL SELECT 87262, 27834, 27832 UNION ALL SELECT 87262, 27835, 27832
      UNION ALL SELECT 87589, 27891, 27897 UNION ALL SELECT 87589, 27892, 27897 UNION ALL SELECT 87589, 27893, 27897) s
CROSS JOIN (SELECT 5564 AS area UNION ALL SELECT 5565 UNION ALL SELECT 1878 UNION ALL SELECT 340 UNION ALL SELECT 5592
            UNION ALL SELECT 1879 UNION ALL SELECT 344) a;

-- The aura is not saved: at login spell_area casts it again, with the companions
DELETE FROM `spell_custom_attribute` WHERE `spell` IN (87262, 87589) AND `attribute` = 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(87262,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','The Lost Vikings: Summon Eric (27828, 27834, 27835): spell_area casts it again, with the companions, at login'),
(87589,'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB','Ex-KEF: Summon Amakkar (27891, 27892, 27893): spell_area casts it again, with the companions, at login');

-- The summon brings all three itself (the linked casts summoned a second Baelog and Olaf on every area re-entry)
DELETE FROM `spell_linked_spell` WHERE `spell_trigger` IN (87262, 87589) AND `spell_effect` IN (87263, 87264, 87590, 87591);

DELETE FROM `spell_script_names` WHERE `spell_id` IN (87262, 87589);
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(87262,'spell_badlands_companion_summon'),
(87262,'spell_badlands_companion_aura'),
(87589,'spell_badlands_companion_summon'),
(87589,'spell_badlands_companion_aura');

-- The six on the C++ companion AI. Their SmartAI goes: it credited three objectives on any aggro, set Baelog, Olaf, Gargal and
-- Jurrix passive (they never fought), and despawned them on Kalaran's data (his rows go with 2026_11_20_16).
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (46855, 46856, 46857, 47021, 47022, 47024) AND `source_type` = 0;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_badlands_companion' WHERE `entry` IN (46855, 46856, 46857, 47021, 47022, 47024);
