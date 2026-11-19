-- Master Gadrin (3188, Sen'jin Village) uses faction template 2663, as both TDBs (mop 126).
-- Horde players see no difference (both friendly). Alliance players: 126 is hostile (a red level-12 NPC), 2663 neutral (yellow); he
-- can be attacked under either (not IMMUNE_TO_PC). Against NPCs:
-- 126 is hostile to the Northwatch (1075) and 2663 is not, and 2663 is attacked by the Clattering Scorpids (413) where 126 is not
-- (hostile.py); neither matters, he is IMMUNE_TO_NPC (unit_flags 512). Which client first used 2663 is unknown (both TDBs are later
-- sniffs); taken on the plan's ruling R5.
UPDATE `creature_template` SET `faction` = 2663 WHERE `entry` = 3188;
