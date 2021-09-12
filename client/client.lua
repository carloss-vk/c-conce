ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local maslento = true
        for _,v in pairs(Config.Main) do
            local dist = #(GetEntityCoords(PlayerPedId()) - vec3(v.pos.x, v.pos.y, v.pos.z))
            if dist <= v.distance then
                maslento = false
                ShowFloatingHelpNotification(v.text.msg, v.text.pos)
                if IsControlJustPressed(1, 38) then
                    OpenVehicleShopMenu()
                end
            end
        end
        if maslento then Citizen.Wait(1000) end
    end
end)

Citizen.CreateThread(function()

    for _, info in pairs(Config.Blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.6)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

-- ## Events ## --

local rotate = false

RegisterNetEvent('c-vehshop:rotationVehicle')
AddEventHandler('c-vehshop:rotationVehicle', function(vehicle)
    while rotate do
        Citizen.Wait(10)
        SetEntityHeading(vehicle, GetEntityHeading(vehicle) + 1)
    end
end)

-- ## Funcs ## --

local localVehicle = nil

local firstVehicle = nil

local currentVehicle = nil

local optionsOn = false

RegisterNetEvent('c-vehicleshop:darcoche')
AddEventHandler('c-vehicleshop:darcoche', function(name, color, plate)
    ESX.Game.SpawnVehicle(name, vector3(-31.8162, -1090.20, 26.422), 10.0, function(vehicle)
        print(json.encode(color))
        SetVehicleCustomPrimaryColour(vehicle, color.r, color.g, color.b)
        SetVehicleNumberPlateText(vehicle, plate)
        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        ESX.Game.DeleteVehicle(currentVehicle)
        optionsOn = false
    end)
end)

OpenVehicleShopMenu = function()

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicleshop_menu', {
        title = 'Concesionario',
        align = 'right',
        elements = {
            { label = 'Seleccionar coche', value = 'car' }
        }

    }, function(data, menu)
        menu.close()

        local val = data.current.value 
        local abierto = false
        local abierto2 = false

        if val == 'car' then
            firstVehicle = 'furia'

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'c-sl', {
                title = 'Selecciona el coche',
                align = 'right',
                elements = Config.Shop.Cars
            }, function(data2, menu2)
                abierto = true
                menu2.close()
                local elements = {}
                table.insert(elements, {label = 'Escoger coche', name = 'escoger'})
    
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'c-sl', {
                    title = 'Custom',
                    align = 'right',
                    elements = elements
                }, function(data3, menu3)
                    abierto2 = true
                    if data3.current.name == 'escoger' then
                        rotate = false
                        optionsOn = true
                        Options(currentVehicle, data2.current.price, data2.current.name)
                    end
                end, function(data3, menu3)
                    menu3.close()
                    abierto = false
                    if not abierto2 then
                        ESX.Game.DeleteVehicle(currentVehicle)
                    end
                end)

            end, function(data2, menu2)
                menu2.close()
                if not abierto then
                    ESX.Game.DeleteVehicle(currentVehicle)
                end
            end, function(data2, menu2)
                ESX.Game.DeleteVehicle(currentVehicle)
                if ESX.Game.IsSpawnPointClear(vector3(Config.Main.Conce.vehiclepos[1], Config.Main.Conce.vehiclepos[2], Config.Main.Conce.vehiclepos[3]), 5) then
                    ESX.Game.SpawnLocalVehicle(data2.current.name, vector3(Config.Main.Conce.vehiclepos[1], Config.Main.Conce.vehiclepos[2], Config.Main.Conce.vehiclepos[3]), Config.Main.Conce.vehiclepos[4], function(vehicle)
                        currentVehicle = vehicle
                        rotate = true
                        TriggerEvent('c-vehshop:rotationVehicle', vehicle)
                    end)
                else
                    ESX.ShowNotification('~r~El punto de spawn está bloqueado')
                end
            end)
            if firstVehicle ~= nil then
                if ESX.Game.IsSpawnPointClear(vector3(Config.Main.Conce.vehiclepos[1], Config.Main.Conce.vehiclepos[2], Config.Main.Conce.vehiclepos[3]), 5) then
                    ESX.Game.SpawnLocalVehicle(firstVehicle, vector3(Config.Main.Conce.vehiclepos[1], Config.Main.Conce.vehiclepos[2], Config.Main.Conce.vehiclepos[3]), Config.Main.Conce.vehiclepos[4], function(vehicle)
                        currentVehicle = vehicle
                        rotate = true
                        TriggerEvent('c-vehshop:rotationVehicle', vehicle)
                    end)
                    firstVehicle = nil
                end
            end
        else
            ESX.ShowNotification('~r~El punto de spawn está bloqueado')
        end
    end,

    function(data, menu) -- Closes menu.
        menu.close()
    end)
end

