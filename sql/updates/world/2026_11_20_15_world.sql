-- Dragon's Mouth / New Kargath: the companions' training quests follow The Swift, the Fierce, and the Stout / The Bad Dogs, and
-- the last training hand-in offers The Wrath of a Dragonflight.
--
-- Training quests: Eric 27828, Baelog 27834, Olaf 27835 (Alliance); Amakkar 27891, Jurrix 27892, Gargal 27893 (Horde).
-- PrevQuestID 27827 / 27890: sourced wiki (previous), Badlands ruling R2; the static givers are hidden until then anyway
--   (section B), so this closes the paths around them.
-- RewardNextQuest 27829 / 27894: sourced both TDBs (27829 on the Alliance three); the Horde three carry 27829 in both TDBs, a
--   copy error, corrected to 27894 (ours). The next quest is offered only when it can be taken, i.e. at the last of the three
--   hand-ins (ExclusiveGroup -27828 / -27891 with NextQuestID 27829 / 27894), by the companion, who starts it: "Upon completing
--   the three previous quests, Rhea speaks telepathically" (wiki; PortraitGiver Rheastrasza). 27829 / 27894 are AUTO_ACCEPT.

UPDATE `quest_template_addon` SET `PrevQuestID` = 27827 WHERE `ID` IN (27828, 27834, 27835);
UPDATE `quest_template_addon` SET `PrevQuestID` = 27890 WHERE `ID` IN (27891, 27892, 27893);

UPDATE `quest_template` SET `RewardNextQuest` = 27829 WHERE `ID` IN (27828, 27834, 27835);
UPDATE `quest_template` SET `RewardNextQuest` = 27894 WHERE `ID` IN (27891, 27892, 27893);
