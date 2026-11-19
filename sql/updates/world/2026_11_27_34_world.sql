-- Thonk (25227) is Gail Nozzywig's breadcrumb to Thonk's Lost in the Floods (25187), and it gated it: 25187 had PrevQuestID 25227 and 25227
-- NextQuestID 25187, so a player who skipped Gail's Tiragarde quests was never offered the Southfury Watershed chain. Thonk (39323) was also
-- a starter of his own breadcrumb (take and hand in on the spot) and could be attacked by Alliance players (faction 1074).
-- Sourced: both TDBs (25187 PrevQuestID 0; 25227 BreadcrumbForQuestId 25187; starters of 25227 Gail only; Thonk unit_flags 768
-- IMMUNE_TO_PC|IMMUNE_TO_NPC); Wowhead 25227 2010-12-01 replies ("simple breadcrumb, can't take it once you've completed the main quest"),
-- Wowhead MoP Start: Gail only.
-- Ours: the breadcrumb mechanism, as for the Northfold Manor and Stone Shards breadcrumbs (2026_11_25_02, 2026_11_25_60): NextQuestID 0 and a
-- quest-accept condition "Lost in the Floods never taken" (type 14, status NONE), which also closes the breadcrumb while 25187 is in the log
-- and reopens it if 25187 is abandoned. RewardNextQuest 25187 stays, so Thonk still offers Lost in the Floods when the breadcrumb is handed
-- in. The quest giver status reads quest-accept conditions for the quests an NPC ends too (Player::GetQuestDialogStatus), so a player who
-- holds the breadcrumb and takes 25187 first would lose Thonk's "?" for it (the gossip list does not read them, the hand-in worked):
-- ElseGroup 1 keeps the condition true while 25227 itself is in the log (type 47, mask 10 = complete | incomplete). The offer stays closed
-- then, because an in-log quest already fails SatisfyQuestStatus.
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` = 25187;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` = 25227;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 25227 AND ((`ElseGroup` = 0 AND `ConditionTypeOrReference` = 14 AND `ConditionValue1` = 25187) OR (`ElseGroup` = 1 AND `ConditionTypeOrReference` = 47 AND `ConditionValue1` = 25227));
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,25227,0,0,14,0,25187,0,0,0,0,0,'','Thonk - only while Lost in the Floods has never been taken'),
(19,0,25227,0,1,47,0,25227,10,0,0,0,0,'','Thonk - keep the turn-in marker while it is in the log');
DELETE FROM `creature_queststarter` WHERE `id` = 39323 AND `quest` = 25227;
UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 768 WHERE `entry` = 39323;
