local addonName, ns = ...

-- ----------------------------------------------------------------------------
-- Constants & Configuration
-- ----------------------------------------------------------------------------
local HEADER_HEIGHT = 50
local ROW_HEIGHT = 20
local ROW_SPACING = 2
local WIDTH = 250
local PADDING = 10

local COLORS = {
    TIMER_NORMAL = {1, 1, 1, 1},
    TIMER_WARNING = {1, 0.5, 0.5, 1}, -- Low time
    TIMER_EXPIRED = {1, 0.2, 0.2, 1},
    
    TEXT_COMPLETE = {0.2, 1, 0.2, 1}, -- Green
    TEXT_PENDING = {0.6, 0.6, 0.6, 1}, -- Grey/White
    TEXT_HEADER = {1, 0.82, 0, 1},    -- Gold/Yellowish
    
    BAR_BG = {0.2, 0.2, 0.2, 1},
    BAR_FILL = {0.9, 0.9, 0.9, 1},    -- Angry Keystones usually uses a light grey/white bar for forces, or class color. Will use white/grey.
}

-- Using standard angry colors (Red/Enemy forces typically standard statusbar)
-- Actually Angry Keystones Forces bar is often simple.
COLORS.BAR_FILL = {0.8, 0.2, 0.2, 1} -- Redish for enemies

local BACKDROP = {
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
}

-- ----------------------------------------------------------------------------
-- Variables
-- ----------------------------------------------------------------------------
-- SavedVariables: MPTimerDB
MPTimerDB = MPTimerDB or {}

local frame
local rows = {}
local currentMapID
local timeLimit = 0
local deathCount = 0

-- ----------------------------------------------------------------------------
-- Helper Functions
-- ----------------------------------------------------------------------------
local function FormatTime(seconds)
    if not seconds then return "--:--" end
    if seconds < 0 then
        return "-" .. FormatTime(-seconds)
    end
    local m = math.floor(seconds / 60)
    local s = math.floor(seconds % 60)
    return string.format("%02d:%02d", m, s)
end

local function GetMyTimer()
    -- GetWorldElapsedTime(1) returns time since run start in seconds
    local _, timeCM = GetWorldElapsedTime(1)
    return timeCM or 0
end

local function GetStepInfo()
    if C_ScenarioInfo and C_ScenarioInfo.GetStepInfo then
        return C_ScenarioInfo.GetStepInfo()
    end
    if C_Scenario and C_Scenario.GetStepInfo then
        return C_Scenario.GetStepInfo()
    end
end

local function GetCriteriaInfo(index)
    if C_ScenarioInfo and C_ScenarioInfo.GetCriteriaInfo then
        return C_ScenarioInfo.GetCriteriaInfo(index)
    end
    if C_Scenario and C_Scenario.GetCriteriaInfo then
        return C_Scenario.GetCriteriaInfo(index)
    end
end

local function UpdateFrameSize()
    local numActiveRows = 0
    for _, row in ipairs(rows) do
        if row:IsShown() then numActiveRows = numActiveRows + 1 end
    end
    
    local totalHeight = HEADER_HEIGHT + (numActiveRows * (ROW_HEIGHT + ROW_SPACING)) + PADDING
    -- Ensure at least header is visible
    if totalHeight < HEADER_HEIGHT + PADDING then totalHeight = HEADER_HEIGHT + PADDING end
    
    frame:SetHeight(totalHeight)
end

