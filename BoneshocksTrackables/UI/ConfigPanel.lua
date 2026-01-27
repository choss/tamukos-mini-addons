-- BoneshocksTrackables UI - Config Panel
-- Clean config panel for Midnight

local addonName, BT = ...

function BT:CreateConfigPanel()
	-- Wait for DB to be initialized
	if not BT.db then
		C_Timer.After(0.1, function() BT:CreateConfigPanel() end)
		return
	end
	
	local category, layout = Settings.RegisterVerticalLayoutCategory("Boneshock's Trackables")
	
	-- Title with instructions
	local titleText = "Boneshock's Trackables\n\nUse /btmanage to show/hide individual currencies"
	
	-- Frame Lock
	do
		local variable = "BoneshocksTrackables_FrameLock"
		local name = "Lock frame position"
		local tooltip = "Prevent the frame from being moved"
		local defaultValue = false
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.frame.locked end,
			function(value)
				BT.db.frame.locked = value
				if BT.MainFrame then
					if value then
						BT.MainFrame.bg:Hide()
					else
						BT.MainFrame.bg:Show()
					end
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Bag Space Module
	do
		local variable = "BoneshocksTrackables_BagSpace"
		local name = "Show free bag slots"
		local tooltip = "Display available bag space"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.bagSpace.enabled end,
			function(value)
				BT.db.modules.bagSpace.enabled = value
				if BT.BagSpaceRow then
					if value then
						BT.BagSpaceRow:Show()
					else
						BT.BagSpaceRow:Hide()
					end
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Money Module
	do
		local variable = "BoneshocksTrackables_Money"
		local name = "Show player money"
		local tooltip = "Display gold, silver, and copper"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.money.enabled end,
			function(value)
				BT.db.modules.money.enabled = value
				if BT.MoneyRow then
					if value then
						BT.MoneyRow:Show()
					else
						BT.MoneyRow:Hide()
					end
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Money Textures
	do
		local variable = "BoneshocksTrackables_MoneyTextures"
		local name = "  Show coin icons"
		local tooltip = "Display coin textures next to values"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.money.showTextures end,
			function(value)
				BT.db.modules.money.showTextures = value
				if BT.MoneyRow then
					BT.MoneyRow:GetScript("OnEvent")(BT.MoneyRow, "PLAYER_MONEY")
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Trackables Module
	do
		local variable = "BoneshocksTrackables_Trackables"
		local name = "Show zone-based currencies and items"
		local tooltip = "Display currencies and items based on current zone"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.trackables.enabled end,
			function(value)
				BT.db.modules.trackables.enabled = value
				if BT.TrackablesContainer then
					if value then
						BT.TrackablesContainer:Show()
						BT.TrackablesContainer:GetScript("OnEvent")(BT.TrackablesContainer, "ZONE_CHANGED")
					else
						BT.TrackablesContainer:Hide()
					end
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Trackables Color
	do
		local variable = "BoneshocksTrackables_TrackablesColor"
		local name = "  Color item/currency names by quality"
		local tooltip = "Use quality colors for trackable names"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.trackables.colorName end,
			function(value)
				BT.db.modules.trackables.colorName = value
				if BT.TrackablesContainer then
					BT.TrackablesContainer:GetScript("OnEvent")(BT.TrackablesContainer, "CURRENCY_DISPLAY_UPDATE")
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Show Amount
	do
		local variable = "BoneshocksTrackables_ShowAmount"
		local name = "  Show currency/item amounts"
		local tooltip = "Display the quantity of each currency/item"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.trackables.showAmount end,
			function(value)
				BT.db.modules.trackables.showAmount = value
				if BT.TrackablesContainer then
					BT.TrackablesContainer:GetScript("OnEvent")(BT.TrackablesContainer, "CURRENCY_DISPLAY_UPDATE")
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Show Name
	do
		local variable = "BoneshocksTrackables_ShowName"
		local name = "  Show currency/item names"
		local tooltip = "Display the name of each currency/item"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.trackables.showName end,
			function(value)
				BT.db.modules.trackables.showName = value
				if BT.TrackablesContainer then
					BT.TrackablesContainer:GetScript("OnEvent")(BT.TrackablesContainer, "CURRENCY_DISPLAY_UPDATE")
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Color Amount
	do
		local variable = "BoneshocksTrackables_ColorAmount"
		local name = "  Color amounts by quality"
		local tooltip = "Use quality colors for currency/item amounts"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.trackables.colorAmount end,
			function(value)
				BT.db.modules.trackables.colorAmount = value
				if BT.TrackablesContainer then
					BT.TrackablesContainer:GetScript("OnEvent")(BT.TrackablesContainer, "CURRENCY_DISPLAY_UPDATE")
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- === EXPANSION FILTERS ===
	-- Add a header for expansions
	layout:AddInitializer(CreateSettingsListSectionHeaderInitializer("Expansions"))
	
	-- Modern Expansions
	local modernExpansions = {
		{id = 10, name = "The War Within"},
		{id = 9, name = "Dragonflight"},
		{id = 8, name = "Shadowlands"},
		{id = 7, name = "Battle for Azeroth"},
		{id = 6, name = "Legion"},
	}
	
	for _, exp in ipairs(modernExpansions) do
		local variable = "BoneshocksTrackables_Expansion_" .. exp.id
		local name = exp.name
		local tooltip = "Show " .. exp.name .. " currencies and items"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.trackables.expansions[exp.id] end,
			function(value)
				BT.db.modules.trackables.expansions[exp.id] = value
				if BT.TrackablesContainer then
					BT.TrackablesContainer:GetScript("OnEvent")(BT.TrackablesContainer, "ZONE_CHANGED")
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	-- Classic Expansions
	local classicExpansions = {
		{id = 5, name = "Warlords of Draenor"},
		{id = 4, name = "Mists of Pandaria"},
		{id = 3, name = "Cataclysm"},
		{id = 2, name = "Wrath of the Lich King"},
		{id = 1, name = "The Burning Crusade"},
		{id = 0, name = "Classic"},
		{id = -1, name = "Other"},
	}
	
	for _, exp in ipairs(classicExpansions) do
		local variable = "BoneshocksTrackables_Expansion_" .. exp.id
		local name = "  " .. exp.name
		local tooltip = "Show " .. exp.name .. " currencies and items"
		local defaultValue = true
		
		local setting = Settings.RegisterProxySetting(category, variable, Settings.VarType.Boolean, name, defaultValue,
			function() return BT.db.modules.trackables.expansions[exp.id] end,
			function(value)
				BT.db.modules.trackables.expansions[exp.id] = value
				if BT.TrackablesContainer then
					BT.TrackablesContainer:GetScript("OnEvent")(BT.TrackablesContainer, "ZONE_CHANGED")
				end
			end)
		Settings.CreateCheckbox(category, setting, tooltip)
	end
	
	Settings.RegisterAddOnCategory(category)
	BT.SettingsCategory = category
	
	print("|cff00ff00Boneshock's Trackables config panel loaded!|r")