function Options(vehicle, price, name)
    while optionsOn and DoesEntityExist(vehicle) do
        Citizen.Wait(0)
        local maslento = true
            if not testeando then
                FreezeEntityPosition(vehicle, true)
            end
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local coordsVehicle = GetEntityCoords(vehicle)
            local distancia = #(coords - coordsVehicle)
            if not testeando then
                if distancia < 3.5 then
                    maslento = false
                    ShowFloatingHelpNotification('Press ~r~[E] ~s~to modify the options of the ' .. string.lower(GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))), coordsVehicle)
                    if IsControlJustReleased(1, 38) then
                        local options = {
                            {label = 'Change color', value = 'changeColor'},
                            {label = 'Listen to engine', value = 'motor'},
                            {label = 'Test the car', value = 'test'},
                            {label = 'Stop seeing the vehicle', value = 'dejardever'},
                            {label = 'Pay in cash', value = 'money'},
                            {label = 'Pay by credit card', value = 'bank'}
                        }

                        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'c-op', {
                            title = ('Options of the: <span style = "color: lime;">' .. string.lower(GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))))),
                            align = 'right',
                            elements = options
                        }, function(data, menu)
                            if data.current.value == 'money' then
                                local data = ESX.Game.GetVehicleProperties(vehicle)
                                local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
                                local color = {r = r, g = g, b = b}
                                TriggerServerEvent('c-vehicleshop:buy', GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), color, data, price, GetHashKey(GetEntityModel(vehicle)), 'money')
                            end
                            if data.current.value == 'bank' then
                                local data = ESX.Game.GetVehicleProperties(vehicle)
                                local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
                                local color = {r = r, g = g, b = b}
                                TriggerServerEvent('c-vehicleshop:buy', GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), color, data, price, GetHashKey(GetEntityModel(vehicle)), 'bank')
                            end
                            if data.current.value == 'dejardever' then
                            ESX.Game.DeleteVehicle(vehicle)
                            ESX.ShowNotification(Locale['stop_observing'])
                            end
                            if data.current.value == 'motor' then
                                SetVehicleEngineOn(vehicle, true, true, false)
                                SetVehicleCurrentRpm(vehicle, 1.0)
                            elseif data.current.value == 'changeColor' then
                                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'nasdnasdnasldi', {
                                    title = 'Colors',
                                    align = 'right',
                                    elements = {
                                        {label = 'Black', value = 'negrata'},
                                        {label = 'Blue', value = 'azul'},
                                        {label = 'Marron', value = 'marron'},
                                        {label = 'Grey', value = 'gris'},
                                        {label = 'Green', value = 'verde'},
                                        {label = 'Purple', value = 'morado'},
                                        {label = 'Orange', value = 'naranja'},
                                        {label = 'Pink', value = 'rosa'},
                                        {label = 'White', value = 'blanco'},
                                        {label = 'Yellow', value = 'amarillo'}
                                    }
                                }, function(data2, menu2)
                                    if data2.current.value == 'negrata' then
                                        SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
                                    end
                                    if data2.current.value == 'azul' then
                                        SetVehicleCustomPrimaryColour(vehicle, 0, 151, 255)
                                    end
                                    if data2.current.value == 'marron' then
                                        SetVehicleCustomPrimaryColour(vehicle, 126, 112, 112)
                                    end
                                    if data2.current.value == 'gris' then
                                        SetVehicleCustomPrimaryColour(vehicle, 51, 51, 51)
                                    end
                                    if data2.current.value == 'verde' then
                                        SetVehicleCustomPrimaryColour(vehicle, 0, 255, 4)
                                    end
                                    if data2.current.value == 'rojo' then
                                        SetVehicleCustomPrimaryColour(vehicle, 255, 0, 0)
                                    end
                                    if data2.current.value == 'morado' then
                                        SetVehicleCustomPrimaryColour(vehicle, 131, 0, 255)
                                    end
                                    if data2.current.value == 'naranja' then
                                        SetVehicleCustomPrimaryColour(vehicle, 255, 139, 0)
                                    end
                                    if data2.current.value == 'rosa' then
                                        SetVehicleCustomPrimaryColour(vehicle, 232, 0, 255)
                                    end
                                    if data2.current.value == 'rojo' then
                                        SetVehicleCustomPrimaryColour(vehicle, 255, 0, 0)
                                    end
                                    if data2.current.value == 'blanco' then
                                        SetVehicleCustomPrimaryColour(vehicle, 255, 255, 255)
                                    end
                                    if data2.current.value == 'amarillo' then
                                        SetVehicleCustomPrimaryColour(vehicle, 255, 255, 0)
                                    end
                                end, function(data2, menu2)
                                    menu2.close()
                                end)
                            elseif data.current.value == 'test' then
                                menu.close()
                                test(vehicle)
                            end
                        end, function(data, menu)
                            menu.close()
                        end)
                    end
                end
            end

            if not testeando and distancia > 50 then
                optionsOn = false
                ESX.Game.DeleteVehicle(vehicle)
                ESX.ShowNotification(Locale['max_dist'] .. string.lower(GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))))
            end
        if maslento then Citizen.Wait(1000) end
    end
end

function test(vehicle)
    local anteriorCoords = GetEntityCoords(vehicle)
    local anteriorHeading = GetEntityHeading(vehicle)
    local ped = PlayerPedId()
    testeando = true
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    FreezeEntityPosition(vehicle, false)
    SetEntityCoords(vehicle, Config.Main.Conce.testdrivepos)
    SetEntityCoords(ped, Config.Main.Conce.testdrivepos)
    Citizen.Wait(100)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    Citizen.Wait(100)
    DoScreenFadeIn(500)
    Citizen.Wait(500)
    ESX.ShowNotification('You have ' .. Config.Main.Conce.timeTest .. ' minutes to test')
    local contador = Config.Main.Conce.timeTest * 60
    while contador >= 0 do
        Citizen.Wait(1000)
        contador = contador - 1
    end
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    SetEntityCoords(vehicle, anteriorCoords)
    SetEntityHeading(vehicle, anteriorHeading)
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    Citizen.Wait(600)
    FreezeEntityPosition(vehicle, true)
    TaskWarpPedIntoVehicle(ped, vehicle, -1)
    Citizen.Wait(100)
    DoScreenFadeIn(500)
    Citizen.Wait(500)
    testeando = false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local maslento = true
        if testeando then
            maslento = false
            DisableControlAction(0, 75, true)
        end
        if maslento then Citizen.Wait(1000) end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if testeando then
            DisableControlAction(0, 75, true)
	else
	    Citizen.Wait(1000)
        end
    end
end)

function ShowFloatingHelpNotification(msg, coords)
    SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(2, false, true, -1)
end
