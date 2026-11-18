-- Blasted Lands A (_19): the static Portal-Sentries at the Dark Portal camps are awake (coverage audit C10).
--
-- Today: Horde Portal-Sentry 42301 has template StandState 3 (asleep), so its three spawns without an own addon row (163589,
-- 163608, 163626) lie asleep; Alliance Portal-Sentry 41269 has three spawn addon rows with StandState 3 (163630, 163634,
-- 163635). Three sleeping guards per camp.
-- SOURCED: both TDBs (4.4.2, 12.1.0): creature_template_addon 42301 and 41269 StandState 0, and no creature_addon row for any of
-- their 12 + 12 sentry spawns: no sentry sleeps. No comment mentions a sleeping sentry.
-- Only StandState is changed. The four walking sentries that section C scripts for Watching Our Back (25695 / 26174: 163609,
-- 163638, 163623, 163625) have their own addon rows with StandState 0 and their paths: not touched. Emotes (READY1H 333 on the
-- template / other addons) are left as they are.

UPDATE `creature_template_addon` SET `StandState` = 0 WHERE `entry` = 42301;
UPDATE `creature_addon` ca JOIN `creature` c ON c.`guid` = ca.`guid` SET ca.`StandState` = 0
  WHERE c.`id` = 41269 AND c.`guid` IN (163630, 163634, 163635);
