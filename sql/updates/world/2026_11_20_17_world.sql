-- The Wrath of a Dragonflight arc: the three field quests complete from the quest log, as Rhea's telepathic hand-ins.
--
-- The Wrath of a Dragonflight 27829 / 27894, Their Hunt Continues 27830 / 27895, The Sorrow and the Fury 27831 / 27896 lacked
-- the log turn-in, so each needed a walk back to Rhea at her camp, 1,400 yd away. Sourced: both TDBs Flags 589824 (AUTO_ACCEPT
-- 0x80000 | AUTO_COMPLETE 0x10000); wiki "The quest completes automatically", "completes automatically on the general's death";
-- Gymlea's comment on 27830 (an auto-completion box opens and offers the next quest); PortraitGiver / PortraitTurnIn
-- Rheastrasza. With AUTO_COMPLETE the reward needs no giver and the next quest (RewardNextQuest, all AUTO_ACCEPT) is added
-- from the log (Badlands ruling R7). Rhea stays an ender of the six.
-- Bots: each bot holding the quest completes it on the shared kills and gets its own pop-up; none of the six can be shared.

UPDATE `quest_template` SET `Flags` = 589824 WHERE `ID` IN (27829, 27830, 27831, 27894, 27895, 27896);
