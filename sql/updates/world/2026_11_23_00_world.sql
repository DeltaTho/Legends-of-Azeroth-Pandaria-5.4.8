-- Swamp of Sorrows A (_00): the Bogpaddle chain gates (plan A-01..A-04; S1 dossier 1.3, F-CHAIN-1..4).
--
-- SOURCED: wiki Template:Bogpaddle and quest boxes (27587 "previous = Bullet or Hero's Call or Warchief's Command (all
-- optional)"; 27536 / 27656 / 27663 previous = Maliciously Delicious; 27597 previous = Mostly Harmless and Croc-Out; 27600
-- previous = Kill Gil and Can't Take It With Them); Wowhead comments (28675 2010-12-19 a partner without the breadcrumb did the
-- whole zone; 28570 2011-11-19 [+10] and replies, 28675 2011-01-27, wiki 28675: not two breadcrumbs of one faction at once;
-- 28569 2011-10-09 / 28677 2012-09-04: closed once the zone's chain is started; 27536 2011-12-17 [+20], 27598 reply [+22]
-- "complete 27587 ... unlock 27536 and 27656 ... you will then be given 27597" before Kill Gil; wiki 27598 / 27599 previous =
-- Crazy Larry);
-- both TDBs' starter lists (Silversnap alone gives 27597, Crazy Larry alone gives 27740).
-- OURS: the encoding. No ExclusiveGroup on the breadcrumbs (a positive group would also forbid the second after the first is
-- rewarded, against two "did both" reports): source-19 rows instead, QUESTSTATE mask 1 = neither in the log nor rewarded,
-- mask 10 = in the log. Negative ExclusiveGroups = every member rewarded (the TDBs' positive groups mean "one of" here).
-- Kill Gil / Can't Take It With Them gated on Crazy Larry: both TDBs have no PrevQuestID there; the wiki boxes and the comment
-- above put them after it. 27597 is reachable for everyone (Silversnap, after 27587 -> 27536 + 27656; 27587 needs nothing).
-- The source-19 rows on 28569 / 28570 change what Oralius 9177 / Kibler 10260 offer in Burning Steppes (zone 46): the
-- Bullet is hidden while the faction's board quest is held and once 27587 is taken. No zone-46 creature row is touched.
-- Idempotent: absolute UPDATEs, DELETE + INSERT.

-- A-01: 27587 Maliciously Delicious no longer needs a breadcrumb (their NextQuestID made it depend on one of them)
UPDATE `quest_template_addon` SET `NextQuestID` = 0 WHERE `ID` IN (28569, 28570, 28675, 28677);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` IN (28569, 28570, 28675, 28677) AND `ConditionTypeOrReference` = 47;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 28569, 0, 0, 47, 0, 27587,  1, 0, 0, 0, 0, '', 'The Bogpaddle Bullet (A) - only while Maliciously Delicious is neither in the log nor rewarded'),
(19, 0, 28569, 0, 0, 47, 0, 28675, 10, 0, 1, 0, 0, '', 'The Bogpaddle Bullet (A) - not while Hero''s Call: Swamp of Sorrows! is in the log'),
(19, 0, 28675, 0, 0, 47, 0, 27587,  1, 0, 0, 0, 0, '', 'Hero''s Call: Swamp of Sorrows! - only while Maliciously Delicious is neither in the log nor rewarded'),
(19, 0, 28675, 0, 0, 47, 0, 28569, 10, 0, 1, 0, 0, '', 'Hero''s Call: Swamp of Sorrows! - not while The Bogpaddle Bullet is in the log'),
(19, 0, 28570, 0, 0, 47, 0, 27587,  1, 0, 0, 0, 0, '', 'The Bogpaddle Bullet (H) - only while Maliciously Delicious is neither in the log nor rewarded'),
(19, 0, 28570, 0, 0, 47, 0, 28677, 10, 0, 1, 0, 0, '', 'The Bogpaddle Bullet (H) - not while Warchief''s Command: Swamp of Sorrows! is in the log'),
(19, 0, 28677, 0, 0, 47, 0, 27587,  1, 0, 0, 0, 0, '', 'Warchief''s Command: Swamp of Sorrows! - only while Maliciously Delicious is neither in the log nor rewarded'),
(19, 0, 28677, 0, 0, 47, 0, 28570, 10, 0, 1, 0, 0, '', 'Warchief''s Command: Swamp of Sorrows! - not while The Bogpaddle Bullet is in the log');

-- A-02: Mostly Harmless, Croc-Out and Tastes Like Strider after Maliciously Delicious
-- A-03: Crazy Larry needs both Mostly Harmless and Croc-Out; In With a Bang needs both Kill Gil and Can't Take It With Them
UPDATE `quest_template_addon` SET `PrevQuestID` = 27587, `ExclusiveGroup` = -27536 WHERE `ID` IN (27536, 27656);
INSERT INTO `quest_template_addon` (`ID`, `PrevQuestID`) VALUES (27663, 27587) ON DUPLICATE KEY UPDATE `PrevQuestID` = 27587;
-- A-03b (review W2): Kill Gil and Can't Take It With Them after Crazy Larry (wiki previous = Crazy Larry; 27598 reply [+22])
UPDATE `quest_template_addon` SET `PrevQuestID` = 27597, `ExclusiveGroup` = -27598 WHERE `ID` IN (27598, 27599);

-- A-04: only Trade Baron Silversnap gives Crazy Larry, only Crazy Larry gives Baba Bogbrew
DELETE FROM `creature_queststarter` WHERE (`id`, `quest`) IN ((45948, 27597), (46172, 27740));
