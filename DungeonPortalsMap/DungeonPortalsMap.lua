local addonName, addon = ...

-- Addon initialization
local DPM = CreateFrame("Frame", "DungeonPortalsMapFrame")
DPM:RegisterEvent("ADDON_LOADED")
DPM:RegisterEvent("PLAYER_ENTERING_WORLD")
DPM:RegisterEvent("ZONE_CHANGED")
DPM:RegisterEvent("ZONE_CHANGED_NEW_AREA")

-- Default settings
local defaults = {
    enabled = true,
    hudScale = 108,
    alpha = 100,
    iconScale = 180,
    fontSize = 20,
    showInTimeways = true,
    showPlayer = false,
}

local db
local mapContainer
local isInTimeways = false
local lastUpdate = 0

-- Portal/Dungeon data
local portalData = {
    {
        name = "Dungeon 1",
        icon = "Vehicle-HammerGold-1",
        mapID = 2266,
        x = 0.6464,
        y = 0.4409,
    },
    {
        name = "Eco-Dome & Tazavesh",
        icon = "majorfactions_icons_ManaforgeVandals512",
        mapID = 2266,
        x = 0.7435,
        y = 0.4726,
    },
    {
        name = "Dungeon 3",
        icon = "Vehicle-HammerGold-1",
        mapID = 2266,
        x = 0.7729,
        y = 0.6171,
    },
    {
        name = "Halls of Atonement",
        icon = "talents-heroclass-deathknight-sanlayn",
        mapID = 2266,
        x = 0.7037,
        y = 0.7267,
    },
    {
        name = "Dungeon 5",
        icon = "Vehicle-HammerGold-1",
        mapID = 2266,
        x = 0.6059,
        y = 0.6927,
    },
    {
        name = "Dornogal",
        icon = "poi-hub",
        mapID = 2266,
        x = 0.4348,
        y = 0.4991,
    },
}

-- Initialize database
local function InitializeDB()
    if not DungeonPortalsMapDB then
        DungeonPortalsMapDB = {}
    end
    db = DungeonPortalsMapDB
    
    -- Set defaults
    for k, v in pairs(defaults) do
        if db[k] == nil then
            db[k] = v
        end
    end
end

-- Check if player is in Timeways (zone ID 2266)
local function UpdateTimewaysStatus()
    local mapID = C_Map.GetBestMapForUnit("player")
    local wasInTimeways = isInTimeways
    isInTimeways = (mapID == 2266)
    
    if mapContainer then
        if isInTimeways and db.enabled and db.showInTimeways then
            mapContainer:Show()
        else
            mapContainer:Hide()
        end
    end
    
    return isInTimeways ~= wasInTimeways
end

-- Create portal marker frames
local function CreatePortalMarkers(parentFrame)
    local markers = {}
    
    for i, portal in ipairs(portalData) do
        local marker = CreateFrame("Frame", "DPM_Portal_" .. i, parentFrame)
        marker:SetSize(32, 32)
        marker:SetFrameLevel(parentFrame:GetFrameLevel() + 1)
        
        -- Icon
        marker.icon = marker:CreateTexture(nil, "ARTWORK")
        marker.icon:SetAllPoints()
        if portal.icon then
            marker.icon:SetAtlas(portal.icon)
        end
        
        -- Label
        marker.label = marker:CreateFontString(nil, "OVERLAY")
        marker.label:SetPoint("BOTTOM", marker, "TOP", 0, 10)
        marker.label:SetFont("Fonts\\FRIZQT__.TTF", db.fontSize, "OUTLINE, THICK")
        marker.label:SetText(portal.name)
        marker.label:SetTextColor(1, 1, 1, 1)
        marker.label:SetShadowOffset(1, -1)
        marker.label:SetShadowColor(0, 0, 0, 1)
        marker.label:SetJustifyH("CENTER")
        
        markers[i] = marker
    end
    
    return markers
end

