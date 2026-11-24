-- Echo Isles trainers: Nortet greets warriors with his warrior line and everyone else with "We can't help ya 'ere, mon."; Soratha
-- keeps her mage line for non-druids.
-- Nortet (menu 10977). Sourced: warcraft.wiki.gg Nortet, "Warrior gossip: Take care of ya weapons an' they'll take care of ya back."
-- (npc_text 15257) and "Non-warrior gossip: We can't help ya 'ere, mon." (broadcast 37940 = TDB 12.1.0 npc_text 15265, which mop
-- lacked; the TDB uses it on menus 14182-14184). mop's menu had 15257 and 15260 "I can't help ya. Go talk ta Zen'Tabra if ya want
-- druid trainin'." with no conditions; Player::GetGossipTextId keeps the last row that passes, so everyone, warriors included,
-- read 15260. 15260 is in no source for Nortet (the wiki's non-warrior line covers druids too) and leaves his menu.
-- Soratha (menu 10987). Ours: she had 15260 and her mage line 15275 (the only row both TDBs have); everyone, druids included, read
-- 15275. Inferred from the broadcast set 37933-37939 / 42492 "Go talk ta <trainer> if ya want <class> trainin'": 15260 goes to
-- druids, 15275 to everyone else (no wiki section for her). Each menu's rows are made mutually exclusive, so the result does not
-- depend on the load order of gossip_menu.
DELETE FROM `npc_text` WHERE `ID` = 15265;
INSERT INTO `npc_text` (`ID`, `text0_0`, `text0_1`, `BroadcastTextID0`, `lang0`, `Probability0`, `VerifiedBuild`) VALUES
(15265, 'We can''t help ya ''ere, mon.', 'We can''t help ya ''ere, mon.', 37940, 0, 1, 0);
DELETE FROM `gossip_menu` WHERE `MenuID` = 10977 AND `TextID` IN (15260, 15265);
INSERT INTO `gossip_menu` (`MenuID`, `TextID`, `VerifiedBuild`) VALUES
(10977, 15265, 0);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 14 AND ((`SourceGroup` = 10977 AND `SourceEntry` IN (15257, 15260, 15265)) OR (`SourceGroup` = 10987 AND `SourceEntry` IN (15260, 15275)));
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(14, 10977, 15257, 0, 0, 15, 0, 1, 0, 0, 0, 0, 0, '', 'Nortet - warrior text 15257 only for warriors'),
(14, 10977, 15265, 0, 0, 15, 0, 1, 0, 0, 1, 0, 0, '', 'Nortet - "We can''t help ya ''ere, mon." for everyone but warriors'),
(14, 10987, 15260, 0, 0, 15, 0, 1024, 0, 0, 0, 0, 0, '', 'Soratha - text 15260 (go to Zen''tabra) only for druids'),
(14, 10987, 15275, 0, 0, 15, 0, 1024, 0, 0, 1, 0, 0, '', 'Soratha - own text 15275 for everyone but druids');
