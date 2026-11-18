-- Blasted Lands, The Downfall of Marl Wormthorn 26187 (A) / 25720 (H): Marl Wormthorn 42334 in his trance, released by the
-- Demoniac Vessel (57185 -> 78985 Break Marl's Trance), and back in the trance after every reset.
-- Sourced: he sits in trance in the hollow tree, wrapped in Marl's Shield, untouchable without the quest (26187 2010-11-23
-- [+17]; 42334 2011-08-14); the trance breaks under the vessel (26187 2010-11-23, 2011-05-08); he casts at once (2011-11-09);
-- the aggro and death yells (wiki notes of 26187 / 25720, broadcast texts 42261 / 42264; 42334 2010-12-03 reply [+28]);
-- idle at his spot (both TDBs). Ours: the shield aura goes at the release (a comment speaks of "releasing him from his
-- prison"); he attacks the vessel's user; the reset (spawn, respawn, back home after an evade) puts the flags and the shield
-- back (before, a respawn kept the flags he died with, so the next Marl stood attackable and hostile, shield on).
-- Walked whole: 0 spellhit (now repeatable, the reset re-arms it) -> 5 shield off -> 6 attack; 1-4 his spells as before
-- (Wrath, Mark of the Wild out of combat, Roots, Rejuvenation 0-40 %); 7 aggro yell; 8 death yell; 9 reset -> 10 shield.
DELETE FROM `creature_text` WHERE `CreatureID` = 42334;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(42334, 0, 0, 'What are you doing?  You threaten my work!  The Tainted Scar''s revival is all thanks to me!', 14, 0, 100, 0, 0, 0, 0, 42261, 0, 'Marl Wormthorn - aggro'),
(42334, 1, 0, 'I only wanted to... do something... good...', 14, 0, 100, 0, 0, 0, 0, 42264, 0, 'Marl Wormthorn - death');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 42334;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 42334 AND `source_type` = 0 AND `id` IN (0, 5, 6, 7, 8, 9, 10);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(42334, 0, 0, 5, 8, 0, 100, 0, 78985, 0, 0, 0, 0, 19, 768, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Marl Wormthorn - On Spellhit Break Marl''s Trance - Remove Immune Flags'),
(42334, 0, 5, 6, 61, 0, 100, 0, 0, 0, 0, 0, 0, 28, 78986, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Marl Wormthorn - Linked - Remove Marl''s Shield'),
(42334, 0, 6, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 49, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Marl Wormthorn - Linked - Attack the vessel''s user'),
(42334, 0, 7, 0, 4, 0, 100, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Marl Wormthorn - On Aggro - Yell'),
(42334, 0, 8, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Marl Wormthorn - On Death - Yell'),
(42334, 0, 9, 10, 25, 0, 100, 0, 0, 0, 0, 0, 0, 18, 768, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Marl Wormthorn - On Reset - Back into the trance (immune)'),
(42334, 0, 10, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 78986, 2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Marl Wormthorn - Linked - Cast Marl''s Shield');
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 164241 AND `id` = 42334;   -- idle in his trance, as both TDBs
