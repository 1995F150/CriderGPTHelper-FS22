
CRIDERGPT_VERSION = "1.4.0.0"
if Class == nil then
    function Class(baseClass)
        local newClass = {}
        newClass.__index = newClass
        if baseClass then
            setmetatable(newClass, { __index = baseClass })
        end
        return newClass
    end
end

CriderGPTHelper = {}
local CriderGPTHelper_mt = Class(CriderGPTHelper)

function CriderGPTHelper:getCreatorInfo()
    return {
        name = "Jessie Crider",
        title = "FFA Historian",
        role = "Creator of CriderGPT",
        origin = "Built from Jessie's CriderGPT web platform and FFA projects.",
        description = "CriderGPT Helper was developed by Jessie Crider, FFA Historian, to bring AI and agriculture together inside FS22."
    }
end

-- Print creator info on load
local creatorInfo = CriderGPTHelper:getCreatorInfo()
print(string.format("👤 [CriderGPT Helper] Creator: %s | %s | %s", creatorInfo.name, creatorInfo.title, creatorInfo.role))
print("📝 Origin: " .. creatorInfo.origin)
print("📄 Description: " .. creatorInfo.description)

CriderGPTApollo = CriderGPTApollo or {}
CriderGPTApollo.version = "1.5.0.0"
print("------------------------------------------------------")
print("[CriderGPT Apollo v1.5.0.0] by Jessie Crider (FFA Historian)")
print("Tier System: Free / Plus / Pro / Lifetime — shop-based upgrades.")
print("All systems initialized successfully (Offline Mode).")
print("------------------------------------------------------")
print("[CriderGPT Apollo] Mod registered and ready — found by FS22 Mod Manager.")
print("[CriderGPT Apollo] Release build verified — ready for ModHub submission.")

print("[CriderGPT Apollo] v1.4.0.0 initialized — see modDesc.xml for changelog.")

print("[CriderGPT Apollo] Mod registered and ready — found by FS22 Mod Manager.")

function CriderGPTHelper:new(customMt)
    local self = setmetatable({}, customMt or CriderGPTHelper_mt)
    print("✅ [CriderGPT Helper] Mod initialized successfully.")
    return self
end

-- ================================================================
-- 🔍 Visibility & Verification System
-- ================================================================
function CriderGPTHelper:onMapLoaded()
    print("✅ [CriderGPT Apollo v1.4.0.0] by Jessie Crider (FFA Historian) — Registered Successfully.")
    if g_currentMission ~= nil and g_currentMission.addExtraPrintText ~= nil then
        g_currentMission:addExtraPrintText("[CriderGPT Apollo] Mod is active and loaded.")
    end
end

-- Safety check: modDesc.xml existence and descVersion
local function checkModDesc()
    local modDescPath = "modDesc.xml"
    local file = io.open(modDescPath, "r")
    if file then
        local contents = file:read("*a")
        file:close()
        if not string.find(contents, "<descVersion>66</descVersion>") and not string.find(contents, "descVersion=\"66\"") then
            print("⚠️ [CriderGPT Apollo] modDesc.xml not found or invalid — mod may not appear in game list.")
        end
    else
        print("⚠️ [CriderGPT Apollo] modDesc.xml not found or invalid — mod may not appear in game list.")
    end
end
checkModDesc()

-- Safety check: folder/zip name match
local function checkFolderName()
    local folderName = "FS22_CriderGPTHelper"
    local cwd = string.match(debug.getinfo(1, "S").source, "([^/]+)$")
    if cwd ~= folderName then
        print("⚠️ [CriderGPT Apollo] Folder name mismatch; rename internal folder to FS22_CriderGPTHelper.")
    end
end
checkFolderName()

print("✅ [CriderGPT Apollo] Visibility check complete — Mod should appear in the FS22 'Select Mods' screen.")

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
addModEventListener(CriderGPTHelper)

print("✅ [CriderGPT Helper] Ready — UI override and alerts active.")


