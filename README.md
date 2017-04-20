# Aye
## All your exigents

Aye is a light WOW modular Addon that provides *all your exigents*, with a little help of [Ace3](https://www.wowace.com/addons/ace3/) libs.
Depot for many dependent addons *aka modules*, allows them to be written and run fast, easily and safely.

This addon is required for any `Aye.` modules, just install it, it does not makes anything by itself.
Info for addon developers (if you are not addon developer, you can skip rest):

## Writting a new module

- Name it beginning with `Aye.`, ex. `Aye.example`
- Make 4 basic files and place them directly in the addon named folder:
    - TOC: Module name with `.toc` on end, ex. `Aye.example.toc`
    - Core: Module name with `.lua` on end, ex. `Aye.example.lua`
    - Options: Module name with `.options.lua` on end, ex. `Aye.options.lua`
    - Default Options: Module name with `.options.default.lua` on end, ex.  `Aye.example.options.default.lua`
- Optional: Add `/libs` folder and attach libraries for this one, specified addon
- Optional: Add `/utils` folder and add utility functions inside
### TOC: `Aye.example.toc`
```
## Title: Aye.example
## Notes: Example
## Depot: Aye
## LoadOnDemand: 1
## Author: YOURNAME
## Version: ADDONVERSION
## Interface: INTERFACEVERSION

#libs
## Optional: list of addon specific libraries
## for clarity, place them in "libs/"
##
## @example
##| libs/AceFoo-6.38\AceFoo-6.38.xml
##| libs/Bar/Bar.lua

#utils
## Optional: list of utilities
## for clarity, place them in "utils/"
##
## @example
##| utils/Foo.lua

#files
Aye.example.lua
Aye.example.options.lua
Aye.example.options.default.lua
## Optional: additional files
##
## @example
##| Aye.example.Foo.lua
```
Important notes:

- Name your addon beginning with `Aye.`
- Mark Aye as module's depot with `## Depot: Aye`
- Add addon as LOD with `## LoadOnDemand: 1`
- Don't load module by other addon or manually, only Aye should load it's module while running.

### Core: `Aye.example.lua`
Begin your addon with:
```lua
local Aye = Aye;
if not Aye.addModule("Aye.example") then return end;
```
Where `example` is your addon name. `local Aye` to cache it and `Aye.addModule` to handle user *Insanity*. In short: Don't let user to enable this module manually to avoid unexpected user–caused lua errors. Defend user from himself and reduce amount of unecessary tickets. Because nobody likes tickets!

#### OnEnable

Optional: Add `Aye.modules.example.OnEnable`
Module's `OnEnable` is fired once when module is loaded by Aye itself.
Put here all preparation operations, like adding new objects, initializing the Azeroth Defend–o–Bot 6000C™ etc.
Example:
```lua
Aye.modules.example.OnEnable = function()
	-- register addon messages
	RegisterAddonMessagePrefix("Aye");	-- Aye
	RegisterAddonMessagePrefix("D4");	-- DBM
	
	-- list of all Naughty Childrens
	Aye.modules.example.naughtyChildrens = {};
end;
```

#### events
Optional: `Aye.modules.example.events`
Aye registers and handles all events existing in it's modules to futher fire `.events` events in it's modules.
This means, you don't need to register your events, nor make any other frustrating code to handle it, just add `Aye.modules.example.events.EVENT_NAME` function, where `EVENT_NAME` is the name of event to handle. Vuala! Example:
```lua
Aye.modules.example.events.ACHIEVEMENT_EARNED = function()
	-- Achievement Earned
	DoEmote("happy");
end;
```

#### commands
Optional: `Aye.modules.example.slash`
Command: `/aye module [...]`. `module` is case–insensitive recipient module name. After `module` there can be passed space and any number of space separated arguments. Aye detects command module recipient and sends to it command optional arguments. Example:
```
/aye example Echo! yell
```
This command will send `Echo!` and `yell` as optional arguments to `example` module.
To handle this command, `example` module should use the `Aye.modules.example.slash` command. Example:
```lua
Aye.modules.example.slash = function(message, channel)
	SendChatMessage(message, channel);
end;
```
This example will cause to yell `Echo!`.

#### additional info
Avoid tainting globals.
Avoid tainting global `Aye` and any of it's childrens, until explictly allowed *(see below)*.
Aye taints:

- Global: `Aye` — Aye Addon object
- Global: `StaticPopupDialogs["AYE_INSANITY"]` — *Insanity* Popup object
- Global: `SlashCmdList['AYE']` — Aye command object
    - Global: `SLASH_AYE1` — Aye command word

Aye's structure (beside Ace) where `example` is your `Aye.` module name:

- `Aye.libs` — libraries. Aye uses the following [Ace3](https://www.wowace.com/addons/ace3/) libraries:
    - [`AceAddon`](https://www.wowace.com/addons/ace3/pages/api/ace-addon-3-0/)
    - [`AceConfig`](https://www.wowace.com/addons/ace3/pages/api/ace-config-3-0/) as `Aye.libs.Config`
        - [`AceConfigDialog`](https://www.wowace.com/addons/ace3/pages/api/ace-config-dialog-3-0/) as `Aye.libs.ConfigDialog`
        - [`AceConfigRegistry`](https://www.wowace.com/addons/ace3/pages/api/ace-config-registry-3-0/) as `Aye.libs.ConfigRegistry`
		- [`AceConfigCmd`](https://www.wowace.com/projects/ace3/pages/api/ace-config-cmd-3-0/) as dependency library
    - [`AceDB`](https://www.wowace.com/addons/ace3/pages/api/ace-db-3-0/) as `Aye.libs.DB`
	- [`AceGUI`](https://www.wowace.com/projects/ace3/pages/ace-gui-3-0-widgets/) as dependency library
	
	Additionally, Aye uses the following non–Ace dependency libraries:
	- [`LibStub`](https://www.wowace.com/projects/libstub)
	- [`CallbackHandler`](https://www.wowace.com/projects/callbackhandler)
- `Aye.utils` — utilities
- `Aye.modules` — modules. You are allowed, and thus, you should, for clarity, use `Aye.modules.example` object for your module data. If you need to init more subobjects, `.OnEnable` function is a right place for it.
- `Aye.options` — Aye options object. You are allowed, and should use `Aye.options.example` object to put options of your module to in `Aye.options.lua` file *(see below)*.
    - `Aye.default.global` — Aye default options. You are allowed, and should use `Aye.default.global.example` object to put default options of your module to in `Aye.options.default.lua` file *(see below)*.
- `Aye.OnEnable` — function used when Aye get's enabled
    - `Aye.load` — *Insanity* helper variable that determines if modules can be loaded
- `Aye.addModule` — *Insanity* function that should be called by every module *(see above*)
- `Aye.db` — Aye database, used by [`AceDB`](https://www.wowace.com/addons/ace3/pages/api/ace-db-3-0/) to store modules options as `AyeDB`.
- `Aye.frames` — Aye frames:
    - `Aye.frames.options` — options frame
        - `Aye.frames.options.default` — default options frame
    - `Aye.frames.root` — root frame to handle events and propagate them to modules
- `Aye.assert` — *Debug* function, non–interrupting assert of Aye `pcall`ed executions
- `Aye.error` — *Debug* function, reporting last error
	- `Aye.error` — *Debug* container, list of errors to report

### Options: `Aye.example.options.lua`
Begin your options file with:
```lua
local Aye = Aye;
if not Aye.load then return end;
```
`local Aye` to cache it and `Aye.load` check to handle user *Insanity* *(see above)*.
Then, add options object to `Aye.options.args.example` where `example` is your module name.
Options object should follow the [`AceOptions` table format](https://www.wowace.com/addons/ace3/pages/ace-config-3-0-options-tables/) beginning with:
```lua
name = "EXAMPLE_NAME",
type = "group",
```
where `EXAMPLE_NAME` is module name displayed in options, example:
```lua
Aye.options.args.example = {
	name = "Example addon",
	type = "group",
	args = {
		header1 = {
			order = 1,
			type = "header",
			name = "Example options",
		},
		description2 = {
			order = 2,
			type = "description",
			name = "|cffe6cc80Example|r options description.\n",
		},
		enable = {
			order = 3,
			name = "Enable",
			desc = "Enable Options",
			type = "toggle",
			get = function() return Aye.db.global.example.enable end,
			set = function(_, v) Aye.db.global.example.enable = v end,
		},
	},
};
```
Note that options should be saved in `Aye.db.global.example` db object, where `example` is module name.

### Default Options: `Aye.example.options.default.lua`
Begin your default options file with:
```lua
local Aye = Aye;
if not Aye.load then return end;
```
`local Aye` to cache it and `Aye.load` check to handle user *Insanity* *(see above)*.
Then, add default options object to `Aye.default.global.example` where `example` is your module name. Example:
```lua
Aye.default.global.example = {
	enable = true, -- Enable Options
}
```

In order to access options from GUI, open Game Memu → Interface → Addons tab → Aye → *your addon name*.

## Writting a new utility
Begin your utility file with:
```lua
local Aye = Aye;
if not LibStub:NewLibrary("Aye.utils.example", VERSION) then return end;
Aye.utils.example = Aye.utils.example or {};
```
`local Aye` to cache it. [`LibStub`](https://www.wowace.com/projects/libstub) provides usage of newest util version, we just need to pass `VERSION` as integer number. Third line allows loading deprecated functions from older library versions, to maintain backward compatibility, if needed.
Then, add util functions to `Aye.utils.example` where `example` is your util name. Example:
```lua
-- @noparam
-- @return {bool} IsMale if player is Male
Aye.utils.example.IsMale = function()
	return UnitSex("player") == 2;
end;
```
Utilities should:

- contain only functions or variables and work independent of any addons or modules.
- not taint any variables excepts dedicated `Aye.utils.example` object where `example` is util's name.
- be used when they can be used by many modules, but still, should be included by every module, independent.

Aye utilities are indented to work same for it's modules like libraries for their addons.

## Credits
Special thanks to:

- [Ace3](https://www.wowace.com/addons/ace3/) authors
- Vlad#WoWUIDev
- Torhal#WoWUIDev
- nebula#WoWUIDev

…and the rest of #WoWUIDev community.

## Licence
### [CC BY 4](https://creativecommons.org/licenses/by/4.0/)
You are free to:

- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material for any purpose, even commercially.
- The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
- No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.