-- Northern Barrens S1 (_11): Ratchet quest data - Find Baron Longshore Horde only, two log turn-ins, Gazlowe's extra ender,
-- Gazlowe's Fortune after the map, quest object and quest mob respawns.
-- (plan.md section 1 `_11`; dossier F: F-14045-1, F-14038-2, F-14046-2, F-887-1, F-14050-2, F-respawn.)
--
-- SOURCED: 14045 is Horde-only in both TDBs (946 / the Horde mask), mop offered it to the Alliance at Gazlowe; 14038 and 14046
-- are handed in from the log in both TDBs (QUEST_FLAGS_AUTO_COMPLETE 0x10000; "radio me with this stolen gnomecorder");
-- 887 ends at Dizzywig 3453 only (both TDBs); quest objects 195203 195205 195211 and Garvey 34750 / 34747 respawn in 120 s in
-- both TDBs (mop 300; comments: ammo "respawn fairly fast", Garvey "1 min 5 s .. 1 min 30 s"); 14050 follows 14049 by its
-- text ("Sink me, you were right! There's a map tattooed on the skull") and a 2010-12-30 comment [+15].
-- OURS / CHOICE POINTS: 14050 PrevQuestID 14049 (questions.md Q1 default yes; both TDBs and Wowhead's series have no link) -
-- one UPDATE below; 14045 stays a walk-to turn-in at the Baron (Q3 default no; yes = add 0x10000 to 14045 here).

-- F-14045-1: Find Baron Longshore is Horde only.
UPDATE `quest_template` SET `AllowableRaces`=33555378 WHERE `ID`=14045;

-- F-14038-2 / F-14046-2: handed in from the quest log.
UPDATE `quest_template` SET `Flags`=`Flags`|0x10000 WHERE `ID` IN (14038,14046);

-- F-887-1: Gazlowe is not an ender of Southsea Freebooters (Dizzywig still is; Gazlowe still starts it).
DELETE FROM `creature_questender` WHERE `id`=3391 AND `quest`=887;

-- F-14050-2 (Q1): Gazlowe's Fortune after A Most Unusual Map.
UPDATE `quest_template_addon` SET `PrevQuestID`=14049 WHERE `ID`=14050;

-- F-respawn: quest objects and quest mobs back to 120 s.
UPDATE `gameobject` SET `spawntimesecs`=120 WHERE `id` IN (195203,195205,195211) AND `map`=1;
UPDATE `creature` SET `spawntimesecs`=120 WHERE `id` IN (34750,34747) AND `map`=1;
