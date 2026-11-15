-- Lethlor Ravine: The Egg Lives On 27859 is offered only after Devastation 27930.
--
-- SHIP ONLY WITH section H's H-3 (Rheastrasza's Gift scene and its credit) and H-4: until H-4 removes Rhea's starter row,
-- Rhea still offers Devastation to anyone at any time, so shipped alone this gate blocks nothing; with H-3 / H-4 Devastation
-- comes only from the Gift (or the note after an abandon).
--
-- Blam at Agmond's End offered the chain's last quest, with its blue trinket, to every player of level 44 from the start.
-- Sourced: wiki 27859 / 27930 (previous = Devastation; Blam appears at the cave mouth once Devastation is done). Against both
--   TDBs, which have no link and no addon row (Badlands ruling R2: enforced). Ours: the mechanism. The Agmond's End Blam then
--   also offers it after Devastation, as well as the cave copy (section B): acceptable.
-- No addon row exists for 27859: INSERT IGNORE creates it, the absolute UPDATE sets the link; a row another section adds keeps
-- its other columns.

INSERT IGNORE INTO `quest_template_addon` (`ID`) VALUES (27859);
UPDATE `quest_template_addon` SET `PrevQuestID` = 27930 WHERE `ID` = 27859;
