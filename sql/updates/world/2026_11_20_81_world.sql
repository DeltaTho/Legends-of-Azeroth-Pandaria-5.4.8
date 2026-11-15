-- Badlands H-2: Lifting the Veil 27770 is witnessed, not fought
-- Rhea 46654's script (npc_badlands_rhea, zone_badlands_rhea.cpp) says her line on accept and credits Nyxondra 46658 3 s later
-- to the accepter and the accepter's playerbots within 40 yd. This file adds the line.
-- Sourced: the line BT 46757 "I will now remove the fog from your eyes. Behold, our captive." and Nyxondra appearing (wiki 27770
-- notes); credit without a fight (comments 2010-11-29 [+3], 2010-12-03 [+3]); emote 5 = the broadcast text's emote.
-- Ours: the 3 s delay, the playerbot credit (decisions R4 as amended), TextRange 5 (Rhea is quest-invisible outside her window).
-- Ship with or before section A's A-8 (Nyxondra cannot die): without this credit A-8 makes the quest uncompletable.
DELETE FROM `creature_text` WHERE `CreatureID`=46654 AND `GroupID`=1;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(46654,1,0,'I will now remove the fog from your eyes.  Behold, our captive.',12,0,100,5,0,0,0,46757,5,'Rhea - Lifting the Veil accepted');
