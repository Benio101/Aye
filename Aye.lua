local Aye = Aye;

Aye.OnEnable = function()
	-- allow loading modules
	Aye.load = true;
	
	-- load modules
	for AddOnID =1, GetNumAddOns() do
		local name, _, _, _, reason = GetAddOnInfo(AddOnID);
		
		if reason == "DEMAND_LOADED" then
			name = name:match("^Aye%.(.*)");
			
			if name then
				local AddOnDependencies = {GetAddOnDependencies(AddOnID)};
				
				for DependencyID =1, #AddOnDependencies do
					if AddOnDependencies[DependencyID] == "Aye" then
						Aye.modules[name] = {events = {}};
						
						-- failsafe load module
						if not Aye.assert(pcall(LoadAddOn, AddOnID)) then
							-- unregister module that failed to load
							Aye.modules[name] = nil;
						end;
					end;
				end;
			end;
		end;
	end;
	
	-- forbid loading modules
	Aye.load = nil;
	
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
						Aye.assert(pcall(eventFunction, ...));
					end;
				end;
			end;
		end;
	end);
	
	-- execute modules OnEnable
	for _, module in pairs(Aye.modules) do
		if module.OnEnable then
			Aye.assert(pcall(module.OnEnable));
		end;
	end;
end;

-- handle /aye command
SlashCmdList['AYE'] = function(command)
	command = {strsplit(" ", command)};
	local recipient = table.remove(command, 1);
	
	-- execute slash command
	for moduleName, module in pairs(Aye.modules) do
		if
				string.lower(recipient) == string.lower(moduleName)
			and	module.slash
		then
			Aye.assert(pcall(module.slash, unpack(command)));
		end;
	end;
end;
SLASH_AYE1 = '/aye';

-- does not adds the new module
-- aye! it does really not adds
--
-- @param {string} moduleName module name not to add
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

-- non–interrupting assert of pcalled executions
-- thanks for inspiration to nevcairiel and Vlad
--
-- @param {bool} status pcall returned status
-- @param message pcall returned status message
-- @return {bool} status pcall returned status
Aye.assert = function(status, message)
	if not status then
		table.insert(Aye.errors, message);
		C_Timer.After(0, Aye.error);
	end;
	
	return status;
end;

-- report last error
--
-- @noparam
-- @noreturn
Aye.error = function()
	local message = table.remove(Aye.errors, 1);
	
	if #Aye.errors >0 then
		C_Timer.After(0, Aye.error);
	end;
	
	error(message);
end;