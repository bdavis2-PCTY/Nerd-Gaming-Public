local sx, sy = guiGetScreenSize ( )
local phone_y = sy + 10
local to_phone_y = sy - 600
local phone_x = sx - 330
local moveSpeed = 18
local isOpen = false
local isRender = false
LoadedPage = nil
local RealTime = "00:00"
local backgroundPath = "images/backgrounds/background_1.png"

if ( fileExists ( "custombg.png" ) ) then
	backgroundPath = "custombg.png" 
elseif ( fileExists ( "custombg.jpg" ) ) then
	backgroundPath = "custombg.jpg"
end

base = guiCreateStaticImage (  phone_x, phone_y, 350, 600, "images/phone.png", false  )
background = guiCreateStaticImage ( 43, 92, 262, 422, backgroundPath, false, base )
RealTimeText = guiCreateLabel( 250, 78, 220, 60, RealTime, false, base )
guiSetFont ( RealTimeText, "default-bold-small" )
guiSetVisible ( base, false )
guiLabelSetColor ( RealTimeText, 0, 120, 255 )

local open = {
	startY = sy+5,
	endY = to_phone_y,
	startTime = nil,
	endTime = nil,
	allowClicking = true
}

function updateTimeTimer()
	local realTime = getRealTime ( )
	local hour = realTime['hour']
	local min = realTime['minute']
	local ending = "AM"
	if ( hour > 12 ) then
		hour = hour - 12
		ending = 'PM'
	end if ( min <  10 ) then
		min = 0 .. min
	end
	
	if ( tostring ( hour ) == '0' ) then
		hour = 12
	end
	
	local text = hour..":"..min .. ending
	guiSetText ( RealTimeText, text )
end

local appSize = 55
local margin_x = 62
local margin_y = 77
pages = { }
-- Home
pages['home'] = { }
pages['home'].base_bank = guiCreateStaticImage ( 5, 5, appSize, appSize, "images/app_bank.png", false, background )
pages['home'].base_waypoints = guiCreateStaticImage ( 5+margin_x, 5, appSize, appSize, "images/app_waypoints.png", false, background )
pages['home'].base_money = guiCreateStaticImage ( 5+margin_x*2, 5, appSize, appSize, "images/app_money.png", false, background )
pages['home'].base_settings = guiCreateStaticImage ( 5+margin_x*3, 5, appSize, appSize, "images/app_settings.png", false, background )

pages['home'].base_notes = guiCreateStaticImage ( 5+margin_x*3, 5+margin_y, appSize, appSize, "images/app_notes.png", false, background )
pages['home'].base_music = guiCreateStaticImage ( 5, 5+margin_y, appSize, appSize, "images/app_music.png", false, background )
pages['home'].base_vehicles = guiCreateStaticImage ( 5+margin_x, 5+margin_y, appSize, appSize, "images/app_vehicle.png", false, background )
pages['home'].base_sms = guiCreateStaticImage ( 5+margin_x*2, 5+margin_y, appSize, appSize, "images/app_sms.png", false, background )

pages['home'].base_stats = guiCreateStaticImage ( 5+margin_x, 5+margin_y*2, appSize, appSize, "images/app_stats.png", false, background )
pages['home'].base_flappy = guiCreateStaticImage ( 5+margin_x*2, 5+margin_y*2, appSize, appSize, "images/app_flappybird.png", false, background )
pages['home'].base_2048 = guiCreateStaticImage ( 5, 5+margin_y*2, appSize, appSize, "images/app_2048.png", false, background )

setElementData ( pages['home'].base_money, "tooltip-text", "Send Money" )
setElementData ( pages['home'].base_sms, "tooltip-text", "SMS" )
setElementData ( pages['home'].base_bank, "tooltip-text", "Bank" )
setElementData ( pages['home'].base_music, "tooltip-text", "Music" )
setElementData ( pages['home'].base_notes, "tooltip-text", "Notes" )
setElementData ( pages['home'].base_waypoints, "tooltip-text", "Waypoints" )
setElementData ( pages['home'].base_vehicles, "tooltip-text", "Vehicles" )
setElementData ( pages['home'].base_settings, "tooltip-text", "Settings" )
setElementData ( pages['home'].base_stats, "tooltip-text", "User & Server Stats" )
setElementData ( pages['home'].base_flappy, "tooltip-text", "Flappy Bird" )
setElementData ( pages['home'].base_2048, "tooltip-text", "2048" )
setElementData ( pages['home'].base_money, "tooltip-displaytext", false )
setElementData ( pages['home'].base_sms, "tooltip-displaytext", false )
setElementData ( pages['home'].base_bank, "tooltip-displaytext", false )
setElementData ( pages['home'].base_music, "tooltip-displaytext", false )
setElementData ( pages['home'].base_notes, "tooltip-displaytext", false )
setElementData ( pages['home'].base_waypoints, "tooltip-displaytext", false )
setElementData ( pages['home'].base_vehicles, "tooltip-displaytext", false )
setElementData ( pages['home'].base_settings, "tooltip-displaytext", false )
setElementData ( pages['home'].base_stats, "tooltip-displaytext", false )
setElementData ( pages['home'].base_flappy, "tooltip-displaytext", false )
setElementData ( pages['home'].base_2048, "tooltip-displaytext", false )

for i, v in pairs ( pages['home'] ) do
	if ( getElementType ( v ) == "gui-staticimage" ) then
		guiSetAlpha ( v, 0.8 )
	end
end

-- SMS
pages['sms'] = { }
pages['sms'].grid = guiCreateGridList ( 4, 11, 257, 150, false, background )
pages['sms'].search = guiCreateEdit ( 4, 161, 257, 30, "Search...", false, background )
pages['sms'].messages = guiCreateMemo ( 4, 220, 257, 150, "", false, background )
pages['sms'].message = guiCreateEdit ( 4, 376, 200, 30, "Message...", false, background )
pages['sms'].send = guiCreateButton ( 207, 376, 52, 30, "Send", false, background )
pages['sms'].fromLast = nil
pages['sms'].selectedPlayer = nil
pages['sms'].sMessages = { }

guiGridListAddColumn ( pages['sms'].grid, "Player", 0.9 )
guiMemoSetReadOnly ( pages['sms'].messages, true )
guiEditSetMaxLength ( pages['sms'].message, 300 )


-- Bank
pages['bank'] = { }
pages['bank'].bank_balance = guiCreateMemo ( 4, 11, 255, 70, "Your bank balance is $0", false, background)
pages['bank'].bank_log = guiCreateGridList ( 4, 85, 255, 320, false, background)
guiGridListAddColumn( pages['bank'].bank_log, "Log", 1.2 )
guiGridListAddColumn( pages['bank'].bank_log, "Serial", 0.9 )
guiGridListAddColumn( pages['bank'].bank_log, "IP", 0.4 )
guiMemoSetReadOnly ( pages['bank'].bank_balance, true )
guiGridListSetSortingEnabled ( pages['bank'].bank_log, false )

-- Music
pages['music'] = { }
pages['music'].grid = guiCreateGridList ( 4, 8, 257, 250, false, background )
pages['music'].stop = guiCreateButton ( 87, 266, 80, 40, "Stop Music", false, background  )
pages['music'].play = guiCreateButton ( 4, 266, 80, 40, "Play Music", false, background  )
pages['music'].delete = guiCreateButton ( 170, 266, 88, 40, "Delete Station", false, background  )
pages['music'].lbl1 = guiCreateLabel ( 4, 311, 50, 20, "Name:", false, background )
pages['music'].lbl2 = guiCreateLabel ( 4, 336, 50, 20, "URL:", false, background )
pages['music'].add_name = guiCreateEdit ( 42, 311, 180, 20, "", false, background )
pages['music'].add_url = guiCreateEdit ( 42, 336, 180, 20, "", false, background )
pages['music'].add = guiCreateButton ( 87, 368, 138, 30, "Add Station", false, background )
pages['music'].sound = nil

