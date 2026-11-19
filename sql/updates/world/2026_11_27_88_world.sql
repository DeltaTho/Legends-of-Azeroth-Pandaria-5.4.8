-- Durotar, Tiragarde Keep and Scuttle Coast: the drowned Kul Tiras sailors and marines lie still and cannot be targeted.
--
-- 51 spawns of 37911 Drowned Kul Tiras Sailor (35) and 37912 Drowned Kul Tiras Marine (16), every spawn of both entries
-- (all in zone 14), lie posed dead (template or spawn aura 29266 Permanent Feign Death or 64462 Drowned State) but had
-- MovementType 1 with a 3 yd wander: corpses sliding about on the beach.
-- Sourced, both TDBs: every spawn of both entries MovementType 0, wander 0; template unit_flags include NOT_SELECTABLE
-- (0x2000000; 4.4.2: 33554432, 12.1.0 the same bit with others), which mop lacked: the corpses could be targeted.
-- The pose auras are kept as they are (29266 and 64462 both show a corpse). Immunity flags are not needed here: faction 35
-- is friendly to both player factions and to every NPC faction (hostile.py), so nothing can attack them.
-- No quest, loot, SmartAI or path uses them.

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` IN (37911,37912) AND `guid` IN (251646,251647,251648,251649,251650,251651,251652,251653,251654,251655,251751,251752,251753,251754,251755,251756,
  251757,251758,251759,251760,251814,251815,251816,251817,251818,251819,251820,251821,251823,251858,251859,251860,
  251861,251862,251863,251864,251865,251866,251890,251891,251892,251893,251894,251895,251896,251897,251898,251916,
  251917,251918,251919);
UPDATE `creature_template` SET `unit_flags` = 33587200 WHERE `entry` IN (37911,37912); -- 32768 (as before) | 0x2000000 NOT_SELECTABLE
