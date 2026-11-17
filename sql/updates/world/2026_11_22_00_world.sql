-- Burning Steppes A (_00): quest chain gates of Flamestar Post, Gorzeeki and Chiselgrip (plan A-01..A-05, A-12, A-15, A-16, A-18, A-20, A-22..A-26, A-29).
--
-- SOURCED: wiki quest boxes ("previous = Mouton or Hero's Call or Warchief's Command (all optional)"; Stocking Up / A Future Project /
-- Mud Hunter after Burning Vengeance; The Sand, the Cider, and the Orb after all three; Return after both Gorzeeki quests;
-- Chiselgrip after Done Nothing Wrong; Stebben's quests after Chiselgrip; Golem Training after both), Wowhead comments (28172
-- 2010-11-25, 28417 2010-11-26 "no pre-requisite"; 28514 2011-08-16 DNW blocks Mouton; 28667 2012-09-04 boards close once the zone's
-- chain is started; 28184 2010-12-13 / 28426 2010-11-28 need DNW; 28174 2011-04-21 Keeshan gives 28416 after Redridge), both TDBs'
-- starter lists (no Gorzeeki for 28180/28422, no Ariok for 28425, no Stebben for 28184/28426).
-- OURS: the encoding (negative ExclusiveGroups = all members needed; QUESTSTATE mask 1 = neither held nor rewarded); the Redridge
-- quest that decides 28416 vs 28174 is 26726 Triumphant Return (the last Keeshan quest of Redridge, inferred; user question Q5).
-- Searing Gorge's giver-side quests 28514/28515 (Mouton Flamestar): NextQuestID 0 and the two source-19 rows below are written
-- here by agreement (plan.md section 3); their texts stay with Searing Gorge.
-- Idempotent: absolute UPDATEs, DELETE + INSERT.

-- G1 breadcrumbs optional: a breadcrumb's NextQuestID made its target depend on it (DependentPreviousQuests)
UPDATE `quest_template_addon` SET `PrevQuestID` = 0 WHERE `ID` IN (28172, 28417, 28174, 28418);
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28514, 28515, 28666, 28667);

