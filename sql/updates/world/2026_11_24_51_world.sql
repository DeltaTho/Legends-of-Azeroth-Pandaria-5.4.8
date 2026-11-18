-- Blasted Lands, You Are Rakh'likh, Demon (25701 H / 26171 A): the fight with Razelikh the Defiler on the Rise of the Defiler,
-- run by Loramus Thalipedes 41279 (C++ npc_blasted_lands_loramus_rise, npc_blasted_lands_razelikh, npc_blasted_lands_loramus_defiled,
-- spell_blasted_lands_stone_knife, spell_blasted_lands_flames_of_chaos, spell_blasted_lands_demon_hunters_resolve in
-- zone_blasted_lands.cpp).
-- Sourced: every line below (broadcast_text, speakers and order from the wiki 25701 / 26171 notes and comments 387878, radicarl,
-- Taishigi), 41292's level 57 and no stun (both TDBs), Loramus sessile (TCPP static flags), the felhound's spawn visual (its own
-- spell 7741 Summoned Demon).
-- Ours: charm immunity on Razelikh and the Defiled (a warlock could enslave the Defiled and break the quest, comment 484865), the
-- felhound's visual once when it appears instead of every 15-20 s in combat; who Flames of Chaos' three effects hit (players only;
-- effect 2 nobody) and Demon Hunter's Resolve reaching players only (see the C++).

-- Razelikh, his felhound and Loramus the Defiled are summoned by the event; the static copies stood (and wandered) there at all times
DELETE FROM `creature_addon` WHERE `guid` IN (313940,313942,369400);
DELETE FROM `creature` WHERE (`guid`=313940 AND `id`=41280) OR (`guid`=313942 AND `id`=41290) OR (`guid`=369400 AND `id`=41292);

-- Loramus on the summit stays where he is (TCPP static flags 0x80106: SESSILE)
UPDATE `creature` SET `MovementType`=0, `wander_distance`=0 WHERE `guid`=313941 AND `id`=41279;

UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_blasted_lands_loramus_rise' WHERE `entry`=41279;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_blasted_lands_razelikh', `mechanic_immune_mask`=`mechanic_immune_mask`|1 WHERE `entry`=41280;
UPDATE `creature_template` SET `AIName`='', `ScriptName`='npc_blasted_lands_loramus_defiled', `minlevel`=57, `maxlevel`=57,
 `unit_flags`=`unit_flags`&~262144, `mechanic_immune_mask`=`mechanic_immune_mask`|1 WHERE `entry`=41292;
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (41279,41280,41292) AND `source_type`=0;

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry`=41290;
DELETE FROM `smart_scripts` WHERE `entryorguid`=41290 AND `source_type`=0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,
 `event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,
 `action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,
 `target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(41290,0,0,0,54,0,100,0,0,0,0,0,0,11,7741,32,0,0,0,0,1,0,0,0,0,0,0,0,0,'Defiled Felhound - On Just Summoned - Cast Summoned Demon');

DELETE FROM `creature_text` WHERE `CreatureID` IN (41279,41280,41292);
INSERT INTO `creature_text` (`CreatureID`,`GroupID`,`ID`,`Text`,`Type`,`Language`,`Probability`,`Emote`,`Duration`,`Sound`,`SoundType`,
 `BroadcastTextId`,`TextRange`,`comment`) VALUES
(41279,0,0,'Demon!  I have returned from beyond the grave to destroy you!',12,0,100,0,0,0,0,41232,0,'Loramus Thalipedes - Rise intro 1'),
(41279,1,0,'Death has not erased my memory.  I still know your name...',12,0,100,0,0,0,0,41233,0,'Loramus Thalipedes - Rise intro 2'),
(41279,2,0,'RAKH''LIKH!  Come, and know demise!',14,0,100,0,0,0,0,41234,0,'Loramus Thalipedes - Rise intro 3, summons Razelikh'),
(41279,3,0,'Hold on!',14,0,100,0,0,0,0,42291,0,'Loramus Thalipedes - pulls a player back onto the Rise'),
(41279,3,1,'Return to me!',14,0,100,0,0,0,0,41245,0,'Loramus Thalipedes - pulls a player back onto the Rise'),
(41279,3,2,'Ah!  Get back over here!',14,0,100,0,0,0,0,42292,0,'Loramus Thalipedes - pulls a player back onto the Rise'),
(41280,0,0,'Fool of a demon hunter.  How many pieces must I cut you into this time?',14,0,100,0,0,0,0,41235,0,'Razelikh the Defiler - Rise intro'),
(41280,1,0,'Enough games!',14,0,100,0,0,0,0,41236,0,'Razelikh the Defiler - transfer 1'),
(41280,2,0,'What''s this?  Loramus... I see, they used the Altar of Storms, didn''t they?',12,0,100,0,0,0,0,41237,0,'Razelikh the Defiler - transfer 2'),
(41280,3,0,'You must feel it already then... the demonic energy entering your heart, your lungs, your soul...',12,0,100,0,0,0,0,41238,0,'Razelikh the Defiler - transfer 3'),
(41280,4,0,'Allow me to speed up the process a bit!',14,0,100,0,0,0,0,41239,0,'Razelikh the Defiler - transfer 4, Transfer Soul'),
(41280,5,0,'%s goes into a frenzy!',16,0,100,0,0,0,0,2384,0,'Razelikh the Defiler - Frenzy'),
(41292,0,0,'Now, heroes!  Finish me, while Rakh''likh possesses my body!',12,0,100,0,0,0,0,41241,0,'Loramus the Defiled - after the transfer'),
(41292,1,0,'The pain!  Oh, sweet sassy molassey, the pain!',14,8,100,0,0,0,0,41240,0,'Loramus the Defiled - beaten (Demonic)'),
(41292,2,0,'Quickly!  Use the knife on me!  Time runs short!',12,0,100,0,0,0,0,41242,0,'Loramus the Defiled - asks for the knife'),
(41292,3,0,'The stone knife!  Use it NOW!  I can''t maintain control of him for much longer...',12,0,100,0,0,0,0,41244,0,'Loramus the Defiled - asks again'),
(41292,4,0,'The delights of death await you.',12,8,100,0,0,0,0,41243,0,'Loramus the Defiled - Razelikh speaks (Demonic)'),
(41292,5,0,'It is done.  Leave me here, then, while I wrestle with Rakh''likh in the next world.  Your job here is done, heroes.',12,0,100,0,0,0,0,41246,0,'Loramus the Defiled - sealed');

-- 77380 the Stone Knife; 10854 Flames of Chaos (who its effects hit); 77371 Demon Hunter's Resolve (its area auras reach players only)
DELETE FROM `spell_script_names` WHERE `spell_id` IN (77380,10854,77371);
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(77380,'spell_blasted_lands_stone_knife'),
(10854,'spell_blasted_lands_flames_of_chaos'),
(77371,'spell_blasted_lands_demon_hunters_resolve');