-- ----------------------------------------------------------------------------
-- Frame Creation
-- ----------------------------------------------------------------------------
local function CreateMainFrame()
    local f = CreateFrame("Frame", "MPTimerMainFrame", UIParent, "BackdropTemplate")
    f:SetSize(WIDTH, HEADER_HEIGHT)
    f:SetPoint("CENTER")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:SetClampedToScreen(true)
    
    f:SetBackdrop(BACKDROP)
    f:SetBackdropColor(0, 0, 0, 0.8)
    f:SetBackdropBorderColor(0, 0, 0, 1)

    -- Header: Time (Left Big)
    f.TimerText = f:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
    f.TimerText:SetPoint("TOPLEFT", f, "TOPLEFT", PADDING, -PADDING/2)
    f.TimerText:SetText("00:00")

    -- Header: Forces (Right)
    f.ForcesBar = CreateFrame("StatusBar", nil, f)
    f.ForcesBar:SetSize(90, 14)
    f.ForcesBar:SetPoint("TOPRIGHT", f, "TOPRIGHT", -PADDING, -PADDING - 2)
    f.ForcesBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    f.ForcesBar:SetStatusBarColor(unpack(COLORS.BAR_FILL))
    f.ForcesBar:SetMinMaxValues(0, 100)
    f.ForcesBar:SetValue(0)
    
    f.ForcesBar.bg = f.ForcesBar:CreateTexture(nil, "BACKGROUND")
    f.ForcesBar.bg:SetAllPoints()
    f.ForcesBar.bg:SetColorTexture(unpack(COLORS.BAR_BG))

    f.ForcesText = f.ForcesBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    f.ForcesText:SetPoint("CENTER", f.ForcesBar, "CENTER", 0, 0)
    f.ForcesText:SetText("0%")

    -- Header: Next Chest (Bottom Left of Header Area)
    f.ChestText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.ChestText:SetPoint("BOTTOMLEFT", f, "TOPLEFT", PADDING, -HEADER_HEIGHT + 5)
    f.ChestText:SetText("+3")

    -- Header: Deaths (Bottom Right of Header Area)
    f.DeathText = f:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    f.DeathText:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -PADDING, -HEADER_HEIGHT + 5)
    f.DeathText:SetText("D: 0")

    -- Separator
    local line = f:CreateTexture(nil, "ARTWORK")
    line:SetHeight(1)
    line:SetColorTexture(1, 1, 1, 0.2)
    line:SetPoint("TOPLEFT", f, "TOPLEFT", 4, -HEADER_HEIGHT)
    line:SetPoint("TOPRIGHT", f, "TOPRIGHT", -4, -HEADER_HEIGHT)

    -- Container for rows
    f.rowContainer = CreateFrame("Frame", nil, f)
    f.rowContainer:SetPoint("TOPLEFT", f, "TOPLEFT", 0, -HEADER_HEIGHT)
    f.rowContainer:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", 0, 0)

    f:Hide()
    return f
end

local function CreateRow(index)
    local row = CreateFrame("Frame", nil, frame.rowContainer)
    row:SetSize(WIDTH - (PADDING * 2), ROW_HEIGHT)
    row:SetPoint("TOPLEFT", frame.rowContainer, "TOPLEFT", PADDING, -((index - 1) * (ROW_HEIGHT + ROW_SPACING)) - 5)

    row.Name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.Name:SetPoint("LEFT", 0, 0)
    row.Name:SetTextColor(unpack(COLORS.TEXT_PENDING))
    row.Name:SetJustifyH("LEFT")
    row.Name:SetWidth(170)
    row.Name:SetWordWrap(false)

    row.Time = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    row.Time:SetPoint("RIGHT", 0, 0)
    row.Time:SetTextColor(unpack(COLORS.TEXT_PENDING))

    rows[index] = row
    return row
end

-- ----------------------------------------------------------------------------
-- Logic
-- ----------------------------------------------------------------------------
local function ResetSplits()
    MPTimerDB.splits = {}
    MPTimerDB.runId = nil
end