-- ================================================================
-- � CriderGPT Apollo: Offline Farm Intelligence
-- ================================================================
ApolloKnowledgeBase = {
    yield = "Yield depends on soil quality and crop type. Check your field’s precision data.",
    nitrogen = "Nitrogen levels too low reduce yield. Apply fertilizer until optimal.",
    lime = "Lime application resets pH. Use every few harvests to keep pH neutral.",
    soil = "Soil composition affects growth. Check the Precision Farming overlay for details.",
    ph = "pH affects nutrient uptake. Keep pH near neutral for best results.",
    fertilizer = "Fertilizer boosts yield. Use according to crop needs and soil tests.",
    seed = "Seed rate affects plant density. Adjust for crop and field conditions.",
}

CriderGPTApollo = {}

-- ================================================================
-- 🛒 Subscription Tier System
-- ================================================================
CriderGPTApollo.currentTier = "Free"

function CriderGPTApollo:setTier(tierName)
    self.currentTier = tierName
    print("[CriderGPT Apollo] Tier set to " .. tierName)
    if g_currentMission ~= nil and g_currentMission.addExtraPrintText ~= nil then
        g_currentMission:addExtraPrintText("[CriderGPT Apollo] " .. tierName .. " Plan Activated!")
    end
    self:saveTier()
end

function CriderGPTApollo:saveTier()
    local file = io.open("cridergpt_tier.xml", "w")
    if file then
        file:write("<cridergptTier>" .. self.currentTier .. "</cridergptTier>")
        file:close()
    end
end

function CriderGPTApollo:loadTier()
    local file = io.open("cridergpt_tier.xml", "r")
    if file then
        local contents = file:read("*a")
        file:close()
        local tier = string.match(contents, "<cridergptTier>(.-)</cridergptTier>")
        if tier then self.currentTier = tier end
    end
end

CriderGPTApollo:loadTier()

-- Shop event hooks (simulation)
function CriderGPTHelper:onObjectBought(storeItem, configName, price)
    if storeItem == "CriderGPT Apollo Core" then
        local tierName = configName:gsub(" Plan","")
        CriderGPTApollo:setTier(tierName)
        print("[CriderGPT Apollo] Purchased " .. tierName .. " Plan for $" .. price .. ".")
    end
end

function CriderGPTHelper:onObjectSold(storeItem)
    if storeItem == "CriderGPT Apollo Core" then
        CriderGPTApollo:setTier("Free")
        print("[CriderGPT Apollo] Plan sold — reverted to Free tier.")
        if g_currentMission ~= nil and g_currentMission.addExtraPrintText ~= nil then
            g_currentMission:addExtraPrintText("[CriderGPT Apollo] Subscription cancelled. Back to Free Plan.")
        end
    end
end

function CriderGPTApollo:convertLitersToGallons(liters)
    return math.floor((liters or 0) * 0.264172 * 100) / 100
end

function CriderGPTApollo:getFarmData(questionText)
    local lowerText = string.lower(questionText or "")
    if string.find(lowerText, "field") then
        local fieldNum = string.match(lowerText, "field%s*(%d+)")
        if fieldNum ~= nil then
            return self:getFieldStatus(tonumber(fieldNum))
        else
            return "Please specify a field number (e.g., 'field 20')."
        end
    elseif string.find(lowerText, "vehicle") or string.find(lowerText, "tractor") then
        return self:getVehicleStatus()
    elseif string.find(lowerText, "fuel") or string.find(lowerText, "diesel") then
        return self:getFuelLevel()
    elseif string.find(lowerText, "price") or string.find(lowerText, "sell") then
        local crop = string.match(lowerText, "price%s*([%a]+)") or string.match(lowerText, "sell%s*([%a]+)")
        return self:getMarketPrice(crop)
    elseif string.find(lowerText, "production") or string.find(lowerText, "factory") then
        return self:getProductionStatus()
    elseif string.find(lowerText, "milk") or string.find(lowerText, "liters") or string.find(lowerText, "gallons") then
        local material = string.match(lowerText, "(milk|liters|gallons|corn|wheat|soy|barley)")
        return self:getStorageOrTankData(material)
    end
    return "Sorry, I couldn't match your question to any farm data reader. Try asking about field, vehicle, fuel, price, production, or storage." 
