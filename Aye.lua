local Aye = Aye;

Aye.OnEnable = function()
	-- load modules
	Aye.load = true; -- allow loading modules
	for AddOnID =1, GetNumAddOns() do
		local name, _, _, _, reason = GetAddOnInfo(AddOnID);
		if reason == "DEMAND_LOADED" then
			name = name:match("^Aye%.(.*)");
			if name ~= nil then
				local AddOnDependencies = {GetAddOnDependencies(AddOnID)};
				for DependencyID =1, #AddOnDependencies do
					if AddOnDependencies[DependencyID] == "Aye" then
						Aye.modules[name] = {events = {}};
						
						-- failsafe load module
						if not pcall(LoadAddOn, AddOnID) then
							-- unregister module that failed to load
							Aye.modules[name] = nil;
						end;
					end;
				end;
			end;
		end;
	end;
	Aye.load = nil; -- forbid loading modules
	
	-- add options
	Aye.db = Aye.libs.DB:New("AyeDB", Aye.default, true);
	Aye.libs.Config:RegisterOptionsTable("Aye", Aye.options);
	Aye.frames = {options = Aye.libs.ConfigDialog:AddToBlizOptions("Aye")};
	Aye.frames.options.default = function()
		Aye.db:ResetDB("Default");
		Aye.db = Aye.libs.DB:New("AyeDB", Aye.default, true);
		Aye.libs.ConfigRegistry:NotifyChange("Aye");
	end;
	
	-- register events
	Aye.frames.root = CreateFrame("Frame");
	for _, module in pairs(Aye.modules) do
		if module.events then
			for event in pairs(module.events) do
				Aye.frames.root:RegisterEvent(event);
			end;
		end;
	end;
	
	-- handle events
	Aye.frames.root:SetScript("OnEvent", function(self, event, ...)
		for _, module in pairs(Aye.modules) do
			if module.events then
				for eventName, eventFunction in pairs(module.events) do
					if eventName == event then
						pcall(eventFunction, ...);
					end;
				end;
			end;
		end;
	end);
	
	-- execute modules OnEnable
	for _, module in pairs(Aye.modules) do
		if module.OnEnable then
			pcall(module.OnEnable);
		end;
	end;
end;

-- handle /aye command
SlashCmdList['AYE'] = function(command)
	command = {strsplit(" ", command)};
	local recipient = command[1];
	table.remove(command, 1);
	
	-- execute slash command
	for moduleName, module in pairs(Aye.modules) do
		if
				string.lower(recipient) == string.lower(moduleName)
			and	module.slash
		then
			pcall(module.slash, unpack(command));
		end;
	end;
end;
SLASH_AYE1 = '/aye';

-- does not adds the new module
-- aye! it does really not adds
--
-- @param {moduleName} module name not to add
-- @return {bool} if module was^Wcan be added
Aye.addModule = function(moduleName)
	if Aye.load then
		return true;
	else
		-- module to un… yes! unload
		Aye.unload = moduleName;
		StaticPopup_Show("AYE_INSANITY");
		return false;
	end;
end;