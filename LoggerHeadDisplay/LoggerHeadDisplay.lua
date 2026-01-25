local addonName, addon = ...
local LOGO_PATH = "Interface\\AddOns\\LoggerHeadDisplay\\Logo" -- place Logo.tga (128x128) in addon folder

-- Addon initialization
local LHD = CreateFrame("Frame", "LoggerHeadDisplayFrame")
LHD:RegisterEvent("ADDON_LOADED")
LHD:RegisterEvent("PLAYER_ENTERING_WORLD")

-- Default settings
local defaults = {
    point = "CENTER",
    relativePoint = "CENTER",
    xOffset = 472.86,
    yOffset = -540.05,
    width = 75,
    height = 12,
    fontSize = 12,
    font = "Fonts\\FRIZQT__.TTF", -- Friz Quadrata TT
    outline = "OUTLINE",
    locked = false,
}

local db
local dataObject
local ldb
local displayFrame

-- Initialize database
local function InitializeDB()
    if not LoggerHeadDisplayDB then
        LoggerHeadDisplayDB = {}
    end
    db = LoggerHeadDisplayDB
    
    -- Set defaults
    for k, v in pairs(defaults) do
        if db[k] == nil then
            db[k] = v
        end
    end
end

-- Create the display frame
local function CreateDisplayFrame()
    local frame = CreateFrame("Button", "LoggerHeadDisplayButton", UIParent)
    frame:SetSize(db.width, db.height)
    frame:SetPoint(db.point, UIParent, db.relativePoint, db.xOffset, db.yOffset)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForClicks("AnyUp")
    
    -- Background
    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints()
    frame.bg:SetColorTexture(0, 0, 0, 0.5)
    
    -- Icon
    frame.icon = frame:CreateTexture(nil, "ARTWORK")
    frame.icon:SetSize(db.height, db.height)
    frame.icon:SetPoint("LEFT", frame, "LEFT", 0, 0)
    
    -- Text
    frame.text = frame:CreateFontString(nil, "OVERLAY")
    frame.text:SetFont(db.font, db.fontSize, db.outline)
    frame.text:SetPoint("LEFT", frame.icon, "RIGHT", 2, 0)
    frame.text:SetPoint("RIGHT", frame, "RIGHT", -2, 0)
    frame.text:SetJustifyH("LEFT")
    frame.text:SetTextColor(1, 1, 1, 1)
    
    -- Value text (for displaying numeric values)
    frame.value = frame:CreateFontString(nil, "OVERLAY")
    frame.value:SetFont(db.font, db.fontSize, db.outline)
    frame.value:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 0)
    frame.value:SetJustifyH("RIGHT")
    frame.value:SetTextColor(1, 1, 1, 1)
    
    -- Dragging functionality (right-click to drag)
    frame:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" and not db.locked then
            self:StartMoving()
        end
    end)
    
    frame:SetScript("OnMouseUp", function(self, button)
        if button == "RightButton" then
            self:StopMovingOrSizing()
            local point, _, relativePoint, xOffset, yOffset = self:GetPoint()
            db.point = point
            db.relativePoint = relativePoint
            db.xOffset = xOffset
            db.yOffset = yOffset
        end
    end)
    
    frame:Show()
    displayFrame = frame
    return frame
end

-- Update the display from data object
local function UpdateDisplay()
    if not displayFrame or not dataObject then return end
    
    -- Update icon (fallback to bundled logo if LDB icon missing)
    local iconTexture = dataObject.icon or LOGO_PATH
    if iconTexture then
        displayFrame.icon:SetTexture(iconTexture)
        displayFrame.icon:Show()
    else
        displayFrame.icon:Hide()
    end
    
    -- Update text
    local text = dataObject.text or dataObject.label or ldb:GetNameByDataObject(dataObject) or "LoggerHead"
    displayFrame.text:SetText(text)
    
    -- Update value
    if dataObject.value then
        displayFrame.value:SetText(tostring(dataObject.value))
        displayFrame.value:Show()
    else
        displayFrame.value:Hide()
    end
