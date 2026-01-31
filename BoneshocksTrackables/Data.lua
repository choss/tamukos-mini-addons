-- BoneshocksTrackables Data
-- All currency and item trackable definitions

local addonName, BT = ...

-- Delve maps reference
BT.delveMaps = {2269,2249,2250,2302,2251,2312,2277,2310,2300,2301,2313,2347,2259,2314,2299,2348,2396,2420,2421}

-- Covenant maps reference (Shadowlands)
BT.covenantMaps = {1707,1708,1698,1701,1702,1703,1699,1700} -- K,NL,NF,V

-- Main trackables table
BT.trackables = {
    [10] = {
        
        -- ===THE WAR WITHIN===
        -- currencies:
        {--Valorstones
            id = 3008,
            type = "currency",
            uiMapIDs = {2339},
            parentMapIDs = {"r2274"},
            excludeMapIDs = BT.delveMaps,
            customColorToggle = true,
            customColor = {0,0.8,1,1}, --r,g,b,a
            priority = 1,
        },
        {--Weathered Crest
            id = 3284,
            type = "currency",
            uiMapIDs = {2339},
            parentMapIDs = {"r2274"},
            excludeMapIDs = BT.delveMaps,
            customColorToggle = true,
            customColor = {0.12, 1, 0, 1}, --r,g,b,a
            priority = 2,
            hide = true,
        },
        {--Carved Crest
            id = 3286,
            type = "currency",
            uiMapIDs = {2339},
            parentMapIDs = {"r2274"},
            excludeMapIDs = BT.delveMaps,
            customColorToggle = true,
            customColor = {0,0.44,0.87,1}, --r,g,b,a
            priority = 3,
            hide = true,
        },
        {--Runed Crest
            id = 3288,
            type = "currency",
            uiMapIDs = {2339},
            parentMapIDs = {"r2274"},
            excludeMapIDs = BT.delveMaps,
            customColorToggle = true,
            customColor = {0.64,0.21,0.93,1}, --r,g,b,a
            priority = 4,
            hide = true,
        },
        {--Gilded Crest
            id = 3290,
            type = "currency",
            uiMapIDs = {2339},
            parentMapIDs = {"r2274"},
            excludeMapIDs = BT.delveMaps,
            customColorToggle = true,
            customColor = {1,0.5,0,1}, --r,g,b,a
            priority = 5,
        },
        {--Kej
            id = 3056,
            type = "currency",
            parentMapIDs = {2255},
        },
        {--Resonance Crystals
            id = 2815,
            type = "currency",
            areaMapIDs = {14796,15545,14755,15044,15043},
            excludeMapIDs = BT.delveMaps,
            shortenAmount = 1,
        },
        {--Ethereal Voidsplinters
            id = 3269,
            type = "currency",
            areaMapIDs = {15043},
        },
        {--Undercoin
            id = 2803,
            type = "currency",
            areaMapIDs = {15329},
            uiMapIDs = BT.delveMaps,
        },
        {--Restored Coffer Key
            id = 3028,
            type = "currency",
            areaMapIDs = {15329},
            uiMapIDs = BT.delveMaps,
        },
        {--Flame-Blessed Iron
            id = 3090,
            type = "currency",
            parentMapIDs = {"r2369"},
        },
        {--Empty Kaja'Cola Can
            id = 3218,
            type = "currency",
            uiMapIDs = {2346},
        },
        {--Market Research
            id = 3226,
            type = "currency",
            uiMapIDs = {2346},
            hideZero = true,
        },    
        {--Displaced Corrupted Mementos
            id = 3149,
            type = "currency",
            uiMapIDs = {2404},
            areaMapIDs = {15046},
            hideZero = true,
        },  
        {--Ethereal Strands
            id = 3278,
            type = "currency",
            uiMapIDs = BT.delveMaps,
            areaMapIDs = {15807},
            hideZero = true,
            --warnings = {enabled=false, value=10, operator=3}, --1== 2~= 3> 4< 5>= 6<=
        },  
        {--Twilight's Blade Insignia
            id = 3319,
            type = "currency",
            uiMapIDs = {241}, -- Twilight Highlands
            parentMapIDs = {"r2274"}, -- Khaz Algar (TWW)
            zones = "Twilight Highlands",
        },
        
        -- items:
        {--Coffer Key Shard
            id = 236096,
            type = "item",
            uiMapIDs = {2339, unpack(BT.delveMaps)},
            parentMapIDs = {"r2274"},
            warnings = {enabled=true, value=100, operator=5}, --1== 2~= 3> 4< 5>= 6<=
            hideZero = true,
            value = {enabled=true, value=100, operator=">="}
        },
        {--Radiant Echo
            id = 246771,
            type = "item",
            uiMapIDs = BT.delveMaps,
            areaMapIDs = {15329,15357,15356,15384,15148,15451,15330,15450,15360,15647},
        },
        {--Artisan's Acuity
            id = 210814,
            type = "item",
            areaMapIDs = {15043},
            zones = "Crafter's Enclave", --has no areaID
        },
        {--Radiant Remnant
            id = 206350,
            type = "item",
            areaMapIDs = {14854,15037,15094,14851,15114,14850,14852,15024,15025,15106},
        },
        {--Radiant Emblem of Service
            id = 238920,
            type = "item",
            areaMapIDs = {15335},
            hideZero = true,
        },
    },    
    [9] = {
        -- ===DRAGONFLIGHT===
        -- currencies:
        {--Paracausal Flakes
            id = 2594,
            type = "currency",
            hideZero = true,
            areaMapIDs = {13802},            
        },
        {--Flightstones
            id = 2245,
            type = "currency",
            uiMapIDs = {2112,2200},
            parentMapIDs = {1978},
            customColorToggle = true,
            customColor = {0,0.8,1,1}, --r,g,b,a
            priority = 1,
        },
        {--Conquest
            id = 1602,
            type = "currency",
            zones = "Gladiator's Refuge",
            areaMapIDs = {14499},
        },
        {--Valor
            id = 1191,
            type = "currency",
            zones = "Gladiator's Refuge",
            areaMapIDs = {14499},
        },
        {--Dragon Isles Supplies
            id = 2003,
            type = "currency",
            parentMapIDs = {1978,2025},
            shortenAmount = 1,
            tocversion = 100002,
        },
        {--Elemental Overflow
            id = 2118,
            type = "currency",
            zones = "The Sapphire Enclave",
            areaMapIDs = {14504},
            shortenAmount = 1,
            tocversion = 100002,
        },
        {--Storm Sigil
            id = 2122,
            type = "currency",
            zones = "The Sapphire Enclave",
            areaMapIDs = {14504},
            shortenAmount = 1,
            tocversion = 100002,
        },
        {--Whelpling's Awakened Crest
            id = 2806,
            type = "currency",
            uiMapIDs = {2200,2112},
            areaMapIDs = {14960},
            customColorToggle = true,
            customColor = {0.12, 1, 0, 1}, --r,g,b,a
            priority = 2,
            hide = true,
        },
        {--Drake's Awakened Crest
            id = 2807,
            type = "currency",
            uiMapIDs = {2200,2112},
            areaMapIDs = {14960},
            customColorToggle = true,
            customColor = {0,0.44,0.87,1}, --r,g,b,a
            priority = 3,
            hide = true,
        },
        {--Wyrm's Awakened Crest
            id = 2809,
            type = "currency",
            uiMapIDs = {2200,2112},
            areaMapIDs = {14960},
            customColorToggle = true,
            customColor = {0.64,0.21,0.93,1}, --r,g,b,a
            priority = 4,
            hide = true,
        },
        {--Aspect's Awakened Crest
            id = 2812,
            type = "currency",
            uiMapIDs = {2200,2112},
            areaMapIDs = {14960},
            parentMapIDs = {1978},
            customColorToggle = true,
            customColor = {1,0.5,0,1}, --r,g,b,a
            priority = 5,
        },
        
        -- items:
        {--Antique Bronze Bullion
            id = 213089,
            type = "item",
            hideZero = false,
            areaMapIDs = {14502},
        },
        {--Dilated Time Pod
            id = 209856,
            type = "item",
            hideZero = true,
            areaMapIDs = {13802},
        },
        {--Centaur Hunting Trophy
            id = 200093,
            type = "item",
            zones = "Maruukai",
            uiMapIDs = {2023},
            tocversion = 100002,
            warnings = {enabled=true, value=1, operator=5}
        },
        {--Restored Obsidian Key
            id = 191264,
            type = "item",
            zones = "Obsidian Throne, Obsidian Citadel, The Slagmire",
            areaMapIDs = {13941, 13717, 14012},
            tocversion = 100002,
            warnings = {enabled=true, value=100, operator=1} --1== 2~= 3> 4< 5>= 6<=
        },
        {--Key Framing
            id = 193201,
            type = "item",
            zones = "Obsidian Throne, Obsidian Citadel, The Slagmire",
            areaMapIDs = {13941, 13717, 14012},
            tocversion = 100002,
        },
        {--Key Fragments
            id = 191251,
            type = "item",
            zones = "Obsidian Throne, Obsidian Citadel, The Slagmire",
            areaMapIDs = {13941, 13717, 14012},
            tocversion = 100002,
        },
        {--Sargha's Signet
            id = 201991,
            type = "item",
            zones = "Obsidian Throne",
            areaMapIDs = {13941},
            tocversion = 100002,
            hideZero = true,
        },
        {--Mark of Sargha
            id = 200224,
            type = "item",
            zones = "Obsidian Throne",
            areaMapIDs = {13941},
            tocversion = 100002,
            hideZero = true,
        },
        {--Magmote
            id = 202173,
            type = "item",
            zones = "Smoldering Perch",
            areaMapIDs = {13976},
            tocversion = 100002,
        },
        {--Dragon Isles Artifact
            id = 192055,
            type = "item",
            zones = "Dragonscale Basecamp",
            areaMapIDs = {13732},
            tocversion = 100002,
        },
        {--Titan Relic
            id = 199906,
            type = "item",
            zones = "Valdrakken",
            areaMapIDs = {13862},
            hideZero = true,
            tocversion = 100002,
        },
        {--Zskera Vault Key
            id = 202196,
            type = "item",
            uiMapIDs = {2151},
            tocversion = 100007,
        },
    },
    [8] = {
        -- ===SHADOWLANDS===
        -- currencies:
        {--Reservoir Anima
            id = 1813,
            type = "currency",
            uiMapIDs = {1961,1819,unpack(BT.covenantMaps)},
            zones = "Heart of the Forest",
            parentMapIDs = {1550,},
            shortenAmount = 1,
        },
        {--Redeemed Soul
            id = 1810,
            type = "currency",
            uiMapIDs = BT.covenantMaps,
            zones = "Heart of the Forest",
            customColorToggle = true,
            customColor = {215/255, 184/255, 219/255, 1} --r,g,b,a
        },
        {--Grateful Offering
            id = 1885,
            type = "currency",
            uiMapIDs = BT.covenantMaps,
            zones = "Glitterfall Basin, Heart of the Forest",
        },
        {--Adventure Campaign Progress (Mission Table)
            id = 1889,
            type = "currency",
            uiMapIDs = BT.covenantMaps,
            zones = "Heart of the Forest",
            hide = true,
        },
        {--Infused Ruby
            id = 1820,
            type = "currency",
            zones = "Revendreth",
            uiMapIDs = {1525},
        },
        {--Stygia
            id = 1767,
            type = "currency",
            uiMapIDs = {1543},
            parentMapIDs = {1543},
            excludeByZoneText = "Torghast, Tower of the Damned",
            shortenAmount = 1,
        },
        {--Soul Ash
            id = 1828,
            type = "currency",
            uiMapIDs = {1912, 1911},
            shortenAmount = 1,
        },
        {--Soul Cinders
            id = 1906,
            type = "currency",
            uiMapIDs = {1912, 1911},
            shortenAmount = 1,
            tocversion = 90100,
        },
        {--Tower Knowledge
            id = 1904,
            type = "currency",
            uiMapIDs = {1912, 1911},
            shortenAmount = 1,
            tocversion = 90100,
            hideZero = true,
        },
        {--Honor
            id = 1792,
            type = "currency",
            uiMapIDs = {1670},
        },
        {--Sinstone Fragments
            id = 1816,
            type = "currency",
            uiMapIDs = {1525,},
            zones = "Halls of Atonement",
            restrict = true,
            hideZero = true,
        },
        {--Cataloged Research
            id = 1931,
            type = "currency",
            uiMapIDs = {1961},
            tocversion = 90100,
            shortenAmount = 1,
        },
        {--Stygian Ember
            id = 1977,
            type = "currency",
            zones = "Keeper's Respite",
            uiMapIDs = {1961},
        },
        {--Cyphers of the First Ones
            id = 1979,
            type = "currency",
            uiMapIDs = {1970},
            zones = "Exile's Hollow",
            tocversion = 90200,
        },
        {--Cosmic Flux
            id = 2009,
            type = "currency",
            uiMapIDs = {1970, 1912, 1911},
            tocversion = 90200,
            shortenAmount = 2,
        },
        
        -- items:
        {--Sandworn Relic
            id = 190189,
            type = "item",
            uiMapIDs = {1970},
            zones = "Pilgrim's Grace"
        },
        {--Genesis Mote
            id = 188957,
            type = "item",
            uiMapIDs = {1970},
            tocversion = 90200,
            hideZero = true,
        },
        {--Cypher of Relocation
            id = 180817,
            type = "item",
            uiMapIDs = {1543},
            parentMapIDs = {1543},
            excludeMapIDs = {1961},
            excludeByZoneText = "Torghast, Tower of the Damned",
        },
        {--Grand Inquisitor's Sinstone Fragment
            id = 180451,
            type = "item",
            uiMapIDs = {1525,},
            zones = "Halls of Atonement",
            restrict = true,
            hideZero = true,
        },
        {--Korthian Archivists' Key
            id = 186984,
            type = "item",
            uiMapIDs = {1961},
            tocversion = 90100,
            hideZero = true,
        },
        {--Teleporter Repair Kit
            id = 186972,
            type = "item",
            uiMapIDs = {1961},
            tocversion = 90100,
            hideZero = true,
        },
        {--Repaired Riftkey
            id = 186731,
            type = "item",
            uiMapIDs = {1961},
            tocversion = 90100,
            hideZero = true,
        },
        --**Queen's Conservatory Items**
        {--Greater Dutiful Spirit
            id = 178880,
            type = "item",
            uiMapIDs = {1662},
            hideZero = true,
        },
        {--Greater Martial Spirit
            id = 178877,
            type = "item",
            uiMapIDs = {1662},
            hideZero = true,
        },
        {--Greater Untamed Spirit
            id = 177699,
            type = "item",
            uiMapIDs = {1662},
            hideZero = true,
        },
        {--Greater Prideful Spirit
            id = 178883,
            type = "item",
            uiMapIDs = {1662},
            hideZero = true,
        },
        --**ETHEREAL The Maw Items**
        {--Stygic Dampener
            id = 183787,
            type = "item",
            uiMapIDs = {1543},
            parentMapIDs = {1543},
            excludeByZoneText = "Torghast, Tower of the Damned",
            hideZero = true,
            warnings = {enabled=true, value=1, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Stygic Dampener
            id = 183165,
            type = "item",
            uiMapIDs = {1543},
            parentMapIDs = {1543},
            excludeByZoneText = "Torghast, Tower of the Damned",
            hideZero = true,
            warnings = {enabled=true, value=1, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Shifting Catalyst
            id = 183799,
            type = "item",
            uiMapIDs = {1543},
            hideZero = true,
            warnings = {enabled=true, value=1, operator=5}, --1== 2~= 3> 4< 5>= 6<=
            restrict = true,
            zones = "Soulstained Fields, Torturer's Hovel",
        },
    },
    [7] = {
        -- ===BATTLE FOR AZEROTH===
        {--Seafarer's Dubloon
            id = 1710,
            type = "currency",
            uiMapIDs = {862, 895},
            zones = "Port of Zandalar, Boralus Harbor",
            always = false,
        },
        {--Honorbound Service Medal
            id = 1716,
            uiMapIDs = {862, 62, 14},
            type = "currency",
            zones = "Port of Zandalar, Darkshore, Arathi Highlands",
            faction = "horde",
            expansion = 8,
        },
        {--7th Legion Service Medal
            id = 1717,
            uiMapIDs = {895, 62, 14},
            type = "currency",
            zones = "Boralus Harbor, Darkshore, Arathi Highlands",
            faction = "alliance",
            expansion = 8,
        },
        {--War Resources
            id = 1560,
            uiMapIDs = {862, 895, 62, 14},
            type = "currency",
            zones = "The Banshee's Wail, Wind's Redemption, Darkshore, Arathi Highlands, The Maelstrom Mercantile,Tradewinds Market",
        },
        {--Brawler's Gold
            id = 1299,
            type = "currency",
            zones = "Brawl'gar Arena",
        },
        {--Seal of Wartorn Fate
            id = 1580,
            type = "currency",
            uiMapIDs = {862, 895},
        },
        {--Titan Residuum
            id = 1718,
            type = "currency",
            zones = "The Maelstrom Mercantile, Vault of Kings, Tradewinds Market",
            uiMapIDs = {862, 895},
        },
        --Nazjatar stuff start
        {--Prismatic Manapearl
            id = 1721,
            type = "currency",
            zones = "Nazjatar, Mardivas's Laboratory",
            uiMapIDs = {1355},
        },
        {--Nazjatar Battle Commendation
            id = 168802,
            type = "item",
            zones = "Newhome, Mezzamere",
            uiMapIDs = {1355},
        },
        --Nazjatar stuff end
        --Mechagon start
        {--Galvanic OScillator
            id = 168832,
            type = "item",
            zones = "Mechagon",
            uiMapIDs = {1462},
        },
        {--S.P.A.R.E. Crate
            id = 169610,
            type = "item",
            zones = "Mechagon",
            uiMapIDs = {1462},
        },
        {--Spare Parts
            id = 166846,
            type = "item",
            zones = "Mechagon",
            uiMapIDs = {1462},
        },
        {--Energy Cell
            id = 166970,
            type = "item",
            zones = "Mechagon",
            uiMapIDs = {1462},
        },
        {--Chain Ignitercoil
            id = 168327,
            type = "item",
            zones = "Mechagon",
            uiMapIDs = {1462},
        },
        --Mechagon end
        --Visions of N'zoth start
        {--Corrupted Memento
            id = 1719,
            type = "currency",
            zones = "Chamber of Heart",
            uiMapIDs = {1570,1571,},
            shortenAmount = 1,
        },
        {--Corrupted Memento (vision)
            id = 1744,
            type = "currency",
            uiMapIDs = {1469,1470,},
        },
        {--Coalescing Visions
            id = 1755,
            type = "currency",
            zones = "Chamber of Heart, Uldum, Ramkahen",
            uiMapIDs = {1530,1570,1527,1571,1579,},
            shortenAmount = 1,
        },
        {--Vessel of Horrific Visions
            id = 173363,
            type = "item",
            zones = "Chamber of Heart",
        },
        {--Vial of Self Preservation
            id = 173293,
            type = "item",
            uiMapIDs = {1570,1571,},
            hideZero = true,
        },
        {--Resilient Soul
            id = 169294,
            type = "item",
            uiMapIDs = {1570,1571,},
            hideZero = true,
            warnings = {enabled=true, value=5, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Shard of Self Sacrifice
            id = 173888,
            type = "item",
            uiMapIDs = {1570,1571,},
            hideZero = true,
            warnings = {enabled=true, value=5, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Aqir Relic Fragment
            id = 174756,
            type = "item",
            uiMapIDs = {1527,},
            hideZero = true,
            warnings = {enabled=true, value=6, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Aqir Relic
            id = 174761,
            type = "item",
            uiMapIDs = {1527,},
            hideZero = true,
            warnings = {enabled=true, value=1, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Tol'vir Relic Fragment
            id = 174764,
            type = "item",
            uiMapIDs = {1527,},
            hideZero = true,
            warnings = {enabled=true, value=6, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Tol'vir Relic
            id = 174765,
            type = "item",
            uiMapIDs = {1527,},
            hideZero = true,
            warnings = {enabled=true, value=1, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Mantid Relic Fragment
            id = 174760,
            type = "item",
            uiMapIDs = {1530,},
            hideZero = true,
            warnings = {enabled=true, value=6, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Mantid Relic
            id = 174766,
            type = "item",
            uiMapIDs = {1530,},
            hideZero = true,
            warnings = {enabled=true, value=1, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Mogu Relic Fragment
            id = 174759,
            type = "item",
            uiMapIDs = {1530,},
            hideZero = true,
            warnings = {enabled=true, value=6, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Mogu Relic
            id = 174767,
            type = "item",
            uiMapIDs = {1530,},
            hideZero = true,
            warnings = {enabled=true, value=1, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Voidwarped Relic Fragment
            id = 174758,
            type = "item",
            uiMapIDs = {1530,1527,},
            hideZero = true,
            warnings = {enabled=true, value=6, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Cursed Relic
            id = 174768,
            type = "item",
            uiMapIDs = {1530,1527,},
            hideZero = true,
            warnings = {enabled=true, value=1, operator=5}, --1== 2~= 3> 4< 5>= 6<=
        },
        {--Echoes of Ny'alotha
            id = 1803,
            type = "currency",
            zones = "Seat of Ramkahen, The Silent Sanctuary, Vault of Kings, Seat of Knowledge",
            uiMapIDs = {1473,},
            hideZero = true,
            shortenAmount = 1,
        },
        --Visions of N'zoth end
        
    },
    [6] = {
        -- ===LEGION===
        {--Coins of Air
            id = 1416,
            type = "currency",
            zones = "The Hall of Shadows",
        },
        {--Wakening Essence
            id = 1533,
            type = "currency",
            zones = "Tanks for Everything, Lorlathil, Thunder Totem, Valdisdall, Crumbled Palace, Wardens' Redoubt, Shal'Aran, The Vindicaar, Deliverance Point",
            uiMapIDs = {646,830,882,885,831,832,883,884,887,680,627,628,641,650,634,630,},
            restrict = true
        },
        {-- Nethershard
            id = 1226,
            type = "currency",
            uiMapIDs = {646},
            zones = "Deliverance Point, Broken Shore",
        },
        {--Veiled Argunite
            id = 1508,
            type = "currency",
            zones = "The Vindicaar",
            uiMapIDs = {905,}
        },
        {--Ancient Mana
            id = 1155,
            type = "currency",
            uiMapIDs = {680},
        },
        {--Legiofall War Supplies
            id = 1342,
            type = "currency",
            zones = "Broken Shore, Deliverance Point",
            uiMapIDs = {646},
        },
        {--Sightless Eye
            id = 1149,
            type = "currency",
            zones = "NoneExistingZone",
            uiMapIDs = {628,}
        },
        {--Seal of Broken Fate
            id = 1273,
            type = "currency",
            zones = "NonExistingZone",
            uiMapIDs = {625,}
        },
        {--Order Resources
            id = 1220,
            type = "currency",
            zones = "The Dreamgrove, Netherlight Temple, Dreadscar Rift, Heart of Azeroth, Fel Hammer, Acherus, Sanctum of Light, Temple of Five Dawns, Hall of Shadows, Hall of the Guardian, Trueshot Lodge, Skyhold, Magus Commerce Exchange",
            uiMapIDs = {625,},
            excludeMapIDs = {125,}
        },
    },
    [5] = {
        -- ===WARLORDS OF DRAENOR===
        {--Apexis Cystal
            uiMapIDs = {534},
            id = 823,
            type = "currency",
            zones = "Tanaan Jungle",
        },
        {--Garrison Resources
            id = 824,
            type = "currency",
            zones = "Frostwall Shipyard, Lunarfall Shipyard",
            uiMapIDs = {590,582}
        },
        {--Oil
            id = 1101,
            type = "currency",
            zones = "Frostwall Shipyard, Lunarfall Shipyard",
            uiMapIDs = {590,582}
        },
        {--Seal of Tempered Fate
            id = 994,
            type = "currency",
            zones = "Warspear, Stormshield",
            uiMapIDs = {624, 622},
        },
        {--Seal of Inevitable Fate
            id = 1129,
            type = "currency",
            zones = "Warspear, Stormshield",
            uiMapIDs = {624, 622},
        },
    },
    [4] = {
        -- ===MISTS OF PANDARIA===
        {--Bloody Coin
            id = 789,
            type = "currency",
            zones = "Timeless Isle",
            uiMapIDs = {554},
        },
        {--Timeless Coin
            id = 777,
            type = "currency",
            zones = "Timeless Isle",
            uiMapIDs = {554},
        },
        {--Skyshard
            id = 86547,
            type = "item",
            uiMapIDs = {1530,390},
            hideZero = true,
        },
        {--Elder Charm of Good Fortune
            id = 697,
            type = "currency",
            uiMapIDs = {504},
        },
        {--Ironpaw Token
            id = 402,
            type = "currency",
            zones = "The Halfhill Market",
            uiMapIDs = {376},
        },
        {--Giant Dinosaur Bone
            id = 94288,
            type = "item",
            uiMapIDs = {507},
            zones = "Isle of Giants",
            hideZero = true,
        },
    },
    
    [3] = {
        -- ===CATACLYSM===
    },
    [2] = {
        -- ===WRATH OF THE LICH KING===
        {--Champion's Seal
            id = 241,
            type = "currency",
            zones = "Argent Tournament Grounds, Sunreaver Pavilion, Silver Covenant Pavilion, The Alliance Valiants' Ring, The Aspirants' Ring, The Argent Valiants' Ring, The Ring of Champions, The Horde Valiants' Ring",
            excludeMapIDs = {1819,}
        },
    },
    [1] = {
        -- ===THE BURNING CRUSADE===
    },
    [0] = {
        -- ===CLASSIC===
    },
    [-1] = {
        -- ===OTHER===
        {--Epicurean's Award
            id = 81,
            type = "currency",
            zones = "Orgrimmar, Undercity, Thunder Bluff, Stormwind City, Darnassus, City of Ironforge, Argent Tournament Grounds",
            uiMapIDs = {125, 376},
        },
        {--Darkmoon Prize Ticket
            id = 515,
            type = "currency",
            zones = "Darkmoon Island",
            uiMapIDs = {407},
        },
        {--Darkmoon Ride Ticket
            id = 81055,
            type = "item",
            zones = "Darkmoon Island",
            customColorToggle = true,
            customColor = {255/255, 255/255, 0/255, 1} --r,g,b,a
        },
        {--Argent Commendation (Shadowlands Pre-patch event)
            id = 1754,
            type = "currency",
            uiMapIDs = {118,},
            expansion = 8,
        }
    },
}