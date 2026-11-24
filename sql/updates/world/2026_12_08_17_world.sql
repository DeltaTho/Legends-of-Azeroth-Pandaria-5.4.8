-- Territorial Fetish: the Spitescale Flag Bunny guid 251809 no longer carries a fetish for ever.
-- Its spawn addon had Territorial Fetish 72072 as a permanent aura (a sniff of a flag in use). spell_place_territorial_fetish
-- (zone_durotar.cpp:2432-2443) refuses a placement when the nearest flag bunny within 50 yd already has 72072, so that flag always
-- showed a fetish, could never be used, and a player standing nearest to it was refused ("invalid target") even beside a free flag.
-- Sourced: the bunny template has no aura and the other 21 flag bunnies have no addon; 72072 is meant to be cast by the bunny on a
-- placement and removed after 120 s (38560 SmartAI ids 0-2). The addon row goes; 251809 then uses the template like the others.
DELETE FROM `creature_addon` WHERE `guid` = 251809;
