-- Burning Steppes, A Perfect Costume 28202-28205 / 28428-28431: four leftover rows of the Tailor's Table's old SmartAI.
-- 2026_11_22_37 deleted the SmartAI of go 206947 (now C++ go_burning_steppes_tailors_table) but not its source-22 conditions
-- ("Execute SAI only if player has race mask", groups 1, 3, 5, 7, SourceId 1). They had no effect any more; removed.

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=22 AND `SourceEntry`=206947 AND `SourceId`=1 AND `SourceGroup` IN (1,3,5,7);
