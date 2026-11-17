-- Zone 46 (Burning Steppes) row from the Swamp of Sorrows pass; held out of its first build, shipped 2026-11-20 after the user
-- saw the rocket wandering. Nothing else depends on it.
--
-- Burning Steppes, The Bogpaddle Bullet 48950 (guid 165442), the rocket parked at Sharon Boomgetter's launch rig, stays put
-- instead of drifting about within 3 yd.
--
-- Sourced: the Cataclysm TDB (4.4.2) spawn of 48950 on the same spot (its guid 288713) has MovementType 0 and wander distance 0;
--   screenshots 396388, 194720 and 362475 show it standing at the rig. The dossier's "AnimTier 1 (hover)" was a misread: that
--   TDB creature_addon row is guid 48950, another creature (StandState 1); the rocket's spawn has no addon row and its template
--   addon is all zero, as here, so nothing else changes.
-- The hover in the screenshots is the model's own: display 31992 is the rocket mount (CREATURE\ROCKETMOUNT2\ROCKETMOUNT2.M2,
--   CreatureModelData 3367, geometry from 0.18 to 2.25 yd above its origin), and the sniffed spot (z 152.438) is on the ground
--   (152.35) with no hover flag or anim tier in either TDB. A hover movement row (Ground 2) would lift it another HoverHeight on
--   top of that, higher than the screenshots show, so none is added.

UPDATE `creature` SET `MovementType` = 0, `wander_distance` = 0 WHERE `guid` = 165442 AND `id` = 48950;
