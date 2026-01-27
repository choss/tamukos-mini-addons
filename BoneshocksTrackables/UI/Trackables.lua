-- BoneshocksTrackables UI - Trackables Module
-- Display zone-aware currencies and items

local addonName, BT = ...

function BT:InitTrackables()
	if not self.db.modules.trackables.enabled then return end
	
	-- Container for trackable rows
	local container = CreateFrame("Frame", nil, BT.MainFrame)
	container:SetSize(200, 16)  -- Will resize based on content
	container.rows = {}
	
	-- Function to get active trackables based on current zone
	local function GetActiveTrackables()
		local zoneText = GetZoneText():gsub("%s+", ""):lower()
		local minimapText = GetMinimapZoneText():gsub("%s+", ""):lower()
		local mapID = C_Map.GetBestMapForUnit("player")
		local faction = UnitFactionGroup("player"):lower()
		
		local active = {}
		
		for _, trackable in ipairs(BT.allTrackables) do
			local show = false
			
			-- Check if user has explicitly hidden this trackable
			local trackableKey = trackable.type .. ":" .. trackable.id
			local userHidden = BT.db.hiddenTrackables and BT.db.hiddenTrackables[trackableKey]
			
			-- Skip if hidden: user preference overrides default hide setting
			local isHidden = false
			if userHidden ~= nil then
				isHidden = userHidden
			else
				isHidden = trackable.hide or false
			end
			
			if isHidden then
				-- Skip this trackable entirely
			-- Check if expansion is enabled
			elseif BT.db.modules.trackables.expansions[trackable.expansion] then
				-- Always show
				if trackable.always then
					show = true
				-- Faction check
				elseif not trackable.faction or trackable.faction == "both" or trackable.faction == faction then
					-- Zone matching
					local zoneMatch = false
					
					-- Direct uiMapID match
					if trackable.uiMapIDs and trackable.uiMapIDs[mapID] then
						zoneMatch = true
					end
					
					-- Zone text match
					if trackable.zones then
						local zones = trackable.zones:gsub("%s+", ""):lower()
						if zones:find(zoneText, 1, true) or zones:find(minimapText, 1, true) then
							zoneMatch = true
						end
					end
					
					-- Area match
					if trackable.areaMapIDs then
						for areaID in pairs(trackable.areaMapIDs) do
							local areaName = C_Map.GetAreaInfo(areaID)
							if areaName then
								local area = areaName:gsub("%s+", ""):lower()
								if area == zoneText or area == minimapText then
									zoneMatch = true
									break
								end
							end
						end
					end
					
					-- Parent map match (includes children)
					if trackable.parentMapIDs then
						for parentID in pairs(trackable.parentMapIDs) do
							local recurse = false
							if type(parentID) == "string" and parentID:sub(1,1) == "r" then
								recurse = true
								parentID = tonumber(parentID:sub(2))
							end
							
							if parentID == mapID then
								zoneMatch = true
								break
							end
							
							-- Check children
							local children = C_Map.GetMapChildrenInfo(parentID, nil, recurse)
							if children then
								for _, child in ipairs(children) do
									if child.mapID == mapID then
										zoneMatch = true
										break
									end
								end
							end
							if zoneMatch then break end
						end
					end
					
					-- Exclusions
					if trackable.excludeMapIDs and trackable.excludeMapIDs[mapID] then
						zoneMatch = false
					end
					if trackable.excludeByZoneText then
						local excludeZones = trackable.excludeByZoneText:gsub("%s+", ""):lower()
						if excludeZones:find(zoneText, 1, true) or excludeZones:find(minimapText, 1, true) then
							zoneMatch = false
						end
					end
					
					if zoneMatch then
						show = true
					end
				end
			end
			
			if show then
				table.insert(active, trackable)
			end
		end
		
		-- Sort by priority
		table.sort(active, function(a, b)
			return (a.priority or 999) < (b.priority or 999)
		end)
		
		return active
	end
	
	-- Update trackables display
	local function Update()
		local activeTrackables = GetActiveTrackables()
		
		-- Ensure we have enough rows
		while #container.rows < #activeTrackables do
			local row = CreateFrame("Frame", nil, container)
			row:SetSize(200, 14)
			
			local icon = row:CreateTexture(nil, "OVERLAY")
			icon:SetSize(12, 12)
			icon:SetPoint("LEFT")
			row.icon = icon
			
			local text = row:CreateFontString(nil, "OVERLAY")
			text:SetFont(STANDARD_TEXT_FONT, 11, "OUTLINE")
			text:SetPoint("LEFT", icon, "RIGHT", 3, 0)
			text:SetJustifyH("LEFT")
			row.text = text
			
			table.insert(container.rows, row)
		end
		
		-- Hide extra rows
		for i = #activeTrackables + 1, #container.rows do
			container.rows[i]:Hide()
		end
		
		-- Update visible rows
		local yOffset = 0
		local maxWidth = 0
		
		for i, trackable in ipairs(activeTrackables) do
			local row = container.rows[i]
			
			-- Get current amount
			local amount, name, icon, quality
			if trackable.type == "currency" then
				local info = C_CurrencyInfo.GetCurrencyInfo(trackable.id)
				if info then
					amount = info.quantity
					name = info.name
					icon = info.iconFileID
					quality = info.quality or 1
				end
			elseif trackable.type == "item" then
				amount = C_Item.GetItemCount(trackable.id, true, true, true, true) or 0
				local item = Item:CreateFromItemID(trackable.id)
				name = item:GetItemName() or "Unknown"
				icon = item:GetItemIcon() or 134400
				quality = item:GetItemQuality() or 1
			end
			
			-- Skip if hideZero and amount is 0
			local skipRow = false
			if trackable.hideZero and amount == 0 then
				row:Hide()
				skipRow = true
			end
			
			if not skipRow then
			
			-- Format amount
			local amountStr = BT.AbbreviateAmount(amount, trackable.shortenAmount or 0)
			
			-- Color
			local color = ITEM_QUALITY_COLORS[quality] or ITEM_QUALITY_COLORS[1]
			if trackable.customColorToggle and trackable.customColor then
				color = CreateColor(unpack(trackable.customColor))
			end
			
			-- Warning color if configured
			if trackable.warnings and trackable.warnings.enabled then
				if BT.CheckValue(amount, trackable.warnings.value, trackable.warnings.operator) then
					color = CreateColor(1, 0, 0, 1)
				end
			end
			
			-- Build text
			local cfg = BT.db.modules.trackables
			local displayParts = {}
			if cfg.showAmount then
				if cfg.colorAmount then
					table.insert(displayParts, color:WrapTextInColorCode(amountStr))
				else
					table.insert(displayParts, amountStr)
				end
			end
			if cfg.showName then
				if cfg.colorName then
					table.insert(displayParts, color:WrapTextInColorCode(name))
				else
					table.insert(displayParts, name)
				end
			end
			
			row.text:SetText(table.concat(displayParts, " "))
			row.icon:SetTexture(icon)
			
			-- Position
			row:ClearAllPoints()
			row:SetPoint("TOPLEFT", container, "TOPLEFT", 0, yOffset)
			yOffset = yOffset - 14
			
			row:SetWidth(12 + 3 + row.text:GetStringWidth() + 2)
			maxWidth = math.max(maxWidth, row:GetWidth())
			
			row:Show()
			end
		end
		
		-- Resize container
		container:SetSize(maxWidth, math.abs(yOffset))
	end
	
	-- Events
	container:RegisterEvent("ZONE_CHANGED")
	container:RegisterEvent("ZONE_CHANGED_INDOORS")
	container:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	container:RegisterEvent("PLAYER_ENTERING_WORLD")
	container:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	container:RegisterEvent("BAG_UPDATE")
	container:SetScript("OnEvent", Update)
	
	-- Throttled updates for bag events
	local throttle = 0
	container:SetScript("OnUpdate", function(self, elapsed)
		throttle = throttle - elapsed
		if throttle <= 0 then
			throttle = 0.2
			Update()
		end
	end)
	
	-- Initial update
	Update()
	
	-- Add to main frame
	BT.MainFrame:AddRow(container)
	BT.TrackablesContainer = container
end
