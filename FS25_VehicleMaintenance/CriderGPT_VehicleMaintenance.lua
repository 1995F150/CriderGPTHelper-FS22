-- CriderGPT_VehicleMaintenance.lua
-- Console-safe vehicle maintenance mod for FS25

-- Configurable costs
local BATTERY_RECHARGE_COST = 250
local BATTERY_REPLACE_COST = 800
local OIL_CHANGE_COST = 150
local ENGINE_REPAIR_BASE_COST = 1200

-- System variables
local batteryHealth = 100
local oilLevel = 100
local engineWear = 0

-- Save/load helpers
function saveMaintenanceData(xmlFile)
    setXMLInt(xmlFile, "vehicleMaintenance#batteryHealth", batteryHealth)
    setXMLInt(xmlFile, "vehicleMaintenance#oilLevel", oilLevel)
    setXMLInt(xmlFile, "vehicleMaintenance#engineWear", engineWear)
end

function loadMaintenanceData(xmlFile)
    batteryHealth = getXMLInt(xmlFile, "vehicleMaintenance#batteryHealth") or 100
    oilLevel = getXMLInt(xmlFile, "vehicleMaintenance#oilLevel") or 100
    engineWear = getXMLInt(xmlFile, "vehicleMaintenance#engineWear") or 0
end

-- BATTERY SYSTEM
function RechargeBattery()
    if batteryHealth < 100 then
        if g_currentMission.missionStats:getMoney() >= BATTERY_RECHARGE_COST then
            batteryHealth = 100
            g_currentMission.missionStats:removeMoney(BATTERY_RECHARGE_COST)
            print("[VehicleMaintenance] Battery recharged for $"..BATTERY_RECHARGE_COST)
        else
            print("[VehicleMaintenance] Not enough money to recharge battery.")
        end
    end
end

function ReplaceBattery()
    if g_currentMission.missionStats:getMoney() >= BATTERY_REPLACE_COST then
        batteryHealth = 100
        g_currentMission.missionStats:removeMoney(BATTERY_REPLACE_COST)
        print("[VehicleMaintenance] Battery replaced for $"..BATTERY_REPLACE_COST)
    else
        print("[VehicleMaintenance] Not enough money to replace battery.")
    end
end

-- OIL SYSTEM
function ChangeOil()
    if g_currentMission.missionStats:getMoney() >= OIL_CHANGE_COST then
        oilLevel = 100
        engineWear = math.max(engineWear - 10, 0)
        g_currentMission.missionStats:removeMoney(OIL_CHANGE_COST)
        print("[VehicleMaintenance] Oil changed for $"..OIL_CHANGE_COST)
    else
        print("[VehicleMaintenance] Not enough money to change oil.")
    end
end

function CheckOilStatus()
    if oilLevel < 5 then
        print("🛢️ Oil critically low.")
    elseif oilLevel < 20 then
        print("🛢️ Oil low.")
    else
        print("🛢️ Oil level OK.")
    end
end

-- ENGINE WEAR SYSTEM
function RepairEngine()
    local cost = ENGINE_REPAIR_BASE_COST + (engineWear * 10)
    if g_currentMission.missionStats:getMoney() >= cost then
        engineWear = 0
        g_currentMission.missionStats:removeMoney(cost)
        print("[VehicleMaintenance] Engine repaired for $"..cost)
    else
        print("[VehicleMaintenance] Not enough money to repair engine.")
    end
end

-- Event listeners (pseudo-code, replace with actual FS25 event hooks)
function onVehicleStart()
    -- Battery check
    if batteryHealth < 5 then
        print("🔋 Battery dead — vehicle will not start.")
        return false
    elseif batteryHealth < 25 then
        print("🔋 Battery weak — delayed cranking.")
        -- Add delay logic here
    end
    -- Oil check
    if oilLevel < 5 then
        print("🛢️ Oil critically low. Engine will not start.")
        return false
    elseif oilLevel < 20 then
        print("🛢️ Oil low. Engine performance reduced.")
    end
    -- Engine wear check
    if engineWear >= 100 then
        print("⚙️ Engine wear critical — cannot start.")
        return false
    elseif engineWear > 80 then
        print("⚙️ Engine wear high — random stalls possible.")
    end
    return true
end

function onVehicleUpdate(dt)
    -- Simulate battery drain
    batteryHealth = math.max(batteryHealth - (dt * 0.00001), 0)
    -- Simulate oil consumption
    oilLevel = math.max(oilLevel - (dt * 0.00002), 0)
    -- Engine wear increases with use and low oil
    if oilLevel < 20 then
        engineWear = math.min(engineWear + (dt * 0.0001), 100)
    else
        engineWear = math.min(engineWear + (dt * 0.00005), 100)
    end
end

-- HUD feedback (console-safe)
function showMaintenanceAlerts()
    if batteryHealth < 25 then print("🔋 Battery weak — may fail soon.") end
    if oilLevel < 5 then print("🛢️ Oil critically low.") end
    if engineWear > 80 then print("⚙️ Engine wear critical — service required.") end
end

-- Placeholders for future systems
local coolantLevel = 100 -- TODO
local transmissionWear = 0 -- TODO
local tireWear = 0 -- TODO

-- Integration hooks for other CriderGPT mods
function registerWithCriderGPT()
    if _G.CriderGPTHelper ~= nil and type(_G.CriderGPTHelper.registerMaintenanceMod) == "function" then
        _G.CriderGPTHelper.registerMaintenanceMod(self)
    end
end

-- Debug log
print("[VehicleMaintenance] Mod loaded. All systems initialized.")
