-- Outland, Netherstorm: Chancellor Bloodleaf 22012, Eclipsion Soldier 22016, Spellbinder 22017 and Cavalier 22018 are ordinary hostile kill
-- targets that carry the guard flag. A guard's death sends a server-wide "zone under attack" message, which now also goes for guards on
-- SmartAI, so every kill would alert the other faction. Clear the flag (CREATURE_FLAG_EXTRA_GUARD).
UPDATE `creature_template` SET `flags_extra`=`flags_extra`&~32768 WHERE `entry` IN (22012, 22016, 22017, 22018);
