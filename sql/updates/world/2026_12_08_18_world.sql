-- Echo Isles class line: Tunari's unit flags as both TDBs; the Arts quests' practice areas in the 5.x map-area format.
-- 1. Tunari 38245 (priest trainer) had IMMUNE_TO_NPC on top of the flags every other trainer here has (33536 vs 33024). Both TDBs
--    give him the same unit_flags as the other trainers (256, IMMUNE_TO_PC, without IMMUNE_TO_NPC; tdb-diff.md). A friendly trainer,
--    so nothing a player sees changes; he gets his siblings' 33024.
UPDATE `creature_template` SET `unit_flags` = 33024 WHERE `entry` = 38245;
-- 2. The Arts quests' practice area (the polygon round the training grounds, objective index 0 "use <spell> on Tiki Targets") had
--    QuestObjectiveId 0 (old format), so the client could not tie the area to its objective and hide it once the practice is done.
--    Ours: each gets the id of its own index-0 objective (quest_objective); no source has these rows in the 5.x format. The
--    learn-spell rows (index -1, at the trainer) are left.
--    Neither TDB has rows to compare: 4.4.2 has the Cataclysm versions of these quests, 12.1.0 retired them (Flags 0x4000); the
--    Proving Pit areas were fixed the same way from TDB 12.1.0 (2026_12_08_07).
UPDATE `quest_poi` SET `QuestObjectiveId` = 267011 WHERE `QuestID` = 24640 AND `ObjectiveIndex` = 0;
UPDATE `quest_poi` SET `QuestObjectiveId` = 255305 WHERE `QuestID` = 24752 AND `ObjectiveIndex` = 0;
UPDATE `quest_poi` SET `QuestObjectiveId` = 267985 WHERE `QuestID` = 24760 AND `ObjectiveIndex` = 0;
UPDATE `quest_poi` SET `QuestObjectiveId` = 265786 WHERE `QuestID` = 24766 AND `ObjectiveIndex` = 0;
UPDATE `quest_poi` SET `QuestObjectiveId` = 263475 WHERE `QuestID` = 24772 AND `ObjectiveIndex` = 0;
UPDATE `quest_poi` SET `QuestObjectiveId` = 265381 WHERE `QuestID` = 24778 AND `ObjectiveIndex` = 0;
UPDATE `quest_poi` SET `QuestObjectiveId` = 265509 WHERE `QuestID` = 24784 AND `ObjectiveIndex` = 0;
UPDATE `quest_poi` SET `QuestObjectiveId` = 255456 WHERE `QuestID` = 26274 AND `ObjectiveIndex` = 0;
