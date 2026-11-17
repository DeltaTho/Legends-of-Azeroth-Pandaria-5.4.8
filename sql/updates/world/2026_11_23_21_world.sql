-- Swamp of Sorrows, the Bloodmire and Stonard: let the battle be fought, held at 80 % on both sides, and keep players off
-- the battle mounts.
--
-- Sourced: Stonard Warriors fight Marshtide Footmen and are a quest kill (27821); both TDBs give 46166 unit_flags 0, mop's
-- IMMUNE_TO_PC kept every NPC and every resting player off them. Stonard Ogres fight the Marshtide Knights and players
-- (27795, 27854: "our knights are well-matched against the brutes"); both TDBs have them not civilian, mop's flags_extra 2
-- kept them from ever starting a fight. Cowering Peons (stage III, posed cowering, emote 431) are civilian in TDB 4.4.2
-- (column Civilian 1; TDB 12.1.0 flags_extra 0); mop's 0 sent them at every Alliance player in Stonard.
-- Ours: the sparring caps (retail's "not below ~80 %" battles; here NPC damage below half denies a player's kill credit,
-- Creature.h IsDamageEnoughForLootingAndReward) on the six fighting entries of the dossier and on the kodos, wardrummers,
-- steeds and clerics that stand in the stage-I battle (otherwise they died to footmen and warriors every few minutes and lay
-- about); the Cowering Peons immune to NPCs (the invaders beside them would otherwise kill them; players can still attack
-- them); the two spellclick conditions. The ride rows of the kodo and the steed stay: this core seats a vehicle's accessory
-- through its npc_spellclick_spells row (Vehicle::InstallAccessory -> Unit::HandleSpellClick, #170), so deleting them would
-- unsummon every wardrummer and cleric. Only the accessory may click now; a player sees no click cursor on an emptied kodo or
-- steed (Player::CanSeeSpellClickOn checks the condition).

-- Stonard Warrior: no IMMUNE_TO_PC (33024 -> 32768)
UPDATE `creature_template` SET `unit_flags`=32768 WHERE `entry`=46166;
-- Stonard Ogre: not civilian
UPDATE `creature_template` SET `flags_extra`=0 WHERE `entry`=46765;
-- Cowering Peon: civilian (TDB 4.4.2), immune to NPCs (ours)
UPDATE `creature_template` SET `flags_extra`=2, `unit_flags`=512 WHERE `entry`=46874;

DELETE FROM `creature_sparring_template` WHERE `creature_id` IN (46164,46166,46765,46414,46869,46870,46748,46749,46840,46841);
INSERT INTO `creature_sparring_template` (`creature_id`,`health_limit_pct`,`comment`) VALUES
(46164,80,'Marshtide Footman - Bloodmire battle'),
(46166,80,'Stonard Warrior - Bloodmire battle'),
(46748,80,'Stonard Kodo Beast - Bloodmire battle'),
(46749,80,'Stonard Wardrummer - Bloodmire battle'),
(46840,80,'Marshtide Steed - Bloodmire battle'),
(46841,80,'Marshtide Cleric - Bloodmire battle'),
(46765,80,'Stonard Ogre - Bloodmire battle'),
(46414,80,'Marshtide Knight - Bloodmire battle'),
(46869,80,'Marshtide Invader - assault on Stonard'),
(46870,80,'Stonard Defender - assault on Stonard');

-- Only the kodo's wardrummer and the steed's cleric may take the seat
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=18 AND `SourceGroup` IN (46748,46840) AND `SourceEntry`=46598;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(18,46748,46598,0,0,31,0,3,46749,0,0,0,0,'','Stonard Kodo Beast - only its Stonard Wardrummer rides it'),
(18,46840,46598,0,0,31,0,3,46841,0,0,0,0,'','Marshtide Steed - only its Marshtide Cleric rides it');
