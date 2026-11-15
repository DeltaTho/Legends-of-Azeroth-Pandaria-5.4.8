-- New Kargath / Dragon's Mouth front: Darkflight Shadowspeakers 46918 (Their Hunt Continues 27830 / 27895) play their emote
-- animations again.
--
-- mop's template alone carries unit_flags 0x20000000 (PREVENT_EMOTES_FROM_CHAT_TEXT; the template's only flag); neither TDB has
-- it (tdb-diff section 1). Cosmetic. The per-spawn unit_flags 8 that section C sets on four Shadowspeaker spawns replace the
-- template value on those four and are not touched here.

UPDATE `creature_template` SET `unit_flags` = 0 WHERE `entry` = 46918;