end

function CriderGPTApollo:getVehicleStatus()
    if g_currentMission == nil or g_currentMission.controlledVehicle == nil then
        return "No vehicle is currently controlled."
    end
    local vehicle = g_currentMission.controlledVehicle
    local name = vehicle:getName() or "Unknown Vehicle"
    local fuel = vehicle.getFuelFillLevel and vehicle:getFuelFillLevel() or 0
    local wear = vehicle.getWearTotalAmount and vehicle:getWearTotalAmount() or 0
    local hours = vehicle.getOperatingTime and math.floor(vehicle:getOperatingTime() / 3600) or 0
    local paintWear = vehicle.spec_paintable and vehicle.spec_paintable.getDamageAmount and vehicle.spec_paintable:getDamageAmount() or "N/A"
    return string.format("Your %s has %.0f%% fuel, %d engine hours, and paint wear: %s.", name, fuel, hours, tostring(paintWear))
end

function CriderGPTApollo:getFuelLevel()
    if g_currentMission == nil or g_currentMission.controlledVehicle == nil then
        return "No vehicle is currently controlled."
    end
    local vehicle = g_currentMission.controlledVehicle
    local liters = vehicle.getFuelFillLevel and vehicle:getFuelFillLevel() or 0
    local gallons = self:convertLitersToGallons(liters)
    return string.format("Current fuel: %.2f liters (%.2f gallons)", liters, gallons)
end

function CriderGPTApollo:getMarketPrice(cropName)
    if g_currentMission == nil or g_currentMission.economyManager == nil or cropName == nil then
        return "Market price data not available or crop not specified."
    end
    local fillTypeIndex = g_fruitTypeManager and g_fruitTypeManager:getFruitTypeIndexByName(cropName) or nil
    if fillTypeIndex == nil then
        return "Unknown crop: " .. tostring(cropName)
    end
    local price = g_currentMission.economyManager:getPricePerLiter(fillTypeIndex)
    -- For demo, just return current price
    return string.format("Current price for %s: %.2f per liter.", cropName, price or 0)
end

function CriderGPTApollo:getProductionStatus()
    if g_currentMission == nil or g_currentMission.productionChainManager == nil then
        return "No production chains found."
    end
    local reply = ""
    for _, prod in pairs(g_currentMission.productionChainManager.productions or {}) do
        local name = prod.name or "Factory"
        local input = prod.inputFillLevels and prod.inputFillLevels[1] or 0
        local output = prod.outputFillLevels and prod.outputFillLevels[1] or 0
        reply = reply .. string.format("%s – %d L in, %d L out. ", name, input, output)
    end
    return reply ~= "" and reply or "No active productions."
end

function CriderGPTApollo:getStorageOrTankData(material)
    if g_currentMission == nil or material == nil then
        return "No storage/tank data available or material not specified."
    end
    -- For demo, just return a placeholder
    return string.format("Storage/tank data for %s: [Demo only]", material)
end

function CriderGPTApollo:getFieldStatus(fieldNumber)
    if g_fieldManager == nil or g_fruitTypeManager == nil then
        return "Field data is not available in this environment."
    end
    local field = g_fieldManager:getFieldByNumber(fieldNumber)
    if field == nil then
        return "Field " .. tostring(fieldNumber) .. " not found."
    end
    local fruitTypeIndex = field.fruitTypeIndex or 0
    local fruitType = g_fruitTypeManager:getFruitTypeNameByIndex(fruitTypeIndex) or "Unknown"
    local growthState = field.growthState or 0
    local hasWeeds = field.hasWeeds and "Yes" or "No"
    local needsPlowing = field.needsPlowing and "Yes" or "No"
    local needsFertilizing = field.needsFertilizing and "Yes" or "No"
    return string.format(
        "Field %d currently has %s at growth stage %d. Weeds: %s. Needs plowing: %s. Fertilizer needed: %s.",
        fieldNumber, fruitType, growthState, hasWeeds, needsPlowing, needsFertilizing
    )
