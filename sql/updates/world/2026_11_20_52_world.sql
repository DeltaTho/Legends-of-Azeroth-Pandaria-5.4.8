-- Badlands, Tomb of the Watchers: the two Games and Ancient Protectors are handed in from the quest log, and Ancient Protectors
-- needs BOTH Games. Ships only with the board scripts (2026_11_20_50 / _51 and zone_badlands_titans.cpp): a log turn-in quest
-- must still earn its objective first (Player.cpp, CanCompleteQuest), and nothing else gives the Games' credit.
--
-- Sourced: Flags of TDB 12.1.0 on the four Games, 1638400 (AUTO_COMPLETE 0x10000 | AUTO_ACCEPT 0x80000 | 0x100000); TDB 4.4.2
--   has 10289152 (0x9D0000: mop's 0x9C0000 plus AUTO_COMPLETE), the same in this core, which reads only 0x10000 / 0x80000 /
--   0x100000 of them; 589824 (AUTO_COMPLETE | AUTO_ACCEPT) on Ancient Protectors 27793 / 27887 in both TDBs; comments ("Click here to continue", the quest pops up
--   after the second game, Carbonite users could not see the log hand-in); neither TDB has the slabs as enders.
-- Ours: the negative ExclusiveGroups (this core's "every quest of the group rewarded" for a dependent previous quest,
--   Player::SatisfyQuestDependentPreviousQuests): Ancient Protectors names both Games as previous quests through their
--   NextQuestID, and one rewarded Game was enough. The TDBs' positive groups (+27693, +27885) make the members mutually
--   exclusive here and are not taken. No SourceSpellID (the slab starts the board on accept; the accept handler would cast it a
--   second time) and no PrevQuestID on Ancient Protectors (AUTO_ACCEPT is added directly after the log hand-in).

UPDATE `quest_template` SET `Flags`=1638400 WHERE `ID` IN (27693,27709,27885,27886);
UPDATE `quest_template` SET `Flags`=589824 WHERE `ID` IN (27793,27887);

UPDATE `quest_template_addon` SET `ExclusiveGroup`=-27693 WHERE `ID` IN (27693,27709);
UPDATE `quest_template_addon` SET `ExclusiveGroup`=-27885 WHERE `ID` IN (27885,27886);

-- A log hand-in quest at a slab only shows a stray "?" there
DELETE FROM `gameobject_questender` WHERE `id` IN (206335,206336) AND `quest` IN (27693,27709,27885,27886,27793,27887);
