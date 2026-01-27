-- BoneshocksTrackables UI - Money Module
-- Display player money with optional icons and abbreviation

local addonName, BT = ...

function BT:InitMoney()
	local row = CreateFrame("Frame", nil, BT.MainFrame)
	row:SetSize(150, 16)
	
	local text = row:CreateFontString(nil, "OVERLAY")
	text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	text:SetPoint("LEFT")
	text:SetJustifyH("LEFT")
	row.text = text
	
	-- Coin textures
	local goldIcon = "|TInterface\\MoneyFrame\\UI-GoldIcon:14:14:2:0|t"
	local silverIcon = "|TInterface\\MoneyFrame\\UI-SilverIcon:14:14:2:0|t"
	local copperIcon = "|TInterface\\MoneyFrame\\UI-CopperIcon:14:14:2:0|t"
	
	-- Update function
	local function Update()
		local totalCopper = GetMoney()
		local gold = math.floor(totalCopper / 10000)
		local silver = math.floor((totalCopper % 10000) / 100)
		local copper = totalCopper % 100
		
		local cfg = BT.db.modules.money
		local parts = {}
		
		-- Gold
		if cfg.showGold and gold > 0 then
			local goldStr = BT.AbbreviateAmount(gold, cfg.abbreviateMode)
			if cfg.showTextures then
				table.insert(parts, goldStr .. goldIcon)
			else
				table.insert(parts, goldStr .. "g")
			end
		end
		
		-- Silver
		if cfg.showSilver and (silver > 0 or (gold == 0 and copper == 0)) then
			if cfg.showTextures then
				table.insert(parts, silver .. silverIcon)
			else
				table.insert(parts, silver .. "s")
			end
		end
		
		-- Copper
		if cfg.showCopper and (copper > 0 or (gold == 0 and silver == 0)) then
			if cfg.showTextures then
				table.insert(parts, copper .. copperIcon)
			else
				table.insert(parts, copper .. "c")
			end
		end
		
		local displayText = "Money: " .. table.concat(parts, " ")
		text:SetText(displayText)
		
		-- Resize row to fit text
		row:SetWidth(text:GetStringWidth() + 5)
	end
	
	-- Events
	row:RegisterEvent("PLAYER_MONEY")
	row:RegisterEvent("PLAYER_ENTERING_WORLD")
	row:SetScript("OnEvent", Update)
	
	-- Initial update
	Update()
	
	-- Add to main frame
	BT.MainFrame:AddRow(row)
	BT.MoneyRow = row
	
	-- Show/hide based on enabled state
	if BT.db.modules.money.enabled then
		row:Show()
	else
		row:Hide()
	end
end
