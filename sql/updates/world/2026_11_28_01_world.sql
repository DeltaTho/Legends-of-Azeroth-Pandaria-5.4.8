-- Durotar's two breadcrumbs become real breadcrumbs (quest_template_addon.BreadcrumbForQuestId, 2026_11_28_00), as both TDBs have them:
-- Sen'jin Village (25073, Vol'jin, ended by Master Gadrin) leads to Breaking the Chain (25167, Gadrin), and Thonk (25227, Gail Nozzywig,
-- ended by Thonk) leads to Lost in the Floods (25187, Thonk).
--
-- Until now they were emulated (2026_11_27_14, 2026_11_27_34): NextQuestID 0 on the breadcrumb, a quest-accept condition "target never
-- taken" (type 14) and an OR branch (ElseGroup 1, type 47 on the breadcrumb itself, mask 10) that only kept the ender's "?" while the
-- core still hid it for a failed accept condition. Those rows go; the NextQuestID / PrevQuestID / ExclusiveGroup clean-up of those files
-- stays (a breadcrumb must not also unlock its target).
--
-- Who is offered what, per state (the same for players and bots):
--   nothing done           breadcrumb offered once the target could be taken, target offered at its giver. "Could be taken" includes
--                          the target's MinLevel 4: a troll who finishes An Ancient Enemy (24814, level 5) below level 4 sees
--                          Sen'jin Village at 4 (new; the condition rows offered it at once). 25227 and 25187 both have MinLevel 4.
--   breadcrumb in the log  target NOT offered (new: the condition rows allowed both); the breadcrumb's ender shows "?", the hand-in
--                          works. Thonk then offers 25187 on the spot (25227 RewardNextQuest); Gadrin shows 25167's "!" afterwards
--                          (25073 has no RewardNextQuest).
--   breadcrumb rewarded    target offered; the breadcrumb is not offered again (not repeatable).
--   target taken first     breadcrumb not offered (as with the condition); if the target is abandoned, it is offered again.
--   target rewarded        breadcrumb not offered (as with the condition).
--   both in the log        (possible under the condition rows) the breadcrumb can still be handed in, with its "?".
-- 25073 keeps its PrevQuestID 24814 and 25227 its PrevQuestID 25178: requirements of the breadcrumbs themselves.
UPDATE `quest_template_addon` SET `BreadcrumbForQuestId` = 25167 WHERE `ID` = 25073;
UPDATE `quest_template_addon` SET `BreadcrumbForQuestId` = 25187 WHERE `ID` = 25227;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` = 25073 AND `SourceId` = 0 AND
    ((`ElseGroup` = 0 AND `ConditionTypeOrReference` = 14 AND `ConditionValue1` = 25167) OR (`ElseGroup` = 1 AND `ConditionTypeOrReference` = 47 AND `ConditionValue1` = 25073));
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` = 25227 AND `SourceId` = 0 AND
    ((`ElseGroup` = 0 AND `ConditionTypeOrReference` = 14 AND `ConditionValue1` = 25187) OR (`ElseGroup` = 1 AND `ConditionTypeOrReference` = 47 AND `ConditionValue1` = 25227));
