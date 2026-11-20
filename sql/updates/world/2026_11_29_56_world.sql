-- Northern Barrens, Echeyakee (881): taming Echeyakee counts as conquering him.
-- Sourced: the quest log text "Slay or subdue him"; Wowhead 881 comments 2010-11-24 [+47], 2011-01-04, 2011-03-05,
-- 2011-05-26, 2011-06-04 (mixed: some 2011 replies say a tame did not count; the quest text decides, plan question 8).
-- Ours: the hook on 13481 Tame Beast (the effect spell of 1515), spell_barrens_tame_echeyakee in zone_the_barrens.cpp.
-- To undo the choice (Q8 = kill only): delete this row.
DELETE FROM `spell_script_names` WHERE `spell_id` = 13481 AND `ScriptName` = 'spell_barrens_tame_echeyakee';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (13481, 'spell_barrens_tame_echeyakee');
