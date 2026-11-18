-- Burning Steppes, Blackrock Cudgel of Discipline 89562 (item 63390; I Am the Law and I Am the Lash 28278 / 28439, Abuse of Power
-- 28279 / 28440): "the Cudgel hits for a quarter of the target's health" (wiki 28278), so four hits kill a troop before it can
-- unmask the player. The core reduced the quarter by the troop's armor (physical school, about 39 % on a Blackrock Sergeant at
-- level 50: seven hits) and truncated it (four hits left a level 50 sergeant at 2 health). IGNORE_ARMOR keeps the quarter whole;
-- the C++ SpellScript spell_burning_steppes_blackrock_cudgel rounds it up (zone_burning_steppes.cpp).

DELETE FROM `spell_custom_attribute` WHERE `spell`=89562;
INSERT INTO `spell_custom_attribute` (`spell`,`attribute`,`comment`) VALUES
(89562,'SPELL_ATTR0_CU_IGNORE_ARMOR','Blackrock Cudgel of Discipline - a quarter of the target''s health, not reduced by armor');

DELETE FROM `spell_script_names` WHERE `spell_id`=89562;
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(89562,'spell_burning_steppes_blackrock_cudgel');
