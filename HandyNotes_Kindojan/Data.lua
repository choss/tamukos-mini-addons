local ADDON_NAME, ns = ...

-- Data Storage (MapID -> Coord -> Data)
-- Coordinates are stored as: x*1000000 + y*100 (x and y are 0-100 percentages, 2 decimals)
-- e.g. 50.3, 82.6 -> 50308260

-- Map ID 2647 = Labyrinth of Kindo'jan
ns.points = ns.points or {}

local ICON = "Interface\\Icons\\inv_helm_armor_hextroll_d_01"
ns.icon = ICON
local NOTE = "Possible Hexmask / locked room spawn"

ns.points[2647] = {
    [50308260] = { label = "Chamber of Rites",  note = NOTE, icon = ICON },
    [88505150] = { label = "The Cave Towers",   note = NOTE, icon = ICON },
    [56801780] = { label = "Akil'zon's Roost",  note = NOTE, icon = ICON },
    [18801820] = { label = "Jan'alai's Refuge", note = NOTE, icon = ICON },
    [58502170] = { label = "Nalorakk's Rest",   note = NOTE, icon = ICON },
}

