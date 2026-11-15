-- Badlands: the actors of the three "The Day that Deathwing Came" stories leave the open world. Outside a story nobody sees the
-- hostile level-85 Cowardly Deathwing at the Scar (a one-shot trap for passers-by), the two wandering Deathwings, the rock walls
-- across the Scar floor, the clouds in the sky, the wandering Cave In Triggers, or the two rings of fire;
-- inside a story the player carries that story's phase (aura 261 of its start spell) and sees its actors.
--
-- Sourced: the phase ids are the start spells' own (5.4.8 DBC, Phase.dbc): 86557 TDDC 1: Summon Theldurin -> 293, 87737 TDDC 2:
--   Summon Lucien -> 295, 86675 TDDC 3: Summon Martek's Hog -> 310. None of these spawns is in either TDB (they were imported
--   from a 4.3.4 sniff without their phase); the Cowardly Deathwing is summoned by 87802 (TDDC 2) for 2 min, so the static copy
--   is a sniffed summon; npc 46471 comment 2011-01-05 [+5] "you must have to be on the quest to see him".
-- Ours: which actor goes into which story (from the stories' texts and objectives: elementals, walls and the trench-end
--   Deathwing are Theldurin's; clouds Lucien's; the pillar Deathwing and the cave-in triggers Martek's; each fire ring with its
--   Deathwing); standing the two Deathwings, the triggers and the two large bunnies still; the trigger flag on 47128 / 47129
--   (47129 Cave In Stalker, summoned by the story, would otherwise show its infernal model; the 23 spawns of 47128 already
--   carry the invisible model 11686, so for them the flag only marks them as triggers).
-- No phase_area row lists 293, 295 or 310. phaseMask stays 1; spawns with a phaseId are seen only by a player carrying it,
-- phase-0 spawns stay visible to him. The 17 "TDDC Event - PRK" props at the camp stay in phase 0 (orchestrator's acceptance
-- of the stories dossier S4) and the Biker Helmets 206542 are untouched. The elementals keep their sniffed Generic Quest
-- Invisibility 1 (49414); the story start casts the detections 86637 / 87785. These updates go by entry, so a doubled
-- elemental removed by another commit is simply not there.

-- the Cowardly Deathwing: a copy of a 2-minute summon
DELETE FROM `creature_addon` WHERE `guid` = 162681;
DELETE FROM `creature` WHERE `guid` = 162681 AND `id` = 47103;

-- TDDC 1 (Theldurin): the 57 Dang-Blasted Rock Elementals, the Deathwing at the end of the trench, the 77 rock walls, the ring
-- of fire around that Deathwing
UPDATE `creature` SET `phaseId` = 293 WHERE `id` = 46467;
UPDATE `creature` SET `phaseId` = 293, `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 161640 AND `id` = 46471;
UPDATE `gameobject` SET `phaseId` = 293 WHERE `id` = 206108;
UPDATE `creature` SET `phaseId` = 293 WHERE `id` = 41200 AND `guid` IN
  (161636,161637,161638,161639,161641,161642,161643,161644,161645,161718,161719,161720,161721);
UPDATE `creature` SET `phaseId` = 293, `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 161646 AND `id` = 44775;

-- TDDC 2 (Lucien): the nine clouds
UPDATE `creature` SET `phaseId` = 295 WHERE `id` = 47097;

-- TDDC 3 (Martek): the Deathwing on the pillar, the 23 Cave In Triggers along the trench, the ring of fire around the pillar
UPDATE `creature` SET `phaseId` = 310, `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 161582 AND `id` = 46471;
UPDATE `creature` SET `phaseId` = 310, `MovementType` = 0, `wander_distance` = 0 WHERE `id` = 47128;
UPDATE `creature` SET `phaseId` = 310 WHERE `id` = 41200 AND `guid` IN
  (161574,161575,161576,161577,161578,161579,161580,161581,161583,161686,161687,161688,161689);
UPDATE `creature` SET `phaseId` = 310, `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 161584 AND `id` = 44775;

-- triggers (47129 would show an infernal otherwise)
UPDATE `creature_template` SET `flags_extra` = `flags_extra` | 0x80 WHERE `entry` IN (47128, 47129);