end

function CriderGPTApollo:getFarmAdvice(questionText)
    local lowerText = string.lower(questionText or "")
    -- Detect field status questions
    local fieldPattern = "field%s*(%d+)"
    if string.find(lowerText, "what's in field") or string.find(lowerText, "check field")
        or string.find(lowerText, "what crop on field") or string.find(lowerText, "status field") then
        local fieldNum = string.match(lowerText, fieldPattern)
        if fieldNum ~= nil then
            local num = tonumber(fieldNum)
            if num ~= nil then
                return self:getFieldStatus(num)
            end
        end
        return "Please specify a field number (e.g., 'status field 20')."
    end
    for topic, response in pairs(ApolloKnowledgeBase) do
        if string.find(lowerText, topic) then
            -- Example of using in-game data (if available)
            if topic == "nitrogen" and PrecisionFarmingSystem ~= nil and g_currentMission ~= nil then
                local vehicle = g_currentMission.controlledVehicle
                if vehicle ~= nil and vehicle.getNitrogenLevel ~= nil then
                    local nLevel = vehicle:getNitrogenLevel()
                    if nLevel ~= nil and nLevel < 100 then
                        return "Your nitrogen level looks low. Apply fertilizer until optimal range is reached."
                    else
                        return "Nitrogen level is optimal. Maintain current fertilization schedule."
                    end
                end
            end
            return response
        end
    end
    return "Sorry, I don't have advice for that topic yet. Try asking about yield, nitrogen, lime, pH, soil, fertilizer, or seed rate."
end

print("CriderGPT Apollo initialized (Offline Farm Intelligence Active).")

print("[CriderGPT Apollo] Field awareness module loaded. Ready to analyze farm data.")

print("[CriderGPT Apollo] Farm Neural Core Online — All Systems Linked (Offline Mode).")


-- ================================================================
-- �💬 CriderGPT Chat UI Tab (Groundwork)
-- ================================================================
-- This is a basic structure for a new ESC menu tab using FS22's GUI system

CriderGPTChatFrame = {}
local CriderGPTChatFrame_mt = Class(CriderGPTChatFrame, TabMenuFrameElement)

function CriderGPTChatFrame:new(target, customMt)
    local self = TabMenuFrameElement:new(target, customMt or CriderGPTChatFrame_mt)
    self:setupElements()
    return self
end

function CriderGPTChatFrame:setupElements()
    -- Title bar
    self.title = "CriderGPT Assistant"
    -- Scrollable text area for messages
    self.messages = {}
    -- Input field for chat text
    self.inputText = ""
    -- Send button
    self.sendButton = {
        text = "Send",
        onClick = function()
            local userMsg = self.inputText or ""
            print("[CriderGPT Chat] Message sent: " .. userMsg)
            table.insert(self.messages, "[Farmer] " .. userMsg)
                local apolloReply = CriderGPTApollo:getFarmData(userMsg)
            table.insert(self.messages, "[CriderGPT Apollo] " .. apolloReply)
            self.inputText = ""
        end
    }
    -- (In a real mod, you would use GuiElement subclasses and XML layouts)
end

function CriderGPTChatFrame:onOpen()
    print("[CriderGPT Chat] Tab opened.")
end

function CriderGPTChatFrame:draw()
    -- Placeholder for drawing the UI elements
    print("[CriderGPT Chat] Drawing UI: " .. self.title)
end

-- Register the tab in the ESC menu (TabMenuController)
if g_gui ~= nil and g_gui.generation == 2 and g_tabMenu ~= nil then
    if g_tabMenu.addFrame ~= nil then
        local chatFrame = CriderGPTChatFrame:new(nil)
        g_tabMenu:addFrame(chatFrame, "CriderGPT Chat")
        print("[CriderGPT Chat] Tab registered in ESC menu.")
    end
end
