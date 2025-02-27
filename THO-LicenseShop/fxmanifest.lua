fx_version 'bodacious'
game 'gta5'

author 'Your Name'
description 'License purchasing script with ox_target interaction'
version '1.0.0'

client_script {
    'config.lua',    -- Ensure this is above client.lua to load the configuration first
    'client.lua'
}

server_script 'server.lua'

dependencies {
    'es_extended',
    'ox_target',
}