guiGridListAddColumn ( pages['music'].grid, "Name", 0.45 )
guiGridListAddColumn ( pages['music'].grid, "URL", 0.45 )
guiSetFont ( pages['music'].lbl1, "default-bold-small" )
guiSetFont ( pages['music'].lbl2, "default-bold-small" )


-- Notes
pages['notes'] = { }
pages['notes'].notes = guiCreateMemo ( 4, 11, 255, 400, "", false, background)


-- send money
pages['money'] = { }
pages['money'].grid = guiCreateGridList ( 4, 11, 257, 250, false, background )
pages['money'].search = guiCreateEdit ( 4, 261, 257, 30, "Search...", false, background )
pages['money'].lbl1 = guiCreateLabel ( 8, 310, 40, 28, "Money:", false, background )
pages['money'].amount = guiCreateEdit ( 8, 335, 150, 30, "", false, background )
pages['money'].send = guiCreateButton ( 160, 335, 80, 30, "Send", false, background )

guiGridListAddColumn ( pages['money'].grid, "Player", 0.9 )


-- Vehicles
pages['vehicles'] = { }
pages['vehicles'].grid = guiCreateGridList ( 4, 11, 257, 330, false, background )
pages['vehicles'].show = guiCreateButton ( 4, 350, 80, 25, "Show", false, background )
pages['vehicles'].recover = guiCreateButton ( ((84+(261-80))/2 -40), 350, 80, 25, "Recover", false, background )
pages['vehicles'].sell = guiCreateButton ( 261-80, 350, 80, 25, "Sell", false, background )
pages['vehicles'].refresh = guiCreateButton ( 4, 383, 125, 25, "Refresh", false, background )
pages['vehicles'].warptome = guiCreateButton ( 136, 383, 125, 25, "Warp to me", false, background )

guiGridListAddColumn ( pages['vehicles'].grid, "Vehicle", 0.9 )


-- Waypoints
pages['waypoints'] = { }
pages['waypoints'].grid = guiCreateGridList ( 4, 11, 257, 330, false, background )
pages['waypoints'].add_nameLbl = guiCreateLabel ( 4, 350, 257, 25, "Name:", false, background )
pages['waypoints'].add_name = guiCreateEdit ( 4, 375, 190, 25, "", false, background )
pages['waypoints'].add = guiCreateButton ( 197, 375, 50, 25, "Add", false, background )
guiGridListAddColumn ( pages['waypoints'].grid, "", 0.9 )
guiGridListSetSortingEnabled ( pages['waypoints'].grid, false )
	
	
-- Settings
pages['settings'] = { }
pages['settings'].scroll = guiCreateScrollPane ( 0, 0, 260, 400, false, background )
local s = pages['settings'].scroll
local UserSettings = { 
	['Display'] = {
		{ "UserSettings_UseCustomRadio", 			"Use custom radio HUD" 				},
		{ "UserSettings_UseCustomHud", 				"Use custom zone name HUD" 			},
		{ "usersettings_usecustomvehiclenames", 	"Use custom vehicle name HUD" 		},
		{ "usersettings_usetopbar", 				"Toggle top-bar messages" 			},
		{ "UserSettings_ShowSpeedMeter", 			"Toggle vehicle speed meter" 		},
		{ "UserSettings_ShowSpeedGraph", 			"Toggle vehicle speed meter graph" 	},
		{ "usersetting_display_vipchat", 			"Toggle VIP Chat (VIP Only)" 		},
		{ "usersettings_display_clouds",			"Toggle Clouds"						},
		{ "usersettings_display_clienttoserverstats","Show client-server stats"			},
	},
	
	['Blips'] = {
		{ "usersetting_display_createfuelblips", 		"Fuel station blips" 			},
		{ "usersetting_display_createpnsblips", 		"Pay n' Spray Station Blips" 	},
		{ "usersetting_display_createammunationblips", 	"Ammu-nation Blips" 		   	},
		{ "usersetting_display_clubblips", 				"Club Blips" 		  			},
		{ "usersetting_display_skinshopblips", 			"Skin Shop Blips" 		  		},
		{ "usersetting_display_hospitalblips", 			"Hospital Blips"				},
		{ "usersetting_display_usershopblips", 			"User Shop Blips"				},
		{ "usersetting_display_vehicleshopblips", 		"Vehicle Shop Blips"			},
		{ "usersetting_display_gymblips",				"Gym Blips"						},
		{ "usersetting_display_modshopblips",			"Modshop Blips"					},
		{ "usersetting_display_usedvehicleshopblips",	"Use Vehicle Shop Blips"		},
	},
		
	['Notifications'] = {
		{ "usersetting_notification_joinquitmessages", 		"Show join/quit messages" 	},
		{ "usersetting_notification_nickchangemessages", 	"Show name change messages" },
		{ "usersettings_showmoneylogs", 					"Toggle money messages"     },
		{ "usersettings_display_lowfpswarning",				"Low FPS notifications"		},
	},
		
	['Shaders'] = {
		{ "usersetting_shader_bloom", 				"Bloom" 			},
		{ "usersetting_shader_contrast", 			"Contrast" 			},
		{ "usersetting_shader_detail", 				"Detail" 			},
		{ "usersetting_shader_skybox", 				"Skybox" 			},
		{ "usersetting_shader_roadshine", 			"Road Shine" 		},
		{ "usersetting_shader_vehiclereflections", 	"Vehicle Reflections"},
		{ "usersetting_shader_water", 				"Water quality" 	},
		{ "usersetting_shader_wetroad", 			"Wet Roads" 		},
	},
		
	['Others'] = {
		{ "usersetting_misc_playsoundonguiclick", 	"Play sound when clicking GUI buttons" },
	}
}

