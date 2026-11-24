-- Echo Isles story chain: prerequisite groups, one stray starter, Vol'jin's Thrall replay, the optional "Speak" step, auto-accept.
-- Sourced throughout; no row of 25073 Sen'jin Village (Durotar's) is touched.
--
-- 1. Young and Vicious needs Saving the Young, Mercy for the Lost AND Consort of the Sea Witch; An Ancient Enemy needs No More
--    Mercy AND Territorial Fetish. Sourced: ExclusiveGroup -24623 / -24812 in both TDBs; warcraft.wiki.gg "previous" of 24626 and
--    24814; Wowhead 24626 2011-03-25 ("requires completion of Consort of the Sea Witch"). mop had group 0 = "any one of them"
--    (Player::SatisfyQuestDependentPreviousQuests: a rewarded dependent with a negative group needs every member rewarded).
--    24626 keeps PrevQuestID 24623 (TDB 0; 24623 is a member anyway). 25073 still needs 24814 only.
UPDATE `quest_template_addon` SET `ExclusiveGroup` = -24623 WHERE `ID` IN (24623, 24624, 24625);
UPDATE `quest_template_addon` SET `ExclusiveGroup` = -24812 WHERE `ID` IN (24812, 24813);

-- 2. Vol'jin 38966 at Darkspear Hold no longer offers An Ancient Enemy. Sourced: neither TDB starts 24814 there; the wiki's giver
--    is Morakki. Morakki 38442 (Spitescale Cove, always visible) and Vol'jin 38225 (above the cave) still start it; 38966 still
--    ends it and still starts 25064 and 25073.
DELETE FROM `creature_queststarter` WHERE `id` = 38966 AND `quest` = 24814;

-- 3. "You spoke of communing with Thrall? Did I miss it?" (menu 11127 option 1) shows only once An Ancient Enemy is rewarded.
--    Sourced: warcraft.wiki.gg 24814 ("After the conversation ends, players can speak to Vol'jin to watch it again"); mop showed
--    it to every player from level 1. 24814 is a Horde quest and the condition is positive, so ConditionValue3 stays 0.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = 11127 AND `SourceEntry` = 1;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 11127, 1, 0, 0, 8, 0, 24814, 0, 0, 0, 0, 0, '', 'Vol''jin - Thrall vision replay only after An Ancient Enemy is rewarded');

-- 4. "Speak with Vol'jin at Spitescale Cove" is optional. Sourced: TDB 12.1.0 quest_objectives 265488 Flags 5; warcraft.wiki.gg
--    "(Optional)". Player::CanCompleteQuest skips objectives flagged 0x4, so a player who arrives while another player's fight
--    runs completes on Zar'jira's death (her death credit to helpers: 2026_12_08_09).
UPDATE `quest_objective` SET `flags` = 5 WHERE `questId` = 24814 AND `id` = 265488;

-- 5. Young and Vicious and Breaking the Line are auto-accepted (Flags as both TDBs: 524288 / 17301504; 0x80000 is
--    QUEST_FLAGS_AUTO_ACCEPT, 0x1000000 is not read by this core). Kijara's raptor summon and Tortunga's "tell Jornun" still run:
--    the auto-accept path calls AddQuestAndCheckCompletion, which calls the giver AI's OnQuestAccept.
UPDATE `quest_template` SET `Flags` = 524288 WHERE `ID` = 24626;
UPDATE `quest_template` SET `Flags` = 17301504 WHERE `ID` = 25035;
