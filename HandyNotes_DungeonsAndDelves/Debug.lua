-- Debug helper for adding new points.
-- /hnd_debug prints the player's map and, if shown, the open world map (they can be different map IDs).

local function PrintMap(mapID, source)
    local mapInfo = C_Map.GetMapInfo(mapID)
    if not mapInfo then
        print(("  %s: could not get map info for ID %s"):format(source, tostring(mapID)))
        return
    end

    print(("  %s: %s (ID %d, type %s)"):format(source, mapInfo.name or "?", mapID, tostring(mapInfo.mapType)))
    if mapInfo.parentMapID and mapInfo.parentMapID > 0 then
        local parentInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
        if parentInfo then
            print(("    Parent: %s (ID %d)"):format(parentInfo.name or "?", mapInfo.parentMapID))
        end
    end

    local position = C_Map.GetPlayerMapPosition(mapID, "player")
    if not position then
        print("    Player position is not available on this map")
        return
    end

    local x, y = position:GetXY()
    local px, py = math.floor(x * 10000 + 0.5), math.floor(y * 10000 + 0.5)
    print(("    Position: %.2f, %.2f"):format(px / 100, py / 100))
    print(("    Data.lua: [%d] = { label = \"\", note = \"\", icon = ICON },"):format(px * 10000 + py))
    print(("    /way #%d %.1f %.1f"):format(mapID, px / 100, py / 100))
end

SLASH_HNDDEBUG1 = "/hnd_debug"
SlashCmdList["HNDDEBUG"] = function()
    print("HandyNotes_DungeonsAndDelves Debug:")

    local playerMapID = C_Map.GetBestMapForUnit("player")
    if playerMapID then
        PrintMap(playerMapID, "Player map")
    end

    if WorldMapFrame and WorldMapFrame:IsShown() then
        local openMapID = WorldMapFrame:GetMapID()
        if openMapID and openMapID ~= playerMapID then
            PrintMap(openMapID, "Open world map")
        end
    end
end
