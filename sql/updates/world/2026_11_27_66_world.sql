-- Durotar: Beyond Durotar (25648) is offered by Gor the Enforcer after Ignoring the Warnings (25206), not after Skull Rock.
-- mop gave it PrevQuestID 25262 Skull Rock and 25262 NextQuestID 25648: Skull Rock is handed in to Margoz, after which nothing
-- sends the player back to Gor, so Beyond Durotar was in practice never offered.
-- Sourced: warcraft.wiki.gg Beyond Durotar infobox "previous = Ignoring the Warnings"; the quest text ("I'm sure you still have
-- work to do here in Durotar"). Both TDBs have no addon row for 25648 (prev 0) and 25262 NextQuestID 0; the wiki is taken where
-- the TDB has 0 (quest-chain-phasing rule).
-- After this 25648's previous-quest list is 25206 alone (ObjectMgr.cpp fills it from PrevQuestID and from quests whose
-- NextQuestID points here; none does any more).
-- Left for the Azshara/Orgrimmar pass: not offered while Warchief's Command: Azshara! (28496) is taken (comment 2011-05-30).

UPDATE `quest_template_addon` SET `PrevQuestID` = 25206 WHERE `ID` = 25648;
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` = 25262;
