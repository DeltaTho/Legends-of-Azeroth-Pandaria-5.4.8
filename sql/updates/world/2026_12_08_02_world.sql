-- Echo Isles class line: three quest starters no source has.
-- Sourced: TDB 12.1.0 creature_queststarter and Wowhead MoP Classic: 24764 The Rise of the Darkspear (druid) starts at Jin'thala
-- 37951 only, 24769 More Than Expected (druid) at Zen'tabra 38243 only, 24774 Proving Pit (rogue) at Legati 38244 only.
-- mop also had Zen'tabra offering the druid Rise (picked up and handed in at the same NPC, skipping Jin'thala and Zuni), Vol'jin
-- 38966 offering the druid More Than Expected beside where it is handed in, and the Darkspear Jailor offering the rogue Proving Pit.
-- The jailor keeps mop's npcflag 3 (gossip + quest giver; both TDBs: 1). Ours: without the quest-giver bit he could not be clicked
-- at all while npc_darkspear_jailor has taken his gossip flag away during a fight (zone_durotar.cpp:1672 / 1707); with it a click
-- still shows his menu text. He starts no quest any more.
-- The enders are unchanged: 24764 Zen'tabra, 24769 Vol'jin 38966, 24774 Legati.
DELETE FROM `creature_queststarter` WHERE (`id` = 38243 AND `quest` = 24764) OR (`id` = 38966 AND `quest` = 24769) OR (`id` = 39062 AND `quest` = 24774);
UPDATE `creature_template` SET `npcflag` = 3 WHERE `entry` = 39062;
