-- Searing Gorge, Heat That Just Don't Quit 27981: Furnace Flasks fill only from a living fire elemental, and the elemental shrinks.
--
-- 88418 Fill Furnace Flask (Furnace Flasks 62826 on use) is a DUMMY on any unit (target 25) plus CREATE_ITEM 62827 on the caster,
-- with no CastingRequirements, conditions or script, so a flask filled from any unit: a critter, a party member, oneself.
-- - Conditions (source 17, explicit target): a living Blazing Elemental 5850, Inferno Elemental 5852, Magma Elemental 5855 or
--   Rasha'krak 47553; anything else fails with "Invalid target" (SPELL_FAILED_BAD_TARGETS 13). Spell range 5 yd (SpellRange 2),
--   as the wiki's "close to melee range".
-- - spell_searing_gorge_fill_furnace_flask (zone_searing_gorge_thorium.cpp): the sampled elemental shrinks (42824 Result: Shrink,
--   scale -25 %) until it resets or dies; the shrink is only a look and never refuses another fill, so one living elemental gives
--   as many flasks as wanted. Bags full: the cast is refused ("Inventory is full") and nothing shrinks.
-- Sourced: the four entries (quest text "the elementals gotta be alive"; wiki notes; comment 2011-03-20 for Rasha'krak), the shrink
-- (wiki "shrink down to fun-size"; comment 2012-08-19), repeated fills from one elemental (2012-09-02 [+22]; 2011-03-20 "10 times"
-- on Rasha'krak; less grindy than the 2010-12-04 "patched" reply). Ours: spell 42824 as the shrink and its end on evade/death;
-- refusing the zone's other fire elementals (Searing Flamewraith 47463, Smoldar, Scald, Pyron, Calcinder: no source either way).

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceEntry`=88418;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(17,0,88418,0,0,31,1,3,5850,0,0,13,0,'','Fill Furnace Flask - target Blazing Elemental'),
(17,0,88418,0,0,36,1,0,0,0,0,13,0,'','Fill Furnace Flask - target alive'),
(17,0,88418,0,1,31,1,3,5852,0,0,13,0,'','Fill Furnace Flask - target Inferno Elemental'),
(17,0,88418,0,1,36,1,0,0,0,0,13,0,'','Fill Furnace Flask - target alive'),
(17,0,88418,0,2,31,1,3,5855,0,0,13,0,'','Fill Furnace Flask - target Magma Elemental'),
(17,0,88418,0,2,36,1,0,0,0,0,13,0,'','Fill Furnace Flask - target alive'),
(17,0,88418,0,3,31,1,3,47553,0,0,13,0,'','Fill Furnace Flask - target Rasha''krak'),
(17,0,88418,0,3,36,1,0,0,0,0,13,0,'','Fill Furnace Flask - target alive');

DELETE FROM `spell_script_names` WHERE `spell_id`=88418;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(88418,'spell_searing_gorge_fill_furnace_flask');
