-- Burning Steppes A (_01): Done Nothing Wrong 28172 / 28417 can be completed: free the four Fettered Whelplings by clicking them
-- (plan A-06, A-07, A-08).
--
-- SOURCED: both TDBs (Fettered Whelpling 47814/47820/47821/47822 unit_flags 0; Freed Whelpling 48539-48542 level 1); the 5.4.8 DBC
-- (90368-90371 "Summon Freed <colour> Whelpling", castable while mounted, private 60 s summon of 48539-48542); comments (28417
-- 2010-11-26 / 2011-04-05 click them, the item goes to the bags; 2010-12-03 works mounted; 2010-11-27 each party member frees his
-- own; 2010-12-24 / 2010-12-16 with full bags "they will just fly away").
-- mop had: NOT_SELECTABLE + IMMUNE_TO_PC/NPC on the whelps (no click), the spellclick spell 90102 (Deadmines' Steam Valve vehicle
-- aura) and no source at all for the four items 63114/63116/63117/63119.
-- OURS: the item and despawn by SmartAI on the click (no sniffed script exists), the click conditions (quest in progress, that
-- colour not yet held), and the freed whelp's fly-off (it appears beside the player, lifts off after 1.5 s and is gone 4 s later)
-- with Flight = CanFly on its movement template so the fly animation plays (core rule C45).
-- The whelp spawns (doubles, walkers, respawn 120) are section C's (_24, plan K1).
-- Idempotent: absolute UPDATEs, DELETE + INSERT.

