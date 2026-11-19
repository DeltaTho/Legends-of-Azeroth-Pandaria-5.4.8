-- Durotar, Dustwind Cave: two Burning Blade Neophytes 3196 stood doubled, 0.2 and 0.4 yd from another Neophyte (253509 on 251349,
-- 253337 on 251430). Both TDBs have one Neophyte at each spot (310442, 310453). Deleted the later copies (layers.txt). No addon,
-- pool, formation, event or per-guid script row refers to them. Shipped from section 4 (plan ruling R11; scope C agreed).

DELETE FROM `creature_addon` WHERE `guid` IN (253509, 253337);
DELETE FROM `creature` WHERE `guid` IN (253509, 253337);
