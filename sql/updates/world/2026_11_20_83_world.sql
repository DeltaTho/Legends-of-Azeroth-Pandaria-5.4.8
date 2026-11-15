-- Badlands H-4: Devastation 27930 can be taken again at Rhea's Final Note after an abandon
-- Devastation is added by itself when a Gift is handed in from the log (RewardNextQuest, AUTO_ACCEPT | AUTO_TAKE). After an
-- abandon nothing offered it again but Rhea 46654's starter row, and Rhea is gone by then (her Clutch copy hides once the Gift is
-- taken, section B). The note 206504 in the cave, Devastation's ender, now offers it; Rhea no longer does.
-- Sourced: no starter in either TDB or on Wowhead; a 2024 comment re-offered it by walking back to the hill (retail bug).
-- Ours: the note as starter (the quest stays gated on a Gift through the Gifts' NextQuestID 27930).
DELETE FROM `creature_queststarter` WHERE `id`=46654 AND `quest`=27930;
DELETE FROM `gameobject_queststarter` WHERE `id`=206504 AND `quest`=27930;
INSERT INTO `gameobject_queststarter` (`id`,`quest`) VALUES (206504,27930);
