-- Durotar: remove three stray spawns and two custom spell-focus objects that serve no live quest.
--
-- 1) Razor Hill Grunt 51911 guid 303088 stood 1.3 yd inside Burok, the Razor Hill flight master (272.16,-4769.88): one
--    level-90 grunt overlapping the NPC players click. Neither TDB has entry 51911 anywhere (the TDBs' Razor Hill
--    Grunts are 5953). No gossip, addon, path or script. Sourced: absence from both TDBs and the overlap.
-- 2) Pygmy Surf Crawler 39004: guids 252979 and 253021 stood 0.3 yd apart (-1091.9,-5138.0), the same crab twice; neither
--    TDB has a crawler on that spot (nearest 14.7 yd). Delete the higher guid. Nothing references it.
-- 3) Custom spell-focus objects (gameobject type 8, templates VerifiedBuild 1, in neither TDB). Each was checked against
--    the spells that require its focus (Spell.dbc -> SpellCastingRequirements.RequiresSpellFocus) and the quests behind them:
--    - 301090 "Orgrimmar Gates" (focus 1697, guid 217532 at 1386.4,-4369.5, an Elwynn rock model on the gate road): only
--      87140 Read Warchief's Proclamation (item 62493) needs it, for 27801 Show Me Your Papers, a quest of the 2010
--      Cataclysm pre-launch event (game_event 48, ended 2010-12-06) with no starter in mop.
--    - 100035 "Shaman Shrine" (focus 63, guid 66170 at -884,-4296 on a hill west of the Valley, a shaman stone model):
--      only 8202/8898/8899/8900/9735 Sapta Sight need it, for the pre-Cataclysm shaman quests Earth/Fire/Water Sapta and
--      Call of Earth (972, 1462-1464, 1516-1521), none with a starter in mop. The other three 100035 spawns (Silverpine,
--      Thousand Needles, Mulgore) are left.
--    - 301050 "top of Razor Hill Watchtower" (focus 1657) is the focus of 73817 Thonk's Spyglass (25187): kept.

DELETE FROM `creature_addon` WHERE `guid` IN (303088, 253021);
DELETE FROM `creature` WHERE (`id` = 51911 AND `guid` = 303088) OR (`id` = 39004 AND `guid` = 253021);
DELETE FROM `gameobject_addon` WHERE `guid` IN (217532, 66170);
DELETE FROM `gameobject` WHERE (`id` = 301090 AND `guid` = 217532) OR (`id` = 100035 AND `guid` = 66170);
