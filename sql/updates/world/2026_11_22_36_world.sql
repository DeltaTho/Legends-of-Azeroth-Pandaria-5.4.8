-- Burning Steppes, Black Tooth Hovel: Quartermaster Kaoshin 48085 and the Blackrock War Kodos 48111 are Blackrock (FactionTemplate
-- 40): friendly in the Blackrock Disguise, hostile without it.
--
-- Kaoshin: mop faction 35 (friendly to all), both TDBs 40. Sources: wiki Quartermaster_Kaoshin and wiki 28239 notes ("does not know
-- you are a spy"), 48085 2010-11-26 [+3], 2011-11-30 [+2]: he attacks undisguised players and hits hard (rank 1, level 51).
-- Kodos: mop faction 35 + unit_flags 0x110 (IMMUNE_TO_PC): friendly and unattackable for everyone; both TDBs faction 40, unit_flags
-- 16. The horn's hostile branch still sets faction 14 and the evade row of 2026_11_22_38 restores the template (now 40).
-- Must ship with 2026_11_22_35 (the disguise working for female characters and coming off whole), never without it.
-- Playerbots never wear the disguise: Kaoshin and the kodos attack them (research\_playerbots-issues.md).

UPDATE `creature_template` SET `faction`=40 WHERE `entry`=48085;
UPDATE `creature_template` SET `faction`=40, `unit_flags`=16 WHERE `entry`=48111;
