local ADDON_NAME, ns = ...

-- Mythic+ dungeon buffs and pickups.
-- Each map ID is the one the coordinates were recorded on; dungeons with several floors or
-- sub-zones use separate map IDs and the points are not shared between them.
-- Coordinate source: willoucom/Handynotes_MythicPlus (nodes.lua).

ns.points = ns.points or {}

local ICON_PATH = "Interface\\Icons\\"
local BUFF     = ICON_PATH .. "spell_holy_innerfire"
local BOOK     = ICON_PATH .. "inv_misc_book_09"
local POTION   = ICON_PATH .. "inv_potion_93"
local HERB     = ICON_PATH .. "inv_misc_herb_16"
local CAULDRON = ICON_PATH .. "trade_alchemy_dpotion_a11"
local MINING   = ICON_PATH .. "trade_mining"
local INCENSE  = ICON_PATH .. "inv_misc_dust_02"
local RUNE     = ICON_PATH .. "spell_nature_stoneclawtotem"
local TAILOR   = ICON_PATH .. "inv_misc_bag_10"
local DRAKE    = ICON_PATH .. "ability_evoker_blessingofthebronze"

-- Midnight
ns.points[2514] = { -- Den of Nalorakk
    [25975843] = { label = "Warding Incense", note = "Versatility buff for the party, 10 minutes. Midnight Alchemy 25 or Bear Form Druid", icon = INCENSE },
    [39847744] = { label = "Warding Incense", note = "Versatility buff for the party, 10 minutes. Midnight Alchemy 25 or Bear Form Druid", icon = INCENSE },
    [70453386] = { label = "Rune of Anchoring", note = "Reduces movement forces for 15 minutes (Harsh Winds). Night Elf, Troll or Bear Form Druid", icon = RUNE },
}

ns.points[2515] = { -- Magisters' Terrace (library)
    [49886417] = { label = "Arcane Empowerment", note = "Interact with the book in the library: +5% Haste for 30 minutes", icon = BOOK },
}

ns.points[2492] = { -- Windrunner Spire
    [52875502] = { label = "Speed Boost Potion", note = "+100% movement speed for 1 minute", icon = POTION },
}
ns.points[2496] = { -- Windrunner Spire
    [43075997] = { label = "Speed Boost Potion", note = "+100% movement speed for 1 minute", icon = POTION },
}

-- Dragonflight
ns.points[2097] = { -- Algeth'ar Academy
    [42856894] = { label = "5% Haste",               note = "Bronze Dragonflight Recruiter", icon = DRAKE },
    [49675936] = { label = "5% Versatility",         note = "Red Dragonflight Recruiter",    icon = DRAKE },
    [46565603] = { label = "10% Healing taken",      note = "Green Dragonflight Recruiter",  icon = DRAKE },
    [41896051] = { label = "Mastery (584 rating)",   note = "Blue Dragonflight Recruiter",   icon = DRAKE },
    [46567181] = { label = "5% Critical Strike",     note = "Black Dragonflight Recruiter",  icon = DRAKE },
}

ns.points[2096] = { -- Brackenhide Hollow
    [11413935] = { label = "Cauldron usage", note = "An Alchemist with 25 skill can activate the cauldrons. Players then interact with a cauldron to gain an ability that removes disease", icon = CAULDRON },
    [17863978] = { label = "Cauldron", note = "Pick up the cauldron, then use the extra button to cleanse disease", icon = CAULDRON },
    [21623021] = { label = "Cauldron", note = "Pick up the cauldron, then use the extra button to cleanse disease", icon = CAULDRON },
    [28503637] = { label = "Cauldron", note = "Pick up the cauldron, then use the extra button to cleanse disease", icon = CAULDRON },
    [40944319] = { label = "Cauldron", note = "Pick up the cauldron, then use the extra button to cleanse disease", icon = CAULDRON },
    [47636607] = { label = "Cauldron", note = "Pick up the cauldron, then use the extra button to cleanse disease", icon = CAULDRON },
}

ns.points[2083] = { -- Halls of Infusion (upper floor)
    [45369179] = { label = "Mushroom", note = "A Herbalist with 25 skill can collect it: 30 minute party buff that periodically cures poison or disease", icon = HERB },
}

ns.points[2071] = { -- Uldaman: Legacy of Tyr
    [57686786] = { label = "Mining deposit", note = "Miner with 25 skill: stacking out-of-combat movement speed buff (up to 30% across 3 deposits)", icon = MINING },
    [73708867] = { label = "Mining deposit", note = "Miner with 25 skill: stacking out-of-combat movement speed buff (up to 30% across 3 deposits)", icon = MINING },
    [80874419] = { label = "Mining deposit", note = "Miner with 25 skill: stacking out-of-combat movement speed buff (up to 30% across 3 deposits)", icon = MINING },
}

-- Shadowlands
ns.points[1669] = { -- Mists of Tirna Scithe
    [78202990] = { label = "Buff", note = "Druids, Night Elves, Taurens and Herbalists can open a zone with mushrooms (10% stat buff)", icon = HERB },
    [89802310] = { label = "Shortcut", note = "Druids, Night Elves, Taurens and Herbalists can open a path", icon = HERB },
}

-- The War Within
ns.points[2341] = { -- Stonevault
    [35304940] = { label = "Buff", note = "Warriors, Dwarves and Blacksmiths can buff the group (10% Versatility)", icon = BUFF },
}

ns.points[2343] = { -- City of Threads
    [48161811] = { label = "Buff", note = "Rogues, Priests and Engineers can buff the group (15% damage and healing, 50% movement speed)", icon = BUFF },
    [55002100] = { label = "Buff", note = "Rogues, Priests and Engineers can buff the group (15% damage and healing, 50% movement speed)", icon = BUFF },
    [55502990] = { label = "Buff", note = "Rogues, Priests and Engineers can buff the group (15% damage and healing, 50% movement speed)", icon = BUFF },
}

ns.points[2357] = { -- Ara-Kara, City of Echoes
    [18005100] = { label = "Tailoring stun", note = "Tailors get an on-use 10 second stun that also works on the Shrilling Voice mini-bosses", icon = TAILOR },
    [33403750] = { label = "Tailoring stun", note = "Tailors get an on-use 10 second stun that also works on the Shrilling Voice mini-bosses", icon = TAILOR },
    [64104430] = { label = "Tailoring stun", note = "Tailors get an on-use 10 second stun that also works on the Shrilling Voice mini-bosses", icon = TAILOR },
    [69105960] = { label = "Tailoring stun", note = "Tailors get an on-use 10 second stun that also works on the Shrilling Voice mini-bosses", icon = TAILOR },
    [73105370] = { label = "Tailoring stun", note = "Tailors get an on-use 10 second stun that also works on the Shrilling Voice mini-bosses", icon = TAILOR },
}
