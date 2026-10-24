local ADDON_NAME, ns = ...
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")
local HL = LibStub("AceLocale-3.0"):NewLocale(ADDON_NAME, "enUS", true, true)

if not HL then return end

-- Define the plugin handler
local pluginHandler = {}
local options = {}

-- Plugin Configuration (for HandyNotes settings)
options = {
    type = "group",
    name = "Dungeons",
    desc = "Dungeon locations and markers",
    get = function(info) return ns.db[info[#info]] end,
    set = function(info, v)
        ns.db[info[#info]] = v
        pluginHandler:Refresh()
    end,
    args = {
        desc = {
            name = "Settings for HandyNotes Dungeons",
            type = "description",
            order = 0,
        },
        icon_scale = {
            type = "range",
            name = "Icon Scale",
            desc = "The scale of the icons",
            min = 0.25, max = 2, step = 0.01,
            arg = "icon_scale",
            order = 10,
        },
        icon_alpha = {
            type = "range",
            name = "Icon Alpha",
            desc = "The alpha transparency of the icons",
            min = 0, max = 1, step = 0.01,
            arg = "icon_alpha",
            order = 20,
        },
    },
}

-- Node interaction
function pluginHandler:OnEnter(mapFile, coord)
    local tooltip = GameTooltip
    if self:GetCenter() > UIParent:GetCenter() then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end
    
    local mapID = HandyNotes:GetMapFiletoMapID(mapFile)
    local point = ns.points[mapID] and ns.points[mapID][coord]
    
    if point then
        tooltip:SetText(point.label or "Unknown Node")
        if point.note then
             tooltip:AddLine(point.note, 1, 1, 1, true)
        end
    else
        tooltip:SetText("Unknown Node")
    end

    tooltip:Show()
end

function pluginHandler:OnLeave()
    GameTooltip:Hide()
end

-- Node iterator
local function iter(t, prestate)
    if not t then return nil end
    local state, value = next(t, prestate)
    while state do
        if value then
            -- return coord, mapFile, icon, scale, alpha
            return state, nil, value.icon or "interface\\icons\\inv_misc_questionmark", ns.db.icon_scale, ns.db.icon_alpha
        end
        state, value = next(t, state)
    end
    return nil, nil, nil, nil, nil
end

function pluginHandler:GetNodes2(mapID, minimap)
    return iter, ns.points[mapID], nil
end

function pluginHandler:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", "Dungeons")
end

-- Initialization
local function Init()
    -- Initialize database with defaults
    local defaults = {
        profile = {
            icon_scale = 1.0,
            icon_alpha = 1.0,
        },
    }
    
    local db = LibStub("AceDB-3.0"):New("HandyNotes_DungeonsDB", defaults)
    ns.db = db.profile

    -- Register plugin with HandyNotes
    HandyNotes:RegisterPluginDB("Dungeons", pluginHandler, options)
end

-- Event Handling
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        Init()
    end
end)

