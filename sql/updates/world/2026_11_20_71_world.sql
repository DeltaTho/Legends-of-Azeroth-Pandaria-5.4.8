-- Badlands: the companions' pet bar. Eric "The Swift" 46855 / Amakkar 47021 is the player's pet; his bar shows Attack and Follow
-- and two buttons for each training quest taken (all six once the three are taken, and after the hand-ins), at buttons 3-4, 6-7
-- and 9-10. Each use ticks its own objective; Baelog / Jurrix shoots the player's target or speeds the three's attacks, Olaf /
-- Gargal raises his shield or taunts the player's target onto himself.
--
-- Before this: the bar held four buttons (Charge, Pocket Potion, and the Warcry buff and Olaf's Shield Wall cast by Eric on
-- himself), Valhalla Shot / Fiery Blast and Mighty Shout were missing, and three objectives were credited on any aggro.
--
-- Sourced: the six abilities, their effects and objectives (DBC 87278-87283 / 87608-87614 and the helpers' spells; quest_objective
--   of 27828/27834/27835/27891-27893, Horde: Fiery Blast 46865, Time Warp 46864); the pet bar and the button numbers (comments
--   on 27828, 27891, 27892; annick 2011-02-28); a hostile target needed (Adelorna 2010-12-01 [+30]); not mounted (720258
--   2010-12-08 [+6]).
-- Ours: slots 4 and 7 empty, the refusal while mounted, the 40 yd reach of Mighty Shout, the potion and the attack speed buff
--   kept to the player's own three; a playerbot in the group within 40 yd gets each credit too (bots never press a pet bar).
-- The pet cast is refused for a spell not in the creature's spell1-8 (Creature::HasSpell): the six go there; the bar itself is
-- built by npc_badlands_companion (zone_badlands_companions.cpp).

UPDATE `creature_template` SET `spell1` = 87278, `spell2` = 87279, `spell3` = 87281, `spell4` = 87280, `spell5` = 87282, `spell6` = 87283, `spell7` = 0, `spell8` = 0 WHERE `entry` = 46855;
UPDATE `creature_template` SET `spell1` = 87608, `spell2` = 87609, `spell3` = 87612, `spell4` = 87611, `spell5` = 87613, `spell6` = 87614, `spell7` = 0, `spell8` = 0 WHERE `entry` = 47021;

DELETE FROM `spell_script_names` WHERE `spell_id` IN (87278, 87279, 87280, 87281, 87282, 87283, 87608, 87609, 87611, 87612, 87613, 87614, 87277, 87596, 87274, 87606);
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(87278,'spell_badlands_companion_charge'),   -- Eric's Charge
(87608,'spell_badlands_companion_charge'),   -- Amakkar's Kidney Shot
(87279,'spell_badlands_companion_potion'),   -- Eric's Pocket Potion
(87609,'spell_badlands_companion_potion'),   -- Amakkar's Pocket Potion
(87281,'spell_badlands_companion_order'),    -- Baelog's Valhalla Shot
(87280,'spell_badlands_companion_order'),    -- Baelog's Warcry
(87282,'spell_badlands_companion_order'),    -- Olaf's Shield Wall
(87283,'spell_badlands_companion_order'),    -- Olaf's Mighty Shout
(87612,'spell_badlands_companion_order'),    -- Jurrix's Fiery Blast
(87611,'spell_badlands_companion_order'),    -- Jurrix's Time Warp
(87613,'spell_badlands_companion_order'),    -- Gargal's Shield Wall
(87614,'spell_badlands_companion_order'),    -- Gargal's Mighty Shout
(87277,'spell_badlands_companion_buff'),     -- Baelog's Warcry (the buff)
(87596,'spell_badlands_companion_buff'),     -- Jurrix's Time Warp (the buff)
(87274,'spell_badlands_companion_shout'),    -- Olaf's Mighty Shout (the taunt)
(87606,'spell_badlands_companion_shout');    -- Gargal's Mighty Shout (the taunt)
