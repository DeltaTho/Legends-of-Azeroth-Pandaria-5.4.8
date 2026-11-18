-- Burning Steppes: let players put on the Blackrock Disguise (89261) again.
-- 2026_11_22_35 added two negated "quest rewarded" conditions (type 8) so the disguise cannot be worn after Locked and
-- Loaded (28327 Alliance / 28453 Horde). With ConditionValue3 0, ConditionMgr.cpp:231-244 evaluates a quest whose
-- AllowableRaces exclude the player as "NegativeCondition", so the negated row of the other faction's quest always fails:
-- every player got "You can't do that right now" on the disguise (smoke test 2026-11-17, smoke-triage.md F1).
-- ConditionValue3 1 checks the reward status plainly (never rewarded for the other faction's quest -> passes).
-- Ours: the mechanism. Sourced: the disguise cannot be worn after Locked and Loaded (S2 dossier, three comments).
UPDATE `conditions` SET `ConditionValue3` = 1
WHERE `SourceTypeOrReferenceId` = 17 AND `SourceGroup` = 0 AND `SourceEntry` = 89261
  AND `ConditionTypeOrReference` = 8 AND `ConditionValue1` IN (28327, 28453) AND `NegativeCondition` = 1;
