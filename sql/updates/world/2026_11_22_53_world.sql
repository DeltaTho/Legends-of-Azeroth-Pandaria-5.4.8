-- Burning Steppes: the static John J. Keeshan 03 (48346, guid 373734, Morgan's Vigil) and Ariok 03 (48567, guid 373702, Flame
-- Crest) go, with the interim staging that showed them only in the follower window (phase_area 46 / 314 and 46 / 316 and their
-- source-26 conditions, 2026_11_22_25). Both entries are the summons of 89869 / 90483 (SUMMON-HAS-STATIC: neither TDB spawns
-- them); since 2026_11_22_52 the follower offers and takes the Blood Tour group in the field. Ships in the same build as
-- 2026_11_22_52 and the follower script (plan.md section 4). Neither guid has an addon, formation, pool, game event, link or
-- per-guid SmartAI (checked 2026-11-17). The camp copies 48306 / 48565 still offer Blood Tour, Draconic Vanguard and A Deal With a
-- Dragon before the first is taken.

DELETE FROM `creature` WHERE `guid` IN (373734,373702) AND `id` IN (48346,48567);
DELETE FROM `creature_addon` WHERE `guid` IN (373734,373702);

DELETE FROM `phase_area` WHERE `AreaId`=46 AND `PhaseId` IN (314,316);
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=26 AND `SourceEntry`=46 AND `SourceGroup` IN (314,316);
