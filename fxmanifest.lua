fx_version 'cerulean'
game 'gta5'

author 'carlossdev'
description 'Vehicleshop for cm shop'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    '@mysql-async/lib/MySQL.lua'
}