fx_version "adamant"
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
games {"rdr3"}

client_scripts {
    "client/client.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/server.lua"
}

shared_scripts {
    "config.lua",
    "hairs.lua",
    'overlays.lua',
    'client/npc.lua',
}