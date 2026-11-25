-- Northern Barrens, the Southsea pirate camps: Southsea Cutthroat 3383 had faction template 190 (Ambient: neutral to everyone),
-- so the cutthroats stood yellow among the hostile Southsea Privateers 3384 (template 230, Southsea Freebooters) in the same
-- camps (play test 2026-11-25). Wowhead (MoP Classic) shows them hostile to both factions, and the Cataclysm database
-- (cata_world) has 230. Both retail TDB extracts keep 190 and add IMMUNE_TO_PC, which would make the kills of Southsea
-- Freebooters 887 impossible; not followed.
UPDATE `creature_template` SET `faction`=230 WHERE `entry`=3383;
