-- Blasted Lands, The Amulet of Sevine (25698 H / 26168 A): Salt-Flop 41265 offers "Murloc, I know that you hold the Amulet of
-- Sevine. I need it." only while the amulet is still needed.
-- Sourced: the option and the gift (wiki notes; comment 740590 [+6]; mop menu 11479 option 0 and SmartAI 41265 id 0).
-- Ours: the state mask. With "quest taken" (type 9) the option stayed once the amulet was held (the quest is then complete), and
-- each click gave another one. Section D owns this option's conditions only; Salt-Flop's other rows are section E's.
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId`=15 AND `SourceGroup`=11479 AND `SourceEntry`=0 AND `ConditionValue1` IN (25698,26168);
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,
 `ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(15,11479,0,0,0,47,0,25698,8,0,0,0,0,'','Salt-Flop - Amulet of Sevine option while The Amulet of Sevine (H) is incomplete'),
(15,11479,0,0,1,47,0,26168,8,0,0,0,0,'','Salt-Flop - Amulet of Sevine option while The Amulet of Sevine (A) is incomplete');
