-- Light's Hope Chapel (zone 139), Fuselight, Ho! 27762: The Uncrashable 48708 beside Gek Nozzlerocket can be clicked to take the
-- rocket to Fuselight-by-the-Sea.
--
-- Kept out of the first integration because the NPC stands in Eastern Plaguelands; included at the user's word (2026-11-15).
-- Without it the rocket of 2026_11_20_48 stays inert. Gek 48704 is not touched.
--
-- Sourced (comments of 27762 and 48708: 2011-01-05 [+13], 2011-03-20 [+9], 2011-06-02 [+6] and others): The Uncrashable stands
--   beside Gek inside the west gate (sniffed spawn 173981, IconName "vehichleCursor"); after taking the quest you click it and
--   off you go; it can be used while the quest is in the log.
-- Ours (no TDB has a spellclick or condition row for it; precedent: the static Silver Bullet X-831 52203):
--   - npcflag SPELLCLICK 16777216: a creature that is no vehicle is clickable only with the flag (Player::CanSeeSpellClickOn).
--   - npc_spellclick_spells (48708, 87956 Rocket Ride to Badlands, cast by the clicker).
--   - The click works with 27762 in the log, complete or not (QUESTSTATE mask 2 | 8: the quest has no objectives and is complete
--     on accept, so QUESTTAKEN would never pass). Nothing checks the quest once aboard.

UPDATE `creature_template` SET `npcflag` = `npcflag` | 16777216 WHERE `entry` = 48708;

DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = 48708;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES
(48708, 87956, 1, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` = 48708 AND `SourceEntry` = 87956;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(18, 48708, 87956, 0, 0, 47, 0, 27762, 10, 0, 0, 0, 0, '', 'The Uncrashable - Rocket Ride to Badlands only with Fuselight, Ho! in the log');
