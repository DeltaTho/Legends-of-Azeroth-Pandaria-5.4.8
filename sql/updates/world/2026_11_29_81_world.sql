-- Northern Barrens, The Grol'dom Militia (13973) / Drag it Out of Them (13961): Razormane Pillager 34503 carried the GOSSIP npcflag
-- all the time, so right-clicking a hostile pillager opened gossip instead of attacking it (play test 2026-11-24). Both TDBs
-- (4.4.2 and 12.1.0) have npcflag 0. The gossip ("<Pound this chump.>", menu 10519) is needed only on a netted pillager:
-- spell_snared_in_net now sets the flag while the net holds and takes it off again; a respawn resets it from the template.
UPDATE `creature_template` SET `npcflag`=0 WHERE `entry`=34503;
