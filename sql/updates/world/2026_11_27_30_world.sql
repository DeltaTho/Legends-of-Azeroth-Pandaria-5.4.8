-- Shipwreck Searching (25178, Gail Nozzywig) needs From Bad to Worse (25173, Gar'Thok) handed in as well as Exploiting the Situation (25176).
-- Sourced: comment 2011-05-24 on 25178 ("you need to complete From Bad to Worse and Exploiting the Situation"); both TDBs give 25173 and 25176
-- NextQuestID 25178 with ExclusiveGroup -25173. Ours: the mechanism. The TDB rows are not copied: this core gives every quest whose
-- PrevQuestID is 25173 (Storming the Beaches 25177, Loss Reduction 25179) the group check too (Player.cpp SatisfyQuestDependentPreviousQuests,
-- ObjectMgr DependentPreviousQuests), so they would need Gail's quest as well and Gar'Thok's RewardNextQuest 25177 would fail.
-- A quest-accept condition instead, read by CanTakeQuest (gossip list, accept, party share, RewardNextQuest) and by the quest giver status
-- for the quests an NPC starts AND ends (Player::GetQuestDialogStatus, both loops). So Gail shows no "!" for 25178 until both are done.
-- ElseGroup 1 keeps the condition true while 25178 itself is in the log (type 47, mask 10 = complete | incomplete): that only restores her
-- "?" for a player who took 25178 before this file (or without 25173); the offer stays closed because an in-log quest already fails
-- SatisfyQuestStatus. ConditionValue3 0: 25173 and 25178 are Horde-only and only a Horde player can hold either, so the AllowableRaces case
-- of type 8 (ConditionMgr.cpp:231-244) reduces to the plain reward check, and value3 1 would log "useless data" at every start.
-- 25173..25179 rows unchanged.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 25178 AND ((`ElseGroup` = 0 AND `ConditionTypeOrReference` = 8 AND `ConditionValue1` = 25173) OR (`ElseGroup` = 1 AND `ConditionTypeOrReference` = 47 AND `ConditionValue1` = 25178));
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,25178,0,0,8,0,25173,0,0,0,0,0,'','Shipwreck Searching - needs From Bad to Worse rewarded too'),
(19,0,25178,0,1,47,0,25178,10,0,0,0,0,'','Shipwreck Searching - keep the turn-in marker while it is in the log');
