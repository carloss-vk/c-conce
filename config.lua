Config = {}

Config.Main = {
    ['Conce'] = { 
        pos = vector3(-50.5263, -1091.92, 26.422),
        distance = 1.5,
        text = {msg = 'Press ~r~[E]~w~ to access the menu', pos = vector3(-50.5263, -1091.92, 26.422)},
        vehiclepos = vector4(-47.4642, -1095.77, 26.422, 100.0),
        testdrivepos = vector3(-1455.43, -3042.65, 13.944),
        timeTest = 0.5 -- minutos
    }
}

Config.Shop = {
    ['Cars'] = {
        {label = 'Furia', name = 'furia', price = 1500000},
        {label = 'T20', name = 't20', price = 200},
        {label = 'Cheetah', name = 'cheetah', price = 200},
        {label = 'Itali RSX', name = 'italirsx', price = 500}
    }
}

Config.Blips = {
    {title = "Concesionario central", colour = 5, id = 225, x = -42.9113, y = -1098.67, z = 26.422},
}

Locale = {
    ['max_dist'] = '~r~You have moved far away from ',
    ['stop_observing'] = 'Dejaste de observar el ~g~vehículo~w~'
}