-- Blasted Lands, Watching Our Back (25695 Horde / 26174 Alliance): the walking Portal-Sentries catch a player reading the plans
-- (zone_blasted_lands_bloodstone.cpp: spell_blasted_lands_portal_sentry_trigger on 77361 Portal-Sentry Trigger Aura).
--
-- Sourced: the DBC kit (77361 periodic 1 s, 77360 Caught in the Act! 20 yd, 77364 Examining, 77366 Teleport to the commanders);
-- the whispers (broadcast 41208 "Begone, Horde thief!" for the Alliance Portal-Sentry 41269, 42246 "Begone, Alliance thief!" for
-- the Horde Portal-Sentry 42301, 41206 / 41207 for both: comments 25695 2011-12-18 [+677], 2010-11-25 [+126], 26174 2010-11-23
-- [+49], wiki notes); the walkers are mop's four sentries on paths (163609, 163638 at the Alliance camp; 163623, 163625 at the
-- Horde camp). Neither TDB has the aura or the texts.
-- Ours: the aura on the four walkers only (the comments speak only of the patrols); the selection rules in the script header.
-- 77361 alone would cast 77360, a cone stun, on every enemy in front of the sentry each second: it only ships with the script.
UPDATE `creature_addon` SET `auras` = '77361' WHERE `guid` IN (163609, 163638, 163623, 163625);

DELETE FROM `spell_script_names` WHERE `spell_id` = 77361 AND `ScriptName` = 'spell_blasted_lands_portal_sentry_trigger';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES (77361,'spell_blasted_lands_portal_sentry_trigger');

DELETE FROM `creature_text` WHERE `CreatureID` IN (41269, 42301);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,`BroadcastTextId`,`TextRange`,`comment`) VALUES
(41269,0,0,'Begone, Horde thief!',15,0,100,0,0,0,0,41208,0,'Alliance Portal-Sentry - caught a Horde reader of the plans'),
(41269,1,0,'Get away from those!',15,0,100,0,0,0,0,41206,0,'Alliance Portal-Sentry - caught a reader of the plans'),
(41269,1,1,'What do you think you''re doing?',15,0,100,0,0,0,0,41207,0,'Alliance Portal-Sentry - caught a reader of the plans'),
(42301,0,0,'Begone, Alliance thief!',15,0,100,0,0,0,0,42246,0,'Horde Portal-Sentry - caught an Alliance reader of the plans'),
(42301,1,0,'Get away from those!',15,0,100,0,0,0,0,41206,0,'Horde Portal-Sentry - caught a reader of the plans'),
(42301,1,1,'What do you think you''re doing?',15,0,100,0,0,0,0,41207,0,'Horde Portal-Sentry - caught a reader of the plans');