local SettingPreferences = {
	['looks'] = {
		['UserSettings_UseCustomRadio'] = true,					['UserSettings_UseCustomHud'] = true,
		['usersettings_usecustomvehiclenames'] = true,			['usersettings_usetopbar'] = true,
		['UserSettings_ShowSpeedMeter'] = true,					['UserSettings_ShowSpeedGraph'] = true,
		['usersetting_display_createfuelblips'] = true,			['usersetting_display_createpnsblips'] = true,
		['usersetting_display_createammunationblips'] = true,	['usersetting_notification_joinquitmessages'] = true,
		['usersetting_notification_nickchangemessages'] = true, ['usersetting_shader_skybox'] = true,
		['usersetting_shader_water'] = true,					['usersetting_shader_wetroad'] = true,
		['usersetting_shader_bloom'] = true,					['usersetting_shader_contrast'] = true,
		['usersetting_shader_vehiclereflections'] = true,		['usersettings_showmoneylogs'] = true,
		['usersetting_shader_roadshine'] = true,				['usersetting_shader_detail'] = true,
		['usersetting_display_clubblips'] = true,				['usersetting_display_skinshopblips'] = true,
		['usersetting_display_hospitalblips'] = true,			['usersetting_display_vehicleshopblips'] = true,
		['usersetting_misc_playsoundonguiclick'] = true,		['usersettings_display_clouds'] = true,
		['usersetting_display_usershopblips'] = true,			['usersettings_display_clienttoserverstats']=true,
		['usersettings_display_lowfpswarning'] = true,			['usersetting_display_gymblips'] = true,
		["usersetting_display_modshopblips"] = true,			['usersetting_display_usedvehicleshopblips'] = true,

	}, 
	['performance'] = {
		['UserSettings_UseCustomRadio'] = false,				['UserSettings_UseCustomHud'] = false,
		['usersettings_usecustomvehiclenames'] = false,			['usersettings_usetopbar'] = false,
		['UserSettings_ShowSpeedMeter'] = false,				['UserSettings_ShowSpeedGraph'] = false,
		['usersetting_display_createfuelblips'] = false,		['usersetting_display_createpnsblips'] = false,
		['usersetting_display_createammunationblips'] = false,	['usersetting_notification_joinquitmessages'] = false,
		['usersetting_notification_nickchangemessages'] = false,['usersetting_shader_skybox'] = false,
		['usersetting_shader_water'] = false,					['usersetting_shader_wetroad'] = false,
		['usersetting_shader_bloom'] = false,					['usersetting_shader_contrast'] = false,
		['usersetting_shader_vehiclereflections'] = false,		['usersettings_showmoneylogs'] = false,
		['usersetting_shader_roadshine'] = false,				['usersetting_shader_detail'] = false,
		['usersetting_display_clubblips'] = false,				['usersetting_display_skinshopblips'] = false,
		['usersetting_display_hospitalblips'] = false,			['usersetting_display_vehicleshopblips'] = false,
		['usersetting_misc_playsoundonguiclick'] = false,		['usersettings_display_clouds'] = false,
		['usersetting_display_usershopblips'] = false,			['usersettings_display_clienttoserverstats'] = false,
		['usersettings_display_lowfpswarning'] = false,			['usersetting_display_gymblips'] = false,
		["usersetting_display_modshopblips"] = false,			['usersetting_display_usedvehicleshopblips'] = false,
	},
	['mix'] = {
		['UserSettings_UseCustomRadio'] = false, 				['UserSettings_UseCustomHud'] = false,
		['usersettings_usecustomvehiclenames'] = false, 		['usersettings_usetopbar'] = true,
		['UserSettings_ShowSpeedMeter'] = true, 				['UserSettings_ShowSpeedGraph'] = false,
		['usersetting_display_createfuelblips'] = true,			['usersetting_display_createpnsblips'] = true,
		['usersetting_display_createammunationblips'] = true,	['usersetting_notification_joinquitmessages'] = true,
		['usersetting_notification_nickchangemessages'] = false,['usersetting_shader_skybox'] = false,
		['usersetting_shader_water'] = true,					['usersetting_shader_wetroad'] = false,
		['usersetting_shader_bloom'] = false,					['usersetting_shader_contrast'] = false,
		['usersetting_shader_vehiclereflections'] = true,		['usersettings_showmoneylogs'] = false,
		['usersetting_shader_roadshine'] = true,				['usersetting_shader_detail'] = false,
		['usersetting_display_clubblips'] = true,				['usersetting_display_skinshopblips'] = true,
		['usersetting_display_hospitalblips'] = true,			['usersetting_display_vehicleshopblips'] = true,
		['usersetting_misc_playsoundonguiclick'] = true,		['usersettings_display_clouds'] = false,
		['usersetting_display_usershopblips'] = true,			['usersettings_display_clienttoserverstats'] = true,
		['usersettings_display_lowfpswarning'] = true,			['usersetting_display_gymblips'] = true,
		["usersetting_display_modshopblips"] = true,			['usersetting_display_usedvehicleshopblips'] = false,
	}
}

local lastY = -15
local labelX = 10
for i, v in pairs ( UserSettings ) do
	lastY = lastY + 30
	pages['settings']['TitleLabel-'..tostring(i)] = guiCreateLabel ( labelX, lastY, 250, 20, tostring ( i ), false, s )
	guiSetFont ( pages['settings']['TitleLabel-'..tostring(i)], "default-bold-small" )
	for i2, v2 in ipairs ( v ) do
		lastY = lastY + 20
		pages['settings'][v2[1]] = guiCreateCheckBox ( labelX+15, lastY, 230, 20, tostring ( v2 [ 2 ] ), false, false, s )
	end
end

local lastY = lastY + 45
pages['settings'].btnSave = guiCreateButton ( 5, lastY+30, 250, 25, "Save", false, s )
pages['settings'].btnDefault_Looks = guiCreateButton ( 5, lastY, 80, 25, "Looks", false, s )
pages['settings'].btnDefault_Performance = guiCreateButton ( 90, lastY, 80, 25, "Performance", false, s )
pages['settings'].btnDefault_Mix = guiCreateButton ( 175, lastY, 80, 25, "Mix", false, s )
lastY = nil
labelX = nil


-- Stats
function createStatusLabel ( x, y, w, h, t, r, p, x2, w2, t2 )
	guiCreateLabel ( x, y, w, h, t, r, p )
	local t2 = t2 or "N/A"
	return guiCreateLabel ( x2, y, w2, h, t2, r, p )
end
pages['stats'] = { }
pages['stats'].scroll = guiCreateScrollPane ( 10, 10, 245, 400, false, background ) 
pages['stats'].lbl1 = guiCreateLabel ( 10, 15, 200, 20, "User Statistics", false, pages['stats'].scroll )
pages['stats']['user_account'] = createStatusLabel ( 20, 35, 230, 20, "Account:", false, pages['stats'].scroll, 100, 150 )
pages['stats']['user_serial'] = createStatusLabel ( 20, 55, 230, 20, "Serial:", false, pages['stats'].scroll, 100, 150 )
pages['stats']['user_ip'] = createStatusLabel ( 20, 75, 230, 20, "IP:", false, pages['stats'].scroll, 100, 150 )
pages['stats']['user_kills'] = createStatusLabel ( 20, 95, 230, 20, "Kills:", false, pages['stats'].scroll, 100, 150 )
pages['stats']['user_deaths'] = createStatusLabel ( 20, 115, 230, 20, "Deaths:", false, pages['stats'].scroll, 100, 150 )
pages['stats'].lbl2 = guiCreateLabel ( 10, 155, 200, 20, "Weapon Statistics", false, pages['stats'].scroll )
pages['stats']['weapon_9mm'] = createStatusLabel ( 20, 175, 230, 20, "9MM:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_silenced'] = createStatusLabel ( 20, 195, 230, 20, "Silenced:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_deagle'] = createStatusLabel ( 20, 215, 230, 20, "Deagle:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_shotgun'] = createStatusLabel ( 20, 235, 230, 20, "Shotgun:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_combatshotgun'] = createStatusLabel ( 20, 255, 230, 20, "Combat Shotgun:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_micro_smg'] = createStatusLabel ( 20, 275, 230, 20, "Micro SMG/Tec-9:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_mp5'] = createStatusLabel ( 20, 295, 230, 20, "MP5:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_ak47'] = createStatusLabel ( 20, 315, 230, 20, "AK47:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_m4'] = createStatusLabel ( 20, 335, 230, 20, "M4:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats']['weapon_sniper_rifle'] = createStatusLabel ( 20, 355, 230, 20, "Sniper Rifle:", false, pages['stats'].scroll, 130, 85, "0/100" )
pages['stats'].lbl3 = guiCreateLabel ( 10, 395, 200, 20, "Server Statistics", false, pages['stats'].scroll )
pages['stats']['server_mathEquation'] = createStatusLabel ( 20, 415, 230, 20, "Math Equation: ", false, pages['stats'].scroll, 130, 85 )
pages['stats']['server_currentEvent'] = createStatusLabel ( 20, 435, 230, 20, "Current Event: ", false, pages['stats'].scroll, 130, 85 )
pages['stats'].lbl4 = guiCreateLabel ( 10, 465, 200, 20, "VIP Statistics", false, pages['stats'].scroll )
pages['stats']['vip_vip'] = createStatusLabel ( 20, 485, 230, 20, "VIP: ", false, pages['stats'].scroll, 130, 85 )
pages['stats']['vip_expDate'] = createStatusLabel ( 20, 505, 230, 20, "VIP Exp. Date: ", false, pages['stats'].scroll, 130, 85 )
pages['stats']['server_netvippayout'] = createStatusLabel ( 20, 525, 230, 20, "Next VIP Payout: ", false, pages['stats'].scroll, 130, 85 )
guiSetFont ( pages['stats'].lbl1, "default-bold-small" )
guiSetFont ( pages['stats'].lbl2, "default-bold-small" )
guiSetFont ( pages['stats'].lbl3, "default-bold-small" )
guiSetFont ( pages['stats'].lbl4, "default-bold-small" )

