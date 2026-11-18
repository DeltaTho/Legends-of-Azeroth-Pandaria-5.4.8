-- Blasted Lands A (_06): Shadowsworn Spellblades (42296), Occultists (42297) and Okril'lon Infantry (42359) are not silenced
-- (dossier S2 F-SILENCE; review round 1 note N3 for the Infantry).
--
-- Today: all three templates carry UNIT_FLAG_SILENCED 0x2000 (42296 / 42297 unit_flags 8208; 42359 536911872); Spell.cpp 7248
-- fails every spell of PreventionType 1 (silence) for them: the Spellblade's Blast Wave 17277 and the Infantry's Battle Shout
-- 81219 (both PreventionType 1 in SpellCategories.dbc) never go off. Cleave / Mortal Strike (PreventionType 2) are unaffected.
-- SOURCED: both TDBs (4.4.2 and 12.1.0) have unit_flags 0 for all three; 25716 2010-11-24 [+4] (the Spellblades leap at you
-- "with an explosion at the end").
-- Only the silence bit is cleared (42296 / 42297 8208 -> 16; 42359 536911872 -> 536903680, keeping mop's PREVENT_EMOTES and
-- 0x8000).

UPDATE `creature_template` SET `unit_flags` = 16 WHERE `entry` IN (42296, 42297);
UPDATE `creature_template` SET `unit_flags` = 536903680 WHERE `entry` = 42359;
