-- Northern Barrens (zone 17), mechanical checks of research\_prior-region-backports.md ("Checks every earlier zone should get once").
-- Checks run for zone 17 (the rest are in the commit): (2) display ids: none missing; (3) spell_area: 2 rows, no aura_spell; (4) phase_area: none;
--   (5) follower / vehicle auras: none without DONT_SAVE (65466 control-vehicle is DONT_SAVE by the core; 65595 is S5's, 96526 the
--   Silver Bullet's); (6) source-20 conditions: none; (10) paired service NPCs: only the Gargok double, fixed in _73.
-- (9) Ground creatures whose creature_template_movement row allows flight: Deviate Coiler 3630, Deviate Stinglash 3631 and Deviate
--   Coiler Hatchling 20797 are snakes that patrol (MovementType 1 / 2) with Flight 2 (CanFly); TDB 1210 / 442 have no movement row
--   for them (ground). Flight 0 as Adder 3300 and the other snakes. All their spawns are zone 17. Not changed: Witchwing Harpy 3276 /
--   Windcaller 3280 and Barrens Vulture 34640 (birds, left flying), triggers and bunnies.
UPDATE `creature_template_movement` SET `Flight`=0 WHERE `CreatureId` IN (3630,3631,20797);