-- flappy bird
pages['flappy'] = { }
pages['flappy'].lbl =  guiCreateLabel ( 10, 155, 200, 20, " ", false, background )

-- 2048
pages['_2048'] = { }
pages['_2048'].newGameButton = guiCreateButton(10, 322, 100, 30, "New Game", false, background)
pages['_2048'].closeButton = guiCreateButton(120, 540, 100, 50, "Close", false, background)
pages['_2048'].scoreLabel = guiCreateLabel(10, 362, 80, 50, "Score: 0", false, background)
pages['_2048'].gameState = guiCreateLabel(100, 250, 400, 200, "", false, background)
guiSetProperty(pages['_2048'].gameState,"AlwaysOnTop","true")
guiSetFont(pages['_2048'].gameState,"sa-gothic")
pages['_2048'].bg2048 = guiCreateStaticImage(0, 50, 262, 262, "images/2048/background.png", false, background)
pages['_2048'].dummyLabel = guiCreateLabel(30, 25, 80, 20, "2048", false, background)
guiSetFont(pages['_2048'].dummyLabel, "default-bold-small" )

for i, v in pairs ( pages['home'] ) do
	local w, h = guiGetSize ( v, false )
	local x, y = guiGetPosition ( v, false )
	local d = { pos = { x = x, y = y }, size = { w = w, h = h } }
	setElementData ( v, "NGPhone:Home:OriginalAppData", d )
end


function onPhoneRender ( )
	local x, y = guiGetPosition ( base, false )
	local now = getTickCount()
	if ( isOpen ) then
		local elapsedTime = now - open.startTime
		local duration = open.endTime - open.startTime
		local progress = elapsedTime / duration
		local sY, eY = open.startY, open.endY
		x, y, _ = interpolateBetween ( x, sy+10, 100, x, eY, 150,  progress, "OutBounce" )
		guiSetPosition ( base, x, y, false )
		if ( now >= open.endTime ) then
			open.allowClicking = true
		end
	else
		local elapsedTime = now - open.startTime
		local duration = open.endTime - open.startTime
		local progress = elapsedTime / duration
		local sY, eY = open.startY, open.endY
		x, y, _ = interpolateBetween ( x, eY, 100, x, sY, 150,  progress, "InBack" )
		guiSetPosition ( base, x, y, false )
		if ( now >= open.endTime ) then
			open.allowClicking = true
			isOpen = false
			guiSetVisible ( base, false )
			isRender = false
			showCursor ( false )
			if ( isElement( updateTimeTimer ) ) then
				killTimer ( updateTimeTimer )
			end
			removeEventHandler ( "onClientPreRender", root, onPhoneRender )
			removeEventHandler ( "onClientClick", root, clickingHandler )
			removeEventHandler ( "onClientGUIClick", root, clickingHandler2 )
			removeEventHandler ( "onClientGUIChanged", root, onClientGUIChanged )
		end
	end
	phone_x = x
	phone_y = y
	dxDrawFixedText ( "Nerd Gaming Mobile",  x, y+78, 350, 20, tocolor ( 255, 255, 255, 255 ), 1, "default-bold", "center", "top", false, false, true )
	Draw2048Images ( )
	if ( LoadedPage == "home" ) then
		local x1, y1 = guiGetPosition ( base, false )
		local x2, y2 = guiGetPosition ( background, false )
		local x1, y1 = x1 + x2, y2 + y1
		for i, v in pairs ( pages [ 'home' ]  ) do
			local org = getElementData ( v, "NGPhone:Home:OriginalAppData" )
			local a = guiGetAlpha ( v )
			if ( getElementData ( v, "isHoveringOnGUIElement" ) ) then
				guiSetSize ( v, appSize + 6, appSize + 6, false )
				guiSetPosition ( v, org.pos.x-3, org.pos.y-3, false )
				local x, y = guiGetPosition ( v, false )
				local w, h = guiGetSize ( v, false )
				dxDrawText ( getElementData ( v, "tooltip-text" ), x+x1+1, y+h+3+y1, x+w+x1, y+h+5+y1, tocolor ( 0, 0, 0, a * 255 ), 1, "default-bold", "center", "top", false, false, true )
				dxDrawText ( getElementData ( v, "tooltip-text" ), x+x1, y+h+2+y1, x+w+x1, y+h+4+y1, tocolor ( 255, 255, 255, a * 255 ), 1, "default-bold", "center", "top", false, false, true )
				if ( a ~= 1 ) then
					a = a + 0.008
					if ( a > 1 ) then
						a = 1
					end
				end
			else
				guiSetSize ( v, org.size.w, org.size.h, false )
				guiSetPosition ( v, org.pos.x, org.pos.y, false )
				if ( a ~= 0.8 ) then
					a = a - 0.008
					if ( a < 0.8 ) then
						a = 0.8
					end
				end
			end
			guiSetAlpha ( v, a )
		end
	end
end

function clickingHandler ( s, b, x, y )
	if ( s == "left" and b == "up" ) then
		-- home page
		if ( x >= phone_x + 160 and x <= phone_x + 190 and y >= phone_y + 522 and y <= phone_y + 545 ) then
			if ( LoadedPage ~= "home" ) then
				setPhonePageOpen ( "home" )
			else
				setPhoneOpen ( false )
			end
		elseif ( x >= phone_x + 75 and x <= phone_x + 105 and y >= phone_y + 523 and y <= phone_y + 548 ) then
			setPhoneOpen ( false )
		end
	end
end

