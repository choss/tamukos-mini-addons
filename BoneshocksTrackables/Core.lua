-- BoneshocksTrackables Core
-- Main addon initialization and helper functions

local addonName, BT = ...

-- Helper: Convert indexed table to set (keys with value=true)
function BT.Set(list)
	local set = {}
	for _, v in ipairs(list) do
		set[v] = true
	end
	return set
end

-- Operator functions for warnings/value checks
BT.operators = {
	["=="] = function(a, b) return a == b end,
	[1] = function(a, b) return a == b end,
	["~="] = function(a, b) return a ~= b end,
	[2] = function(a, b) return a ~= b end,
	[">"] = function(a, b) return a > b end,
	[3] = function(a, b) return a > b end,
	["<"] = function(a, b) return a < b end,
	[4] = function(a, b) return a < b end,
	[">="] = function(a, b) return a >= b end,
	[5] = function(a, b) return a >= b end,
	["<="] = function(a, b) return a <= b end,
	[6] = function(a, b) return a <= b end,
}

-- Check if value meets operator condition
function BT.CheckValue(value, triggerValue, operator)
	if not value or not triggerValue or not operator then return end
	return BT.operators[operator](value, triggerValue)
end

-- Abbreviate numbers (short: 1K, large: 1.2K)
function BT.AbbreviateAmount(amount, mode)
	if mode == 1 then
		return AbbreviateNumbers(amount)
	elseif mode == 2 then
		return AbbreviateLargeNumbers(amount)
	else
		return tostring(amount)
	end
end

-- Initialize trackables data: convert arrays to sets, set defaults
function BT:ProcessTrackables()
	local all = {}
	BT.currencies = {}
	BT.items = {}
	
	for expansion, list in pairs(self.trackables) do
		for _, trackable in ipairs(list) do
			-- Convert indexed arrays to sets for fast lookup
			if trackable.uiMapIDs then
				trackable.uiMapIDs = self.Set(trackable.uiMapIDs)
			end
			if trackable.excludeMapIDs then
				trackable.excludeMapIDs = self.Set(trackable.excludeMapIDs)
			end
			if trackable.parentMapIDs then
				trackable.parentMapIDs = self.Set(trackable.parentMapIDs)
			end
			if trackable.areaMapIDs then
				trackable.areaMapIDs = self.Set(trackable.areaMapIDs)
			end
			
			-- Set defaults
			if not trackable.expansion then
				trackable.expansion = expansion
			end
			if not trackable.priority then
				trackable.priority = 999
			end
			if not trackable.warnings then
				trackable.warnings = {}
			end
			
			-- Add to master lists
			table.insert(all, trackable)
			if trackable.type == "currency" then
				BT.currencies[trackable.id] = trackable
			elseif trackable.type == "item" then
				BT.items[trackable.id] = trackable
			end
		end
	end
	
	self.allTrackables = all
end

-- Event frame
local EventFrame = CreateFrame("Frame")
BT.EventFrame = EventFrame

EventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" and ... == addonName then
		BT:InitDB()
		BT:ProcessTrackables()
		-- Initialize UI modules (will be implemented in UI files)
		if BT.InitMainFrame then
			BT:InitMainFrame()
		end
		if BT.InitBagSpace then
			BT:InitBagSpace()
		end
		if BT.InitMoney then
			BT:InitMoney()
		end
		if BT.InitTrackables then
			BT:InitTrackables()
		end
		
		-- Create config panel after a short delay
		C_Timer.After(0.1, function()
			if BT.CreateConfigPanel then
				BT:CreateConfigPanel()
			end
		end)
	elseif event == "PLAYER_LOGOUT" then
		-- SavedVariables are automatically saved
	end
end)

EventFrame:RegisterEvent("ADDON_LOADED")
EventFrame:RegisterEvent("PLAYER_LOGOUT")
