-- Durotar and Orgrimmar: three extra quest givers that are each the quest's own ender, which neither TDB has.
--   Sent for Help (25256): Spiketooth 39590 offered (and took back) the breadcrumb that sends you to him; only Vek'nag 39604 starts it.
--   Neeru Fireblade (25263): Neeru 3216 offered it to anyone who had done Skull Rock, skipping Margoz 3208, who starts it.
--   Message for Garrosh (25267): Garrosh 39605 offered it; only the Kor'kron Loyalist 39609 starts it (and seats the goblin on
--   his battleworg when it is taken there).
-- Sourced: both TDBs' creature_queststarter (25256 [39604], 25263 [3208], 25267 [39609]).
-- Kept: the Kor'kron Loyalist as a second starter of Warchief's Emissary (25266), against both TDBs (Thrall 38935 only). Thrall
-- stands on the Lost Isles (map 648), which a goblin cannot go back to once he has sailed to Bladefist Bay; a goblin who
-- abandons 25266 in Durotar can take it again only from the Loyalist (it is complete on accept and ends at him). Without the
-- row the goblin chain would stop there for good.
-- Every quest keeps a giver in Durotar in every state: 25256 Vek'nag (Margoz's camp), 25263 Margoz (also after an abandon),
-- 25267 the Loyalist on the Bladefist Bay dock.

DELETE FROM `creature_queststarter` WHERE (`id`, `quest`) IN ((39590, 25256), (3216, 25263), (39605, 25267));
