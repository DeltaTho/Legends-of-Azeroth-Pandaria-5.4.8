-- Blasted Lands (zone 4): templates of non-quest mobs that differ from both TDBs (section F, Part E).
-- Sourced (TDB 4.4.2 and 12.1.0 agree):
-- - Felscale Crawler 45087 faction 7 (neutral, never attacks) -> 14 (hostile).
-- - Cassia the Slitherqueen 45258 faction 14 -> 2205, the faction of the Bloodwash Gamblers / Idolaters around her (she then
--   helps them when pulled; 14 and 2205 do not fight each other either way, hostile.py).
-- - Bonepicker Felfeeder 5983: template aura 11964 Fevered Fatigue (both TDBs' creature_template_addon). Every Felfeeder spawn
--   has its own creature_addon row (for its flight path) and this core reads a spawn's addon instead of the template's
--   (Creature::GetCreatureAddon), so the aura is set on those rows too; their other columns are not touched.

UPDATE `creature_template` SET `faction`=14 WHERE `entry`=45087;
UPDATE `creature_template` SET `faction`=2205 WHERE `entry`=45258;
UPDATE `creature_template_addon` SET `auras`='11964' WHERE `entry`=5983;
UPDATE `creature_addon` SET `auras`='11964' WHERE `guid` IN (163099,163100,163101,163191,163192,163193,163259,163260,163261,163262,163263,163311,163312,163313,163314,163315,163316,163317,163340,163341,163342,163343,163344,163368,163369,163370,163371,163386,163387,163388,163389,163402,163403,163404,163405,163418,163489,163490,163492,163640,163643,163656,163661,163662,163664,163668,163674,163680,163681,163682,163689,163701,163705,163713,163716,163717,163723,163729,163736,163744,163745,163759,163760,163761,163768,163779,163784,163785,163790,163795,163800);
