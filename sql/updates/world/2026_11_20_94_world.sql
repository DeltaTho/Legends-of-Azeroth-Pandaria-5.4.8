-- Badlands, Rheastrasza's Gift 27858 / 27898: the scene's Deathwing 46957 keeps the flight the script gives him.
--
-- He lands at the cave entrance on the ground and, at the end, flies off (npc_badlands_rg_camera, EVENT_RG_FLIES_OFF, which
-- sets him flying and on the Fly animation tier). His template allows no flight (no creature_template_movement row), so
-- Creature::UpdateMovementFlags, run on every update in which he moved, took the flight and the Fly tier off again as soon as
-- he left the ground spot (SetFlying(false), SetCanFly(false)): the client then played his walk animation along the whole
-- flight path (user's play test). With CREATURE_FLAG_EXTRA_NO_MOVE_FLAGS_UPDATE (0x200) the script alone sets his movement
-- flags, as for the Skitterweb Matriarch 44906 in Silverpine.
-- The entry is not shared: no spawns, no SmartAI; only 87442 RG: Summon Deathwing summons it (139780 names it with effect 157,
-- create item, not a summon). Ours.

UPDATE `creature_template` SET `flags_extra` = `flags_extra` | 0x200 WHERE `entry` = 46957;
