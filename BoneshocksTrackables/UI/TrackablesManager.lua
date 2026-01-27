-- BoneshocksTrackables UI - Trackables Manager
-- Searchable list to show/hide individual trackables

local addonName, BT = ...

function BT:CreateTrackablesManager(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(580, 400)
	frame:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -10)
	
	-- Title
	local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 10, -10)
	title:SetText("Show/Hide Individual Trackables")
	
	-- Search box
	local searchBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
	searchBox:SetSize(560, 20)
	searchBox:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 5, -10)
	searchBox:SetAutoFocus(false)
	searchBox:SetText("Search currencies and items...")
	searchBox:SetScript("OnEditFocusGained", function(self)
		if self:GetText() == "Search currencies and items..." then
			self:SetText("")
		end
	end)
	searchBox:SetScript("OnEditFocusLost", function(self)
		if self:GetText() == "" then
			self:SetText("Search currencies and items...")
		end
	end)
	
	-- Scroll frame for trackables list
	local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", searchBox, "BOTTOMLEFT", -5, -10)
	scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 10)
	
	local content = CreateFrame("Frame", nil, scrollFrame)
	content:SetSize(520, 1)
	scrollFrame:SetScrollChild(content)
	
	frame.searchBox = searchBox
	frame.scrollFrame = scrollFrame
	frame.content = content
	frame.checkboxes = {}
	
	-- Function to update list based on search
	local function UpdateList()
		local searchText = searchBox:GetText():lower()
		if searchText == "search currencies and items..." then
			searchText = ""
		end
		
		-- Hide all checkboxes first
		for _, cb in ipairs(frame.checkboxes) do
			cb:Hide()
		end
		
		local yOffset = 0
		local visibleCount = 0
		
		-- Sort trackables by expansion and name
		local sortedTrackables = {}
		for _, trackable in ipairs(BT.allTrackables) do
			table.insert(sortedTrackables, trackable)
		end
		table.sort(sortedTrackables, function(a, b)
			if a.expansion ~= b.expansion then
				return a.expansion > b.expansion
			end
			-- Get names for sorting
			local aName, bName
			if a.type == "currency" then
				local info = C_CurrencyInfo.GetCurrencyInfo(a.id)
				aName = info and info.name or "Unknown"
			else
				aName = C_Item.GetItemNameByID(a.id) or "Unknown"
			end
			if b.type == "currency" then
				local info = C_CurrencyInfo.GetCurrencyInfo(b.id)
				bName = info and info.name or "Unknown"
			else
				bName = C_Item.GetItemNameByID(b.id) or "Unknown"
			end
			return aName < bName
		end)
		
		for i, trackable in ipairs(sortedTrackables) do
			-- Get trackable name
			local name
			if trackable.type == "currency" then
				local info = C_CurrencyInfo.GetCurrencyInfo(trackable.id)
				name = info and info.name or ("Currency " .. trackable.id)
			elseif trackable.type == "item" then
				name = C_Item.GetItemNameByID(trackable.id) or ("Item " .. trackable.id)
			end
			
			-- Filter by search
			if searchText == "" or name:lower():find(searchText, 1, true) then
				visibleCount = visibleCount + 1
				
				-- Create checkbox if needed
				if not frame.checkboxes[visibleCount] then
					local cb = CreateFrame("CheckButton", nil, content, "InterfaceOptionsCheckButtonTemplate")
					cb:SetSize(24, 24)
					frame.checkboxes[visibleCount] = cb
				end
				
				local cb = frame.checkboxes[visibleCount]
				cb:SetPoint("TOPLEFT", content, "TOPLEFT", 5, yOffset)
				cb.Text:SetText(string.format("%s (ID: %d)", name, trackable.id))
				
				-- Ensure hiddenTrackables table exists
				if not BT.db.hiddenTrackables then
					BT.db.hiddenTrackables = {}
				end
				
				-- Store trackable key (type:id) before setting up the click handler
				local trackableKey = trackable.type .. ":" .. trackable.id
				cb.trackableKey = trackableKey
				
				-- Set checked state: user preference overrides default hide
				local isHidden
				if BT.db.hiddenTrackables[trackableKey] ~= nil then
					isHidden = BT.db.hiddenTrackables[trackableKey]
				else
					isHidden = trackable.hide or false
				end
				cb:SetChecked(not isHidden)
				
				cb:SetScript("OnClick", function(self)
					local checked = self:GetChecked()
					-- Ensure hiddenTrackables table exists
					if not BT.db.hiddenTrackables then
						BT.db.hiddenTrackables = {}
					end
					
					if checked then
						-- Show this trackable (explicitly set to false)
						BT.db.hiddenTrackables[self.trackableKey] = false
					else
						-- Hide this trackable
						BT.db.hiddenTrackables[self.trackableKey] = true
					end
					
					-- Update display
					if BT.TrackablesContainer then
						BT.TrackablesContainer:GetScript("OnEvent")(BT.TrackablesContainer, "ZONE_CHANGED")
					end
				end)
				cb:Show()
				
				yOffset = yOffset - 25
			end
		end
		
		content:SetHeight(math.max(1, math.abs(yOffset)))
	end
	
	-- Update list on search text change
	searchBox:SetScript("OnTextChanged", function(self)
		UpdateList()
	end)
	
	-- Initial update
	C_Timer.After(0.5, function() UpdateList() end)
	
	return frame
end