local function UpdateCriteria()
    local _, _, numCriteria = GetStepInfo()
    if not numCriteria then return end

    local bossIndex = 1
    
    for i = 1, numCriteria do
        local description, criteriaType, completed, quantity, totalQuantity, flags, assetID, quantityString, criteriaID, duration, elapsed, criteriaFailed, isWeightedProgress = GetCriteriaInfo(i)
        
        if isWeightedProgress then
            -- Enemy Forces
            local percent = 0
            if totalQuantity > 0 then
                percent = (quantity / totalQuantity) * 100
            end
            if percent > 100 then percent = 100 end
            
            frame.ForcesBar:SetValue(percent)
            frame.ForcesText:SetText(string.format("%.1f%%", percent))
            
            if percent >= 100 then
                 frame.ForcesText:SetTextColor(0, 1, 0)
                 frame.ForcesBar:SetStatusBarColor(0, 1, 0)
            else
                 frame.ForcesText:SetTextColor(1, 1, 1)
                 frame.ForcesBar:SetStatusBarColor(unpack(COLORS.BAR_FILL))
            end
        else
            -- Boss / Objective
            local row = rows[bossIndex] or CreateRow(bossIndex)
            row:Show()
            
            -- Sometimes description is empty for hidden criteria, skip them if needed?
            -- Usually all displayed criteria are relevant.
            row.Name:SetText(description)
            
            -- Check for split time
            local splitTime = MPTimerDB.splits[criteriaID]
            
            -- If we just completed it and don't have a split, save it
            if completed and not splitTime then
                local currentTimer = GetMyTimer()
                if currentTimer > 0 then
                    splitTime = currentTimer
                    MPTimerDB.splits[criteriaID] = splitTime
                end
            end
            
            if completed then
                row.Name:SetTextColor(unpack(COLORS.TEXT_COMPLETE))
                row.Time:SetTextColor(unpack(COLORS.TEXT_COMPLETE))
                -- If we have a recorded split, show it, otherwise show a checkmark or similar?
                -- Requirement: "Display Split Time (Right)"
                if splitTime then
                    row.Time:SetText(FormatTime(splitTime))
                else
                    row.Time:SetText("Done") -- Fallback if reload happened before completion logged
                end
            else
                row.Name:SetTextColor(unpack(COLORS.TEXT_PENDING))
                row.Time:SetTextColor(unpack(COLORS.TEXT_PENDING))
                row.Time:SetText("")
            end
            
            bossIndex = bossIndex + 1
        end
    end
    
    -- Hide unused rows
    for i = bossIndex, #rows do
        rows[i]:Hide()
    end
    
    UpdateFrameSize()
end

local function UpdateTimers()
    local timer = GetMyTimer()
    if not timer then return end

    -- Main Timer
    frame.TimerText:SetText(FormatTime(timer))
    if timeLimit and timer > timeLimit then
        frame.TimerText:SetTextColor(unpack(COLORS.TIMER_EXPIRED))
    else
        frame.TimerText:SetTextColor(unpack(COLORS.TIMER_NORMAL))
    end

    -- Chest Timer calc
    if timeLimit and timeLimit > 0 then
        -- Standard Mythic+ rules
        local limit3 = timeLimit * 0.6
        local limit2 = timeLimit * 0.8
        
        local text = ""
        local color = {1, 1, 1}
        
        if timer < limit3 then
            text = string.format("+3: %s", FormatTime(limit3 - timer))
            color = {0, 1, 0} -- Green
        elseif timer < limit2 then
            text = string.format("+2: %s", FormatTime(limit2 - timer))
            color = {1, 1, 0} -- Yellow
        elseif timer < timeLimit then
            text = string.format("+1: %s", FormatTime(timeLimit - timer))
            color = {1, 1, 1} -- White
        else
            text = "Depleted"
            color = {0.5, 0.5, 0.5} -- Gray
        end
        
        frame.ChestText:SetText(text)
        frame.ChestText:SetTextColor(unpack(color))
    else
        frame.ChestText:SetText("")
    end
end

local function UpdateDeathCount()
    local count, timeLost = C_ChallengeMode.GetDeathCount()
    deathCount = count or 0
    frame.DeathText:SetText("D: " .. deathCount)
    if deathCount > 0 then
        frame.DeathText:SetTextColor(unpack(COLORS.TIMER_EXPIRED))
    else
        frame.DeathText:SetTextColor(1, 1, 1)
    end
