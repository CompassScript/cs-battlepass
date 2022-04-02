fx_version 'adamant'

game 'gta5'

description 'battlepass'

version '1.0.0'

server_script {
    'config.lua',
    'server/main.lua'    
}
client_script {
    'config.lua',
    'client/main.lua'    
}

ui_page {
	'html/index.html'
}

files {
	'html/index.html',
	'html/style/*.css',
	'html/script/*.js',
	'html/img/*.png',
}
