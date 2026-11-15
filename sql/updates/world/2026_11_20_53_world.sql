-- Badlands, Tomb of the Watchers: the Trove of the Watchers 206374 opens only for a player it has a quest for.
--
-- Sourced: gameobject_template_addon of TDB 4.4.2 gives the chest flags 4 (GO_FLAG_INTERACT_COND): usable only with a quest
--   from it (The Titans' Trove 27912 / 27913 end here, Return to Blam 27794 / 27888 start here).
-- Ours: not that flag. This core never sends GO_DYNFLAG_LO_ACTIVATE for a quest giver object (GameObject::BuildValuesUpdate:
--   chests and goobers only), so the flag would close the chest to everyone and break both chains. The script
--   go_badlands_trove_of_the_watchers (zone_badlands_titans.cpp) gives a player with nothing to take or hand in no window
--   instead (until now an empty gossip box). The chest stays where it is, always visible (orchestrator ruling G1, option b;
--   the "appears after the second defender falls" option was not taken).

UPDATE `gameobject_template` SET `AIName`='', `ScriptName`='go_badlands_trove_of_the_watchers' WHERE `entry`=206374;
