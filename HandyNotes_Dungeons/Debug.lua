-- Debug helper to find the correct map ID
-- Type /hn_dungeons_debug in-game while in City of Threads to see the map ID

SLASH_HNDUNGEONS1 = "/hn_dungeons_debug"
SlashCmdList["HNDUNGEONS"] = function()
    local mapID = C_Map.GetBestMapForUnit("player")
    local mapInfo = C_Map.GetMapInfo(mapID)
    
    if mapInfo then
        print("HandyNotes_Dungeons Debug:")
        print("  Current Map ID: " .. tostring(mapID))
        print("  Map Name: " .. tostring(mapInfo.name))
        print("  Map Type: " .. tostring(mapInfo.mapType))
        
        -- Also print parent map
        if mapInfo.parentMapID and mapInfo.parentMapID > 0 then
            local parentInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
            if parentInfo then
                print("  Parent Map ID: " .. tostring(mapInfo.parentMapID))
                print("  Parent Name: " .. tostring(parentInfo.name))
            end
        end
        
        -- Print player position
        local position = C_Map.GetPlayerMapPosition(mapID, "player")
        if position then
            local x, y = position:GetXY()
            print("  Player Position: " .. string.format("%.2f, %.2f", x*100, y*100))
            print("  Encoded Coord: " .. tostring(math.floor(x*10000 + 0.5) * 10000 + math.floor(y*10000 + 0.5)))
        end
    else
        print("Could not get map info")
    end
end
