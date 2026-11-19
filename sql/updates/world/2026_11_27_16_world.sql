-- Never Trust a Big Barb and a Smile (25165): the Clattering Scorpid (3125) warns its victim when it starts Envenom, and the venom sample
-- goes to the player whose totem caught it when the Envenom lands.
-- What the player sees (sourced): about 5 s into the fight the scorpid starts Envenom (2.5 s cast) and a centre-screen boss whisper
-- "Clattering Scorpid is casting Envenom!  Place your totem down now!" (creature_text 3125/0, broadcast 39298, type 42: in both TDBs and
-- mop; wiki Notes show it as a boss emote); the player drops the Poison Extraction Totem (item 52505 -> 73673, 15 s); when the Envenom
-- hits, one sample is credited (quest log "placing the totem near a Clattering Scorpid"; Wowhead 2010-11-23 [+12] "when the Envenom
-- cast completes you get one venom sample").
-- Before: the warning was a TALK with target self, so its whisper had no player target and was dropped (CreatureTextMgr::SendChat);
-- the credit was a 7.5 s combat timer telling the nearest totem within 15 yd of the scorpid, so it came even when the cast was
-- interrupted or missed, and in a crowd it went to whoever owned the nearest totem.
-- Now: id 1 whispers to the victim (a player victim; a pet victim gets no whisper). Id 2 credits the unit the Envenom hits (target
-- invoker; ours, where both TDBs credit target "victim") when it carries the totem's 15 s marker aura 73673 effect 1 (both TDBs'
-- condition, 22/3/3125). A unit hit that is not a player (a hunter's pet tanking) gives no credit, as in both TDBs: a pet carries no
-- marker aura, and this core's condition targets cannot reach the pet's owner, so the earlier "nearest totem within 15 yd" rule (which
-- could credit another player's totem) is dropped rather than kept (Wowhead 2010-11-28 reply [+7] says a pet tanking once got credit;
-- not built). Envenom stays once per fight at 5 s (mop; Wowhead 2014-02-14 [+1] "each Clattering Scorpid will only use his envenom
-- once"; the TDBs repeat it every 15-24 s). Id 3 (beta's Sundering Cleave row) is untouched. Id 4 and condition 22/5 of an earlier
-- version of this file are removed.
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 3125 AND `ScriptName` = '';
DELETE FROM `smart_scripts` WHERE `entryorguid` = 3125 AND `source_type` = 0 AND `id` IN (1, 2, 4);
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3125, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 'Clattering Scorpid - Linked To Id 0 - Say Line 0 to Victim (Place your totem down now!)'),
(3125, 0, 2, 0, 31, 0, 100, 0, 73672, 0, 0, 0, 0, 33, 39236, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Clattering Scorpid - On Envenom Hit - Quest Credit to the Unit Hit (if it placed a Poison Extraction Totem)');
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceEntry` = 3125 AND `SourceId` = 0 AND `SourceGroup` IN (3, 5);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(22, 3, 3125, 0, 0, 1, 0, 73673, 1, 0, 0, 0, 0, '', 'Clattering Scorpid - Envenom credit only if the unit hit has the Poison Extraction Totem aura');
