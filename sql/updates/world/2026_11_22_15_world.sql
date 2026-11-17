-- Burning Steppes B (_15): Glory Amidst Chaos map area, helper spells off the reward screens, Placing the Pawns flags (plan B-20, B-22,
-- B-23; S4-F9, S4-F11 extended by K11, S4-F12). S4-F10 (Worgsaw) needs nothing: 28313 / 28445 already have ItemDrop2 63427 x1 as
-- both TDBs, so Player::RewardQuest takes the saw (the dossier's "ItemDrop all 0" was wrong).
--
-- SOURCED:
-- * Glory Amidst Chaos 28321 / 28455: the area at (-7770,-2775) / (-7770,-2767) is High Warlock Xi'lun's (objective index 2) in both
--   TDBs; mop gave it to General Thorg'izog's objective, so Thorg'izog showed two areas and Xi'lun none.
-- * Placing the Pawns 28326 / 28449: Flags 0x10C0000, i.e. TDB 4.4.2's 0x11C0000 without 0x100000. That bit is TC's
--   PLAYER_CAST_ON_ACCEPT, but this core reads it as AUTO_SUBMIT (C65) and there is no start spell to cast: it would only allow a
--   submit that skips the hand-in at Troteman / Eitrigg, where the new Blackrock Disguise is given (_16). Ours on dropping it.
-- * Helper spells listed as rewards (core rule C21: the quest screen shows RewardSpell; RewardDisplaySpell is still cast when
--   RewardSpell is 0, C58): 90374 / 90375 / 90376 (the delivered package appears beside the boss), 90365 Remove Blackrock Disguise
--   (Enough Damage For One Day and Locked and Loaded), and 81040 (a server-only spell_dbc row "deleted spell for some quests" the
--   5.4.8 client lacks; on 28310 / 28442 it updates zone auras and phases) on the zone's 24 quests that carry it. Same rule as Searing
--   Gorge 2026_11_21_36 and Badlands 2026_11_20_07.
-- Idempotent: absolute or guarded UPDATEs.

UPDATE `quest_poi` SET `ObjectiveIndex` = 2, `QuestObjectiveId` = 254995 WHERE `QuestID` = 28321 AND `Idx1` = 3;
UPDATE `quest_poi` SET `ObjectiveIndex` = 2, `QuestObjectiveId` = 259067 WHERE `QuestID` = 28455 AND `Idx1` = 3;

UPDATE `quest_template` SET `RewardDisplaySpell` = `RewardSpell`, `RewardSpell` = 0
 WHERE `ID` IN (28317, 28318, 28319, 28450, 28451, 28452, 28327, 28453, 28286, 28441) AND `RewardSpell` IN (90374, 90375, 90376, 90365);
UPDATE `quest_template` SET `RewardDisplaySpell` = 81040, `RewardSpell` = 0
 WHERE `ID` IN (28172, 28177, 28178, 28179, 28183, 28184, 28253, 28310, 28311, 28312, 28313, 28321,
                28417, 28419, 28420, 28421, 28425, 28426, 28436, 28442, 28443, 28444, 28445, 28455) AND `RewardSpell` = 81040;

UPDATE `quest_template` SET `Flags` = 17563648 WHERE `ID` IN (28326, 28449);
