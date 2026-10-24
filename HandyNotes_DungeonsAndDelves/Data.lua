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
-- Map ID 2671 = Labyrinth of Kindo'jan (zone-type map the player is on); same coordinates as 2647
ns.points[2671] = ns.points[2647]

-- Map ID 2342 = City of Threads (dungeon instance), parent map ID 2213
-- Coordinates were converted from WeakAura pixel offsets; use /hnd_debug at each location to get exact coords
ns.points[2342] = {
    -- Queen's Eyes
    [55804270] = { label = "1st Eye", note = "Begin at this Eye while fighting Xeph'itik", icon = "Interface\\Icons\\Ability_Evoker_EyeOfInfinity" },

    -- 2nd Zone (Blue)
    [69204950] = { label = "2nd Zone - Eye 1", note = "Blue zone, first Eye",  icon = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness" },
    [82405910] = { label = "2nd Zone - Eye 2", note = "Blue zone, second Eye", icon = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness" },
    [82404890] = { label = "2nd Zone - Eye 3", note = "Blue zone, third Eye",  icon = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness" },

    -- 3rd Zone (Green)
    [10270350] = { label = "3rd Zone - Eye 1", note = "Green zone, first Eye",  icon = "Interface\\Icons\\Spell_Shadow_Twilight" },
    [10440037] = { label = "3rd Zone - Eye 2", note = "Green zone, second Eye", icon = "Interface\\Icons\\Spell_Shadow_Twilight" },
    [95000000] = { label = "3rd Zone - Eye 3", note = "Green zone, third Eye",  icon = "Interface\\Icons\\Spell_Shadow_Twilight" },

    -- 4th Zone (Red)
    [56801880] = { label = "4th Zone - Eye 1", note = "Red zone, first Eye",  icon = "Interface\\Icons\\Spell_Shadow_Possession" },
    [39201120] = { label = "4th Zone - Eye 2", note = "Red zone, second Eye", icon = "Interface\\Icons\\Spell_Shadow_Possession" },
    [66000250] = { label = "4th Zone - Eye 3", note = "Red zone, third Eye",  icon = "Interface\\Icons\\Spell_Shadow_Possession" },

    -- Last Eye (Executor Nizrek)
    [46701130] = { label = "Last Eye", note = "Final Eye before Executor Nizrek", icon = "Interface\\Icons\\INV_Enchant_EssenceMagicLarge" },
}

