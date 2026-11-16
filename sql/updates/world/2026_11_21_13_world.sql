-- Searing Gorge A-27 (main-chain walk M1): Gaining Even More Acceptance 7737 stops being offered at Honored.
--
-- SOURCED: both TDBs (12.1.0 and 4.4.2) quest_template_addon 7737: RequiredMinRepFaction 59, RequiredMaxRepFaction 59, RequiredMinRepValue
-- 3000, RequiredMaxRepValue 9000; wiki quest 7737 "This quest is repeatable up to Honored". mop had 42000.
-- 13662 not changed: both TDBs have no upper limit (RequiredMaxRepFaction 0, value 0) and mop's 59/59/3000/42000 stops it at Exalted, which
-- is what the wiki says for 13662 ("residue turn-ins up to Exalted"; originally Friendly to Honored, changed in Cataclysm).
-- Same build as _08 (7737/13662 after 28064), no other ship-order link.
UPDATE `quest_template_addon` SET `RequiredMaxRepValue`=9000 WHERE `ID`=7737;
