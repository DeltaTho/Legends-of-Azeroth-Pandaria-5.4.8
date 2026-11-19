-- Breadcrumb quests: `quest_template_addon` gets TrinityCore's BreadcrumbForQuestId column (same name, type and place as in both TDBs).
--
-- A quest with BreadcrumbForQuestId = X is a breadcrumb leading to quest X: it is offered only while X could be taken (not once X is in the
-- log or rewarded, nor while the player could not take X for any other reason), X is not offered while the breadcrumb is in the log,
-- and X never requires the breadcrumb. The sign is ignored (TrinityCore takes the absolute value). A breadcrumb must not also unlock its
-- target: if its NextQuestID, or the target's PrevQuestID, points the other way, ObjectMgr logs an error and drops that link.
--
-- Every row defaults to 0, so nothing changes until a zone fills the column; NextQuestID, PrevQuestID and ExclusiveGroup keep their
-- meaning. The worldserver that reads this column (ObjectMgr::LoadQuests selects it) needs this file applied first.
--
-- Undo (with the previous worldserver binary): ALTER TABLE `quest_template_addon` DROP COLUMN `BreadcrumbForQuestId`;
-- Re-runnable: the ADD COLUMN is guarded by information_schema (PREPARE).

SET @has := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'quest_template_addon' AND COLUMN_NAME = 'BreadcrumbForQuestId');
SET @ddl := IF(@has = 0, 'ALTER TABLE `quest_template_addon` ADD COLUMN `BreadcrumbForQuestId` int NOT NULL DEFAULT 0 AFTER `ExclusiveGroup`', 'DO 0');
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
