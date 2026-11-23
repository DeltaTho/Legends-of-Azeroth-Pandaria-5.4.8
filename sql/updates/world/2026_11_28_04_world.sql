-- Blasted Lands, 25771 One Draenei's Junk...: one source fragment, like 25772 (ProvidedItemCount 1)
-- 2026_11_28_03 set StartItem 10593; the loader warned "ProvidedItemCount = 0, set to 1 but need fix in DB".
UPDATE `quest_template_addon` SET `ProvidedItemCount` = 1 WHERE `ID` = 25771;
