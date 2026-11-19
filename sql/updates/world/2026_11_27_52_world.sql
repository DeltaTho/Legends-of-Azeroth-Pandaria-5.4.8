-- Durotar, Watershed Patrol 25188 (plan section 3, CP5 D-1 and CP6 EB-3; ruling R16; dossier D-watershed "Shared mechanism").
-- D-1 (BLOCKED the quest): Misha 3193, Zen'Taji 39324 and Raggaran 39326 have SmartAI rows that credit the patrol at the
-- hand-in of their quests (On Quest Reward 25193 -> 39333, 25195 -> 39334, 25192 -> 39332, 25189 -> 39331, to the invoker),
-- but their ScriptName npc_watershed_patrol made CreatureAISelector take that empty ScriptedAI instead, and its
-- CreatureScript::OnQuestReward has had no caller since ddad56404: no objective could ever move. The class is removed from
-- zone_durotar.cpp in the same commit; the core hook is not restored in this pass (R16). Tekla 39325 also carried the name
-- (no AIName, no rows): 2026_11_27_53 sets her escort script (each file sets only the rows it owns, so the order of the files
-- does not matter; between the two her old name points at no script and she stands as today).
-- SOURCED: each person is helped by doing their quests (Wowhead 2010-11-25 [+11] Talvanor; wiki Notes); 25190 gives no
-- credit, 25192 does (same comment). OURS (EB-3): taking the patrol, and logging in with it, credits the people already
-- helped (quest_durotar_watershed_patrol / player_durotar_watershed): their quests cannot be done twice, so an abandoned and
-- retaken patrol, or one taken after a hand-in that the dead hook never credited, could never be finished.
UPDATE `creature_template` SET `ScriptName` = '' WHERE `entry` IN (3193, 39324, 39326);
UPDATE `quest_template_addon` SET `ScriptName` = 'quest_durotar_watershed_patrol' WHERE `ID` = 25188;
