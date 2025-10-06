
-- FS25 Vehicle Maintenance Mod

function VehicleMaintain:onLoad()
    print("[VehicleMaintain] Loaded vehicle maintenance mod!")
    -- Check for CriderGPTHelper mod
    if _G.CriderGPTHelper ~= nil then
        print("[VehicleMaintain] CriderGPTHelper detected! Integrating...")
        -- Example: Call a function from CriderGPTHelper if available
        if type(_G.CriderGPTHelper.registerMaintenanceMod) == "function" then
            _G.CriderGPTHelper.registerMaintenanceMod(self)
        end
    else
        print("[VehicleMaintain] CriderGPTHelper not found. Running standalone.")
    end
    -- Add your maintenance logic here
end

-- Add more functions and event hooks as needed
