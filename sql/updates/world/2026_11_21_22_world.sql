-- Searing Gorge, Zamael Lunthistle 8436 (plan B-3): the ghost in the cage on Firewatch Ridge is seen, and offers Lunthistle's
-- Tale 27984, only from Dark Ministry 27979 on.
--
-- Sourced:
-- - 49415 Generic Quest Invisibility 2 (type 8, amount 100) on 8436's template: both TDBs.
-- - The window: "the ! may be visible on your minimap as you leave Thorium Point" while doing Dark Ministry (comment 27979
--   2011-11-14 [+12]); "I only had the quest available after completing Dark Ministry" (27984 2012-10-06).
-- - 88474 See Quest Invis 2 (type 8, amount 1000, AreaGroup 2804 = zone 51) is the zone's own type-8 detection (gate R-16).
-- Ours:
-- - The spell_area rows (neither TDB has one): zone 51, from 27979 taken (complete / incomplete / rewarded), and from 27984
--   taken the same way, so a player who accepted Lunthistle's Tale and then abandoned Dark Ministry still sees its ender and,
--   once it is handed in, the giver of Prayer to Elune 27985.
-- No other creature in zone 51 carries a type-8 invisibility; the Badlands NPCs with 49415 are 400+ yd outside the zone and
-- the detection drops on leaving it (gate 5d).

UPDATE `creature_template_addon` SET `auras`='49415' WHERE `entry`=8436;

DELETE FROM `spell_area` WHERE `spell`=88474 AND `area`=51;
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(88474,51,27979,0,0,0,2,1,74,0),
(88474,51,27984,0,0,0,2,1,74,0);
