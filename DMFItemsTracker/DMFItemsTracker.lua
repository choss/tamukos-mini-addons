local ADDON_NAME = ...

local defaults = {
    point = "CENTER",
    relPoint = "CENTER",
    x = 0,
    y = 0,
    locked = false,
    zoneOnly = true, -- hide outside DMF/capitals to match the aura
}

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local zoneWhitelist = {
    [37] = true,   -- Elwynn Forest (Stormwind entry)
    [84] = true,   -- Stormwind City
    [407] = true,  -- Darkmoon Island
    [2112] = true, -- Valdrakken
}

local quests = {
    cooking = 29509,
    fishing = 29513,
    alchemy = 29506,
    blacksmithing = 29508,
    enchanting = 29510,
    engineering = 29511,
    herbalism = 29514,
    inscription = 29515,
    jewelcrafting = 29516,
    leatherworking = 29517,
    mining = 29518,
    skinning = 29519,
    tailoring = 29520,
}

local items = {
    cooking = { id = 30817, need = 5, name = "Simple Flour" },
    alchemy = { id = 1645, need = 5, name = "Moonberry Juice" },
    inscription = { id = 39354, need = 5, name = "Light Parchment" },
    leatherworking = {
        { id = 6529, need = 10, name = "Shiny Bauble" },
        { id = 2320, need = 5, name = "Coarse Thread" },
        { id = 6260, need = 5, name = "Blue Dye" },
    },
    tailoring = {
        { id = 2320, need = 1, name = "Coarse Thread" },
        { id = 6260, need = 1, name = "Blue Dye" },
        { id = 2604, need = 1, name = "Red Dye" },
    },
}

local function ensureDB()
    DMFItemsTrackerDB = DMFItemsTrackerDB or {}
    for k, v in pairs(defaults) do
        if DMFItemsTrackerDB[k] == nil then
            DMFItemsTrackerDB[k] = v
        end
    end
end

local function getProfessionSkillIDs()
    local profs = { GetProfessions() }
    local skillIDs = {}
    for i = 1, #profs do
        local profIndex = profs[i]
        if profIndex then
            local _, _, _, _, _, _, skillLine = GetProfessionInfo(profIndex)
            if skillLine then
                skillIDs[skillLine] = true
            end
        end
    end
    return skillIDs
end

local function colorText(text, good)
    return (good and "|cff00ff00" or "|cffff0000") .. text .. "|r"
end

local function line(label, value)
    return "|cff00dddd" .. label .. ":|r " .. value
end

local function questComplete(qid)
    return C_QuestLog.IsQuestFlaggedCompleted(qid)
end

local function countHas(id, need)
    local count = GetItemCount(id, false, false) or 0
    return count, count >= need
end

local function buildText()
    local skillIDs = getProfessionSkillIDs()
    local out = { "|cff00ffaaDarkmoon Faire Items Needed|r" }

    -- Cooking (always listed)
    do
        local q = quests.cooking
        if questComplete(q) then
            table.insert(out, line("Cooking", "|cff00ff00Complete|r"))
        else
            local need = items.cooking
            local count, ok = countHas(need.id, need.need)
            table.insert(out, line("Cooking", colorText(need.name .. " x" .. need.need .. " (" .. count .. ")", ok)))
        end
    end

    -- Fishing (always listed, no item requirement)
    do
        local q = quests.fishing
        if questComplete(q) then
            table.insert(out, line("Fishing", "|cff00ff00Complete|r"))
        else
            table.insert(out, line("Fishing", "None"))
        end
    end

    -- Professions with item turn-ins
    local function maybeAdd(label, skillID, qid, itemData)
        if not skillIDs[skillID] then
            return
        end
        if questComplete(qid) then
            table.insert(out, line(label, "|cff00ff00Complete|r"))
            return
        end
        if not itemData then
            table.insert(out, line(label, "None"))
            return
        end
        if itemData.id then
            local count, ok = countHas(itemData.id, itemData.need)
            table.insert(out, line(label, colorText(itemData.name .. " x" .. itemData.need .. " (" .. count .. ")", ok)))
        else
            local parts = {}
            local allOk = true
            for _, req in ipairs(itemData) do
                local count, ok = countHas(req.id, req.need)
                allOk = allOk and ok
                table.insert(parts, colorText(req.name .. " x" .. req.need .. " (" .. count .. ")", ok))
            end
            table.insert(out, line(label, table.concat(parts, ", ")))
        end
    end

    maybeAdd("Alchemy", 171, quests.alchemy, items.alchemy)
    maybeAdd("Blacksmithing", 164, quests.blacksmithing)
    maybeAdd("Enchanting", 333, quests.enchanting)
    maybeAdd("Engineering", 202, quests.engineering)
    maybeAdd("Herbalism", 182, quests.herbalism)
    maybeAdd("Inscription", 773, quests.inscription, items.inscription)
    maybeAdd("Jewelcrafting", 755, quests.jewelcrafting)
    maybeAdd("Leatherworking", 165, quests.leatherworking, items.leatherworking)
    maybeAdd("Mining", 186, quests.mining)
    maybeAdd("Skinning", 393, quests.skinning)
    maybeAdd("Tailoring", 197, quests.tailoring, items.tailoring)

    return table.concat(out, "\n")
