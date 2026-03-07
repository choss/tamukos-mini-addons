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
						if (zoneText ~= "" and zones:find(zoneText, 1, true)) or (minimapText ~= "" and zones:find(minimapText, 1, true)) then
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
						if (zoneText ~= "" and excludeZones:find(zoneText, 1, true)) or (minimapText ~= "" and excludeZones:find(minimapText, 1, true)) then
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
	
	-- Helper: resolve color for a trackable (custom > quality)
	local function GetTrackableColor(trackable, quality)
		if trackable.customColorToggle and trackable.customColor then
			local c = trackable.customColor
			return CreateColor(c[1], c[2], c[3], c[4] or 1)
		end
		local ct = ITEM_QUALITY_COLORS[quality] or ITEM_QUALITY_COLORS[1]
		return CreateColor(ct.r, ct.g, ct.b, 1)
	end

	-- Helper: fetch amount/name/icon/quality for any trackable
	local function GetTrackableData(trackable)
		if trackable.type == "currency" then
			local info = C_CurrencyInfo.GetCurrencyInfo(trackable.id)
			if info then
				return info.quantity, info.name, info.iconFileID, info.quality or 1
			end
		elseif trackable.type == "item" then
			local amt = C_Item.GetItemCount(trackable.id, true, true, true, true) or 0
			local item = Item:CreateFromItemID(trackable.id)
			return amt, item:GetItemName() or "Unknown", item:GetItemIcon() or 134400, item:GetItemQuality() or 1
		end
	end

	-- Helper: create or return the display row at index
	local function EnsureRow(idx)
		if not container.rows[idx] then
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
			container.rows[idx] = row
		end
		return container.rows[idx]
	end

	-- Update trackables display
	local function Update()
		local activeTrackables = GetActiveTrackables()
		local cfg = BT.db.modules.trackables

		-- Build display items: group consecutive slashGroup entries when option is on
		local displayItems = {}
		local i = 1
		while i <= #activeTrackables do
			local t = activeTrackables[i]
			if cfg.mergeSlashGroups and t.slashGroup then
				local group = {t}
				local j = i + 1
				while j <= #activeTrackables and activeTrackables[j].slashGroup == t.slashGroup do
					table.insert(group, activeTrackables[j])
					j = j + 1
				end
				table.insert(displayItems, {isGroup = true, trackables = group})
				i = j
			else
				table.insert(displayItems, {isGroup = false, trackable = t})
				i = i + 1
			end
		end

		-- Ensure enough rows exist
		for idx = 1, #displayItems do EnsureRow(idx) end

		-- Hide extra rows
		for idx = #displayItems + 1, #container.rows do
			container.rows[idx]:Hide()
		end

		-- Render rows
		local yOffset = 0
		local maxWidth = 0

		for idx, item in ipairs(displayItems) do
			local row = container.rows[idx]

			if item.isGroup then
				-- Slash-separated group (e.g. Champion/Hero/Myth Dawncrest)
				local parts = {}
				local firstIcon
				for _, gt in ipairs(item.trackables) do
					local amount, _, icon, quality = GetTrackableData(gt)
					if amount then
						firstIcon = firstIcon or icon
						local amtStr = BT.AbbreviateAmount(amount, gt.shortenAmount or 0)
						local color = GetTrackableColor(gt, quality)
						if gt.warnings and gt.warnings.enabled and BT.CheckValue(amount, gt.warnings.value, gt.warnings.operator) then
							color = CreateColor(1, 0, 0, 1)
						end
						table.insert(parts, cfg.colorAmount and color:WrapTextInColorCode(amtStr) or amtStr)
					end
				end
				if #parts > 0 then
					local sep = cfg.colorAmount and "|cffffffff||r" or "|"
					local displayStr = table.concat(parts, sep)
					if cfg.showName then
						displayStr = displayStr .. " " .. item.trackables[1].slashGroup
					end
					row.text:SetText(displayStr)
					row.icon:SetTexture(firstIcon)
					row:ClearAllPoints()
					row:SetPoint("TOPLEFT", container, "TOPLEFT", 0, yOffset)
					yOffset = yOffset - 14
					row:SetWidth(12 + 3 + row.text:GetStringWidth() + 2)
					maxWidth = math.max(maxWidth, row:GetWidth())
					row:Show()
				else
					row:Hide()
				end
			else
				-- Single trackable row
				local trackable = item.trackable
				local amount, name, icon, quality = GetTrackableData(trackable)
				if trackable.hideZero and (not amount or amount == 0) then
					row:Hide()
				else
					local amountStr = BT.AbbreviateAmount(amount or 0, trackable.shortenAmount or 0)
					local color = GetTrackableColor(trackable, quality or 1)
					if trackable.warnings and trackable.warnings.enabled then
						if BT.CheckValue(amount, trackable.warnings.value, trackable.warnings.operator) then
							color = CreateColor(1, 0, 0, 1)
						end
					end
					local displayParts = {}
					if cfg.showAmount then
						table.insert(displayParts, cfg.colorAmount and color:WrapTextInColorCode(amountStr) or amountStr)
					end
					if cfg.showName then
						table.insert(displayParts, cfg.colorName and color:WrapTextInColorCode(name) or name)
					end
					row.text:SetText(table.concat(displayParts, " "))
					row.icon:SetTexture(icon)
					row:ClearAllPoints()
					row:SetPoint("TOPLEFT", container, "TOPLEFT", 0, yOffset)
					yOffset = yOffset - 14
					row:SetWidth(12 + 3 + row.text:GetStringWidth() + 2)
					maxWidth = math.max(maxWidth, row:GetWidth())
					row:Show()
				end
			end
		end

		-- Resize container
		container:SetSize(maxWidth, math.abs(yOffset))
		if BT.MainFrame and BT.MainFrame.LayoutRows then
			BT.MainFrame:LayoutRows()
		end
	end
	
	-- Events
	container:RegisterEvent("ZONE_CHANGED")
	container:RegisterEvent("ZONE_CHANGED_INDOORS")
	container:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	container:RegisterEvent("PLAYER_ENTERING_WORLD")
	container:RegisterEvent("CURRENCY_DISPLAY_UPDATE")
	container:RegisterEvent("BAG_UPDATE")
	
	-- Throttled update system
	local updatePending = false
	local function RequestUpdate()
		if not updatePending then
			updatePending = true
			C_Timer.After(0.2, function()
				Update()
				updatePending = false
			end)
		end
	end
	
	container:SetScript("OnEvent", RequestUpdate)
	
	-- Initial update
	RequestUpdate()
	
	-- Add to main frame
	BT.MainFrame:AddRow(container)
	BT.TrackablesContainer = container
end
