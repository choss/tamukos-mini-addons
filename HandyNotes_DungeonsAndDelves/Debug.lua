-- Debug helper for adding new points.
-- /hnd_debug uses the map you are standing in, or the open world map if it is shown.

SLASH_HNDDEBUG1 = "/hnd_debug"
SlashCmdList["HNDDEBUG"] = function()
    local mapID, source
    if WorldMapFrame and WorldMapFrame:IsShown() then
        mapID, source = WorldMapFrame:GetMapID(), "open world map"
    else
        mapID, source = C_Map.GetBestMapForUnit("player"), "player location"
    end

    local mapInfo = mapID and C_Map.GetMapInfo(mapID)
    if not mapInfo then
        print("HandyNotes_DungeonsAndDelves: could not get map info")
        return
    end

    print("HandyNotes_DungeonsAndDelves Debug:")
    print(("  Map: %s (ID %d, type %s, from %s)"):format(mapInfo.name or "?", mapID, tostring(mapInfo.mapType), source))
    if mapInfo.parentMapID and mapInfo.parentMapID > 0 then
        local parentInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
        if parentInfo then
            print(("  Parent: %s (ID %d)"):format(parentInfo.name or "?", mapInfo.parentMapID))
        end
    end

    local position = C_Map.GetPlayerMapPosition(mapID, "player")
    if not position then
        print("  Player position is not available on this map")
        return
    end

    local x, y = position:GetXY()
    local px, py = math.floor(x * 10000 + 0.5), math.floor(y * 10000 + 0.5)
    print(("  Position: %.2f, %.2f"):format(px / 100, py / 100))
    print(("  Data.lua: [%d] = { label = \"\", note = \"\", icon = ICON },"):format(px * 10000 + py))
    print(("  /way #%d %.1f %.1f"):format(mapID, px / 100, py / 100))
end
