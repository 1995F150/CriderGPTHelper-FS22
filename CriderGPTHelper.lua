-- ================================================================
-- CriderGPT Helper (v1.3.2.0)
-- Author: Jessie Crider
-- Purpose: Replace AI Worker UI text with "CriderGPT" and show HUD alerts
-- Compatible with FS22 (descVersion 66)
-- ================================================================

CriderGPTHelper = {}
local CriderGPTHelper_mt = Class(CriderGPTHelper)

function CriderGPTHelper:new(customMt)
    local self = setmetatable({}, customMt or CriderGPTHelper_mt)
    print("✅ [CriderGPT Helper] Mod initialized successfully.")
    return self
end

-- ================================================================
-- 🧠 Notification Helper
-- ================================================================
function CriderGPTHelper:showNotification(message)
    if g_currentMission ~= nil then
        g_currentMission:addExtraPrintText("CriderGPT: " .. message)
    end
end

-- ================================================================
-- 🚜 Override AI Worker Start / Stop
-- ================================================================
local originalStartAIJob = AIVehicleUtil.startJob
AIVehicleUtil.startJob = function(vehicle, ...)
    if vehicle ~= nil and g_currentMission ~= nil then
        g_currentMission:addExtraPrintText("CriderGPT: Worker hired and ready!")
        print("🟢 [CriderGPT Helper] Worker hire event triggered.")
    end
    return originalStartAIJob(vehicle, ...)
end

local originalStopAIJob = AIVehicleUtil.stopCurrentAIJob
AIVehicleUtil.stopCurrentAIJob = function(vehicle, noEventSend)
    if vehicle ~= nil and g_currentMission ~= nil then
        g_currentMission:addExtraPrintText("CriderGPT: Worker dismissed — taking a break.")
        print("🔴 [CriderGPT Helper] Worker dismissed event triggered.")
    end
    return originalStopAIJob(vehicle, noEventSend)
end

-- ================================================================
-- 🧩 Override Localization Texts (UI Control Hints)
-- ================================================================
-- Some versions of FS22 use "input_AI_START"/"input_AI_STOP" instead of HIRE/DISMISS
local oldGetText = g_i18n.getText

function g_i18n:getText(textName, ...)
    if textName == "input_AI_HIRE" or textName == "input_AI_START" then
        return "Hire CriderGPT"
    elseif textName == "input_AI_DISMISS" or textName == "input_AI_STOP" then
        return "Dismiss CriderGPT"
    end
    return oldGetText(self, textName, ...)
end

-- ================================================================
-- ⛽ Fuel Monitoring System
-- ================================================================
function CriderGPTHelper:update(dt)
    local vehicle = g_currentMission and g_currentMission.controlledVehicle
    if vehicle ~= nil and vehicle.getConsumerFillUnitFillLevel ~= nil then
        local fuelLevel = vehicle:getConsumerFillUnitFillLevel(FillType.DIESEL)
        if fuelLevel ~= nil and fuelLevel < 50 then
            self:showNotification("Fuel is running low! (" .. math.floor(fuelLevel) .. " L left)")
        end
    end
end

-- ================================================================
-- 🏁 Register Mod Event
-- ================================================================
addModEventListener(CriderGPTHelper:new())

print("✅ [CriderGPT Helper] Ready — UI override and alerts active.")
