local ADDON_NAME, ns = ...
local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes")

local PLUGIN_NAME = "Kindojan"

local pluginHandler = {}
LibStub("AceEvent-3.0"):Embed(pluginHandler)

local options = {
    type = "group",
    name = "Labyrinth of Kindo'jan",
    desc = "Possible Hexmask / locked room spawns",
    get = function(info) return ns.db[info[#info]] end,
    set = function(info, v)
        ns.db[info[#info]] = v
        pluginHandler:Refresh()
    end,
    args = {
        desc = {
            name = "Settings for HandyNotes Labyrinth of Kindo'jan",
            type = "description",
            order = 0,
        },
        icon_scale = {
            type = "range",
            name = "Map Icon Scale",
            desc = "The scale of the icons on the world map",
            min = 0.25, max = 3, step = 0.01,
            order = 10,
        },
        icon_scale_minimap = {
            type = "range",
            name = "Minimap Icon Scale",
            desc = "The scale of the icons on the minimap",
            min = 0.25, max = 3, step = 0.01,
            order = 15,
        },
        icon_alpha = {
            type = "range",
            name = "Icon Alpha",
            desc = "The alpha transparency of the icons",
            min = 0, max = 1, step = 0.01,
            order = 20,
        },
        show_minimap = {
            type = "toggle",
            name = "Show on minimap",
            desc = "Show the markers on the minimap",
            order = 30,
        },
        show_notes = {
            type = "toggle",
            name = "Show notes in tooltips",
            desc = "Show the note line in the marker tooltip",
            order = 40,
        },
        waypoint_all = {
            type = "execute",
            name = "Add TomTom waypoints",
            desc = "Add a TomTom waypoint for every spawn location",
            func = function() pluginHandler:AddAllWaypoints() end,
            disabled = function() return not TomTom end,
            order = 50,
        },
    },
}

-- TomTom integration
local function AddWaypoint(mapID, coord)
    if not TomTom then return end
    local point = ns.points[mapID] and ns.points[mapID][coord]
    if not point then return end
    local x, y = HandyNotes:getXY(coord)
    TomTom:AddWaypoint(mapID, x, y, {
        title = point.label,
        from = ADDON_NAME,
        persistent = nil,
        minimap = true,
        world = true,
    })
end

local function SetMapWaypoint(mapID, coord)
    local x, y = HandyNotes:getXY(coord)
    C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(mapID, x, y))
    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
end

function pluginHandler:AddAllWaypoints()
    for mapID, points in pairs(ns.points) do
        for coord in pairs(points) do
            AddWaypoint(mapID, coord)
        end
    end
end

-- Node interaction
function pluginHandler:OnEnter(mapID, coord)
    local tooltip = GameTooltip
    if self:GetCenter() > UIParent:GetCenter() then
        tooltip:SetOwner(self, "ANCHOR_LEFT")
    else
        tooltip:SetOwner(self, "ANCHOR_RIGHT")
    end

    local point = ns.points[mapID] and ns.points[mapID][coord]
    if point then
        tooltip:SetText(point.label or "Unknown Node")
        if point.note and ns.db.show_notes then
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

-- Right-click context menu
function pluginHandler:OnClick(button, down, mapID, coord)
    if button ~= "RightButton" or not down then return end
    MenuUtil.CreateContextMenu(self, function(owner, root)
        root:CreateTitle("HandyNotes: Labyrinth of Kindo'jan")
        local waypoint = root:CreateButton("Set waypoint", function()
            SetMapWaypoint(mapID, coord)
        end)
        waypoint:SetEnabled(C_Map.CanSetUserWaypointOnMap(mapID))
        if TomTom then
            root:CreateButton("Add TomTom waypoint", function()
                AddWaypoint(mapID, coord)
            end)
        end
        root:CreateButton("Close", function() end)
    end)
end

-- Node iterator
local function iter(t, prestate)
    if not t then return nil end
    local state, value = next(t, prestate)
    while state do
        if value then
            -- return coord, mapFile, icon, scale, alpha
            return state, nil, value.icon or ns.icon, ns.iterScale, ns.db.icon_alpha
        end
        state, value = next(t, state)
    end
    return nil, nil, nil, nil, nil
end

function pluginHandler:GetNodes2(mapID, minimap)
    if minimap and not ns.db.show_minimap then return iter, nil, nil end
    ns.iterScale = minimap and ns.db.icon_scale_minimap or ns.db.icon_scale
    return iter, ns.points[mapID], nil
end

function pluginHandler:Refresh()
    self:SendMessage("HandyNotes_NotifyUpdate", PLUGIN_NAME)
end

-- Initialization
local function Init()
    local defaults = {
        profile = {
            icon_scale = 1.0,
            icon_scale_minimap = 1.0,
            icon_alpha = 1.0,
            show_minimap = true,
            show_notes = true,
        },
    }

    local db = LibStub("AceDB-3.0"):New("HandyNotes_KindojanDB", defaults)
    ns.db = db.profile

    HandyNotes:RegisterPluginDB(PLUGIN_NAME, pluginHandler, options)
end

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        Init()
    end
end)