-- G4 Horde gathering quests after Burning Vengeance (Alliance has two Burning Vengeance copies: conditions below)
UPDATE `quest_template_addon` SET `PrevQuestID` = 28418 WHERE `ID` IN (28419, 28420, 28421);
-- G5 every member needed for the follow-up (the TDBs' positive groups are mutually exclusive in this core: not copied)
UPDATE `quest_template_addon` SET `ExclusiveGroup` = -28177 WHERE `ID` IN (28177, 28178, 28179);
UPDATE `quest_template_addon` SET `ExclusiveGroup` = -28419 WHERE `ID` IN (28419, 28420, 28421);
UPDATE `quest_template_addon` SET `ExclusiveGroup` = -28181 WHERE `ID` IN (28181, 28182);
UPDATE `quest_template_addon` SET `ExclusiveGroup` = -28423 WHERE `ID` IN (28423, 28424);
UPDATE `quest_template_addon` SET `ExclusiveGroup` = -28225 WHERE `ID` IN (28225, 28226);
-- F-14 Gorzeeki's two quests after The Sand, the Cider, and the Orb (wiki previous)
UPDATE `quest_template_addon` SET `PrevQuestID` = 28180 WHERE `ID` IN (28181, 28182);
UPDATE `quest_template_addon` SET `PrevQuestID` = 28422 WHERE `ID` IN (28423, 28424);

-- G8 starters neither TDB has
DELETE FROM `creature_queststarter` WHERE (`id`, `quest`) IN ((14437, 28180), (14437, 28422), (48559, 28425), (48033, 28184), (48033, 28426));

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceGroup` = 0 AND `SourceEntry` IN
  (28514, 28515, 28666, 28667, 28174, 28416, 28177, 28178, 28179, 28184, 28426, 28225, 28226);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
-- G2 a breadcrumb closes once its target is taken
(19, 0, 28514, 0, 0, 47, 0, 28172, 1, 0, 0, 0, 0, '', 'Mouton Flamestar (A) - only while Done Nothing Wrong is neither held nor rewarded'),
(19, 0, 28515, 0, 0, 47, 0, 28417, 1, 0, 0, 0, 0, '', 'Mouton Flamestar (H) - only while Done Nothing Wrong is neither held nor rewarded'),
(19, 0, 28666, 0, 0, 47, 0, 28174, 1, 0, 0, 0, 0, '', 'Hero''s Call: Burning Steppes! - only while Burning Vengeance 28174 is neither held nor rewarded'),
(19, 0, 28666, 0, 0, 47, 0, 28416, 1, 0, 0, 0, 0, '', 'Hero''s Call: Burning Steppes! - and Burning Vengeance 28416 neither'),
(19, 0, 28667, 0, 0, 47, 0, 28418, 1, 0, 0, 0, 0, '', 'Warchief''s Command: Burning Steppes! - only while Burning Vengeance is neither held nor rewarded'),
-- G3 Burning Vengeance: 28416 after Redridge (26726 Triumphant Return), 28174 otherwise, never both
(19, 0, 28416, 0, 0, 8, 0, 26726, 0, 0, 0, 0, 0, '', 'Burning Vengeance (Redridge) - Triumphant Return rewarded'),
(19, 0, 28416, 0, 0, 47, 0, 28174, 1, 0, 0, 0, 0, '', 'Burning Vengeance (Redridge) - not while the other copy is held or rewarded'),
(19, 0, 28174, 0, 0, 8, 0, 26726, 0, 0, 1, 0, 0, '', 'Burning Vengeance - Triumphant Return not rewarded'),
(19, 0, 28174, 0, 0, 47, 0, 28416, 1, 0, 0, 0, 0, '', 'Burning Vengeance - not while the Redridge copy is held or rewarded'),
-- G4 Alliance gathering quests after either Burning Vengeance
(19, 0, 28177, 0, 0, 8, 0, 28174, 0, 0, 0, 0, 0, '', 'Stocking Up - Burning Vengeance rewarded'),
(19, 0, 28177, 0, 1, 8, 0, 28416, 0, 0, 0, 0, 0, '', 'Stocking Up - or Burning Vengeance (Redridge) rewarded'),
(19, 0, 28178, 0, 0, 8, 0, 28174, 0, 0, 0, 0, 0, '', 'A Future Project - Burning Vengeance rewarded'),
(19, 0, 28178, 0, 1, 8, 0, 28416, 0, 0, 0, 0, 0, '', 'A Future Project - or Burning Vengeance (Redridge) rewarded'),
(19, 0, 28179, 0, 0, 8, 0, 28174, 0, 0, 0, 0, 0, '', 'Mud Hunter - Burning Vengeance rewarded'),
(19, 0, 28179, 0, 1, 8, 0, 28416, 0, 0, 0, 0, 0, '', 'Mud Hunter - or Burning Vengeance (Redridge) rewarded'),
-- G6 Chiselgrip needs Done Nothing Wrong (ships with _01, which makes Done Nothing Wrong completable)
(19, 0, 28184, 0, 0, 8, 0, 28172, 0, 0, 0, 0, 0, '', 'Chiselgrip, the Heart of the Steppes (A) - Done Nothing Wrong rewarded'),
(19, 0, 28426, 0, 0, 8, 0, 28417, 0, 0, 0, 0, 0, '', 'Chiselgrip, the Heart of the Steppes (H) - Done Nothing Wrong rewarded'),
-- G7 Stebben's quests after Chiselgrip (both factions: AllowableRaces 0)
(19, 0, 28225, 0, 0, 8, 0, 28184, 0, 0, 0, 0, 0, '', 'Prove Yer Allegiance - Chiselgrip (A) rewarded'),
(19, 0, 28225, 0, 1, 8, 0, 28426, 0, 0, 0, 0, 0, '', 'Prove Yer Allegiance - or Chiselgrip (H) rewarded'),
(19, 0, 28226, 0, 0, 8, 0, 28184, 0, 0, 0, 0, 0, '', 'Scrapped Golems - Chiselgrip (A) rewarded'),
(19, 0, 28226, 0, 1, 8, 0, 28426, 0, 0, 0, 0, 0, '', 'Scrapped Golems - or Chiselgrip (H) rewarded');
