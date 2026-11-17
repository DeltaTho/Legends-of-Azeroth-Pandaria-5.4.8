-- Burning Steppes, Assault on Dreadmaul Rock 28320 (A) / 28454 (H): the war council cutscene on accept (plan F, S4 E1).
-- Sourced: the start spell 89947 (AODR: Summon Camera/Phase: the AODR Event Camera 48373 + phase 341), the actors and their
--   spells 89916 / 89919 / 89921 / 89977, the lines (broadcast texts 48535-48546, 48548-48550, 48658; speakers and order: wiki
--   notes and comments 2011-02-09 [+22], 2011-01-08 [+37]; 48545 is Demonic, LanguageID 8), boss emote 48658 "Meanwhile...".
-- Ours: SourceSpellID as the mechanism (no TDB has one on these quests; quest_template_addon rows are B's, only the column is
--   set here); the talk / question / exclamation emotes; TextRange 5 (personal: only the player in the cutscene hears it);
--   DONT_SAVE on 89947 (no phase 341 after a relog); the camera's rocket-chicken model 22903 removed (as RG Event Camera
--   46958, Badlands 2026_11_20_93: 48373 is summoned only by 89947, no spawns), so the camera is only the invisible stalker.

UPDATE `quest_template_addon` SET `SourceSpellID`=89947 WHERE `ID` IN (28320,28454);

DELETE FROM `spell_custom_attribute` WHERE `spell`=89947 AND `attribute`='SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB';
INSERT INTO `spell_custom_attribute` (`spell`, `attribute`, `comment`) VALUES
(89947, 'SPELL_ATTR0_CU_DONT_SAVE_AURA_TO_DB', 'AODR: Summon Camera/Phase - phase 341, not across logout');

UPDATE `creature_template` SET `ScriptName`='npc_bs_aodr_camera' WHERE `entry`=48373;
UPDATE `creature_template` SET `ScriptName`='npc_bs_aodr_actor' WHERE `entry` IN (48370,48371,48372,48409);

DELETE FROM `creature_template_model` WHERE `CreatureID`=48373 AND `CreatureDisplayID`=22903;

DELETE FROM `creature_text` WHERE `CreatureID` IN (48370,48371,48372,48373);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(48370,0,0,'We are nearly prepared to start this battle, brothers.  Thorg''izog, what is the matter?  Why are you covering your butt like that?',12,0,100,6,0,0,0,48535,5,'High Warlock Xi''lun - AODR council 1'),
(48370,1,0,'Can you still lead your troops?  Do you need to promote one of your sergeants?',12,0,100,6,0,0,0,48537,5,'High Warlock Xi''lun - AODR council 3'),
(48370,2,0,'I see.  Well, do the best you can.  And Neeralak, why are you all black and smoky?',12,0,100,6,0,0,0,48539,5,'High Warlock Xi''lun - AODR council 5'),
(48370,3,0,'Delivered?  Woke up?  What are you even talking about?  Were you attacked by flamekin?',12,0,100,6,0,0,0,48541,5,'High Warlock Xi''lun - AODR council 7'),
(48370,4,0,'You''re both failures.  But it doesn''t matter: with a pit lord on our side, we won''t need foot soldiers OR dragons.  Behold!',12,0,100,5,0,0,0,48544,5,'High Warlock Xi''lun - AODR council 10, Behold'),
(48370,5,0,'One, two, three, four, I declare a thumb war!',12,8,100,0,0,0,0,48545,5,'High Warlock Xi''lun - AODR ritual (Demonic; channel state by script)'),
(48370,6,0,'And now to quickly use the Orb of Domination, before the pit lord turns on us.',12,0,100,0,0,0,0,48546,5,'High Warlock Xi''lun - AODR the orb (cast emote by script)'),
(48371,0,0,'Those imps you had delivered... they woke up and started shooting fireballs at everybody!  It was chaos!',12,0,100,5,0,0,0,48540,5,'Dragon-Lord Neeralak - AODR council 6'),
(48371,1,0,'Imps, flamekin, whatever!  I don''t know warlock crap.  Demons all look the same to me!',12,0,100,1,0,0,0,48542,5,'Dragon-Lord Neeralak - AODR council 8'),
(48371,2,0,'Besides, I''ve been busy dealing with other issues.  Dozens of my dragons died when those two enemies swept through the front lines.',12,0,100,1,0,0,0,48543,5,'Dragon-Lord Neeralak - AODR council 9'),
(48371,3,0,'I never called any dragons...',12,0,100,1,0,0,0,48550,5,'Dragon-Lord Neeralak - AODR after the dragon reveal'),
(48372,0,0,'WHAT?  No reason... it''s just... something is very wrong with my stomach.  I think it''s something I ate.',12,0,100,5,0,0,0,48536,5,'General Thorg''izog - AODR council 2'),
(48372,1,0,'Timan fell from the Pillar of Ash.  Othana was eaten by wolves.  Gorlop fell in lava.  And most of my sergeants were killed in a freak cudgelling accident.',12,0,100,1,0,0,0,48538,5,'General Thorg''izog - AODR council 4'),
(48372,2,0,'The pit lord''s loose!  We''re doomed!  Retreat!',12,0,100,0,0,0,0,48548,5,'General Thorg''izog - AODR retreat (exclamation by script)'),
(48372,3,0,'Quickly, everyone run toward those dragons!  All troops, towards the dragons!  The dragons will save us!',12,0,100,5,0,0,0,48549,5,'General Thorg''izog - AODR after the dragon reveal'),
(48373,0,0,'Meanwhile, atop Dreadmaul Rock...',41,0,100,0,0,0,0,48658,5,'AODR Event Camera - cutscene start');
