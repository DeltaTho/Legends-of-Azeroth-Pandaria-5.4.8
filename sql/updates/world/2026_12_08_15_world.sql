-- Young and Vicious: Swiftclaw keeps running round Kijara's island until he is lassoed, the player then steers him, the pen credits
-- the rider, and he throws his rider on the coast of Darkspear Strand.
--
-- What the sources describe: Swiftclaw "runs around the small island that the quest giver is on" (Wowhead 24626 2010-11-23),
-- "around the south island in a circle" (npc 38002 2010-11-23); the lasso seats you on him; "Swiftclaw isn't stopping! Steer him
-- back to the raptor pens near Darkspear Hold." (his own emote); the player steers ("press '/' ... it will slow him to walking
-- speed", 2010-11-23 reply; "if you run him into the water he will stop running", 2013-05-23; "run him across the bridge,
-- slightly to the right", 2010-12-02 reply): a raptor the player steers, not a ride on a path. In the pen "you automatically
-- dismount, quest done" (2010-12-02 reply, 2011-05-22, 2011-07-11). "A bit up on the coast of Darkspear Strand (about the fishing
-- trainers) you will be dismounted and Swiftclaw will disappear" (2012-12-30).
--
-- 1. The lap repeats while he is free (waypoint start id 2: repeat 1; mop ran it once and left him standing). On the lasso, id 5
--    pauses the path for an hour instead of stopping it: WP_STOP ends the path, and SmartAI::EndPath restarts a repeating path at
--    once, which would carry the rider round the island under server control. A forced pause stops him (MoveIdle, under which the
--    client's moves for its mover are accepted: MovementHandler.cpp, IDLE_MOTION_TYPE) and UpdatePath does nothing while paused;
--    he never lives that long once ridden (any dismount despawns him 5 s later, ids 7-10).
UPDATE `smart_scripts` SET `action_param3` = 1 WHERE `entryorguid` = 38002 AND `source_type` = 0 AND `id` = 2;
UPDATE `smart_scripts` SET `action_type` = 54, `action_param1` = 3600000, `action_param2` = 0, `action_param3` = 0, `comment` = 'Swiftclaw - Linked To Id 4 - Pause Waypoint 1 h (the rider steers)' WHERE `entryorguid` = 38002 AND `source_type` = 0 AND `id` = 5;

-- 2. Pen credit to the rider, found by Swiftclaw himself. Notera 38988 and Kortin 38990 used to cast the credit on the closest player
--    in 10 yd (a bystander could take it; any player walking past Kortin was credited without a raptor) and took the aura from
--    every Swiftclaw there. They cannot find Swiftclaw themselves: he is a personal summon (SummonProperties 492, flag 0x10) and the
--    creature search checks private-owner visibility with the searcher as seer (GridNotifiers.h:1223, Object.cpp:2294). The search
--    the other way round works (the trainers are public). Ours: once a second, a Swiftclaw that is ridden (Mount Ducal's Horse
--    48678 on him) within 10 yd of Notera or Kortin has his rider (SMART_TARGET_OWNER_OR_SUMMONER = the charmer while ridden) cast
--    Raptor Turn-in Credit 70941 on himself, then throws him off, which runs the existing "passenger removed" rows (run off,
--    despawn 5 s later). The trainers' own rows and Notera's invoker condition go; they had no other rows.
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (38988, 38990) AND `source_type` = 0;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` IN (38988, 38990) AND `SourceId` = 0;
UPDATE `creature_template` SET `AIName` = '' WHERE `entry` IN (38988, 38990);
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 38002;

-- 3. Boundary (ours: checked once a second, the areas): Darkspear Strand 393 (the coast facing the isles, where the fishing trainer
--    stands) and the Durotar areas behind it (Sen'jin Village 367, Durotar 14, 6748). The route Kijara's island 4863 -> bridge ->
--    Darkspear Isle 4875 and the sea round the isles (area 6453) are none of these.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 38002 AND `source_type` = 0 AND `id` IN (11, 12, 13);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(38002, 0, 11, 12, 1, 0, 100, 0, 1000, 1000, 1000, 1000, 86, 70941, 2, 23, 0, 0, 0, 23, 0, 0, 0, 0, 0, 0, 0, 'Swiftclaw - OOC every 1 s - ridden within 10 yd of Notera or Kortin: rider casts Raptor Turn-in Credit on himself'),
(38002, 0, 12, 0, 61, 0, 100, 0, 0, 0, 0, 0, 28, 48678, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Swiftclaw - Linked - Remove Mount Ducal''s Horse (rider dismounted in the pen)'),
(38002, 0, 13, 0, 1, 0, 100, 0, 1000, 1000, 1000, 1000, 28, 48678, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 'Swiftclaw - OOC every 1 s - on the Durotar coast: Remove Mount Ducal''s Horse (rider thrown off)');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 38002 AND `SourceId` = 0 AND `SourceGroup` IN (12, 14);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 12, 38002, 0, 0, 1, 1, 48678, 0, 0, 0, 0, 0, '', 'Swiftclaw - pen credit: ridden'),
(22, 12, 38002, 0, 0, 29, 1, 38988, 10, 0, 0, 0, 0, '', 'Swiftclaw - pen credit: within 10 yd of Notera'),
(22, 12, 38002, 0, 1, 1, 1, 48678, 0, 0, 0, 0, 0, '', 'Swiftclaw - pen credit: ridden'),
(22, 12, 38002, 0, 1, 29, 1, 38990, 10, 0, 0, 0, 0, '', 'Swiftclaw - pen credit: within 10 yd of Kortin'),
(22, 14, 38002, 0, 0, 23, 1, 393, 0, 0, 0, 0, 0, '', 'Swiftclaw - boundary: Darkspear Strand'),
(22, 14, 38002, 0, 1, 23, 1, 367, 0, 0, 0, 0, 0, '', 'Swiftclaw - boundary: Sen''jin Village'),
(22, 14, 38002, 0, 2, 23, 1, 14, 0, 0, 0, 0, 0, '', 'Swiftclaw - boundary: Durotar'),
(22, 14, 38002, 0, 3, 23, 1, 6748, 0, 0, 0, 0, 0, '', 'Swiftclaw - boundary: Durotar (6748)');
