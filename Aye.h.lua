Aye = LibStub("AceAddon-3.0"):NewAddon("Aye");
local Aye = Aye;

-- libs
-- external /libs as Aye.libs objects
Aye.libs = {};
Aye.libs.Config = LibStub("AceConfig-3.0");
Aye.libs.ConfigDialog = LibStub("AceConfigDialog-3.0");
Aye.libs.ConfigRegistry = LibStub("AceConfigRegistry-3.0");
Aye.libs.DB = LibStub("AceDB-3.0");

-- utils
-- /utils as Aye.utils functions
Aye.utils = {};

-- modules
-- /modules as Aye.modules.MODULE_NAME objects with optional .events
Aye.modules = {};

-- options
-- Aye.default.global.MODULE_NAME
-- Aye.options.args.MODULE_NAME
Aye.default = {global = {}};
Aye.options = {
	name = "All your exigents",
	type = "group",
	args = {},
};

-- popup to show for insane players
-- credits for idea to Torhal#WoWUIDev. Thanks!
StaticPopupDialogs["AYE_INSANITY"] = {
	text =
			"|cffe6cc80Aye!|r You are manually loading things that are disabled without first loading their dependencies. |cffff4040You are insane!|r\n\n"
		..	"|cff9d9d9dYour insanity could have lured some bugs to the addon.|r What do you wish to do with your insanely loaded addon?"
	,
	button1 = "Keep Enabled & Reload",
	button2 = "Disable & Reload",
	OnAccept = function() ReloadUI() end,
	OnCancel = function() DisableAddOn(Aye.unload); ReloadUI() end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = false,
	preferredIndex = 3,
};