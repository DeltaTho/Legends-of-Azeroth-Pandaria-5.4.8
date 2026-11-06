-- Firelands: Majordomo Staghelm 52571 is immune to players and NPCs until the Druids of the Flame around him are dead, as in retail and Cataclysm
-- (TDB 1210 and 442, TCPP: unit_flags 0x340). boss_majordomo_staghelm clears the flags when the druids die.
UPDATE `creature_template` SET `unit_flags`=832 WHERE `entry`=52571;
