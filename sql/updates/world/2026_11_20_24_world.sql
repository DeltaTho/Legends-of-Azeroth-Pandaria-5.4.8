-- Badlands: the static Lost Vikings at Dragon's Mouth (Eric 46852, Baelog 46853, Olaf 46854) and the static Bad Dogs in New
-- Kargath (Amakkar 47011, Gargal 47013, Jurrix 47018) are hidden exactly while your own three companions are with you, and are
-- back at their fire once the companions leave (The Hidden Clutch handed in, or every training quest abandoned).
--
-- Before this they were shown by Generic Quest Invisibility Detection 2 (49417) while Eric / Amakkar's training quest was not
-- taken, and again from The Wrath of a Dragonflight complete: who took Baelog's or Olaf's quest first saw the static three
-- beside his summoned three (two Baelogs, two starters of each training quest), and from 27829 complete the statics stood
-- beside the companions again.
--
-- Sourced: the statics' Generic Quest Invisibility 2 (49415, type 8, amount 100; both TDBs hide the Alliance three with it);
--   the Badlands' own type-8 detection "See Quest Invis 2" 87403 (amount 1000, AreaGroup the Badlands); the companions stay
--   until The Hidden Clutch is handed in and "completing the quest will have players saying goodbye to the vikings" (wiki
--   27832 / 27897; plan rule R1).
-- Ours (the plan's draft, vikings VD-6, keyed the statics on quests; its own "stricter form" note keys them on the
--   companions, which is what this does): each faction's statics are seen while the player does not hold that faction's
--   companion aura (87262 "The Lost Vikings: Summon Eric" / 87589 "Ex-KEF: Summon Amakkar", whose spell_area rows decide
--   when the companions are out). A row that depends on an aura has its spell stripped everywhere when the aura lands or goes and the row no longer
--   fits (SpellAuras.cpp:1560-1577), so each row gets a detection no other row uses: 87403 for Dragon's Mouth, 49417 (the
--   generic pair of 49415, used by no other Badlands row) for New Kargath. Both still show the other faction's statics to a
--   player of that faction, as before.
-- Ships with the companions' summon rows (plan G-1); alone it is still consistent (no aura, no companions, statics shown).

DELETE FROM `spell_area` WHERE `spell` IN (49417, 87403) AND `area` IN (5564, 5565);
INSERT INTO `spell_area` (`spell`,`area`,`quest_start`,`quest_end`,`aura_spell`,`racemask`,`gender`,`autocast`,`quest_start_status`,`quest_end_status`) VALUES
(87403, 5564, 0, 0, -87262, 0, 2, 1, 0, 0),  -- Dragon's Mouth: the static vikings while the Lost Vikings are not with you
(49417, 5565, 0, 0, -87589, 0, 2, 1, 0, 0);  -- New Kargath: the static Bad Dogs while the Bad Dogs are not with you
