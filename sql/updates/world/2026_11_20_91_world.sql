-- Badlands, Fuselight, Ho! 27762: Gobby Nozzlerocket 48837 is seated on The Uncrashable 48766 by its script, after the player.
--
-- Found in the smoke test: the rocket flew without its pilot. As an automatic accessory (this row, from 2026_11_20_48) Gobby
-- boarded seat 0 when the rocket appeared, and lost it when the player was put in seat 1: two ride auras on one vehicle stack
-- only while an enterable seat is still free (Aura::CanStackWith), seat 1 cannot be entered, so the player's aura removed his
-- and he was unsummoned (an accessory that leaves its vehicle goes after 2 s). spell_badlands_rocket_ride_to_badlands now seats
-- the player first and then installs Gobby in seat 0. The rocket's spellclick row (48766, 46598), which boards him, stays.
-- Ours (no TDB has any of these rows).

DELETE FROM `vehicle_template_accessory` WHERE `entry` = 48766;
