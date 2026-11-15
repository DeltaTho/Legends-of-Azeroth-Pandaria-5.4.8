-- Badlands H-1: Rhea Revealed 27769 credits every player who takes it (and their playerbots), not only the last one
-- Rhea 46654 moves from SmartAI to the C++ script npc_badlands_rhea (zone_badlands_rhea.cpp), which ports her SmartAI ids 0-2
-- (line on accept, credit 46654 seven seconds later) with one timer per accept, so a player and bots who take the quest within
-- 7 s are all credited (the SmartAI timed event credited only the last invoker).
-- Sourced: the line (BT 46758, emote 5) on accept and the reveal (wiki 27769 notes); the 7 s timer and the credit entry are mop's.
-- Ours: credit also to the accepter's playerbots within 40 yd (decisions R4 as amended); the line goes out personally
-- (TextRange 5) because every Rhea copy is quest-invisible outside its window (section B) and text reaches everyone in range.
DELETE FROM `smart_scripts` WHERE `entryorguid`=46654 AND `source_type`=0;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_badlands_rhea' WHERE `entry`=46654;
UPDATE `creature_text` SET `TextRange`=5 WHERE `CreatureID`=46654 AND `GroupID`=0 AND `ID`=0;
