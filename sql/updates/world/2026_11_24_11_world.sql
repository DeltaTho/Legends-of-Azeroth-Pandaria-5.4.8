-- Blasted Lands A (_11): Shadowsworn Spellblades and Occultists drop their spell focus as they turn demon at 30 % (plan section 2
-- orphan, dossier S2 H-S6-4; Cultists at our Doorstep 25716).
--
-- Today: one Spellblade spawn (guid 163685) carries 78909 Break Spell Focus as a permanent spawn aura (neither TDB): effect 0 is
-- aura 254 (off-hand disarm), which hides its focus (off-hand item 2944) for ever; its trigger effect never runs from an addon
-- aura. Both entries cast 84325 Fel-Infused (demon form 41787) at 30 %, as both TDBs.
-- SOURCED: 2013-01-15 [+12], 2011-09-12 [+2]: they "throw their focus to the ground and turn demon". 78909 = off-hand disarm +
-- TRIGGER_SPELL 84325 (5.4.8 DBC).
-- OURS: the 30 % row casts 78909 (which triggers 84325 itself) on both entries, triggered, instead of 84325 alone; the spawn aura
-- goes (matched by entry, so no guid is depended on).
-- NOT BUILT (deferred, review round 1 N1): the sources say a cultist that has turned no longer drops the Intact focus. No
-- data-only mechanism holds in this core: (1) creature loot conditions are evaluated against the looting player only
-- (LootMgr.cpp 75 / 461: IsObjectMeetToConditions(player, ...), no corpse as condition target), so no condition can see the
-- corpse's 84325 aura; (2) loot mode is not honoured for creature loot (Unit.cpp 16199 passes the map difficulty, nothing reads
-- Creature::GetLootMode) and SmartAI has no action to set it; (3) the remaining data tricks (removing the lootable flag, forced
-- despawn, a template switch) also deny or change the rest of the corpse. A C++ hook (e.g. a CreatureScript JustDied that
-- removes item 57134 from loot when the turn happened) would do it; section A is data only. So a turned cultist still drops
-- the focus as today (100 %, 1-2): test-sheet row, deferred.
-- Kill window if it is ever built: the turn is at 30 % health (both TDBs' 0-30 % health row; no source gives a number) and
-- 78909 / 84325 are instant (cast time index 1), so "killed before the turn" means taking the last 30 % in the blow or tick
-- that crosses 30 %: rare solo, common with a group or bots bursting.
-- Walked whole: row 0 (30 %, once per life), rows 1-3 unchanged; an evade no longer reloads a disarm; respawn resets the row.

UPDATE `creature_addon` ca JOIN `creature` c ON c.`guid` = ca.`guid` SET ca.`auras` = NULL WHERE c.`id` = 42296 AND ca.`auras` = '78909';
UPDATE `smart_scripts` SET `action_type` = 11, `action_param1` = 78909, `action_param2` = 2, `target_type` = 1,
  `comment` = 'Shadowsworn Spellblade - Between 0-30% Health - Cast ''Break Spell Focus'' (triggers Fel-Infused) (No Repeat)'
  WHERE `entryorguid` = 42296 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 2;
UPDATE `smart_scripts` SET `action_type` = 11, `action_param1` = 78909, `action_param2` = 2, `target_type` = 1,
  `comment` = 'Shadowsworn Occultist - Between 0-30% Health - Cast ''Break Spell Focus'' (triggers Fel-Infused) (No Repeat)'
  WHERE `entryorguid` = 42297 AND `source_type` = 0 AND `id` = 0 AND `event_type` = 2;
