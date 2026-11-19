-- Durotar layer, plan ruling R1 option D, second part (drop together with 2026_11_27_98 if the user rules otherwise):
-- the Razor Hill rebels stand guard awake.
--
-- mop's creature_template_addon gave 72366 Darkspear Headhunter (51 spawns) and 72376 Thunder Bluff Warrior (34), all in
-- Razor Hill, aura 131727 "Cosmetic - Sleep Zzz Breakable"; none of their spawns has its own addon, so all 85 guards
-- wore the sleep visual while standing at their posts. TDB 12.1.0, the only TDB with these templates, has no aura on
-- either. Sourced: clear it.
-- Not done, overturning the plan and the dossier: making 72559 (the other Thunder Bluff Warrior, 4 spawns) sleep.
-- TDB 12.1.0's StandState 3 + aura 55701 sits on 72559 renamed "Thunder Bluff Protector" with a directions icon, a
-- later retail reuse of the entry; in 5.4 a 72559 was seen awake, shouting "For the Warchief!" as it attacked a
-- scorpid (Wowhead npc 72559, 2013-09-29 [+3]). Two of the four 72559 stand on former grunt posts. Left as is.
-- Note: where mop's 131727 came from is unknown; if it was a 5.4 sniff, sleeping guards would be retail (spotcheck F).

UPDATE `creature_template_addon` SET `auras` = NULL WHERE `entry` IN (72366, 72376);
