-- Valley of Trials class quests are for orcs only, as their training quests already are.
-- Sourced: TDB 4.4.2 AllowableRaces 2 on all twelve Cataclysm class quests, Wowhead MoP Classic "Race: Orc" on all fourteen. mop had
-- every Horde race on the parchments 2383 3087 3088 3089 and the monk pair 31156 31157, and orc + goblin on 3090 and 25145. It only
-- shows for a non-orc Horde character who does Your Place In The World and Cutting Teeth in the Valley; such a character would take a
-- parchment whose orc-only training quest is then never pushed.
-- Not changed: 25152 and 25126 themselves (both TDBs allow every race there).
UPDATE `quest_template` SET `AllowableRaces` = 2 WHERE `ID` IN (2383, 3087, 3088, 3089, 3090, 25145, 31156, 31157);
