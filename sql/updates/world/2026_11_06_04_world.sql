-- Hellfire Ramparts: Vazruden the Herald 17307 had UNIT_FLAG_IMMUNE_TO_NPC, which is not on him in retail or Cataclysm (TDB 1210 and 442, TCPP: unit_flags 0x40).
UPDATE `creature_template` SET `unit_flags`=64 WHERE `entry`=17307;
