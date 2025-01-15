fx_version 'cerulean'
game 'gta5'
description 'Death Screen'
version '1.0'
legacyversion '1.11.4'
lua54 'yes'

shared_scripts { 
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
    'locales/*.lua',
}

client_scripts {
    'config.lua',
    'client/*.lua',
}

ui_page 'nui/index.html'

files {
	'nui/*.html',
	'nui/assets/*.js',
	'nui/assets/*.css',
}

dependencies {
	'es_extended'
}