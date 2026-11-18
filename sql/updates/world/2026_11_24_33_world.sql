-- Blasted Lands: Ashmane Boars 5992 (A Bloodmage's Gotta Eat Too 25690 / 26172) attack on approach.
-- Sourced: both TDBs faction 14; comment 25690 2012-08-30 [+5] (aggressive since 5.0.4). mop had 189 (neutral to both factions).
-- Ours: nothing.
UPDATE `creature_template` SET `faction` = 14 WHERE `entry` = 5992;