end

local frame

local function applyPosition()
    frame:ClearAllPoints()
    frame:SetPoint(DMFItemsTrackerDB.point, UIParent, DMFItemsTrackerDB.relPoint, DMFItemsTrackerDB.x, DMFItemsTrackerDB.y)
end

local function savePosition()
    local point, _, relPoint, x, y = frame:GetPoint(1)
    DMFItemsTrackerDB.point = point
    DMFItemsTrackerDB.relPoint = relPoint
    DMFItemsTrackerDB.x = x
    DMFItemsTrackerDB.y = y
end

local function updateDragState()
    local locked = DMFItemsTrackerDB.locked
    frame:EnableMouse(true)
    frame:SetMovable(not locked)
    if not locked then
        frame:RegisterForDrag("LeftButton")
    else
        frame:RegisterForDrag()
    end
end

local function shouldShow()
    if not DMFItemsTrackerDB.zoneOnly then
        return true
    end
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID and zoneWhitelist[mapID] then
        return true
    end
    return false
end

local function refresh()
    if not shouldShow() then
        frame:Hide()
        return
    end
    frame.text:SetText(buildText())
    frame:Show()
end

local function onEvent(_, event)
    if event == "PLAYER_ENTERING_WORLD" then
        ensureDB()
        applyPosition()
        updateDragState()
    end
    refresh()
end

local function onDragStart(self)
    if not DMFItemsTrackerDB.locked then
        self:StartMoving()
    end
end

local function onDragStop(self)
    self:StopMovingOrSizing()
    savePosition()
end

local function setupFrame()
    frame = CreateFrame("Frame", "DMFItemsTrackerFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    frame:SetSize(340, 360)
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 },
    })
    frame:SetBackdropColor(0, 0, 0, 0.65)
    frame:SetBackdropBorderColor(0.2, 0.2, 0.2, 0.9)
    frame:SetClampedToScreen(true)

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.text:SetPoint("TOPLEFT", 12, -12)
    frame.text:SetPoint("TOPRIGHT", -12, -12)
    frame.text:SetJustifyH("LEFT")
    frame.text:SetJustifyV("TOP")
    frame.text:SetWordWrap(true)
    frame.text:SetSpacing(2)

    frame:SetScript("OnDragStart", onDragStart)
    frame:SetScript("OnDragStop", onDragStop)

    frame:SetScript("OnEvent", onEvent)
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("BAG_UPDATE")
    frame:RegisterEvent("QUEST_LOG_UPDATE")
    frame:RegisterEvent("SKILL_LINES_CHANGED")
    frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
    frame:RegisterEvent("ZONE_CHANGED")

    frame:SetMovable(true)
    frame:EnableMouse(true)
end

local function printHelp()
    print("DMF Items Tracker: commands:")
    print("  /dmfitems lock   - lock the frame (stop dragging)")
    print("  /dmfitems unlock - unlock the frame (drag with left button)")
    print("  /dmfitems toggle - toggle visibility in current zone")
    print("  /dmfitems reset  - reset position")
    print("  /dmfitems zone   - toggle zone-only display (currently " .. (DMFItemsTrackerDB.zoneOnly and "on" or "off") .. ")")
end

SLASH_DMFITEMS1 = "/dmfitems"
SlashCmdList.DMFITEMS = function(msg)
    ensureDB()
    msg = trim((msg or ""):lower())
    if msg == "lock" then
        DMFItemsTrackerDB.locked = true
        updateDragState()
        print("DMF Items Tracker locked")
    elseif msg == "unlock" then
        DMFItemsTrackerDB.locked = false
        updateDragState()
        print("DMF Items Tracker unlocked (drag with left button)")
    elseif msg == "reset" then
        for k, v in pairs(defaults) do
            DMFItemsTrackerDB[k] = v
        end
        applyPosition()
        updateDragState()
        refresh()
        print("DMF Items Tracker position reset")
    elseif msg == "toggle" then
        if frame:IsShown() then
            frame:Hide()
        else
            refresh()
        end
    elseif msg == "zone" then
        DMFItemsTrackerDB.zoneOnly = not DMFItemsTrackerDB.zoneOnly
        print("DMF Items Tracker zone-only display: " .. (DMFItemsTrackerDB.zoneOnly and "on" or "off"))
        refresh()
    else
        printHelp()
    end
end

-- Initialize
setupFrame()
ensureDB()
applyPosition()
updateDragState()
refresh()
