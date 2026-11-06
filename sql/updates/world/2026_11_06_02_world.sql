-- Creature::CanStartAttack no longer treats UNIT_FLAG_IMMUNE_TO_NPC alone as immune to players. These were only kept from attacking
-- players by that: hostile invisible helpers with nothing else stopping them (Invisible Stalker 35592, Frost Burst Bunny 35076, Highbank
-- Cannon Bunny 49631), and the Lich King 30443, an unscripted scene actor. Immune to both, they still start no fight.
UPDATE `creature_template` SET `unit_flags`=`unit_flags`|256 WHERE `entry` IN (35592, 35076, 49631, 30443) AND `unit_flags`&512;