-- Create the main map display
local function CreateMapDisplay()
    if mapContainer then return end
    
    mapContainer = CreateFrame("Frame", "DungeonPortalsMapContainer", UIParent)
    mapContainer:SetFrameStrata("MEDIUM")
    mapContainer:SetFrameLevel(50)
    mapContainer:SetPoint("CENTER", UIParent, "CENTER")
    
    -- Calculate HUD scale
    local hudScale = db.hudScale / 100
    local iconScale = db.iconScale / 100
    local alpha = db.alpha / 100
    
    -- Create map and update function
    mapContainer.markers = CreatePortalMarkers(mapContainer)
    mapContainer.hudScale = hudScale
    mapContainer.iconScale = iconScale
    mapContainer.alpha = alpha
    
    -- Corner logo (uses Logo.tga if present)
    mapContainer.logo = mapContainer:CreateTexture(nil, "OVERLAY")
    mapContainer.logo:SetSize(32, 32)
    mapContainer.logo:SetPoint("TOPLEFT", mapContainer, "TOPLEFT", 4, -4)
    mapContainer.logo:SetTexture(LOGO_PATH)
    mapContainer.logo:SetAlpha(0.85)
    
    -- Player position marker
    mapContainer.player = CreateFrame("Frame", "DPM_Player", mapContainer)
    mapContainer.player:SetSize(16, 16)
    mapContainer.player.icon = mapContainer.player:CreateTexture(nil, "ARTWORK")
    mapContainer.player.icon:SetAllPoints()
    mapContainer.player.icon:SetAtlas("CompassIcons-Player")
    
    mapContainer:Hide()
end

-- Update portal positions based on player location and facing
local function UpdatePortalPositions()
    if not mapContainer or not isInTimeways then return end
    
    local time = GetTime()
    if time - lastUpdate < 0.01 then return end -- Only update 100x per second
    lastUpdate = time
    
    local mapID = C_Map.GetBestMapForUnit("player")
    if mapID ~= 2266 then return end
    
    local playerPos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not playerPos then return end
    
    local playerX = playerPos.x
    local playerY = playerPos.y
    local angle = GetPlayerFacing() or 0
    
    local width, height = C_Map.GetMapWorldSize(mapID)
    if not width or not height then return end
    
    -- HUD calculations
    local hudSize = width * 2 * mapContainer.hudScale
    mapContainer:SetSize(hudSize, hudSize)
    
    -- Aspect ratio correction
    local proportion = height / width
    
    -- 45-degree tilt components
    local tiltX = math.cos(math.rad(355))
    local tiltY = math.sin(math.rad(155))
    local fov = 45
    local verticalOffset = 0.06
    
    -- Trigonometric helpers for player facing rotation
    local cosAngle = math.cos(angle)
    local sinAngle = math.sin(angle)
    
    -- Update each portal marker
    for i, marker in ipairs(mapContainer.markers) do
        local portal = portalData[i]
        
        -- Calculate distance from player to portal
        local distanceX = portal.x - playerX
        local distanceY = (portal.y - playerY) * proportion
        
        -- Apply player facing rotation
        local pointX = cosAngle * distanceX - sinAngle * distanceY
        local pointY = sinAngle * distanceX + cosAngle * distanceY
        
        -- Apply 45-degree tilt with FOV correction
        local tiltedX = pointX * tiltX * (90 / fov)
        local tiltedY = (pointY * tiltY * (90 / fov)) + verticalOffset
        
        -- Update marker
        marker:SetSize(32 * mapContainer.iconScale, 32 * mapContainer.iconScale)
        marker:SetAlpha(mapContainer.alpha)
        marker:ClearAllPoints()
        marker:SetPoint("CENTER", mapContainer, "CENTER", 
            tiltedX * hudSize, (tiltedY * hudSize) * -1)
        marker:Show()
    end
    
    -- Update player marker
    mapContainer.player:SetSize(16 * mapContainer.iconScale, 16 * mapContainer.iconScale)
    mapContainer.player:SetAlpha(mapContainer.alpha)
    mapContainer.player:ClearAllPoints()
    mapContainer.player:SetPoint("CENTER", mapContainer, "CENTER", 0, 0)
    if db.showPlayer then
        mapContainer.player:Show()
    else
        mapContainer.player:Hide()
    end
