-- Northern Barrens S1 (_07): Counterattack! (4021) - Krom'zar and his banner come from the event only, Regthar's question
-- starts the battle again, the event resets 5 minutes after Krom'zar appears, the Kolkar retreat line.
-- (plan.md section 1 `_07`; dossier D: D-4021-1, D-4021-2, D U2.)
--
-- SOURCED: neither TDB spawns Krom'zar 9456 or his banner 164690 (he appears after many kills; comments 2011-02-27,
-- 2011-04-17; the banner comes from his death cast 13965); both TDBs let "Where is Warlord Krom'zar?" (menu 1882) run the
-- waves in phase 1 and reset after 5 minutes out of combat; "the Kolkar are retreating" at the end (old comments, a 2025
-- comment) = BroadcastText 8897 "The Kolkar invaders are retreating!" (found in broadcast_text; no TDB or AzerothCore
-- creature_text row says who speaks it).
-- OURS: Regthar speaks the retreat line, as a yell (he stands 60-125 yd from the battle), 250 s after Krom'zar appears,
-- when the last summoned Kolkar time out (rows 4-15 live 450 s from the start, rows 16-25 250 s; Krom'zar comes ~200 s in);
-- the lock after a run stays 300 s from row 26 in total (230 s to the line + 70 s), so a new start is accepted 5 min 20 s
-- after Krom'zar appears, or at once after any hand-in (row 7).
-- Before: mop row 5 had phase mask 4 (phase 3, never set: the option never started anything) and the action list locked
-- the giver for 2 h after a run, so one run per 2 h unless someone handed 4021 in.
-- Note: S6 `_72` (I-S3) trims the static skirmish at the bunker to the TDB four; no row overlap.

-- D-4021-1: Krom'zar and his banner exist only through the event.
DELETE FROM `creature_addon` WHERE `guid`=265894;
DELETE FROM `creature` WHERE `guid`=265894 AND `id`=9456;
DELETE FROM `gameobject` WHERE `guid`=183494 AND `id`=164690;

-- D-4021-2: the gossip option runs the battle in phase 1 and moves Regthar to phase 2 (as the quest accept does).
UPDATE `smart_scripts` SET `event_phase_mask`=1 WHERE `entryorguid`=3389 AND `source_type`=0 AND `id`=5 AND `event_type`=62;
DELETE FROM `smart_scripts` WHERE `entryorguid`=3389 AND `source_type`=0 AND `id`=6;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(3389,0,6,0,62,1,100,0,1882,0,0,0,0,22,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Regthar Deathgate - On Gossip Option 0 Selected - Set Event Phase 2');

-- D-4021-2 + D U2: the end of the action list - retreat line when the Kolkar time out, then phase 1 (300 s after row 26).
DELETE FROM `creature_text` WHERE `CreatureID`=3389 AND `GroupID`=2;
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(3389,2,0,'The Kolkar invaders are retreating!',14,0,100,0,0,0,0,8897,0,'Regthar Deathgate - Counterattack! battle ends');
DELETE FROM `smart_scripts` WHERE `entryorguid`=338900 AND `source_type`=9 AND `id` IN (27,28);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(338900,9,27,0,0,0,100,0,230000,230000,0,0,0,1,2,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Regthar Deathgate - On Script - Yell Line 2 (the Kolkar retreat)'),
(338900,9,28,0,0,0,100,0,70000,70000,0,0,0,22,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,'Regthar Deathgate - On Script - Set Event Phase 1');

-- Review M3: the accept row that runs the action list (id 3, phase 2) becomes a link of the phase-1 accept (id 2), so a
-- player accepting 4021 while a battle runs no longer restarts it and summons a second set of waves.
UPDATE `smart_scripts` SET `link`=3 WHERE `entryorguid`=3389 AND `source_type`=0 AND `id`=2 AND `action_type`=22;
UPDATE `smart_scripts` SET `event_type`=61, `event_phase_mask`=0, `event_param1`=0, `comment`='Regthar Deathgate - Linked To Id 2 (Counterattack! taken in phase 1) - Run Script' WHERE `entryorguid`=3389 AND `source_type`=0 AND `id`=3 AND `action_type`=80;
