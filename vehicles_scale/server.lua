local json = json

local webhookURL = 'https://discord.com/api/webhooks/YOUAR_WEBHOOK'

RegisterNetEvent('vehicle_scale:getTrunkWeight', function(plate)
    local src = source
    print("[vehicle_scale] Request for plate:", plate)

    local inventory = exports.ox_inventory:GetInventoryItems('trunk', plate)

    print("[vehicle_scale] Inventory:", inventory and json.encode(inventory) or "nil")

    local totalWeight = 0

    if inventory then
        for _, item in pairs(inventory) do
            if item.weight then
                totalWeight = totalWeight + (item.weight * item.count)
            end
            print("[server] Item:", item.name, "count:", item.count, "weight:", item.weight or "nil")
        end
    end

    TriggerClientEvent('vehicle_scale:returnTrunkWeight', src, totalWeight)
end)

RegisterNetEvent('vehicle_scale:logDiscord', function(plate, totalMass, baseMass, extraMass)
    print(('[vehicle_scale] Vehicle %s total weight %d (base %d + cargo %d)'):format(plate, totalMass, baseMass, extraMass))

    local message = {
        content = nil,
        embeds = {{
            title = "🚗 Vehicle Weight",
            color = 65280,
            fields = {
                { name = "Plate", value = plate, inline = true },
                { name = "VEHICLE MASS", value = tostring(baseMass) .. " kg", inline = true }
            },
            footer = { text = "Vehicle Scale Logger" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    PerformHttpRequest(webhookURL, function(err, text, headers)
        if err == 204 then
            print("[vehicle_scale] Webhook sent successfully.")
        else
            print("[vehicle_scale] Error sending webhook: " .. tostring(err))
        end
    end, 'POST', json.encode(message), { ['Content-Type'] = 'application/json' })
end)
