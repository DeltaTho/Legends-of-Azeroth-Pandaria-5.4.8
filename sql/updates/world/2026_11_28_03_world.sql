-- Blasted Lands, 25771 One Draenei's Junk...: the Imperfect Draenethyst Fragment 10593 is the quest's source item again
-- The 4.3.4 TDB had SourceItemId (StartItem) 10593 and no ItemDrop, like 25772 Flawless Draenethyst Sphere (StartItem 8244).
-- LoA had StartItem 0 and ItemDrop1 10593 x1 next to the objective 10593 x1, so a kept fragment counted twice at turn-in.
-- With StartItem set, the accept handler keeps the fragment that starts the quest and Player::AddQuest gives no copy.
UPDATE `quest_template` SET `StartItem` = 10593, `ItemDrop1` = 0, `ItemDropQuantity1` = 0 WHERE `ID` = 25771;
