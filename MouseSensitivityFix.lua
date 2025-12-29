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

-- Event handler
MSF:RegisterEvent("ADDON_LOADED")
MSF:RegisterEvent("PLAYER_ENTERING_WORLD")
MSF:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "MouseSensitivityFix" then
        -- Silent load, message will show on PLAYER_ENTERING_WORLD
    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Delay application to ensure WoW has finished its override
        C_Timer.After(1.5, function()
            if MouseSensitivityFixDB.mouseSensitivity then
                SafeSetCVar("mouseSpeed", MouseSensitivityFixDB.mouseSensitivity)
                print(string.format("|cff00ffff[MSF]|r Mouse Sensitivity: |cff00ff00%.3f|r (type |cff00ff00/ms|r or |cff00ff00/mouse|r to edit)", MouseSensitivityFixDB.mouseSensitivity))
            end
            if MouseSensitivityFixDB.mouseLookSpeed then
                SafeSetCVar("cameraYawMoveSpeed", MouseSensitivityFixDB.mouseLookSpeed)
            end
        end)
    end
end)
