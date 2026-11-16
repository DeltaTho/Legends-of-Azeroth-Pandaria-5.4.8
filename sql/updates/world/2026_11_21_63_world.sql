-- Searing Gorge, They Build a Better Bullet 28030: a Dark Iron Marksman's or Lookout's Shoot that hits a player leaves a Dark Iron
-- Bullet 62916 in that player's bags, with or without the quest.
--
-- Both TDBs: 8338 / 8566 cast 88445 Shoot (school damage + FORCE_CAST 88444 on the target, which creates the bullet). 88444 is in
-- neither the 5.4.8 Spell.dbc nor mop spell_dbc, and mop's 8338 / 8566 cast 6660 Shoot (damage only), so being shot gave nothing.
-- New id 4 on each: SPELLHIT_TARGET 6660 -> ADD_ITEM 62916 x1 to the hit unit (the invoker; SmartAI::SpellHitTarget runs only on a
-- hit, Spell::DoAllEffectOnTarget, and ADD_ITEM skips non-players). The other rows (Shoot, Multi-Shot, Raptor Strike, flee at 15 %)
-- are unchanged; no per-guid SmartAI exists for either entry. Both entries already have AIName SmartAI (set again here).
-- Sourced: a bullet per hit, also without the quest (28030 2010-11-24 [+20] and replies; 2011-03-02; 2011-07-21; 62916 2011-08-12
-- [+38], 2012-01-06 [+60] "still happens in 5.4"). Ours: the mechanism (SmartAI instead of the missing 88444); only Shoot, as 88445.

UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (8338,8566);
DELETE FROM `smart_scripts` WHERE `entryorguid` IN (8338,8566) AND `source_type`=0 AND `id`=4;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(8338,0,4,0,31,0,100,0,6660,0,0,0,0,56,62916,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Dark Iron Marksman - On Shoot hit target - Give a Dark Iron Bullet'),
(8566,0,4,0,31,0,100,0,6660,0,0,0,0,56,62916,1,0,0,0,0,7,0,0,0,0,0,0,0,0,'Dark Iron Lookout - On Shoot hit target - Give a Dark Iron Bullet');
