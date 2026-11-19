-- Rwag (3155, Valley of Trials rogue trainer): remove the stale gossip script.
-- On selecting option 4 of menu 141 it closed the window and cast Conjure Elegant Letter (21100): in the TDBs that option was "May I
-- have it, please." (the Ravenholdt letter); in mop option 4 is "Enter the Proving Grounds", shown to level-90 rogues, so they got the
-- window closed and a letter (SmartAI::OnGossipSelect returns false, so the Proving Grounds option still ran). Both TDBs give Rwag no
-- AI. Kaplak (3170, Razor Hill) has the same two rows: Razor Hill's coder's.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3155 AND `source_type` = 0;
UPDATE `creature_template` SET `AIName` = '' WHERE `entry` = 3155 AND `AIName` = 'SmartAI';
