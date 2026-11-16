-- Searing Gorge: Spider Rider's ride and Cranky Little Dwarfs' sit are scripted in C++ now (plan D-6, D-7; npc_sg_lunk_follower).
-- The old SmartAI made every Glassweb Spider and Dark Iron Steamsmith at half health immune and evade for every player, with or
-- without Lunk, and tried to board the followers onto a seatless spider (vehicle 584) or a seat that charms the dwarf (8961), from
-- a private follower no creature search can find: no ride, no sit, no credit, and someone else's Lunk could take your steamsmith.
-- Kept: 5840 id 0 (Lunk giver on death) and 9 (Steam Jet), 5856 id 0 (Lunk giver on death), 7 (Poison) and 8 (Web).
DELETE FROM `smart_scripts` WHERE `entryorguid`=5840 AND `source_type`=0 AND `id` BETWEEN 1 AND 8;
DELETE FROM `smart_scripts` WHERE `entryorguid`=5856 AND `source_type`=0 AND `id` BETWEEN 1 AND 6;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (5840000,5856000) AND `source_type`=9;

-- The steamsmith's vehicle 1262 was there only for the old sit (its one seat 8961 has CAN_CONTROL | CAN_ENTER_OR_EXIT): with the
-- rows above gone nothing boards it (no spellclick, accessory or other script uses 5840), but the usable seat gave every
-- steamsmith a dead gear cursor until its first respawn (Vehicle constructor, Player::CanSeeSpellClickOn with no click rows) and
-- knockback immunity (Vehicle::ApplyAllImmunities). Both TDBs keep 1262 (sniffed); ours to drop it.
UPDATE `creature_template` SET `VehicleId`=0 WHERE `entry`=5840;

-- The steamsmith's sleep lines go to Lunk's owner only (the dwarf says them while Lunk, whom only the owner sees, sits on him)
UPDATE `creature_text` SET `TextRange`=5 WHERE `CreatureID`=5840 AND `GroupID`=0;
