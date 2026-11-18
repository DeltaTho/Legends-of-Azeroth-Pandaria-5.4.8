-- Blasted Lands A (_13): the Nethergarde Footmen fight the Okril'lon Infantry they face in the supply camp (dossier S2 F-BATTLE;
-- Eliminate the Okril'lon 25711).
--
-- Today: 17 Footmen 45031 (faction 2321) stand 3-4 yd from Infantry 42359 (2322), facing them; the factions are hostile both
-- ways and neither has IMMUNE_TO_NPC, but static NPCs never start a fight (line-of-sight checks run on movement only).
-- SOURCED: 25711 2010-11-23 [+3] "Fight the ones that the friendly infantry are fighting; you should get credit"; wiki 25711
-- notes "Most of them will be occupied with Nethergarde's troops"; 25710 2010-11-23 [+5].
-- OURS: the starter (no TDB script starts it): a Footman out of combat attacks the closest Infantry within 8 yd every 5-8 s;
-- and the caps: creature_sparring_template 80 % on both (Unit::DealDamage, Unit.cpp 932-947): creature damage never kills
-- either side, and once a side is at or below 80 % further creature hits do nothing. The hit that crosses 80 % is not trimmed,
-- so one footman blow can leave an Infantry somewhat below 80 % (a Heroic Strike or crit from 81 %); footman damage stays far
-- under half of its health, so a player (or bot) still deals the rest and keeps the kill credit (m_PlayerDamageReq = half
-- the health, Creature::IsDamageEnoughForLootingAndReward). Player, bot and pet damage is not capped.
-- Footman rows 0-2 are unchanged (abilities pass, 2026_10_29_987); AIName already SmartAI, set again so the file stands alone.

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 45031 AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE `entryorguid` = 45031 AND `source_type` = 0 AND `id` = 3;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(45031, 0, 3, 0, 1, 0, 100, 0, 1000, 3000, 5000, 8000, 0, 49, 0, 0, 0, 0, 0, 0, 19, 42359, 8, 0, 0, 0, 0, 0, 0, 'Nethergarde Footman - Out of Combat - Attack Closest Okril''lon Infantry (8 yd)');
DELETE FROM `creature_sparring_template` WHERE `creature_id` IN (42359, 45031);
INSERT INTO `creature_sparring_template` (`creature_id`, `health_limit_pct`, `comment`) VALUES
(42359, 80, 'Okril''lon Infantry - endless fight with the Nethergarde Footmen; creature hits stop once it is at or below 80 % (player kill credit)'),
(45031, 80, 'Nethergarde Footman - endless fight with the Okril''lon Infantry');
