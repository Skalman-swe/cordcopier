fx_version 'cerulean'




game 'gta5'

author 'Lenn_Arts'
description 'Copy all cords with ease'
version '1.0.0'

lua54 'yes'

-- ==============================
-- DEPENDENCIES
-- ==============================
dependencies {
    'ox_lib'
}

-- ==============================
-- CLIENT / SERVER
-- ==============================
client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_scripts {
    '@ox_lib/init.lua',
    'server.lua',
   
}
