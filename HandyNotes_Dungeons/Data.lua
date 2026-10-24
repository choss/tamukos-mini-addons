local ADDON_NAME, ns = ...

-- Data Storage (MapID -> Coord -> Data)
-- Coordinates are stored as: x*10000 + y (where x and y are 0-100 percentages)
-- Icon file IDs from WoW's interface

-- Map ID 2342 = City of Threads (dungeon instance)
-- Parent Map ID 2213 = City of Threads (zone)
-- Note: Coordinates converted from WeakAura pixel offsets
-- Use /hn_dungeons_debug while standing at each location to get exact coords

ns.points = ns.points or {}

ns.points[2342] = {
    -- Queen's Eyes locations
    -- 1st Eye (Starting position) 
    [55804270] = { 
        label = "1st Eye", 
        note = "Begin at this Eye while fighting Xeph'itik",
        icon = "Interface\\Icons\\Ability_Evoker_EyeOfInfinity" 
    },
    
    -- 2nd Zone (Blue) - 3 Eyes
    [69204950] = { 
        label = "2nd Zone - Eye 1", 
        note = "Blue zone, first Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness" 
    },
    [82405910] = { 
        label = "2nd Zone - Eye 2", 
        note = "Blue zone, second Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness" 
    },
    [82404890] = { 
        label = "2nd Zone - Eye 3", 
        note = "Blue zone, third Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Shadesofdarkness" 
    },
    
    -- 3rd Zone (Green) - 3 Eyes
    [10270350] = { 
        label = "3rd Zone - Eye 1", 
        note = "Green zone, first Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Twilight" 
    },
    [10440037] = { 
        label = "3rd Zone - Eye 2", 
        note = "Green zone, second Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Twilight" 
    },
    [95000000] = { 
        label = "3rd Zone - Eye 3", 
        note = "Green zone, third Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Twilight" 
    },
    
    -- 4th Zone (Red) - 3 Eyes
    [56801880] = { 
        label = "4th Zone - Eye 1", 
        note = "Red zone, first Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Possession" 
    },
    [39201120] = { 
        label = "4th Zone - Eye 2", 
        note = "Red zone, second Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Possession" 
    },
    [66000250] = { 
        label = "4th Zone - Eye 3", 
        note = "Red zone, third Eye",
        icon = "Interface\\Icons\\Spell_Shadow_Possession" 
    },
    
    -- Last Eye (Executor Nizrek location)
    [46701130] = { 
        label = "Last Eye", 
        note = "Final Eye before Executor Nizrek",
        icon = "Interface\\Icons\\INV_Enchant_EssenceMagicLarge" 
    },
}
