-- Vol'jin 38966: "Can you tell me of the time when the Darkspear left Orgrimmar, Vol'jin?" (menu 11127 option 0, the Garrosh vision
-- replay) shows only once one of the nine More Than Expected quests is rewarded (OURS: no TDB has this option; the TDBs' only
-- 11127 option is the Thrall replay, conditioned on 24814 rewarded as 2026_12_08_08 does for option 1). mop showed it from level 1.
-- One ElseGroup per quest = OR. Option 1's condition (SourceEntry 1) is untouched. Horde quests, positive conditions.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 11127 AND `SourceEntry` = 0;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 11127, 0, 0, 0, 8, 0, 24643, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded'),
(15, 11127, 0, 0, 1, 8, 0, 24755, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded'),
(15, 11127, 0, 0, 2, 8, 0, 24763, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded'),
(15, 11127, 0, 0, 3, 8, 0, 24769, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded'),
(15, 11127, 0, 0, 4, 8, 0, 24775, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded'),
(15, 11127, 0, 0, 5, 8, 0, 24781, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded'),
(15, 11127, 0, 0, 6, 8, 0, 24787, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded'),
(15, 11127, 0, 0, 7, 8, 0, 26277, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded'),
(15, 11127, 0, 0, 8, 8, 0, 31163, 0, 0, 0, 0, 0, '', 'Vol''jin - Garrosh vision replay only after a More Than Expected is rewarded');
