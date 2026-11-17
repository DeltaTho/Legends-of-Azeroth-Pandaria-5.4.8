-- Burning Steppes B (_17, fix round 1): the "radio" quests arrive by themselves, however the quest before them is finished.
--
-- SOURCED (wiki; comments):
-- * Abuse of Power 28279 / 28440 "start=Automatic": Troteman / Eitrigg radio in when I Am the Law / Lash 28278 / 28439 is accepted
--   (28440 2010-11-26 [+11] "plops open in your quest tracker"). The General's SmartAI push (_10) runs only when he is the giver, so a
--   player who got 28278 / 28439 by quest share never got it (walk trials W1).
-- * Placing the Pawns 28326 / 28449 "start=Automatic ... Troteman / Eitrigg will radio in" once Blood Tour, Draconic Vanguard and A
--   Deal With a Dragon are all done (wiki 28326 / 28449). Their enders differ (Keeshan / Ariok 03 in the field, a C++ follower, and
--   Acride), so no one NPC script can do it (walk vigil W1).
-- * Locked and Loaded 28327 / 28453 "start=Automatic ... Troteman radios in with this quest" after all three deliveries; 28453
--   2011-05-26 [+1] "accepted without text or sound ... you can see the questionmark on the map" (walk assault W3).
-- OURS, the mechanism: ten server-side spells (spell_dbc / spellmisc_dbc / spelleffect_dbc, the way 81040 exists here) with
-- SPELL_EFFECT_QUEST_START (150). Spell::EffectQuestStart adds the quest only if Player::CanTakeQuest and CanAddQuest pass, so it
-- fires on every hand-in of a set and succeeds only once the whole set is rewarded (negative exclusive groups -28314 / -28446 /
-- -28317 / -28450 + NextQuestID), and never re-adds a quest held or done; a quest without objectives completes at once.
-- * 300460 / 300461: quest_template_addon.SourceSpellID of 28278 / 28439 (the player casts it on every accept, NPC or shared,
--   QuestHandler.cpp). The General's push stays: on an NPC accept it adds the quest first (with its details window), the spell then
--   finds it held and does nothing.
-- * 300462 / 300463: RewardDisplaySpell of 28314-28316 / 28446-28448 (cast after the quest is marked rewarded, Player::RewardQuest;
--   RewardSpell is 0, so nothing is shown on the reward screen).
-- * 300464-300469: RewardDisplaySpell of the six deliveries in place of the package summons 90374 / 90376 / 90375 (_15): effect 0
--   triggers that summon (the package still appears beside the boss), effect 1 starts Locked and Loaded.
-- Spell ids 300460-300469, SpellMisc ids 300460-300469, SpellEffect ids 500460-500479: free in the 5.4.8 DBCs (max Spell 163227,
-- SpellEffect 229554, SpellMisc 137122), in mop_world and in the other Burning Steppes branches. SpellMisc attributes copied from
-- 81040's row 200158 (instant, self, hidden).
-- Idempotent: DELETE + INSERT, absolute UPDATEs.

DELETE FROM `spell_dbc` WHERE `Id` BETWEEN 300460 AND 300469;
DELETE FROM `spellmisc_dbc` WHERE `Id` BETWEEN 300460 AND 300469;
DELETE FROM `spelleffect_dbc` WHERE `Id` BETWEEN 500460 AND 500479;

INSERT INTO `spellmisc_dbc` (`Id`, `Attributes`, `AttributesEx`, `AttributesEx2`, `AttributesEx3`, `AttributesEx4`, `AttributesEx5`, `AttributesEx6`, `AttributesEx7`, `AttributesEx8`, `AttributesEx9`, `AttributesEx10`, `AttributesEx11`, `AttributesEx12`, `AttributesEx13`, `CastingTimeIndex`, `DurationIndex`, `RangeIndex`, `SchoolMask`, `Comment`)
SELECT n.`Id`, m.`Attributes`, m.`AttributesEx`, m.`AttributesEx2`, m.`AttributesEx3`, m.`AttributesEx4`, m.`AttributesEx5`, m.`AttributesEx6`, m.`AttributesEx7`, m.`AttributesEx8`, m.`AttributesEx9`, m.`AttributesEx10`, m.`AttributesEx11`, m.`AttributesEx12`, m.`AttributesEx13`, 1, 0, 1, 1, CONCAT('spellid ', n.`Id`)
FROM `spellmisc_dbc` m
JOIN (SELECT 300460 AS `Id` UNION ALL SELECT 300461 UNION ALL SELECT 300462 UNION ALL SELECT 300463 UNION ALL SELECT 300464
      UNION ALL SELECT 300465 UNION ALL SELECT 300466 UNION ALL SELECT 300467 UNION ALL SELECT 300468 UNION ALL SELECT 300469) n
WHERE m.`Id` = 200158;

