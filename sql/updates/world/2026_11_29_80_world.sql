-- Northern Barrens, Club Foote (14034): Sashya's "Hahaha, very nice, $n!" (BT 35013, creature_text 34651 group 3) never played.
-- Foote's row 9 made Sashya speak through target type 10 (her spawn guid); SmartAIMgr::IsTextValid checks a Talk row's group
-- against the script owner's own texts for every target type except 9, 11 and 19 (SmartScriptMgr.cpp:1289-1333), found no
-- group 3 on Foote 34754 and dropped the row at load ("using non-existent Text id 3, skipped"). Target type 19 (closest
-- creature 34651 within 15 yd: Sashya sits 4.9 yd from Foote) is not checked at load; at run time the target creature is the
-- talker and Foote's invoker, the clubbing player, the talk target (SmartScript.cpp:122-155), as Hargash's lines of the
-- 13999 scene already work. Sashya's own SmartAI (id 0, action list 3465100: the 13999 scene, ruling R2) is not touched.
UPDATE `smart_scripts` SET `target_type`=19, `target_param1`=34651, `target_param2`=15, `target_param3`=0,
`comment`='Chief Engineer Foote - Linked - Sashya (closest, 15 yd) says "Hahaha, very nice" to the clubber'
WHERE `entryorguid`=34754 AND `source_type`=0 AND `id`=9 AND `action_type`=1;