function clickingHandler2 ( b, s )
	if ( b ~= "left"  or s ~= "up" ) then
		return
	end
	if ( LoadedPage == "home" ) then
	
		
		if ( source == pages['home'].base_sms ) then
			setPhonePageOpen ( 'sms' )
			guiSetText ( pages['sms'].search, "Search..." )
			guiGridListClear ( pages['sms'].grid )
			for i, v in ipairs ( getElementsByType ( "player" ) ) do
				if ( v ~= localPlayer ) then
					local r = guiGridListAddRow ( pages['sms'].grid )
					guiGridListSetItemText ( pages['sms'].grid, r, 1, tostring ( getPlayerName ( v ) ), false, false )
				end
			end
		elseif ( source == pages['home'].base_bank ) then
			setPhonePageOpen ( "bank" )
			appFunctions.bank:onPanelLoad ( )
		elseif ( source == pages['home'].base_music ) then
			setPhonePageOpen ( 'music' )
			guiGridListClear ( pages['music'].grid )
			for i, v in ipairs ( getRadioStations ( ) ) do 
				local name, url = unpack ( v )
				local row = guiGridListAddRow ( pages['music'].grid )
				guiGridListSetItemText ( pages['music'].grid, row, 1, name, false, false )
				guiGridListSetItemText ( pages['music'].grid, row, 2, url, false, false )
			end
		elseif ( source == pages['home'].base_notes ) then
			setPhonePageOpen ( 'notes' )
		elseif ( source == pages['home'].base_money ) then
			setPhonePageOpen ( "money" )
			guiSetText ( pages['money'].search, "Search..." )
			guiGridListClear ( pages['money'].grid )
			for i, v in ipairs ( getElementsByType ( "player" ) ) do
				if ( v ~= localPlayer ) then
					local r = guiGridListAddRow ( pages['money'].grid )
					guiGridListSetItemText ( pages['money'].grid, r, 1, tostring ( getPlayerName ( v ) ), false, false )
				end
			end
		elseif ( source == pages['home'].base_waypoints ) then
			setPhonePageOpen ( "waypoints" )
			guiGridListClear ( pages['waypoints'].grid )
			appFunctions.waypoints:onPanelLoad ( )
		elseif ( source == pages['home'].base_vehicles ) then
			setPhonePageOpen ( "vehicles" )
			appFunctions.vehicles:onPanelLoad ( )
		elseif ( source == pages['home'].base_settings ) then
			setPhonePageOpen ( "settings" )
			appFunctions.settings:onSettingsLoad ( )
		elseif ( source == pages['home'].base_stats ) then
			setPhonePageOpen ( "stats" )
			appFunctions.stats:onPanelLoad ( )
		elseif ( source == pages['home'].base_flappy ) then
			setPhonePageOpen ( "flappy" )
			appFunctions.flappy:onPageOpen()
		elseif ( source == pages['home'].base_2048 ) then
			setPhonePageOpen ( "_2048" )
			appFunctions._2048:onPageOpen()
		end
		
		
		
	elseif ( LoadedPage == "sms" ) then
		if ( source == pages['sms'].search ) then
			local text = guiGetText ( source )
			if ( text == "Search..." ) then
				guiSetText ( source, "" )
			end
		elseif ( source == pages['sms'].message ) then
			if ( guiGetText ( source ) == "Message..." ) then
				guiSetText ( source, "" )
			end
		elseif ( source == pages['sms'].grid ) then
			local row, col = guiGridListGetSelectedItem ( source )
			guiSetText ( pages['sms'].messages, "" )
			pages['sms'].selectedPlayer = nil
			if ( row ~= -1 ) then
				local p = getPlayerFromName ( guiGridListGetItemText ( source, row, 1 ) )
				pages['sms'].selectedPlayer = p
				if ( isElement ( p ) ) then
					local recentMessages = pages['sms'].sMessages[p]
					if recentMessages then
						guiSetText ( pages['sms'].messages, recentMessages )
					else
						guiSetText ( pages['sms'].messages, "No Recent Messages." )
					end
				else
					guiGridListRemoveRow ( source, row )
					exports['NGMessages']:sendClientMessage ( "Invalid player, removing now.", 0, 0, 150 )
				end
			end
		elseif ( source == pages['sms'].send ) then
			local row, col = guiGridListGetSelectedItem ( pages['sms'].grid )
			guiSetText ( pages['sms'].messages, "" )
			if ( row ~= -1 ) then
				local p = tostring ( guiGridListGetItemText ( pages['sms'].grid, row, 1 ) )
				if ( isElement ( getPlayerFromName ( p ) ) ) then
					local message = tostring ( guiGetText ( pages['sms'].message ) )
					local fromName = getPlayerFromName ( p )
					if ( message:gsub ( ' ', '' ) ~= "" and message ~= "Message..." ) then
						local second, minute, hour = getThisTime ( )
						local message2 = "["..table.concat({hour,minute,second},":").."] To: "..message
						if ( not pages['sms'].sMessages[fromName] ) then
							pages['sms'].sMessages[fromName] = ""
						end
						pages['sms'].sMessages[fromName] = pages['sms'].sMessages[fromName] .. message2 .. "\n"
						guiSetText ( pages['sms'].message, "Message..." )
						guiSetText ( pages['sms'].messages, pages['sms'].sMessages[fromName] )
						triggerServerEvent ( "NGPhone:App.SMS:SendPlayerMessage", localPlayer, fromName, message )
					else
						exports['NGMessages']:sendClientMessage ( "Invalid message.", 0, 150, 150 )
						guiSetText ( pages['sms'].messages, pages['sms'].sMessages[fromName] )
					end
				else
					guiGridListRemoveRow ( pages['sms'].grid, row )
					exports['NGMessages']:sendClientMessage ( "Invalid player, removing now.", 0, 150, 150 )
				end
			else
				exports['NGMessages']:sendClientMessage ( "No player selected.", 0, 150, 150 )
			end
		else
			if ( guiGetText ( pages['sms'].search ) == "" ) then
				guiSetText ( pages['sms'].search, "Search..." )
			end if ( guiGetText ( pages['sms'].message ) == "" ) then
				guiSetText ( pages['sms'].message, "Message..." )
			end
		end
	elseif ( LoadedPage == "music" ) then
		if ( source == pages['music'].add ) then
			local name = tostring ( guiGetText ( pages['music'].add_name ) )
			local url = tostring ( guiGetText ( pages['music'].add_url ) )
			if ( name:gsub(" ", "" ) == "" or url:gsub(" ","" ) == "" ) then
				return exports['NGMessages']:sendClientMessage ( "You need to fill out all the information.", 200, 200, 200 )
			end
			local scroll = guiGridListGetVerticalScrollPosition ( pages['music'].grid )
			addRadioStation ( name, url )
			exports['NGMessages']:sendClientMessage ( "Adding radio station "..name.." -> "..url, 200, 255, 200 )
			
			guiGridListClear ( pages['music'].grid )
			for i, v in ipairs ( getRadioStations ( ) ) do 
				local name2, url2 = unpack ( v )
				local row = guiGridListAddRow ( pages['music'].grid )
				guiGridListSetItemText ( pages['music'].grid, row, 1, name2, false, false )
				guiGridListSetItemText ( pages['music'].grid, row, 2, url2, false, false )
				if ( name2 == name and url2 == url ) then
					guiGridListSetSelectedItem ( pages['music'].grid, row, 1 )
				end
			end
			guiGridListSetVerticalScrollPosition ( pages['music'].grid, scroll )
		elseif ( source == pages['music'].delete ) then
			local row, col = guiGridListGetSelectedItem ( pages['music'].grid )
			if ( row ~= -1 ) then
				local scroll = guiGridListGetVerticalScrollPosition ( pages['music'].grid )
				local name = guiGridListGetItemText ( pages['music'].grid, row, 1 )
				local url = guiGridListGetItemText ( pages['music'].grid, row, 2 )
				removeRadioStation ( name, url )
				guiGridListClear ( pages['music'].grid )
				for i, v in ipairs ( getRadioStations ( ) ) do 
					local name2, url2 = unpack ( v )
					local row = guiGridListAddRow ( pages['music'].grid )
					guiGridListSetItemText ( pages['music'].grid, row, 1, name2, false, false )
					guiGridListSetItemText ( pages['music'].grid, row, 2, url2, false, false )
				end
				guiGridListSetVerticalScrollPosition ( pages['music'].grid, scroll )
			else
				exports['NGMessages']:sendClientMessage ( "No station selected.", 255, 255, 0 )
			end
		elseif ( source == pages['music'].play ) then
			local row, col = guiGridListGetSelectedItem ( pages['music'].grid )
			if ( row ~= -1 ) then
				if ( isElement ( pages['music'].sound ) ) then
					destroyElement ( pages['music'].sound )
				end
				pages['music'].sound = playSound ( guiGridListGetItemText ( pages['music'].grid, row, 2 ) )
				exports['NGMessages']:sendClientMessage ( "Now listening to "..guiGridListGetItemText ( pages['music'].grid, row, 1 ).." @ "..guiGridListGetItemText ( pages['music'].grid, row, 2 ), 0, 255, 0 )
			else
				exports['NGMessages']:sendClientMessage ( "No radio station is selected.", 255, 255, 255 )
			end
		elseif ( source == pages['music'].stop ) then
			if ( isElement ( pages['music'].sound ) ) then
				exports['NGMessages']:sendClientMessage ( "Stopping live stream radio.", 255, 255, 0 )
				destroyElement ( pages['music'].sound )
			else
				exports['NGMessages']:sendClientMessage ( "You're not listening to a radio station.", 255, 0, 0 )
			end
		end
	elseif ( LoadedPage == "money" ) then
		if ( source == pages['money'].search ) then
			if ( guiGetText ( source ) == "Search..." ) then
				guiSetText ( source, "" )
			end
		else
			if ( guiGetText ( pages['money'].search ) == "" ) then
				guiSetText ( pages['money'].search, "Search..." )
			end
		end
		
		if ( source == pages['money'].send ) then
			local row, col = guiGridListGetSelectedItem ( pages['money'].grid )
			if ( row == -1 ) then
				return exports['NGMessages']:sendClientMessage ( "No player selected.", 255, 255, 0 )
			end if ( guiGetText ( pages['money'].amount ) == "" ) then
				return exports['NGMessages']:sendClientMessage ( "No amount defined.", 255, 255, 0 )
			end
			local p = getPlayerFromName ( guiGridListGetItemText ( pages['money'].grid, row, 1 ) )
			if ( isElement ( p ) ) then
				local amount = tonumber ( guiGetText ( pages['money'].amount ) )
				triggerServerEvent ( "NGPhone:App.Money:sendPlayerMoney", localPlayer, p, amount )
			else
				exports['NGMessages']:sendClientMessage ( "Sorry, that play no longer exists.", 255, 255, 0 )
			end
		end
	elseif ( LoadedPage == "waypoints" ) then
		-- exports.NGPlayerFunctions:waypointUnlocate()
		-- appFunctions.waypoints:onPanelLoad ( ) 
	
		if ( source == pages['waypoints'].grid ) then
			
			local row, col = guiGridListGetSelectedItem ( source );
			local text = nil;
			
			if ( row == -1 and exports.ngplayerfunctions:waypointIsTracking( ) ) then 
				exports.ngmessages:sendClientMessage ( "Un-locating current target!" );
				exports.NGPlayerFunctions:waypointUnlocate( );
			end 
			
			if ( row > -1 ) then 
				text = guiGridListGetItemText ( source, row, 1 );
			end 
			
			if ( WaypointPage == "main" ) then 
				if ( WayPointLocs [ text ] ) then 
					guiGridListClear ( source )
					
					guiGridListSetItemText ( source, guiGridListAddRow ( source ), 1, "<< Back <<", false, false  );
					guiGridListSetItemText ( source, guiGridListAddRow ( source ), 1, "", true, true  );
					
					WaypointPage = text;
					if ( WaypointPage == "Locations" ) then 
						for location, data in pairs ( WayPointLocs [ 'Locations' ] ) do 
							guiGridListSetItemText ( source, guiGridListAddRow ( source ), 1, tostring ( location ), true, true  );
							for index, _data in ipairs ( data ) do 
								local row = guiGridListAddRow ( source );
								guiGridListSetItemText ( source, row, 1, tostring ( _data [ 1 ] ), false, false );
								guiGridListSetItemData ( source, row, 1, table.concat({_data[2], _data[3], _data[4]},"," ) );
							end 
						end 
					else
						for index, _data in ipairs ( WayPointLocs [ text ] ) do 
							local row = guiGridListAddRow ( source );
							guiGridListSetItemText ( source, row, 1, tostring ( _data [ 1 ] ), false, false );
							guiGridListSetItemData ( source, row, 1, table.concat({_data[2], _data[3], _data[4]},"," ) );
						end 
					end 
					
				end 
			end 
			
			if ( text == "<< Back <<" ) then 
				guiGridListClear ( source );
				appFunctions.waypoints:onPanelLoad ( );
				WaypointPage = "main";
			elseif ( guiGridListGetItemData ( source, row, 1 ) ) then 
				local pos = split ( guiGridListGetItemData ( source, row, 1 ), "," );
				if ( #pos == 3 ) then 
					if ( WaypointPage ~= "Players" ) then
						local x, y, z = tonumber(pos[1]), tonumber(pos[2]), tonumber(pos[3])
						if ( exports.ngplayerfunctions:createWaypointLoc ( x, y, z ) ) then
							exports.ngmessages:sendClientMessage( "Now tracking '"..tostring(guiGridListGetItemText(source,row,1)).."'", 255, 255, 0 );
						end
					else 
						if ( getPlayerFromName ( text ) ) then
							if ( exports.ngplayerfunctions:createWaypointLoc ( 0, 0, 0 ) and exports.ngplayerfunctions:setWaypointAttachedToElement ( getPlayerFromName ( text ) ) ) then
								exports.ngmessages:sendClientMessage( "Now tracking "..tostring(text), 255, 255, 0 );
							else 
								exports.ngmessages:sendClientMessage ( "Unable to track this player!", 200, 60, 60 );
							end
						else 
							exports.ngmessages:sendClientMessage ( "Sorry, that player has changed their name or has disconnected", 200, 60, 60 );
						end 
					end 
				end 
			end 
			
			
		elseif ( source == pages['waypoints'].add ) then
			appFunctions.waypoints:addWaypoint ( )
		end
	elseif ( LoadedPage == "vehicles" ) then
		if ( source == pages['vehicles'].grid ) then
			local row, col = guiGridListGetSelectedItem ( pages['vehicles'].grid )
			if ( row ~= -1 ) then
				guiSetEnabled ( pages['vehicles'].show, true )
				guiSetEnabled ( pages['vehicles'].recover, true )
				guiSetEnabled ( pages['vehicles'].sell, true )
				local index = guiGridListGetItemData ( source, row, 1 )
				local visible = tonumber ( vehicleData[index][9] )
				if ( visible == 1 ) then visible = true else visible = false end
				if ( visible ) then
					guiSetText ( pages['vehicles'].show, "Hide" )
					vehicleData[index][9] = 1
					guiSetEnabled ( pages['vehicles'].warptome, exports.NGVIP:getVipLevelFromName ( getElementData ( localPlayer, "VIP" ) ) >= 3 )
				else
					guiSetText ( pages['vehicles'].show, "Show" )
					vehicleData[index][9] = 0
					guiSetEnabled ( pages['vehicles'].warptome, false )
				end
			else
				guiSetEnabled ( pages['vehicles'].show, false )
				guiSetEnabled ( pages['vehicles'].recover, false )
				guiSetEnabled ( pages['vehicles'].sell, false )
				guiSetEnabled ( pages['vehicles'].warptome, false )
				guiSetText ( pages['vehicles'].show, "Show" )
			end
		elseif ( source == pages['vehicles'].show ) then
			local row, col = guiGridListGetSelectedItem ( pages['vehicles'].grid )
			if ( row ~= -1 ) then
				local index = guiGridListGetItemData ( pages['vehicles'].grid, row, 1 )
				local visible = tonumber ( vehicleData[index][9] )
				if ( visible == 1 ) then visible = true else visible = false end
				triggerServerEvent ( "NGPhone:Apps->Vehicles:SetVehicleVisible", localPlayer, vehicleData[index][2], not visible )
				if visible then
					guiSetText ( source, "Show" )
					vehicleData[index][9] = 0
					guiSetEnabled ( pages['vehicles'].warptome, false )
				else
					guiSetText ( source, "Hide" )
					vehicleData[index][9] = 1
					guiSetEnabled ( pages['vehicles'].warptome, exports.NGVIP:getVipLevelFromName ( getElementData ( localPlayer, "VIP" ) ) >= 3 )
				end
			end
		elseif ( source == pages['vehicles'].warptome ) then
			local row, col = guiGridListGetSelectedItem ( pages['vehicles'].grid )
			if ( row ~= -1 ) then
				
				if ( isPedInVehicle ( localPlayer ) ) then
					return exports.NGMessages:sendClientMessage ( "You cannot warp your vehicle to you, because you're currently in a vehicle.", 255, 0, 0 )
				elseif ( getElementInterior ( localPlayer ) ~= 0 or getElementDimension ( localPlayer ) ~= 0 ) then
					return exports.NGMessages:sendClientMessage ( "You must be outside, and in dimension 0 to warp your vehicle to you.", 255, 255, 0 )
				end
			
				local index = guiGridListGetItemData ( pages['vehicles'].grid, row, 1 )
				if ( vehicleData[index][9] == 1 ) then
					if ( vehicleData[index][11] == 1 ) then
						return exports.NGMessages:sendClientMessage ( "This vehicle is impounded, you cannot warp it to you.", 255, 255, 0 )
					end
					triggerServerEvent ( "NGPhone:Apps->Vehicles:WarpThisVehicleToMe", localPlayer, vehicleData[index][2] )
				end
			end
		elseif ( source == pages['vehicles'].sell ) then
			local row, col = guiGridListGetSelectedItem ( pages['vehicles'].grid )
			if ( row ~= -1 ) then
				local index = guiGridListGetItemData ( pages['vehicles'].grid, row, 1 )
				local visible = tonumber ( vehicleData[index][9] )
				if ( visible == 1 ) then visible = true else visible = false end
				if ( visible ) then
					return exports['NGMessages']:sendClientMessage ( "Hide your vehicle before you sell it.", 255, 255, 0 )
				end
				askConfirm ( "Are sure you would like to sell this vehicle?", function ( c, index )
					if not c then return end
					triggerServerEvent ( "NGPhone:App->Vehicles:sellPlayerVehicle", localPlayer, localPlayer, index )
					setTimer ( function() appFunctions.vehicles:ReloadList() end, 200, 1 )
				end, index )
			end
		elseif ( source == pages['vehicles'].give ) then
			local row, col = guiGridListGetSelectedItem ( pages['vehicles'].grid )
			if ( row ~= -1 ) then
				local index = guiGridListGetItemData ( pages['vehicles'].grid, row, 1 )
				local visible = tonumber ( vehicleData[index][9] )
				if ( visible == 1 ) then visible = true else visible = false end
				if ( visible ) then
					return exports['NGMessages']:sendClientMessage ( "Please hide the vehicle to send it.", 255, 0, 0 )
				end
				local vehID = vehicleData[index][2]
				if ( vehID ) then
				
					guiSetVisible ( GiveWindow, true )
					guiBringToFront ( GiveWindow ) 
					guiGridListClear ( gridGive )
					givingVehicle = index
					local count = 0
					for i, v in ipairs ( getElementsByType ( 'player' ) ) do
						if ( v ~= localPlayer ) then
							guiGridListSetItemText ( gridGive, guiGridListAddRow ( gridGive ), 1, getPlayerName ( v ), false, false  )
							count = count + 1
						end
					end
					if ( count == 0 ) then
						guiGridListSetItemText ( gridGive, guiGridListAddRow ( gridGive ), 1, "Sorry, there are currently no players online.", true, true  )
					end
				end
			end
		elseif ( source == btnGiveCancel ) then
			guiSetVisible ( GiveWindow, false )
		elseif ( source == btnGiveGive ) then 
			local row, col = guiGridListGetSelectedItem ( gridGive )
			if ( row ~= -1 ) then
				local pName = guiGridListGetItemText ( gridGive, row, 1 )
				if ( not isElement ( getPlayerFromName ( pName ) ) ) then return exports['NGMessages']:sendClientMessage ( "Sorry, that player  no longer exists.", 255, 0, 0 ) end
				
				if ( vehicleData[givingVehicle][9] == 1 ) then return exports['NGMessages']:sendClientMessage ( "Hide the vehicle to give it.", 255, 0, 0 ) end
				local vehicleID = vehicleData[givingVehicle][2]
				triggerServerEvent ( "NGVehicles:onPlayerGivePlayerVehicle", localPlayer, vehicleID, getPlayerFromName ( pName ) )
				guiSetVisible ( GiveWindow, false ) 
				setTimer ( appFunctions.vehicles:ReloadList ( ), 200, 1 )
			else
				exports['NGMessages']:sendClientMessage ( "Select a player to send your vehicle to.", 255, 0, 0 )
			end
		elseif ( source == pages['vehicles'].recover ) then
			local row, col = guiGridListGetSelectedItem ( pages['vehicles'].grid )
			if ( row == -1 ) then return end
			local data = vehicleData[guiGridListGetItemData ( pages['vehicles'].grid, row, 1 )]
			if ( data[9] == 1 ) then return exports['NGMessages']:sendClientMessage ( "To recover your vehicle, please hide it first.", 255, 0, 0 ) end
			triggerServerEvent ( "NGPhone:Apps->Vehicles:AttemptRecoveryOnID", localPlayer, data[2] )
		
		elseif ( source == pages['vehicles'].refresh ) then
			appFunctions.vehicles:ReloadList ( )
		end
	elseif ( LoadedPage == "settings" ) then
		if ( source == pages['settings'].btnSave ) then
			--outputConsole ( "==================================================");
			for i, v in pairs ( pages['settings'] ) do
				if ( doesSettingExist ( tostring ( i ) ) ) then
					local to = tostring ( guiCheckBoxGetSelected ( v ) )
					--outputConsole ( "SETTING UPDATE: "..tostring ( i ).." updated to "..tostring ( to ) )
					outputDebugString ( "SETTING UPDATE: "..tostring ( i ).." updated to "..tostring ( to ) )
					updateSetting ( i, to )
				end
			end
			--outputConsole ( "==================================================");
			exports.NGMessages:sendClientMessage ( "Client settings updated -- If something isn't displaying right, it's probably a shader issue.", 250, 120, 0 )
		elseif ( source == pages['settings'].btnDefault_Looks ) then
			for i, v in pairs ( SettingPreferences['looks'] ) do
				if ( isElement ( pages['settings'][i] ) ) then
					guiCheckBoxSetSelected ( pages['settings'][i], v )
				end
			end
		elseif ( source == pages['settings'].btnDefault_Performance ) then
			for i, v in pairs ( SettingPreferences['performance'] ) do
				if ( isElement ( pages['settings'][i] ) ) then
					guiCheckBoxSetSelected ( pages['settings'][i], v )
				end
			end
		elseif ( source == pages['settings'].btnDefault_Mix ) then
			for i, v in pairs ( SettingPreferences['mix'] ) do
				if ( isElement ( pages['settings'][i] ) ) then
					guiCheckBoxSetSelected ( pages['settings'][i], v )
				end
			end
		end
	end
end

function onClientGUIChanged ( )
	if ( LoadedPage == "sms" ) then
		if ( source == pages['sms'].search ) then
			local text = guiGetText ( source )
			if ( text ~= "Search..." ) then
				guiGridListClear ( pages['sms'].grid )
				for i, v in ipairs ( getElementsByType ( 'player' ) ) do
					local name = tostring ( getPlayerName ( v ) )
					if ( string.find ( string.lower ( name ), string.lower ( text ) ) and v ~= localPlayer ) then
						local row = guiGridListAddRow ( pages['sms'].grid )
						guiGridListSetItemText ( pages['sms'].grid, row, 1, name, false, false )
					end
				end
			end
		end
	elseif ( LoadedPage == "money" ) then
		if ( source == pages['money'].search ) then
			local text = guiGetText ( source )
			if ( text ~= "Search..." ) then
				guiGridListClear ( pages['money'].grid )
				for i, v in ipairs ( getElementsByType ( 'player' ) ) do
					local name = tostring ( getPlayerName ( v ) )
					if ( string.find ( string.lower ( name ), string.lower ( text ) ) and v ~= localPlayer ) then
						local row = guiGridListAddRow ( pages['money'].grid )
						guiGridListSetItemText ( pages['money'].grid, row, 1, name, false, false )
					end
				end
			end
		elseif ( source == pages['money'].amount ) then
			guiSetText ( source, guiGetText(source):gsub ( "%p", "" ) )
			guiSetText ( source, guiGetText(source):gsub ( "%s", "" ) )
			guiSetText ( source, guiGetText(source):gsub ( "%a", "" ) )
			local num = tonumber ( guiGetText ( source ) )
			if ( num and num > 5000000 ) then
				guiSetText ( source, "5000000" )
			end
		end
	end
end

function getThisTime ( )
	local time = getRealTime ( )
	local s = time.second
	local m = time.minute
	local h = time.hour
	if ( s < 10 ) then s = "0"..s end
	if ( m < 10 ) then m = "0"..m end
	if ( h < 10 ) then h = "0"..h end
	return s, m, h
end


function setPhonePageOpen ( page )
	LoadedPage = page
	guiSetInputMode ( "no_binds_when_editing" )
	for i, v in pairs ( pages ) do
		for k, e in pairs ( v ) do
			if ( isGUIElement ( e ) ) then
				guiSetVisible ( e, false )
			end
		end
	end
	for i, v  in pairs ( pages[page] ) do
		if ( isGUIElement ( v ) ) then
			guiSetVisible ( v, true )
		end
	end
	if ( page ~= "flappy" and flappy ) then
		flappyBirdGame:Destructor();
		flappy = false
	end
end

function setPhoneOpen ( bool )
	if ( not exports['NGLogin']:isClientLoggedin ( ) or not open.allowClicking ) then
		return
	end
	showCursor ( bool )
	open.startTime = getTickCount ( )
	open.endTime = getTickCount ( ) + 2000
	open.allowClicking = false
	if bool and not isOpen then
		isOpen = true
		if not isRender then
			isRender = true
			guiSetVisible ( base, true )
			updateTimeTimer()
			updateTimeTimerPhone = setTimer ( updateTimeTimer, 1000, 0 )
			setPhonePageOpen ( LoadedPage or "home" )
			addEventHandler ( "onClientPreRender", root, onPhoneRender )
			addEventHandler ( "onClientClick", root, clickingHandler )
			addEventHandler ( "onClientGUIClick", root, clickingHandler2 )
			addEventHandler ( "onClientGUIChanged", root, onClientGUIChanged )
		end
	elseif not bool and isOpen then
		isOpen = false
		if ( isTimer ( updateTimeTimerPhone ) ) then
			killTimer ( updateTimeTimerPhone )
		end
	end
	
	updateSetting ( "notes", tostring ( guiGetText ( pages['notes'].notes ) ) )
end

bindKey ( "F3", "down", function ( )
	
	if ( not exports.NGLogin:isClientLoggedin ( ) ) then return end

	guiSetText ( pages['notes'].notes, tostring ( getSetting ( "notes" ) ) )
	setPhoneOpen ( not isOpen )
	if isOpen then
		if not LoadedPage then
			setPhonePageOpen ( 'home' )
		elseif ( LoadedPage == "stats" ) then
			appFunctions.stats:onPanelLoad ( )
		end
	end
end )

function dxDrawFixedText ( text, x, y, w, h, c, scale, font, ax, ay, clip, wordBreak, postGUI )
	local c =c or tocolor ( 255, 255, 255, 255 )
	local scale = scale or 1
	local font = font or "default"
	local ax = ax or "left"
	local ay = ay or "top"
	local clip = clip or false
	local wordBreak = wordBreak or false
	local postGUI = postGUI or false
	return dxDrawText ( text, x, y, x+w, y+h, c, scale, font, ax, ay, clip, wordBreak, postGUI )
end

function isGUIElement ( element )
	if ( element and isElement ( element ) ) then
		local t = tostring ( getElementType ( element ) )
		if ( string.sub ( t, 1, 4 ) == "gui-" ) then
			return true
		end
	end
	return false
end






----------------------------------------------------------
-- Confirmation WIndow									--
----------------------------------------------------------
local confirmWindowArgs = { } 
local confirm = {}
confirm.window = guiCreateWindow( ( sx / 2 - 324 / 2 ), ( sy / 2 - 143 /2 ), 324, 143, "Confirm", false)
confirm.text = guiCreateLabel(10, 35, 304, 65, "", false, confirm.window)
guiSetVisible ( confirm.window, false )
guiSetFont(confirm.text, "default-bold-small")
guiLabelSetHorizontalAlign(confirm.text, "left", true)
guiWindowSetSizable ( confirm.window, false )
confirm.yes = guiCreateButton(10, 100, 108, 25, "Confirm", false, confirm.window)
confirm.no = guiCreateButton(128, 100, 108, 25, "Deny", false, confirm.window)

function onConfirmClick( ) 
	if ( source ~= confirm.yes and source ~= confirm.no ) then return end
	
	removeEventHandler ( "onClientGUIClick", root, onConfirmClick )
	guiSetVisible ( confirm.window, false )
	local v = false
	if ( source == confirm.yes ) then
		v = true
	end
	confirmWindowArgs.callback ( v, unpack ( confirmWindowArgs.args ) )
	confirmWindowArgs.args = nil
	confirmWindowArgs.callback = nil
end

function askConfirm ( question, callback_, ... )
	if ( not callback_ or type ( callback_ ) ~= "function" ) then
		return false
	end
	
	guiSetVisible ( confirm.window, true )
	guiSetText ( confirm.text, tostring ( question ) )
	confirmWindowArgs.callback = callback_
	confirmWindowArgs.args = { ... }
	addEventHandler ( "onClientGUIClick", root, onConfirmClick )
	guiBringToFront ( confirm.window )
	return true
end

