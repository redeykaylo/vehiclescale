local scaleObject = nil
local trunkWeight = 0
local waitingForWeight = false

-- Create blips for each scale zone
CreateThread(function()
    for _, zone in pairs(Config.ScaleZones) do
        local blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
        SetBlipSprite(blip, 524)          -- Scale icon (uses GTA scale icon)
        SetBlipScale(blip, 0.8)           -- Blip size
        SetBlipColour(blip, 2)            -- Green color
        SetBlipAsShortRange(blip, true)  -- Blip visible only nearby
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Vehicle Scale")
        EndTextCommandSetBlipName(blip)
    end
end)

-- 3D text rendering (bigger and more visible)
local function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.5, 0.5)               -- bigger text
        SetTextFont(4)                       -- font suitable for English
        SetTextProportional(1)
        SetTextColour(255, 255, 100, 255)   -- yellow color, fully opaque
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)

        local factor = (string.len(text)) / 290
        DrawRect(_x, _y + 0.015, 0.02 + factor, 0.04, 0, 0, 0, 180) -- darker and bigger background
    end
end

-- Event to receive trunk weight from server
RegisterNetEvent('vehicle_scale:returnTrunkWeight', function(weight)
    print("[client] trunkWeight returned:", weight)
    trunkWeight = weight
    waitingForWeight = false
end)

-- Function to get inventory weight from trunk via event
local function GetVehicleInventoryWeight(plate)
    trunkWeight = 0
    waitingForWeight = true
    TriggerServerEvent('vehicle_scale:getTrunkWeight', plate)

    local timeout = 10000 -- 10 seconds timeout
    local waited = 0

    while waitingForWeight and waited < timeout do
        Wait(50)
        waited += 50
    end

    if waitingForWeight then
        print("[client] Timeout waiting for trunkWeight")
        return 0
    end

    return trunkWeight
end

-- Spawn scale prop
CreateThread(function()
    for _, zone in pairs(Config.ScaleZones) do
        local model = `baspel_weighingmachine_`
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(0) end

        local obj = CreateObject(model, zone.coords.x, zone.coords.y, zone.coords.z - 1.0, false, false, false)
        SetEntityHeading(obj, zone.heading)
        FreezeEntityPosition(obj, true)
        scaleObject = obj
        SetModelAsNoLongerNeeded(model)
    end
end)

-- Main interaction and weighing loop
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, zone in pairs(Config.ScaleZones) do
            local dist = #(coords - zone.coords)
            if dist < 15.0 then               -- bigger distance for showing text
                sleep = 0
                DrawText3D(zone.coords.x, zone.coords.y, zone.coords.z + 1.2, zone.text)

                if dist < 5.0 and IsControlJustPressed(0, 38) then -- E key, smaller distance for interaction
                    if IsPedInAnyVehicle(ped, false) then
                        local veh = GetVehiclePedIsIn(ped, false)
                        local mass = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fMass')
                        local plate = GetVehicleNumberPlateText(veh):gsub("%s+", ""):upper()

                        print("[client] Plate:", plate)

                        local extraMass = GetVehicleInventoryWeight(plate)
                        local totalMass = math.floor(mass + extraMass)

                        lib.notify({
                            title = '🚗 Vehicle Weight',
                            description = ('🧱 VEHICLE MASS: %d kg'):format(totalMass),
                            type = 'inform'
                        })

                        TriggerServerEvent('vehicle_scale:logDiscord', plate, totalMass, mass, extraMass)
                    else
                        lib.notify({
                            title = '⛔ Error',
                            description = 'You must be inside a vehicle!',
                            type = 'error'
                        })
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
