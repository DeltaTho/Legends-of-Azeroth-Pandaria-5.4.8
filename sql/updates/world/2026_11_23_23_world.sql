-- Swamp of Sorrows, Marking the Fallen (27845 Alliance / 27856 Horde): a marked body keeps lying where it fell, wears its
-- flag for 20 seconds, takes no second flag while it does, and can be marked again once the flag is gone.
--
-- Sourced: "I marked this same Footman seven times" (27845 2010-12-04 [+26]); "Once you target one fallen warrior, you can
-- mark him with banner 7 times. Cooldown is 18 seconds, just wait until banner dissapears and do it again" (27856 2011-01-22
-- reply [+12]; 27845 2011-04-20 [+2]); a body that already carries a flag cannot be marked (2011-01-03 [+8], 2011-02-01
-- reply). Marked for Retrieval 87293 / 87296 lasts 20 s (SpellDuration index 18), effect 0 is its aura (dummy, visual
-- 18446 / 18447), range 5 yd, target 38 nearest Fallen Marshtide Footman 46881 / Fallen Stonard Warrior 46882 (existing
-- condition 13). The credit stays the caster's own (SmartAI action 33 on the invoker), one per mark, as sourced.
-- Ours: the encoding. Each body's credit event is now repeatable and no longer despawns the body 8 s later (LoA's own
-- script: neither TDB has AI or spawns for the corpses); the spell refuses a body on which any player's flag is still up
-- (CONDITION_AURA on the candidate target, any caster, ConditionMgr.cpp; ANDed with the entry condition), so a second
-- player beside him waits up to 20 s for the same body. The retail "spam the banner for several credits" fault (2011-10-17
-- [+2]) is not reproduced.

DELETE FROM `smart_scripts` WHERE `entryorguid` IN (46881,46882) AND `source_type`=0 AND `id`=1;
UPDATE `smart_scripts` SET `link`=0, `event_flags`=0 WHERE `entryorguid` IN (46881,46882) AND `source_type`=0 AND `id`=0;
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (46881,46882);

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=13 AND `SourceGroup`=1 AND `SourceEntry` IN (87293,87296) AND `ConditionTypeOrReference`=1;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13,1,87293,0,0,1,0,87293,0,0,1,0,0,'','Marked for Retrieval - not on a Fallen Marshtide Footman whose flag is still up'),
(13,1,87296,0,0,1,0,87296,0,0,1,0,0,'','Marked for Retrieval - not on a Fallen Stonard Warrior whose flag is still up');
