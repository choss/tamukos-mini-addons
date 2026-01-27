-- BoneshocksTrackables UI - Bag Space Module
-- Display free/total bag slots with warning color

local addonName, BT = ...

function BT:InitBagSpace()
	if not self.db.modules.bagSpace.enabled then return end
	
	local row = CreateFrame("Frame", nil, BT.MainFrame)
	row:SetSize(150, 16)
	
	local text = row:CreateFontString(nil, "OVERLAY")
	text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	text:SetPoint("LEFT")
	text:SetJustifyH("LEFT")
	row.text = text
	
	-- Update function
	local function Update()
		local free, total = 0, 0
		for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			local slots = C_Container.GetContainerNumSlots(i)
			local freeSlots = C_Container.GetContainerNumFreeSlots(i)
			total = total + slots
			free = free + freeSlots
		end
		
		local cfg = BT.db.modules.bagSpace
		local displayText
		if cfg.showTotal then
			displayText = string.format("Bags: %d/%d", free, total)
		else
			displayText = string.format("Bags: %d", free)
		end
		
		-- Warning color if low
		if free <= cfg.warningThreshold then
			text:SetText("|cffff0000" .. displayText .. "|r")
		else
			text:SetText("|cffffffff" .. displayText .. "|r")
		end
		
		-- Resize row to fit text
		row:SetWidth(text:GetStringWidth() + 5)
	end
	
	-- Events
	row:RegisterEvent("BAG_UPDATE")
	row:RegisterEvent("PLAYER_ENTERING_WORLD")
	row:SetScript("OnEvent", Update)
	
	-- Initial update
	Update()
	
	-- Add to main frame
	BT.MainFrame:AddRow(row)
	BT.BagSpaceRow = row
end
