-- Burning Steppes B (_12): the Blackrock Cudgel of Discipline in I Am the Law / Lash 28278 / 28439 and Abuse of Power 28279 / 28440
-- (plan B-07..B-11, B-15).
--
-- SOURCED: one credit per cudgel hit on any Fields of Honor troop, the same troop again and again, sergeants included (comments
-- 2010-11-24 [+15], 2010-12-23 [+7] and reply, 2010-12-29 [+6], 2014-02-20 [+3]; 28279 2011-02-06 [+7] "They will even count towards
-- the 20"; wiki "does not have a cooldown, global or otherwise"); hit lines 48428-48431 ("Ouch! What did I do?" ...) and notice lines
-- 48424-48427 ("Hey, wait a minute..." ...) (wiki; broadcast_text); troops "occasionally notice the mask" and unmask the player (wiki,
-- 2010-12-03 [+5], 2011-04-30 [+5]); sergeants killed by any means count, also in a group (2010-11-28 [+4], 2012-09-15 [+20]).
-- mop had: credit only from Smolderthorn Assassins 48119 and Firegut Flamespeakers 48121 (48 of 123 troops), once per 30 s each; the
-- Assassins said their notice lines on every hit, the Flamespeakers their aggro lines; Blackrock Soldiers 7025 (75 troops) and
-- sergeants gave no hit credit; a sergeant's kill credit went only to the unit that killed it (no pet, no group); Firegut Brute 7035
-- had "Sorry! Won't happen again, sir!" among its aggro lines.
-- OURS: 90 % hit line, 10 % once per troop life the notice line + Unmask 89596 on the hitter (user question Q1; Unmask's effect is
-- section D's spell script, D-16 - without it the cast does nothing, as before). The "Recently disciplined" self-cast goes (no source
-- needs it; condition 17/89568 stays and keeps the DBC credit path from double-counting).
-- The notice rows are gated on the troop being alive after the hit (fix round 1).
-- Idempotent: DELETE + INSERT.

DELETE FROM `creature_text` WHERE (`CreatureID` = 7025 AND `GroupID` = 1) OR (`CreatureID` = 48119 AND `GroupID` = 1)
  OR (`CreatureID` = 48121 AND `GroupID` IN (1, 2)) OR (`CreatureID` = 48121 AND `GroupID` = 0 AND `ID` = 3) OR (`CreatureID` = 7035 AND `GroupID` = 0 AND `ID` = 3);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `SoundType`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(7025, 1, 0, 'Hey, wait a minute...', 12, 0, 100, 0, 0, 0, 0, 48424, 0, 'Blackrock Soldier - notices the disguise'),
(7025, 1, 1, 'I don''t recognize you...', 12, 0, 100, 0, 0, 0, 0, 48425, 0, 'Blackrock Soldier - notices the disguise'),
(7025, 1, 2, 'Hmm... are you new around here...?', 12, 0, 100, 0, 0, 0, 0, 48426, 0, 'Blackrock Soldier - notices the disguise'),
(7025, 1, 3, 'You''re not one of us, are you...?', 12, 0, 100, 0, 0, 0, 0, 48427, 0, 'Blackrock Soldier - notices the disguise'),
(48119, 1, 0, 'Ouch!  What did I do?', 12, 0, 100, 0, 0, 0, 0, 48428, 0, 'Smolderthorn Assassin - cudgeled'),
(48119, 1, 1, 'Hey!  Who gave you the cudgel?', 12, 0, 100, 0, 0, 0, 0, 48429, 0, 'Smolderthorn Assassin - cudgeled'),
(48119, 1, 2, 'It wasn''t me, I swear!  You can''t prove anything!', 12, 0, 100, 0, 0, 0, 0, 48430, 0, 'Smolderthorn Assassin - cudgeled'),
(48119, 1, 3, 'Sorry!  Won''t happen again, sir!', 12, 0, 100, 0, 0, 0, 0, 48431, 0, 'Smolderthorn Assassin - cudgeled'),
(48121, 1, 0, 'Ouch!  What did I do?', 12, 0, 100, 0, 0, 0, 0, 48428, 0, 'Firegut Flamespeaker - cudgeled'),
(48121, 1, 1, 'Hey!  Who gave you the cudgel?', 12, 0, 100, 0, 0, 0, 0, 48429, 0, 'Firegut Flamespeaker - cudgeled'),
(48121, 1, 2, 'It wasn''t me, I swear!  You can''t prove anything!', 12, 0, 100, 0, 0, 0, 0, 48430, 0, 'Firegut Flamespeaker - cudgeled'),
(48121, 1, 3, 'Sorry!  Won''t happen again, sir!', 12, 0, 100, 0, 0, 0, 0, 48431, 0, 'Firegut Flamespeaker - cudgeled'),
(48121, 2, 0, 'Hey, wait a minute...', 12, 0, 100, 0, 0, 0, 0, 48424, 0, 'Firegut Flamespeaker - notices the disguise'),
(48121, 2, 1, 'I don''t recognize you...', 12, 0, 100, 0, 0, 0, 0, 48425, 0, 'Firegut Flamespeaker - notices the disguise'),
(48121, 2, 2, 'Hmm... are you new around here...?', 12, 0, 100, 0, 0, 0, 0, 48426, 0, 'Firegut Flamespeaker - notices the disguise'),
(48121, 2, 3, 'You''re not one of us, are you...?', 12, 0, 100, 0, 0, 0, 0, 48427, 0, 'Firegut Flamespeaker - notices the disguise');
-- kept: 7025 group 0 = the four hit lines, 48119 group 0 = the four notice lines, 48121 group 0 ids 0-2 = aggro lines, 48201 group 0

-- kept rows: 7025 ids 0-2, 48119 ids 3-4, 48121 ids 3-6, 48201 ids 0-1 (Unmask + line on the first hit), 3-4
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND ((`entryorguid` IN (48119, 48121) AND `id` IN (0, 1, 2))
  OR (`entryorguid` = 7025 AND `id` BETWEEN 3 AND 6) OR (`entryorguid` = 48119 AND `id` = 5) OR (`entryorguid` = 48121 AND `id` = 7)
  OR (`entryorguid` = 48201 AND `id` IN (2, 5)));
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(7025, 0, 3, 0, 8, 0, 100, 0, 89562, 0, 0, 0, 0, 33, 48195, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Blackrock Soldier - On Cudgel Hit - Cudgel Credit to the hitter (every hit)'),
(7025, 0, 4, 0, 8, 0, 90, 0, 89562, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Blackrock Soldier - On Cudgel Hit (90%) - Say Hit Line'),
(7025, 0, 5, 6, 8, 0, 10, 1, 89562, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Blackrock Soldier - On Cudgel Hit (10%, once) - Say Notice Line'),
(7025, 0, 6, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 89596, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Blackrock Soldier - Linked - Cast Unmask on the hitter'),
(48119, 0, 0, 0, 8, 0, 100, 0, 89562, 0, 0, 0, 0, 33, 48195, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Smolderthorn Assassin - On Cudgel Hit - Cudgel Credit to the hitter (every hit)'),
(48119, 0, 1, 0, 8, 0, 90, 0, 89562, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Smolderthorn Assassin - On Cudgel Hit (90%) - Say Hit Line'),
(48119, 0, 2, 5, 8, 0, 10, 1, 89562, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Smolderthorn Assassin - On Cudgel Hit (10%, once) - Say Notice Line'),
(48119, 0, 5, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 89596, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Smolderthorn Assassin - Linked - Cast Unmask on the hitter'),
(48121, 0, 0, 0, 8, 0, 100, 0, 89562, 0, 0, 0, 0, 33, 48195, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Firegut Flamespeaker - On Cudgel Hit - Cudgel Credit to the hitter (every hit)'),
(48121, 0, 1, 0, 8, 0, 90, 0, 89562, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Firegut Flamespeaker - On Cudgel Hit (90%) - Say Hit Line'),
(48121, 0, 2, 7, 8, 0, 10, 1, 89562, 0, 0, 0, 0, 1, 2, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Firegut Flamespeaker - On Cudgel Hit (10%, once) - Say Notice Line'),
(48121, 0, 7, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 11, 89596, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Firegut Flamespeaker - Linked - Cast Unmask on the hitter'),
(48201, 0, 2, 0, 6, 0, 100, 0, 0, 0, 0, 0, 0, 33, 48210, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 'Blackrock Sergeant - On Death - Sergeant Cudgel Credit (loot recipient and his group)'),
(48201, 0, 5, 0, 8, 0, 100, 0, 89562, 0, 0, 0, 0, 33, 48195, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Blackrock Sergeant - On Cudgel Hit - Cudgel Credit to the hitter (counts for the 20)');

-- the notice only while the troop is still alive after the hit (SpellHit runs after the damage, so the 10 % roll also came on the
-- killing hit: the corpse said "Hey, wait a minute..." and the Unmask cast failed). Condition 22 = the row's id + 1, object = the troop.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceId` = 0 AND ((`SourceGroup` = 6 AND `SourceEntry` = 7025) OR (`SourceGroup` = 3 AND `SourceEntry` IN (48119, 48121)));
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 6, 7025, 0, 0, 36, 1, 0, 0, 0, 0, 0, 0, '', 'Blackrock Soldier - notice the disguise only if the hit did not kill it'),
(22, 3, 48119, 0, 0, 36, 1, 0, 0, 0, 0, 0, 0, '', 'Smolderthorn Assassin - notice the disguise only if the hit did not kill it'),
(22, 3, 48121, 0, 0, 36, 1, 0, 0, 0, 0, 0, 0, '', 'Firegut Flamespeaker - notice the disguise only if the hit did not kill it');
