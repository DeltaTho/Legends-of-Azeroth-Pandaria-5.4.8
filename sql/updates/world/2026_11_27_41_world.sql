-- Kaplak (3170, Razor Hill rogue trainer): his SmartAI closes the gossip and casts Conjure Elegant Letter (21100) when option 4 of menu 141 is
-- chosen. In the TDBs that option was the Ravenholdt letter ("May I have it, please."); in mop option 4 of menu 141 is "Enter the Proving
-- Grounds" (level-90 rogues), so choosing it at Kaplak gave a letter and closed the window. Same rows and fix as Rwag (3155) in the Valley
-- (section 1, A2-F8). Ours: removing the rows (the letter option no longer exists in this menu). Nothing else references his SmartAI.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3170 AND `source_type` = 0;
UPDATE `creature_template` SET `AIName` = '' WHERE `entry` = 3170 AND `AIName` = 'SmartAI';
