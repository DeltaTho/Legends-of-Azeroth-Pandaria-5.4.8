-- Durotar: Fizzled (25260). Fizzle Darkclaw's drowned corpse 3203 handed over the orb on the first click ("<Attempt to remove the
-- orb.>" added Fizzle's Orb 52580 and closed). Retail had a second page and a cast bar.
-- Sourced: warcraft.wiki.gg Fizzled (the dialogue: "<Attempt to remove the orb.>" -> "<You grab at the orb, but Fizzle's hand clutches
-- around it even tighter. The orb glows slightly.>" with "<Attempt to remove Fizzle's Hand, then.>" and "<Give up. This is too
-- scary.>", then a cast bar); comment 2011-02-20 reply [+3] ("Give up i'm too afraid"); broadcast_text 39581-39584; mop menu 11239
-- with npc_text 15662 (bct 39582) already exists; DBC 74024 Remove Fizzle's Hand (3 s cast, CREATE_ITEM on the caster; Wowhead item
-- 52580 lists it as the source); offer reward "you bring half of the goblin's arm".
-- What the player sees: talk to the corpse with the quest in progress -> "<Attempt to remove the orb.>" -> second page ->
-- "<Attempt to remove Fizzle's Hand, then.>" closes the window and starts a 3 s "Remove Fizzle's Hand" bar -> the orb is in the bags
-- (moving or being hit breaks the cast: talk to him again); "<Give up. This is too scary.>" closes the window. Without the quest in
-- progress (or with the orb already, the quest then complete) only the npc_text shows.
-- No fork or LocalChanges update has smart_scripts rows for 3203 (only koKR texts).

UPDATE `gossip_menu_option` SET `ActionMenuID` = 11239 WHERE `MenuID` = 11240 AND `OptionID` = 0;
DELETE FROM `gossip_menu_option` WHERE `MenuID` = 11239;
INSERT INTO `gossip_menu_option` (`MenuID`, `OptionID`, `OptionIcon`, `OptionText`, `OptionBroadcastTextID`, `OptionType`, `OptionNpcflag`,
 `ActionMenuID`, `ActionPoiID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `VerifiedBuild`) VALUES
(11239, 0, 0, '<Attempt to remove Fizzle''s Hand, then.>', 39583, 1, 1, 0, 0, 0, 0, NULL, 0, 0),
(11239, 1, 0, '<Give up.  This is too scary.>', 39584, 1, 1, 0, 0, 0, 0, NULL, 0, 0);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` IN (11239, 11240);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`,
 `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, 11240, 0, 0, 0, 47, 0, 25260, 8, 0, 0, 0, 0, '', 'Fizzle Darkclaw - try for the orb only while Fizzled is in progress'),
(15, 11239, 0, 0, 0, 47, 0, 25260, 8, 0, 0, 0, 0, '', 'Fizzle Darkclaw - remove the hand only while Fizzled is in progress');

UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 3203;
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 3203;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
 `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`,
 `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(3203, 0, 0, 1, 62, 0, 100, 0, 11239, 0, 0, 0, 0, 85, 74024, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Fizzle Darkclaw - Gossip 11239/0 - Invoker casts Remove Fizzle''s Hand (3 s; creates Fizzle''s Orb)'),
(3203, 0, 1, 0, 61, 0, 100, 0, 0, 0, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Fizzle Darkclaw - Linked - Close gossip'),
(3203, 0, 2, 0, 62, 0, 100, 0, 11239, 1, 0, 0, 0, 72, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 'Fizzle Darkclaw - Gossip 11239/1 (give up) - Close gossip');
