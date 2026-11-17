-- With Dying Breath 27911: Helgrum's last moments when the quest is taken from Neeka Bloodscar (npc_neeka_bloodscar,
-- zone_swamp_of_sorrows.cpp). Sourced: his line bt 49703 (wiki quest_27911 "On accept"; Wowhead 27911 2011-08-25 [+13]) and
-- that Neeka cries (wiki "Neeka Bloodscar cries."), said with bt 6104 "%s cries." and EMOTE_ONESHOT_CRY (18).
-- Ours: both public (range 0: everyone on the tower sees and hears it; the sources describe only what the taker saw), the
-- ScriptName, the use of bt 6104 for the wiki's emote line.
-- Groups 0 only: 47041 group 1 (the tower grunt's answers) and group 2 (bt 49699, reserved) are other rows.
DELETE FROM `creature_text` WHERE (`CreatureID`=1442 AND `GroupID`=0) OR (`CreatureID`=47041 AND `GroupID`=0);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(1442,0,0,'Be strong, Neeka. I will watch over you...',12,0,100,0,0,0,0,49703,0,'Helgrum the Swift - With Dying Breath'),
(47041,0,0,'%s cries.',16,0,100,18,0,0,0,6104,0,'Neeka Bloodscar - With Dying Breath');

UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_neeka_bloodscar' WHERE `entry`=47041;
