-- Mouse Sensitivity Fix
-- Extends the mouse sensitivity range to allow for much lower values

local MSF = CreateFrame("Frame")
local MIN_SENSITIVITY = 0.01  -- Lowest allowed (default is 0.5)
local MAX_SENSITIVITY = 3.0   -- Highest allowed (default is 1.5)

-- Saved variables
MouseSensitivityFixDB = MouseSensitivityFixDB or {
    mouseSensitivity = 0.5,
    mouseLookSpeed = 90
}

-- Safe wrapper for SetCVar that doesn't taint
local function SafeSetCVar(cvar, value)
    if cvar == "mouseSpeed" then
        local numValue = tonumber(value)
        if numValue then
            -- Clamp to our extended range
            numValue = math.max(MIN_SENSITIVITY, math.min(MAX_SENSITIVITY, numValue))
            MouseSensitivityFixDB.mouseSensitivity = numValue
            -- Directly set the cvar without hooking
            SetCVar(cvar, tostring(numValue))
            return true
        end
    elseif cvar == "cameraYawMoveSpeed" then
        local numValue = tonumber(value)
        if numValue then
            MouseSensitivityFixDB.mouseLookSpeed = numValue
            SetCVar(cvar, tostring(numValue))
            return true
        end
    end
    return false
end

-- Slash commands for manual adjustment
SLASH_MOUSESENS1 = "/mousesens"
SLASH_MOUSESENS2 = "/ms"
SLASH_MOUSESENS3 = "/mouse"
SlashCmdList["MOUSESENS"] = function(msg)
    local value = tonumber(msg)
    if value then
        SafeSetCVar("mouseSpeed", value)
        print(string.format("|cff00ff00Mouse Sensitivity set to: %.3f|r", value))
    else
        local current = GetCVar("mouseSpeed")
        print("|cff00ffffMouse Sensitivity Fix|r")
        print(string.format("Current sensitivity: |cff00ff00%.3f|r", tonumber(current) or 0.5))
        print(string.format("Range: |cffff0000%.2f|r to |cffff0000%.2f|r", MIN_SENSITIVITY, MAX_SENSITIVITY))
        print("Usage: |cff00ff00/mousesens <value>|r, |cff00ff00/ms <value>|r, or |cff00ff00/mouse <value>|r")
        print("Example:")
        print("  |cff00ff00/ms 0.2|r - |cffffaa00Start Here|r")
        print(" ")
        print("|cff888888Mouse Look Speed:|r |cff00ff00/mouselook <value>|r or |cff00ff00/ml <value>|r")
        print("|cff888888Note: Mouse look appears to have negligible/no effect on gameplay|r")
    end
end

-- Slash commands for mouse look speed
SLASH_MOUSELOOK1 = "/mouselook"
SLASH_MOUSELOOK2 = "/ml"
SlashCmdList["MOUSELOOK"] = function(msg)
    local value = tonumber(msg)
    if value then
        value = math.max(1, math.min(270, value))
        SafeSetCVar("cameraYawMoveSpeed", value)
        print(string.format("|cff00ff00Mouse Look Speed set to: %d|r", value))
    else
        local current = GetCVar("cameraYawMoveSpeed")
        print("|cff00ffffMouse Look Speed|r")
        print(string.format("Current speed: |cff00ff00%s|r", current))
        print("Range: |cffff00001|r to |cffff0000270|r (default 90)")
        print("Usage: |cff00ff00/mouselook <value>|r or |cff00ff00/ml <value>|r")
    end
end

-- Config panel slash command
SLASH_MOUSESENSCONFIG1 = "/msconfig"
SlashCmdList["MOUSESENSCONFIG"] = function()
    InterfaceOptionsFrame_OpenToCategory("Mouse Sensitivity Fix")
end

-- Event handler
MSF:RegisterEvent("ADDON_LOADED")
MSF:RegisterEvent("PLAYER_LOGIN")
MSF:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "MouseSensitivityFix" then
        -- Restore saved settings
        if MouseSensitivityFixDB.mouseSensitivity then
            SafeSetCVar("mouseSpeed", MouseSensitivityFixDB.mouseSensitivity)
        end

        print("|cff00ffffMouse Sensitivity Fix loaded!|r")
        print("Type |cff00ff00/mousesens|r or |cff00ff00/ms|r for help")
    elseif event == "PLAYER_LOGIN" then
        -- Apply settings on login
        if MouseSensitivityFixDB.mouseSensitivity then
            SafeSetCVar("mouseSpeed", MouseSensitivityFixDB.mouseSensitivity)
        end
        if MouseSensitivityFixDB.mouseLookSpeed then
            SafeSetCVar("cameraYawMoveSpeed", MouseSensitivityFixDB.mouseLookSpeed)
        end
    end
end)

-- Create a simple config panel
local config = CreateFrame("Frame", "MouseSensFixConfig", UIParent)
config.name = "Mouse Sensitivity Fix"

local title = config:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("Mouse Sensitivity Fix")

local desc = config:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
desc:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
desc:SetWidth(600)
desc:SetJustifyH("LEFT")
desc:SetText("This addon allows you to set mouse sensitivity below the normal minimum of 0.5.\nUse /ms <value> to set sensitivity between 0.01 and 3.0")

local currentText = config:CreateFontString(nil, "ARTWORK", "GameFontNormal")
currentText:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -20)

local slider = CreateFrame("Slider", "MSFSlider", config, "OptionsSliderTemplate")
slider:SetPoint("TOPLEFT", currentText, "BOTTOMLEFT", 0, -20)
slider:SetMinMaxValues(MIN_SENSITIVITY * 100, MAX_SENSITIVITY * 100)
slider:SetValueStep(1)
slider:SetWidth(400)
slider:SetHeight(20)
getglobal(slider:GetName() .. 'Low'):SetText(string.format("%.2f", MIN_SENSITIVITY))
getglobal(slider:GetName() .. 'High'):SetText(string.format("%.2f", MAX_SENSITIVITY))
getglobal(slider:GetName() .. 'Text'):SetText("Mouse Sensitivity")

slider:SetScript("OnValueChanged", function(self, value)
    local actualValue = value / 100
    SafeSetCVar("mouseSpeed", actualValue)
    currentText:SetText(string.format("Current Value: %.3f", actualValue))
end)

config:SetScript("OnShow", function(self)
    local current = tonumber(GetCVar("mouseSpeed")) or 0.5
    slider:SetValue(current * 100)
    currentText:SetText(string.format("Current Value: %.3f", current))
end)

InterfaceOptions_AddCategory(config)

print("|cff00ff00MouseSensitivityFix initialized|r")
