-- Durotar: The Wolf and The Kodo (25205), the data of the fable scene (script: zone_durotar_blockade.cpp). Shin Stonepillar's SmartAI
-- gave the credit on the gossip click with no scene; it is replaced by npc_durotar_shin_stonepillar, so this file ships with the
-- script (alone it would leave the quest with no credit). What the scene is and what is sourced or ours: the script's header.
-- Sourced: Shin's option only with the quest in progress (the fable is told to the player on the quest); Dash 73851 on The Wolf's
-- bar (wiki The_Wolf; DBC); the twelve lines (broadcast_text 39438-39451; boss emotes: wiki Notes); not saving the invisibility
-- aura and Hunting at a logout in the wolf (wiki, hotfix 2010-11-24); the six kodos stand still in their facing pairs (they
-- wandered 3 yd into each other; the screenshots show them locked head to head).
-- Ours: the lines go to the player alone (TextRange 5); group 12 (a pair held by another rider) is our own text.

-- Shin Stonepillar 39380: the scene script takes the gossip
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 39380;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_durotar_shin_stonepillar' WHERE `entry` = 39380;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 11209;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
 `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 11209, 0, 0, 0, 47, 0, 25205, 8, 0, 0, 0, 0, '', 'Shin Stonepillar - tell the fable only while The Wolf and The Kodo is in progress');

-- The Wolf 39364 (vehicle 690, summoned by 73840) and The Kodo 39365
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_durotar_the_wolf', `spell1` = 73851 WHERE `entry` = 39364;
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'npc_durotar_the_kodo' WHERE `entry` = 39365;
UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 39365;

DELETE FROM `spell_script_names` WHERE `spell_id` IN (73919, 73851);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(73919, 'spell_durotar_wolf_and_kodos_invisibility'),
(73851, 'spell_durotar_wolf_dash');

-- Not saving the invisibility aura and Hunting at a logout in the wolf (the hotfix) needs no row: SpellMgr marks every aura with the
-- CHANGE_MAP interrupt flag and an infinite duration DONT_SAVE (SpellMgr.cpp ~3041), and 73919 / 73841 are both (SpellInterrupts
-- 0x480000, duration -1). The DELETE only clears rows an earlier draft of this file added.
DELETE FROM `spell_custom_attribute` WHERE `spell` IN (73919, 73841) AND `attribute` = 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';

DELETE FROM `creature_text` WHERE `CreatureID` = 39364;
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(39364, 0, 0, 'One day, The Wolf was very hungry, so he ran east to look for some food.', 41, 0, 100, 0, 0, 0, 0, 39438, 5, 'The Wolf - opening (personal boss emote)'),
(39364, 1, 0, 'The Wolf ran and ran, looking for an easy meal.', 41, 0, 100, 0, 0, 0, 0, 39444, 5, 'The Wolf - Dash (personal boss emote)'),
(39364, 2, 0, 'He was hungry for kodo meat.', 41, 0, 100, 0, 0, 0, 0, 39445, 5, 'The Wolf - Dash (personal boss emote)'),
(39364, 3, 0, 'The Wolf was lazy, and didn''t want to work for his meal.', 41, 0, 100, 0, 0, 0, 0, 39446, 5, 'The Wolf - Dash (personal boss emote)'),
(39364, 4, 0, 'The more he ran, the more his stomach growled.', 41, 0, 100, 0, 0, 0, 0, 39447, 5, 'The Wolf - Dash (personal boss emote)'),
(39364, 5, 0, 'The Wolf did not care for raptor meat.', 41, 0, 100, 0, 0, 0, 0, 39448, 5, 'The Wolf - Dash (personal boss emote)'),
(39364, 6, 0, 'The Wolf found scorpid meat to be too bitter.', 41, 0, 100, 0, 0, 0, 0, 39449, 5, 'The Wolf - Dash (personal boss emote)'),
(39364, 7, 0, 'The Wolf had grown tired of eating boar meat.', 41, 0, 100, 0, 0, 0, 0, 39450, 5, 'The Wolf - Dash (personal boss emote)'),
(39364, 8, 0, 'He scoured the sands of Durotar, hunting for his prey.', 41, 0, 100, 0, 0, 0, 0, 39451, 5, 'The Wolf - Dash (personal boss emote)'),
(39364, 9, 0, 'He happened upon a pair of battling kodos.$bClever as he was, The Wolf decided to wait for one to defeat the other.', 41, 0, 100, 0, 0, 0, 0, 39439, 5, 'The Wolf - a free pair of kodos reached (personal boss emote)'),
(39364, 10, 0, 'When the weaker Kodo died, The Wolf approached and tried to eat it.', 41, 0, 100, 0, 0, 0, 0, 39440, 5, 'The Wolf - the weaker kodo falls (personal boss emote)'),
(39364, 11, 0, 'The remaining Kodo, angry at The Wolf''s impetuousness,$bswiftly killed The Wolf before he had a chance to eat.', 41, 0, 100, 0, 0, 0, 0, 39441, 5, 'The Wolf - the wolf is killed (personal boss emote)'),
(39364, 12, 0, 'Another wolf is already watching these kodos. Find another pair, or wait.', 41, 0, 100, 0, 0, 0, 0, 0, 5, 'The Wolf - at a pair another rider holds (ours, no broadcast text; personal boss emote)');