INSERT INTO `spell_dbc` (`Id`, `SpellAuraOptionsId`, `SpellCastingRequirementsId`, `SpellCategoriesId`, `SpellClassOptionsId`, `SpellEquippedItemsId`, `SpellLevelsId`, `SpellTargetRestrictionsId`, `SpellInterruptsId`, `SpellMiscId`, `Comment`) VALUES
(300460, 0, 0, 0, 0, 0, 0, 0, 0, 300460, 'Burning Steppes - radio: start Abuse of Power (A) 28279'),
(300461, 0, 0, 0, 0, 0, 0, 0, 0, 300461, 'Burning Steppes - radio: start Abuse of Power (H) 28440'),
(300462, 0, 0, 0, 0, 0, 0, 0, 0, 300462, 'Burning Steppes - radio: start Placing the Pawns (A) 28326'),
(300463, 0, 0, 0, 0, 0, 0, 0, 0, 300463, 'Burning Steppes - radio: start Placing the Pawns (H) 28449'),
(300464, 0, 0, 0, 0, 0, 0, 0, 0, 300464, 'Burning Steppes - delivery for Thorg''izog (A): package 90374 + start Locked and Loaded 28327'),
(300465, 0, 0, 0, 0, 0, 0, 0, 0, 300465, 'Burning Steppes - delivery for Neeralak (A): package 90376 + start Locked and Loaded 28327'),
(300466, 0, 0, 0, 0, 0, 0, 0, 0, 300466, 'Burning Steppes - delivery for Xi''lun (A): package 90375 + start Locked and Loaded 28327'),
(300467, 0, 0, 0, 0, 0, 0, 0, 0, 300467, 'Burning Steppes - delivery for Thorg''izog (H): package 90374 + start Locked and Loaded 28453'),
(300468, 0, 0, 0, 0, 0, 0, 0, 0, 300468, 'Burning Steppes - delivery for Neeralak (H): package 90376 + start Locked and Loaded 28453'),
(300469, 0, 0, 0, 0, 0, 0, 0, 0, 300469, 'Burning Steppes - delivery for Xi''lun (H): package 90375 + start Locked and Loaded 28453');

-- (Id, Effect, MiscValue, TriggerSpell, SpellId, EffectIndex); target A 1 = the caster (the player)
INSERT INTO `spelleffect_dbc` (`Id`, `Effect`, `EffectValueMultiplier`, `EffectApplyAuraName`, `EffectAplitude`, `EffectBasePoints`, `EffectBonusMultiplier`, `EffectDamageMultiplier`, `EffectChainTarget`, `EffectDieSides`, `EffectMechanic`, `EffectMiscValue`, `EffectMiscValueB`, `EffectRadiusIndex`, `EffectRadiusIndexMax`, `EffectRealPointsPerLevel`, `EffectSpellClassMaskA`, `EffectSpellClassMaskB`, `EffectSpellClassMaskC`, `EffectSpellClassMaskD`, `EffectTriggerSpell`, `EffectImplicitTargetA`, `EffectImplicitTargetB`, `EffectSpellId`, `EffectIndex`, `EffectAttributes`) VALUES
(500460, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28279, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300460, 0, 0),
(500461, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28440, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300461, 0, 0),
(500462, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28326, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300462, 0, 0),
(500463, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28449, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300463, 0, 0),
(500464,  64, 0, 0, 0, 0, 0, 1, 0, 0, 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 90374, 1, 0, 300464, 0, 0),
(500465, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28327, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300464, 1, 0),
(500466,  64, 0, 0, 0, 0, 0, 1, 0, 0, 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 90376, 1, 0, 300465, 0, 0),
(500467, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28327, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300465, 1, 0),
(500468,  64, 0, 0, 0, 0, 0, 1, 0, 0, 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 90375, 1, 0, 300466, 0, 0),
(500469, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28327, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300466, 1, 0),
(500470,  64, 0, 0, 0, 0, 0, 1, 0, 0, 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 90374, 1, 0, 300467, 0, 0),
(500471, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28453, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300467, 1, 0),
(500472,  64, 0, 0, 0, 0, 0, 1, 0, 0, 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 90376, 1, 0, 300468, 0, 0),
(500473, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28453, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300468, 1, 0),
(500474,  64, 0, 0, 0, 0, 0, 1, 0, 0, 0,     0, 0, 0, 0, 0, 0, 0, 0, 0, 90375, 1, 0, 300469, 0, 0),
(500475, 150, 0, 0, 0, 0, 0, 1, 0, 0, 0, 28453, 0, 0, 0, 0, 0, 0, 0, 0, 0,     1, 0, 300469, 1, 0);

UPDATE `quest_template_addon` SET `SourceSpellID` = 300460 WHERE `ID` = 28278;
UPDATE `quest_template_addon` SET `SourceSpellID` = 300461 WHERE `ID` = 28439;
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 300462 WHERE `ID` IN (28314, 28315, 28316);
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 300463 WHERE `ID` IN (28446, 28447, 28448);
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 300464 WHERE `ID` = 28317;
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 300465 WHERE `ID` = 28318;
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 300466 WHERE `ID` = 28319;
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 300467 WHERE `ID` = 28450;
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 300468 WHERE `ID` = 28451;
UPDATE `quest_template` SET `RewardSpell` = 0, `RewardDisplaySpell` = 300469 WHERE `ID` = 28452;