end

-- Setup LDB integration
local function SetupLDB()
    ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
    if not ldb then
        print("|cffff0000LoggerHead Display:|r LibDataBroker-1.1 not found!")
        return
    end
    
    -- Try to get the LoggerHead data object
    dataObject = ldb:GetDataObjectByName("LoggerHead")
    
    if not dataObject then
        -- Wait for it to be created
        ldb.callbacks:RegisterCallback("LibDataBroker_DataObjectCreated", function(event, name, obj)
            if name == "LoggerHead" then
                dataObject = obj
                SetupDataObjectHandlers()
                UpdateDisplay()
            end
        end)
    else
        SetupDataObjectHandlers()
        UpdateDisplay()
    end
end

-- Setup handlers for the data object
function SetupDataObjectHandlers()
    if not dataObject or not displayFrame then return end
    
    -- Click handler (left-click to activate)
    displayFrame:SetScript("OnClick", function(self, button)
        if button == "LeftButton" and dataObject.OnClick then
            dataObject.OnClick(self, button)
            UpdateDisplay()
        end
    end)
    
    -- Tooltip handlers
    displayFrame:SetScript("OnEnter", function(self)
        if dataObject.OnEnter then
            dataObject.OnEnter(self)
        elseif dataObject.OnTooltipShow then
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
            GameTooltip:ClearLines()
            dataObject.OnTooltipShow(GameTooltip)
            GameTooltip:Show()
        end
    end)
    
    displayFrame:SetScript("OnLeave", function(self)
        if dataObject.OnLeave then
            dataObject.OnLeave(self)
        else
            GameTooltip:Hide()
        end
    end)
    
    -- Listen for attribute changes
    if ldb and ldb.callbacks then
        ldb.callbacks:RegisterCallback("LibDataBroker_AttributeChanged_LoggerHead", function(event, name, key, value, obj)
            UpdateDisplay()
        end)
    end
end

-- Event handler
LHD:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        InitializeDB()
        CreateDisplayFrame()
        SetupLDB()
    elseif event == "PLAYER_ENTERING_WORLD" then
        if displayFrame and dataObject then
            UpdateDisplay()
        end
    end
end)

-- Continuous update loop for real-time changes
local updateFrame = CreateFrame("Frame")
updateFrame:SetScript("OnUpdate", function(self)
    if displayFrame and dataObject then
        UpdateDisplay()
    end
end)

-- Slash commands
SLASH_LOGGERHEADDISPLAY1 = "/lhd"
SLASH_LOGGERHEADDISPLAY2 = "/loggerheaddisplay"

SlashCmdList["LOGGERHEADDISPLAY"] = function(msg)
    msg = string.lower(msg or "")
    
    if msg == "lock" then
        db.locked = true
        print("|cff00ff00LoggerHead Display:|r Frame locked")
    elseif msg == "unlock" then
        db.locked = false
        print("|cff00ff00LoggerHead Display:|r Frame unlocked - drag to move")
    elseif msg == "reset" then
        db.point = defaults.point
        db.relativePoint = defaults.relativePoint
        db.xOffset = defaults.xOffset
        db.yOffset = defaults.yOffset
        if displayFrame then
            displayFrame:ClearAllPoints()
            displayFrame:SetPoint(db.point, UIParent, db.relativePoint, db.xOffset, db.yOffset)
        end
        print("|cff00ff00LoggerHead Display:|r Position reset")
    elseif msg == "show" then
        if displayFrame then
            displayFrame:Show()
            print("|cff00ff00LoggerHead Display:|r Shown")
        end
    elseif msg == "hide" then
        if displayFrame then
            displayFrame:Hide()
            print("|cff00ff00LoggerHead Display:|r Hidden")
        end
    else
        print("|cff00ff00LoggerHead Display Commands:|r")
        print("  /lhd lock - Lock frame position")
        print("  /lhd unlock - Unlock frame to move")
        print("  /lhd reset - Reset position to default")
        print("  /lhd show - Show the display")
        print("  /lhd hide - Hide the display")
    end
end
