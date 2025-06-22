fx_version 'cerulean'
game 'gta5'

author 'Tobias'
description 'Vehicle weighing scale with prop, UI and Discord logging'

lua54 'yes' -- DŮLEŽITÉ pro správnou funkci ox_lib
dependency 'ox_lib'

shared_script '@ox_lib/init.lua'
shared_script 'config.lua'

client_script 'client.lua'
server_script 'server.lua'
