-- Badlands, Rheastrasza's Gift 27858 / 27898: the scene's camera and the player's copy never take the rocket chicken model.
--
-- RG Event Camera 46958 and Player Mirror Image 46956 each had two displays at equal probability, 11686 (InvisibleStalker.m2)
-- and 22903 (RocketChicken.m2, scale 1.5), and no TRIGGER flag, so ObjectMgr::ChooseDisplayId picked the rocket chicken in
-- about half the summons.
-- - The camera: its three seats put the eye at the vehicle (CameraModes 90 / 91 / 94, position offset 0), so the chicken sat
--   around the eye for the whole scene.
-- - The copy: 87439's CLONE_CASTER gives it the player's display (AuraEffect::HandleAuraCloneCaster); a chicken showed in the
--   bushes whenever the clone did not land (no copy found within 40 yd by spell_badlands_rg_mirror_image). With the stalker
--   only, such a copy is invisible instead.
-- Neither entry is shared: no spawns, no SmartAI; only 87435 RG: Summon Camera summons 46958 and only 87434 RG: Summon Player
-- Mirror Image summons 46956 (the other SpellEffect rows naming them are effect 157, create item, not summons).
-- Sourced: both display rows (TDB). Ours: dropping 22903 from the two.

DELETE FROM `creature_template_model` WHERE `CreatureID` IN (46956, 46958) AND `CreatureDisplayID` = 22903;
