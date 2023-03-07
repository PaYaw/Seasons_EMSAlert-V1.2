-- NC PROTECT+
server_scripts { '@nc_PROTECT+/exports/sv.lua' }
client_scripts { '@nc_PROTECT+/exports/cl.lua' }

fx_version 'adamant'
games { 'gta5' }

ui_page 'Source/ui/index.html'

description 'WildCart EMS Alert'
version '1.0'

server_scripts {'Source/Server.lua'}
client_scripts {'Source/Client.lua'}
files {
	'Source/ui/*.*'
}