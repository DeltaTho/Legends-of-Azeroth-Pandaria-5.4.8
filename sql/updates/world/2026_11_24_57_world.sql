-- Blasted Lands, The Amulet of Allistarj (25697 H / 26167 A): the Allistarjian Vault 203229 in the Serpent's Coil comes back after
-- 2 minutes instead of 5 (both TDBs: 120 s for the same spawn, 216208). One vault serves every player one opening at a time.
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `guid`=155849 AND `id`=203229;
