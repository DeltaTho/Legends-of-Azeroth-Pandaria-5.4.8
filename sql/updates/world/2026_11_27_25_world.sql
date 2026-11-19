-- Northwatch Scouts (39317, Invaders in Our Home) all stand in their stealth pose, as both TDBs.
-- mop's template addon had StandState 8 (kneel) and no aura, so the 11 scouts without a spawn addon knelt, while the 22 with one
-- stood with the stealth animation aura 58506. Both TDBs: template addon StandState 0 with aura 58506 ("each cloaked in stealth",
-- Wowhead 25172). The SmartAI already re-applies 58506 on respawn.
UPDATE `creature_template_addon` SET `StandState` = 0, `auras` = '58506' WHERE `entry` = 39317;
