-- Blasted Lands: Bloodmage Drazial 7505 (giver of A Bloodmage's Gotta Eat Too 25690) back beside Bloodmage Lynnore at the back
-- of Dreadmaul Furnace.
-- Sourced: both TDBs (-11469.2, -2633.37, 4.72791, 3.94903); npc 7505 comments 2010-12-08 [+15] and 2011-09-08 [+10] (he stands
-- with Lynnore and now and then uses the stone and appears outside); Lynnore's text "quickly confers with Drazial". mop had him
-- outside on the exact arrival point of the inside stone's teleport (76896), so players attuning the bloodstone landed on him: a
-- sniff of him after one of those trips. His occasional trip outside is not built.
-- Ours: nothing.
UPDATE `creature` SET `position_x` = -11469.2, `position_y` = -2633.37, `position_z` = 4.72791, `orientation` = 3.94903
WHERE `guid` = 163109 AND `id` = 7505;