end

-- Slash command
SLASH_BONESHOCKTRACKABLES1 = "/bt"
SLASH_BONESHOCKTRACKABLES2 = "/boneshock"
SlashCmdList["BONESHOCKTRACKABLES"] = function(msg)
	if BT.SettingsCategory then
		Settings.OpenToCategory(BT.SettingsCategory:GetID())
	else
		print("|cffff0000Boneshock's Trackables config panel not loaded yet. Please /reload and try again.|r")
	end
end

-- Slash command for trackables manager
SLASH_BTMANAGE1 = "/btmanage"
SlashCmdList["BTMANAGE"] = function(msg)
	if not BT.TrackablesManagerFrame then
		BT.TrackablesManagerFrame = BT:CreateTrackablesManager(UIParent)
		BT.TrackablesManagerFrame:SetPoint("CENTER")
		BT.TrackablesManagerFrame:SetFrameStrata("DIALOG")
		
		-- Add background
		local bg = BT.TrackablesManagerFrame:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints()
		bg:SetColorTexture(0.05, 0.05, 0.05, 0.95)
		
		-- Add close button
		local close = CreateFrame("Button", nil, BT.TrackablesManagerFrame, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", -5, -5)
		
		-- Make draggable
		BT.TrackablesManagerFrame:SetMovable(true)
		BT.TrackablesManagerFrame:EnableMouse(true)
		BT.TrackablesManagerFrame:RegisterForDrag("LeftButton")
		BT.TrackablesManagerFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
		BT.TrackablesManagerFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	end
	BT.TrackablesManagerFrame:Show()
	print("|cff00ff00Showing trackables manager. Search and check/uncheck currencies to show/hide them.|r")
end
