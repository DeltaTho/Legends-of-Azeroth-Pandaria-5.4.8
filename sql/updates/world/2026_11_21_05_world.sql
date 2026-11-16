-- Searing Gorge A-15, A-16, A-17: Finister's Spherule, Twilight Collar and Fire-Gizzard drop 100 %.
--
-- SOURCED: both TDBs: Spherule 100 %, Twilight Collar 100 % from 47309/47310/47311 (ministers). Wowhead item 62822 comment '100 % drop rate'
-- plus the user's rule: collars from 5860/5861/5862 (no collar row in either TDB; 8419 was already 100 %). OURS: Fire-Gizzard 100 % (no certain rate; the less
-- grindy one by the user's rule).
-- Idempotent: DELETE + INSERT, absolute UPDATEs, INSERT .. ON DUPLICATE KEY UPDATE.

-- TP-2 (F3) Finister's Spherule 100 %
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100 WHERE `entry`=47311 AND `item`=62824;
-- TP-4 (F8) Twilight Collars 100 %
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100 WHERE `item`=62822 AND `entry` IN (5860,5861,5862,8419,47309,47310,47311);
-- TP-4b (gate 3-14) Fire-Gizzard 100 % (no certain rate; less grindy)
UPDATE `creature_loot_template` SET `ChanceOrQuestChance`=-100 WHERE `entry`=9318 AND `item`=62914;
