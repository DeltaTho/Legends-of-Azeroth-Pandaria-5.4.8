-- Durotar, Skull Rock (25262): the 5.4 Kor'kron (level 90 elites, phaseMask 65535: Grunts 71379 guids 563924-563930 563936 563937
-- 563854-563859 563950 563955 563957, Spotters 71055 563951 563949, Motivators 71052 563836 563852 563860 563938 563947, a Riderless
-- Battle Worg 71228 563853) fight the Burning Blade Fanatics 3197 and Apprentices 3198 outside the cave (hostile both ways), killed
-- them or wore them below half health, and took the Searing Collars and the kills from the players.
-- Plan ruling R20: the fight is retail 5.4 behaviour - Wowhead 71055 2013-09-19 [+1] and reply: Kor'kron fight the Skull Rock
-- Fanatics "though the Fanatics aren't dying to them - they're tough"; Skull Rock 2013-12-13 [+6]: a Fanatic fighting about eight
-- Kor'kron Grunts - so the fight stays and the cultists survive it.
-- How: creature_sparring_template 85 % for both entries (this core's table: Unit::DealDamage and Spell::DoAllEffectOnTarget stop
-- damage from creatures no player controls once the cultist is at 85 % or below, and show their melee as fake damage), plus the
-- script npc_durotar_skull_rock_cultist (SmartAI kept), which cuts a single big NPC hit at 85 % as well: the table alone only
-- stops a hit that would kill at 1 hp, and a 1-hp cultist gives no loot to the player who finishes it (half its health must come
-- from players). Players, pets and guardians are not limited.
-- What the player sees: Kor'kron and cultists exchanging blows outside Skull Rock with the cultists holding at about 85 % health;
-- a player who attacks a cultist kills it as usual and gets the kill, the loot and the collar chance.
-- The script also clears a player's tag (and restores health and the player-damage requirement) once no player or player's unit
-- is in the cultist's fight and none has hit it for 10 s: the core clears a tag only at an evade or a death, and the endless fight
-- never evades, so a cultist a player hit and then left would give the next player no loot.
-- Do the Kor'kron reach them: they are level 90 against level 9-10, so their aggro reach is 45 yd (Creature::GetAttackDistance,
-- level difference capped at 25); the cultists wander 3 yd (MovementType 1) and so pass in front of them. The nine Grunts
-- 563854-563859/563955/563957 stand 31-35 yd from the three Fanatic spots on the same level (z within 1.2 yd), and Grunts / a
-- Spotter on the ridge stand 23-31 yd from Apprentice 205100 and Fanatic 205095 (17-27 yd higher). So the flat-ground Grunts are
-- within reach of the Fanatics; whether line of sight and a path down the ridge exist for the others is not computed (watch).
-- Ours: 85 % (the value of this core's other endless NPC fights, e.g. Horgus' Skull) and the 10 s.

DELETE FROM `creature_sparring_template` WHERE `creature_id` IN (3197, 3198);
INSERT INTO `creature_sparring_template` (`creature_id`, `health_limit_pct`, `comment`) VALUES
(3197, 85, 'Burning Blade Fanatic - endless fight with the 5.4 Kor''kron outside Skull Rock (the Fanatics are not dying to them)'),
(3198, 85, 'Burning Blade Apprentice - endless fight with the 5.4 Kor''kron outside Skull Rock');

UPDATE `creature_template` SET `ScriptName` = 'npc_durotar_skull_rock_cultist' WHERE `entry` IN (3197, 3198);
