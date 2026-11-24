-- Durotar: Unbidden Visitors (25194) credits the player who hurt the Wayward Plainstrider.
--
-- The user, play-testing 2026-11-23: the plainstriders "start running" but give no credit.
-- The 11 per-guid scripts of Wayward Plainstrider 39337 (id 10) store SMART_TARGET_VICTIM On Aggro, and the 1-30 % health
-- event credits stored list 1 (id 3). On Aggro runs from CreatureAI::JustEngagedWith, which CombatManager calls when the fight
-- starts (CombatManager.cpp -> CreatureAI::JustEnteredCombat -> EngagementStart), before the creature has picked a victim:
-- GetVictim() is null there, list 1 is stored empty and the credit at 30 % reaches nobody while the flee (ids 4-7) still runs.
-- Store the action invoker instead: the unit the fight started with. A pet opener is credited to its owner by
-- SMART_ACTION_CALL_KILLEDMONSTER's pet branch (SmartScript.cpp).
UPDATE `smart_scripts` SET `target_type`=7, `comment`='Wayward Plainstrider - On Aggro - Store Target List (invoker)'
WHERE `source_type`=0 AND `id`=10 AND `event_type`=4 AND `action_type`=64 AND `target_type`=2
  AND `entryorguid` IN (SELECT -`guid` FROM `creature` WHERE `id`=39337);
