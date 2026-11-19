-- Durotar, Lost in the Floods 25187 (plan section 3, CP3 / ruling R15; dossier D-watershed, event brief EB-1 and D-U2).
-- The four telescope cameras get the C++ script npc_durotar_watershed_telescope (zone_durotar.cpp) INSTEAD of their SmartAI:
-- the SmartAI stored the closest player within 30 yd (not the summoner), credited and teleported him 10 s after the path end
-- whether he was still seated or not, and exited + teleported in one tick (the camera-stuck trap). Not both: AIName goes.
-- SOURCED: credit only for a view watched to the end (Wowhead 2010-11-06 [+91], wiki), back on the tower afterwards.
-- OURS: the flight (no source), now flown by the script; the four generated paths (`waypoints` 39320, 39345, 39346, 39347,
-- used only by these SmartAI rows; each began by backing away 37 yd from the summon spot, D-U2) go with the SmartAI. Neither
-- TDB has SmartAI or paths for these entries; no sql/updates file of the fork touches them (checked).
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_durotar_watershed_telescope' WHERE `entry` IN (39320, 39345, 39346, 39347);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (39320, 39345, 39346, 39347) AND `source_type` = 0;
DELETE FROM `waypoints` WHERE `entry` IN (39320, 39345, 39346, 39347);
