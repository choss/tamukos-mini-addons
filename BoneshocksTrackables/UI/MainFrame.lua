-- BoneshocksTrackables UI - Main Frame
-- Movable container for all modules

local addonName, BT = ...

function BT:InitMainFrame()
	local frame = CreateFrame("Frame", "BoneshocksTrackablesFrame", UIParent)
	frame:SetSize(200, 100)  -- Will auto-resize based on content
	frame:SetMovable(true)
	frame:SetClampedToScreen(false)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	
	-- Background (optional, for visibility during setup)
	frame.bg = frame:CreateTexture(nil, "BACKGROUND")
	frame.bg:SetAllPoints()
	frame.bg:SetColorTexture(0, 0, 0, 0.5)
	frame.bg:Hide()  -- Hidden by default, show when unlocked
	
	-- Drag handlers
	frame:SetScript("OnDragStart", function(self)
		if not BT.db.frame.locked then
			self:StartMoving()
		end
	end)
	
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		-- Save position (top-left corner)
		local point, _, relativePoint, x, y = self:GetPoint()
		BT.db.frame.x = x
		BT.db.frame.y = y
	end)
	
	-- Restore saved position or center
	if BT.db.frame.x and BT.db.frame.y then
		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", BT.db.frame.x, BT.db.frame.y)
	else
		-- Default to Top-Left anchor (visually centered) to ensure downward growth
		frame:SetPoint("TOPLEFT", UIParent, "CENTER", -100, 50)
	end
	
	-- Scale
	frame:SetScale(BT.db.frame.scale or 1.0)
	
	-- Container for rows (bag, money, trackables)
	frame.rows = {}
	
	-- Function to add a row
	function frame:AddRow(rowFrame)
		table.insert(self.rows, rowFrame)
		rowFrame:SetParent(self)
		self:LayoutRows()
	end
	
	-- Layout rows vertically
	function frame:LayoutRows()
		local yOffset = -5
		local maxWidth = 0
		
		for _, row in ipairs(self.rows) do
			if row:IsShown() then
				row:ClearAllPoints()
				row:SetPoint("TOPLEFT", self, "TOPLEFT", 5, yOffset)
				yOffset = yOffset - row:GetHeight() - 2
				maxWidth = math.max(maxWidth, row:GetWidth())
			end
		end
		
		-- Resize frame to fit content
		self:SetSize(maxWidth + 10, math.abs(yOffset) + 5)
	end
	
	-- Lock/unlock toggle (for config panel)
	function frame:ToggleLock()
		BT.db.frame.locked = not BT.db.frame.locked
		if BT.db.frame.locked then
			self.bg:Hide()
		else
			self.bg:Show()
		end
	end
	
	-- LDB data object
	if LibStub then
		local LDB = LibStub:GetLibrary("LibDataBroker-1.1", true)
		if LDB then
			BT.LDBObject = LDB:NewDataObject("BoneshocksTrackables", {
				type = "data source",
				text = "BT",
				icon = "Interface\\Icons\\INV_Misc_Coin_01",
				OnClick = function(self, button)
					if button == "LeftButton" then
						if BoneshocksTrackablesFrame:IsShown() then
							BoneshocksTrackablesFrame:Hide()
						else
							BoneshocksTrackablesFrame:Show()
						end
					elseif button == "RightButton" then
						-- Open config panel
						if BT.ConfigPanel then
							InterfaceOptionsFrame_OpenToCategory(BT.ConfigPanel)
							InterfaceOptionsFrame_OpenToCategory(BT.ConfigPanel)
						end
					end
				end,
				OnTooltipShow = function(tooltip)
					tooltip:AddLine("Boneshock's Trackables")
					tooltip:AddLine("|cffaaaaaa Click to toggle frame|r")
					tooltip:AddLine("|cffaaaaaa Right-click for options|r")
				end,
			})
		end
	end
	
	BT.MainFrame = frame
	frame:Show()
end
