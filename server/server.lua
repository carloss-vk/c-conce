ESX = nil
local Vehicles   = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('c-vehicleshop:buy')
AddEventHandler('c-vehicleshop:buy', function(model, name, color, p, price, hash, mode)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    print('lo hago')

    if mode == 'bank' then
        if xPlayer.getAccount('bank').money >= tonumber(price) then
            xPlayer.removeAccountMoney('bank', tonumber(price))
            local plate = GeneratePlate()
            CreateVehicleDB(plate, p)
            TriggerClientEvent('c-vehicleshop:darcoche', src, name, color, plate)
            xPlayer.showNotification('Has ~g~comprado~w~ un '..model..' con matrícula '..plate..'')
        else
            xPlayer.showNotification("~r~No tienes dinero suficiente")
        end
    elseif mode == 'money' then
        if xPlayer.getMoney() >= tonumber(price) then
            xPlayer.removeMoney(tonumber(price))
            local plate = GeneratePlate()
            CreateVehicleDB(plate, p)
            TriggerClientEvent('c-vehicleshop:darcoche', src, name, color, plate)
            xPlayer.showNotification('Has ~g~comprado~w~ un '..model..' con matrícula '..plate..'')
        else
            xPlayer.showNotification("~r~No tienes dinero suficiente")
        end
    end
end)

CreateVehicleDB = function(plate, p)
    local xPlayer = ESX.GetPlayerFromId(source)

    p.plate = plate
                MySQL.Sync.execute("INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)",
                {
                    ['@owner'] = xPlayer.identifier,
                    ['@plate'] = tostring(plate),
                    ['@vehicle'] = json.encode(p)
                }
                )
end

GeneratePlate = function()

    local plate = "CM " ..math.random(100, 999)

    return plate

end