end

-- Event handler
DPM:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        InitializeDB()
        CreateMapDisplay()
        UpdateTimewaysStatus()
    elseif event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(1, function()
            UpdateTimewaysStatus()
        end)
    elseif event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
        UpdateTimewaysStatus()
    end
end)

-- Update hook for continuous position tracking
local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", function(self)
    UpdatePortalPositions()
end)

-- Slash commands
SLASH_DUNGEONPORTALSMAP1 = "/dpm"
SLASH_DUNGEONPORTALSMAP2 = "/dungeonportals"

SlashCmdList["DUNGEONPORTALSMAP"] = function(msg)
    msg = string.lower(msg or "")
    
    if msg == "toggle" or msg == "" then
        db.enabled = not db.enabled
        if db.enabled then
            print("|cff00ff00Dungeon Portals Map:|r Enabled")
            UpdateTimewaysStatus()
        else
            print("|cff00ff00Dungeon Portals Map:|r Disabled")
            if mapContainer then
                mapContainer:Hide()
            end
        end
    elseif msg == "show" then
        db.enabled = true
        db.showInTimeways = true
        print("|cff00ff00Dungeon Portals Map:|r Shown")
        UpdateTimewaysStatus()
    elseif msg == "hide" then
        db.enabled = false
        print("|cff00ff00Dungeon Portals Map:|r Hidden")
        if mapContainer then
            mapContainer:Hide()
        end
    elseif msg:match("^scale%s+(%d+)") then
        local scale = tonumber(msg:match("^scale%s+(%d+)"))
        if scale and scale >= 50 and scale <= 300 then
            db.hudScale = scale
            if mapContainer then
                mapContainer.hudScale = scale / 100
            end
            print("|cff00ff00Dungeon Portals Map:|r HUD scale set to " .. scale)
        else
            print("|cffff0000Dungeon Portals Map:|r Scale must be between 50 and 300")
        end
    elseif msg:match("^alpha%s+([%d%.]+)") then
        local alpha = tonumber(msg:match("^alpha%s+([%d%.]+)"))
        if alpha and alpha >= 0 and alpha <= 100 then
            db.alpha = alpha
            if mapContainer then
                mapContainer.alpha = alpha / 100
            end
            print("|cff00ff00Dungeon Portals Map:|r Alpha set to " .. alpha)
        else
            print("|cffff0000Dungeon Portals Map:|r Alpha must be between 0 and 100")
        end
    elseif msg:match("^icon%s+(%d+)") then
        local iconScale = tonumber(msg:match("^icon%s+(%d+)"))
        if iconScale and iconScale >= 50 and iconScale <= 300 then
            db.iconScale = iconScale
            if mapContainer then
                mapContainer.iconScale = iconScale / 100
            end
            print("|cff00ff00Dungeon Portals Map:|r Icon scale set to " .. iconScale)
        else
            print("|cffff0000Dungeon Portals Map:|r Icon scale must be between 50 and 300")
        end
    elseif msg == "player" then
        db.showPlayer = not db.showPlayer
        if db.showPlayer then
            print("|cff00ff00Dungeon Portals Map:|r Player marker shown")
        else
            print("|cff00ff00Dungeon Portals Map:|r Player marker hidden")
        end
    else
        print("|cff00ff00Dungeon Portals Map Commands:|r")
        print("  /dpm toggle - Toggle display on/off")
        print("  /dpm show - Show the map")
        print("  /dpm hide - Hide the map")
        print("  /dpm scale <50-300> - Set HUD scale")
        print("  /dpm icon <50-300> - Set icon scale")
        print("  /dpm alpha <0-100> - Set opacity (0=invisible, 100=opaque)")
        print("  /dpm player - Toggle player position marker on/off")
    end
end
