-- Blasted Lands A (_05): Dreadmaul Ogre Mages (5975) and Nethergarde Engineers (5997) are not stunned (dossier S1 F-STUN).
--
-- Today: both templates carry UNIT_FLAG_STUNNED 0x40000 and PREVENT_EMOTES 0x20000000 with no stun aura; Spell.cpp 7257-7280
-- fails every cast of a unit with UNIT_FLAG_STUNNED (SPELL_FAILED_STUNNED), so the mages cast no frost spells and the engineers
-- (Pick Your Fate 25678 targets) never shoot or throw bombs, and both look stunned.
-- SOURCED: both TDBs have neither flag (TDB 4.4.2 unit_flags 0 for 5997); 5997 comment [+4] (OLD, pre-revamp) "stay back and
-- shoot, then melee"; their SmartAI rows Shoot / Bomb / Explosive Shot / Ticking Time Bomb.
-- Only these two bits are cleared: mop's 0x8000 stays (the TDB has 0; the TDB diff treats that bit as equivalent).
-- Absolute values: 5975 537133056 -> 0, 5997 537165824 -> 32768.

UPDATE `creature_template` SET `unit_flags` = 0 WHERE `entry` = 5975;
UPDATE `creature_template` SET `unit_flags` = 32768 WHERE `entry` = 5997;
