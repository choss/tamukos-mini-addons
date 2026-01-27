-- BoneshocksTrackables Config
-- SavedVariables schema and defaults

local addonName, BT = ...

-- Defaults for SavedVariables
BT.defaults = {
	frame = {
		x = nil,  -- Auto-center if not set
		y = nil,
		scale = 1.0,
		locked = false,
	},
	modules = {
		bagSpace = {
			enabled = true,
			showTotal = true,  -- Show "X/Y" vs just "X"
			warningThreshold = 10,  -- Red warning when free slots <= this
		},
		money = {
			enabled = true,
			showGold = true,
			showSilver = true,
			showCopper = true,
			showTextures = true,  -- Coin icons
			abbreviateMode = 0,  -- 0=none, 1=short (1K), 2=large (1.2K)
		},
		trackables = {
			enabled = true,
			expansions = {
				[10] = true,  -- War Within
				[9] = true,   -- Dragonflight
				[8] = true,   -- Shadowlands
				[7] = true,   -- BFA
				[6] = true,   -- Legion
				[5] = true,   -- WoD
				[4] = true,   -- MoP
				[3] = true,   -- Cata
				[2] = true,   -- WotLK
				[1] = true,   -- TBC
				[0] = true,   -- Classic
				[-1] = true,  -- Other
			},
			showAmount = true,
			showName = true,
			showExtra = true,  -- Extra info like "+100" anima in bags
			colorAmount = true,
			colorName = true,
			mergeExtraInfo = false,  -- Merge extra into amount number
		},
	},
	customTrackables = {},  -- User-added trackables
	hiddenTrackables = {},  -- User-hidden trackables by ID: {[currencyID] = true, ...}
}

-- Initialize SavedVariables
function BT:InitDB()
	if not BoneshocksTrackablesDB then
		BoneshocksTrackablesDB = {}
	end
	
	self.db = BoneshocksTrackablesDB
	
	-- Deep copy defaults for missing keys
	local function ApplyDefaults(target, defaults)
		for k, v in pairs(defaults) do
			if target[k] == nil then
				if type(v) == "table" then
					target[k] = {}
					ApplyDefaults(target[k], v)
				else
					target[k] = v
				end
			elseif type(v) == "table" and type(target[k]) == "table" then
				ApplyDefaults(target[k], v)
			end
		end
	end
	
	ApplyDefaults(self.db, self.defaults)
end
