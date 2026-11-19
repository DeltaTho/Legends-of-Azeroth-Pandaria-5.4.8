-- Bom'bay's voodoo (gossip menu 3062: frog/snake/chicken hex, grow, launch, brew, ghost) opens after Never Trust a Big Barb and a Smile
-- (25165), not after the retired Zalazane (826), which has no starter: nobody could ever see the seven options.
-- Sourced: both TDBs gate options 0-6 on 25165 rewarded; Wowhead 25165 2010-11-24 [+9], 2010-12-04 [+14], 2010-12-01 [+8] (the voodoo
-- after this quest); the reward text "You come back to Bom'bay when you be needin' a pickup. Bom'bay got the spells to fix ya!".
-- Ours: the greeting 3795 ("Since you help me, I help ya for free. Whatcha need fixin?") on the same condition; both TDBs keep 826 on it,
-- which would show the options under the default "Once I get my hands on a few more supplies, I fix ya right up!".
-- 25165 is Horde-only; with ConditionValue3 0 an Alliance player fails the condition (no options), as before.
UPDATE `conditions` SET `ConditionValue1` = 25165, `Comment` = 'Bom''bay - show gossip option if Never Trust a Big Barb and a Smile rewarded'
 WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 3062 AND `SourceEntry` BETWEEN 0 AND 6 AND `ConditionTypeOrReference` = 8 AND `ConditionValue1` IN (826, 25165);
UPDATE `conditions` SET `ConditionValue1` = 25165, `Comment` = 'Bom''bay - show text 3795 if Never Trust a Big Barb and a Smile rewarded'
 WHERE `SourceTypeOrReferenceId` = 14 AND `SourceGroup` = 3062 AND `SourceEntry` = 3795 AND `ConditionTypeOrReference` = 8 AND `ConditionValue1` IN (826, 25165);