end

local function OnUpdate(self, elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed >= 0.1 then
        UpdateTimers()
        self.elapsed = 0
    end
end

local function Initialize()
    frame = CreateMainFrame()
    frame:SetScript("OnUpdate", OnUpdate)
    
    -- Initialize DB ensure structure
    if not MPTimerDB.splits then MPTimerDB.splits = {} end
    
    -- Check if we are currently in a run (reload)
    local _, _, difficulty = GetInstanceInfo()
    if difficulty == 8 then -- Mythic+
        local level = C_ChallengeMode.GetActiveKeystoneInfo()
        if level and level > 0 then
            -- We are in a key
            local mapID = C_Map.GetBestMapForUnit("player")
            if mapID then
                _, _, timeLimit = C_ChallengeMode.GetMapUIInfo(mapID)
            end
            
            frame:Show()
            UpdateCriteria()
            UpdateDeathCount()
        end
    end
end

-- ----------------------------------------------------------------------------
-- Events
-- ----------------------------------------------------------------------------
local eventHandler = CreateFrame("Frame")
eventHandler:RegisterEvent("ADDON_LOADED")
eventHandler:RegisterEvent("CHALLENGE_MODE_START")
eventHandler:RegisterEvent("SCENARIO_CRITERIA_UPDATE")
eventHandler:RegisterEvent("CHALLENGE_MODE_DEATH_COUNT_UPDATED")
eventHandler:RegisterEvent("PLAYER_ENTERING_WORLD")
eventHandler:RegisterEvent("CHALLENGE_MODE_RESET")

eventHandler:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" and ... == addonName then
        Initialize()
        
    elseif event == "CHALLENGE_MODE_START" then
        local mapID = ...
        if mapID then
             _, _, timeLimit = C_ChallengeMode.GetMapUIInfo(mapID)
        else
             local bestMap = C_Map.GetBestMapForUnit("player")
             if bestMap then _, _, timeLimit = C_ChallengeMode.GetMapUIInfo(bestMap) end
        end
        ResetSplits()
        UpdateDeathCount()
        UpdateCriteria()
        frame:Show()
        
    elseif event == "SCENARIO_CRITERIA_UPDATE" then
        if frame and frame:IsShown() then
            UpdateCriteria()
        end
        
    elseif event == "CHALLENGE_MODE_DEATH_COUNT_UPDATED" then
        if frame and frame:IsShown() then
            UpdateDeathCount()
        end
        
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Re-check environment
        local _, _, difficulty = GetInstanceInfo()
        if difficulty == 8 then
            frame:Show()
            UpdateCriteria()
            UpdateDeathCount()
            -- Re-fetch time limit if needed
            local mapID = C_Map.GetBestMapForUnit("player")
             if mapID then
                local _, _, limit = C_ChallengeMode.GetMapUIInfo(mapID)
                if limit then timeLimit = limit end
             end
        else
            if frame then frame:Hide() end
        end
        
    elseif event == "CHALLENGE_MODE_RESET" then
        if frame then frame:Hide() end
    end
end)

-- ----------------------------------------------------------------------------
-- Slash Command
-- ----------------------------------------------------------------------------
SLASH_MPTIMER1 = "/mpt"
SlashCmdList["MPTIMER"] = function(msg)
    if frame:IsShown() then
        frame:Hide()
        print("MPTimer: Hidden")
    else
        Initialize() -- Just in case not initialized
        frame:Show()
        -- Mock data for testing visuals
        timeLimit = 1800
        UpdateCriteria() -- Will fail if not in scenario, but shows frame
        print("MPTimer: Shown (May be empty if not in dungeon)")
        
        -- Force resize for demo
        frame:SetHeight(HEADER_HEIGHT + 30)
    end
end
