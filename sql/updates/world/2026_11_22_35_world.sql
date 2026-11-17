-- Burning Steppes, the Blackrock Disguise (item 63357 -> 89261, Into the Black Tooth Hovel 28239 / 28432 and everything after it):
-- the disguise works for female characters, gives one race aura, puts Pandaren in the ogre costume, comes off whole, and can no
-- longer be put on after Locked and Loaded.
--
-- How it works here: 89261 (hidden marker, AreaGroup 2830 = Burning Steppes) is linked on cast to all eight race auras 89253-89260
-- (spell_linked_spell type 0); the source-17 conditions keep the one for the player's race and gender (the race aura does the work:
-- FORCE_REACTION to Faction 34 "Orc, Blackrock", FactionTemplate 40, and the visible paper mask). The losers fail CheckCast.
--
-- 1. All eight gender rows said 0 (male): a female character got no race aura at all (the hovel, Kaoshin and General Thorg'izog
--    stayed hostile), a male got his group's male and female aura. The female aura of each pair is the even id: 89254 / 89256 /
--    89258 / 89260 show the female mask items 69096 / 63278 / 69043 / 69102 (SpellVisual -> SpellVisualKit effect 17, 5.4.8 DB2).
-- 2. Pandaren (races 25 / 26, bits 0x1000000 | 0x2000000) sat in the orc mask; every source puts them in the ogre costume (the 4-1-3
--    recipe in more than 15 comments 2012-2014; item 63357 reply "Pandaren female ... chest armor goes off", which only the ogre kits
--    do). Moved from 89253 / 89254 to 89255 / 89256.
-- 3. The seven casts that are expected to fail now fail with SPELL_FAILED_DONT_REPORT (29), never shown (ours: was 184 custom 0).
-- 4. Removal both ways. mop already had race aura removed -> 89261 removed (8 rows, kept); added 89261 removed -> race auras removed,
--    so Unmask Effect 89594 and Remove Blackrock Disguise 90365 (both REMOVE_AURA 89261 only) and a right-click on the buff leave
--    nothing behind (before: the race aura stayed after an unmask / a hand-in, the forced reaction with it). Loop-free: _UnapplyAura
--    erases the aura from m_appliedAuras before HandleAuraSpecificMods runs its -id links (Unit.cpp _UnapplyAura).
-- 5. Not after Locked and Loaded 28327 / 28453: "You can't do that right now" (item 63357 2011-01-04 replies, 2012-07-01 [+3]; 28286
--    2011-01-04 [+10]). Ours: the error code 185 SPELL_FAILED_CANT_DO_THAT_RIGHT_NOW and the two negated QUESTREWARDED rows.
-- Sourced: race groups (28428 2012-05-28 [+322], 28431 2010-11-24 [+74], wiki ratio table), genders (DB2 mask items), D12.
-- Kaoshin's and the kodos' faction 40 (2026_11_22_36) must never ship without this file.

-- 1 + 2 + 3
UPDATE `conditions` SET `ConditionValue1`=1 WHERE `SourceTypeOrReferenceId`=17 AND `SourceGroup`=0 AND `SourceEntry` IN (89254,89256,89258,89260) AND `ConditionTypeOrReference`=20;
UPDATE `conditions` SET `ConditionValue1`=23, `Comment`=REPLACE(`Comment`,',Pandaren','') WHERE `SourceTypeOrReferenceId`=17 AND `SourceGroup`=0 AND `SourceEntry` IN (89253,89254) AND `ConditionTypeOrReference`=16;
UPDATE `conditions` SET `ConditionValue1`=52429856, `Comment`=CONCAT(REPLACE(`Comment`,',Pandaren',''),',Pandaren') WHERE `SourceTypeOrReferenceId`=17 AND `SourceGroup`=0 AND `SourceEntry` IN (89255,89256) AND `ConditionTypeOrReference`=16;
UPDATE `conditions` SET `ErrorType`=29, `ErrorTextId`=0 WHERE `SourceTypeOrReferenceId`=17 AND `SourceGroup`=0 AND `SourceEntry` BETWEEN 89253 AND 89260;

-- 4
DELETE FROM `spell_linked_spell` WHERE (`spell_trigger`=-89261 AND `spell_effect` BETWEEN -89260 AND -89253) OR (`spell_trigger` BETWEEN -89260 AND -89253 AND `spell_effect`=-89261);
INSERT INTO `spell_linked_spell` (`spell_trigger`,`spell_effect`,`type`,`comment`) VALUES
(-89261,-89253,0,'Blackrock Disguise removed - remove Blackrock Orc Disguise (Male)'),
(-89261,-89254,0,'Blackrock Disguise removed - remove Blackrock Orc Disguise (Female)'),
(-89261,-89255,0,'Blackrock Disguise removed - remove Firegut Ogre Disguise (Male)'),
(-89261,-89256,0,'Blackrock Disguise removed - remove Firegut Ogre Disguise (Female)'),
(-89261,-89257,0,'Blackrock Disguise removed - remove Goblin Mercenary Disguise (Male)'),
(-89261,-89258,0,'Blackrock Disguise removed - remove Goblin Mercenary Disguise (Female)'),
(-89261,-89259,0,'Blackrock Disguise removed - remove Smolderthorn Troll Disguise (Male)'),
(-89261,-89260,0,'Blackrock Disguise removed - remove Smolderthorn Troll Disguise (Female)'),
(-89253,-89261,0,'Blackrock Orc Disguise (Male) removed - remove Blackrock Disguise'),
(-89254,-89261,0,'Blackrock Orc Disguise (Female) removed - remove Blackrock Disguise'),
(-89255,-89261,0,'Firegut Ogre Disguise (Male) removed - remove Blackrock Disguise'),
(-89256,-89261,0,'Firegut Ogre Disguise (Female) removed - remove Blackrock Disguise'),
(-89257,-89261,0,'Goblin Mercenary Disguise (Male) removed - remove Blackrock Disguise'),
(-89258,-89261,0,'Goblin Mercenary Disguise (Female) removed - remove Blackrock Disguise'),
(-89259,-89261,0,'Smolderthorn Troll Disguise (Male) removed - remove Blackrock Disguise'),
(-89260,-89261,0,'Smolderthorn Troll Disguise (Female) removed - remove Blackrock Disguise');

-- 5
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=17 AND `SourceGroup`=0 AND `SourceEntry`=89261;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(17,0,89261,0,0,8,0,28327,0,0,1,185,0,'','Blackrock Disguise - not after Locked and Loaded (Alliance)'),
(17,0,89261,0,0,8,0,28453,0,0,1,185,0,'','Blackrock Disguise - not after Locked and Loaded (Horde)');
