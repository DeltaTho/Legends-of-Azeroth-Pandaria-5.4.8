-- Fuselight-by-the-Sea: Colt Carbine takes in no Vashj'ir quests, the Great Pisani can set a hearthstone (plan items C-14, C-15).
--
-- C-14. Colt Carbine 49920 was the ender of two Vashj'ir quests (25219 Don't be Shellfish, 25748 Clear Goals; QuestSortID 5144
--   Shimmering Expanse, whose own enders are 39875 and 40643) and carried the QUESTGIVER npcflag (4226 = 2 + 128 vendor + 4096
--   repair). A player still carrying either quest got a turn-in "?" over a Badlands goblin. Both TDBs: no quest rows for him and
--   npcflag without bit 2. Vendor and repair stay.
-- C-15. The Great Pisani 49934 (npcflag 65537, gossip + innkeeper; menu 12596 with text 17726) had no option in his menu: this
--   core builds gossip options only from gossip_menu_option, so "make this my home" never appeared. Both TDBs: menu 12596 option 0,
--   innkeeper type, "I'd like to make this my home." (BroadcastText 50234). The first pass used mop's standard innkeeper
--   line (2822) because it believed 50234 absent from mop's broadcast_text; it is there with exactly that text (checked), so the
--   sniffed line is used. Icon 5, type 8 (INNKEEPER) and OptionNpcflag 65536 are mop's innkeeper pattern (menu 1582 option 0).
-- Sourced: both TDBs. Ours: nothing.

DELETE FROM `creature_questender` WHERE `id` = 49920 AND `quest` IN (25219,25748);
UPDATE `creature_template` SET `npcflag` = `npcflag` & ~2 WHERE `entry` = 49920;

DELETE FROM `gossip_menu_option` WHERE `MenuID` = 12596 AND `OptionID` = 0;
INSERT INTO `gossip_menu_option` (`MenuID`,`OptionID`,`OptionIcon`,`OptionText`,`OptionBroadcastTextID`,`OptionType`,`OptionNpcflag`,`ActionMenuID`,`ActionPoiID`,`BoxCoded`,`BoxMoney`,`BoxText`,`BoxBroadcastTextID`,`VerifiedBuild`) VALUES
(12596,0,5,'I''d like to make this my home.',50234,8,65536,0,0,0,0,'',0,0);
