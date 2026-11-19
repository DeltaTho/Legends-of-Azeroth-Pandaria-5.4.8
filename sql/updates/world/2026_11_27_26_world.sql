-- Valley of Trials class quests are offered from level 2, as Wowhead MoP Classic says (quick facts "Requires level 2" and reqlevel 2 on
-- all fourteen) and as mop's own 5.x monk pair 31156/31157 already is; TDB 4.4.2 and the Cataclysm-era wiki have 3.
-- With 3, a level-2 orc leaving Gornek after Cutting Teeth got no parchment and had to walk back once level 3; with 2 the parchment is
-- picked up with Invaders in Our Home and the 5.0.4 objective "Reach Level 3 to Learn X" is open until the spell comes at level 3.
-- A decision still open with the user (plan ruling R2): this commit stands alone so it can be dropped.
UPDATE `quest_template` SET `MinLevel` = 2 WHERE `ID` IN (2383, 3087, 3088, 3089, 3090, 25138, 25139, 25141, 25143, 25145, 25147, 25149);