UPDATE `creature_template` SET `unit_flags` = 0, `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (47814, 47820, 47821, 47822);

-- the click: cast_flags 3 = the clicker casts on himself (summon at the clicker)
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` IN (47814, 47820, 47821, 47822);
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(47814, 90368, 3, 0), (47820, 90369, 3, 0), (47821, 90370, 3, 0), (47822, 90371, 3, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` IN (47814, 47820, 47821, 47822);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(18, 47814, 90368, 0, 0, 9, 0, 28172, 0, 0, 0, 0, 0, '', 'Fettered Red Whelpling - Done Nothing Wrong (A) in progress'),
(18, 47814, 90368, 0, 0, 2, 0, 63114, 1, 0, 1, 0, 0, '', 'Fettered Red Whelpling - no Freed Red Whelpling yet'),
(18, 47814, 90368, 0, 1, 9, 0, 28417, 0, 0, 0, 0, 0, '', 'Fettered Red Whelpling - Done Nothing Wrong (H) in progress'),
(18, 47814, 90368, 0, 1, 2, 0, 63114, 1, 0, 1, 0, 0, '', 'Fettered Red Whelpling - no Freed Red Whelpling yet'),
(18, 47820, 90369, 0, 0, 9, 0, 28172, 0, 0, 0, 0, 0, '', 'Fettered Green Whelpling - Done Nothing Wrong (A) in progress'),
(18, 47820, 90369, 0, 0, 2, 0, 63116, 1, 0, 1, 0, 0, '', 'Fettered Green Whelpling - no Freed Green Whelpling yet'),
(18, 47820, 90369, 0, 1, 9, 0, 28417, 0, 0, 0, 0, 0, '', 'Fettered Green Whelpling - Done Nothing Wrong (H) in progress'),
(18, 47820, 90369, 0, 1, 2, 0, 63116, 1, 0, 1, 0, 0, '', 'Fettered Green Whelpling - no Freed Green Whelpling yet'),
(18, 47821, 90370, 0, 0, 9, 0, 28172, 0, 0, 0, 0, 0, '', 'Fettered Blue Whelpling - Done Nothing Wrong (A) in progress'),
(18, 47821, 90370, 0, 0, 2, 0, 63117, 1, 0, 1, 0, 0, '', 'Fettered Blue Whelpling - no Freed Blue Whelpling yet'),
(18, 47821, 90370, 0, 1, 9, 0, 28417, 0, 0, 0, 0, 0, '', 'Fettered Blue Whelpling - Done Nothing Wrong (H) in progress'),
(18, 47821, 90370, 0, 1, 2, 0, 63117, 1, 0, 1, 0, 0, '', 'Fettered Blue Whelpling - no Freed Blue Whelpling yet'),
(18, 47822, 90371, 0, 0, 9, 0, 28172, 0, 0, 0, 0, 0, '', 'Fettered Bronze Whelpling - Done Nothing Wrong (A) in progress'),
(18, 47822, 90371, 0, 0, 2, 0, 63119, 1, 0, 1, 0, 0, '', 'Fettered Bronze Whelpling - no Freed Bronze Whelpling yet'),
(18, 47822, 90371, 0, 1, 9, 0, 28417, 0, 0, 0, 0, 0, '', 'Fettered Bronze Whelpling - Done Nothing Wrong (H) in progress'),
(18, 47822, 90371, 0, 1, 2, 0, 63119, 1, 0, 1, 0, 0, '', 'Fettered Bronze Whelpling - no Freed Bronze Whelpling yet');

-- the item to the clicker, then the fettered whelp goes (back after its spawntimesecs)
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (47814, 47820, 47821, 47822) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(47814, 0, 0, 1, 73, 0, 100, 0, 0, 0, 0, 0, 0, 56, 63114, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Fettered Red Whelpling - On Spellclick - Add Freed Red Whelpling to the clicker'),
(47814, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Fettered Red Whelpling - Linked - Despawn'),
(47820, 0, 0, 1, 73, 0, 100, 0, 0, 0, 0, 0, 0, 56, 63116, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Fettered Green Whelpling - On Spellclick - Add Freed Green Whelpling to the clicker'),
(47820, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Fettered Green Whelpling - Linked - Despawn'),
(47821, 0, 0, 1, 73, 0, 100, 0, 0, 0, 0, 0, 0, 56, 63117, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Fettered Blue Whelpling - On Spellclick - Add Freed Blue Whelpling to the clicker'),
(47821, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Fettered Blue Whelpling - Linked - Despawn'),
(47822, 0, 0, 1, 73, 0, 100, 0, 0, 0, 0, 0, 0, 56, 63119, 1, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Fettered Bronze Whelpling - On Spellclick - Add Freed Bronze Whelpling to the clicker'),
(47822, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Fettered Bronze Whelpling - Linked - Despawn');

-- the private Freed Whelpling: level 1 (both TDBs; mop 85), flies off
UPDATE `creature_template` SET `minlevel` = 1, `maxlevel` = 1, `AIName` = 'SmartAI', `ScriptName` = '' WHERE `entry` IN (48539, 48540, 48541, 48542);
DELETE FROM `creature_template_movement` WHERE `CreatureId` IN (48539, 48540, 48541, 48542);
INSERT INTO `creature_template_movement` (`CreatureId`, `Ground`, `Swim`, `Flight`, `Rooted`, `Chase`, `Random`, `InteractionPauseTimer`) VALUES
(48539, 1, 0, 2, 0, NULL, NULL, NULL), (48540, 1, 0, 2, 0, NULL, NULL, NULL), (48541, 1, 0, 2, 0, NULL, NULL, NULL), (48542, 1, 0, 2, 0, NULL, NULL, NULL);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (48539, 48540, 48541, 48542) AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(48539, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, 67, 1, 1500, 1500, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Freed Red Whelpling - Just Summoned - Timed event 1 in 1.5 s'),
(48539, 0, 1, 2, 59, 0, 100, 0, 1, 0, 0, 0, 0, 114, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 10, 15, 0, 'Freed Red Whelpling - Timed event 1 - Fly up and away'),
(48539, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 4000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Freed Red Whelpling - Linked - Despawn in 4 s'),
(48540, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, 67, 1, 1500, 1500, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Freed Green Whelpling - Just Summoned - Timed event 1 in 1.5 s'),
(48540, 0, 1, 2, 59, 0, 100, 0, 1, 0, 0, 0, 0, 114, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 10, 15, 0, 'Freed Green Whelpling - Timed event 1 - Fly up and away'),
(48540, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 4000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Freed Green Whelpling - Linked - Despawn in 4 s'),
(48541, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, 67, 1, 1500, 1500, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Freed Blue Whelpling - Just Summoned - Timed event 1 in 1.5 s'),
(48541, 0, 1, 2, 59, 0, 100, 0, 1, 0, 0, 0, 0, 114, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 10, 15, 0, 'Freed Blue Whelpling - Timed event 1 - Fly up and away'),
(48541, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 4000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Freed Blue Whelpling - Linked - Despawn in 4 s'),
(48542, 0, 0, 0, 54, 0, 100, 0, 0, 0, 0, 0, 0, 67, 1, 1500, 1500, 0, 0, 100, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Freed Bronze Whelpling - Just Summoned - Timed event 1 in 1.5 s'),
(48542, 0, 1, 2, 59, 0, 100, 0, 1, 0, 0, 0, 0, 114, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 10, 15, 0, 'Freed Bronze Whelpling - Timed event 1 - Fly up and away'),
(48542, 0, 2, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 41, 4000, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Freed Bronze Whelpling - Linked - Despawn in 4 s');
