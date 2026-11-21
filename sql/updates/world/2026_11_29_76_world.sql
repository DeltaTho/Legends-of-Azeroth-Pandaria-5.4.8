-- Northern Barrens (zone 17), scope I-O: objects.
-- I-O1 Takk's Nest 202081: one nest (72798, 18 yd from the sniffed spot), not five at once (the nest gives the Leaping Hatchling pet).
DELETE FROM `gameobject` WHERE `id`=202081 AND `guid` IN (6347,6349,6350,184229);
-- I-O2 static Samophlanges 162024 in neither TDB: 175584 at Sputtervalve's feet, 175586 by the road at (859,-2346). 175585 stays (H).
DELETE FROM `gameobject` WHERE `id`=162024 AND `guid` IN (175584,175586);
